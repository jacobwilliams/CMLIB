      SUBROUTINE SLINK(M, DMD, D, DRLAB, DTITLE, DMIWRK, IWORK, WORK,
     *                 TLAB, IOUT, IERR, OUNIT)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      UTILIZES THE SINGLE-LINKAGE CLUSTERING ALGORITHM TO CONSTRUCT
C      A TREE FROM A USER-SPECIFIED DISTANCE MATRIX
C
C   DESCRIPTION
C   -----------
C
C   1.  THE ALGORITHM TO COMPUTE SINGLE-LINKAGE TREES IS FOUND ON PAGES
C       191-195 OF THE REFERENCE.  THE DATA MATRIX ARE THE DISTANCES
C       BETWEEN THE CASES.  THE DISTANCES SHOULD BE CALCULATED ON
C       SCALED DATA (CLUSTER SUBROUTINE STAND CAN BE USED TO
C       STANDARDIZE THE VARIABLES).  THE OUTPUT CAN BE THE REGULAR
C       REGULAR TREE OUTPUT OR THE BLOCK REPRESENTATION OF THE TREE AND
C       IS WRITTEN ON FORTRAN UNIT OUNIT.
C
C   2.  THE REGULAR TREE LISTS THE CASES VERTICALLY AND HAS HORIZONTAL
C       LINES EMANATING FROM EACH CASE.  EACH CLUSTER WILL CORRESPOND
C       TO A VERTICAL LINE BETWEEN TWO HORIZONTAL LINES.  THE CASES
C       BETWEEN AND INCLUDED IN THE HORIZONTAL LINES ARE THE MEMBERS OF
C       THE CLUSTER.  THE DISTANCE FROM THE CASE NAMES TO THE VERTICAL
C       LINES CORRESPOND TO THE CLUSTER DIAMETER OR THE DISTANCE
C       BETWEEN THE FIRST AND LAST CASES.
C
C   3.  THE BLOCK DIAGRAM PRINTS THE DISTANCE MATRIX WITH THE CASES
C       LABELING BOTH HORIZONTAL AND VERTICAL AXES.  THE DISTANCES HAVE
C       BEEN MULTIPLIED BY 10.  THE HORIZONTAL BOUNDARIES OF THE BLOCKS
C       ARE REPRESENTED BY DASHES AND THE VERTICAL BOUNDARIES BY QUOTE
C       MARKS.  COMMAS REPRESENT THE CORNERS OF THE BLOCKS.
C
C   INPUT PARAMETERS
C   ----------------
C
C   M     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF OBJECTS.
C
C   DMD   INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX D.  MUST BE AT LEAST M.
C
C   D     REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMD AND SECOND
C            DIMENSION MUST BE AT LEAST M (CHANGED ON OUTPUT).
C         THE MATRIX OF DISTANCES.  ORDERED ON OUTPUT SUCH THAT ALL
C            CLUSTERS ARE CONTIGUOUS IN THE ORDER.
C
C         D(I,J) = DISTANCE FROM CASE I TO CASE J
C
C   DRLAB VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST M
C            (CHANGED ON OUTPUT).
C         LABELS OF THE CASES.  ORDERED ON OUTPUT.
C
C   DTITLE 10-CHARACTER VARIABLE (UNCHANGED ON OUTPUT).
C         TITLE OF THE DATA SET.
C
C   DMIWRK INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE LEADING DIMENSION OF MATRIX IWORK.  MUST BE AT LEAST 4.
C
C   IWORK INTEGER VECTOR WHOSE FIRST DIMENSION MUST BE AT DMIWRK AND
C            WHOSE SECOND DIMENSION MUST BE AT LEAST M+1.
C         WORK VECTOR.
C
C   WORK  REAL VECTOR DIMENSIONED AT LEAST M+1.
C         WORK VECTOR.
C
C   TLAB  VECTOR OF 4-CHARACTER VARIABLES DIMENSIONED AT LEAST M+1
C         WORK VECTOR.
C
C         IF THE REGULAR TREE DIAGRAM IS NOT CHOSEN, TLAB CAN HAVE
C            LENGTH 1.
C
C   IOUT  INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         OPTION FOR CHOOSING FORM OF OUTPUT.  IOUT HAS THE DECIMAL
C           EXPANSION AB SUCH THAT IF
C
C              A .NE. 0  THE REGULAR TREE WILL BE PRINTED
C              B .NE. 0  THE BLOCKED TREE WILL BE PRINTED
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
C         IERR = 0, NO ERRORS WERE DETECTED DURING EXECUTION
C
C         IERR = 1, EITHER THE FIRST AND LAST CASES OR THE CLUSTER
C                   DIAMETER FOR A CLUSTER IS OUT OF BOUNDS.  THE
C                   CLUSTER AND ITS VALUES ARE PRINTED ON UNIT OUNIT.
C                   EXECUTION WILL CONTINUE WITH QUESTIONABLE RESULTS
C                   FOR THAT CLUSTER.  ERROR FLAG SET IN THE REGULAR
C                   TREE OUTPUT ROUTINE.
C
C         IERR = 2, EITHER THE FIRST AND LAST CASES OR THE CLUSTER
C                   DIAMETER FOR A CLUSTER IS OUT OF BOUNDS.  THE
C                   CLUSTER AND ITS BOUNDARIES ARE PRINTED ON UNIT
C                   OUNIT.  EXECUTION WILL CONTINUE WITH QUESTIONABLE
C                   RESULTS FOR THAT CLUSTER.  ERROR FLAG SET IN THE
C                   BLOCK TREE OUTPUT ROUTINE.
C
C   REFERENCES
C   ----------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 191-215.
C
C     HARTIGAN, J. A. (1975) PRINTER GRAPHICS FOR CLUSTERING. JOURNAL OF
C        STATISTICAL COMPUTATION AND SIMULATION. VOLUME 4,PAGES 187-213.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMIWRK, DMD, OUNIT
      DIMENSION D(DMD,*), WORK(*), IWORK(DMIWRK,*)
      CHARACTER*4 DRLAB(*), TLAB(*), CTEMP
      CHARACTER*10 DTITLE
