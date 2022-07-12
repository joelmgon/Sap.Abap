*&---------------------------------------------------------------------*
*&  Include           Z_ABAP_BASICS_CALC_SCR
*&---------------------------------------------------------------------*

*_ ecrã de parâmetros

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "
PARAMETERS: p_par1 TYPE dmbtr,
            p_par2 TYPE dmbtr.

SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN ULINE /1(50).
SELECTION-SCREEN COMMENT /1(21) text-002.
SELECTION-SCREEN COMMENT /1(10) text-003 MODIF ID ope.
SELECTION-SCREEN ULINE /1(50).
PARAMETERS: p_op TYPE char01.
SELECTION-SCREEN END OF BLOCK b1.