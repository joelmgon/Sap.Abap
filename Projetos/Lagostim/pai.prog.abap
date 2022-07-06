*&---------------------------------------------------------------------*
*&  Include           ZHRO_LAGOSTIM_PAI
*&---------------------------------------------------------------------*



FORM user_command USING r_ucomm LIKE sy-ucomm rs_selfield TYPE slis_selfield.

    CASE r_ucomm.
      WHEN 'BACK'.
        RETURN.
      WHEN 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
  
      WHEN 'ZDELETE'.
  
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'Warning Message'
            text_question         = 'Are you sure you want to delete?'
            text_button_1         = 'Yes'
            text_button_2         = 'No'
            default_button        = '2'
            display_cancel_button = ''
          IMPORTING
            answer                = zhro_answer  "VARIAVEL TIPO CHAR1 QUE ARMAZENA A RESPOSTA DO USER AO CLICAR YES(1)/NO(2)
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.
  *-----------------------------------------VERIFICAÇAO DO BOTAO QUE O UTILIZADOR ESCOLHEU---------------------------------------------------
        CASE zhro_answer.
          WHEN '1'.
            READ TABLE it_request INDEX rs_selfield-tabindex INTO wa_request.
            DELETE FROM zhro_request WHERE request_nr = wa_request-request_nr.
            IF sy-subrc = 0.
              MESSAGE 'Successfully deleted' TYPE 'S'.
            ELSEIF sy-subrc NE 0.
              MESSAGE 'Error deleting the data' TYPE 'E'.
              RETURN.
            ENDIF..
  
          WHEN '2'.
            RETURN.
  
          WHEN OTHERS.
        ENDCASE.
        PERFORM get_data.
  
        rs_selfield-refresh = 'X'.              "FAZ UPDATE AO ALV
  
      WHEN 'ZMODIFY'.
  
        PERFORM f_save_data.
        PERFORM get_data.
  
        rs_selfield-refresh = 'X'.
  
      WHEN 'ZBILL'.
  
        PERFORM print_form USING rs_selfield-tabindex.    " PERFORM AO PRINT_FORM DA LINHA SELECIONADA NO ALV
  
      WHEN OTHERS.
    ENDCASE.
  
  
  ENDFORM.