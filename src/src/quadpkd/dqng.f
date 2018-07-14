      SUBROUTINE DQNG(F,A,B,EPSABS,EPSREL,RESULT,ABSERR,NEVAL,IER)
C***BEGIN PROLOGUE  DQNG
C***DATE WRITTEN   800101   (YYMMDD)
C***REVISION DATE  810101   (YYMMDD)
C***REVISION HISTORY (YYMMDD)
C   000601   Changed DMAX1/DMIN1/DABS to generic MAX/MIN/ABS
C***CATEGORY NO.  H2A1A1
C***KEYWORDS  AUTOMATIC INTEGRATOR,GAUSS-KRONROD(PATTERSON),
C             NON-ADAPTIVE,SMOOTH INTEGRAND
C***AUTHOR  PIESSENS, ROBERT, APPLIED MATH. AND PROGR. DIV. -
C             K. U. LEUVEN
C           DE DONCKER, ELISE, APPLIED MATH. AND PROGR. DIV. -
C             K. U. LEUVEN
C           KAHANER, DAVID, NBS - MODIFIED (2/82)
C***PURPOSE  The routine calculates an approximation result to a
C            given definite integral I = integral of F over (A,B),
C            hopefully satisfying following claim for accuracy
C            ABS(I-RESULT).LE.MAX(EPSABS,EPSREL*ABS(I)).
C***DESCRIPTION
C
C NON-ADAPTIVE INTEGRATION
C STANDARD FORTRAN SUBROUTINE
C DOUBLE PRECISION VERSION
C
C           F      - Double precision
C                    Function subprogram defining the integrand function
C                    F(X). The actual name for F needs to be declared
C                    E X T E R N A L in the driver program.
C
C           A      - Double precision
C                    Lower limit of integration
C
C           B      - Double precision
C                    Upper limit of integration
C
C           EPSABS - Double precision
C                    Absolute accuracy requested
C           EPSREL - Double precision
C                    Relative accuracy requested
C                    If  EPSABS.LE.0
C                    And EPSREL.LT.MAX(50*REL.MACH.ACC.,0.5D-28),
C                    The routine will end with IER = 6.
C
C         ON RETURN
C           RESULT - Double precision
C                    Approximation to the integral I
C                    Result is obtained by applying the 21-POINT
C                    GAUSS-KRONROD RULE (RES21) obtained by optimal
C                    addition of abscissae to the 10-POINT GAUSS RULE
C                    (RES10), or by applying the 43-POINT RULE (RES43)
C                    obtained by optimal addition of abscissae to the
C                    21-POINT GAUSS-KRONROD RULE, or by applying the
C                    87-POINT RULE (RES87) obtained by optimal addition
C                    of abscissae to the 43-POINT RULE.
C
C           ABSERR - Double precision
C                    Estimate of the modulus of the absolute error,
C                    which should EQUAL or EXCEED ABS(I-RESULT)
C
C           NEVAL  - Integer
C                    Number of integrand evaluations
C
C           IER    - IER = 0 normal and reliable termination of the
C                            routine. It is assumed that the requested
C                            accuracy has been achieved.
C                    IER.GT.0 Abnormal termination of the routine. It is
C                            assumed that the requested accuracy has
C                            not been achieved.
C           ERROR MESSAGES
C                    IER = 1 The maximum number of steps has been
C                            executed. The integral is probably too
C                            difficult to be calculated by DQNG.
C                        = 6 The input is invalid, because
C                            EPSABS.LE.0 AND
C                            EPSREL.LT.MAX(50*REL.MACH.ACC.,0.5D-28).
C                            RESULT, ABSERR and NEVAL are set to zero.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  D1MACH,XERROR
C***END PROLOGUE  DQNG
C
      DOUBLE PRECISION A,ABSC,ABSERR,B,CENTR,DHLGTH,
     1  D1MACH,EPMACH,EPSABS,EPSREL,F,FCENTR,FVAL,FVAL1,FVAL2,FV1,FV2,
     2  FV3,FV4,HLGTH,RESULT,RES10,RES21,RES43,RES87,RESABS,RESASC,
     3  RESKH,SAVFUN,UFLOW,W10,W21A,W21B,W43A,W43B,W87A,W87B,X1,X2,X3,X4
      INTEGER IER,IPX,K,L,NEVAL
      EXTERNAL F
