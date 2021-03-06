      SUBROUTINE STWAY(U,V,YHP,INOUT,STOWA)
C***BEGIN PROLOGUE  STWAY
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***REFER TO  BVSUP
C
C  This subroutine stores (recalls) integration data in the event
C  that a restart is needed (the homogeneous solution vectors become
C  too dependent to continue)
C***ROUTINES CALLED  STOR1
C***COMMON BLOCKS    ML15TO,ML18JR,ML8SZ
C***END PROLOGUE  STWAY
C
      DIMENSION U(*),V(*),YHP(*),STOWA(*)
C
      COMMON /ML8SZ/NFC,NCOMP,INHOMO,IGOFX,XSAV,C,IVP
      COMMON /ML15TO/XBEG,X,INFO(15),KOP,XOP,ISTKOP,MNSWOT,
     1               NSWOT,KNSWOT,LOTJP,PWCND,TND,XOT,PX,XEND
      COMMON /ML18JR/NXPTS,NIC,RE,AE,NOPG,MXNON,NDISK,NTAPE,NEQ,
     1              INDPVT,INTEG,TOL,NPS,NTP,NEQIVP,NUMORT,NFCC,ICOCO
C
C***FIRST EXECUTABLE STATEMENT  STWAY
      IF (INOUT .EQ. 1) GO TO 100
C
C     SAVE IN STOWA ARRAY AND ISTKOP
C
      KS=NFC*NCOMP
      CALL STOR1(STOWA,U,STOWA(KS+1),V,1,0,0)
      KS=KS+NCOMP
      IF (NEQIVP .EQ. 0) GO TO 50
      DO 25 J=1,NEQIVP
      KSJ=KS+J
   25 STOWA(KSJ)=YHP(KSJ)
   50 KS=KS+NEQIVP
      STOWA(KS+1)=X
      ISTKOP=KOP
      IF (XOP .EQ. X) ISTKOP=KOP+1
      RETURN
C
C     RECALL FROM STOWA ARRAY AND ISTKOP
C
  100 KS=NFC*NCOMP
      CALL STOR1(YHP,STOWA,YHP(KS+1),STOWA(KS+1),1,0,0)
      KS=KS+NCOMP
      IF (NEQIVP .EQ. 0) GO TO 150
      DO 125 J=1,NEQIVP
      KSJ=KS+J
  125 YHP(KSJ)=STOWA(KSJ)
  150 KS=KS+NEQIVP
      X=STOWA(KS+1)
      INFO(1)=0
      KO=KOP-ISTKOP
      KOP=ISTKOP
      IF (NDISK .EQ. 0  .OR.  KO .EQ. 0) RETURN
      DO 175 K=1,KO
  175 BACKSPACE NTAPE
      RETURN
      END