C
      IERR = 0
      DO 10 I = 1 , M
   10    IWORK(4,I) = I
      D(1,1)=R1MACH(2)
C
C     FIND THE OBJECT CLOSEST TO THE FIRST OBJECT
C
      DO 20 K=2 , M
         IF(D(1,K).LT.D(1,1)) THEN
            D(1,1)=D(1,K)
            IWORK(4,1)=K
         ENDIF
   20 CONTINUE
C
C     SET UP THE CLUSTERS
C
      DO 90 NEXT = 1,M-1
         J = NEXT + 1
         DMIN=R1MACH(2)
         IMIN=NEXT
C
C     FIND THE SMALLEST OF THE SMALLEST DISTANCES SO FAR COMPUTED
C
         DO 30 I=1,NEXT
            IF(D(I,I).LT.DMIN) THEN
               DMIN=D(I,I)
               IMIN=I
            ENDIF
   30    CONTINUE
         WORK(J+1)=100.*DMIN
         I=IWORK(4,IMIN)
C
C     PLACE THE OBJECT JUST DETERMINED IN THE NEXT POSITION BY
C     EXCHANGING IT WITH THE ONE CURRENTLY THERE
C
         DO 40 K=1,M
            A=D(I,K)
            D(I,K)=D(J,K)
   40       D(J,K)=A
         CTEMP = DRLAB(I)
         DRLAB(I)= DRLAB(J)
         DRLAB(J) = CTEMP
         DO 50 K=1,M
            A=D(K,I)
            D(K,I)=D(K,J)
   50       D(K,J)=A
         ITEMP = IWORK(4,I)
         IWORK(4,I) = IWORK(4,J)
         IWORK(4,J) = ITEMP
         DO 60 K=1,NEXT
            IF(IWORK(4,K).EQ.I) IWORK(4,K)=1
   60       IF(IWORK(4,K).EQ.J) IWORK(4,K)=I
C
C     UPDATE THE SMALLEST DISTANCES
C
         DO 80 I=1,J
            IWORK(4,J)=J
            IF(IWORK(4,I).LE.J) THEN
               IWORK(4,I)=I
               D(I,I)=R1MACH(2)
               DO 70 K=J,M
                  IF(K.NE.J.AND.D(I,K).LT.D(I,I)) THEN
                     D(I,I)=D(I,K)
                     IWORK(4,I)=K
                  ENDIF
   70          CONTINUE
            ENDIF
   80    CONTINUE
   90 CONTINUE
C
C     FIND BOUNDARIES OF CLUSTERS
C
      WORK(2)=R1MACH(2)
      M1 = M + 1
      DO 140 K=2,M1
         IWORK(1,K)=K
         IWORK(2,K)=K
         DO 100 L=K,M1
            IF(L.NE.K) THEN
               IF(WORK(L).GT.WORK(K)) GO TO 110
            ENDIF
  100    IWORK(2,K)=L
  110    DO 120 L=2,K
            LL=K-L+2
            IF(L.NE.2) THEN
               IF(WORK(LL).GT.WORK(K)) GO TO 130
            ENDIF
  120    CONTINUE
  130    IWORK(1,K)=LL
  140 CONTINUE
      MM2=M-1
      DO 160 K=1,MM2
         DO 150 L=1,2
  150       IWORK(L,K)=IWORK(L,K+2)
  160    WORK(K)=WORK(K+2)
C
C     SCALE CLUSTER DIAMETERS BETWEEN 1 AND 100
C
      XMAX = 0.
      DO 170 K=1,MM2
  170    IF(XMAX.LT.WORK(K)) XMAX=WORK(K)
      DO 180 K=1,MM2
  180    IWORK(3,K)=INT((WORK(K)*100)/XMAX)
C
C     REORDER DISTANCE MATRIX
C
      DO 190 I=1,M
  190    D(I,I)=0.
C
C     PRODUCE OUTPUT
C
      IA = IOUT / 10
      IB = MOD(IOUT,10)
      IF (IA .NE. 0) THEN
         IF (OUNIT .GT. 0) WRITE(OUNIT,1)
    1    FORMAT('1')
         TLAB(1) = DTITLE
         DO 200 I = 1 , M
  200       TLAB(I+1) = DRLAB(I)
         CALL TREE1(M+1,M-1,DMIWRK,IWORK,TLAB,IERR,OUNIT)
      ENDIF
      IF (IB .NE. 0) THEN
         DO 210 K = 1, M-1
            IWORK(3,K) = IWORK(1,K)
            IWORK(4,K) = IWORK(2,K)
 210     CONTINUE
         CALL BLOCK(DMD,M+1,M+1,D,DRLAB,DRLAB,DTITLE,M-1,DMIWRK,IWORK,
     *              IERR,OUNIT)
      ENDIF
      RETURN
      END
