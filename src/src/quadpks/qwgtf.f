      REAL FUNCTION QWGTF(X,OMEGA,P2,P3,P4,INTEGR)
C***BEGIN PROLOGUE  QWGTF
C***REFER TO  QK15W
C***ROUTINES CALLED  (NONE)
C***REVISION DATE  830518   (YYMMDD)
C***KEYWORDS  COS OR SIN IN WEIGHT FUNCTION
C***AUTHOR  PIESSENS, ROBERT, APPLIED MATH. AND PROGR. DIV. -
C             K. U. LEUVEN
C           DE DONCKER, ELISE, APPLIED MATH. AND PROGR. DIV. -
C             K. U. LEUVEN
C***PURPOSE  This function subprogram is used together with the
C            routine QAWF and defines the WEIGHT function.
C***END PROLOGUE  QWGTF
C
      REAL OMEGA,OMX,P2,P3,P4,X
      INTEGER INTEGR
C***FIRST EXECUTABLE STATEMENT  QWGTF
      OMX = OMEGA*X
      GO TO(10,20),INTEGR
   10 QWGTF = COS(OMX)
      GO TO 30
   20 QWGTF = SIN(OMX)
   30 RETURN
      END