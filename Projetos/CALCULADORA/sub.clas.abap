*&---------------------------------------------------------------------*
*&  Include           Z_ABAP_BASICS_CALC_SUB
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CALC_RESULTADO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PAR1  text
*      -->P_P_PAR2  text
*      -->P_P_OP  text
*      <--P_GV_RESULTADO  text
*----------------------------------------------------------------------*
FORM calc_resultado  USING    p_par1
                              p_par2
                              p_op
                     CHANGING p_resultado.

*gc_operadores_validos(4) TYPE c VALUE '+-*/'.

* calcular resultado final
  CASE p_op.
    WHEN gc_operadores_validos+0(1).
      p_resultado = p_par1 + p_par2.

    WHEN gc_operadores_validos+1(1).
      p_resultado = p_par1 - p_par2.

    WHEN gc_operadores_validos+2(1).
      p_resultado = p_par1 * p_par2.

    WHEN gc_operadores_validos+3(1).
      p_resultado = p_par1 / p_par2.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EXIBIR_RESULTADO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM exibir_resultado .
  cl_demo_output=>next_section( title = |Calculadora básica: { p_par1 } { p_op } { p_par2 } | ).
  cl_demo_output=>write_data( name = 'Resultado' value = | { gv_resultado } | ).
  cl_demo_output=>display( ).
ENDFORM.