C
      DIMENSION FV1(5),FV2(5),FV3(5),FV4(5),X1(5),X2(5),X3(11),X4(22),
     1  W10(5),W21A(5),W21B(6),W43A(10),W43B(12),W87A(21),W87B(23),
     2  SAVFUN(21)
C
C           THE FOLLOWING DATA STATEMENTS CONTAIN THE
C           ABSCISSAE AND WEIGHTS OF THE INTEGRATION RULES USED.
C
C           X1      ABSCISSAE COMMON TO THE 10-, 21-, 43- AND 87-
C                   POINT RULE
C           X2      ABSCISSAE COMMON TO THE 21-, 43- AND 87-POINT RULE
C           X3      ABSCISSAE COMMON TO THE 43- AND 87-POINT RULE
C           X4      ABSCISSAE OF THE 87-POINT RULE
C           W10     WEIGHTS OF THE 10-POINT FORMULA
C           W21A    WEIGHTS OF THE 21-POINT FORMULA FOR ABSCISSAE X1
C           W21B    WEIGHTS OF THE 21-POINT FORMULA FOR ABSCISSAE X2
C           W43A    WEIGHTS OF THE 43-POINT FORMULA FOR ABSCISSAE X1, X3
C           W43B    WEIGHTS OF THE 43-POINT FORMULA FOR ABSCISSAE X3
C           W87A    WEIGHTS OF THE 87-POINT FORMULA FOR ABSCISSAE X1,
C                   X2, X3
C           W87B    WEIGHTS OF THE 87-POINT FORMULA FOR ABSCISSAE X4
C
C
C GAUSS-KRONROD-PATTERSON QUADRATURE COEFFICIENTS FOR USE IN
C QUADPACK ROUTINE QNG.  THESE COEFFICIENTS WERE CALCULATED WITH
C 101 DECIMAL DIGIT ARITHMETIC BY L. W. FULLERTON, BELL LABS, NOV 1981.
C
      DATA X1    (  1) / 0.9739065285 1717172007 7964012084 452 D0 /
      DATA X1    (  2) / 0.8650633666 8898451073 2096688423 493 D0 /
      DATA X1    (  3) / 0.6794095682 9902440623 4327365114 874 D0 /
      DATA X1    (  4) / 0.4333953941 2924719079 9265943165 784 D0 /
      DATA X1    (  5) / 0.1488743389 8163121088 4826001129 720 D0 /
      DATA W10   (  1) / 0.0666713443 0868813759 3568809893 332 D0 /
      DATA W10   (  2) / 0.1494513491 5058059314 5776339657 697 D0 /
      DATA W10   (  3) / 0.2190863625 1598204399 5534934228 163 D0 /
      DATA W10   (  4) / 0.2692667193 0999635509 1226921569 469 D0 /
      DATA W10   (  5) / 0.2955242247 1475287017 3892994651 338 D0 /
C
      DATA X2    (  1) / 0.9956571630 2580808073 5527280689 003 D0 /
      DATA X2    (  2) / 0.9301574913 5570822600 1207180059 508 D0 /
      DATA X2    (  3) / 0.7808177265 8641689706 3717578345 042 D0 /
      DATA X2    (  4) / 0.5627571346 6860468333 9000099272 694 D0 /
      DATA X2    (  5) / 0.2943928627 0146019813 1126603103 866 D0 /
      DATA W21A  (  1) / 0.0325581623 0796472747 8818972459 390 D0 /
      DATA W21A  (  2) / 0.0750396748 1091995276 7043140916 190 D0 /
      DATA W21A  (  3) / 0.1093871588 0229764189 9210590325 805 D0 /
      DATA W21A  (  4) / 0.1347092173 1147332592 8054001771 707 D0 /
      DATA W21A  (  5) / 0.1477391049 0133849137 4841515972 068 D0 /
      DATA W21B  (  1) / 0.0116946388 6737187427 8064396062 192 D0 /
      DATA W21B  (  2) / 0.0547558965 7435199603 1381300244 580 D0 /
      DATA W21B  (  3) / 0.0931254545 8369760553 5065465083 366 D0 /
      DATA W21B  (  4) / 0.1234919762 6206585107 7958109831 074 D0 /
      DATA W21B  (  5) / 0.1427759385 7706008079 7094273138 717 D0 /
      DATA W21B  (  6) / 0.1494455540 0291690566 4936468389 821 D0 /
