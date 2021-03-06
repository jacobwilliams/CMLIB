C
C   DRIVER FOR TESTING CMLIB ROUTINES
C     CPZERO
C     RPZERO
C
C    ONE INPUT DATA CARD IS REQUIRED
C         READ(LIN,1) KPRINT,TIMES
C    1    FORMAT(I1,E10.0)
C
C     KPRINT = 0   NO PRINTING
C              1   NO PRINTING FOR PASSED TESTS, SHORT MESSAGE
C                  FOR FAILED TESTS
C              2   PRINT SHORT MESSAGE FOR PASSED TESTS, FULLER
C                  INFORMATION FOR FAILED TESTS
C              3   PRINT COMPLETE QUICK-CHECK RESULTS
C
C                ***IMPORTANT NOTE***
C         ALL QUICK CHECKS USE ROUTINES R2MACH AND D2MACH
C         TO SET THE ERROR TOLERANCES.
C     TIMES IS A CONSTANT MULTIPLIER THAT CAN BE USED TO SCALE THE
C     VALUES OF R1MACH AND D1MACH SO THAT
C               R2MACH(I) = R1MACH(I) * TIMES   FOR I=3,4,5
C               D2MACH(I) = D1MACH(I) * TIMES   FOR I=3,4,5
C     THIS MAKES IT EASILY POSSIBLE TO CHANGE THE ERROR TOLERANCES
C     USED IN THE QUICK CHECKS.
C     IF TIMES .LE. 0.0 THEN TIMES IS DEFAULTED TO 1.0
C
C              ***END NOTE***
C
      COMMON/UNIT/LUN
      COMMON/MSG/ICNT,JTEST(38)
      COMMON/XXMULT/TIMES
      LUN=I1MACH(2)
      LIN=I1MACH(1)
      ITEST=1
C
C     READ KPRINT,TIMES PARAMETERS FROM DATA CARD..
C
      READ(LIN,1) KPRINT,TIMES
1     FORMAT(I1,E10.0)
      IF(TIMES.LE.0.) TIMES=1.
      CALL XSETUN(LUN)
      CALL XSETF(1)
      CALL XERMAX(1000)
C   TEST CPZERO AND RPZERO
      CALL CPRPQX(KPRINT,IPASS)
      ITEST=ITEST*IPASS
C
      IF(KPRINT.GE.1.AND.ITEST.NE.1) WRITE(LUN,2)
2     FORMAT(/' ***** WARNING -- THE TEST FOR SUBLIBRARY CPZERO HAS FAILED,
     1  ***** ')
      IF(KPRINT.GE.1.AND.ITEST.EQ.1) WRITE(LUN,3)
3     FORMAT(/'----- SUBLIBRARY CPZERO PASSED ALL TESTS ----- ')
      END
      SUBROUTINE CPRPQX(KPRINT,IPASS)
C
C     THIS QUICK CHECK ROUTINE IS WRITTEN FOR CPZERO AND RPZERO.
C     THE ZEROS OF POLYNOMIAL WITH COEFFICIENTS A(.) ARE STORED
C     IN ZK(.).  RELERR IS THE RELATIVE ACCURACY REQUIRED FOR
C     THEM TO PASS.
C
      COMMON /MSG/ ICNT,ITEST(38)
      COMMON /UNIT/ LUN
      INTEGER KPRINT,IPASS,ICNT,ITEST,LUN
      INTEGER IDEG,IDEGP1,INFO,I,J,ID
      REAL A(6),ERR,ERRI,RELERR
      COMPLEX AC(6),Z(5),ZK(5),W(21)
      DATA IDEG / 5 /
      DATA A / 1., -3.7, 7.4, -10.8, 10.8, -6.8 /
      DATA ZK / (1.7,0.), (1.,1.), (1.,-1.),
     +          (0.,1.414213562 3730950488),
     +         (0.,-1.414213562 3730950488) /
      IPASS = 1
      IDEGP1 = IDEG+1
      RELERR = SQRT(R2MACH(4))
      DO 10 J=1,IDEGP1
         AC(J) = CMPLX(A(J),0.)
   10    CONTINUE
      INFO = 0
      CALL CPZERO(IDEG,AC,Z,W(4),INFO,W)
      IF (INFO .NE. 0) CALL XERROR(' CPRPQX -- INFO .NE. 0',22,101,2)
      DO 30 J=1,IDEG
         ERR = CABS(Z(J) - ZK(1))
         ID = 1
         DO 20 I=2,IDEG
            ERRI = CABS(Z(J) - ZK(I))
            IF (ERRI .LT. ERR) ID = I
            ERR = AMIN1(ERRI,ERR)
   20       CONTINUE
         IF (CABS(Z(J) - ZK(ID))/CABS(ZK(ID)) .GE. RELERR) IPASS = 0
   30    CONTINUE
      INFO = 0
      CALL RPZERO(IDEG,A,Z,W(4),INFO,W)
      IF (INFO .NE. 0) CALL XERROR(' CPRPQX -- INFO .NE. 0',22,102,2)
      DO 50 J=1,IDEG
         ERR = CABS(Z(J) - ZK(1))
         ID = 1
         DO 40 I=2,IDEG
            ERRI = CABS(Z(J) - ZK(I))
            IF (ERRI .LT. ERR) ID = I
            ERR = AMIN1(ERRI,ERR)
   40       CONTINUE
         IF (CABS(Z(J) - ZK(ID))/CABS(ZK(ID)) .GE. RELERR) IPASS = 0
   50    CONTINUE
      IF (KPRINT.GE.2 .AND. IPASS.NE.0) WRITE (LUN,670)
  670 FORMAT('CPRPQX PASSES ALL TESTS.')
      IF (KPRINT.GE.1 .AND. IPASS.EQ.0) WRITE (LUN,680)
  680 FORMAT('CPRPQX FAILS SOME TESTS.')
      RETURN
      END
      DOUBLE PRECISION FUNCTION D2MACH(I)
      DOUBLE PRECISION D1MACH
      COMMON/XXMULT/TIMES
      D2MACH=D1MACH(I)
      IF(I.EQ.1.OR. I.EQ.2) RETURN
      D2MACH = D2MACH * DBLE(TIMES)
      RETURN
      END
      REAL FUNCTION R2MACH(I)
      COMMON/XXMULT/TIMES
      R2MACH=R1MACH(I)
      IF(I.EQ.1.OR. I.EQ.2) RETURN
      R2MACH = R2MACH * TIMES
      RETURN
      END
