      SUBROUTINE DPSIFN(X,N,KODE,M,ANS,NZ,IERR)
C***BEGIN PROLOGUE  DPSIFN
C***DATE WRITTEN   820601   (YYMMDD)
C***REVISION DATE  851111   (YYMMDD)
C***CATEGORY NO.  C7C
C***KEYWORDS  DERIVATIVES OF THE GAMMA FUNCTION,DOUBLE PRECISION,
C             GAMMA FUNCTION,POLYGAMMA FUNCTION,PSI FUNCTION
C***AUTHOR  AMOS, DONALD E., SANDIA NATIONAL LABORATORIES
C***PURPOSE  Compute derivatives of the PSI function.
C            (18 or fewer digits)
C***DESCRIPTION
C
C       **** Double Precision version of PSIFN ****
C         The following definitions are used in DPSIFN:
C
C      Definition 1
C         PSI(X) = d/dx (ln(GAMMA(X)), the first derivative of
C                  the log GAMMA function.
C      Definition 2
C                     K   K
C         PSI(K,X) = d /dx (PSI(X)), the K-th derivative of PSI(X).
C   ___________________________________________________________________
C      DPSIFN computes a sequence of SCALED derivatives of
C      the PSI function; i.e. for fixed X and M it computes
C      the M-member sequence
C
C                    ((-1)**(K+1)/GAMMA(K+1))*PSI(K,X)
C                       for K = N,...,N+M-1
C
C      where PSI(K,X) is as defined above.   For KODE=1, DPSIFN returns
C      the scaled derivatives as described.  KODE=2 is operative only
C      when K=0 and in that case DPSIFN returns -PSI(X) + LN(X).  That
C      is, the logarithmic behavior for large X is removed when KODE=2
C      and K=0.  When sums or differences of PSI functions are computed
C      the logarithmic terms can be combined analytically and computed
C      separately to help retain significant digits.
C
C         Note that CALL DPSIFN(X,0,1,1,ANS) results in
C                   ANS = -PSI(X)
C
C     Input      X is DOUBLE PRECISION
C           X      - Argument, X .gt. 0.0D0
C           N      - First member of the sequence, 0 .le. N .le. 100
C                    N=0 gives ANS(1) = -PSI(X)       for KODE=1
C                                       -PSI(X)+LN(X) for KODE=2
C           KODE   - Selection parameter
C                    KODE=1 returns scaled derivatives of the PSI
C                    function.
C                    KODE=2 returns scaled derivatives of the PSI
C                    function EXCEPT when N=0. In this case,
C                    ANS(1) = -PSI(X) + LN(X) is returned.
C           M      - Number of members of the sequence, M.ge.1
C
C    Output     ANS is DOUBLE PRECISION
C           ANS    - A vector of length at least M whose first M
C                    components contain the sequence of derivatives
C                    scaled according to KODE.
C           NZ     - Underflow flag
C                    NZ.eq.0, A normal return
C                    NZ.ne.0, Underflow, last NZ components of ans are
C                             set to zero, ANS(M-K+1)=0.0, K=1,...,NZ
C           IERR   - Error flag
C                    IERR=0, A normal return, computation completed
C                    IERR=1, Input error,     no computation
C                    IERR=2, Overflow,        X too small or N+M-1 too
C                            large or both
C                    IERR=3, Error,           N too large. Dimensioned
C                            array TRMR(NMAX) is not large enough for N
C
C         The nominal computational accuracy is the maximum of unit
C         roundoff (=D1MACH(4)) and 1.0D-18 since critical constants
C         are given to only 18 digits.
C
C         PSIFN is the single precision version of DPSIFN.
C***LONG DESCRIPTION
C
C         The basic method of evaluation is the asymptotic expansion
C         for large X.ge.XMIN followed by backward recursion on a two
C         term recursion relation
C
C                  W(X+1) + X**(-N-1) = W(X).
C
C         This is supplemented by a series
C
C                  SUM( (X+K)**(-N-1) , K=0,1,2,... )
C
C         which converges rapidly for large N. Both XMIN and the
C         number of terms of the series are calculated from the unit
C         roundoff of the machine environment.
C***REFERENCES  HANDBOOK OF MATHEMATICAL FUNCTIONS, AMS 55, NATIONAL
C                 BUREAU OF STANDARDS BY M. ABRAMOWITZ AND I. A.
C                 STEGUN, 1964, PP.258-260, EQTNS. 6.3.5, 6.3.18, 6.4.6,
C                 6.4.9, 6.4.10
C               A PORTABLE FORTRAN SUBROUTINE FOR DERIVATIVES OF THE
C                 PSI FUNCTION BY D. E. AMOS, ACM TRANS. MATH SOFTWARE,
C                 1983, ALGORITHM 610
C***ROUTINES CALLED  D1MACH,I1MACH
C***END PROLOGUE  DPSIFN
      INTEGER I, IERR, J, K, KODE, M, MM, MX, N, NMAX, NN, NP, NX, NZ
      INTEGER I1MACH
      DOUBLE PRECISION ANS, ARG, B, DEN, ELIM, EPS, FLN, FN, FNP, FNS,
     * FX, RLN, RXSQ, R1M4, R1M5, S, SLOPE, T, TA, TK, TOL, TOLS, TRM,
     * TRMR, TSS, TST, TT, T1, T2, WDTOL, X, XDMLN, XDMY, XINC, XLN,
     * XM, XMIN, XQ, YINT
      DOUBLE PRECISION D1MACH
      DIMENSION B(22), TRM(22), TRMR(100), ANS(*)
      DATA NMAX /100/
C-----------------------------------------------------------------------
C             BERNOULLI NUMBERS
C-----------------------------------------------------------------------
      DATA B(1), B(2), B(3), B(4), B(5), B(6), B(7), B(8), B(9), B(10),
     * B(11), B(12), B(13), B(14), B(15), B(16), B(17), B(18), B(19),
     * B(20), B(21), B(22) /1.00000000000000000D+00,
     * -5.00000000000000000D-01,1.66666666666666667D-01,
     * -3.33333333333333333D-02,2.38095238095238095D-02,
     * -3.33333333333333333D-02,7.57575757575757576D-02,
     * -2.53113553113553114D-01,1.16666666666666667D+00,
     * -7.09215686274509804D+00,5.49711779448621554D+01,
     * -5.29124242424242424D+02,6.19212318840579710D+03,
     * -8.65802531135531136D+04,1.42551716666666667D+06,
     * -2.72982310678160920D+07,6.01580873900642368D+08,
     * -1.51163157670921569D+10,4.29614643061166667D+11,
     * -1.37116552050883328D+13,4.88332318973593167D+14,
     * -1.92965793419400681D+16/
C
C
C***FIRST EXECUTABLE STATEMENT  DPSIFN
      IERR = 0
      NZ=0
      IF (X.LE.0.0D0) IERR=1
      IF (N.LT.0) IERR=1
      IF (KODE.LT.1 .OR. KODE.GT.2) IERR=1
      IF (M.LT.1) IERR=1
      IF (IERR.NE.0) RETURN
      MM=M
      NX = MIN0(-I1MACH(15),I1MACH(16))
      R1M5 = D1MACH(5)
      R1M4 = D1MACH(4)*0.5D0
      WDTOL = DMAX1(R1M4,0.5D-18)
C-----------------------------------------------------------------------
C     ELIM = APPROXIMATE EXPONENTIAL OVER AND UNDERFLOW LIMIT
C-----------------------------------------------------------------------
      ELIM = 2.302D0*(DBLE(FLOAT(NX))*R1M5-3.0D0)
      XLN = DLOG(X)
   41 CONTINUE
      NN = N + MM - 1
      FN = DBLE(FLOAT(NN))
      FNP = FN + 1.0D0
      T = FNP*XLN
C-----------------------------------------------------------------------
C     OVERFLOW AND UNDERFLOW TEST FOR SMALL AND LARGE X
C-----------------------------------------------------------------------
      IF (DABS(T).GT.ELIM) GO TO 290
      IF (X.LT.WDTOL) GO TO 260
C-----------------------------------------------------------------------
C     COMPUTE XMIN AND THE NUMBER OF TERMS OF THE SERIES, FLN+1
C-----------------------------------------------------------------------
      RLN = R1M5*DBLE(FLOAT(I1MACH(14)))
      RLN = DMIN1(RLN,18.06D0)
      FLN = DMAX1(RLN,3.0D0) - 3.0D0
      YINT = 3.50D0 + 0.40D0*FLN
      SLOPE = 0.21D0 + FLN*(0.0006038D0*FLN+0.008677D0)
      XM = YINT + SLOPE*FN
      MX = INT(SNGL(XM)) + 1
      XMIN = DBLE(FLOAT(MX))
      IF (N.EQ.0) GO TO 50
      XM = -2.302D0*RLN - DMIN1(0.0D0,XLN)
      FNS = DBLE(FLOAT(N))
      ARG = XM/FNS
      ARG = DMIN1(0.0D0,ARG)
      EPS = DEXP(ARG)
      XM = 1.0D0 - EPS
      IF (DABS(ARG).LT.1.0D-3) XM = -ARG
      FLN = X*XM/EPS
      XM = XMIN - X
      IF (XM.GT.7.0D0 .AND. FLN.LT.15.0D0) GO TO 200
   50 CONTINUE
      XDMY = X
      XDMLN = XLN
      XINC = 0.0D0
      IF (X.GE.XMIN) GO TO 60
      NX = INT(SNGL(X))
      XINC = XMIN - DBLE(FLOAT(NX))
      XDMY = X + XINC
      XDMLN = DLOG(XDMY)
   60 CONTINUE
C-----------------------------------------------------------------------
C     GENERATE W(N+MM-1,X) BY THE ASYMPTOTIC EXPANSION
C-----------------------------------------------------------------------
      T = FN*XDMLN
      T1 = XDMLN + XDMLN
      T2 = T + XDMLN
      TK = DMAX1(DABS(T),DABS(T1),DABS(T2))
      IF (TK.GT.ELIM) GO TO 380
      TSS = DEXP(-T)
      TT = 0.5D0/XDMY
      T1 = TT
      TST = WDTOL*TT
      IF (NN.NE.0) T1 = TT + 1.0D0/FN
      RXSQ = 1.0D0/(XDMY*XDMY)
      TA = 0.5D0*RXSQ
      T = FNP*TA
      S = T*B(3)
      IF (DABS(S).LT.TST) GO TO 80
      TK = 2.0D0
      DO 70 K=4,22
        T = T*((TK+FN+1.0D0)/(TK+1.0D0))*((TK+FN)/(TK+2.0D0))*RXSQ
        TRM(K) = T*B(K)
        IF (DABS(TRM(K)).LT.TST) GO TO 80
        S = S + TRM(K)
        TK = TK + 2.0D0
   70 CONTINUE
   80 CONTINUE
      S = (S+T1)*TSS
      IF (XINC.EQ.0.0D0) GO TO 100
C-----------------------------------------------------------------------
C     BACKWARD RECUR FROM XDMY TO X
C-----------------------------------------------------------------------
      NX = INT(SNGL(XINC))
      NP = NN + 1
      IF (NX.GT.NMAX) GO TO 390
      IF (NN.EQ.0) GO TO 160
      XM = XINC - 1.0D0
      FX = X + XM
C-----------------------------------------------------------------------
C     THIS LOOP SHOULD NOT BE CHANGED. FX IS ACCURATE WHEN X IS SMALL
C-----------------------------------------------------------------------
      DO 90 I=1,NX
        TRMR(I) = FX**(-NP)
        S = S + TRMR(I)
        XM = XM - 1.0D0
        FX = X + XM
   90 CONTINUE
  100 CONTINUE
      ANS(MM) = S
      IF (FN.EQ.0.0D0) GO TO 180
C-----------------------------------------------------------------------
C     GENERATE LOWER DERIVATIVES, J.LT.N+MM-1
C-----------------------------------------------------------------------
      IF (MM.EQ.1) RETURN
      DO 150 J=2,MM
        FNP = FN
        FN = FN - 1.0D0
        TSS = TSS*XDMY
        T1 = TT
        IF (FN.NE.0.0D0) T1 = TT + 1.0D0/FN
        T = FNP*TA
        S = T*B(3)
        IF (DABS(S).LT.TST) GO TO 120
        TK = 3.0D0 + FNP
        DO 110 K=4,22
          TRM(K) = TRM(K)*FNP/TK
          IF (DABS(TRM(K)).LT.TST) GO TO 120
          S = S + TRM(K)
          TK = TK + 2.0D0
  110   CONTINUE
  120   CONTINUE
        S = (S+T1)*TSS
        IF (XINC.EQ.0.0D0) GO TO 140
        IF (FN.EQ.0.0D0) GO TO 160
        XM = XINC - 1.0D0
        FX = X + XM
        DO 130 I=1,NX
          TRMR(I) = TRMR(I)*FX
          S = S + TRMR(I)
          XM = XM - 1.0D0
          FX = X + XM
  130   CONTINUE
  140   CONTINUE
        MX = MM - J + 1
        ANS(MX) = S
        IF (FN.EQ.0.0D0) GO TO 180
  150 CONTINUE
      RETURN
C-----------------------------------------------------------------------
C     RECURSION FOR N = 0
C-----------------------------------------------------------------------
  160 CONTINUE
      DO 170 I=1,NX
        S = S + 1.0D0/(X+DBLE(FLOAT(NX-I)))
  170 CONTINUE
  180 CONTINUE
      IF (KODE.EQ.2) GO TO 190
      ANS(1) = S - XDMLN
      RETURN
  190 CONTINUE
      IF (XDMY.EQ.X) RETURN
      XQ = XDMY/X
      ANS(1) = S - DLOG(XQ)
      RETURN
C-----------------------------------------------------------------------
C     COMPUTE BY SERIES (X+K)**(-(N+1)) , K=0,1,2,...
C-----------------------------------------------------------------------
  200 CONTINUE
      NN = INT(SNGL(FLN)) + 1
      NP = N + 1
      T1 = (FNS+1.0D0)*XLN
      T = DEXP(-T1)
      S = T
      DEN = X
      DO 210 I=1,NN
        DEN = DEN + 1.0D0
        TRM(I) = DEN**(-NP)
        S = S + TRM(I)
  210 CONTINUE
      ANS(1) = S
      IF (N.NE.0) GO TO 220
      IF (KODE.EQ.2) ANS(1) = S + XLN
  220 CONTINUE
      IF (MM.EQ.1) RETURN
C-----------------------------------------------------------------------
C     GENERATE HIGHER DERIVATIVES, J.GT.N
C-----------------------------------------------------------------------
      TOL = WDTOL/5.0D0
      DO 250 J=2,MM
        T = T/X
        S = T
        TOLS = T*TOL
        DEN = X
        DO 230 I=1,NN
          DEN = DEN + 1.0D0
          TRM(I) = TRM(I)/DEN
          S = S + TRM(I)
          IF (TRM(I).LT.TOLS) GO TO 240
  230   CONTINUE
  240   CONTINUE
        ANS(J) = S
  250 CONTINUE
      RETURN
C-----------------------------------------------------------------------
C     SMALL X.LT.UNIT ROUND OFF
C-----------------------------------------------------------------------
  260 CONTINUE
      ANS(1) = X**(-N-1)
      IF (MM.EQ.1) GO TO 280
      K = 1
      DO 270 I=2,MM
        ANS(K+1) = ANS(K)/X
        K = K + 1
  270 CONTINUE
  280 CONTINUE
      IF (N.NE.0) RETURN
      IF (KODE.EQ.2) ANS(1) = ANS(1) + XLN
      RETURN
  290 CONTINUE
      IF (T.GT.0.0D0) GO TO 380
      NZ=0
      IERR=2
      RETURN
  380 CONTINUE
      NZ=NZ+1
      ANS(MM)=0.0D0
      MM=MM-1
      IF (MM.EQ.0) RETURN
      GO TO 41
  390 CONTINUE
      NZ=0
      IERR=3
      RETURN
      END