C
      DATA X3    (  1) / 0.9993333609 0193208139 4099323919 911 D0 /
      DATA X3    (  2) / 0.9874334029 0808886979 5961478381 209 D0 /
      DATA X3    (  3) / 0.9548079348 1426629925 7919200290 473 D0 /
      DATA X3    (  4) / 0.9001486957 4832829362 5099494069 092 D0 /
      DATA X3    (  5) / 0.8251983149 8311415084 7066732588 520 D0 /
      DATA X3    (  6) / 0.7321483889 8930498261 2354848755 461 D0 /
      DATA X3    (  7) / 0.6228479705 3772523864 1159120344 323 D0 /
      DATA X3    (  8) / 0.4994795740 7105649995 2214885499 755 D0 /
      DATA X3    (  9) / 0.3649016613 4658076804 3989548502 644 D0 /
      DATA X3    ( 10) / 0.2222549197 7660129649 8260928066 212 D0 /
      DATA X3    ( 11) / 0.0746506174 6138332204 3914435796 506 D0 /
      DATA W43A  (  1) / 0.0162967342 8966656492 4281974617 663 D0 /
      DATA W43A  (  2) / 0.0375228761 2086950146 1613795898 115 D0 /
      DATA W43A  (  3) / 0.0546949020 5825544214 7212685465 005 D0 /
      DATA W43A  (  4) / 0.0673554146 0947808607 5553166302 174 D0 /
      DATA W43A  (  5) / 0.0738701996 3239395343 2140695251 367 D0 /
      DATA W43A  (  6) / 0.0057685560 5976979618 4184327908 655 D0 /
      DATA W43A  (  7) / 0.0273718905 9324884208 1276069289 151 D0 /
      DATA W43A  (  8) / 0.0465608269 1042883074 3339154433 824 D0 /
      DATA W43A  (  9) / 0.0617449952 0144256449 6240336030 883 D0 /
      DATA W43A  ( 10) / 0.0713872672 6869339776 8559114425 516 D0 /
      DATA W43B  (  1) / 0.0018444776 4021241410 0389106552 965 D0 /
      DATA W43B  (  2) / 0.0107986895 8589165174 0465406741 293 D0 /
      DATA W43B  (  3) / 0.0218953638 6779542810 2523123075 149 D0 /
      DATA W43B  (  4) / 0.0325974639 7534568944 3882222526 137 D0 /
      DATA W43B  (  5) / 0.0421631379 3519181184 7627924327 955 D0 /
      DATA W43B  (  6) / 0.0507419396 0018457778 0189020092 084 D0 /
      DATA W43B  (  7) / 0.0583793955 4261924837 5475369330 206 D0 /
      DATA W43B  (  8) / 0.0647464049 5144588554 4689259517 511 D0 /
      DATA W43B  (  9) / 0.0695661979 1235648452 8633315038 405 D0 /
      DATA W43B  ( 10) / 0.0728244414 7183320815 0939535192 842 D0 /
      DATA W43B  ( 11) / 0.0745077510 1417511827 3571813842 889 D0 /
      DATA W43B  ( 12) / 0.0747221475 1740300559 4425168280 423 D0 /
