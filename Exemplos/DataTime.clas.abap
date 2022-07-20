DATA AUFK TYPE ZJG_EMPLOYEES.
*DATA AND TIME FIELDS: FORMATE: YYYYMMDD INITIAL VALUE '00000000'

    DATA MY_DATE TYPE D VALUE '20220120'.
    DATA MY_DATE2 TYPE SY-DATUM.

********************************


*Time Fields: formate: HHMMSS initial value '000000'

    DATA MY_TIME TYPE T VALUE '111015'.
    DATA MY_TIME2 TYPE SY-UZEIT.

********************************
* Test Date & Time Fields Output

    WRITE: MY_DATE,
          / MY_DATE2,
          / MY_TIME,
          / MY_TIME2.
    ULINE.


**********Teste Date & time Calculations *********

    DATA EMP1_SDATE   TYPE D.
    DATA TODAYS_DATE  TYPE D.
    DATA LOS          TYPE I.
    DATA DAYS_COUNT   TYPE I.
    DATA FUT_DATE     TYPE D.

    DATA CLOCK_IN     TYPE T.
    DATA CLOCK_OUT    TYPE T.
    DATA SECONDS_DIFF TYPE I.
    DATA MINUTES_DIFF TYPE I.
    DATA HOURSS_DIFF  TYPE P DECIMALS 2.

*Curruncy  & quality fields
*Field for Currency Calculations
************************************
    DATA MY_SALARY TYPE  ZJG_EMPLOYEES-SALARY.
    DATA MY_TAX_AMT TYPE  ZJG_EMPLOYEES-SALARY.
    DATA MY_NET_PAY TYPE  ZJG_EMPLOYEES-SALARY.
    DATA TAX_PERC TYPE P DECIMALS 2.

*************************************************
    EMP1_SDATE = '20220701'.
    TODAYS_DATE = SY-DATUM.
    LOS = TODAYS_DATE - EMP1_SDATE + 1 .
    WRITE: SY-DATUM, EMP1_SDATE, LOS.
    ULINE.

******************************* sumar numero de dias a data atual.
    TODAYS_DATE = SY-DATUM.
    DAYS_COUNT = 31.
    FUT_DATE  = TODAYS_DATE + DAYS_COUNT.
    WRITE: 'Data Atual: ', SY-DATUM, 'Data Calculada: ', FUT_DATE.
    ULINE.

******************************* data do ultimo dia do mês anterior.
    TODAYS_DATE = SY-DATUM.
    TODAYS_DATE+6(2) = '01'.
    TODAYS_DATE = TODAYS_DATE - 1.
    WRITE: 'Data Atual: ', SY-DATUM, 'Data Calculada: ', TODAYS_DATE.
    ULINE.

******************************* Time seconds, minutes, hours to 60 calculations
    CLOCK_IN = '073000'.
    CLOCK_OUT = '160000'.
    SECONDS_DIFF = CLOCK_OUT - CLOCK_IN.
    WRITE: 'CLOCK_IN: ',CLOCK_IN, 'CLOCK_OUT: ',CLOCK_OUT,'CLOCK_OUT - CLOCK_INS: ',SECONDS_DIFF.
    ULINE.

    MINUTES_DIFF = SECONDS_DIFF / 60.
    WRITE: 'MINUTES_DIFF: ',MINUTES_DIFF, 'M'.
    ULINE.

    HOURSS_DIFF = MINUTES_DIFF / 60.
    WRITE: 'HOURSS_DIFF: ',HOURSS_DIFF, 'H'.
    ULINE.

***************************************
****************** Currency calculations

    TAX_PERC = '0.20'. "%
    SELECT * FROM ZJG_EMPLOYEES INTO CORRESPONDING FIELDS OF AUFK..
      WRITE:/'SURNAME: ',ZJG_EMPLOYEES-SURNAME,'SALARY: ', ZJG_EMPLOYEES-SALARY, ZJG_EMPLOYEES-ECURRENCY.

      MY_TAX_AMT = TAX_PERC * ZJG_EMPLOYEES-SALARY. "taxa * salario
      MY_NET_PAY = ZJG_EMPLOYEES-SALARY - MY_TAX_AMT. " salario - valor imposto
      WRITE:/'MY_TAX_AMT 20%', MY_TAX_AMT,ZJG_EMPLOYEES-ECURRENCY, 'MY_NET_PAY ',MY_NET_PAY, ZJG_EMPLOYEES-ECURRENCY.
      SKIP.

    ENDSELECT.

    ULINE.