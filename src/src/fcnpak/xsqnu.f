      SUBROUTINE XSQNU(NU1,NU2,MU1,THETA,X,SX,ID,PQA,IPQA)
C***BEGIN PROLOGUE  XSQNU
C***REFER TO  XSLEGF
C***ROUTINES CALLED  XSADD, XSADJ, XSPQNU
C***DATE WRITTEN   820728   (YYMMDD)
C***REVISION DATE  871119   (YYMMDD)
C***CATEGORY NO.  C3a2,C9
C***KEYWORDS  LEGENDRE FUNCTIONS
C***AUTHOR  SMITH, JOHN M. (NBS AND GEORGE MASON UNIVERSITY)
C***PURPOSE  TO COMPUTE THE VALUES OF LEGENDRE FUNCTIONS FOR XSLEGF.
C  METHOD: BACKWARD NU-WISE RECURRENCE FOR Q(MU,NU,X) FOR FIXED MU TO
C          OBTAIN Q(MU1,NU1,X),Q(MU1,NU1+1,X),....,Q(MU1,NU2,X)
C***REFERENCES  OLVER AND SMITH,J.COMPUT.PHYSICS,51(1983),N0.3,502-518.
C***END PROLOGUE  XSQNU
      DIMENSION PQA(*),IPQA(*)
      REAL DMU,NU,NU1,NU2,PQ,PQA,PQ1,PQ2,SX,X,X1,X2
      REAL THETA,PQL1,PQL2
C***FIRST EXECUTABLE STATEMENT   XSQNU
      K=0
      PQ2=0.0
      IPQ2=0
      PQL2=0.0
      IPQL2=0
      IF(MU1.EQ.1) GO TO 290
      MU=0
C
C        CALL XSPQNU TO OBTAIN Q(0.,NU2,X) AND Q(0.,NU2-1,X)
C
      CALL XSPQNU(NU1,NU2,MU,THETA,ID,PQA,IPQA)
      IF(MU1.EQ.0) RETURN
      K=(NU2-NU1+1.5)
      PQ2=PQA(K)
      IPQ2=IPQA(K)
      PQL2=PQA(K-1)
      IPQL2=IPQA(K-1)
  290 MU=1
C
C        CALL XSPQNU TO OBTAIN Q(1.,NU2,X) AND Q(1.,NU2-1,X)
C
      CALL XSPQNU(NU1,NU2,MU,THETA,ID,PQA,IPQA)
      IF(MU1.EQ.1) RETURN
      NU=NU2
      PQ1=PQA(K)
      IPQ1=IPQA(K)
      PQL1=PQA(K-1)
      IPQL1=IPQA(K-1)
  300 MU=1
      DMU=1.
  320 CONTINUE
C
C        FORWARD RECURRENCE IN MU TO OBTAIN Q(MU1,NU2,X) AND
C              Q(MU1,NU2-1,X) USING
C              Q(MU+1,NU,X)=-2.*MU*X*SQRT(1./(1.-X**2))*Q(MU,NU,X)
C                   -(NU+MU)*(NU-MU+1.)*Q(MU-1,NU,X)
C
C              FIRST FOR NU=NU2
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
      PQA(K)=PQ
      IPQA(K)=IPQ
      IF(K.EQ.1) RETURN
      IF(NU.LT.NU2) GO TO 340
C
C              THEN FOR NU=NU2-1
C
      NU=NU-1.
      PQ2=PQL2
      IPQ2=IPQL2
      PQ1=PQL1
      IPQ1=IPQL1
      K=K-1
      GO TO 300
C
C         BACKWARD RECURRENCE IN NU TO OBTAIN
C              Q(MU1,NU1,X),Q(MU1,NU1+1,X),....,Q(MU1,NU2,X)
C              USING
C              (NU-MU+1.)*Q(MU,NU+1,X)=
C                       (2.*NU+1.)*X*Q(MU,NU,X)-(NU+MU)*Q(MU,NU-1,X)
C
  340 PQ1=PQA(K)
      IPQ1=IPQA(K)
      PQ2=PQA(K+1)
      IPQ2=IPQA(K+1)
  350 IF(NU.LE.NU1) RETURN
      K=K-1
      X1=(2.*NU+1.)*X*PQ1/(NU+DMU)
      X2=-(NU-DMU+1.)*PQ2/(NU+DMU)
      CALL XSADD(X1,IPQ1,X2,IPQ2,PQ,IPQ)
      CALL XSADJ(PQ,IPQ)
      PQ2=PQ1
      IPQ2=IPQ1
      PQ1=PQ
      IPQ1=IPQ
      PQA(K)=PQ
      IPQA(K)=IPQ
      NU=NU-1.
      GO TO 350
      END
