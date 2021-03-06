      DOUBLE PRECISION FUNCTION DCOT(X)
C***BEGIN PROLOGUE  DCOT
C***DATE WRITTEN   770601   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  C4A
C***KEYWORDS  COTANGENT,DEGREE,DOUBLE PRECISION,ELEMENTARY FUNCTION,
C             TRIGONOMETRIC COSINE
C***AUTHOR  FULLERTON, W., (LANL)
C***PURPOSE  Computes the d.p. Cotangent.
C***DESCRIPTION
C
C DCOT(X) calculates the double precision trigonometric cotangent
C for double precision argument X.  X is in units of radians.
C
C Series for COT        on the interval  0.          to  6.25000E-02
C                                        with weighted error   5.52E-34
C                                         log weighted error  33.26
C                               significant figures required  32.34
C                                    decimal places required  33.85
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH,DCSEVL,DINT,INITDS,XERROR
C***END PROLOGUE  DCOT
      DOUBLE PRECISION X, COTCS(15), AINTY, AINTY2, PI2REC, SQEPS,
     1  XMAX, XMIN, XSML, Y, YREM, PRODBG,  DINT, DCSEVL, D1MACH
      DATA COT CS(  1) / +.2402591609 8295630250 9553617744 970 D+0    /
      DATA COT CS(  2) / -.1653303160 1500227845 4746025255 758 D-1    /
      DATA COT CS(  3) / -.4299839193 1724018935 6476228239 895 D-4    /
      DATA COT CS(  4) / -.1592832233 2754104602 3490851122 445 D-6    /
      DATA COT CS(  5) / -.6191093135 1293487258 8620579343 187 D-9    /
      DATA COT CS(  6) / -.2430197415 0726460433 1702590579 575 D-11   /
      DATA COT CS(  7) / -.9560936758 8000809842 7062083100 000 D-14   /
      DATA COT CS(  8) / -.3763537981 9458058041 6291539706 666 D-16   /
      DATA COT CS(  9) / -.1481665746 4674657885 2176794666 666 D-18   /
      DATA COT CS( 10) / -.5833356589 0366657947 7984000000 000 D-21   /
      DATA COT CS( 11) / -.2296626469 6464577392 8533333333 333 D-23   /
      DATA COT CS( 12) / -.9041970573 0748332671 9999999999 999 D-26   /
      DATA COT CS( 13) / -.3559885519 2060006400 0000000000 000 D-28   /
      DATA COT CS( 14) / -.1401551398 2429866666 6666666666 666 D-30   /
      DATA COT CS( 15) / -.5518004368 7253333333 3333333333 333 D-33   /
      DATA PI2REC / .01161977236 7581343075 5350534900 57 D0 /
      DATA NTERMS, XMAX, XSML, XMIN, SQEPS /0, 4*0.D0 /
C***FIRST EXECUTABLE STATEMENT  DCOT
      IF (NTERMS.NE.0) GO TO 10
      NTERMS = INITDS (COTCS, 15, 0.1*SNGL(D1MACH(3)) )
      XMAX = 1.0D0/D1MACH(4)
      XSML = DSQRT (3.0D0*D1MACH(3))
      XMIN = DEXP (DMAX1(DLOG(D1MACH(1)), -DLOG(D1MACH(2))) + 0.01D0)
      SQEPS = DSQRT (D1MACH(4))
C
 10   Y = DABS(X)
      IF (Y.LT.XMIN) CALL XERROR (  'DCOT    DABS(X) IS ZERO OR SO SMALL
     1 DCOT OVERFLOWS', 50, 2, 2)
      IF (Y.GT.XMAX) CALL XERROR ( 'DCOT    NO PRECISION BECAUSE DABS(X)
     1 IS BIG', 43, 3, 2)
C
C CAREFULLY COMPUTE Y * (2/PI) = (AINT(Y) + REM(Y)) * (.625 + PI2REC)
C = AINT(.625*Y) + REM(.625*Y) + Y*PI2REC  =  AINT(.625*Y) + Z
C = AINT(.625*Y) + AINT(Z) + REM(Z)
C
      AINTY = DINT (Y)
      YREM = Y - AINTY
      PRODBG = 0.625D0*AINTY
      AINTY = DINT (PRODBG)
      Y = (PRODBG-AINTY) + 0.625D0*YREM + PI2REC*Y
      AINTY2 = DINT (Y)
      AINTY = AINTY + AINTY2
      Y = Y - AINTY2
C
      IFN = DMOD (AINTY, 2.0D0)
      IF (IFN.EQ.1) Y = 1.0D0 - Y
C
      IF (DABS(X).GT.0.5D0 .AND. Y.LT.DABS(X)*SQEPS) CALL XERROR ( 'DCOT
     1    ANSWER LT HALF PRECISION, ABS(X) TOO BIG OR X NEAR N*PI (N.NE.
     20)', 72, 1, 1)
C
      IF (Y.GT.0.25D0) GO TO 20
      DCOT = 1.0D0/X
      IF (Y.GT.XSML) DCOT = (0.5D0 + DCSEVL (32.0D0*Y*Y-1.D0, COTCS,
     1  NTERMS)) / Y
      GO TO 40
C
 20   IF (Y.GT.0.5D0) GO TO 30
      DCOT = (0.5D0 + DCSEVL (8.D0*Y*Y-1.D0, COTCS, NTERMS))/(0.5D0*Y)
      DCOT = (DCOT*DCOT-1.D0)*0.5D0/DCOT
      GO TO 40
C
 30   DCOT = (0.5D0 + DCSEVL (2.D0*Y*Y-1.D0, COTCS, NTERMS))/(.25D0*Y)
      DCOT = (DCOT*DCOT-1.D0)*0.5D0/DCOT
      DCOT = (DCOT*DCOT-1.D0)*0.5D0/DCOT
C
 40   IF (X.NE.0.D0) DCOT = DSIGN (DCOT, X)
      IF (IFN.EQ.1) DCOT = -DCOT
C
      RETURN
      END
