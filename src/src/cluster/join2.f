      SUBROUTINE JOIN2(MM, M, N, A, CLAB, RLAB, TITLE, KC, TH, DMWORK,
     *                WORK1, WORK2, IWORK, DMIWRK, IWORK1, CWORK, IERR,
     *                OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      JOINS DATA VALUES IN A CASE-BY-VARIABLE MATRIX INTO BLOCKS UNTIL
C      ALL WITHIN-BLOCK VARIANCES ARE GREATER THAN A USER-SPECIFIED
C      THRESHOLD
C
C   DESCRIPTION
C   -----------
C
C   1.  THE THRESHOLD IS THE LARGEST WITHIN-BLOCK VARIANCE FOR THE DATA
C       VALUES.  THE VARIABLES SHOULD BE SCALED SIMILARLY (CLUSTER
C       SUBROUTINE STAND CAN BE USED TO STANDARDIZE THE VARIABLES).
C       THE ROUTINE STARTS WITH EACH VALUE IN THE DATA MATRIX FORMING A
C       BLOCK.  THEN THE DISTANCES BETWEEN THE VARIABLES AND THE CASES
C       FOR EACH PAIR OF BLOCKS ARE DETERMINED.  THE SMALLEST OF ALL
C       DISTANCES IS FOUND AND THE CORRESPONDING BLOCKS ARE JOINED TO
C       FORM A NEW BLOCK PROVIDED THE VARIANCE OF EACH VARIABLE IN THE
C       NEW BLOCK IS SMALLER THAN THE THRESHOLD.  THE DISTANCES ARE
C       UPDATED AND THE PROCESS REPEATS UNTIL THE NEW BLOCK HAS A
C       LARGER VARIANCE, THEN THE RESULTS ARE PRINTED IN A BLOCK
C       DIAGRAM ON FORTRAN UNIT OUNIT.  THE THRESHOLD SHOULD BE CHOSEN
C       WISELY AS A LARGE THRESHOLD WILL PRODUCE A FEW LARGE BLOCKS AND
C       A SMALL THRESHOLD WILL PRODUCE MANY SMALL BLOCKS.
C
C   2.  MISSING VALUES SHOULD BE REPRESENTED BY 99999.
C
C   3.  THE BLOCK DIAGRAM IS THE DATA MATRIX WITH THE DATA VALUES
C       MULTIPLIED BY 10.  THE BLOCKS ARE OUTLINED BY THE VERTICAL AND
C       HORIZONTAL LINES.
C
C   INPUT PARAMETERS
C   ----------------
C
C   MM    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX A.  MUST BE AT LEAST M.
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CASES.
C
C   N     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF VARIABLES.
C
C   A     REAL MATRIX WHOSE FIRST DIMENSION MUST BE MM AND SECOND
C            DIMENSION MUST BE AT LEAST N (CHANGED ON OUTPUT).
C         THE DATA MATRIX.
C
C         A(I,J) IS THE VALUE FOR THE J-TH VARIABLE FOR THE I-TH CASE.
C
C   CLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST N
C            (CHANGED ON OUTPUT).
C         ORDERED LABELS OF THE COLUMNS.
C
C   RLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST M
C            (CHANGED ON OUTPUT).
C         ORDERED LABELS OF THE ROWS.
C
C   TITLE 10-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         TITLE OF DATA SET.
C
C   KC    INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         MAXIMUM NUMBER OF BLOCKS.  SHOULD BE BETWEEN M AND N*M.
C
C   TH    REAL SCALAR (UNCHANGED ON OUTPUT).
C         THRESHOLD VARIANCE FOR DATA VALUES WITHIN A BLOCK.
C
C   DMWORK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX WORK1.  MUST BE AT LEAST M.
C
C   WORK1 REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMWORK AND SECOND
C            DIMENSION MUST BE AT LEAST N.
C         WORK MATRIX.
C
C   WORK2 REAL VECTOR DIMENSIONED AT LEAST M + N.
C         WORK VECTOR.
C
C   IWORK INTEGER VECTOR DIMENSIONED AT LEAST 2*M + 2*N.
C         WORK VECTOR.
C
C   DMIWRK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX IWORK1.  MUST BE AT LEAST 4.
C
C   IWORK1 INTEGER MATRIX WHOSE FIRST DIMENSION MUST BE DMIWRK AND
C            SECOND DIMENSION MUST BE AT LEAST KC.
C         WORK MATRIX.
C
C   CWORK VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST MAX(M,N).
C         WORK VECTOR.
C
C   OUTPUT PARAMETER
C   ----------------
C
C   IERR  INTEGER SCALAR.
C         ERROR FLAG.
C
C         IERR = 0, NO ERRORS WERE DETECTED DURING EXECUTION
C
C         IERR = 1, THE NUMBER OF BLOCKS NEEDED WAS LARGER THAN THE
C                   NUMBER OF BLOCKS ALLOCATED.  EXECUTION IS
C                   TERMINATED.  INCREASE KC OR INCREASE THRESHOLD TO
C                   PRODUCE FEWER BLOCKS.
C
C         IERR = 2, EITHER THE FIRST AND LAST CASES OR THE CLUSTER
C                   DIAMETER FOR A CLUSTER IS OUT OF BOUNDS.  THE
C                   CLUSTER AND ITS BOUNDARIES ARE PRINTED ON UNIT
C                   OUNIT.  EXECUTION WILL CONTINUE WITH QUESTIONABLE
C                   RESULTS FOR THAT CLUSTER.
C
C         IERR = 3, THE THRESHOLD WAS SO LARGE THAT NO BLOCKS WERE
C                   GENERATED EXECUTION IS TERMINATED.  DECREASE
C                   THRESHOLD.
C
C   REFERENCES
C   ----------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 278-298.
C
C     HARTIGAN, J. A. (1975) PRINTER GRAPHICS FOR CLUSTERING. JOURNAL OF
C        STATISTICAL COMPUTATION AND SIMULATION. VOLUME 4,PAGES 187-213.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER BR, BC, NR, NC, RD, CD, DMWORK, DMIWRK, OUNIT
      DIMENSION A(MM,*), IWORK1(DMIWRK,*), IWORK(*), WORK1(DMWORK,*),
     *          WORK2(*)
      CHARACTER*4 CLAB(*), RLAB(*), CWORK(*)
      CHARACTER*10 TITLE
C
      IERR = 0
      BR = 0
      BC = BR + M
      NR = BC + N
      NC = NR + M
      RD = 0
      CD = RD + M
      DO 10 I = 1 , M
         DO 10 J = 1 , N
   10       WORK1(I,J) = A(I,J)
      KB=KC
      XM=99999.
      DO 20 I=1,M
   20    IWORK(BR+I)=I
      DO 30 J=1,N
   30    IWORK(BC+J)=J
      KA=0
C
C     FIND CLOSEST OBJECTS AND VARIABLES FOR EACH OBJECT AND VARIABLE
C
      DO 40 I=1,M
   40    CALL RDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),I,N,TH,IWORK(NR+I),
     *              WORK2(RD+I))
      DO 50 J=1,N
   50    CALL CDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),J,M,TH,IWORK(NC+J),
     *              WORK2(CD+J))
