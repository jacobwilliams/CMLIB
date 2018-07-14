      SUBROUTINE XSPNRM(NU1,NU2,MU1,MU2,PQA,IPQA)
C***BEGIN PROLOGUE  XSPNRM
C***REFER TO  XSLEGF
C***ROUTINES CALLED  XSADJ
C***DATE WRITTEN   820728   (YYMMDD)
C***REVISION DATE  871119   (YYMMDD)
C***CATEGORY NO.  C3a2,C9
C***KEYWORDS  LEGENDRE FUNCTIONS
C***AUTHOR  SMITH, JOHN M. (NBS AND GEORGE MASON UNIVERSITY)
C***PURPOSE  TO COMPUTE THE VALUES OF LEGENDRE FUNCTIONS FOR XSLEGF.
C        SUBROUTINE XSPNRM TRANSFORMS AN ARRAY OF LEGENDRE
C        FUNCTIONS OF THE FIRST KIND OF NEGATIVE ORDER STORED
C        IN ARRAY PQA INTO NORMALIZED LEGENDRE POLYNOMIALS STORED
C        IN ARRAY PQA. THE ORIGINAL ARRAY IS DESTROYED.
C***REFERENCES  OLVER AND SMITH,J.COMPUT.PHYSICS,51(1983),N0.3,502-518.
C***END PROLOGUE  XSPNRM
      REAL C1,DMU,NU,NU1,NU2,PQA,PROD
      DIMENSION PQA(*),IPQA(*)
C***FIRST EXECUTABLE STATEMENT   XSPNRM
      L=(MU2-MU1)+(NU2-NU1+1.5)
      MU=MU1
      DMU=(FLOAT(MU1))
      NU=NU1
C
C         IF MU .GT.NU, NORM P =0.
C
      J=1
  500 IF(DMU.LE.NU) GO TO 505
      PQA(J)=0.
      IPQA(J)=0
      J=J+1
      IF(J.GT.L) RETURN
C
C        INCREMENT EITHER MU OR NU AS APPROPRIATE.
C
      IF(MU2.GT.MU1) DMU=DMU+1.
      IF(NU2-NU1.GT..5) NU=NU+1.
      GO TO 500
C
C         TRANSFORM P(-MU,NU,X) INTO NORMALIZED P(MU,NU,X) USING
C              NORM P(MU,NU,X)=
C                 SQRT((NU+.5)*FACTORIAL(NU+MU)/FACTORIAL(NU-MU))
C                              *P(-MU,NU,X)
C
  505 PROD=1.
      IPROD=0
      K=2*MU
      IF(K.LE.0) GO TO 520
      DO 510 I=1,K
      PROD=PROD*SQRT(NU+DMU+1.-(FLOAT(I)))
  510 CALL XSADJ(PROD,IPROD)
  520 DO 540 I=J,L
      C1=PROD*SQRT(NU+.5)
      PQA(I)=PQA(I)*C1
      IPQA(I)=IPQA(I)+IPROD
      CALL XSADJ(PQA(I),IPQA(I))
      IF(NU2-NU1.GT..5) GO TO 530
      IF(DMU.GE.NU) GO TO 525
      PROD=SQRT(NU+DMU+1.)*PROD
      IF(NU.GT.DMU) PROD=PROD*SQRT(NU-DMU)
      CALL XSADJ(PROD,IPROD)
      MU=MU+1
      DMU=DMU+1.
      GO TO 540
  525 PROD=0.
      IPROD=0
      MU=MU+1
      DMU=DMU+1.
      GO TO 540
  530 PROD=SQRT(NU+DMU+1.)*PROD
      IF(NU.NE.DMU-1.) PROD=PROD/SQRT(NU-DMU+1.)
      CALL XSADJ(PROD,IPROD)
      NU=NU+1.
  540 CONTINUE
      RETURN
      END