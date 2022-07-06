*&---------------------------------------------------------------------*
*& Report ZABAP_BAPI_CREATE_01_RP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_excel_02_rp.

INCLUDE zabap_excel_02_rp_top.
INCLUDE zabap_excel_02_rp_scr.
INCLUDE zabap_excel_02_rp_cl1.
INCLUDE zabap_excel_02_rp_frm.





CLASS lcl_event DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_vbeln_click
            FOR EVENT link_click OF cl_salv_events_table
        IMPORTING
            row
            column  .
    METHODS:
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function.

    METHODS:
      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column.

ENDCLASS.


CLASS lcl_event IMPLEMENTATION.

  METHOD on_vbeln_click.

*   Get the material number from the table
    READ TABLE gt_alv INTO gs_alv INDEX row.
    IF gs_alv-vbeln IS NOT INITIAL.

      SET PARAMETER ID 'AUN' FIELD gs_alv-vbeln  .
      CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN .
    ENDIF.

  ENDMETHOD.

  METHOD on_user_command.
    CASE e_salv_function.
      WHEN 'MYFUNCTION'.

        DATA: lt_rows TYPE salv_t_row,
              lt_cols TYPE salv_t_column,
              ls_cell TYPE salv_s_cell.

        DATA: l_row        TYPE i,
              l_col        TYPE lvc_fname,
              l_row_string TYPE char128,
              l_col_string TYPE char128,
              l_row_info   TYPE char128,
              l_col_info   TYPE char128.

        DATA(lr_selections) = go_alv->get_selections( ).
        lt_rows = lr_selections->get_selected_rows( ).



        lt_cols = lr_selections->get_selected_columns( ).
        ls_cell = lr_selections->get_current_cell( ).

*      ... Zeile
        CLEAR l_row_info.
        LOOP AT lt_rows INTO l_row.
          WRITE l_row TO l_row_string LEFT-JUSTIFIED.
          CONCATENATE l_row_info l_row_string INTO l_row_info SEPARATED BY space.
        ENDLOOP.
        IF sy-subrc EQ 0.
          MESSAGE i000(0k) WITH 'Linha' l_row_info.
        ENDIF.

*      ... Spalte
        CLEAR l_col_info.
        LOOP AT lt_cols INTO l_col.
          WRITE l_col TO l_col_string LEFT-JUSTIFIED.
          CONCATENATE l_col_info l_col_string INTO l_col_info SEPARATED BY space.
        ENDLOOP.
        IF sy-subrc EQ 0.
          MESSAGE i000(0k) WITH 'Coluna' l_col_info.
        ENDIF.

*      ... Zelle
        IF ls_cell IS NOT INITIAL.
          MESSAGE i000(0k) WITH 'Linha' ls_cell-row 'Coluna' ls_cell-columnname.
        ENDIF.

    ENDCASE.
  ENDMETHOD.                    "on_user_command


  METHOD on_double_click.

    DATA: l_row_string TYPE string,
          l_col_string TYPE string,
          l_row        TYPE char128.

    WRITE row TO l_row LEFT-JUSTIFIED.
    DATA(l_row_str) = CONV string( row ).
    DATA(l_col_str) = CONV string( column ).
    CONCATENATE  'Linha' l_row_str INTO l_row_string SEPARATED BY space.
    CONCATENATE  'Coluna' l_col_str INTO l_col_string SEPARATED BY space.

    MESSAGE i000(0k) WITH 'Duplo click' l_row_string l_col_string.


  ENDMETHOD.                    "on_double_click


ENDCLASS.

*" evento do ecra de selecao
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CLEAR gt_filetab.
  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      multiselection = space
    CHANGING
      file_table     = gt_filetab
      rc             = gv_rc.

  LOOP AT gt_filetab INTO gs_file.
    p_file = gs_file-filename.
  ENDLOOP.





START-OF-SELECTION.
  PERFORM get_data.


END-OF-SELECTION.

*" MOSTRAR TABELA INTERNA NUM ALV SALV
  DATA: lx_msg TYPE REF TO cx_salv_msg.

  DATA: lo_functions TYPE REF TO cl_salv_functions_list.


*" Mostrar alv
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_alv ).
    CATCH cx_salv_msg INTO lx_msg.
  ENDTRY.



  go_alv->set_screen_status(
    pfstatus      = 'ZSALV_STANDARD'
    report        =  sy-repid
    set_functions = go_alv->c_functions_all ).


  DATA(lo_selections) = go_alv->get_selections( ).
  "allow single line selection
  lo_selections->set_selection_mode( if_salv_c_selection_mode=>row_column ).



*" hotspot.
  DATA: lo_cols_tab TYPE REF TO cl_salv_columns_table,
        lo_col_tab  TYPE REF TO cl_salv_column_table.

  lo_cols_tab = go_alv->get_columns( ).

  TRY.
      lo_col_tab ?= lo_cols_tab->get_column( 'VBELN' ).
    CATCH cx_salv_not_found.
  ENDTRY.
*
  TRY.
      CALL METHOD lo_col_tab->set_cell_type
        EXPORTING
          value = if_salv_c_cell_type=>hotspot.
    CATCH cx_salv_data_error .
  ENDTRY.




*" eventos => click
  DATA lo_event_receiver TYPE REF TO lcl_event.
  CREATE OBJECT lo_event_receiver.

  DATA: lo_events TYPE REF TO cl_salv_events_table.
*   All events
  lo_events = go_alv->get_event( ).

*   Event handler
  SET HANDLER lo_event_receiver->on_vbeln_click FOR lo_events.


*...  event USER_COMMAND
  SET HANDLER lo_event_receiver->on_user_command FOR lo_events.



  go_alv->display( ).