C
C     FIND CLOSEST PAIR OF OBJECTS
C
   60 DR=R1MACH(2)/M
      I1=1
      I2=1
      DO 70 I=1,M
         IF(IWORK(BR+I).GE.0.AND.DR.GT.WORK2(RD+I)) THEN
            DR=WORK2(RD+I)
            I1=I
            I2=IWORK(NR+I)
         ENDIF
   70 CONTINUE
C
C     FIND CLOSEST PAIR OF VARIABLES
C
      DC=DR
      J1=1
      J2=1
      DO 80 J=1,N
         IF(IWORK(BC+J).GE.0.AND.DC.GT.WORK2(CD+J)) THEN
            DC=WORK2(CD+J)
            J1=J
            J2=IWORK(NC+J)
         ENDIF
   80 CONTINUE
      IF(I2.LT.I1) THEN
         K=I2
         I2=I1
         I1=K
      ENDIF
      IF(J2.LT.J1) THEN
         K=J2
         J2=J1
         J1=K
      ENDIF
      IF(DC.GE.DR) THEN
C
C     AMALGAMATE THE CLOSEST PAIR OF OBJECTS
C
         IF(I2.EQ.1) GO TO 150
C
C     FIND CLOSEST OBJECT TO I1 AND I2
C
         IWORK(BR+I1)=-IWORK(BR+I1)
         CALL RDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),I2,N,TH,
     *              IWORK(NR+I2),WORK2(RD+I2))
         IWORK(BR+I2)=-IWORK(BR+I2)
         IWORK(BR+I1)=-IWORK(BR+I1)
         CALL RDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),I1,N,TH,
     *              IWORK(NR+I1),WORK2(RD+I1))
         II=IWORK(NR+I2)
         IF(WORK2(RD+I1).LE.WORK2(RD+I2)) II=IWORK(NR+I1)
         L1=IWORK(BR+I1)
         L2=-IWORK(BR+I2)
         LL=IWORK(BR+II)
         IWORK(BR+I1)=L2
         IWORK(BR+I2)=-L1
         MMM=M-1
