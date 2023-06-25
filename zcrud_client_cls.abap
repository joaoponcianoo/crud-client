*&---------------------------------------------------------------------*
*& Include          ZCRUD_CLIENT_CLS
*&---------------------------------------------------------------------*

CLASS cl_application DEFINITION.

  PUBLIC SECTION.
    DATA: atr_client TYPE kunnr.

    METHODS:
      constructor IMPORTING i_kunnr TYPE kunnr,
      get_kunnr RETURNING VALUE(e_return) TYPE kunnr,

      create_client,
      read_client EXPORTING e_not_found TYPE c,
      update_client,
      delete_client.

ENDCLASS.

CLASS cl_application IMPLEMENTATION.

  METHOD constructor.
    atr_client = i_kunnr.
  ENDMETHOD.

  METHOD get_kunnr.
    e_return = atr_client.
  ENDMETHOD.

  METHOD create_client.

    gs_client-erdat = sy-datum.
    gs_client-erzet = sy-uzeit.

    INSERT ztclient_524 FROM gs_client.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      MESSAGE | Cliente { gs_client-kunnr } criado com sucesso! | TYPE 'S'.
      CALL SCREEN 9002.
    ENDIF.

  ENDMETHOD.

  METHOD read_client.

    CLEAR e_not_found.

    SELECT SINGLE *
      FROM ztclient_524
      INTO gs_client
     WHERE kunnr EQ gs_client-kunnr.

    IF sy-subrc NE 0.
      e_not_found = 'X'.
    ENDIF.

  ENDMETHOD.

  METHOD update_client.

    UPDATE ztclient_524 FROM gs_client.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
      MESSAGE 'Dados modificados com sucesso!' TYPE 'S'.
      CALL SCREEN 9002.
    ENDIF.

  ENDMETHOD.

  METHOD delete_client.

    DATA lv_return TYPE c.

    CALL FUNCTION 'POPUP_CONTINUE_YES_NO'
      EXPORTING
        defaultoption = 'N'
        textline1     = 'Confirmar ação?'
*       textline2     =
        titel         = | Deletar Cliente { gs_client-kunnr } |
        start_column  = 25
        start_row     = 6
      IMPORTING
        answer        = lv_return.

    IF lv_return EQ 'J'.
      DELETE FROM ztclient_524 WHERE kunnr EQ gs_client-kunnr.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        MESSAGE | Cliente { gs_client-kunnr } deletado com sucesso! | TYPE 'S'.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.