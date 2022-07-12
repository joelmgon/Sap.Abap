*&---------------------------------------------------------------------*
*&      Form  TRATA_ECRA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM trata_ecra .
    LOOP AT SCREEN.
      IF screen-group1 EQ 'OPE'.
        screen-intensified = '1'.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *&      Form  VALIDA_VALORES
  *&---------------------------------------------------------------------*
  *       text
  *----------------------------------------------------------------------*
  *  -->  p1        text
  *  <--  p2        text
  *----------------------------------------------------------------------
  
  FORM valida_valores .
  *- se divisão validar operadando <> 0
    IF p_op CO gc_operadores_validos.
      IF p_op EQ gc_operadores_validos+3(1) AND p_par2 EQ 0.
        MESSAGE e002.
      ELSEIF p_op EQ gc_operadores_validos+1(1) AND p_par2 GT p_par1.
        MESSAGE e003.
      ENDIF.
    ENDIF.
  ENDFORM.