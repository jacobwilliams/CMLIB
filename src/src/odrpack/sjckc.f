*SJCKC
      SUBROUTINE SJCKC
     +   (FUN,N,NP,M,XPLUSD,LDXPD,BETA,ETA,TOL,EPSMAC,
     +   J,NROW,PV,D,FD,PARMX,PVPSTP,STP,
     +   PVTEMP,ISWRTB,MSG,LMSG,IFLAG)
C***BEGIN PROLOGUE  SJCKC
C***REFER TO  SODR,SODRC
C***ROUTINES CALLED  SJCKF,SPVB,SPVD
C***DATE WRITTEN   860529   (YYMMDD)
C***REVISION DATE  870204   (YYMMDD)
C***CATEGORY NO.  G2E,I1B1
C***KEYWORDS  ORTHOGONAL DISTANCE REGRESSION,
C             NONLINEAR LEAST SQUARES,
C             ERRORS IN VARIABLES
C***AUTHOR  BOGGS, PAUL T.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, GAITHERSBURG, MD 20899
C           BYRD, RICHARD H.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C           DONALDSON, JANET R.
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C           SCHNABEL, ROBERT B.
C             DEPARTMENT OF COMPUTER SCIENCE
C             UNIVERSITY OF COLORADO, BOULDER, CO 80309
C             AND
C             OPTIMIZATION GROUP/SCIENTIFIC COMPUTING DIVISION
C             NATIONAL BUREAU OF STANDARDS, BOULDER, CO 80303-3328
C***PURPOSE  CHECK WHETHER HIGH CURVATURE COULD BE THE CAUSE OF THE
C            DISAGREEMENT BETWEEN THE NUMERICAL AND ANALYTIC DERVIATIVES
C            (THIS ROUTINE IS MODELED AFTER STARPAC SUBROUTINE DCKCRV)
C***END PROLOGUE  SJCKC
C
C  EXTERNALS
C
      EXTERNAL FUN
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE MODEL.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT FUN.)
      EXTERNAL JAC
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE JACOBIANS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT JAC.)
C
C  FUNCTION DECLARATIONS
C
      REAL SPVB
      REAL SPVD
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      REAL BETA(NP)
C        THE FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      REAL CURVE
C        A MEASURE OF THE CURVATURE IN THE MODEL.
      REAL D
C        THE SCALAR IN WHICH ROW   NROW   OF THE DERIVATIVE
C        MATRIX WITH RESPECT TO THE JTH UNKNOWN PARAMETER
C        IS STORED.
      REAL EPSMAC
C        THE VALUE OF MACHINE PRECISION.
      REAL ETA
C        THE RELATIVE NOISE IN THE MODEL.
      REAL FD
C        THE FORWARD DIFFERENCE QUOTIENT DERIVATIVE WITH RESPECT TO THE
C        JTH PARAMETER.
      REAL FIVE
C         THE VALUE 5.0E0.
      INTEGER IFLAG
C        AN INDICATOR VARIABLE, USED PRIMARILY TO DESIGNATE THAT THE
C        USER WISHES THE COMPUTATIONS STOPPED.
      LOGICAL ISWRTB
C        THE CONTROL VALUE DETERMINING WHETHER THE DERIVATIVES WRT
C        BETA (ISWRTB=TRUE) OR DELTA(ISWRTB=FALSE) ARE BEING CHECKED.
      INTEGER J
C        THE INDEX OF THE PARTIAL DERIVATIVE BEING EXAMINED.
      INTEGER LDXPD
C        THE LEADING DIMENSION OF ARRAY XPLUSD.
      INTEGER LMSG
C        THE LENGTH OF THE VECTOR MSG.
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER MSG(LMSG)
C        THE ERROR CHECKING RESULTS.
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NROW
C        THE NUMBER OF THE ROW OF THE INDEPENDENT VARIABLE ARRAY AT
C        WHICH THE DERIVATIVE IS TO BE CHECKED.
      REAL ONE
C         THE VALUE 1.0E0.
      REAL PARMX
C        THE MAXIMUM OF THE CURRENT PARAMETER ESTIMATE.
      REAL PV
C        THE SCALAR IN WHICH THE PREDICTED VALUE FROM THE MODEL FOR
C        ROW   NROW   IS STORED.
      REAL PVMCRV
C        THE PREDICTED VALUE FOR ROW    NROW   OF THE MODEL
C        BASED ON THE CURRENT PARAMETER ESTIMATES
C        FOR ALL BUT THE JTH PARAMETER VALUE, WHICH IS BETA(J)-STPCRV.
      REAL PVPCRV
C        THE PREDICTED VALUE FOR ROW    NROW   OF THE MODEL
C        BASED ON THE CURRENT PARAMETER ESTIMATES
C        FOR ALL BUT THE JTH PARAMETER VALUE, WHICH IS BETA(J)+STPCRV.
      REAL PVPSTP
C        THE PREDICTED VALUE FOR ROW    NROW   OF THE MODEL
C        BASED ON THE CURRENT PARAMETER ESTIMATES
C        FOR ALL BUT THE JTH PARAMETER VALUE, WHICH IS BETA(J) + STP.
      REAL PVTEMP(N)
C        THE VECTOR OF PREDICTED VALUES FROM THE MODEL.
      REAL STP
C        THE STEP SIZE CURRENTLY BEING EXAMINED FOR THE FINITE DIFFERENC
C        DERIVATIVE
      REAL STPCRV
C        THE STEP SIZE SELECTED TO CHECK FOR CURVATURE IN THE MODEL.
      REAL THIRD
