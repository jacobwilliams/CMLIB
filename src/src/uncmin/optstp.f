      SUBROUTINE OPTSTP(N,XPLS,FPLS,GPLS,X,ITNCNT,ICSCMX,
     +      ITRMCD,GRADTL,STEPTL,SX,FSCALE,ITNLIM,IRETCD,MXTAKE,IPR,MSG)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
C UNCONSTRAINED MINIMIZATION STOPPING CRITERIA
C --------------------------------------------
C FIND WHETHER THE ALGORITHM SHOULD TERMINATE, DUE TO ANY
C OF THE FOLLOWING:
C 1) PROBLEM SOLVED WITHIN USER TOLERANCE
C 2) CONVERGENCE WITHIN USER TOLERANCE
C 3) ITERATION LIMIT REACHED
C 4) DIVERGENCE OR TOO RESTRICTIVE MAXIMUM STEP (STEPMX) SUSPECTED
C
C
C PARAMETERS
C ----------
C N            --> DIMENSION OF PROBLEM
C XPLS(N)      --> NEW ITERATE X[K]
C FPLS         --> FUNCTION VALUE AT NEW ITERATE F(XPLS)
C GPLS(N)      --> GRADIENT AT NEW ITERATE, G(XPLS), OR APPROXIMATE
C X(N)         --> OLD ITERATE X[K-1]
C ITNCNT       --> CURRENT ITERATION K
C ICSCMX      <--> NUMBER CONSECUTIVE STEPS .GE. STEPMX
C                  [RETAIN VALUE BETWEEN SUCCESSIVE CALLS]
C ITRMCD      <--  TERMINATION CODE
C GRADTL       --> TOLERANCE AT WHICH RELATIVE GRADIENT CONSIDERED CLOSE
C                  ENOUGH TO ZERO TO TERMINATE ALGORITHM
C STEPTL       --> RELATIVE STEP SIZE AT WHICH SUCCESSIVE ITERATES
C                  CONSIDERED CLOSE ENOUGH TO TERMINATE ALGORITHM
C SX(N)        --> DIAGONAL SCALING MATRIX FOR X
C FSCALE       --> ESTIMATE OF SCALE OF OBJECTIVE FUNCTION
C ITNLIM       --> MAXIMUM NUMBER OF ALLOWABLE ITERATIONS
C IRETCD       --> RETURN CODE
C MXTAKE       --> BOOLEAN FLAG INDICATING STEP OF MAXIMUM LENGTH USED
C IPR          --> DEVICE TO WHICH TO SEND OUTPUT
C MSG          --> IF MSG INCLUDES A TERM 8, SUPPRESS OUTPUT
C
C
      INTEGER N,ITNCNT,ICSCMX,ITRMCD,ITNLIM
      DIMENSION SX(N)
      DIMENSION XPLS(N),GPLS(N),X(N)
      LOGICAL MXTAKE
C
      ITRMCD=0
C
C LAST GLOBAL STEP FAILED TO LOCATE A POINT LOWER THAN X
      IF(IRETCD.NE.1) GO TO 50
C     IF(IRETCD.EQ.1)
C     THEN
        JTRMCD=3
        GO TO 600
C     ENDIF
   50 CONTINUE
C
C FIND DIRECTION IN WHICH RELATIVE GRADIENT MAXIMUM.
C CHECK WHETHER WITHIN TOLERANCE
C
      D=MAX(ABS(FPLS),FSCALE)
      RGX=0.0
      DO 100 I=1,N
        RELGRD=ABS(GPLS(I))*MAX(ABS(XPLS(I)),1./SX(I))/D
        RGX=MAX(RGX,RELGRD)
  100 CONTINUE
      JTRMCD=1
      IF(RGX.LE.GRADTL) GO TO 600
C
      IF(ITNCNT.EQ.0) RETURN
C
C FIND DIRECTION IN WHICH RELATIVE STEPSIZE MAXIMUM
C CHECK WHETHER WITHIN TOLERANCE.
C
      RSX=0.0
      DO 120 I=1,N
        RELSTP=ABS(XPLS(I)-X(I))/MAX(ABS(XPLS(I)),1./SX(I))
        RSX=MAX(RSX,RELSTP)
  120 CONTINUE
      JTRMCD=2
      IF(RSX.LE.STEPTL) GO TO 600
C
C CHECK ITERATION LIMIT
C
      JTRMCD=4
      IF(ITNCNT.GE.ITNLIM) GO TO 600
C
C CHECK NUMBER OF CONSECUTIVE STEPS \ STEPMX
C
      IF(MXTAKE) GO TO 140
C     IF(.NOT.MXTAKE)
C     THEN
        ICSCMX=0
        RETURN
C     ELSE
  140   CONTINUE
        IF (MOD(MSG/8,2) .EQ. 0) WRITE(IPR,900)
        ICSCMX=ICSCMX+1
        IF(ICSCMX.LT.5) RETURN
        JTRMCD=5
C     ENDIF
C
C
C PRINT TERMINATION CODE
C
  600 ITRMCD=JTRMCD
      IF (MOD(MSG/8,2) .EQ. 0) GO TO(601,602,603,604,605), ITRMCD
      GO TO 700
  601 WRITE(IPR,901)
      GO TO 700
  602 WRITE(IPR,902)
      GO TO 700
  603 WRITE(IPR,903)
      GO TO 700
  604 WRITE(IPR,904)
      GO TO 700
  605 WRITE(IPR,905)
C
  700 RETURN
C
  900 FORMAT(48H0OPTSTP    STEP OF MAXIMUM LENGTH (STEPMX) TAKEN)
  901 FORMAT(43H0OPTSTP    RELATIVE GRADIENT CLOSE TO ZERO./
     +       48H OPTSTP    CURRENT ITERATE IS PROBABLY SOLUTION.)
  902 FORMAT(48H0OPTSTP    SUCCESSIVE ITERATES WITHIN TOLERANCE./
     +       48H OPTSTP    CURRENT ITERATE IS PROBABLY SOLUTION.)
  903 FORMAT(52H0OPTSTP    LAST GLOBAL STEP FAILED TO LOCATE A POINT,
     +       14H LOWER THAN X./
     +       51H OPTSTP    EITHER X IS AN APPROXIMATE LOCAL MINIMUM,
     +       17H OF THE FUNCTION,/
     +       50H OPTSTP    THE FUNCTION IS TOO NON-LINEAR FOR THIS,
     +       11H ALGORITHM,/
     +       34H OPTSTP    OR STEPTL IS TOO LARGE.)
  904 FORMAT(36H0OPTSTP    ITERATION LIMIT EXCEEDED./
     +       28H OPTSTP    ALGORITHM FAILED.)
  905 FORMAT(39H0OPTSTP    MAXIMUM STEP SIZE EXCEEDED 5,
     +       19H CONSECUTIVE TIMES./
     +       50H OPTSTP    EITHER THE FUNCTION IS UNBOUNDED BELOW,/
     +       47H OPTSTP    BECOMES ASYMPTOTIC TO A FINITE VALUE,
     +       30H FROM ABOVE IN SOME DIRECTION,/
     +       33H OPTSTP    OR STEPMX IS TOO SMALL)
      END