C
C     AMALGAMATE VALUES AND CREATE NEW BLOCKS
C
         DO 90 J=1,N
            IF(KA.GE.KB-2) GO TO 150
            IF(IWORK(BC+J).GE.0) THEN
               K=IWORK(BC+J)
               IF(AMAX1(A(L1,K),A(L2,K))-AMIN1(A(I1,J),A(I2,J))
     *            .LE.TH) THEN
                  Z=A(L1,K)
                  IF(A(I1,J).GE.A(I2,J))A(I1,J)=A(I2,J)
                  IF(Z.GE.A(L2,K))A(L2,K)=Z
               ELSE
                  Z1=AMAX1(A(L1,K),A(LL,K))-AMIN1(A(I1,J),A(II,J))
                  Z2=AMAX1(A(L2,K),A(LL,K))-AMIN1(A(I2,J),A(II,J))
                  IF(II.EQ.1) THEN
                     Z2=10.**2
                     Z1=R1MACH(2)/M
                  ENDIF
                  IF(Z1.LE.TH) A(L2,K)=A(L1,K)
                  IF(Z2.LE.TH) A(I1,J)=A(I2,J)
                  IF(Z1.GT.TH.AND.Z2.GT.TH) THEN
                     A(I1,J)=A(II,J)
                     A(L2,K)=A(LL,K)
                  ENDIF
                  IF(Z1.GT.TH) THEN
                     KA=KA+1
                     IWORK1(1,KA)=I1+1
                     IWORK1(2,KA)=L1+1
                     IWORK1(3,KA)=J+1
                     IWORK1(4,KA)=IWORK(BC+J)+1
                  ENDIF
                  IF(Z2.GT.TH) THEN
                     KA=KA+1
                     IWORK1(1,KA)=I2+1
                     IWORK1(2,KA)=IWORK(BR+I1)+1
                     IWORK1(3,KA)=J+1
                     IWORK1(4,KA)=IWORK(BC+J)+1
                  ENDIF
               ENDIF
            ENDIF
   90    CONTINUE
C
C     UPDATE DISTANCES
C
         DO 100 I=1,M
            IF(IWORK(BR+I).GE.0.AND.(IWORK(NR+I).EQ.I1.OR.
     *         IWORK(NR+I).EQ.I2.OR.I.EQ.I1)) THEN
               CALL RDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),I,N,TH,
     *                    IWORK(NR+I),WORK2(RD+I))
               J=IWORK(NR+I)
               IF(I.EQ.I1.AND.WORK2(RD+I).LT.WORK2(RD+J)) THEN
                  IWORK(NR+J)=I
                  WORK2(RD+J)=WORK2(RD+I)
               ENDIF
            ENDIF
  100    CONTINUE
         DO 110 J=1,N
            IF(IWORK(BC+J).GE.0) CALL CDIST(MM,M,N,A,IWORK(BC+1),
     *                 IWORK(BR+1),J,M,TH,IWORK(NC+J),WORK2(CD+J))
  110    CONTINUE
      ELSE
C
C     AMALGAMATE CLOSEST PAIR OF VARIABLES
C
C     FIND CLOSEST VARIABLE TO J1 OR J2
C
         IWORK(BC+J1)=-IWORK(BC+J1)
         CALL CDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),J2,M,TH,
     *              IWORK(NC+J2),WORK2(CD+J2))
         IWORK(BC+J2)=-IWORK(BC+J2)
         IWORK(BC+J1)=-IWORK(BC+J1)
         CALL CDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),J1,M,TH,
     *              IWORK(NC+J1),WORK2(CD+J1))
         JJ=IWORK(NC+J2)
         IF(WORK2(CD+J1).LE.WORK2(CD+J2)) JJ=IWORK(NC+J1)
         L1=IWORK(BC+J1)
         L2=-IWORK(BC+J2)
         LL=IWORK(BC+JJ)
         IWORK(BC+J1)=L2
         IWORK(BC+J2)=-L1
         NNN=N-1
