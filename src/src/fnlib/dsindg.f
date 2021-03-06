      DOUBLE PRECISION FUNCTION DSINDG(X)
C***BEGIN PROLOGUE  DSINDG
C***DATE WRITTEN   770601   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  C4A
C***KEYWORDS  DEGREE,DOUBLE PRECISION,ELEMENTARY FUNCTION,SINE,
C             TRIGONOMETRIC SINE
C***AUTHOR  FULLERTON, W., (LANL)
C***PURPOSE  Computes the d.p. Sine for degree arguments.
C***DESCRIPTION
C
C DSINDG(X) calculates the double precision sine for double
C precision argument X where X is in degrees.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  (NONE)
C***END PROLOGUE  DSINDG
      DOUBLE PRECISION X, RADDEG
      DATA RADDEG / 0.0174532925 1994329576 9236907684 886 D0 /
C***FIRST EXECUTABLE STATEMENT  DSINDG
      DSINDG = DSIN (RADDEG*X)
C
      IF (DMOD(X,90.D0).NE.0.D0) RETURN
      N = DABS(X)/90.D0 + 0.5D0
      N = MOD (N, 2)
      IF (N.EQ.0) DSINDG = 0.D0
      IF (N.EQ.1) DSINDG = DSIGN (1.0D0, DSINDG)
C
      RETURN
      END
