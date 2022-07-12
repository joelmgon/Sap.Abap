*&---------------------------------------------------------------------*
*& Report  Z_ABAP_BASICS_CALC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT Z_ABAP_BASICS_CALC MESSAGE-ID ZBASICS.

*_ includes
INCLUDE: Z_ABAP_BASICS_CALC_TOP, "dados globais
         Z_ABAP_BASICS_CALC_SCR, "ecrã
         Z_ABAP_BASICS_CALC_PBO, "Process Before Output
         Z_ABAP_BASICS_CALC_PAI, "Process After Input
         Z_ABAP_BASICS_CALC_SUB. "Subrotinas

AT SELECTION-SCREEN OUTPUT.
  PERFORM TRATA_ECRA.

AT SELECTION-SCREEN ON P_OP.
  PERFORM VALIDA_OPERADOR.

AT SELECTION-SCREEN ON BLOCK B1.
  PERFORM VALIDA_VALORES.

START-OF-SELECTION.
  PERFORM CALC_RESULTADO USING P_PAR1
                               P_PAR2
                               P_OP
                         CHANGING GV_RESULTADO.

END-OF-SELECTION.
  PERFORM EXIBIR_RESULTADO.