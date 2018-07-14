      SUBROUTINE HPACC(NMAX,NWDS,DATA,N,T,XNODE,K)
C
C   PURPOSE
C          TO ACCESS THE K-TH NODE OF THE HEAP,
C          1 .LE. K .LE. N .LE. NMAX
C   INPUT
C        NMAX = MAXIMUM NUMBER OF NODES ALLOWED BY USER.
C        DATA = WORK AREA FOR STORING NODES.
C        N = CURRENT NUMBER OF NODES IN THE HEAP.
C        T = INTEGER ARRAY OF POINTERS TO HEAP NODES.
C        XNODE = A REAL ARRAY, NWDS WORDS LONG, IN WHICH NODAL IN-
C          FORMATION WILL BE INSERTED.
C        K = THE INDEX OF THE NODE TO BE FOUND AND INSERTED INTO
C                XNODE.
C
C   OUTPUT
C        XNODE =  A REAL ARRAY.    CONTAINS IN XNODE(1),...,XNODE(NWDS)
C          THE ELEMENTS OF THE K-TH NODE.
C
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
      REAL DATA(*), XNODE(*)
      INTEGER T(*)
      IF (K .LT. 1 .OR. K .GT. N .OR. N .GT. NMAX) RETURN
      J=T(K)-1
      DO 1 I=1,NWDS
         IPJ=I+J
    1    XNODE(I)=DATA(IPJ)
      RETURN
      END