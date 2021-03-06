      SUBROUTINE DPPQAD(LDC,C,XI,LXI,K,X1,X2,PQUAD)
C***BEGIN PROLOGUE  DPPQAD
C***DATE WRITTEN   800901   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***CATEGORY NO.  H2A2A1,E3,K6
C***KEYWORDS  B-SPLINE,DATA FITTING,DOUBLE PRECISION,INTERPOLATION,
C             QUADRATURE,SPLINE
C***AUTHOR  AMOS, D. E., (SNLA)
C***PURPOSE  Computes the integral on (X1,X2) of a K-th order B-spline
C            using the piecewise polynomial representation.
C***DESCRIPTION
C
C     Written by D. E. Amos, June, 1979.
C
C     Reference SAND-79-1825
C
C     Abstract    **** a double precision routine ****
C
C         DPPQAD computes the integral on (X1,X2) of a K-th order
C         B-spline using the piecewise polynomial representation
C         (C,XI,LXI,K).  Here the Taylor expansion about the left
C         end point XI(J) of the J-th interval is integrated and
C         evaluated on subintervals of (X1,X2) which are formed by
C         included break points.  Integration outside (XI(1),XI(LXI+1))
C         is permitted.
C
C         DPPQAD calls DINTRV
C
C     Description of Arguments
C         Input      C,XI,X1,X2 are double precision
C           LDC    - leading dimension of matrix C, LDC .GE. K
C           C(I,J) - right Taylor derivatives at XI(J), I=1,K , J=1,LXI
C           XI(*)  - break point array of length LXI+1
C           LXI    - number of polynomial pieces
C           K      - order of B-spline, K .GE. 1
C           X1,X2  - end points of quadrature interval, normally in
C                    XI(1) .LE. X .LE. XI(LXI+1)
C
C         Output     PQUAD is double precision
C           PQUAD  - integral of the PP representation over (X1,X2)
C
C     Error Conditions
C         Improper input is a fatal error
C***REFERENCES  D.E. AMOS, *QUADRATURE SUBROUTINES FOR SPLINES AND
C                 B-SPLINES*, SAND79-1825, SANDIA LABORATORIES,
C                 DECEMBER 1979.
C***ROUTINES CALLED  DINTRV,XERROR
C***END PROLOGUE  DPPQAD
C
C
      INTEGER I, II, IL, ILO, IL1, IL2, IM, K, LDC, LEFT, LXI, MF1, MF2
      DOUBLE PRECISION A,AA,BB,C,DX,FLK,PQUAD,Q,S,SS,TA,TB,X,XI,X1,X2
      DIMENSION XI(*), C(LDC,*), SS(2)
C
C***FIRST EXECUTABLE STATEMENT  DPPQAD
      PQUAD = 0.0D0
      IF(K.LT.1) GO TO 100
      IF(LXI.LT.1) GO TO 105
      IF(LDC.LT.K) GO TO 110
      AA = DMIN1(X1,X2)
      BB = DMAX1(X1,X2)
      IF (AA.EQ.BB) RETURN
      ILO = 1
      CALL DINTRV(XI, LXI, AA, ILO, IL1, MF1)
      CALL DINTRV(XI, LXI, BB, ILO, IL2, MF2)
      Q = 0.0D0
      DO 40 LEFT=IL1,IL2
        TA = XI(LEFT)
        A = DMAX1(AA,TA)
        IF (LEFT.EQ.1) A = AA
        TB = BB
        IF (LEFT.LT.LXI) TB = XI(LEFT+1)
        X = DMIN1(BB,TB)
        DO 30 II=1,2
          SS(II) = 0.0D0
          DX = X - XI(LEFT)
          IF (DX.EQ.0.0D0) GO TO 20
          S = C(K,LEFT)
          FLK = DBLE(FLOAT(K))
          IM = K - 1
          IL = IM
          DO 10 I=1,IL
            S = S*DX/FLK + C(IM,LEFT)
            IM = IM - 1
            FLK = FLK - 1.0D0
   10     CONTINUE
          SS(II) = S*DX
   20     CONTINUE
          X = A
   30   CONTINUE
        Q = Q + (SS(1)-SS(2))
   40 CONTINUE
      IF (X1.GT.X2) Q = -Q
      PQUAD = Q
      RETURN
C
C
  100 CONTINUE
      CALL XERROR( ' DPPQAD,  K DOES NOT SATISFY K.GE.1', 35, 2, 1)
      RETURN
  105 CONTINUE
      CALL XERROR( ' DPPQAD,  LXI DOES NOT SATISFY LXI.GE.1', 39, 2, 1)
      RETURN
  110 CONTINUE
      CALL XERROR( ' DPPQAD,  LDC DOES NOT SATISFY LDC.GE.K', 39, 2, 1)
      RETURN
      END