C
      DATA X4    (  1) / 0.9999029772 6272923449 0529830591 582 D0 /
      DATA X4    (  2) / 0.9979898959 8667874542 7496322365 960 D0 /
      DATA X4    (  3) / 0.9921754978 6068722280 8523352251 425 D0 /
      DATA X4    (  4) / 0.9813581635 7271277357 1916941623 894 D0 /
      DATA X4    (  5) / 0.9650576238 5838461912 8284110607 926 D0 /
      DATA X4    (  6) / 0.9431676131 3367059681 6416634507 426 D0 /
      DATA X4    (  7) / 0.9158064146 8550720959 1826430720 050 D0 /
      DATA X4    (  8) / 0.8832216577 7131650137 2117548744 163 D0 /
      DATA X4    (  9) / 0.8457107484 6241566660 5902011504 855 D0 /
      DATA X4    ( 10) / 0.8035576580 3523098278 8739474980 964 D0 /
      DATA X4    ( 11) / 0.7570057306 8549555832 8942793432 020 D0 /
      DATA X4    ( 12) / 0.7062732097 8732181982 4094274740 840 D0 /
      DATA X4    ( 13) / 0.6515894665 0117792253 4422205016 736 D0 /
      DATA X4    ( 14) / 0.5932233740 5796108887 5273770349 144 D0 /
      DATA X4    ( 15) / 0.5314936059 7083193228 5268948562 671 D0 /
      DATA X4    ( 16) / 0.4667636230 4202284487 1966781659 270 D0 /
      DATA X4    ( 17) / 0.3994248478 5921880473 2101665817 923 D0 /
      DATA X4    ( 18) / 0.3298748771 0618828826 5053371824 597 D0 /
      DATA X4    ( 19) / 0.2585035592 0216155180 2280975429 025 D0 /
      DATA X4    ( 20) / 0.1856953965 6834665201 5917141167 606 D0 /
      DATA X4    ( 21) / 0.1118422131 7990746817 2398359241 362 D0 /
      DATA X4    ( 22) / 0.0373521233 9461987081 4998165437 704 D0 /
      DATA W87A  (  1) / 0.0081483773 8414917290 0002878448 190 D0 /
      DATA W87A  (  2) / 0.0187614382 0156282224 3935059003 794 D0 /
      DATA W87A  (  3) / 0.0273474510 5005228616 1582829741 283 D0 /
      DATA W87A  (  4) / 0.0336777073 1163793004 6581056957 588 D0 /
      DATA W87A  (  5) / 0.0369350998 2042790761 4589586742 499 D0 /
      DATA W87A  (  6) / 0.0028848724 3021153050 1334156248 695 D0 /
      DATA W87A  (  7) / 0.0136859460 2271270188 8950035273 128 D0 /
      DATA W87A  (  8) / 0.0232804135 0288831112 3409291030 404 D0 /
      DATA W87A  (  9) / 0.0308724976 1171335867 5466394126 442 D0 /
      DATA W87A  ( 10) / 0.0356936336 3941877071 9351355457 044 D0 /
      DATA W87A  ( 11) / 0.0009152833 4520224136 0843392549 948 D0 /
      DATA W87A  ( 12) / 0.0053992802 1930047136 7738743391 053 D0 /
      DATA W87A  ( 13) / 0.0109476796 0111893113 4327826856 808 D0 /
      DATA W87A  ( 14) / 0.0162987316 9678733526 2665703223 280 D0 /
      DATA W87A  ( 15) / 0.0210815688 8920383511 2433060188 190 D0 /
      DATA W87A  ( 16) / 0.0253709697 6925382724 3467999831 710 D0 /
      DATA W87A  ( 17) / 0.0291896977 5647575250 1446154084 920 D0 /
      DATA W87A  ( 18) / 0.0323732024 6720278968 5788194889 595 D0 /
      DATA W87A  ( 19) / 0.0347830989 5036514275 0781997949 596 D0 /
      DATA W87A  ( 20) / 0.0364122207 3135178756 2801163687 577 D0 /
      DATA W87A  ( 21) / 0.0372538755 0304770853 9592001191 226 D0 /
      DATA W87B  (  1) / 0.0002741455 6376207235 0016527092 881 D0 /
      DATA W87B  (  2) / 0.0018071241 5505794294 8341311753 254 D0 /
      DATA W87B  (  3) / 0.0040968692 8275916486 4458070683 480 D0 /
      DATA W87B  (  4) / 0.0067582900 5184737869 9816577897 424 D0 /
      DATA W87B  (  5) / 0.0095499576 7220164653 6053581325 377 D0 /
      DATA W87B  (  6) / 0.0123294476 5224485369 4626639963 780 D0 /
      DATA W87B  (  7) / 0.0150104473 4638895237 6697286041 943 D0 /
      DATA W87B  (  8) / 0.0175489679 8624319109 9665352925 900 D0 /
      DATA W87B  (  9) / 0.0199380377 8644088820 2278192730 714 D0 /
      DATA W87B  ( 10) / 0.0221949359 6101228679 6332102959 499 D0 /
      DATA W87B  ( 11) / 0.0243391471 2600080547 0360647041 454 D0 /
      DATA W87B  ( 12) / 0.0263745054 1483920724 1503786552 615 D0 /
      DATA W87B  ( 13) / 0.0282869107 8877120065 9968002987 960 D0 /
      DATA W87B  ( 14) / 0.0300525811 2809269532 2521110347 341 D0 /
      DATA W87B  ( 15) / 0.0316467513 7143992940 4586051078 883 D0 /
      DATA W87B  ( 16) / 0.0330504134 1997850329 0785944862 689 D0 /
      DATA W87B  ( 17) / 0.0342550997 0422606178 7082821046 821 D0 /
      DATA W87B  ( 18) / 0.0352624126 6015668103 3782717998 428 D0 /
      DATA W87B  ( 19) / 0.0360769896 2288870118 5500318003 895 D0 /
      DATA W87B  ( 20) / 0.0366986044 9845609449 8018047441 094 D0 /
      DATA W87B  ( 21) / 0.0371205492 6983257611 4119958413 599 D0 /
      DATA W87B  ( 22) / 0.0373342287 5193504032 1235449094 698 D0 /
      DATA W87B  ( 23) / 0.0373610737 6267902341 0321241766 599 D0 /
