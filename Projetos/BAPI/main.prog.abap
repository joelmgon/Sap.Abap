*&---------------------------------------------------------------------*
*& Report ZPACP_BAPI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPACP_BAPI.

INCLUDE ZPACP_BAPI_TOP.
INCLUDE ZPACP_BAPI_SCREEN.
INCLUDE ZPACP_BAPI_FORM.

START-OF-SELECTION.

*Obter os dados a apresentar
PERFORM get_data.

IF GS_RETURN IS INITIAL.
*Preparar o formato dos campos a apresentar na ALV.
  PERFORM build_fieldcatalog.
*Preparar o layout da ALV
  PERFORM build_layout CHANGING gs_layout_a_str.
*Mostrar a ALV
  PERFORM display_alv_report.
  PERFORM data_display.

ENDIF.
End-of-SELECTION.