* Concatenating String Fields

*   Variables
DATA: TITLE(15)        TYPE C VALUE 'Mr',
SURNAME(40)      TYPE C VALUE 'Joel',
FORNAME(40)      TYPE C VALUE 'Gonçalves',
SEP,
DESTINATION(250) TYPE C,
SPACE_NAME(50)   TYPE C VALUE 'MR             Joel      Gonçalves',
LEN              TYPE I,
SURNAME2(40),
EMPL_NUM(11).


*********************************
*Definition concatenate f1 f1 int dl [separated by sep].

CONCATENATE TITLE SURNAME SEP FORNAME INTO DESTINATION.
WRITE DESTINATION.
ULINE.

CONCATENATE TITLE SURNAME SEP FORNAME INTO DESTINATION SEPARATED BY SEP.
WRITE DESTINATION.
ULINE.

*********************************
*Condensing character String
*Definition: condense c [No-Gats].

*   define espace in string
CONDENSE SPACE_NAME.
WRITE SPACE_NAME.
ULINE.

*   remove space in string
CONDENSE SPACE_NAME NO-GAPS.
WRITE SPACE_NAME.
ULINE.

********************************
*  Find the Length of a String

LEN = STRLEN( SURNAME ).
WRITE: 'Len SURNAME', LEN.
ULINE.

********************************
*  Replace Character String

SURNAME2 = 'Mr, JOe, Marco,,,,,,'.
WHILE SY-SUBRC = 0.
REPLACE ',' WITH '.' INTO SURNAME2.
ENDWHILE.
WRITE SURNAME2.
ULINE.

********************************
*  Searching for Specific Characters
SURNAME2 = 'Mr JOe Marco'.
SEARCH SURNAME2 FOR 'JOe'.
WRITE:/ 'Searching "Mr JOe Marco"'.
SKIP.

*  Blank space are ignored
SEARCH SURNAME2 FOR 'JOe     '.
WRITE:/ 'Searching "JOe     "'.
WRITE:/ 'SY-SUBRC', SY-SUBRC, / 'SY-FDPOS', SY-FDPOS.
ULINE.

*  Blank space are taken into account
SEARCH SURNAME2 FOR '.JOe     .'.
WRITE:/ 'Searching ".JOe     ."'.
WRITE:/ 'SY-SUBRC', SY-SUBRC, / 'SY-FDPOS', SY-FDPOS.
ULINE.
*  wild card search - word ending 'mit'
SEARCH SURNAME2 FOR '*rco'.
WRITE:/ 'Searching "*rco"'.
WRITE:/ 'SY-SUBRC', SY-SUBRC, / 'SY-FDPOS', SY-FDPOS.
ULINE.
*  wild card search - word ending 'mit'
SEARCH SURNAME2 FOR '*Mar'.
WRITE:/ 'Searching "*Mar"'.
WRITE:/ 'SY-SUBRC', SY-SUBRC, / 'SY-FDPOS', SY-FDPOS.
ULINE.

********************************
*  SHIFT Statement

EMPL_NUM = '00000102500'.
WRITE:/ 'SHIFT Statement: ' ,/ EMPL_NUM.
SKIP.
SHIFT EMPL_NUM LEFT DELETING LEADING '0'.
WRITE:/ 'LEFT DELETING LEADING', EMPL_NUM.
ULINE.

EMPL_NUM = '00000102500'.
SHIFT EMPL_NUM.
WRITE:/ 'SHIFT', EMPL_NUM.

EMPL_NUM = '00000102500'.
SHIFT EMPL_NUM CIRCULAR.
WRITE EMPL_NUM.
ULINE.

********************************
*  Split Statement - Spliting character String

DATA: MYSTRING(35) TYPE C,
A1(15)       TYPE C,
A2(15)       TYPE C,
A3(15)       TYPE C,
SEP2(2)      TYPE C VALUE '**'.


WRITE / 'Spliting character String'.
*  MYSTRING = ' 102596** Joel **00'.
MYSTRING = ' 102500** Joel **00**00'.
WRITE / MYSTRING.
SKIP.

SPLIT MYSTRING AT SEP2 INTO A1 A2 A3.
WRITE / A1.
WRITE / A2.
WRITE / A3.

ULINE.

********************************
*  SubFields Contact

DATA: INT_TELEPHONE_NUM(15) TYPE C,
COUNTRY_CODE(4)       TYPE C,
TELEPHONE_NUM(9)      TYPE C.

INT_TELEPHONE_NUM = '+351 960000001'.
CONDENSE INT_TELEPHONE_NUM NO-GAPS.
WRITE INT_TELEPHONE_NUM.
SKIP.

COUNTRY_CODE = INT_TELEPHONE_NUM(4).
TELEPHONE_NUM = INT_TELEPHONE_NUM+4(9).
WRITE / COUNTRY_CODE.
WRITE / TELEPHONE_NUM.

COUNTRY_CODE+1(3) = '999'.
WRITE / COUNTRY_CODE.