C        THE VALUE 1.0E0/3.0E0.
      REAL THREE
C         THE VALUE 3.0E0.
      REAL TOL
C        THE AGREEMENT TOLERANCE.
      REAL TWO
C         THE VALUE 2.0E0.
      REAL XPLUSD(LDXPD,M)
C        THE ARRAY X + DELTA.
      REAL ZERO
C         THE VALUE 0.0E0.
C
C
      DATA ZERO,ONE,TWO,THREE,FIVE/0.0E0,1.0E0,2.0E0,3.0E0,5.0E0/
C
C
C***FIRST EXECUTABLE STATEMENT  SJCKC
C
C
      THIRD = ONE/THREE
C
      IF (ISWRTB) THEN
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT BETA
C
         STPCRV = (ETA**THIRD*PARMX*SIGN(ONE,BETA(J))+BETA(J)) - BETA(J)
         PVPCRV = SPVB(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                  NROW,J,STPCRV,IFLAG)
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
         PVMCRV = SPVB(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                  NROW,J,-STPCRV,IFLAG)
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
      ELSE
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT DELTA
C
         STPCRV = (ETA**THIRD*PARMX*SIGN(ONE,XPLUSD(NROW,J))+
     +             XPLUSD(NROW,J)) - XPLUSD(NROW,J)
         PVPCRV = SPVD(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                 NROW,J,STPCRV,IFLAG)
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
         PVMCRV = SPVD(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                 NROW,J,-STPCRV,IFLAG)
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
      END IF
      IF (IFLAG.LT.0) THEN
         RETURN
      END IF
C
C  ESTIMATE CURVATURE BY SECOND DERIVATIVE OF MODEL
C
      CURVE = ((PVPCRV-PV)+(PVMCRV-PV)) / (STPCRV*STPCRV)
      CURVE = CURVE + (ETA ** THIRD) * (ABS(PVPCRV) +
     +        ABS(PVMCRV) + TWO * ABS(PV)) / (PARMX * PARMX)
C
C  COMPARE NUMERICAL AND ANALYTICAL DERIVATIVES USING A FUDGE
C  FACTOR OF TEN.
C
      IF (ABS(CURVE*STP)*FIVE.LT.ABS(FD-D)) THEN
C
C  CURVATURE CANNOT ACCOUNT FOR DISCREPANCY.
C
C  CHECK IF FINITE PRECISION ARITHMETIC COULD BE THE CULPRIT.
C
         CALL SJCKF(FUN,N,NP,M,XPLUSD,LDXPD,BETA,ETA,TOL,
     +              J,NROW,PV,D,FD,PARMX,PVPSTP,STP,CURVE,
     +              PVTEMP,ISWRTB,MSG,LMSG,IFLAG)
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
C
      ELSE
C
C  HIGH CURVATURE COULD BE THE PROBLEM.  TRY A SMALLER STEP SIZE.
C
C  COMPUTE DERIVATIVE WITH SMALLER STEP SIZE
C  IF SMALLER STEP SIZE IS TOO SMALL SET MSG(J+1)=1 ELSE COMPUTE
C  PREDICTED VALUE WITH NEW STEP.
C
         IF (ISWRTB) THEN
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT BETA
C
            STP = (TWO*TOL*ABS(D)*SIGN(ONE,BETA(J)) /
     +             ABS(CURVE)+BETA(J)) - BETA(J)
            IF (ABS(STP).LE.EPSMAC*ABS(BETA(J))) THEN
               IF (MSG(1).EQ.0) MSG(1) = 2
               MSG(J+1) = 6
               RETURN
            ELSE
               PVPSTP = SPVB(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                       NROW,J,STP,IFLAG)
               IF (IFLAG.LT.0) THEN
                  RETURN
               END IF
            END IF
         ELSE
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT DELTA
C
            STP = (TWO*TOL*ABS(D)*SIGN(ONE,XPLUSD(NROW,J)) /
     +             ABS(CURVE)+XPLUSD(NROW,J)) - XPLUSD(NROW,J)
            IF (ABS(STP).LE.EPSMAC*ABS(XPLUSD(NROW,J))) THEN
               IF (MSG(1).EQ.0) MSG(1) = 2
               MSG(J+1) = 6
               RETURN
            ELSE
               PVPSTP = SPVD(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                       NROW,J,STP,IFLAG)
               IF (IFLAG.LT.0) THEN
                  RETURN
               END IF
            END IF
         END IF
C
C  COMPUTE THE NEW NUMERICAL DERIVATIVE
C
         FD = (PVPSTP-PV)/STP
C
C  CHECK WHETHER THE NEW NUMERICAL DERIVATIVE IS OK
C
         IF (ABS(FD-D).GT.TWO*TOL*ABS(D)) THEN
C
C  NUMERICAL DERIVATIVE COMPUTED USING NEW STEP SIZE DOES
C  NOT AGREE WITH ANALYTIC DERIVATIVE.
C
C  CHECK IF THE PROBLEM COULD BE THE FORWARD DIFFERENCE QUOTIENT
C  DERIVATIVE.
C
C  (FUDGE FACTOR IS 2)
C
            IF (ABS(STP*(FD-D)).GE.TWO*ETA*ABS(PV+PVPSTP)) THEN
C
C  FINITE PRECISION COULD NOT BE THE CULPRIT
C
               MSG(1) = 1
               MSG(J+1) = 1
            ELSE
C
C  FINITE PRECISION MAY BE THE CULPRIT
C
               IF (MSG(1).EQ.0) MSG(1) = 2
               MSG(J+1) = 6
            END IF
         END IF
      END IF
C
      RETURN
      END
