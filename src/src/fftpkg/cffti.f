      SUBROUTINE CFFTI(N,WSAVE)
C***BEGIN PROLOGUE  CFFTI
C***DATE WRITTEN   790601   (YYMMDD)
C***REVISION DATE  830401   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C***CATEGORY NO.  J1A2
C***KEYWORDS  FOURIER TRANSFORM
C***AUTHOR  SWARZTRAUBER, P. N., (NCAR)
C***PURPOSE  Initialize for CFFTF and CFFTB.
C***DESCRIPTION
C
C  Subroutine CFFTI initializes the array WSAVE which is used in
C  both CFFTF and CFFTB.  The prime factorization of N together with
C  a tabulation of the trigonometric functions are computed and
C  stored in WSAVE.
C
C  Input Parameter
C
C  N       the length of the sequence to be transformed
C
C  Output Parameter
C
C  WSAVE   a work array which must be dimensioned at least 4*N+15.
C          The same work array can be used for both CFFTF and CFFTB
C          as long as N remains unchanged.  Different WSAVE arrays
C          are required for different values of N.  The contents of
C          WSAVE must not be changed between calls of CFFTF or CFFTB.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  CFFTI1
C***END PROLOGUE  CFFTI
      DIMENSION       WSAVE(*)
C***FIRST EXECUTABLE STATEMENT  CFFTI
      IF (N .EQ. 1) RETURN
      IW1 = N+N+1
      IW2 = IW1+N+N
      CALL CFFTI1 (N,WSAVE(IW1),WSAVE(IW2))
      RETURN
      END
