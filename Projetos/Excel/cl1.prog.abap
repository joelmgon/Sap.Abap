*&---------------------------------------------------------------------*
*&  Include           ZABAP_EXCEL_02_RP_CL1
*&---------------------------------------------------------------------*

CLASS lcl_excel DEFINITION.

    PUBLIC SECTION.
  
      CLASS-METHODS: upload IMPORTING  i_file TYPE string
                            CHANGING   ct_alv TYPE lty_alv_t
                            EXCEPTIONS error .
  ENDCLASS.
  
  
  CLASS lcl_excel IMPLEMENTATION.
    METHOD upload.
  
      DATA : lv_filename      TYPE string,
             lt_records       TYPE solix_tab,
             lv_headerxstring TYPE xstring,
             lv_filelength    TYPE i.
  
      lv_filename = p_file.
  
      CALL FUNCTION 'GUI_UPLOAD'
        EXPORTING
          filename   = i_file
          filetype   = 'BIN'
        IMPORTING
          filelength = lv_filelength
          header     = lv_headerxstring
        TABLES
          data_tab   = lt_records
        EXCEPTIONS
          OTHERS     = 1.
  
  
      IF sy-subrc NE 0.
        RAISE error.
      ENDIF.
  
      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = lv_filelength
        IMPORTING
          buffer       = lv_headerxstring
        TABLES
          binary_tab   = lt_records
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
  
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.
  
      DATA : lo_excel_ref TYPE REF TO cl_fdt_xl_spreadsheet .
  
      TRY .
          lo_excel_ref = NEW cl_fdt_xl_spreadsheet(
                                  document_name = lv_filename
                                  xdocument     = lv_headerxstring ) .
        CATCH cx_fdt_excel_core.
          RAISE error.
      ENDTRY .
  
      "Get List of Worksheets
      lo_excel_ref->if_fdt_doc_spreadsheet~get_worksheet_names(
        IMPORTING
          worksheet_names = DATA(lt_worksheets) ).
  
  
      FIELD-SYMBOLS : <gt_data>       TYPE STANDARD TABLE .
      FIELD-SYMBOLS : <line>       TYPE any .
      FIELD-SYMBOLS : <fs_val>       TYPE any .
  
      DATA lv_char10 TYPE char10.
  
      IF NOT lt_worksheets IS INITIAL.
        READ TABLE lt_worksheets INTO DATA(lv_woksheetname) INDEX 1.
  
        DATA(lo_data_ref) = lo_excel_ref->if_fdt_doc_spreadsheet~get_itab_from_worksheet(
                                                 lv_woksheetname ).
        "now you have excel work sheet data in dyanmic internal table
        ASSIGN lo_data_ref->* TO <gt_data>.
      ENDIF.
  
  
      IF <gt_data> IS ASSIGNED.
        LOOP AT <gt_data> ASSIGNING <line>.
          IF sy-tabix < p_st_r.
            CONTINUE.
          ENDIF.
  
          CLEAR gs_alv.
          ASSIGN COMPONENT 1 OF STRUCTURE <line> TO <fs_val>.
          IF sy-subrc EQ 0.
            gs_alv-vbeln = <fs_val>.
          ENDIF.
  
          "DATA no formato "dd.mm.aaaa"
          ASSIGN COMPONENT 2 OF STRUCTURE <line> TO <fs_val>.
          IF sy-subrc EQ 0.
            lv_char10 = <fs_val>.
            gs_alv-erdat+0(4) = lv_char10+6(4).
            gs_alv-erdat+4(2) = lv_char10+3(2).
            gs_alv-erdat+6(2) = lv_char10+0(2).
          ENDIF.
  
  
  
  
  
          APPEND gs_alv TO ct_alv.
        ENDLOOP.
      ENDIF.
  
  
  
  
  
    ENDMETHOD.
  ENDCLASS.