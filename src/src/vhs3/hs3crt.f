      SUBROUTINE HS3CRT (BDXS,BDXF,BDYS,BDYF,BDZS,BDZF,
     1                   LDIMF,MDIMF,F,PERTRB,W)
C
C     PACKAGE HS3CRT, VERSION 1, AUGUST 1985
C
      DIMENSION BDXS(MDIMF,*),BDXF(MDIMF,*),BDYS(LDIMF,*),BDYF(LDIMF,*),
     1          BDZS(LDIMF,*),BDZF(LDIMF,*),F(LDIMF,MDIMF,*),W(*)
      DELTAX=W(1)
      L=W(2)
      LP=W(3)
      DELTAY=W(4)
      M=W(5)
      MP=W(6)
      DELTAZ=W(7)
      N=W(8)
      NP=W(9)
      ELMBDA=W(10)
      LPEROD = 0
      IF (LP .GT. 1) LPEROD = 1
      DLXRCP = 1./DELTAX
      TWDXSQ = 2./DELTAX**2
      DLYRCP = 1./DELTAY
      TWDYSQ = 2./DELTAY**2
      DLZRCP = 1./DELTAZ
      TWDZSQ = 2./DELTAZ**2
C
C     ENTER BOUNDARY DATA FOR X-BOUNDARIES.
C
      GO TO (111,102,102,104,104),LP
  102 DO 103 K=1,N
      DO 103 J=1,M
         F(1,J,K) = F(1,J,K)-BDXS(J,K)*TWDXSQ
  103 CONTINUE
      GO TO 106
  104 DO 105 K=1,N
      DO 105 J=1,M
         F(1,J,K) = F(1,J,K)+BDXS(J,K)*DLXRCP
  105 CONTINUE
  106 GO TO (111,107,109,109,107),LP
  107 DO 108 K=1,N
      DO 108 J=1,M
         F(L,J,K) = F(L,J,K)-BDXF(J,K)*TWDXSQ
  108 CONTINUE
      GO TO 111
  109 DO 110 K=1,N
      DO 110 J=1,M
         F(L,J,K) = F(L,J,K)-BDXF(J,K)*DLXRCP
  110 CONTINUE
  111 CONTINUE
C
C     ENTER BOUNDARY DATA FOR Y-BOUNDARIES.
C
      GO TO (121,112,112,114,114),MP
  112 DO 113 K=1,N
      DO 113 I=1,L
         F(I,1,K) = F(I,1,K)-BDYS(I,K)*TWDYSQ
  113 CONTINUE
      GO TO 116
  114 DO 115 K=1,N
      DO 115 I=1,L
         F(I,1,K) = F(I,1,K)+BDYS(I,K)*DLYRCP
  115 CONTINUE
  116 GO TO (121,117,119,119,117),MP
  117 DO 118 K=1,N
      DO 118 I=1,L
         F(I,M,K) = F(I,M,K)-BDYF(I,K)*TWDYSQ
  118 CONTINUE
      GO TO 121
  119 DO 120 K=1,N
      DO 120 I=1,L
         F(I,M,K) = F(I,M,K)-BDYF(I,K)*DLYRCP
  120 CONTINUE
  121 CONTINUE
C
C     ENTER BOUNDARY DATA FOR Z-BOUNDARIES.
C
      GO TO (221,212,212,214,214),NP
  212 DO 213 J=1,M
      DO 213 I=1,L
         F(I,J,1) = F(I,J,1)-BDZS(I,J)*TWDZSQ
  213 CONTINUE
      GO TO 216
  214 DO 215 J=1,M
      DO 215 I=1,L
         F(I,J,1) = F(I,J,1)+BDZS(I,J)*DLZRCP
  215 CONTINUE
  216 GO TO (221,217,219,219,217),NP
  217 DO 218 J=1,M
      DO 218 I=1,L
         F(I,J,N) = F(I,J,N)-BDZF(I,J)*TWDZSQ
  218 CONTINUE
      GO TO 221
  219 DO 220 J=1,M
      DO 220 I=1,L
         F(I,J,N) = F(I,J,N)-BDZF(I,J)*DLZRCP
  220 CONTINUE
  221 CONTINUE
      PERTRB = 0.
      IF (ELMBDA.NE.0.) GO TO 133
  126 GO TO (226,133,133,226,133),LP
  226 GO TO (127,133,133,127,133),MP
  127 GO TO (128,133,133,128,133),NP
C
C     FOR SINGULAR PROBLEMS MUST ADJUST DATA TO INSURE THAT A SOLUTION
C     WILL EXIST.
C
  128 CONTINUE
      S = 0.
      DO 230 K=1,N
      DO 130 J=1,M
         DO 129 I=1,L
            S = S+F(I,J,K)
  129    CONTINUE
  130 CONTINUE
  230 CONTINUE
      PERTRB = S/(L*M*N)
      DO 232 K=1,N
      DO 132 J=1,M
         DO 131 I=1,L
            F(I,J,K) = F(I,J,K)-PERTRB
  131    CONTINUE
  132 CONTINUE
  232 CONTINUE
  133 CONTINUE
C
C     ALLOCATE WORK ARRAY W
C
      IW=3*L+11
C
C     SOLVE THE EQUATION
C
      CALL PSTG3D (LDIMF,MDIMF,F,W(IW))
      RETURN
      END
