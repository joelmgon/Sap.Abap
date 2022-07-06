*&---------------------------------------------------------------------*
*&  Include           ZJG_PRO_REQUESTS_VIS04_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.
  CASE OK_CODE_MODIFICAR.
    WHEN 'SALVAR'.
      DATA LS_LISTA LIKE LINE OF GT_LISTA .
      DATA LV_COUNT TYPE I.
      DATA: LV_UNIT_VALUE TYPE ZJG_UNV.


      LOOP AT GT_LISTA INTO LS_LISTA
        WHERE REQUEST_NR = GS_LINHA_MODIFICAR-REQUEST_NR AND
              PLATE_TYPE  = GS_LINHA_MODIFICAR-PLATE_TYPE.
        LV_COUNT = LV_COUNT + 1.
      ENDLOOP.


      IF LV_COUNT EQ 1.

        READ TABLE GT_LISTA
        WITH KEY REQUEST_NR    = GS_LINHA_MODIFICAR-REQUEST_NR
                 PLATE_TYPE  = GS_LINHA_MODIFICAR-PLATE_TYPE

*         REQUEST_VALUE = GS_LINHA_MODIFICAR-REQUEST_VALUE
        TRANSPORTING NO FIELDS.



        SELECT UNIT_VALUE UP TO 1 ROWS FROM ZJG_TDISHES
              INTO LV_UNIT_VALUE
              WHERE PLATE_TYPE = GS_LINHA_MODIFICAR-PLATE_TYPE.
        ENDSELECT.

        GS_LINHA_MODIFICAR-REQUEST_VALUE = GS_LINHA_MODIFICAR-QTY * LV_UNIT_VALUE.
        GS_LINHA_MODIFICAR-MANDT = SY-MANDT.

        MODIFY GT_LISTA FROM GS_LINHA_MODIFICAR INDEX SY-TABIX.
        MODIFY ZJG_TREQUEST FROM GS_LINHA_MODIFICAR.

        IF SY-SUBRC EQ 0.
          COMMIT WORK.
        ELSE.
          MESSAGE i009(ZJG_MSG).

        ENDIF.
        GO_APP->GET_DATA( ).
        GO_LISTA->REFRESH( REFRESH_MODE = IF_SALV_C_REFRESH=>FULL  ).

      ENDIF.


      LEAVE TO SCREEN 0.
    WHEN 'CANCELAR'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  DATA: LV_CREAT_UNIT_VALUE TYPE ZJG_UNV.

  CASE OK_CODE_CRIAR.
    WHEN 'SALVAR'.
      IF GS_LINHA_INSERIR-REQUEST_NR IS NOT INITIAL.

        READ TABLE GT_LISTA
        WITH KEY REQUEST_NR = GS_LINHA_INSERIR-REQUEST_NR
                 PLATE_TYPE = GS_LINHA_INSERIR-PLATE_TYPE

        TRANSPORTING NO FIELDS.

        SELECT UNIT_VALUE UP TO 1 ROWS FROM ZJG_TDISHES
             INTO LV_CREAT_UNIT_VALUE
             WHERE PLATE_TYPE = GS_LINHA_INSERIR-PLATE_TYPE.
        ENDSELECT.

        GS_LINHA_INSERIR-REQUEST_VALUE = GS_LINHA_INSERIR-QTY * LV_CREAT_UNIT_VALUE.
        GS_LINHA_INSERIR-REQUEST_DATE = SY-DATUM.
        GS_LINHA_INSERIR-REQUEST_HOUR = SY-UZEIT.
        GS_LINHA_INSERIR-MANDT = SY-MANDT.

        INSERT ZJG_TREQUEST FROM GS_LINHA_INSERIR.
        IF SY-SUBRC EQ 0.
          COMMIT WORK.
        ELSE.
          MESSAGE i008(ZJG_MSG).
        ENDIF.


        GO_APP->GET_DATA( ).
*        APPEND GS_LINHA_INSERIR TO GT_LISTA.
        GO_LISTA->REFRESH( REFRESH_MODE = IF_SALV_C_REFRESH=>FULL  ).

      ENDIF.


      LEAVE TO SCREEN 0.
    WHEN 'CANCELAR'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0900 INPUT.

  CASE GV_OK_CODE_900.
    WHEN 'EXIT'.
      LEAVE TO SCREEN 0.
    WHEN 'MODIF'.
      GO_APP->DO_PAI_SCREEN_900( ).

  ENDCASE.

ENDMODULE.