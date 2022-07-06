*&---------------------------------------------------------------------*
*&  Include           ZPACP_ALV2_FORM
*&---------------------------------------------------------------------*
FORM get_data .

    SELECT * FROM spfli INTO TABLE it_spfli
      WHERE carrid IN s_air.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *&      Form  PREPARE_LV
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------*
  FORM prepare_lv .
  
    DATA message TYPE REF TO cx_salv_msg.
  
    TRY.
  
        cl_salv_table=>factory(
        IMPORTING
          r_salv_table = alv
          CHANGING
            t_table = it_spfli
            ).
  
        columns = alv->get_columns( ).
        columns->set_optimize( ).
  
        column = columns->get_column( 'MANDT' ).
        column->set_visible( if_salv_c_bool_sap=>false ).
  
        column = columns->get_column( 'COUNTRYFR' ).
        column->set_short_text('País').
        column->set_medium_text('País').
        column->set_long_text('País').
  
        layout_settings = alv->get_layout( ).
  
        layout_key-report = sy-repid.
        layout_settings->set_key( layout_key ).
  
        layout_settings->set_save_restriction( if_salv_c_layout=>restrict_none ).
        layout_settings->set_default( if_salv_c_bool_sap=>true ).
  
  
  
        alv->display( ).
  
      CATCH cx_salv_msg INTO message.
  
    ENDTRY.
  
  ENDFORM.