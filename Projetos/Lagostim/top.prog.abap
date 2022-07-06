*&---------------------------------------------------------------------*
*&  Include           ZHRO_LAGOSTIM_TOP
*&---------------------------------------------------------------------*


TABLES: sscrfields.                                            "variavel para o case do botao inserir
TABLES: zhro_dishes.
TABLES: zhro_request.

TYPES: slis_t_extab TYPE slis_extab OCCURS 1.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_layout   TYPE slis_layout_alv,
      wa_fieldcat TYPE slis_fieldcat_alv,
      wa_request  TYPE zhro_request.


DATA: zhro_answer TYPE char1.


TYPES: BEGIN OF lty_request,
         request_nr    TYPE zhro_request-request_nr,
         plate_type    TYPE zhro_request-plate_type,
         description   TYPE zhro_dishes-description,
         quantity      TYPE zhro_request-quantity,
         request_value TYPE zhro_request-request_value,
         request_date  TYPE zhro_request-request_date,
         currency      TYPE zhro_request-currency,

       END OF lty_request.


DATA: gs_request TYPE lty_request.



DATA: it_req     TYPE STANDARD TABLE OF zhro_request,                               "MODIFY
      it_changes TYPE STANDARD TABLE OF zhro_request.

DATA: it_request TYPE TABLE OF zhro_request.


DATA: rs_selfield TYPE slis_selfield.                                               "REFRESH ALV