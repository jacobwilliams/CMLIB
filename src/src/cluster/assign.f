      SUBROUTINE ASSIGN(MM, M, N, A, K, DMU, U, NC, DMAX)
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   PURPOSE
C   -------
C
C      ASSIGNS EACH CASE TO THE CLUSTER WHOSE CENTER IS A MINIMUM
C      EUCLIDEAN DISTANCE FROM THE CASE. CAN BE USED WITH CLUSTER
C      SUBROUTINE RELOC TO FORM A USER-DEFINED K-MEANS PACKAGE.
C
C   DESCRIPTION
C   -----------
C
C   1.  THE VARIABLES MUST BE SCALED SIMILARLY (CLUSTER SUBROUTINE STAND
C       CAN BE USED TO STANDARDIZE THE VARIABLES).
C
C   2.  THE EUCLIDEAN DISTANCE BETWEEN EACH CLUSTER MEAN AND A CASE IS
C       DETERMINED, AND THAT CASE IS ASSIGNED TO THE CLUSTER WHOSE
C       DISTANCE IS A MINIMUM.  THE CASE THAT IS FURTHEST FROM THE
C       CLUSTER CENTER IS RETURNED ALONG WITH THE FURTHEST DISTANCE.
C       MISSING VALUES ARE DENOTED BY A 99999.  AND DO NOT AFFECT THE
C       DISTANCE CALCULATION.
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
C   K     INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE NUMBER OF CLUSTERS.
C
C   DMU   INTEGER SCALAR (UNCHANGED ON OUTPUT).
C         THE FIRST DIMENSION OF THE MATRIX U.  MUST BE AT LEAST N.
C
C   U     REAL MATRIX WHOSE FIRST DIMENSION MUST BE DMU AND WHOSE SECOND
C            DIMENSION MUST BE AT LEAST K (UNCHANGED ON OUTPUT).
C         THE CENTERS OF THE CLUSTERS.
C
C   OUTPUT PARAMETERS
C   -----------------
C
C   NC    INTEGER VECTOR DIMENSIONED AT LEAST M+1.
C         NC(I) IS THE CLUSTER FOR CASE I.
C
C         NC(M+1) IS THE CASE FURTHEST FROM ITS MEAN.
C
C   DMAX  REAL SCALAR.
C         THE DISTANCE CASE NC(M+1) IS FROM ITS MEAN.
C
C   REFERENCE
C   ---------
C
C     HARTIGAN, J. A. (1975).  CLUSTERING ALGORITHMS, JOHN WILEY &
C        SONS, INC., NEW YORK.  PAGES 84-112.
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
C   MODIFICATION
C   ------------
C
C   LINES STARTING WITH C-RFB BELOW WERE COMMENTED OUT.
C   THE SECOND LINE LEADS TO A FATAL ERROR IN LAHEY FORTRAN.
C   THEY ARE THE ONLY REFERENCES TO VARIABLE DP.  DP IS SET
C   TO ZERO IN THE FIRST AND NEVER CHANGED.  HENCE THE SECOND
C   IS NEVER EXECUTED. 
C
C   R.F. BOISVERT, NIST
C   30 OCT 91  
C
C<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
C
      INTEGER DMU
      DIMENSION A(MM,*), U(DMU,*), NC(*)
C
C     INITIALIZE
C
      DMAX=0.
      NC(1)=0
      XM=99999.
      DO 30 I=1,M
         DC=R1MACH(2)
         DO 20 J=1,K
            DJ=0.
C-RFB       DP=0.
C
C     FIND DISTANCE TO CLUSTER CENTER
C
            DO 10 L=1,N
               IF(U(L,J).EQ.XM.OR.A(I,L).EQ.XM) GO TO 20
               DJ=DJ+(U(L,J)-A(I,L))**2
   10       CONTINUE
C-RFB       IF(DP.GT.0.) DJ=(DJ/DP)**0.5
C
C     FIND CLOSEST CLUSTER CENTER
C
            IF(DJ.LE.DC) THEN
               DC=DJ
               NC(I)=J
            ENDIF
   20    CONTINUE
C
C     FIND ROW FURTHEST FROM ITS CENTER
C
         IF(DC.GE.DMAX) THEN
            DMAX=DC
            NC(M+1)=I
         ENDIF
   30 CONTINUE
      RETURN
      END