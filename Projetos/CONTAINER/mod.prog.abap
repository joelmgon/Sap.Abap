*&---------------------------------------------------------------------*
*&  Include           ZPACP_INTERFACE_MOD
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0400 OUTPUT.
  SET PF-STATUS 'MAINSTATUS'.

*  SET TITLEBAR 'TITLE'.


  IF g_custom_container IS INITIAL.

    " Create CONTAINER object with reference to container name in the screen
    CREATE OBJECT g_custom_container EXPORTING container_name = 'CONTAINER1'.
    " Create GRID object with reference to parent name
    CREATE OBJECT g_grid EXPORTING i_parent = g_custom_container.

    PERFORM prepare_fieldcatalog.
    gs_layout-zebra = 'X'.
    "gs_layout-edit = 'X'. " Makes all Grid editable

    " SET_TABLE_FOR_FIRST_DISPLAY

    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_fieldcatalog = gs_fieldcatalog
        it_outtab       = gt_item. " Data

**********************************************************************

    " Create CONTAINER object with reference to container name in the screen
    CREATE OBJECT g_custom_container2 EXPORTING container_name = 'CONTAINER2'.
    " Create GRID object with reference to parent name
    CREATE OBJECT g_grid2 EXPORTING i_parent = g_custom_container2.

    PERFORM prepare_fieldcatalog.
    gs_layout-zebra = 'X'.
    "gs_layout-edit = 'X'. " Makes all Grid editable

    " SET_TABLE_FOR_FIRST_DISPLAY

    CALL METHOD g_grid2->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_fieldcatalog = gs_fieldcatalog
        it_outtab       = gt_item. " Data

  ELSE.

    CALL METHOD g_grid->refresh_table_display.

  ENDIF.


ENDMODULE.

MODULE user_command_0400 INPUT.


  save_ok = ok_code.

  CLEAR ok_code.

  CASE save_ok.

    WHEN 'EXIT' OR 'BACK' OR 'CANCEL'.

      LEAVE PROGRAM.

    WHEN 'ZSORT'.
      SORT gt_item DESCENDING.
      CALL METHOD g_grid->refresh_table_display.
      CALL METHOD g_grid2->refresh_table_display.

    WHEN 'SAVE'.
      "guardar


  ENDCASE.

ENDMODULE.