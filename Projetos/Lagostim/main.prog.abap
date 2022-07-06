*&---------------------------------------------------------------------*
*& Report ZHRO_LAGOSTIM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zhro_lagostim.

INCLUDE zhro_lagostim_top.
INCLUDE zhro_lagostim_screen.
INCLUDE zhro_lagostim_pai.
INCLUDE zhro_lagostim_form.



START-OF-SELECTION.


  PERFORM get_data.


END-OF-SELECTION.



  PERFORM prepare_alv.
  PERFORM prepare_layout.
  PERFORM display_alv.