*&---------------------------------------------------------------------*
*&  Include           ZPACP_INTERFACE_TOP
*&---------------------------------------------------------------------*

DATA :
  gr_vbeln  TYPE RANGE OF vbak-vbeln,
  grs_vbeln LIKE LINE OF gr_vbeln.


DATA:
  gs_fieldcatalog TYPE lvc_s_fcat OCCURS 0,
  gv_fcat         LIKE LINE OF gs_fieldcatalog,
  gs_layout       TYPE lvc_s_layo.


TYPES :

  BEGIN OF gty_item,
    mandt  LIKE vbak-mandt,
    vbeln  LIKE vbak-vbeln,
    erdat  LIKE vbak-erdat,
    kunnr  LIKE vbak-kunnr,
    posnr  LIKE vbap-posnr,
    matnr  LIKE vbap-matnr,
    arktx  LIKE vbap-arktx,
    kwmeng LIKE vbap-kwmeng,
*    desc_text LIKE vbap-desc_text,

  END OF gty_item,

  BEGIN OF gty_vbak,
    mandt LIKE vbak-mandt,
    vbeln LIKE vbak-vbeln,
    erdat LIKE vbak-erdat,
    kunnr LIKE vbak-kunnr,

  END OF gty_vbak,

  BEGIN OF gty_vbap,
    vbeln  LIKE vbap-vbeln,
    posnr  LIKE vbap-posnr,
    matnr  LIKE vbap-matnr,
    arktx  LIKE vbap-arktx,
    kwmeng LIKE vbap-kwmeng,
  END OF gty_vbap.


DATA :
  gs_item TYPE gty_item,
  gt_item TYPE TABLE OF gty_item.


DATA :
  gs_vbak TYPE gty_vbak,
  gt_vbak TYPE TABLE OF gty_vbak,
  gs_vbap TYPE gty_vbap,
  gt_vbap TYPE TABLE OF gty_vbap.


DATA :
  g_container        TYPE scrfname VALUE 'CONTAINER1',
  g_custom_container TYPE REF TO cl_gui_custom_container,
  g_grid             TYPE REF TO cl_gui_alv_grid.

DATA: g_container2        TYPE scrfname VALUE 'CONTAINER2',
      g_custom_container2 TYPE REF TO cl_gui_custom_container,
      g_grid2             TYPE REF TO cl_gui_alv_grid.


DATA :
  ok_code LIKE sy-ucomm,
  save_ok LIKE sy-ucomm.