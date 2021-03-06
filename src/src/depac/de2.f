      SUBROUTINE DE2(F,NEQ,T,Y,TOUT,INFO,RTOL,ATOL,IDID,YPOUT,YP,YY,WT,
     1   P,PHI,ALPHA,BETA,PSI,V,W,SIG,G,H,EPS,X,HOLD,TOLD,DELSGN,TSTOP,
     2   TWOU,FOURU,START,PHASE1,NORND,STIFF,INTOUT,NS,KORD,KOLD,INIT,
     3   KSTEPS,KLE4,IQUIT,RPAR,IPAR)
C***BEGIN PROLOGUE  DE2
C***REFER TO  DEABM
C
C   DEABM  merely allocates storage for  DE2  to relieve the user of the
C   inconvenience of a long call list.  Consequently  DE2  is used as
C   described in the comments for  DEABM .
C***ROUTINES CALLED  INTRP,R1MACH,STEP2,XERRWV
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***END PROLOGUE  DE2
C
      LOGICAL STIFF,CRASH,START,PHASE1,NORND,INTOUT
C
      DIMENSION Y(NEQ),YY(NEQ),WT(NEQ),PHI(NEQ,16),P(NEQ),YP(NEQ),
     1  YPOUT(NEQ),PSI(12),ALPHA(12),BETA(12),SIG(13),V(12),W(12),G(13),
     2  INFO(15),RTOL(*),ATOL(*),RPAR(*),IPAR(*)
C
      EXTERNAL F
C
C.......................................................................
C
C  THE EXPENSE OF SOLVING THE PROBLEM IS MONITORED BY COUNTING THE
C  NUMBER OF  STEPS ATTEMPTED. WHEN THIS EXCEEDS  MAXNUM, THE COUNTER
C  IS RESET TO ZERO AND THE USER IS INFORMED ABOUT POSSIBLE EXCESSIVE
C  WORK.
C
      DATA MAXNUM/500/
C
C.......................................................................
C
C***FIRST EXECUTABLE STATEMENT  DE2
      IF (INFO(1) .NE. 0) GO TO 10
C
C ON THE FIRST CALL , PERFORM INITIALIZATION --
C        DEFINE THE MACHINE UNIT ROUNDOFF QUANTITY  U  BY CALLING THE
C        FUNCTION ROUTINE  R1MACH. THE USER MUST MAKE SURE THAT THE
C        VALUES SET IN R1MACH ARE RELEVANT TO THE COMPUTER BEING USED.
C
      U=R1MACH(4)
C                       -- SET ASSOCIATED MACHINE DEPENDENT PARAMETERS
      TWOU=2.*U
      FOURU=4.*U
C                       -- SET TERMINATION FLAG
      IQUIT=0
C                       -- SET INITIALIZATION INDICATOR
      INIT=0
C                       -- SET COUNTER FOR ATTEMPTED STEPS
      KSTEPS=0
C                       -- SET INDICATOR FOR INTERMEDIATE-OUTPUT
      INTOUT= .FALSE.
C                       -- SET INDICATOR FOR STIFFNESS DETECTION
      STIFF= .FALSE.
C                       -- SET STEP COUNTER FOR STIFFNESS DETECTION
      KLE4=0
C                       -- SET INDICATORS FOR STEP2 CODE
      START= .TRUE.
      PHASE1= .TRUE.
      NORND= .TRUE.
C                       -- RESET INFO(1) FOR SUBSEQUENT CALLS
      INFO(1)=1
C
C.......................................................................
C
C      CHECK VALIDITY OF INPUT PARAMATERS ON EACH ENTRY
C
   10 IF (INFO(1) .EQ. 0  .OR.  INFO(1) .EQ. 1) GO TO 20
      CALL XERRWV( 'DEABM -- INFO(1) MUST BE SET TO 0 FOR THE START OF A
     1 NEW PROBLEM, AND          MUST BE SET TO 1 FOLLOWING AN INTERRUPT
     2ED TASK.  YOU ARE              ATTEMPTING TO CONTINUE THE INTEGRAT
     3ION ILLEGALLY BY CALLING           THE CODE WITH  INFO(1) = (I1).'
     4,249,3,1,1,INFO(1),0,0,0.,0.)
      IDID=-33
C
   20 IF (INFO(2) .EQ. 0  .OR.  INFO(2) .EQ. 1) GO TO 30
      CALL XERRWV( 'DEABM -- INFO(2) MUST BE 0 OR 1 INDICATING SCALAR AN
     1D VECTOR ERROR            TOLERANCES, RESPECTIVELY.  YOU HAVE CALL
     2ED THE CODE WITH               INFO(2) = (I1).',                16
     34,4,1,1,INFO(2),0,0,0.,0.)
      IDID=-33
