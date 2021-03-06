      SUBROUTINE RFFTI(N,WSAVE)
C***BEGIN PROLOGUE  RFFTI
C***DATE WRITTEN   790601   (YYMMDD)
C***REVISION DATE  830401   (YYMMDD)
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C***CATEGORY NO.  J1A1
C***KEYWORDS  FOURIER TRANSFORM
C***AUTHOR  SWARZTRAUBER, P. N., (NCAR)
C***PURPOSE  Initialize for RFFTF and RFFTB.
C***DESCRIPTION
C
C  Subroutine RFFTI initializes the array WSAVE which is used in
C  both RFFTF and RFFTB.  The prime factorization of N together with
C  a tabulation of the trigonometric functions are computed and
C  stored in WSAVE.
C
C  Input Parameter
C
C  N       the length of the sequence to be transformed.
C
C  Output Parameter
C
C  WSAVE   a work array which must be dimensioned at least 2*N+15.
C          The same work array can be used for both RFFTF and RFFTB
C          as long as N remains unchanged.  Different WSAVE arrays
C          are required for different values of N.  The contents of
C          WSAVE must not be changed between calls of RFFTF or RFFTB.
C***REFERENCES  (NONE)
C***ROUTINES CALLED  RFFTI1
C***END PROLOGUE  RFFTI
      DIMENSION       WSAVE(*)
C***FIRST EXECUTABLE STATEMENT  RFFTI
      IF (N .EQ. 1) RETURN
      CALL RFFTI1 (N,WSAVE(N+1),WSAVE(2*N+1))
      RETURN
      END
