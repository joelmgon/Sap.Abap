*&---------------------------------------------------------------------*
*&  Include           ZABAP_EXCEL_02_RP_SCR
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.


PARAMETERS: r_op1 RADIOBUTTON GROUP rad1 DEFAULT 'X', " excel como xml
            r_op2 RADIOBUTTON GROUP rad1, " excel com office instalado
            r_op3 RADIOBUTTON GROUP rad1. " csv



SELECTION-SCREEN skip 1.

PARAMETERS: p_file TYPE rlgrap-filename.

PARAMETERS: p_st_r TYPE  i DEFAULT '2'.
PARAMETERS: p_st_c TYPE  i DEFAULT '1'.
PARAMETERS: p_end_r TYPE  i DEFAULT '9999'.
PARAMETERS: p_end_c TYPE  i DEFAULT '1'.

SELECTION-SCREEN END OF BLOCK b01.