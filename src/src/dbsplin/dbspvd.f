      SUBROUTINE DBSPVD(T,K,NDERIV,X,ILEFT,LDVNIK,VNIKX,WORK)
C***BEGIN PROLOGUE  DBSPVD
C***DATE WRITTEN   800901   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***CATEGORY NO.  E3,K6
C***KEYWORDS  B-SPLINE,DATA FITTING,DOUBLE PRECISION,INTERPOLATION,
C             SPLINE
C***AUTHOR  AMOS, D. E., (SNLA)
C***PURPOSE  Calculates the value and all derivatives of order less than
C            NDERIV of all basis functions which do not vanish at X.
C***DESCRIPTION
C
C     Written by Carl de Boor and modified by D. E. Amos
C
C     Reference
C         SIAM J. Numerical Analysis, 14, No. 3, June, 1977, pp.441-472.
C
C     Abstract    **** a double precision routine ****
C
C         DBSPVD is the BSPLVD routine of the reference.
C
C         DBSPVD calculates the value and all derivatives of order
C         less than NDERIV of all basis functions which do not
C         (possibly) vanish at X.  ILEFT is input such that
C         T(ILEFT) .LE. X .LT. T(ILEFT+1).  A call to INTRV(T,N+1,X,
C         ILO,ILEFT,MFLAG) will produce the proper ILEFT.  The output of
C         DBSPVD is a matrix VNIKX(I,J) of dimension at least (K,NDERIV)
C         whose columns contain the K nonzero basis functions and
C         their NDERIV-1 right derivatives at X, I=1,K, J=1,NDERIV.
C         These basis functions have indices ILEFT-K+I, I=1,K,
C         K .LE. ILEFT .LE. N.  The nonzero part of the I-th basis
C         function lies in (T(I),T(I+K)), I=1,N).
C
C         If X=T(ILEFT+1) then VNIKX contains left limiting values
C         (left derivatives) at T(ILEFT+1).  In particular, ILEFT = N
C         produces left limiting values at the right end point
C         X=T(N+1).  To obtain left limiting values at T(I), I=K+1,N+1,
C         set X= next lower distinct knot, call INTRV to get ILEFT,
C         set X=T(I), and then call DBSPVD.
C
C         DBSPVD calls DBSPVN
C
C     Description of Arguments
C         Input      T,X are double precision
C          T       - knot vector of length N+K, where
C                    N = number of B-spline basis functions
C                    N = sum of knot multiplicities-K
C          K       - order of the B-spline, K .GE. 1
C          NDERIV  - number of derivatives = NDERIV-1,
C                    1 .LE. NDERIV .LE. K
C          X       - argument of basis functions,
C                    T(K) .LE. X .LE. T(N+1)
C          ILEFT   - largest integer such that
C                    T(ILEFT) .LE. X .LT.  T(ILEFT+1)
C          LDVNIK  - leading dimension of matrix VNIKX
C
C         Output     VNIKX,WORK are double precision
C          VNIKX   - matrix of dimension at least (K,NDERIV) contain-
C                    ing the nonzero basis functions at X and their
C                    derivatives columnwise.
C          WORK    - a work vector of length (K+1)*(K+2)/2
C
C     Error Conditions
C         Improper input is a fatal error
C***REFERENCES  C. DE BOOR, *PACKAGE FOR CALCULATING WITH B-SPLINES*,
C                 SIAM JOURNAL ON NUMERICAL ANALYSIS, VOLUME 14, NO. 3,
C                 JUNE 1977, PP. 441-472.
C***ROUTINES CALLED  DBSPVN,XERROR
C***END PROLOGUE  DBSPVD
C
C
      INTEGER I,IDERIV,ILEFT,IPKMD,J,JJ,JLOW,JM,JP1MID,K,KMD, KP1, L,
     1 LDUMMY, M, MHIGH, NDERIV
      DOUBLE PRECISION FACTOR, FKMD, T, V, VNIKX, WORK, X
C     DIMENSION T(ILEFT+K), WORK((K+1)*(K+2)/2)
C     A(I,J) = WORK(I+J*(J+1)/2),  I=1,J+1  J=1,K-1
C     A(I,K) = W0RK(I+K*(K-1)/2)  I=1.K
C     WORK(1) AND WORK((K+1)*(K+2)/2) ARE NOT USED.
      DIMENSION T(*), VNIKX(LDVNIK,NDERIV), WORK(*)
C***FIRST EXECUTABLE STATEMENT  DBSPVD
      IF(K.LT.1) GO TO 200
      IF(NDERIV.LT.1 .OR. NDERIV.GT.K) GO TO 205
      IF(LDVNIK.LT.K) GO TO 210
      IDERIV = NDERIV
      KP1 = K + 1
      JJ = KP1 - IDERIV
      CALL DBSPVN(T, JJ, K, 1, X, ILEFT, VNIKX, WORK, IWORK)
      IF (IDERIV.EQ.1) GO TO 100
      MHIGH = IDERIV
      DO 20 M=2,MHIGH
        JP1MID = 1
        DO 10 J=IDERIV,K
          VNIKX(J,IDERIV) = VNIKX(JP1MID,1)
          JP1MID = JP1MID + 1
   10   CONTINUE
        IDERIV = IDERIV - 1
        JJ = KP1 - IDERIV
        CALL DBSPVN(T, JJ, K, 2, X, ILEFT, VNIKX, WORK, IWORK)
   20 CONTINUE
C
      JM = KP1*(KP1+1)/2
      DO 30 L = 1,JM
        WORK(L) = 0.0D0
   30 CONTINUE
C     A(I,I) = WORK(I*(I+3)/2) = 1.0       I = 1,K
      L = 2
      J = 0
      DO 40 I = 1,K
        J = J + L
        WORK(J) = 1.0D0
        L = L + 1
   40 CONTINUE
      KMD = K
      DO 90 M=2,MHIGH
        KMD = KMD - 1
        FKMD = FLOAT(KMD)
        I = ILEFT
        J = K
        JJ = J*(J+1)/2
        JM = JJ - J
        DO 60 LDUMMY=1,KMD
          IPKMD = I + KMD
          FACTOR = FKMD/(T(IPKMD)-T(I))
          DO 50 L=1,J
            WORK(L+JJ) = (WORK(L+JJ)-WORK(L+JM))*FACTOR
   50     CONTINUE
          I = I - 1
          J = J - 1
          JJ = JM
          JM = JM - J
   60   CONTINUE
C
        DO 80 I=1,K
          V = 0.0D0
          JLOW = MAX0(I,M)
          JJ = JLOW*(JLOW+1)/2
          DO 70 J=JLOW,K
            V = WORK(I+JJ)*VNIKX(J,M) + V
            JJ = JJ + J + 1
   70     CONTINUE
          VNIKX(I,M) = V
   80   CONTINUE
   90 CONTINUE
  100 RETURN
C
C
  200 CONTINUE
      CALL XERROR( ' DBSPVD,  K DOES NOT SATISFY K.GE.1', 35, 2, 1)
      RETURN
  205 CONTINUE
      CALL XERROR( ' DBSPVD,  NDERIV DOES NOT SATISFY 1.LE.NDERIV.LE.K',
     1 50, 2, 1)
      RETURN
  210 CONTINUE
      CALL XERROR( ' DBSPVD,  LDVNIK DOES NOT SATISFY LDVNIK.GE.K',45,
     1 2, 1)
      RETURN
      END
