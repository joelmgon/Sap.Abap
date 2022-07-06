*&---------------------------------------------------------------------*
*& Report ZABAP_SEND_EMAIL_CLASS_RP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_send_email_class_rp.

INCLUDE zabap_send_email_class_rp_cls.
*" Para enviar um email podemos usar a class cl_bcs.
*" 1 - Criamos uma instância da classe cl_bcs
*" 2 - Criamos o corpo do email (texto ou html) usando o método estático
*"     cl_document_bcs=>create_document

*" 3 - Criar os objetos que representam os endereços de email
*"     cl_cam_address_bcs=>create_internet_address

*" 4 - Associar o corpo do email à instância da classe cl_bcs
*"         método set_document da classe cl_bcs
*"         <obj>->set_document

*" 5 - Enviar o email usando o método send da classe cl_bcs
*"        <obj>->send

*" 6 - Fazer commit work
*"        COMMIT WORK


*" CRIAR UMA CLASSE COM UM MÉTODO (send_email) PARA EVIAR O EMAIL
*" COM OS PARÂMETROS:
*       remetente
*       destinatários (1 ou vários)
*       assunto (texto até 50 caracteres)
*       corpo ( tabela com texto )
* Pode retornar uma flag a indicar sucesso ou falhar.
* LCL_<user_name>_EMAIL.
* ZCL_<user_name>_EMAIL.

*CRiar um programa que usa a classe.
* Z<user_name>_SEND_EMAIL_RP
PARAMETERS: p_sender TYPE string.
PARAMETERS: p_receiv TYPE string.
PARAMETERS: p_recv2 TYPE string.
PARAMETERS: p_subjct TYPE string.

SELECTION-SCREEN SKIP 2.

PARAMETERS: p_body1 TYPE string.
PARAMETERS: p_body2 TYPE string.


INITIALIZATION.
  p_sender = 'no-reply@pt.softinsa.com'.


START-OF-SELECTION.




  DATA lo_email TYPE REF TO lcl_email.

  CREATE OBJECT lo_email.


  DATA lt_text  TYPE soli_tab.
  DATA ls_text TYPE soli.

  ls_text-line = p_body1.
  APPEND ls_text TO lt_text.

  ls_text-line = p_body2.
  APPEND ls_text TO lt_text.


  DATA lt_receivers TYPE string_table.

  APPEND p_receiv TO lt_receivers.

  APPEND p_recv2 TO lt_receivers.

  lo_email->send_email(
          EXPORTING
            iv_sender_email = p_sender
            it_receiver_email = lt_receivers
            iv_subject = p_subjct
            it_text = lt_text
            ).