      SUBROUTINE MIX(MM, M, N, A, CLAB, RLAB, TITLE, K, MXITER, NCOV,
     *               DMWORK, WORK1, DMWRK1, DMWRK2, WORK2, DMWRK3,
     *               WORK3, IWORK, IERR, OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      FITS THE MIXTURE MODEL BY A MAXIMUM LOG-LIKEHOOD CRITERION
C
C   DESCRIPTION
C   -----------
C
C   1.  THE DATA ARE ASSUMED TO BE A RANDOM SAMPLE OF SIZE M FROM A
C       MIXTURE OF K MULTIVARIATE NORMAL DISTRIBUTIONS IN N DIMENSIONS.
C       THE PROBABILITY THAT THE J-TH OBSERVATION WAS DRAWN FROM THE
C       I-TH NORMAL FOR J=1,...,M I=1,...,K IS USED TO ESTIMATE WHICH
C       NORMAL EACH OBSERVATION WAS SAMPLED FROM, AND HENCE GROUP THE
C       OBSERVATIONS INTO K CLUSTERS.  THE CRITERION TO BE MAXIMIZED IS
C       THE LOG LIKELIHOOD
C
C             SUM LOG(G(I)) OVER I=1,...,M
C
C       WHERE G(I) IS THE PROBABILITY DENSITY OF THE I-TH OBSERVATION.
C
C       SEE PAGE 116 OF THE REFERENCE FOR A FURTHER DESCRIPTION OF G.
C
C   2.  THE MANY PARAMETERS PRESENT IN THE BETWEEN-NORMAL COVARIANCE
C       MATRICES REQUIRE MUCH DATA FOR THEIR ESTIMATION.  A RULE OF
C       THUMB IS THAT M SHOULD BE GREATER THAN (N+1)(N+2)K/2.  EVEN
C       WITH MANY OBSERVATIONS, THE PROCEDURE IS VULNERABLE TO
C       NONNORMALITY OR LINEAR DEPENDENCE AMONG THE VARIABLES.  TO
C       REDUCE THIS SENSITIVITY ONE CAN MAKE ASSUMPTIONS ON THESE
C       COVARIANCE MATRICES BY SETTING THE NCOV PARAMETER TO:
C
C       1  IF THE COVARIANCE MATRICES ARE ARBITRARY
C       2  IF THE COVARIANCE MATRICES IN DIFFERENT NORMALS ARE EQUAL
C       3  IF THE COVARIANCE MATRICES ARE EQUAL AND DIAGONAL
C       4  IF ALL VARIABLES HAVE THE SAME VARIANCE AND ARE PAIRWISE
C             INDEPENDENT
C
C   3.  AFTER EVERY 5 ITERATIONS, THE CLUSTER PROBABILITIES, MEANS, AND
C       DETERMINANTS OF COVARIANCE MATRICES ARE PRINTED OUT.  ALSO, THE
C       WITHIN-CLUSTER VARIANCES AND CORRELATIONS FOR EVERY PAIR OF
C       VARIABLES FOR EACH CLUSTER, AND FINALLY EVERY OBSERVATION AND
C       ITS BELONGING PROBABILILTY FOR EACH CLUSTER IS PRINTED.  THE
C       LOG LIKELIHOOD IS PRINTED AFTER EACH ITERATION.  THE ITERATIONS
C       STOP EITHER AFTER THE MAXIMUM NUMBER OF ITERATIONS HAVE BEEN
C       REACHED OR AFTER THE INCREASE IN THE LOG LIKELIHOOD FROM ONE
C       ITERATION TO ANOTHER IS LESS THAT .0001.  ALL OUTPUT IS SENT TO
C       FORTRAN UNIT OUNIT.
C
C   INPUT PARAMETERS
C   ----------------
C
C   MM    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX A.  MUST BE AT LEAST M.
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CASES.
C
C   N     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF VARIABLES.
C
C   A     REAL MATRIX WHOSE FIRST DIMENSION MUST BE MM AND WHOSE SECOND
C            DIMENSION MUST BE AT LEAST N (UNCHANGED ON OUTPUT).
C         THE MATRIX OF DATA VALUES.
C
C         A(I,J) IS THE VALUE FOR THE J-TH VARIABLE FOR THE I-TH CASE.
C
C   CLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST N.
C            (UNCHANGED ON OUTPUT).
C         THE LABELS OF THE VARIABLES.
C
C   RLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST M.
C            (UNCHANGED ON OUTPUT).
C         THE LABELS OF THE CASES.
C
C   TITLE 10-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         TITLE OF THE DATA SET.
C
C   K     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE DESIRED NUMBER OF CLUSTERS.
C
C   MXITER INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE MAXIMUM NUMBER OF ITERATIONS ALLOWED.
C
C   NCOV  INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         DETERMINES STRUCTURE OF THE WITHIN-CLUSTER COVARIANCE MATRIX
C
C             NCOV = 1   GENERAL COVARIANCES
C             NCOV = 2   COVARIANCES EQUAL BETWEEN CLUSTERS
C             NCOV = 3   COVARIANCES EQUAL AND DIAGONAL
C             NCOV = 4   COVARIANCES SPHERICAL
C
C   DMWORK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF THE MATRIX WORK1.  MUST BE AT LEAST
C            2*M+N+1.
C
C   WORK1 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWORK AND WHOSE
C            SECOND DIMENSION MUST BE AT LEAST K.
C         WORK MATRIX.
C
C   DMWRK1 INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX WORK2.  MUST BE AT LEAST N.
C
C   DMWRK2 INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE SECOND DIMENSION OF THE MATRIX WORK2.  MUST BE AT LEAST
C            N+1.
C
C   WORK2 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWRK1, WHOSE SECOND
C            DIMENSION MUST BE DMWRK2, AND WHOSE THIRD DIMENSION MUST BE
C            AT LEAST K+1.
C         WORK MATRIX.
C
C   DMWRK3 INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF THE MATRIX WORK3.  MUST BE AT LEAST
C             N.
C
C   WORK3 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWRK3 AND WHOSE
C            SECOND DIMENSION MUST BE AT LEAST N+1.
C         WORK MATRIX.
C
C   IWORK INTEGER VECTOR DIMENSIONED AT LEAST N.
C         WORK VECTOR.
C
C   OUNIT INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         UNIT NUMBER FOR OUTPUT.
C
C   OUTPUT PARAMETER
C   ----------------
C
C   IERR  INTEGER SCALAR.
C         ERROR FLAG.
C
C         IF IERR = 0, NO ERROR WAS DETECTED.
C
C         IF IERR = K, THE K-TH PIVOT BLOCK OF ONE OF THE COVARIANCE
C                      MATRICES WAS SINGULAR.  THEREFORE, AN INVERSE
C                      COULD NOT BE CALCULATED AND EXECUTION WAS
C                      TERMINATED.  THE ERROR FLAG WAS SET IN CMLIB
C                      SUBROUTINE SSIFA.
C
C   REFERENCE
C   ---------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 113-129.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER OUNIT, P, U, PMIX, T, DMWORK, DMWRK1, DMWRK2, DMWRK3
      DIMENSION A(MM,*), WORK1(DMWORK,*), WORK2(DMWRK1,DMWRK2,*),
     *           DETER(2), IWORK(*), WORK3(DMWRK3,*)
      CHARACTER*4 CLAB(*), RLAB(*)
      CHARACTER*10 TITLE
      LOGICAL DONE
C
C     INITIALIZE
C
      DONE = .FALSE.
      P = 0
      U = P + M
      PMIX = U + N + 1
      T = PMIX
      XLL1 = -R1MACH(2)
      DO 10 J=1,K
   10    WORK2(1,N+1,J)=0.
      DO 30 I=1,M
         DO 20 J=1,K
   20       WORK1(P+I,J)=0.
         J=(I*K)/(M+1)+1
   30    WORK1(P+I,J)=1.
      DO 200 IT=1,MXITER
C
C     UPDATE MEANS AND COVARIANCES
C
         DO 40 J=1,K
   40       CALL MOM(MM,M,N,A,J,WORK1(P+1,J),WORK1(U+1,J),DMWRK1,
     *               DMWRK2,WORK2)
C
C     UPDATE WEIGHTS
C
         WW=0.
         DO 60 J=1,K
            WORK1(PMIX,J)=0.
            DO 50 I=1,M
   50          WORK1(PMIX,J)=WORK1(PMIX,J)+WORK1(P+I,J)
   60    WW=WW+WORK1(PMIX,J)
         DO 70 J=1,K
   70       IF(WW.NE.0.) WORK1(PMIX,J)=WORK1(PMIX,J)/WW
C
C     ADJUST FOR COVARIANCE STRUCTURE
C
         IF(NCOV.NE.1) THEN
            DO 100 I=1,N
               DO 100 II=1,N
                  WORK2(I,II,1)=WORK1(PMIX,1)*WORK2(I,II,1)
                  DO 80 J=2,K
   80                WORK2(I,II,1)=WORK2(I,II,1)+WORK2(I,II,J)*
     *                             WORK1(PMIX,J)
                  IF(NCOV.GE.3.AND.I.NE.II) WORK2(I,II,1)=0.
                  DO 90 J=2,K
   90                WORK2(I,II,J)=WORK2(I,II,1)
  100       CONTINUE
            IF (NCOV.EQ.4) THEN
               CC=0.
               DO 110 I=1,N
  110             CC=CC+WORK2(I,I,1)
               CC=CC/N
               DO 120 I=1,N
                  DO 120 J=1,K
  120                WORK2(I,I,J)=CC
            ENDIF
         ENDIF
         II=IT-1
         IF(((II/5)*5.EQ.II.OR.DONE) .AND. OUNIT .GT. 0)
     *       CALL COVOUT(MM,M,N,A,CLAB,RLAB,TITLE,K,DMWORK,WORK1,
     *            DMWRK1,DMWRK2,WORK2,WORK1(T+1,1),OUNIT)
         IF (DONE) RETURN
C
C     UPDATE BELONGING PROBABILITIES
C
         DO 160 J=1,K
C
C     COMPUTE INVERSES AND DETERMINANTS OF COVARIANCE MATRICES
C
            DO 130 III = 1 , N
               DO 130 JJJ = 1 , N
 130              WORK3(III,JJJ) = WORK2(III,JJJ,J)
            CALL INVERT(DMWRK3,N,WORK3,DETER,WORK3(1,N+1),IWORK,IERR,
     *                  OUNIT)
            IF (IERR .NE. 0) RETURN
            DET = DETER(1) * (10. ** DETER(2))
            DO 140 III = 1 , N
               DO 140 JJJ = 1 , N
 140              WORK2(III,JJJ,J) = WORK3(III,JJJ)
            IF(DET.EQ.0.) RETURN
            DET=SQRT(ABS(DET))
            WORK2(1,N+1,J)=DET
C
C     COMPUTE PROBABILITY DENSITY FOR THE I-TH OBSERVATION FROM THE J-TH
C     NORMAL
C
            DO 160 I=1,M
               S=0.
               DO 150 L=1,N
                  DO 150 LL=1,N
  150                S=S+WORK2(L,LL,J)*(A(I,L)-WORK1(U+L,J))*(A(I,LL)-
     *                   WORK1(U+LL,J))
               IF(S.GT.100.) S=100.
  160          WORK1(T+I,J)=EXP(-S/2.)*WORK1(PMIX,J)/DET
C
C     COMPUTES LOG LIKELIHOOD
C
         XLL=0.
         DO 180 I=1,M
            S=0.
            DO 170 J=1,K
  170          S=S+WORK1(T+I,J)
            IF(S.EQ.0.) S=R1MACH(4)
            XLL=XLL+ALOG(S)
            DO 180 J=1,K
  180          WORK1(T+I,J)=WORK1(T+I,J)/S
         IF (OUNIT .GT. 0) WRITE(OUNIT,1) IT,XLL
    1    FORMAT(' ITERATION = ',I5,' LOG LIKELIHOOD = ',F12.6)
C
C     UPDATE PROBABILITY THE I-TH OBSERVATION WAS DRAWN FROM THE J-TH
C     NORMAL
C
         DO 190 I=1,M
            DO 190 J=1,K
               XIT=MXITER
               ALPHA=1.+.7*IT/XIT
               WORK1(P+I,J)=ALPHA*WORK1(T+I,J)-(ALPHA-1.)*WORK1(P+I,J)
C
C     AT EVERY FIFTH ITERATION, SET PROBABILITIES TO EITHER ZERO OR ONE
C
               IF(IT.EQ.5.AND.WORK1(P+I,J).GT.0.5) WORK1(P+I,J)=1.
               IF(IT.EQ.5.AND.WORK1(P+I,J).LE.0.5) WORK1(P+I,J)=0.
               IF(WORK1(P+I,J).GT.1.) WORK1(P+I,J)=1.
               IF(WORK1(P+I,J).LT.0.) WORK1(P+I,J)=0.
  190    CONTINUE
C
C     RETURN IF NO CHANGE IN LOG LIKELIHOOD
C
         IF (XLL-XLL1 .LE. .00001) DONE = .TRUE.
         XLL1 = XLL
  200 CONTINUE
      RETURN
      END