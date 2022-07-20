DATA WA_EMPLOYEES TYPE ZJG_EMPLOYEES.

***** select, selecionar registos nas tabelas
***** insert, inser registos nas tabelas
***** update, modificar registos existentes na tabela
***** modify, modificar registos existentes na tabela e se nao existir cria-o
***** delete, eliminar registos das tabelas
***** sy-SUBRC = 0 " verifica se a acao foi feita com sucess

************************************** INSERT ****************

  WA_EMPLOYEES-EMPLOYEE = '10000007'.
  WA_EMPLOYEES-SURNAME = 'Danielali'.
  WA_EMPLOYEES-FORENAME = 'Oliveira'.
  WA_EMPLOYEES-TITLE = 'MRS'.
  WA_EMPLOYEES-DOB = '16021994'.

  INSERT ZJG_EMPLOYEES FROM WA_EMPLOYEES.


  IF SY-SUBRC = 0.
    WRITE:/ 'Record Inserted Correctly'.
    COMMIT WORK.
  ELSE.
    WRITE:/ 'We have a retunr code of ', SY-SUBRC.
  ENDIF.



************************************** UPDATE ****************

  WA_EMPLOYEES-EMPLOYEE = '10000007'.
  WA_EMPLOYEES-SURNAME = 'Alice'.
  WA_EMPLOYEES-FORENAME = 'Moreira'.
  WA_EMPLOYEES-TITLE = 'AM'.
  WA_EMPLOYEES-DOB = '16021991'.

  UPDATE ZJG_EMPLOYEES FROM WA_EMPLOYEES.

  IF SY-SUBRC = 0.
    WRITE:/ 'Record updated Correctly'.
  ELSE.
    WRITE:/ 'We have a retunr code of ', SY-SUBRC.
  ENDIF.

************************************** MODIFY ****************

  WA_EMPLOYEES-EMPLOYEE = '10000007'.
  WA_EMPLOYEES-SURNAME = 'Pan'.
  WA_EMPLOYEES-FORENAME = 'Peter'.
  WA_EMPLOYEES-TITLE = 'AM'.
  WA_EMPLOYEES-DOB = '16021991'.

  MODIFY ZJG_EMPLOYEES FROM WA_EMPLOYEES.

  IF SY-SUBRC = 0.
    WRITE:/ 'Record Modified Correctly'.
  ELSE.
    WRITE:/ 'We have a retunr code of ', SY-SUBRC.
  ENDIF.
***********************************************

  CLEAR WA_EMPLOYEES.
  WA_EMPLOYEES-EMPLOYEE = '10000008'.
  WA_EMPLOYEES-SURNAME = 'Pan+1'.
  WA_EMPLOYEES-FORENAME = 'Peter +1'.
  WA_EMPLOYEES-TITLE = 'PP'.
  WA_EMPLOYEES-DOB = '16021991'.

  MODIFY ZJG_EMPLOYEES FROM WA_EMPLOYEES.


  IF SY-SUBRC = 0.
    WRITE:/ 'Record Modified Correctly'.
  ELSE.
    WRITE:/ 'We have a retunr code of ', SY-SUBRC.
  ENDIF.

************************************** DELETE ****************

  CLEAR WA_EMPLOYEES.
*  WA_EMPLOYEES-EMPLOYEE = '10000008'.
*  DELETE ZJG_EMPLOYEES FROM WA_EMPLOYEES.
  DELETE FROM ZJG_EMPLOYEES WHERE SURNAME = 'Pan'.

  IF SY-SUBRC = 0.
    WRITE:/ 'Record Deleted Correctly'.
  ELSE.
    WRITE:/ 'We have a retunr code of ', SY-SUBRC.
  ENDIF.
  CLEAR WA_EMPLOYEES.