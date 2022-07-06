*&---------------------------------------------------------------------*
*& Report ZJG_PRO_REQUESTS_VIS04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZJG_PRO_REQUESTS_VIS04 MESSAGE-ID ZJG_MSG.


INCLUDE ZJG_PRO_REQUESTS_VIS04_TOP .
INCLUDE ZJG_PRO_REQUESTS_VIS04_CL1 . " classes LCL_APP, form /1BCDWB/SF00000132
INCLUDE ZJG_PRO_REQUESTS_VIS04_PAI . " modulo Input
INCLUDE ZJG_PRO_REQUESTS_VIS04_PDO . " modulo Output


START-OF-SELECTION.

  CREATE OBJECT GO_APP.
  GO_APP->GET_DATA( ).
  GO_APP->DISPLAY_ALV( ).

END-OF-SELECTION.