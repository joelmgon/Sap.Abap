*&---------------------------------------------------------------------*
*&  Include           ZJG_PRO_REQUESTS_VIS04_TOP
*&---------------------------------------------------------------------*

*" classes
CLASS LCL_APP DEFINITION DEFERRED.

*" tabelas
TABLES: ZJG_TREQUEST,
        ZJG_TDISHES.

*" variaveis
DATA: GO_APP TYPE REF TO LCL_APP .

*" Mostrar a lista de preços
DATA GO_LISTA TYPE REF TO CL_SALV_TABLE.

" Tabela que tem os dados da base de dados e que quero inserir modificar ou eliminar linhas.
DATA GT_LISTA TYPE STANDARD TABLE OF ZJG_TREQUEST.


DATA GS_LINHA_INSERIR TYPE ZJG_TREQUEST.
DATA GS_LINHA_MODIFICAR TYPE ZJG_TREQUEST.
DATA GS_LINHA_ELIMINAR TYPE ZJG_TREQUEST.

DATA OK_CODE_MODIFICAR TYPE SYST_UCOMM.
DATA OK_CODE_CRIAR     TYPE SYST_UCOMM.

DATA GV_OK_CODE_900 TYPE SYST_UCOMM.

DATA GV_ERROR TYPE CHAR1.