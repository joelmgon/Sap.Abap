*&---------------------------------------------------------------------*
*&  Include           ZPACP_FORM
*&---------------------------------------------------------------------*


FORM prepare_fieldcatalog .


    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'MANDT'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 0.
  
    gv_fcat-coltext = 'MANDT'.
  
    gv_fcat-no_out = 'X'. " Do not Display Column
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'VBELN'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 1.
  
    gv_fcat-coltext = 'VBELN'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'ERDAT'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 2.
  
    gv_fcat-coltext = 'ERDAT'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'KUNNR'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 3.
  
    gv_fcat-coltext = 'KUNNR'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'POSNR'.
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 4.
  
    gv_fcat-coltext = 'POSNR'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'MATNR'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 5.
  
    gv_fcat-coltext = 'MATNR'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'ARKTX'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 6.
  
    gv_fcat-coltext = 'ARKTX'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'KWMENG'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 7.
  
    gv_fcat-coltext = 'KWMENG'.
  
    gv_fcat-edit = 'X'. " Makes field editable in Grid
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
    CLEAR gv_fcat.
  
    gv_fcat-fieldname = 'DESC_TEXT'.
  
    gv_fcat-tabname = 'VBAP'.
  
    gv_fcat-col_pos = 7.
  
    gv_fcat-coltext = 'DESC_TEXT'.
  
    gv_fcat-no_out = 'X'.
  
    INSERT gv_fcat INTO TABLE gs_fieldcatalog.
  
  
  ENDFORM. " U_PREPARE_FIELDCATALOG
  *&---------------------------------------------------------------------*
  *&      Form  GET_DATA
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM get_data .
  
    REFRESH: gt_vbak, gt_vbap, gt_item.
  
  
    " Define Range Criteria
  
  *  grs_vbeln-sign = 'I'.
  *
  *  grs_vbeln-option = 'BT'.
  *  grs_vbeln-low = '1'.
  *  grs_vbeln-high = '100'.
  *
  *  APPEND grs_vbeln TO gr_vbeln.
  
  
  *  CHECK gr_vbeln[] IS NOT INITIAL.
  
    SELECT mandt vbeln erdat kunnr
  
    FROM vbak INTO TABLE gt_vbak UP TO 100 ROWS.
  
  *   WHERE vbeln IN gr_vbeln.
  
  
    CHECK gt_vbak[] IS NOT INITIAL.
  
    SELECT vbeln posnr matnr arktx kwmeng
  
    FROM vbap INTO TABLE gt_vbap
  
    FOR ALL ENTRIES IN gt_vbak
  
    WHERE vbeln EQ gt_vbak-vbeln.
  
  
    IF gt_vbak[] IS NOT INITIAL.
  
  
      LOOP AT gt_vbap INTO gs_vbap.
  
  
        READ TABLE gt_vbak INTO gs_vbak WITH KEY vbeln = gs_vbap-vbeln.
  
  
        gs_item-mandt = gs_vbak-mandt.
  
        gs_item-vbeln = gs_vbak-vbeln.
  
        gs_item-erdat = gs_vbak-erdat.
  
        gs_item-kunnr = gs_vbak-kunnr.
  
        gs_item-posnr = gs_vbap-posnr.
  
        gs_item-matnr = gs_vbap-matnr.
  
        gs_item-arktx = gs_vbap-arktx.
  
        gs_item-kwmeng = gs_vbap-kwmeng.
  
  
        APPEND gs_item TO gt_item.
  
  
        CLEAR gs_item.
  
        CLEAR gs_vbak.
  
        CLEAR gs_vbap.
  
      ENDLOOP.
  
  
    ENDIF.
  
  
  
  ENDFORM.               "fcode_tc_mark_lines