C
   30 IF (INFO(3) .EQ. 0  .OR.  INFO(3) .EQ. 1) GO TO 35
      CALL XERRWV( 'DEABM -- INFO(3) MUST BE 0 OR 1 INDICATING THE INTER
     1VAL OR                     INTERMEDIATE-OUTPUT MODE OF INTEGRATION
     2, RESPECTIVELY.                YOU HAVE CALLED THE CODE WITH  INFO
     3(3) = (I1).',195,5,1,1,INFO(3),0,0,0.,0.)
      IDID=-33
C
   35 IF (INFO(4) .EQ. 0  .OR.  INFO(4) .EQ. 1) GO TO 40
      CALL XERRWV( 'DEABM -- INFO(4) MUST BE 0 OR 1 INDICATING WHETHER O
     1R NOT THE                  INTEGRATION INTERVAL IS TO BE RESTRICTE
     2D BY A POINT TSTOP.            YOU HAVE CALLED THE CODE WITH  INFO
     3(4) = (I1).',195,14,1,1,INFO(4),0,0,0.,0.)
      IDID=-33
C
   40 IF (NEQ .GE. 1) GO TO 50
      CALL XERRWV( 'DEABM -- THE NUMBER OF EQUATIONS NEQ MUST BE A POSIT
     1IVE INTEGER.  YOU          HAVE CALLED THE CODE WITH  NEQ = (I1).'
     2,117,6,1,1,NEQ,0,0,0.,0.)
      IDID=-33
C
   50 NRTOLP=0
      NATOLP=0
      DO 90 K=1,NEQ
        IF (NRTOLP .GT. 0) GO TO 70
        IF (RTOL(K) .GE. 0.) GO TO 60
      CALL XERRWV(   'DEABM -- THE RELATIVE ERROR TOLERANCES RTOL MUST B
     1E NON-NEGATIVE.  YOU         HAVE CALLED THE CODE WITH  RTOL(I1) =
     2 (R1).  IN THE CASE OF           VECTOR ERROR TOLERANCES, NO FURTH
     3ER CHECKING OF RTOL                  COMPONENTS IS DONE.',
     4 238,7,1,1,K,0,1,RTOL(K),0.)
        IDID=-33
        IF (NATOLP .GT. 0) GO TO 100
        NRTOLP=1
        GO TO 70
   60   IF (NATOLP .GT. 0) GO TO 80
   70   IF (ATOL(K) .GE. 0.) GO TO 80
      CALL XERRWV(   'DEABM -- THE ABSOLUTE ERROR TOLERANCES ATOL MUST B
     1E NON-NEGATIVE.  YOU         HAVE CALLED THE CODE WITH  ATOL(I1) =
     2 (R1).  IN THE CASE OF           VECTOR ERROR TOLERANCES, NO FURTH
     3ER CHECKING OF ATOL                  COMPONENTS IS DONE.',
     4 238,8,1,1,K,0,1,ATOL(K),0.)
        IDID=-33
        IF (NRTOLP .GT. 0) GO TO 100
        NATOLP=1
   80   IF (INFO(2) .EQ. 0) GO TO 100
   90   CONTINUE
C
  100 IF (INFO(4) .NE. 1) GO TO 110
      IF (SIGN(1.,TOUT-T) .EQ. SIGN(1.,TSTOP-T)
     1  .AND. ABS(TOUT-T) .LE. ABS(TSTOP-T)) GO TO 110
      CALL XERRWV(   'DEABM -- YOU HAVE CALLED THE CODE WITH  TOUT = (R1
     1)  BUT YOU HAVE ALSO         TOLD THE CODE (INFO(4) = 1) NOT TO IN
     2TEGRATE PAST THE POINT            TSTOP = (R2). THESE INSTRUCTIONS
     3 CONFLICT.',192,14,1,0,0,0,2,TOUT,TSTOP)
      IDID=-33
C
  110 IF (INIT .EQ. 0) GO TO 140
C                       CHECK SOME CONTINUATION POSSIBILITIES
      IF (T .NE. TOUT) GO TO 120
      CALL XERRWV(  'DEABM -- YOU HAVE CALLED THE CODE WITH  T = TOUT AT
     1  T = (R1).  THIS           IS NOT ALLOWED ON CONTINUATION CALLS.'
     2,116,9,1,0,0,0,1,T,0.)
      IDID=-33
C
  120 IF (T .EQ. TOLD) GO TO 130
      CALL XERRWV( 'DEABM -- YOU HAVE CHANGED THE VALUE OF T FROM (R1) T
     1O (R2).  THIS IS           NOT ALLOWED ON CONTINUATION CALLS.',  1
     213,10,1,0,0,0,2,TOLD,T)
      IDID=-33
C
  130 IF (INIT .EQ. 1) GO TO 140
      IF (DELSGN*(TOUT-T) .GE. 0.) GO TO 140
      CALL XERRWV( 'DEABM -- BY CALLING THE CODE WITH  TOUT = (R1) , YOU
     1 ARE ATTEMPTING TO          CHANGE THE DIRECTION OF INTEGRATION. T
     2HIS IS NOT ALLOWED             WITHOUT RESTARTING.',             1
     368,11,1,0,0,0,1,TOUT,0.)
      IDID=-33
C
  140 IF (IDID .NE. (-33)) GO TO 160
      IF (IQUIT .EQ. (-33)) GO TO 150
C
C                       INVALID INPUT DETECTED
      IQUIT=-33
      INFO(1)=-1
      RETURN
C
  150 CALL XERRWV(  'DEABM -- INVALID INPUT WAS DETECTED ON SUCCESSIVE E
     1NTRIES.  IT IS              IMPOSSIBLE TO PROCEED BECAUSE YOU HAVE
     2 NOT CORRECTED THE              PROBLEM, SO EXECUTION IS BEING TER
     3MINATED.',191,12,2,0,0,0,0,0.,0.)
      RETURN
C
C.......................................................................
C
C     RTOL = ATOL = 0. IS ALLOWED AS VALID INPUT AND INTERPRETED AS
C     ASKING FOR THE MOST ACCURATE SOLUTION POSSIBLE. IN THIS CASE,
C     THE RELATIVE ERROR TOLERANCE RTOL IS RESET TO THE SMALLEST VALUE
C     FOURU WHICH IS LIKELY TO BE REASONABLE FOR THIS METHOD AND MACHINE
C
  160 DO 180 K=1,NEQ
        IF (RTOL(K)+ATOL(K) .GT. 0.) GO TO 170
        RTOL(K)=FOURU
        IDID=-2
  170   IF (INFO(2) .EQ. 0) GO TO 190
  180   CONTINUE
C
  190 IF (IDID .NE. (-2)) GO TO 200
C                       RTOL=ATOL=0 ON INPUT, SO RTOL IS CHANGED TO A
C                                                SMALL POSITIVE VALUE
      INFO(1)=-1
      RETURN
C
C     BRANCH ON STATUS OF INITIALIZATION INDICATOR
C            INIT=0 MEANS INITIAL DERIVATIVES AND NOMINAL STEP SIZE
C                   AND DIRECTION NOT YET SET
C            INIT=1 MEANS NOMINAL STEP SIZE AND DIRECTION NOT YET SET
C            INIT=2 MEANS NO FUTHER INITIALIZATION REQUIRED
C
  200 IF (INIT .EQ. 0) GO TO 210
      IF (INIT .EQ. 1) GO TO 220
      GO TO 240
C
C.......................................................................
C
C     MORE INITIALIZATION --
C                         -- EVALUATE INITIAL DERIVATIVES
C
  210 INIT=1
      A=T
      CALL F(A,Y,YP,RPAR,IPAR)
      IF (T .NE. TOUT) GO TO 220
      IDID=2
      DO 215 L = 1,NEQ
  215    YPOUT(L) = YP(L)
      TOLD=T
      RETURN
C
C                         -- SET INDEPENDENT AND DEPENDENT VARIABLES
C                                              X AND YY(*) FOR STEP2
C                         -- SET SIGN OF INTEGRATION DIRECTION
C                         -- INITIALIZE THE STEP SIZE
C
  220 INIT = 2
      X = T
      DO 230 L = 1,NEQ
  230   YY(L) = Y(L)
      DELSGN = SIGN(1.0,TOUT-T)
      H = SIGN(AMAX1(FOURU*ABS(X),ABS(TOUT-X)),TOUT-X)
C
C.......................................................................
C
C   ON EACH CALL SET INFORMATION WHICH DETERMINES THE ALLOWED INTERVAL
C   OF INTEGRATION BEFORE RETURNING WITH AN ANSWER AT TOUT
C
  240 DEL = TOUT - T
      ABSDEL = ABS(DEL)
C
C.......................................................................
C
C   IF ALREADY PAST OUTPUT POINT, INTERPOLATE AND RETURN
C
  250 IF(ABS(X-T) .LT. ABSDEL) GO TO 260
      CALL INTRP(X,YY,TOUT,Y,YPOUT,NEQ,KOLD,PHI,PSI)
      IDID = 3
      IF (X .NE. TOUT) GO TO 255
      IDID = 2
      INTOUT = .FALSE.
  255 T = TOUT
      TOLD = T
      RETURN
C
C   IF CANNOT GO PAST TSTOP AND SUFFICIENTLY CLOSE,
C   EXTRAPOLATE AND RETURN
C
  260 IF (INFO(4) .NE. 1) GO TO 280
      IF (ABS(TSTOP-X) .GE. FOURU*ABS(X)) GO TO 280
      DT = TOUT - X
      DO 270 L = 1,NEQ
  270   Y(L) = YY(L) + DT*YP(L)
      CALL F(TOUT,Y,YPOUT,RPAR,IPAR)
      IDID = 3
      T = TOUT
      TOLD = T
      RETURN
C
  280 IF (INFO(3) .EQ. 0  .OR.  .NOT.INTOUT) GO TO 300
C
C   INTERMEDIATE-OUTPUT MODE
C
      IDID = 1
      DO 290 L = 1,NEQ
        Y(L)=YY(L)
  290   YPOUT(L) = YP(L)
      T = X
      TOLD = T
      INTOUT = .FALSE.
      RETURN
C
C.......................................................................
C
C     MONITOR NUMBER OF STEPS ATTEMPTED
C
  300 IF (KSTEPS .LE. MAXNUM) GO TO 330
C
C                       A SIGNIFICANT AMOUNT OF WORK HAS BEEN EXPENDED
      IDID=-1
      KSTEPS=0
      IF (.NOT. STIFF) GO TO 310
C
C                       PROBLEM APPEARS TO BE STIFF
      IDID=-4
      STIFF= .FALSE.
      KLE4=0
C
  310 DO 320 L = 1,NEQ
        Y(L) = YY(L)
  320   YPOUT(L) = YP(L)
      T = X
      TOLD = T
      INFO(1) = -1
      INTOUT = .FALSE.
      RETURN
C
C.......................................................................
C
C   LIMIT STEP SIZE, SET WEIGHT VECTOR AND TAKE A STEP
C
  330 HA = ABS(H)
      IF (INFO(4) .NE. 1) GO TO 340
      HA = AMIN1(HA,ABS(TSTOP-X))
  340 H = SIGN(HA,H)
      EPS = 1.0
      LTOL = 1
      DO 350 L = 1,NEQ
        IF (INFO(2) .EQ. 1) LTOL = L
        WT(L) = RTOL(LTOL)*ABS(YY(L)) + ATOL(LTOL)
        IF (WT(L) .LE. 0.0) GO TO 360
  350   CONTINUE
      GO TO 380
C
C                       RELATIVE ERROR CRITERION INAPPROPRIATE
  360 IDID = -3
      DO 370 L = 1,NEQ
        Y(L) = YY(L)
  370   YPOUT(L) = YP(L)
      T = X
      TOLD = T
      INFO(1) = -1
      INTOUT = .FALSE.
      RETURN
C
  380 CALL STEP2(F,NEQ,YY,X,H,EPS,WT,START,HOLD,KORD,KOLD,CRASH,PHI,P,
     1           YP,PSI,ALPHA,BETA,SIG,V,W,G,PHASE1,NS,NORND,KSTEPS,
     2           TWOU,FOURU,RPAR,IPAR)
C
C.......................................................................
C
      IF(.NOT.CRASH) GO TO 420
C
C                       TOLERANCES TOO SMALL
      IDID = -2
      RTOL(1) = EPS*RTOL(1)
      ATOL(1) = EPS*ATOL(1)
      IF (INFO(2) .EQ. 0) GO TO 400
      DO 390 L = 2,NEQ
        RTOL(L) = EPS*RTOL(L)
  390   ATOL(L) = EPS*ATOL(L)
  400 DO 410 L = 1,NEQ
        Y(L) = YY(L)
  410   YPOUT(L) = YP(L)
      T = X
      TOLD = T
      INFO(1) = -1
      INTOUT = .FALSE.
      RETURN
C
C   (STIFFNESS TEST) COUNT NUMBER OF CONSECUTIVE STEPS TAKEN WITH THE
C   ORDER OF THE METHOD BEING LESS OR EQUAL TO FOUR
C
  420 KLE4 = KLE4 + 1
      IF(KOLD .GT. 4) KLE4 = 0
      IF(KLE4 .GE. 50) STIFF = .TRUE.
      INTOUT = .TRUE.
      GO TO 250
      END
