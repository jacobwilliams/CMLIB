      SUBROUTINE PST3DI(LPEROD,L,MPEROD,M,C1,NPEROD,N,C2,A,B,C,
     *                  LDIMF,MDIMF,IERROR,W)
C
C     PACKAGE PSTG3D, VERSION 1, AUGUST 1985
C
      DIMENSION A(L),B(L),C(L),W(*)
C
C     SUBROUTINE THAT INITIALIZES SUBROUTINE PSTG3D.
C
C     CONSULT DOCUMENTATION TO PSTG3D FOR DEFINITION OF PARAMETERS.
C
C     CHECK FOR INVALID INPUT.
C
      IERROR=0
      IF (LPEROD.NE.0 .AND. LPEROD.NE.1) IERROR=1
      IF (L.LT.3) IERROR=2
      IF (MPEROD.LT.0 .AND. MPEROD.GT.4) IERROR=3
      IF (M.LT.3) IERROR=4
      IF (NPEROD.LT.0 .AND. NPEROD.GT.4) IERROR=5
      IF (N.LT.3) IERROR=6
      IF (LDIMF.LT.L) IERROR=7
      IF (MDIMF.LT.M) IERROR=8
      IF (LPEROD.EQ.1 .AND. (A(1).NE.0. .OR. C(L).NE.0.)) IERROR=10
      IF (LPEROD.EQ.1) GO TO 200
      DO 100 I=1,L
      IF (A(I).NE.A(1)) GO TO 110
      IF (B(I).NE.B(1)) GO TO 110
      IF (C(I).NE.A(1)) GO TO 110
  100 CONTINUE
      GO TO 200
  110 IERROR=9
  200 IF (IERROR.NE.0) GO TO 400
C
C     ALLOCATE WORK ARRAY W
C
      IA=7
      IB=IA+L
      IC=IB+L
      ICFY=IC+L
      ICFZ=ICFY+4*M
      IFCTRD=ICFZ+4*N
      IWSY=IFCTRD+L*M*N
      IWSZ=IWSY+M+15
C
C     COPY COEFFICIENT ARRAYS A,B, AND C INTO WORK ARRAY.
C
      DO 300 I=0,L-1
      W(IA+I)=A(I+1)
      W(IB+I)=B(I+1)
  300 W(IC+I)=C(I+1)
      LP=LPEROD+1
      MP=MPEROD+1
      NP=NPEROD+1
      CALL PS3DI1(L,LP,M,MP,C1,N,NP,C2,W(IA),W(IB),W(IC),
     *            W(ICFY),W(ICFZ),W(IFCTRD),W(IWSY),W(IWSZ))
C
C     SAVE PARAMETERS FOR SUBROUTINE PSTG3D IN W.
C
      W(1)=L
      W(2)=LP
      W(3)=M
      W(4)=MP
      W(5)=N
      W(6)=NP
  400 CONTINUE
      RETURN
      END