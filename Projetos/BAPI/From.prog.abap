*&---------------------------------------------------------------------*
*&  Include           ZPACP_BAPI_FORM
*&---------------------------------------------------------------------*

FORM get_data .
    DATA:lv_kunnr TYPE kunnr,
         lv_vkorg TYPE vkorg.
  
    lv_kunnr = p_kunnr.
    lv_vkorg = p_vkorg.
  
    IF lv_kunnr IS NOT INITIAL.
  
      CALL FUNCTION 'BAPI_SALESORDER_GETLIST'
        EXPORTING
          customer_number    = p_kunnr
          sales_organization = p_vkorg
  *       MATERIAL           =
  *       DOCUMENT_DATE      =
  *       DOCUMENT_DATE_TO   =
  *       PURCHASE_ORDER     =
  *       TRANSACTION_GROUP  = 0
  *       PURCHASE_ORDER_NUMBER       =
  *       MATERIAL_EVG       =
  *       MATERIAL_LONG      =
        IMPORTING
          return             = gs_return
        TABLES
          sales_orders       = gt_items
  *       EXTENSIONIN        =
  *       EXTENSIONEX        =
        .
  
  
    ENDIF.
    IF gs_return IS NOT INITIAL.
      MESSAGE 'Erro a apresentar os dados' TYPE 'I' DISPLAY LIKE 'E'.
      EXIT.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  BUILD_FIELDCATALOG
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM build_fieldcatalog .
  
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
  *     I_PROGRAM_NAME         =
  *     I_INTERNAL_TABNAME     =
        i_structure_name       = 'BAPIORDERS'
  *     I_CLIENT_NEVER_DISPLAY = 'X'
  *     I_INCLNAME             =
  *     I_BYPASSING_BUFFER     =
  *     I_BUFFER_ACTIVE        =
      CHANGING
        ct_fieldcat            = gt_fcatalog_tab
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
      LOOP AT gt_fcatalog_tab ASSIGNING FIELD-SYMBOL(<fs>).
        CASE <fs>-fieldname.
          WHEN 'MANDT'.
            <fs>-tech = abap_true.
            <fs>-no_out = abap_true.
          WHEN 'SD_DOC'.
            <fs>-hotspot = abap_true.
        ENDCASE.
  
      ENDLOOP.
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  BUILD_LAYOUT
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *      <--P_GS_LAYOUT_A_STR  text
  *----------------------------------------------------------------------*
  FORM build_layout  CHANGING ps_layout_a_str TYPE slis_layout_alv.
    ps_layout_a_str-no_input = abap_true.
    ps_layout_a_str-colwidth_optimize = abap_true.
    ps_layout_a_str-zebra = abap_true.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  DISPLAY_ALV_REPORT
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM display_alv_report .
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
  *     I_INTERFACE_CHECK        = ' '
  *     I_BYPASSING_BUFFER       = ' '
  *     I_BUFFER_ACTIVE          = ' '
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'STATUS '
        i_callback_user_command  = 'USER_COMMAND '
  *     I_CALLBACK_TOP_OF_PAGE   = ' '
  *     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
  *     I_CALLBACK_HTML_END_OF_LIST       = ' '
  *     I_STRUCTURE_NAME         =
  *     I_BACKGROUND_ID          = ' '
  *     I_GRID_TITLE             =
  *     I_GRID_SETTINGS          =
        is_layout                = gs_layout_a_str
        it_fieldcat              = gt_fcatalog_tab
  *     IT_EXCLUDING             =
  *     IT_SPECIAL_GROUPS        =
  *     IT_SORT                  =
  *     IT_FILTER                =
  *     IS_SEL_HIDE              =
  *     I_DEFAULT                = 'X'
        i_save                   = 'X'
  *     IS_VARIANT               =
  *     IT_EVENTS                =
  *     IT_EVENT_EXIT            =
  *     IS_PRINT                 =
  *     IS_REPREP_ID             =
  *     I_SCREEN_START_COLUMN    = 0
  *     I_SCREEN_START_LINE      = 0
  *     I_SCREEN_END_COLUMN      = 0
  *     I_SCREEN_END_LINE        = 0
  *     I_HTML_HEIGHT_TOP        = 0
  *     I_HTML_HEIGHT_END        = 0
  *     IT_ALV_GRAPHICS          =
  *     IT_HYPERLINK             =
  *     IT_ADD_FIELDCAT          =
  *     IT_EXCEPT_QINFO          =
  *     IR_SALV_FULLSCREEN_ADAPTER        =
  * IMPORTING
  *     E_EXIT_CAUSED_BY_CALLER  =
  *     ES_EXIT_CAUSED_BY_USER   =
      TABLES
        t_outtab                 = gt_items[]
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
      MESSAGE 'Erro a apresentar os dados' TYPE 'E'.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  DATA_DISPLAY
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM data_display .
  
  DATA: lr_functions TYPE REF TO cl_salv_functions_list,
        r_columns TYPE REF TO cl_salv_columns_table,
        r_column TYPE REF TO cl_salv_column,
        alv TYPE REF TO cl_salv_table.
  
  DATA: opt TYPE STANDARD TABLE OF rfc_db_opt,
        fld TYPE STANDARD TABLE OF rfc_db_fld,
        tab TYPE STANDARD TABLE OF tab512.
  
  TRY.
    CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = alv
          CHANGING
            t_table      = gt_items.
  
        r_columns = alv->get_columns( ).
        r_columns->set_optimize( abap_true ).
  
        lr_functions = alv->get_functions( ).
        lr_functions->set_all(  ).
  
  CATCH cx_salv_not_found.
  
  ENDTRY.
  
  *Mostrar ALV
  alv->display( ).
  
  ENDFORM.
  
  FORM user_command  USING r_ucomm     LIKE sy-ucomm
                           rs_selfield TYPE slis_selfield.
  
    IF rs_selfield-fieldname EQ 'SD_DOC'.
      SET PARAMETER ID 'AUN' FIELD rs_selfield-value.
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
    ENDIF.
  
  ENDFORM.