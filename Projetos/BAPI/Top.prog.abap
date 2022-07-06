*&---------------------------------------------------------------------*
*&  Include           ZPACP_BAPI_TOP
*&---------------------------------------------------------------------*
*GLOBAL TABLES
DATA: gt_items        TYPE STANDARD TABLE OF bapiorders,
      gs_return       TYPE bapireturn,
      gt_fcatalog_tab TYPE slis_t_fieldcat_alv.

*GLOBAL STRUCTURE
DATA: gs_header       TYPE bapiekkol,
      gs_layout_a_str TYPE slis_layout_alv.

*EXCEPÇÃO
DATA: gx_msg TYPE REF TO cx_salv_msg.