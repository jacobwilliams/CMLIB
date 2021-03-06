*DODPE1
      SUBROUTINE DODPE1
     +   (UNIT,D1,D2,D3,D4,D5,
     +   N,M,
     +   LDSCLD,LDRHO,
     +   LWKMN,LIWKMN,
     +   SCLD,SCLB,NP,W,RHO)
C***BEGIN PROLOGUE  DODPE1
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
C***PURPOSE  PRINT ERROR REPORTS.
C***END PROLOGUE  DODPE1
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      INTEGER D1
C        THE FIRST DIGIT OF INFO.
      INTEGER D2
C        THE SECOND DIGIT OF INFO.
      INTEGER D3
C        THE THIRD DIGIT OF INFO.
      INTEGER D4
C        THE FOURTH DIGIT OF INFO.
      INTEGER D5
C        THE FIFTH DIGIT OF INFO.
      INTEGER LDRHO
C        THE LEADING DIMENSION OF ARRAY RHO.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LDSCLD
C        THE LEADING DIMENSION OF ARRAY SCLD.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LIWKMN
C        THE MINIMUM ACCEPTABLE LENGTH OF ARRAY IWORK.
      INTEGER LWKMN
C        THE MINIMUM ACCEPTABLE LENGTH OF ARRAY WORK.
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION RHO(LDRHO,M)
C        THE DELTA WEIGHTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION SCLB(NP)
C        THE SCALE OF EACH BETA.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION SCLD(LDSCLD,M)
C        THE SCALE OF EACH DELTA.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER UNIT
C        THE LOGICAL UNIT NUMBER USED FOR ERROR MESSAGES.
      DOUBLE PRECISION W(N)
C        THE OBSERVATIONAL ERROR WEIGHTS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION ZERO
C          THE VALUE 0.0D0.
C
C
      DATA ZERO/0.0D0/
C
C
C***FIRST EXECUTABLE STATEMENT  DODPE1
C
C
C  PRINT APPROPRIATE MESSAGES FOR ERRORS IN PROBLEM SPECIFICATION
C  PARAMETERS
C
      IF (D1.EQ.1) THEN
         IF (D2.NE.0) THEN
            WRITE(UNIT,1100)
         END IF
         IF (D3.NE.0) THEN
            WRITE(UNIT,1200)
         END IF
         IF (D4.NE.0) THEN
            WRITE(UNIT,1300)
         END IF
C
C  PRINT APPROPRIATE MESSAGES FOR ERRORS IN DIMENSION SPECIFICATION
C  PARAMETERS
C
      ELSE IF (D1.EQ.2) THEN
         IF (D2.NE.0) THEN
            WRITE(UNIT,2100)
         END IF
         IF (D3.NE.0) THEN
            IF (D3.EQ.1 .OR. D3.EQ.3 .OR. D3.EQ.5 .OR. D3.EQ.7) THEN
               WRITE(UNIT,2210)
            END IF
            IF (D3.EQ.2 .OR. D3.EQ.3 .OR. D3.EQ.6 .OR. D3.EQ.7) THEN
               WRITE(UNIT,2220)
            END IF
            IF (D3.EQ.4 .OR. D3.EQ.5 .OR. D3.EQ.6 .OR. D3.EQ.7) THEN
               WRITE(UNIT,2230)
            END IF
         END IF
         IF (D4.NE.0) THEN
            WRITE(UNIT,2300) LWKMN
         END IF
         IF (D5.NE.0) THEN
            WRITE(UNIT,2400) LIWKMN
         END IF
C
      ELSE IF (D1.EQ.3) THEN
C
C  PRINT APPROPRIATE MESSAGES FOR ERRORS SCALE VALUES
C
         IF (D2.NE.0) THEN
            IF (LDSCLD.GE.N) THEN
               WRITE(UNIT,3110)
            ELSE
               WRITE(UNIT,3120)
            END IF
         END IF
         IF (D3.NE.0) THEN
            WRITE(UNIT,3130)
         END IF
C
C  PRINT APPROPRIATE MESSAGES FOR ERRORS IN OBSERVATIONAL ERROR WEIGHTS
C
         IF (D4.NE.0) THEN
            IF (D4.EQ.1) THEN
               WRITE(UNIT,3210)
            ELSE
               WRITE(UNIT,3220)
            END IF
         END IF
C
C  PRINT APPROPRIATE MESSAGES FOR ERRORS IN DELTA WEIGHTS
C
         IF (D5.NE.0) THEN
            IF (LDRHO.GE.N) THEN
               WRITE(UNIT,3310)
            ELSE
               WRITE(UNIT,3320)
            END IF
         END IF
