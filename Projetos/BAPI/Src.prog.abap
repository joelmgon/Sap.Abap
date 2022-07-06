*&---------------------------------------------------------------------*
*&  Include           ZPACP_BAPI_SCREEN
*&---------------------------------------------------------------------*

TABLES: vbak.

SELECTION-SCREEN BEGIN OF BLOCK bloco01 WITH FRAME TITLE TEXT-001.

PARAMETERS: p_vkorg TYPE vkorg,
            p_kunnr TYPE kunnr.

SELECTION-SCREEN END OF BLOCK bloco01.