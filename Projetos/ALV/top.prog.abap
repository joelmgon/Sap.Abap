*&---------------------------------------------------------------------*
*&  Include           ZPACP_ALV2_TOP
*&---------------------------------------------------------------------*
TABLES: spfli.

DATA: it_spfli TYPE TABLE OF spfli,
      wa_spfli TYPE spfli.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_layout   TYPE slis_layout_alv.

DATA alv TYPE REF TO cl_salv_table.

DATA: columns TYPE REF TO cl_salv_columns_table,
      column  TYPE REF TO cl_salv_column.

DATA: layout_settings TYPE REF TO cl_salv_layout,
      layout_key      TYPE salv_s_layout_key.

DATA functions TYPE REF TO cl_salv_functions_list.