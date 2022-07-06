*&---------------------------------------------------------------------*
*&  Include           ZABAP_SEND_EMAIL_CLASS_RP_CLS
*&---------------------------------------------------------------------*


CLASS lcl_email DEFINITION FINAL.

    PUBLIC SECTION.
  
      METHODS send_email IMPORTING iv_sender_email   TYPE string
                                   it_receiver_email TYPE string_table
                                   iv_subject        TYPE string
                                   it_text           TYPE soli_tab.
      .
  
  ENDCLASS.
  
  
  CLASS lcl_email IMPLEMENTATION.
  
    METHOD send_email.
  
  
      DATA lx_send_req_bcs  TYPE REF TO cx_send_req_bcs .
  
      DATA lo_send_email TYPE REF TO  cl_bcs.
  
  
  *" Criar a instância do objecto que envia o email
      TRY.
          CALL METHOD cl_bcs=>create_persistent
            RECEIVING
              result = lo_send_email.
        CATCH cx_send_req_bcs INTO lx_send_req_bcs.
          WRITE:/ lx_send_req_bcs->get_text( ).
          RETURN.
      ENDTRY.
  
  
  *" Criar o objeto do remetente
      DATA lv_sender_email TYPE adr6-smtp_addr.
      DATA lo_sender TYPE REF TO cl_cam_address_bcs.
  
  
      lv_sender_email = iv_sender_email. "'no-replay@pt.softinsa.com'.
      TRY.
  
          CALL METHOD cl_cam_address_bcs=>create_internet_address
            EXPORTING
              i_address_string = lv_sender_email
            RECEIVING
              result           = lo_sender.
        CATCH cx_address_bcs INTO DATA(lx_address_bcs) .
          WRITE:/ lx_address_bcs->get_text( ).
          RETURN.
  
      ENDTRY.
  
  
  *" Associa o objeto lo_sender para o remetente no objeto principal lo_send_email
      lo_send_email->set_sender( lo_sender ).
  
  
  *" Criar o objeto do destinatário
      DATA lv_receiver_email TYPE adr6-smtp_addr.
      DATA lo_receiver TYPE REF TO cl_cam_address_bcs.
  
      LOOP AT it_receiver_email INTO lv_receiver_email.
  *    lv_receiver_email = it_receiver_email. "'nuno.jose.rodrigues@pt.softinsa.com'.
  
        TRY.
  
            CALL METHOD cl_cam_address_bcs=>create_internet_address
              EXPORTING
                i_address_string = lv_receiver_email
              RECEIVING
                result           = lo_receiver.
          CATCH cx_address_bcs INTO lx_address_bcs .
            WRITE:/ lx_address_bcs->get_text( ).
            RETURN.
  
        ENDTRY.
  
  
  *" Associa o objeto lo_receiver para o destinatário no objeto principal lo_send_email
        lo_send_email->add_recipient( i_recipient = lo_receiver ). "I_EXPRESS = 'X' ).
  
      ENDLOOP.
  
  *" Criar o corpo do email
  
      DATA lv_type  TYPE so_obj_tp.
      DATA lv_subject  TYPE so_obj_des.
  
      DATA lo_document  TYPE REF TO cl_document_bcs.
  
  
      lv_type  = 'RAW'.
      lv_subject = iv_subject. "'Primeiro email'.
  
  
  
      TRY.
  
          CALL METHOD cl_document_bcs=>create_document
            EXPORTING
              i_type    = lv_type
              i_subject = lv_subject
              i_text    = it_text           " lt_text
            RECEIVING
              result    = lo_document.
  
        CATCH cx_document_bcs INTO DATA(lx_document_bcs).
  
          WRITE:/ lx_document_bcs->get_text( ).
          RETURN.
  
      ENDTRY.
  
  *" Associar o corpo do email ao objeto que envia o email lo_send_email
  
      TRY.
  
          CALL METHOD lo_send_email->set_document
            EXPORTING
              i_document = lo_document.
  
        CATCH cx_send_req_bcs INTO lx_send_req_bcs.
          WRITE:/ lx_send_req_bcs->get_text( ).
          RETURN.
      ENDTRY.
  
  
  *" Enviar o email.
      DATA lv_send_result  TYPE os_boolean.
  
      TRY.
  
          CALL METHOD lo_send_email->send
  *  EXPORTING
  *    i_with_error_screen = SPACE
            RECEIVING
              result = lv_send_result.
  
        CATCH cx_send_req_bcs INTO lx_send_req_bcs.
          WRITE:/ lx_send_req_bcs->get_text( ).
          RETURN.
      ENDTRY.
  
  
  
  *" commit work.
      COMMIT WORK.
  
  
      CLEAR: lo_sender, lo_receiver, lo_send_email.
  
  
  
  
  
    ENDMETHOD.
  
  ENDCLASS.