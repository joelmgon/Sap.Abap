*&---------------------------------------------------------------------*
*&  Include           ZABAP_EXCEL_02_RP_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

    DATA lv_filename TYPE  rlgrap-filename.
    DATA lv_begin_col TYPE  i.
    DATA lv_begin_row TYPE  i.
    DATA lv_end_col TYPE  i.
    DATA lv_end_row TYPE  i.
  
    DATA lt_excel TYPE TABLE OF alsmex_tabline.
    DATA ls_excel TYPE alsmex_tabline.
  
  
    IF p_file IS INITIAL.
      MESSAGE 'Tem de indicar um ficheiro válido' TYPE 'S' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    lv_filename = p_file.
  
    CASE 'X'.
      WHEN r_op1. " xml
  
  *" Abrir como xml
        DATA lv_string TYPE string.
        lv_string = lv_filename .
  
  
  
        lcl_excel=>upload( EXPORTING i_file = lv_string CHANGING ct_alv = gt_alv EXCEPTIONS error = 1 OTHERS = 2 ).
        IF sy-subrc NE 0.
          MESSAGE 'Erro a ler o ficheiro' TYPE 'S' DISPLAY LIKE 'E'.
          LEAVE LIST-PROCESSING.
        ENDIF.
  
  
      WHEN r_op2. "xlsx - excel instalado
  
  *" Abrir com a aplicação excel
  
        lv_begin_col = p_st_c.
        lv_begin_row = p_st_r.
        lv_end_col = p_end_c.
        lv_end_row = p_end_r.
  
        CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
          EXPORTING
            filename                = lv_filename
            i_begin_col             = lv_begin_col
            i_begin_row             = lv_begin_row
            i_end_col               = lv_end_col
            i_end_row               = lv_end_row
          TABLES
            intern                  = lt_excel
          EXCEPTIONS
            inconsistent_parameters = 1
            upload_ole              = 2
            OTHERS                  = 3.
        IF sy-subrc <> 0.
  * Implement suitable error handling here
        ENDIF.
  
  
  *" Preencher tabela do ALV.
  
  
        LOOP AT lt_excel INTO ls_excel.
          CLEAR gs_alv.
          CASE ls_excel-col.
  
            WHEN '0001'.
              gs_alv-vbeln  =  ls_excel-value.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = gs_alv-vbeln
                IMPORTING
                  output = gs_alv-vbeln.
  
  
          ENDCASE.
  
  
          APPEND gs_alv TO gt_alv.
        ENDLOOP.
  
  
      WHEN r_op3. "csv
  
        DATA: lt_table TYPE TABLE OF kcde_intern_struc,
              ls_table TYPE kcde_intern_struc.
  
        TRY.
  
            CALL FUNCTION 'KCD_CSV_FILE_TO_INTERN_CONVERT'
              EXPORTING
                i_filename      = lv_filename
                i_separator     = ','
              TABLES
                e_intern        = lt_table
              EXCEPTIONS
                upload_csv      = 1
                upload_filetype = 2
                OTHERS          = 3.
            IF sy-subrc <> 0.
              CLEAR lt_table.
            ENDIF.
          CATCH cx_sy_dyn_call_illegal_type.
            CLEAR lt_table.
  
        ENDTRY.
  
  
        LOOP AT lt_table INTO ls_table .
          CLEAR gs_alv.
          CASE ls_table-col.
  
            WHEN '0001'.
              gs_alv-vbeln  =  ls_table-value.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = gs_alv-vbeln
                IMPORTING
                  output = gs_alv-vbeln.
  
  
          ENDCASE.
  
  
          APPEND gs_alv TO gt_alv.
        ENDLOOP.
  
  
        WHEN OTHERS:
          ...
    ENDCASE.
  
  
  
  ENDFORM.