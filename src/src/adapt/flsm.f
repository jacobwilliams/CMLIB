      REAL FUNCTION FLSM(S,CENTER,HWIDTH,X,M,MP,MAXORD,G,F,SUMCLS)
C
C***  FUNCTION TO COMPUTE FULLY SYMMETRIC BASIC RULE SUM
C
      INTEGER S, M(S), MP(S), MAXORD, SUMCLS, IXCHNG, LXCHNG, I, L,
     * IHALF, MPI, MPL
      REAL G(MAXORD), X(S), INTWGT, ZERO, ONE, TWO, INTSUM,
     * CENTER(S), HWIDTH(S)
      ZERO = 0
      ONE = 1
      TWO = 2
      INTWGT = ONE
      DO 10 I=1,S
        MP(I) = M(I)
        IF (M(I).NE.0) INTWGT = INTWGT/TWO
        INTWGT = INTWGT*HWIDTH(I)
   10 CONTINUE
      SUMCLS = 0
      FLSM = ZERO
C
C*******  COMPUTE CENTRALLY SYMMETRIC SUM FOR PERMUTATION MP
   20 INTSUM = ZERO
      DO 30 I=1,S
        MPI = MP(I) + 1
        X(I) = CENTER(I) + G(MPI)*HWIDTH(I)
   30 CONTINUE
   40 SUMCLS = SUMCLS + 1
      INTSUM = INTSUM + F(S,X)
      DO 50 I=1,S
        MPI = MP(I) + 1
        IF(G(MPI).NE.ZERO) HWIDTH(I) = -HWIDTH(I)
        X(I) = CENTER(I) + G(MPI)*HWIDTH(I)
        IF (X(I).LT.CENTER(I)) GO TO 40
   50 CONTINUE
C*******  END INTEGRATION LOOP FOR MP
C
      FLSM = FLSM + INTWGT*INTSUM
      IF (S.EQ.1) RETURN
C
C*******  FIND NEXT DISTINCT PERMUTATION OF M AND LOOP BACK
C          TO COMPUTE NEXT CENTRALLY SYMMETRIC SUM
      DO 80 I=2,S
        IF (MP(I-1).LE.MP(I)) GO TO 80
        MPI = MP(I)
        IXCHNG = I - 1
        IF (I.EQ.2) GO TO 70
        IHALF = IXCHNG/2
        DO 60 L=1,IHALF
          MPL = MP(L)
          IMNUSL = I - L
          MP(L) = MP(IMNUSL)
          MP(IMNUSL) = MPL
          IF (MPL.LE.MPI) IXCHNG = IXCHNG - 1
          IF (MP(L).GT.MPI) LXCHNG = L
   60   CONTINUE
        IF (MP(IXCHNG).LE.MPI) IXCHNG = LXCHNG
   70   MP(I) = MP(IXCHNG)
        MP(IXCHNG) = MPI
        GO TO 20
   80 CONTINUE
C*****  END LOOP FOR PERMUTATIONS OF M AND ASSOCIATED SUMS
C
      RETURN
      END