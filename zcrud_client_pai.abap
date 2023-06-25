*----------------------------------------------------------------------*
***INCLUDE ZCRUD_CLIENT_PAI.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  CHECK sy-ucomm IS NOT INITIAL.

  IF gs_client-kunnr IS INITIAL.
    MESSAGE 'Informar N° Cliente' TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  CREATE OBJECT go_app
    EXPORTING
      i_kunnr = gs_client-kunnr.

  go_app->read_client( IMPORTING e_not_found = gv_not_found ).

  CASE sy-ucomm.
    WHEN 'CREATE'.
      IF gv_not_found IS NOT INITIAL.
        CLEAR gs_client.
        gs_client-kunnr = go_app->get_kunnr( ).
        CALL SCREEN 9001.
      ELSE.
        MESSAGE | Cliente { gs_client-kunnr } já cadastrado! | TYPE 'S' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

    WHEN 'READ'.
      IF gv_not_found IS INITIAL.
        CALL SCREEN 9002.
      ELSE.
        MESSAGE | Cliente { gs_client-kunnr } não cadastrado! | TYPE 'S' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

    WHEN 'UPDATE'.
      IF gv_not_found IS INITIAL.
        CALL SCREEN 9003.
      ELSE.
        MESSAGE | Cliente { gs_client-kunnr } não cadastrado! | TYPE 'S' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

    WHEN 'DELETE'.
      IF gv_not_found IS NOT INITIAL.
        MESSAGE | Cliente { gs_client-kunnr } não cadastrado! | TYPE 'S' DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
      go_app->delete_client( ).

  ENDCASE.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  CASE sy-ucomm.
    WHEN 'SAVE'.
      go_app->create_client( ).

    WHEN 'BACK'.
      CALL SCREEN 9000.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  CASE sy-ucomm.
    WHEN 'UPDATE'.
      CALL SCREEN 9003.

    WHEN 'BACK'.
      CALL SCREEN 9000.

  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9003 INPUT.

  CASE sy-ucomm.
    WHEN 'SAVE'.
      go_app->update_client( ).

    WHEN 'BACK'.
      CALL SCREEN 9000.
  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  EXIT_USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE exit_user_command_9000 INPUT.

  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE PROGRAM.
  ENDCASE.

ENDMODULE.