      SUBROUTINE WCOV(MM, M, N, A, CLAB, RLAB, TITLE, NC, DMCOV, COV,
     1                COVLAB, COVTIT, WORK)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      COMPUTES COVARIANCES WITHIN EACH CLUSTER
C
C   DESCRIPTION
C   -----------
C
C   1.  THE ARRAY NC DEFINES THE CLUSTER MEMBERSHIP FOR EACH CASE.  IF
C       NC(I) = J  THEN CASE I IS IN CLUSTER J.
C
C   2.  THE MEAN FOR EACH CLUSTER IS DETERMINED, AND THE CROSS PRODUCTS
C       BETWEEN EACH VARIABLE WITHIN EACH CLUSTER ARE ACCUMULATED.
C       FINALLY, THE CROSS PRODUCTS ARE DIVIDED BY THE DEGREES OF
C       FREEDOM (THE NUMBER OF CASES - THE NUMBER OF CLUSTERS).
C
C   3.  THE ROUTINE ASSUMES THERE ARE NO MISSING VALUES.  IF SOME
C       MISSING VALUES EXIST, CALL CLUSTER SUBROUTINE "TWO" TO REPLACE
C       THEM BY THE OVERALL MEAN OF THE VARIABLE, OR CALL CLUSTER
C       ROUTINE "MISS" TO REPLACE THEM BY THE CLUSTER MEAN OF THE
C       VARIABLE .  SINCE THE LABELS FOR THE WITHIN-GROUP COVARIANCE
C       MATRIX ARE SYMMETRIC, ONLY ONE VECTOR OF LABELS ARE GENERATED
C       AND THAT VECTOR CAN BE USED FOR BOTH LABEL ARGUMENTS FOR THE
C       CLUSTER SUBROUTINE "OUT".  SEE "WCOV" IN THE SAMPLE FILE UNDER
C       ACCOUNT HARTIGA FOR AN EXAMPLE OF CALLING "OUT" AFTER WCOV.
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
C            DIMENSION MUST BE AT LEAST N. (UNCHANGED ON OUTPUT).
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
C   NC    INTEGER VECTOR DIMENSIONED AT LEAST M (UNCHANGED ON OUTPUT).
C         NC(I) INDICATES THE CLUSTER NUMBER FOR CASE I.
C
C   DMCOV INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE COVARIANCE MATRIX.  MUST BE AT
C            LEAST N.
C
C   WORK  REAL VECTOR DIMENSIONED AT LEAST N.
C         WORK VECTOR.
C
C   OUTPUT PARAMETERS
C   -----------------
C
C   COV   REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMCOV AND WHOSE
C            SECOND DIMENSION MUST BE AT LEAST N.
C         THE WITHIN-GROUP COVARIANCE MATRIX.
C
C   COVLAB VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST N.
C         THE LABELS OF THE VARIABLES FOR THE WITHIN-GROUP COVARIANCE
C            MATRIX.
C
C   COVTIT 10-CHARACTER VARIABLE.
C         TITLE OF THE WITHIN-GROUP COVARIANCE MATRIX.
C
C   REFERENCE
C   ---------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 69, 70.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMCOV
      DIMENSION A(MM,*), COV(DMCOV,*), NC(*), WORK(*)
      CHARACTER*4 CLAB(*), RLAB(*), COVLAB(*)
      CHARACTER*10 TITLE, COVTIT
C
C     INITIALIZE COVARIANCES AND COUNT TOTAL NUMBER OF CLUSTERS
C
      DO 10 I=1,N
         DO 10 J=1,N
   10       COV(I,J)=0.
      K=0
      DO 20 I=1,M
   20    IF(NC(I).GT.K) K=NC(I)
C
C     COMPUTE MEAN FOR EACH CLUSTER
C
      Q=0.
      DO 90 L=1,K
         P=0.
         DO 30 J=1,N
   30       WORK(J)=0.
         DO 50 I=1,M
            IF(NC(I).EQ.L) THEN
               P=P+1.
               DO 40 J=1,N
   40             WORK(J)=WORK(J)+A(I,J)
            ENDIF
   50    CONTINUE
         DO 60 J=1,N
   60       IF(P.NE.0.) WORK(J)=WORK(J)/P
         IF(P.GT.0.) Q=Q+P-1.
C
C     ADD ON CROSS PRODUCTS
C
         DO 80 I=1,M
            IF(NC(I).EQ.L) THEN
               DO 70 J=1,N
                  DO 70 JJ=1,J
   70             COV(J,JJ)=COV(J,JJ)+(A(I,J)-WORK(J))*(A(I,JJ)
     *                      -WORK(JJ))
            ENDIF
   80    CONTINUE
   90 CONTINUE
C
C     DIVIDE BY DEGREES OF FREEDOM
C
      DO 100 J=1,N
         DO 100 JJ=1,J
            IF(Q.GT.0.) COV(J,JJ)=COV(J,JJ)/Q
  100       COV(JJ,J)=COV(J,JJ)
C
C     LABEL
C
      DO 110 J=1,N
  110    COVLAB(J)=CLAB(J)
      COVTIT = 'WITHIN COV'
      RETURN
      END
