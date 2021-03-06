*DJCKF
      SUBROUTINE DJCKF
     +   (FUN,N,NP,M,XPLUSD,LDXPD,BETA,ETA,TOL,
     +   J,NROW,PV,D,FD,PARMX,PVPSTP,STP,CURVE,
     +   PVTEMP,ISWRTB,MSG,LMSG,IFLAG)
C***BEGIN PROLOGUE  DJCKF
C***REFER TO  DODR,DODRC
C***ROUTINES CALLED  DPVB,DPVD
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
C***PURPOSE  CHECK WHETHER FINITE PRECISION ARITHMETIC COULD BE THE
C            CAUSE OF THE DISAGREEMENT BETWEEN THE DERIVATIVES.
C            (THIS ROUTINE IS MODELED AFTER STARPAC SUBROUTINE DCKFPA)
C***END PROLOGUE  DJCKF
C
C  EXTERNALS
C
      EXTERNAL FUN
C        THE NAME OF USER-SUPPLIED ROUTINE FOR COMPUTING THE MODEL.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE SECTION V.B,
C        ARGUMENT FUN.)
C
C  FUNCTION DECLARATIONS
C
      DOUBLE PRECISION DPVB
      DOUBLE PRECISION DPVD
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      DOUBLE PRECISION BETA(NP)
C        THE FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION CURVE
C        A MEASURE OF THE CURVATURE IN THE MODEL.
      DOUBLE PRECISION D
C        THE SCALAR IN WHICH ROW   NROW   OF THE DERIVATIVE
C        MATRIX WITH RESPECT TO THE JTH UNKNOWN PARAMETER
C        IS STORED.
      DOUBLE PRECISION ETA
C        THE RELATIVE NOISE IN THE MODEL
      DOUBLE PRECISION FD
C        THE FORWARD DIFFERENCE QUOTIENT DERIVATIVE WITH RESPECT TO THE
C        JTH PARAMETER
      INTEGER IFLAG
C        AN INDICATOR VARIABLE, USED PRIMARILY TO DESIGNATE THAT THE
C        USER WISHES THE COMPUTATIONS STOPPED.
      LOGICAL ISWRTB
C        THE CONTROL VALUE DETERMINING WHETHER THE DERIVATIVES WRT
C        BETA (ISWRTB=TRUE) OR DELTA(ISWRTB=FALSE) ARE BEING CHECKED.
      INTEGER J
C        THE INDEX OF THE PARTIAL DERIVATIVE BEING EXAMINED.
      LOGICAL LARGE
C        AN INDICATOR VALUE INDICATING WHETHER THE RECOMMENDED
C        INCREASE IN THE STEP SIZE WOULD BE GREATER THAN PARMX.
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
      DOUBLE PRECISION ONE
C        THE VALUE 1.0D0.
      DOUBLE PRECISION PARMX
C        THE MAXIMUM OF THE CURRENT PARAMETER ESTIMATE AND THE
C        TYPICAL VALUE OF THAT PARAMETER
      DOUBLE PRECISION PV
C        THE SCALAR IN WHICH THE PREDICTED VALUE FROM THE MODEL FOR
C        ROW   NROW   IS STORED.
      DOUBLE PRECISION PVPSTP
C        THE PREDICTED VALUE FOR ROW    NROW   OF THE MODEL
C        BASED ON THE CURRENT PARAMETER ESTIMATES
C        FOR ALL BUT THE JTH PARAMETER VALUE, WHICH IS BETA(J) + STP.
      DOUBLE PRECISION PVTEMP(N)
C        THE VECTOR OF PREDICTED VALUES FROM THE MODEL.
      DOUBLE PRECISION STP
C        THE STEP SIZE CURRENTLY BEING EXAMINED FOR THE FINITE DIFFERENC
C        DERIVATIVE
      DOUBLE PRECISION TEN
C        THE VALUE 10.0D0.
      DOUBLE PRECISION TOL
C        THE AGREEMENT TOLERANCE.
      DOUBLE PRECISION TWO
C        THE VALUE 2.0D0.
      DOUBLE PRECISION XPLUSD(LDXPD,M)
C        THE ARRAY X + DELTA.
C
C
      DATA ONE,TWO,TEN/1.0D0,2.0D0,10.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DJCKF
C
C
C  CHECK WHETHER FINITE PRECISION COULD BE THE PROBLEM
C
      IF (ABS(STP*(FD-D)).GE.TEN*ETA*(ABS(PV)+ABS(PVPSTP))) THEN
C
C  DISCREPANCY BETWEEN NUMERICAL AND ANALYTICAL DERIVATIVES CANNOT
C  BE ACCOUNTED FOR BY FINITE PRECISION ARITHMETIC
C
         MSG(1) = 1
         MSG(J+1) = 1
      ELSE
C
C  FINITE PRECISION ARITHMETIC COULD BE THE PROBLEM.
C  TRY A LARGER STEP SIZE
C
C
         IF (ISWRTB) THEN
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT BETA
C
            STP = (ETA*(ABS(PV)+ABS(PVPSTP))*SIGN(ONE,BETA(J))/
     +            (TOL*ABS(D))+BETA(J)) - BETA(J)
            IF (ABS(STP).GT.PARMX) THEN
               STP = PARMX*SIGN(ONE,BETA(J))
               LARGE = .TRUE.
            ELSE
               LARGE = .FALSE.
            END IF
            PVPSTP = DPVB(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                    NROW,J,STP,IFLAG)
         ELSE
C
C  PERFORM COMPUTATIONS FOR DERIVATIVES WRT DELTA
C
            STP = (ETA*(ABS(PV)+ABS(PVPSTP))*SIGN(ONE,XPLUSD(NROW,J))/
     +            (TOL*ABS(D))+XPLUSD(NROW,J)) - XPLUSD(NROW,J)
            IF (ABS(STP).GT.PARMX) THEN
               STP = PARMX*SIGN(ONE,XPLUSD(NROW,J))
               LARGE = .TRUE.
            ELSE
               LARGE = .FALSE.
            END IF
            PVPSTP = DPVD(FUN,N,NP,M,BETA,XPLUSD,LDXPD,PVTEMP,
     +                    NROW,J,STP,IFLAG)
         END IF
         IF (IFLAG.LT.0) THEN
            RETURN
         END IF
C
         FD = (PVPSTP-PV)/STP
C
C  CHECK FOR AGREEMENT
C
         IF ((ABS(FD-D)).GT.TWO*TOL*ABS(D)) THEN
C
C  FORWARD DIFFERENCE QUOTIENT AND ANALYTIC DERIVATIVES STILL DISAGREE.
C  CHECK IF CURVATURE IS THE PROBLEM
C
            IF (ABS(CURVE*STP).GE.ABS(FD-D) .OR. LARGE) THEN
C
C  CURVATURE MAY BE THE CULPRIT
C
               IF (MSG(1).EQ.0) MSG(1) = 2
               IF (LARGE) THEN
                  MSG(J+1) = 5
               ELSE
                  MSG(J+1) = 6
               END IF
            ELSE
C
C  CURVATURE COULDNT BE THE CULPRIT
C
               MSG(1) = 1
               MSG(J+1) = 1
            END IF
         END IF
      END IF
C
      RETURN
      END
