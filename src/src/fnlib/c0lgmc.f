      COMPLEX FUNCTION C0LGMC(Z)
C***BEGIN PROLOGUE  C0LGMC
C***DATE WRITTEN   780401   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  C7A
C***KEYWORDS  COMPLEX,GAMMA FUNCTION,RELATIVE ERROR,SPECIAL FUNCTION
C***AUTHOR  FULLERTON, W., (LANL)
C***PURPOSE  Evaluates (Z+0.5)*CLOG((Z+1.)/Z) - 1.0 with relative
C            accuracy.
C***DESCRIPTION
C
C Evaluate  (Z+0.5)*CLOG((Z+1.0)/Z) - 1.0  with relative error accuracy
C Let Q = 1.0/Z so that
C     (Z+0.5)*CLOG(1+1/Z) - 1 = (Z+0.5)*(CLOG(1+Q) - Q + Q*Q/2) - Q*Q/4
C        = (Z+0.5)*Q**3*C9LN2R(Q) - Q**2/4,
C where  C9LN2R  is (CLOG(1+Q) - Q + 0.5*Q**2) / Q**3.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  C9LN2R,R1MACH
C***END PROLOGUE  C0LGMC
      COMPLEX Z, Q, C9LN2R, CLOG
      DATA RBIG / 0.0 /
C***FIRST EXECUTABLE STATEMENT  C0LGMC
      IF (RBIG.EQ.0.0) RBIG = 1.0/R1MACH(3)
C
      CABSZ = CABS(Z)
      IF (CABSZ.GT.RBIG) C0LGMC = -(Z+0.5)*CLOG(Z) - Z
      IF (CABSZ.GT.RBIG) RETURN
C
      Q = 1.0/Z
      IF (CABSZ.LE.1.23) C0LGMC = (Z+0.5)*CLOG(1.0+Q) - 1.0
      IF (CABSZ.GT.1.23) C0LGMC = ((1.+.5*Q)*C9LN2R(Q) - .25) * Q**2
C
      RETURN
      END
