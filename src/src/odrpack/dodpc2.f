*DODPC2
      SUBROUTINE DODPC2
     +   (IPR,FSTITR,LUNRPT,NP,
     +   NJEV,NFEV,RNORM,ACTRED,PRERED,ALPHA,TAU,PNORM,BETA)
C***BEGIN PROLOGUE  DODPC2
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
C***PURPOSE  GENERATE ITERATION REPORTS
C***END PROLOGUE  DODPC2
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      DOUBLE PRECISION ACTRED
C        THE ACTUAL RELATIVE REDUCTION IN THE SUM-OF-SQUARES
C        OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION ALPHA
C        THE LEVENBERG-MARQUARDT PARAMETER.
      DOUBLE PRECISION BETA(NP)
C        THE FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      LOGICAL FSTITR
C        THE INDICATOR VARIABLE USED TO DESIGNATE WHETHER THIS IS THE
C        FIRST ITERATION (FSTITR=.TRUE.) OR NOT (FSTITR=.FALSE.).
      CHARACTER*3 GN
C        THE CHARACTER VARIABLE USED TO INDICATE WHETHER A GAUSS-NEWTON
C        STEP WAS TAKEN.
      INTEGER IPR
C        THE VALUE WHICH CONTROLS THE REPORT BEING PRINTED.
      INTEGER J
C        AN INDEXING VARIABLE.
      INTEGER K
C        AN INDEXING VARIABLE.
      INTEGER L
C        AN INDEXING VARIABLE.
      INTEGER LUNRPT
C        THE LOGICAL UNIT NUMBER USED FOR COMPUTATION REPORTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NFEV
C        THE NUMBER OF FUNCTION EVALUATIONS.
      INTEGER NJEV
C        THE NUMBER OF JACOBIAN EVALUATIONS.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION PNORM
C        THE NORM OF THE SCALED ESTIMATED PARAMETERS.
      DOUBLE PRECISION PRERED
C        THE PREDICTED RELATIVE REDUCTION IN THE SUM-OF-SQUARES
C        OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION RATIO
C        THE RATIO OF TAU TO PNORM.
      DOUBLE PRECISION RNORM
C        THE NORM OF THE WEIGHTED OBSERVATIONAL ERRORS.
      DOUBLE PRECISION TAU
C        THE TRUST REGION DIAMETER.
      DOUBLE PRECISION ZERO
C          THE VALUE 0.0D0.
C
C
      DATA ZERO/0.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DODPC2
C
C
      IF (FSTITR) THEN
         IF (IPR.EQ.1) THEN
            WRITE (LUNRPT,1120)
         ELSE
            WRITE (LUNRPT,1130)
         END IF
      END IF
      IF (ALPHA.EQ.ZERO) THEN
         GN = 'YES'
      ELSE
         GN = ' NO'
      END IF
      IF (PNORM.NE.ZERO) THEN
         RATIO = TAU/PNORM
      ELSE
         RATIO = ZERO
      END IF
      IF (IPR.EQ.1) THEN
         WRITE (LUNRPT,1141) NJEV,NFEV,RNORM**2,ACTRED,PRERED,
     +                       RATIO,GN
      ELSE
         J = 1
         K = MIN(3,NP)
         IF (J.EQ.K) THEN
            WRITE (LUNRPT,1141) NJEV,NFEV,RNORM**2,ACTRED,PRERED,
     +                          RATIO,GN,J,BETA(J)
         ELSE
            WRITE (LUNRPT,1142) NJEV,NFEV,RNORM**2,ACTRED,PRERED,
     +                          RATIO,GN,J,K,(BETA(L),L=J,K)
         END IF
         IF (NP.GT.3) THEN
            DO 10 J=4,NP,3
               K = MIN(J+2,NP)
               IF (J.EQ.K) THEN
                  WRITE (LUNRPT,1151) J,BETA(J)
               ELSE
                  WRITE (LUNRPT,1152) J,K,(BETA(L),L=J,K)
               END IF
   10       CONTINUE
         END IF
      END IF
C
      RETURN
C
C  FORMAT STATEMENTS
C
 1120 FORMAT
     +   (//
     +    '         CUM.                 ACT. REL.   PRED. REL.'/
     +    '  IT.  NO. FN     WEIGHTED   SUM-OF-SQS   SUM-OF-SQS',
     +    '              G-N'/
     +    ' NUM.   EVALS   SUM-OF-SQS    REDUCTION    REDUCTION',
     +    '  TAU/PNORM  STEP'/
     +    ' ----  ------  -----------  -----------  -----------',
     +    '  ---------  ----'/)
 1130 FORMAT
     +   (//
     +    '         CUM.                 ACT. REL.   PRED. REL.'/
     +    '  IT.  NO. FN     WEIGHTED   SUM-OF-SQS   SUM-OF-SQS',
     +    '              G-N      BETA -------------->'/
     +    ' NUM.   EVALS   SUM-OF-SQS    REDUCTION    REDUCTION',
     +    '  TAU/PNORM  STEP     INDEX           VALUE'/
     +    ' ----  ------  -----------  -----------  -----------',
     +    '  ---------  ----     -----           -----'/)
 1141 FORMAT
     +   (1X,I4,I8,1X,D12.5,2D13.4,D11.3,3X,A3,7X,I3,3D16.8)
 1142 FORMAT
     +   (1X,I4,I8,1X,D12.5,2D13.4,D11.3,3X,A3,1X,I3,' TO',I3,3D16.8)
 1151 FORMAT
     +   (76X,I3,D16.8)
 1152 FORMAT
     +   (70X,I3,' TO',I3,3D16.8)
      END
