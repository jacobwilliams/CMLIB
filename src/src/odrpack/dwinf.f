*DWINF
      SUBROUTINE DWINF
     +   (N,M,NP,
     +   DELTAI,FI,RNORMI,PARTLI,SSTOLI,TAUFCI,EPSMAI,OLMAVI,
     +   FJACBI,FJACXI,XPLUSI,BETACI,BETASI,BETANI,
     +   DELTSI,DELTNI,DDELTI,FSI,FNI,SI,SSSI,SSI,SSFI,TI,TTI,
     +   TAUI,ALPHAI,TFJACI,OMEGAI,YTI,UI,QRAUXI,WRK1I,WRK2I,STPI,
     +   RCONDI)
C***BEGIN PROLOGUE  DWINF
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
C***PURPOSE  SET STORAGE LOCATIONS WITHIN DOUBLE PRECISION WORK SPACE
C***END PROLOGUE  DWINF
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      INTEGER ALPHAI
C        THE LOCATION IN ARRAY WORK OF
C        THE LEVENBERG-MARQUARDT PARAMETER.
      INTEGER BETACI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE CURRENT ESTIMATED VALUES OF THE UNFIXED BETA'S.
      INTEGER BETANI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE NEW ESTIMATED VALUES OF THE UNFIXED BETA'S.
      INTEGER BETASI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SAVED ESTIMATED VALUES OF THE UNFIXED BETA'S.
      INTEGER DDELTI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY (W*D)**2 * DELTA.
      INTEGER DELTAI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      INTEGER DELTNI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE NEW ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      INTEGER DELTSI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SAVED ESTIMATED ERRORS IN THE INDEPENDENT VARIABLES.
      INTEGER EPSMAI
