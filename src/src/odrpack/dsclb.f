*DSCLB
      SUBROUTINE DSCLB
     +   (NP,BETA,EPSMAC,SSF)
C***BEGIN PROLOGUE  DSCLB
C***REFER TO  DODR,DODRC
C***ROUTINES CALLED  (NONE)
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
C***PURPOSE  COMPUTE APPROPRIATE SCALE VALUES FOR BETA'S ACCORDING TO
C            THE ALGORITHM GIVEN IN THE PROLOGUES FOR DODR AND DODRC
C***END PROLOGUE  DSCLB
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      DOUBLE PRECISION BETA(NP)
C        THE FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      LOGICAL BIGDIF
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THERE IS A
C        SIGNIFICANT DIFFERENCE IN THE MAGNITUDES OF THE NON ZERO
C        BETA'S (BIGDIF=.TRUE.) OR NOT (BIGDIF=.FALSE.).
      DOUBLE PRECISION BMAX
C        THE LARGEST NON ZERO MAGNITUDE.
      DOUBLE PRECISION BMIN
C        THE SMALLEST NON ZERO MAGNITUDE.
      DOUBLE PRECISION EPSMAC
C        THE VALUE OF MACHINE PRECISION.
      INTEGER K
C        AN INDEXING VARIABLE.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION ONE
C        THE VALUE 1.0D0.
      DOUBLE PRECISION SSF(NP)
C        THE SCALE USED FOR THE BETA'S.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION TWO
C        THE VALUE 2.0D0.
      DOUBLE PRECISION ZERO
C        THE VALUE 0.0D0.
C
C
      DATA ZERO,ONE,TWO/0.0D0,1.0D0,2.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DSCLB
C
C
      BMAX = ABS(BETA(1))
      DO 10 K=2,NP
         BMAX = MAX(BMAX,ABS(BETA(K)))
   10 CONTINUE
C
      IF (BMAX.EQ.ZERO) THEN
C
C  ALL INPUT VALUES OF BETA ARE ZERO
C
         DO 20 K=1,NP
            SSF(K) = ONE
   20    CONTINUE
C
      ELSE
C
C  SOME OF THE INPUT VALUES ARE NONZERO
C
         BMIN = BMAX
         DO 30 K=1,NP
            IF (BETA(K).NE.ZERO) THEN
               BMIN = MIN(BMIN,ABS(BETA(K)))
            END IF
   30    CONTINUE
         BIGDIF = LOG10(BMAX)-LOG10(BMIN).GE.TWO
         DO 40 K=1,NP
            IF (BETA(K).EQ.ZERO) THEN
               SSF(K) =  ONE/(SQRT(EPSMAC)*BMIN)
            ELSE
               IF (BIGDIF) THEN
                  SSF(K) = ONE/ABS(BETA(K))
               ELSE
                  SSF(K) = ONE/BMAX
               END IF
            END IF
   40    CONTINUE
C
      END IF
C
      RETURN
      END