C
C           LIST OF MAJOR VARIABLES
C           -----------------------
C
C           CENTR  - MID POINT OF THE INTEGRATION INTERVAL
C           HLGTH  - HALF-LENGTH OF THE INTEGRATION INTERVAL
C           FCENTR - FUNCTION VALUE AT MID POINT
C           ABSC   - ABSCISSA
C           FVAL   - FUNCTION VALUE
C           SAVFUN - ARRAY OF FUNCTION VALUES WHICH HAVE ALREADY BEEN
C                    COMPUTED
C           RES10  - 10-POINT GAUSS RESULT
C           RES21  - 21-POINT KRONROD RESULT
C           RES43  - 43-POINT RESULT
C           RES87  - 87-POINT RESULT
C           RESABS - APPROXIMATION TO THE INTEGRAL OF ABS(F)
C           RESASC - APPROXIMATION TO THE INTEGRAL OF ABS(F-I/(B-A))
C
C           MACHINE DEPENDENT CONSTANTS
C           ---------------------------
C
C           EPMACH IS THE LARGEST RELATIVE SPACING.
C           UFLOW IS THE SMALLEST POSITIVE MAGNITUDE.
C
C***FIRST EXECUTABLE STATEMENT  DQNG
      EPMACH = D1MACH(4)
      UFLOW = D1MACH(1)
C
C           TEST ON VALIDITY OF PARAMETERS
C           ------------------------------
C
      RESULT = 0.0D+00
      ABSERR = 0.0D+00
      NEVAL = 0
      IER = 6
      IF(EPSABS.LE.0.0D+00.AND.EPSREL.LT.MAX(0.5D+02*EPMACH,0.5D-28))
     1  GO TO 80
      HLGTH = 0.5D+00*(B-A)
      DHLGTH = ABS(HLGTH)
      CENTR = 0.5D+00*(B+A)
      FCENTR = F(CENTR)
      NEVAL = 21
      IER = 1
