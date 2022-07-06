*&---------------------------------------------------------------------*
*&  Include           ZHRO_LAGOSTIM_SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.



SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.

SELECT-OPTIONS: s_pltype FOR zhro_dishes-plate_type,
                   s_reqnr FOR zhro_request-request_nr.

SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN SKIP.


SELECTION-SCREEN:BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-s02,
   BEGIN OF LINE,
       PUSHBUTTON 12(10) TEXT-020 USER-COMMAND cli1,

END OF LINE.

PARAMETERS: p_reqnr  TYPE zhro_request-request_nr,
            p_pltype TYPE zhro_request-plate_type,
            p_qntity TYPE zhro_request-quantity,
            p_curr   TYPE zhro_request-currency.

SELECTION-SCREEN:END OF BLOCK b2.


AT SELECTION-SCREEN.

  CASE sscrfields.

    WHEN 'CLI1'.
      PERFORM insert_data.
*      rs_selfield-refresh = 'X'.
  ENDCASE.