C
      END IF
C
C  FORMAT STATEMENTS
C
 1100 FORMAT
     +   (/' ERROR :  N IS LESS THAN ONE.')
 1200 FORMAT
     +   (/' ERROR :  M IS LESS THAN ONE.')
 1300 FORMAT
     +   (/' ERROR :  NP IS LESS THAN ONE'/
     +     '          OR NP IS GREATER THAN N.')
 2100 FORMAT
     +   (/' ERROR :  LDX IS LESS THAN N.')
 2210 FORMAT
     +   (/' ERROR :  LDIFX IS LESS THAN N'/
     +     '          AND LDIFX IS NOT EQUAL TO ONE.')
 2220 FORMAT
     +   (/' ERROR :  LDSCLD IS LESS THAN N'/
     +     '          AND LDSCLD IS NOT EQUAL TO ONE.')
 2230 FORMAT
     +   (/' ERROR :  LDRHO IS LESS THAN N'/
     +     '          AND LDRHO IS NOT EQUAL TO ONE.')
 2300 FORMAT
     +   (/' ERROR :  LWORK IS LESS THAN ',I5, ','/
     +     '          THE SMALLEST ACCEPTABLE DIMENSION OF ARRAY WORK.')
 2400 FORMAT
     +   (/' ERROR :  LIWORK IS LESS THAN ',I5, ','/
     +     '          THE SMALLEST ACCEPTABLE DIMENSION OF ARRAY',
     +              ' IWORK.')
 3110 FORMAT
     +   (/' ERROR :  SCLD(I,J) IS LESS THAN OR EQUAL TO ZERO'/
     +     '          FOR SOME I = 1, ..., N AND J = 1, ..., M.'//
     +     '          WHEN SCLD(1,1) IS GREATER THAN ZERO'/
     +     '          AND LDSCLD IS GREATER THAN OR EQUAL TO N THEN'/
     +     '          EACH OF THE N BY M ELEMENTS OF'/
     +     '          SCLD MUST BE GREATER THAN ZERO.')
 3120 FORMAT
     +   (/' ERROR :  SCLD(1,J) IS LESS THAN OR EQUAL TO ZERO'/
     +     '          FOR SOME J = 1, ..., M.'//
     +     '          WHEN SCLD(1,1) IS GREATER THAN ZERO'/
     +     '          AND LDSCLD IS EQUAL TO ONE THEN'/
     +     '          EACH OF THE 1 BY M ELEMENTS OF'/
     +     '          SCLD MUST BE GREATER THAN ZERO.')
 3130 FORMAT
     +   (/' ERROR :  SCLB(K) IS LESS THAN OR EQUAL TO ZERO'/
     +     '          FOR SOME K = 1, ..., NP.'//
     +     '          ALL NP ELEMENTS OF',
     +              ' SCLB MUST BE GREATER THAN ZERO.')
 3210 FORMAT
     +   (/' ERROR :  W(I) IS LESS THAN ZERO FOR SOME I = 1, ..., N.'//
     +     '          WHEN W(1) IS GREATER THAN OR EQUAL TO ZERO THEN'/
     +     '          ALL N ELEMENTS OF',
     +              ' W MUST BE GREATER THAN OR EQUAL TO ZERO.')
 3220 FORMAT
     +   (/' ERROR :  THE NUMBER OF NON ZERO VALUES IN ARRAY W) IS'/
     +     '          LESS THAN NP.')
 3310 FORMAT
     +   (/' ERROR :  RHO(I,J) IS LESS THAN OR EQUAL TO ZERO'/
     +     '          FOR SOME I = 1, ..., N AND J = 1, ..., M.'//
     +     '          WHEN RHO(1,1) IS GREATER THAN ZERO'/
     +     '          AND LDRHO IS GREATER THAN OR EQUAL TO N THEN'/
     +     '          EACH OF THE N BY M ELEMENTS OF'/
     +     '          RHO MUST BE GREATER THAN ZERO.')
 3320 FORMAT
     +   (/' ERROR :  RHO(1,J) IS LESS THAN OR EQUAL TO ZERO'/
     +     '          FOR SOME J = 1, ..., M.'//
     +     '          WHEN RHO(1,1) IS GREATER THAN ZERO'/
     +     '          AND LDRHO IS EQUAL TO ONE THEN'/
     +     '          EACH OF THE 1 BY M ELEMENTS OF'/
     +     '          RHO MUST BE GREATER THAN ZERO.')
      END
