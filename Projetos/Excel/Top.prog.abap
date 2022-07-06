*&---------------------------------------------------------------------*
*&  Include           ZABAP_EXCEL_02_RP_TOP
*&---------------------------------------------------------------------*


*" Dados globais
TYPES: BEGIN OF lty_alv,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,

       END OF lty_alv.
TYPES: lty_alv_t TYPE TABLE OF lty_alv.


DATA:
  gt_alv TYPE lty_alv_t,
  gs_alv TYPE lty_alv.

DATA: gt_filetab TYPE filetable,
      gs_file    TYPE file_table,
      gv_rc      TYPE i.

DATA go_alv type ref to cl_salv_table.