C        THE LOCATION IN ARRAY WORK OF
C        THE VALUE OF MACHINE PRECISION.
      INTEGER FI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      INTEGER FJACBI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE JACOBIAN WITH RESPECT TO BETA.
      INTEGER FJACXI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE JACOBIAN WITH RESPECT TO X.
      INTEGER FNI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE NEW (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      INTEGER FSI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SAVED (WEIGHTED) ESTIMATED VALUES OF EPSILON.
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NEXT
C        THE NEXT AVAILABLE LOCATION.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER OLMAVI
C        THE LOCATION IN ARRAY WORK OF
C        THE AVERAGE NUMBER OF LEVENBERG-MARQUARDT STEPS PER ITERATION.
      INTEGER OMEGAI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY (I-FJACX*INV(P)*TRANS(FJACX))**(-1/2)  WHERE
C        P = TRANS(FJACX)*FJACX + D**2 + ALPHA*TT**2
      INTEGER PARTLI
C        THE LOCATION IN ARRAY WORK OF
C        THE PARAMETER CONVERGENCE STOPPING CRITERIA.
      INTEGER QRAUXI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY REQUIRED TO RECOVER THE ORTHOGONAL PART OF THE
C        Q-R DECOMPOSITION.
      INTEGER RCONDI
C        THE LOCATION IN ARRAY WORK OF
C        THE APPROXIMATE RECIPROCAL CONDITION OF TFJACB.
      INTEGER RNORMI
C        THE LOCATION IN ARRAY WORK OF
C        THE NORM OF THE WEIGHTED OBSERVATIONAL ERRORS.
      INTEGER SI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE STEP FOR THE ESTIMATED BETA'S.
      INTEGER SSFI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SCALE USED FOR THE BETA'S.
      INTEGER SSI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SCALE USED FOR THE ESTIMATED BETA'S.
      INTEGER SSSI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY USED TO COMPUTED VARIOUS SUMS-OF-SQUARES.
      INTEGER SSTOLI
C        THE LOCATION IN ARRAY WORK OF
C        THE SUM-OF-SQUARES CONVERGENCE STOPPING CRITERIA.
      INTEGER STPI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE STEP USED TO COMPUTE FINITE DIFFERENCE DERIVATIVES.
      INTEGER TAUFCI
C        THE LOCATION IN ARRAY WORK OF
C        THE FACTOR USED TO COMPUTE THE INITIAL TRUST REGION DIAMETER.
      INTEGER TAUI
C        THE LOCATION IN ARRAY WORK OF
C        THE TRUST REGION DIAMETER.
      INTEGER TFJACI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY INV(DIAG(SQRT(OMEGA(I)),I=1,...,N))*FJACB.
      INTEGER TI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE STEP FOR THE ESTIMATED DELTA'S.
      INTEGER TTI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE SCALE USED FOR THE DELTA'S.
      INTEGER UI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE APPROXIMATE NULL VECTOR FOR TFJACB.
      INTEGER WRK1I
C        THE STARTING LOCATION IN ARRAY WORK OF
C        A WORK ARRAY.
      INTEGER WRK2I
C        THE STARTING LOCATION IN ARRAY WORK OF
C        A WORK ARRAY.
      INTEGER XPLUSI
C        THE STARTING LOCATION IN ARRAY WORK OF
C        THE ARRAY X + DELTA.
      INTEGER YTI
C         THE STARTING LOCATION IN WORK OF
C         THE ARRAY -(DIAG(SQRT(OMEGA(I)),I=1,...,N)*(G1-V*INV(E)*D*G2).
C
C
C***FIRST EXECUTABLE STATEMENT  DWINF
C
C
      IF (N.GE.1 .AND. NP.GE.1 .AND. M.GE.1) THEN
         DELTAI = 1
         FI = DELTAI + N*M
         RNORMI = FI + N
         PARTLI = RNORMI + 1
         SSTOLI = PARTLI + 1
         TAUFCI = SSTOLI + 1
         EPSMAI = TAUFCI + 1
         OLMAVI = EPSMAI + 1
         FJACBI = OLMAVI + 1
         FJACXI = FJACBI + N*NP
         XPLUSI = FJACXI + N*M
         BETACI = XPLUSI + N*M
         BETASI = BETACI + NP
         BETANI = BETASI + NP
         DELTSI = BETANI + NP
         DELTNI = DELTSI + N*M
         DDELTI = DELTNI + N*M
         FSI = DDELTI + N*M
         FNI = FSI + N
         SI = FNI + N
         SSSI = SI + NP
         SSI = SSSI + N + N*M
         SSFI = SSI + NP
         TI = SSFI + NP
         TTI = TI + N*M
         TAUI = TTI + N*M
         ALPHAI = TAUI + 1
         TFJACI = ALPHAI + 1
         OMEGAI = TFJACI + N*NP
         YTI = OMEGAI + N
         UI = YTI + N
         QRAUXI = UI + N
         WRK1I = QRAUXI + NP
         WRK2I = WRK1I + N*M
         STPI = WRK2I + NP
         RCONDI = STPI + N
         NEXT = RCONDI + 1
      ELSE
         DELTAI = 1
         FI = 1
         RNORMI = 1
         PARTLI = 1
         SSTOLI = 1
         TAUFCI = 1
         EPSMAI = 1
         OLMAVI = 1
         FJACBI = 1
         FJACXI = 1
         XPLUSI = 1
         BETACI = 1
         BETASI = 1
         BETANI = 1
         DELTSI = 1
         DELTNI = 1
         DDELTI = 1
         FSI = 1
         FNI = 1
         SI = 1
         SSSI = 1
         SSI = 1
         SSFI = 1
         TI = 1
         TTI = 1
         TAUI = 1
         ALPHAI = 1
         TFJACI = 1
         OMEGAI = 1
         YTI = 1
         UI = 1
         QRAUXI = 1
         WRK1I = 1
         WRK2I = 1
         STPI = 1
         RCONDI = 1
         NEXT = 1
      END IF
      RETURN
      END
