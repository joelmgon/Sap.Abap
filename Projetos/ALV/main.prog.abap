*&---------------------------------------------------------------------*
*& Report ZPACP_ALV_REPORT2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPACP_ALV_REPORT2.

INCLUDE zpacp_alv2_top.
INCLUDE zpacp_alv2_scr.
INCLUDE zpacp_alv2_form.

START-OF-SELECTION.

  PERFORM get_data.

END-OF-SELECTION.

  PERFORM prepare_lv.