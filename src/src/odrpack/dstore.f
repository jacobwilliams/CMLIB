*DSTORE
      SUBROUTINE DSTORE
     +   (N,M,NP,WORK,LWORK,IWORK,LIWORK,
     +   RNORM,TAU,ALPHA,NFEV,NJEV,INT2,OLMAVG,RCOND,IRANK)
C***BEGIN PROLOGUE  DSTORE
C***REFER TO  DODR,DODRC
C***ROUTINES CALLED  DIWINF,DWINF
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
C***PURPOSE  STORE COMPUTED SCALARS INTO WORK ARRAYS FOR RETURN TO USER
C***END PROLOGUE  DSTORE
C
C  VARIABLE DECLARATIONS (ALPHABETICALLY)
C
      DOUBLE PRECISION ALPHA
C        THE LEVENBERG-MARQUARDT PARAMETER.
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
      INTEGER INT2
C        THE NUMBER OF INTERNAL DOUBLING STEPS.
      INTEGER INT2I
C        THE LOCATION IN ARRAY IWORK OF
C        THE NUMBER OF INTERNAL DOUBLING STEPS.
      INTEGER IPRINI
C        THE LOCATION IN ARRAY IWORK OF
C        THE PRINT CONTROL VARIABLE.
      INTEGER IRANK
C        THE RANK DEFICIENCY OF THE JACOBIAN WRT BETA.
      INTEGER IRANKI
C        THE LOCATION IN ARRAY IWORK OF
C        THE RANK DEFICIENCY OF THE JACOBIAN WRT BETA.
      INTEGER IWORK(LIWORK)
C        THE INTEGER WORK SPACE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER JPVTI
C        THE STARTING LOCATION IN ARRAY IWORK OF
C        THE PIVOT VECTOR.
      INTEGER LIWORK
C        THE LENGTH OF VECTOR IWORK.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER LUNERI
C        THE LOCATION IN ARRAY IWORK OF
C        THE LOGICAL UNIT NUMBER USED FOR ERROR MESSAGES.
      INTEGER LUNRPI
C        THE LOCATION IN ARRAY IWORK OF
C        THE LOGICAL UNIT NUMBER USED FOR COMPUTATION REPORTS.
      INTEGER LWORK
C        THE LENGTH OF VECTOR WORK.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER M
C        THE NUMBER OF COLUMNS OF DATA IN THE INDEPENDENT VARIABLE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER MAXITI
C        THE LOCATION IN ARRAY IWORK OF
C        THE MAXIMUM NUMBER OF ITERATIONS ALLOWED.
      INTEGER MSGB
C        THE STARTING LOCATION IN ARRAY IWORK OF
C        THE ERROR CHECKING RESULTS FOR THE JACOBIAN WRT BETA.
      INTEGER MSGX
C        THE STARTING LOCATION IN ARRAY IWORK OF
C        THE ERROR CHECKING RESULTS FOR THE JACOBIAN WRT X.
      INTEGER N
C        THE NUMBER OF OBSERVATIONS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      INTEGER NFEV
C        THE NUMBER OF FUNCTION EVALUATIONS.
      INTEGER NFEVI
C        THE LOCATION IN ARRAY IWORK OF
C        THE NUMBER OF FUNCTION EVALUATIONS.
      INTEGER NJEV
C        THE NUMBER OF JACOBIAN EVALUATIONS.
      INTEGER NJEVI
C        THE LOCATION IN ARRAY IWORK OF
C        THE NUMBER OF JACOBIAN EVALUATIONS.
      INTEGER NP
C        THE NUMBER OF FUNCTION PARAMETERS.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
      DOUBLE PRECISION OLMAVG
C        THE AVERAGE NUMBER OF LEVENBERG-MARQUARDT STEPS PER ITERATION.
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
      DOUBLE PRECISION RCOND
C        THE APPROXIMATE RECIPROCAL CONDITION OF TFJACB.
      INTEGER RCONDI
C        THE LOCATION IN ARRAY WORK OF
C        THE APPROXIMATE RECIPROCAL CONDITION OF TFJACB.
      DOUBLE PRECISION RNORM
C        THE NORM OF THE WEIGHTED OBSERVATIONAL ERRORS.
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
      DOUBLE PRECISION TAU
C        THE TRUST REGION DIAMETER.
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
      DOUBLE PRECISION WORK(LWORK)
C        THE DOUBLE PRECISION WORK SPACE.
C        (FOR DETAILS, SEE ODRPACK REFERENCE GUIDE.)
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
C***FIRST EXECUTABLE STATEMENT  DSTORE
C
C
C  SET STARTING LOCATIONS WITHIN INTEGER WORKSPACE
C
      CALL DIWINF
     +   (M,NP,
     +   MSGB,MSGX,JPVTI,MAXITI,IPRINI,NFEVI,NJEVI,INT2I,IRANKI,
     +   LUNERI,LUNRPI)
C
C  SET STARTING LOCATIONS WITHIN DOUBLE PRECISION WORK SPACE
C
      CALL DWINF
     +   (N,M,NP,
     +   DELTAI,FI,RNORMI,PARTLI,SSTOLI,TAUFCI,EPSMAI,OLMAVI,
     +   FJACBI,FJACXI,XPLUSI,BETACI,BETASI,BETANI,
     +   DELTSI,DELTNI,DDELTI,FSI,FNI,SI,SSSI,SSI,SSFI,TI,TTI,
     +   TAUI,ALPHAI,TFJACI,OMEGAI,YTI,UI,QRAUXI,WRK1I,WRK2I,STPI,
     +   RCONDI)
C
      WORK(RCONDI) = RCOND
      WORK(RNORMI) = RNORM
      WORK(TAUI) = TAU
      WORK(ALPHAI) = ALPHA
      WORK(OLMAVI) = OLMAVG
C
      IWORK(NFEVI) = NFEV
      IWORK(NJEVI) = NJEV
      IWORK(INT2I) = INT2
      IWORK(IRANKI) = IRANK
C
      RETURN
      END