C
C     AMALGAMATE VALUES AND CREATE NEW BLOCKS
C
         DO 120 I=1,M
            IF(KA.GE.KB-2) GO TO 150
            IF(IWORK(BR+I).GE.0) THEN
               K=IWORK(BR+I)
               IF(AMAX1(A(K,L1),A(K,L2))-AMIN1(A(I,J1),A(I,J2))
     *            .LE.TH) THEN
                  Z=A(K,L1)
                  IF(A(I,J1).GE.A(I,J2)) A(I,J1)=A(I,J2)
                  IF(Z.GE.A(K,L2)) A(K,L2)=Z
               ELSE
                  Z1=AMAX1(A(K,L1),A(K,LL))-AMIN1(A(I,J1),A(I,JJ))
                  Z2=AMAX1(A(K,L2),A(K,LL))-AMIN1(A(I,J2),A(I,JJ))
                  IF(JJ.EQ.1) THEN
                     Z2=R1MACH(2)/M
                     Z1=Z2
                  ENDIF
                  IF(Z1.LE.TH) A(K,L2)=A(K,L1)
                  IF(Z2.LE.TH) A(I,J1)=A(I,J2)
                  IF(Z1.GT.TH.AND.Z2.GT.TH) THEN
                     A(I,J1)=A(I,JJ)
                     A(K,L2)=A(K,LL)
                  ENDIF
                  IF(Z1.GT.TH) THEN
                     KA=KA+1
                     IWORK1(1,KA)=I+1
                     IWORK1(2,KA)=IWORK(BR+I)+1
                     IWORK1(3,KA)=J1+1
                     IWORK1(4,KA)=L1+1
                  ENDIF
                  IF(Z2.GT.TH) THEN
                     KA=KA+1
                     IWORK1(1,KA)=I+1
                     IWORK1(2,KA)=IWORK(BR+I)+1
                     IWORK1(3,KA)=J2+1
                     IWORK1(4,KA)=L2+1
                  ENDIF
               ENDIF
            ENDIF
  120    CONTINUE
C
C     UPDATE DISTANCES
C
         DO 130 J=1,N
            IF(IWORK(BC+J).GE.0.AND.(IWORK(NC+J).EQ.J1.OR.
     *        IWORK(NC+J).EQ.J2.OR.J.EQ.J1)) THEN
               CALL CDIST(MM,M,N,A,IWORK(BC+1),IWORK(BR+1),J,M,TH,
     *                    IWORK(NC+J),WORK2(CD+J))
               I=IWORK(NC+J)
               IF(J.EQ.J1.AND.WORK2(CD+J).LT.WORK2(CD+I)) THEN
                  IWORK(NC+I)=J
                  WORK2(CD+I)=WORK2(CD+J)
               ENDIF
            ENDIF
  130    CONTINUE
         DO 140 I=1,M
            IF(IWORK(BR+I).GE.0.) CALL RDIST(MM,M,N,A,IWORK(BC+1),
     *                  IWORK(BR+1),I,N,TH,IWORK(NR+I),WORK2(RD+I))
  140    CONTINUE
      ENDIF
      GOTO 60
C
C     COMPUTE NEW ORDERING OF OBJECTS AND VARIABLES
C
  150 CONTINUE
      IF(KA.GE.KB-2) THEN
         IF (OUNIT .GT. 0) WRITE(OUNIT,1)
    1    FORMAT(' TOO MANY BLOCKS, INCREASE THRESHOLD OR INCREASE KC ')
         IERR = 1
         RETURN
      ENDIF
      IF(KA.EQ.0) THEN
         IF (OUNIT .GT. 0) WRITE(OUNIT,2)
    2    FORMAT(' NO BLOCKS, DECREASE THRESHOLD ')
         IERR = 3
         RETURN
      ENDIF
      IF(KA.EQ.0.OR.KA.GE.KB-2) GOTO 210
C
C     FIND OBJECT ORDER
C
      J=IWORK(BR+1)
      DO 160 I=1,M
         IM=M-I+1
         IWORK(NR+IM)=J
  160    J=-IWORK(BR+J)
C
C     FIND VARIABLE ORDER
C
      J=IWORK(BC+1)
      DO 170 I=1,N
         IN=N-I+1
         IWORK(NC+IN)=J
  170    J=-IWORK(BC+J)
      DO 180 I=1,M
         J=IWORK(NR+I)
  180    IWORK(BR+J)=I
      DO 190 J=1,N
         I=IWORK(NC+J)
  190    IWORK(BC+I)=J
C
C     ADJUST BLOCKS
C
      DO 200 K=1,KA
         I1=IWORK1(1,K)-1
         I2=IWORK1(2,K)-1
         J1=IWORK1(3,K)-1
         J2=IWORK1(4,K)-1
         I1=IWORK(BR+I1)
         I2=IWORK(BR+I2)
         J1=IWORK(BC+J1)
         J2=IWORK(BC+J2)
         IWORK1(1,K)=I1+1
         IWORK1(2,K)=I2+1
         IWORK1(3,K)=J1+1
         IWORK1(4,K)=J2+1
  200 CONTINUE
      KA=KA+1
      IWORK1(1,K)=2
      IWORK1(2,K)=M+1
      IWORK1(3,K)=2
      IWORK1(4,K)=N+1
C
C     OUTPUT
C
  210 CALL PMUT(DMWORK,M,N,WORK1,IWORK(BC+1),IWORK(BR+1),IWORK(NR+1),
     *          IWORK(NC+1),MM,A,CLAB,RLAB,CWORK)
      CALL BLOCK(MM,M+1,N+1,A,CLAB,RLAB,TITLE,KA,DMIWRK,IWORK1,IERR,
     *           OUNIT)
      RETURN
      END