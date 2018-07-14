      SUBROUTINE XSQMU(NU1,NU2,MU1,MU2,THETA,X,SX,ID,PQA,IPQA)
C***BEGIN PROLOGUE  XSQMU
C***REFER TO  XSLEGF
C***ROUTINES CALLED  XSADD, XSADJ, XSPQNU
C***DATE WRITTEN   820728   (YYMMDD)
C***REVISION DATE  871119   (YYMMDD)
C***CATEGORY NO.  C3a2,C9
C***KEYWORDS  LEGENDRE FUNCTIONS
C***AUTHOR  SMITH, JOHN M. (NBS AND GEORGE MASON UNIVERSITY)
C***PURPOSE  TO COMPUTE THE VALUES OF LEGENDRE FUNCTIONS FOR XSLEGF.
C METHOD: FORWARD MU-WISE RECURRENCE FOR Q(MU,NU,X) FOR FIXED NU TO
C         OBTAIN  Q(MU1,NU,X),Q(MU1+1,NU,X),....,Q(MU2,NU,X)
C***REFERENCES  OLVER AND SMITH,J.COMPUT.PHYSICS,51(1983),N0.3,502-518.
C***END PROLOGUE  XSQMU
      DIMENSION PQA(*),IPQA(*)
      REAL DMU,NU,NU1,NU2,PQ,PQA,PQ1,PQ2,SX,X,X1,X2
      REAL THETA
C***FIRST EXECUTABLE STATEMENT   XSQMU
      MU=0
C
C        CALL XSPQNU TO OBTAIN Q(0.,NU1,X)
C
      CALL XSPQNU(NU1,NU2,MU,THETA,ID,PQA,IPQA)
      PQ2=PQA(1)
      IPQ2=IPQA(1)
      MU=1
C
C        CALL XSPQNU TO OBTAIN Q(1.,NU1,X)
C
      CALL XSPQNU(NU1,NU2,MU,THETA,ID,PQA,IPQA)
      NU=NU1
      K=0
      MU=1
      DMU=1.
      PQ1=PQA(1)
      IPQ1=IPQA(1)
      IF(MU1.GT.0) GO TO 310
      K=K+1
      PQA(K)=PQ2
      IPQA(K)=IPQ2
      IF(MU2.LT.1) GO TO 330
  310 IF(MU1.GT.1) GO TO 320
      K=K+1
      PQA(K)=PQ1
      IPQA(K)=IPQ1
      IF(MU2.LE.1) GO TO 330
  320 CONTINUE
C
C        FORWARD RECURRENCE IN MU TO OBTAIN
C                  Q(MU1,NU,X),Q(MU1+1,NU,X),....,Q(MU2,NU,X) USING
C             Q(MU+1,NU,X)=-2.*MU*X*SQRT(1./(1.-X**2))*Q(MU,NU,X)
C                               -(NU+MU)*(NU-MU+1.)*Q(MU-1,NU,X)
C
      X1=-2.*DMU*X*SX*PQ1
      X2=(NU+DMU)*(NU-DMU+1.)*PQ2
      CALL XSADD(X1,IPQ1,-X2,IPQ2,PQ,IPQ)
      CALL XSADJ(PQ,IPQ)
      PQ2=PQ1
      IPQ2=IPQ1
      PQ1=PQ
      IPQ1=IPQ
      MU=MU+1
      DMU=DMU+1.
      IF(MU.LT.MU1) GO TO 320
      K=K+1
      PQA(K)=PQ
      IPQA(K)=IPQ
      IF(MU2.GT.MU) GO TO 320
  330 RETURN
      END
