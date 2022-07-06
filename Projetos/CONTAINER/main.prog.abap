*&---------------------------------------------------------------------*
*& Report ZPACP_INTERFACES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpacp_container.

INCLUDE ZPACP_CONTAINER_TOP.
*INCLUDE zpacp_interface_top.
INCLUDE ZPACP_CONTAINER_MOD.
*INCLUDE zpacp_interface_mod. "pai e pbo
INCLUDE ZPACP_CONTAINER_FORM.
*INCLUDE zpacp_form. "elementos da tabela

START-OF-SELECTION.

PERFORM GET_DATA.

  "SELECT * FROM mara INTO TABLE it_mara UP TO 100 ROWS.

  CALL SCREEN '0400'.