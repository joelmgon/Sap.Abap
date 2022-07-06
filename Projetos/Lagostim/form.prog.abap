*&---------------------------------------------------------------------*
*&  Include           ZHRO_LAGOSTIM_FORM
*&---------------------------------------------------------------------*

FORM get_data.

    SELECT  zhro_request~mandt zhro_request~request_nr zhro_request~plate_type zhro_request~quantity zhro_request~request_value
      zhro_request~request_date zhro_request~currency
      FROM zhro_request
      INNER JOIN zhro_dishes ON zhro_request~plate_type = zhro_dishes~plate_type  "SELECT ÁS 2 TABELAS EM QUE O CAMPO PLATE TYPE,
      INTO TABLE it_request                  "É IGUAL NAS DUAS E COM A CONDIÇAO INSERIDA PELO UTILIZADOR,
      WHERE zhro_dishes~plate_type IN s_pltype                       "S_PLTYPE E S_REQNR
      AND   zhro_request~request_nr IN s_reqnr.
  
  
  
  
  ENDFORM.
  
  
  
  
  FORM prepare_alv.
  
    DATA: lv_index TYPE int1.
    lv_index = 0.
  
    wa_fieldcat-fieldname = 'REQUEST_NR'.
    wa_fieldcat-seltext_m = 'REQUEST_NR'.
    wa_fieldcat-col_pos = lv_index + 1.
    wa_fieldcat-outputlen = 10.
    wa_fieldcat-key = 'X'.                 "CAMPO CHAVE 'X'
    wa_fieldcat-just = 'L'.
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
  
    wa_fieldcat-fieldname = 'PLATE_TYPE'.
    wa_fieldcat-seltext_m = 'PLATE_TYPE'.
    wa_fieldcat-col_pos = lv_index + 1.
    wa_fieldcat-outputlen = 10.
    wa_fieldcat-key = 'X'.                    "CAMPO CHAVE , NAO EDITAVEL POIS O CAMPO REQUEST NR E PLATE TYPE JUNTOS SAO CHAVE
    wa_fieldcat-just = 'L'.
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
  
  
    wa_fieldcat-fieldname = 'QUANTITY'.
    wa_fieldcat-seltext_m = 'QUANTITY'.
    wa_fieldcat-col_pos = lv_index + 1.
    wa_fieldcat-outputlen = 10.
    wa_fieldcat-just = 'L'.
    wa_fieldcat-edit = 'X'.                      "CAMPO EDITAVEL 'X'
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
  
  
    wa_fieldcat-fieldname = 'REQUEST_VALUE'.
    wa_fieldcat-seltext_m = 'REQUEST_VALUE'.
    wa_fieldcat-col_pos = lv_index + 1.
    wa_fieldcat-outputlen = 10.
    wa_fieldcat-just = 'L'.
    wa_fieldcat-edit = ''.                    "CAMPO EDITAVEL 'X'
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
  
  
    wa_fieldcat-fieldname = 'CURRENCY'.
    wa_fieldcat-seltext_m = 'CURRENCY'.
    wa_fieldcat-col_pos = lv_index + 1.
    wa_fieldcat-outputlen = 10.
    wa_fieldcat-just = 'L'.
    wa_fieldcat-edit = ''.                 "CAMPO NAO EDITAVEL
    APPEND wa_fieldcat TO it_fieldcat.
    CLEAR wa_fieldcat.
  
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
  *     I_PROGRAM_NAME         =
  *     I_INTERNAL_TABNAME     =
        i_structure_name       = 'ZHRO_REQUEST'
  *     i_client_never_display = 'X'
  *     i_inclname             =
  *     i_bypassing_buffer     =
  *     i_buffer_active        =
      CHANGING
        ct_fieldcat            = it_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
    LOOP AT it_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
      IF
        <fs_fieldcat>-fieldname = 'MANDT'.
        <fs_fieldcat>-no_out = 'X'.                  "ESCONDER O CAMPO MANDANTE
      ENDIF.
  
      wa_layout-zebra = 'X'.
      wa_layout-colwidth_optimize = abap_true.
    ENDLOOP.
  
  
  
  ENDFORM.
  
  
  
  FORM prepare_layout .
    wa_layout-zebra = abap_true.
    wa_layout-colwidth_optimize = abap_true.
  
  ENDFORM.
  
  
  FORM f_save_data.   "MODIFY
  
    DATA: wa_req     TYPE zhro_request,      "DEFINIR 2 WORKAREAS DO TIPO DA NOSSA TABELA PRINCIPAL
          wa_req_sec TYPE zhro_request.      "2 Work areas para verificar se a que armazena as modificaçoes está = à outra
  
    DATA : ref_grid TYPE REF TO cl_gui_alv_grid.
  
  
  
    IF ref_grid IS INITIAL.                             "OBTER OS DADOS ATUALIZADOS DA TABELA INTERNA NO ALV
      CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
        IMPORTING
          e_grid = ref_grid.
    ENDIF.
  
    IF NOT ref_grid IS INITIAL.
      CALL METHOD ref_grid->check_changed_data.
    ENDIF.
  
  
    CLEAR it_changes[].                             "REMOVER TODO O CONTEUDO DA TABELA QUE VAI ARMAZENAR AS ALTERAÇOES EFETUADAS
  
    LOOP AT it_request INTO wa_request.
      READ TABLE it_req INTO wa_req INDEX sy-tabix .
      IF wa_req NE wa_request.
        IF  wa_request-quantity = 0 .
          MESSAGE 'Insert quantity.' TYPE 'E'.
          RETURN.
        ENDIF.                                    "Caso n sejam iguais modifica a tabela fisica.
        APPEND wa_request TO it_changes.
        MOVE-CORRESPONDING wa_request TO wa_req_sec.
        PERFORM get_request_value CHANGING wa_req_sec.
  
        MODIFY zhro_request FROM wa_req_sec.
      ENDIF.
      CLEAR wa_req.
    ENDLOOP.
  
  
  
    rs_selfield-refresh = 'X'.          "REFRESH AO NOSSO ALV DOS CAMPOS MODIFICADOS
  
  
  
    IF sy-subrc = 0.
      MESSAGE 'Request has been modified!' TYPE 'S'.
    ELSEIF sy-subrc NE 0.
      MESSAGE 'Error modifying the request!' TYPE 'E'.
    ENDIF.
  
  
  
  ENDFORM.
  
  
  
  
  FORM get_data_modi .                          "SELECT ÀS DUAS TABELAS EM QUE O CAMPO PLATE TYPE É COMUM NAS DUAS TABELAS
    SELECT *
      FROM zhro_request INNER JOIN zhro_dishes ON zhro_request~plate_type = zhro_dishes~plate_type
      INTO CORRESPONDING FIELDS OF TABLE it_request.                "PARA OS CAMPOS CORRESPONDENTES DA NOSSA TABELA INTERNA REQUEST
  
  ENDFORM.
  
  
  
  
  FORM get_request_value CHANGING cs_request TYPE zhro_request.
  
    DATA: lv_unit_value TYPE zhro_unit_value.            "VARIAVEL QUE VAI ARMAZENAR O VALOR UNITARIO E A QUANTIDADE DE UM PEDIDO
    "( DO TIPO DE DADOS DO CAMPO UNIT VALUE DA NOSSA TABELA
  
  
    SELECT unit_value UP TO 1 ROWS FROM zhro_dishes
    INTO lv_unit_value                                       " Select ao campo unit value de uma unica linha para a variavel criada
      WHERE plate_type = cs_request-plate_type.
  
      cs_request-request_value = cs_request-quantity * lv_unit_value.
  
    ENDSELECT.
  
  
  ENDFORM.
  
  
  
  
  
  FORM display_alv .
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
  *     I_INTERFACE_CHECK        = ' '
  *     I_BYPASSING_BUFFER       = ' '
  *     I_BUFFER_ACTIVE          = ' '
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'PFSTATUS'
        i_callback_user_command  = 'USER_COMMAND'
  *     I_CALLBACK_TOP_OF_PAGE   = ' '
  *     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
  *     I_CALLBACK_HTML_END_OF_LIST       = ' '
  *     I_STRUCTURE_NAME         =
  *     I_BACKGROUND_ID          = ' '
  *     I_GRID_TITLE             =
  *     I_GRID_SETTINGS          =
        is_layout                = wa_layout
        it_fieldcat              = it_fieldcat
  *     IT_EXCLUDING             =
  *     IT_SPECIAL_GROUPS        =
  *     IT_SORT                  =
  *     IT_FILTER                =
  *     IS_SEL_HIDE              =
  *     I_DEFAULT                = 'X'
        i_save                   = 'X'
  *     IS_VARIANT               =
  *     IT_EVENTS                =
  *     IT_EVENT_EXIT            =
  *     IS_PRINT                 =
  *     IS_REPREP_ID             =
  *     I_SCREEN_START_COLUMN    = 0
  *     I_SCREEN_START_LINE      = 0
  *     I_SCREEN_END_COLUMN      = 0
  *     I_SCREEN_END_LINE        = 0
  *     I_HTML_HEIGHT_TOP        = 0
  *     I_HTML_HEIGHT_END        = 0
  *     IT_ALV_GRAPHICS          =
  *     IT_HYPERLINK             =
  *     IT_ADD_FIELDCAT          =
  *     IT_EXCEPT_QINFO          =
  *     IR_SALV_FULLSCREEN_ADAPTER        =
  *   IMPORTING
  *     E_EXIT_CAUSED_BY_CALLER  =
  *     ES_EXIT_CAUSED_BY_USER   =
      TABLES
        t_outtab                 = it_request
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  ENDFORM.
  
  
  
  
  *---------------------------------------------------PF-STATUS GUI-------------------------------------------------------------------------------
  
  FORM pfstatus USING rt_extab TYPE slis_t_extab.
    SET PF-STATUS 'Z_GUI' EXCLUDING rt_extab.
  
  ENDFORM.
  
  
  *-------------------------------------------------------------INSERT-----------------------------------------------------------------
  
  
  
  
  FORM insert_data .
  
    DATA: lv_unit_value TYPE zhro_unit_value.
    DATA: ls_request TYPE zhro_request.
  
    SELECT * UP TO 1 ROWS FROM zhro_request
      INTO ls_request
      WHERE request_nr = p_reqnr AND plate_type = p_pltype.
  
    ENDSELECT.
  
    IF sy-subrc = 0.
      MESSAGE 'This plate type already exists for the specified request.' TYPE 'E'.
      RETURN.
    ENDIF.
    CLEAR ls_request.
  
    SELECT unit_value UP TO 1 ROWS FROM zhro_dishes
      INTO lv_unit_value
      WHERE plate_type = p_pltype.
  *    AND request_nr = p_reqnr.
  
    ENDSELECT.
  
    gs_request-request_nr = p_reqnr.         "TEMOS DE IGUALAR OS DADOS INSERIDOS PELO UTILIZADOR AOS CAMPOS DA NOSSA ESTRUTURA
    gs_request-quantity = p_qntity.
    gs_request-plate_type = p_pltype.
    gs_request-request_value = lv_unit_value * p_qntity.    "CALCULO DO VALOR DO PEDIDO (UNIT VALUE X QUANTITY)
    gs_request-request_date = sy-datum.
    gs_request-currency = p_curr.
  
    IF  gs_request-quantity = 0 .
      MESSAGE 'Insert quantity.' TYPE 'E'.
      RETURN.
    ELSEIF gs_request-plate_type IS INITIAL .
      MESSAGE 'Insert plate type.' TYPE 'E'.
      RETURN.
  
    ELSEIF gs_request-request_nr IS INITIAL .
      MESSAGE 'Insert request number.' TYPE 'E'.
      RETURN.
    ELSEIF gs_request-currency IS INITIAL .
      MESSAGE 'Error creating request!' TYPE 'E'.
    ELSEIF gs_request-quantity NE 0 .
      MESSAGE 'A new request has been created!' TYPE 'S'.
  
    ELSEIF gs_request-plate_type IS NOT INITIAL .
      MESSAGE 'A new request has been created!' TYPE 'S'.
  
    ELSEIF gs_request-request_nr IS NOT INITIAL .
      MESSAGE 'A new request has been created!' TYPE 'S'.
  
    ENDIF.
  
  
  
  
  
    MOVE-CORRESPONDING gs_request TO ls_request.   "ENVIAR OS DADOS DA GS REQUEST PARA A LS REQUEST PQ A GS NAO TEM O CAMPO MDNT
  
    MODIFY zhro_request FROM ls_request.      "INSERE OS DADOS QUE FORAM ARMAZENADOS NA ESTRUTURA REQUEST PARA A TABELA PRINCIPAL
  
  
  
  
  
  ENDFORM.
  
  
  
  *--------------------------------------------------PRINT----------------------------------------------------------------------------
  
  
  
  FORM print_form USING p_index .
  
    "fill_table USING    wa   TYPE any
    "CHANGING ptab TYPE INDEX TABLE.
    "APPEND wa TO ptab.
    "ENDFORM.
  
  
    IF p_index EQ 0.
      MESSAGE 'Select a line.' TYPE 'E'.
      RETURN.
    ENDIF.
  
    READ TABLE it_request INDEX p_index INTO wa_request.
    IF sy-subrc NE 0 .
      MESSAGE 'Erro.' TYPE 'E'.
      RETURN.
    ENDIF.
  
  
    DATA: i_request_nr TYPE zhro_request_nr.
    DATA lv_count TYPE int4.
  
    SELECT COUNT( * ) INTO lv_count FROM  zhro_request
       WHERE request_nr = wa_request-request_nr.
  
    IF lv_count EQ 0.
      MESSAGE 'Erro' TYPE 'E'.
      RETURN.
  
    ENDIF.
  
    DATA: fm_name TYPE rs38l_fnam.
  
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZHRO_LAGOSTIM_SMARTFORM'
  *     VARIANT            = ' '
  *     DIRECT_CALL        = ' '
      IMPORTING
        fm_name            = fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
  
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
  
  
    CALL FUNCTION fm_name
      EXPORTING
  *     ARCHIVE_INDEX    =
  *     ARCHIVE_INDEX_TAB          =
  *     ARCHIVE_PARAMETERS         =
  *     CONTROL_PARAMETERS         =
  *     MAIL_APPL_OBJ    =
  *     MAIL_RECIPIENT   =
  *     MAIL_SENDER      =
  *     OUTPUT_OPTIONS   =
        user_settings    = 'X'
        i_request_nr     = wa_request-request_nr
  * IMPORTING
  *     DOCUMENT_OUTPUT_INFO       =
  *     JOB_OUTPUT_INFO  =
  *     JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
  * Implement suitable error handling here
    ENDIF.
  
  ENDFORM.