C
C          COMPUTE THE INTEGRAL USING THE 10- AND 21-POINT FORMULA.
C
      DO 70 L = 1,3
      GO TO (5,25,45),L
    5 RES10 = 0.0D+00
      RES21 = W21B(6)*FCENTR
      RESABS = W21B(6)*ABS(FCENTR)
      DO 10 K=1,5
        ABSC = HLGTH*X1(K)
        FVAL1 = F(CENTR+ABSC)
        FVAL2 = F(CENTR-ABSC)
        FVAL = FVAL1+FVAL2
        RES10 = RES10+W10(K)*FVAL
        RES21 = RES21+W21A(K)*FVAL
        RESABS = RESABS+W21A(K)*(ABS(FVAL1)+ABS(FVAL2))
        SAVFUN(K) = FVAL
        FV1(K) = FVAL1
        FV2(K) = FVAL2
   10 CONTINUE
      IPX = 5
      DO 15 K=1,5
        IPX = IPX+1
        ABSC = HLGTH*X2(K)
        FVAL1 = F(CENTR+ABSC)
        FVAL2 = F(CENTR-ABSC)
        FVAL = FVAL1+FVAL2
        RES21 = RES21+W21B(K)*FVAL
        RESABS = RESABS+W21B(K)*(ABS(FVAL1)+ABS(FVAL2))
        SAVFUN(IPX) = FVAL
        FV3(K) = FVAL1
        FV4(K) = FVAL2
   15 CONTINUE
C
C          TEST FOR CONVERGENCE.
C
      RESULT = RES21*HLGTH
      RESABS = RESABS*DHLGTH
      RESKH = 0.5D+00*RES21
      RESASC = W21B(6)*ABS(FCENTR-RESKH)
      DO 20 K = 1,5
        RESASC = RESASC+W21A(K)*(ABS(FV1(K)-RESKH)+ABS(FV2(K)-RESKH))
     1                  +W21B(K)*(ABS(FV3(K)-RESKH)+ABS(FV4(K)-RESKH))
   20 CONTINUE
      ABSERR = ABS((RES21-RES10)*HLGTH)
      RESASC = RESASC*DHLGTH
      GO TO 65
C
C          COMPUTE THE INTEGRAL USING THE 43-POINT FORMULA.
C
   25 RES43 = W43B(12)*FCENTR
      NEVAL = 43
      DO 30 K=1,10
        RES43 = RES43+SAVFUN(K)*W43A(K)
   30 CONTINUE
      DO 40 K=1,11
        IPX = IPX+1
        ABSC = HLGTH*X3(K)
        FVAL = F(ABSC+CENTR)+F(CENTR-ABSC)
        RES43 = RES43+FVAL*W43B(K)
        SAVFUN(IPX) = FVAL
   40 CONTINUE
C
C          TEST FOR CONVERGENCE.
C
      RESULT = RES43*HLGTH
      ABSERR = ABS((RES43-RES21)*HLGTH)
      GO TO 65
C
C          COMPUTE THE INTEGRAL USING THE 87-POINT FORMULA.
C
   45 RES87 = W87B(23)*FCENTR
      NEVAL = 87
      DO 50 K=1,21
        RES87 = RES87+SAVFUN(K)*W87A(K)
   50 CONTINUE
      DO 60 K=1,22
        ABSC = HLGTH*X4(K)
        RES87 = RES87+W87B(K)*(F(ABSC+CENTR)+F(CENTR-ABSC))
   60 CONTINUE
      RESULT = RES87*HLGTH
      ABSERR = ABS((RES87-RES43)*HLGTH)
   65 IF(RESASC.NE.0.0D+00.AND.ABSERR.NE.0.0D+00)
     1  ABSERR = RESASC*MIN(0.1D+01,(0.2D+03*ABSERR/RESASC)**1.5D+00)
      IF (RESABS.GT.UFLOW/(0.5D+02*EPMACH)) ABSERR = MAX
     1  ((EPMACH*0.5D+02)*RESABS,ABSERR)
      IF (ABSERR.LE.MAX(EPSABS,EPSREL*ABS(RESULT))) IER = 0
C ***JUMP OUT OF DO-LOOP
      IF (IER.EQ.0) GO TO 999
   70 CONTINUE
   80 CALL XERROR( 'ABNORMAL RETURN FROM DQNG ',26,IER,0)
  999 RETURN
      END
