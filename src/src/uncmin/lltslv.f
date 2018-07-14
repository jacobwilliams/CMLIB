      SUBROUTINE LLTSLV(NR,N,A,X,B)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
C PURPOSE
C -------
C SOLVE AX=B WHERE A HAS THE FORM L(L-TRANSPOSE)
C BUT ONLY THE LOWER TRIANGULAR PART, L, IS STORED.
C
C PARAMETERS
C ----------
C NR           --> ROW DIMENSION OF MATRIX
C N            --> DIMENSION OF PROBLEM
C A(N,N)       --> MATRIX OF FORM L(L-TRANSPOSE).
C                  ON RETURN A IS UNCHANGED.
C X(N)        <--  SOLUTION VECTOR
C B(N)         --> RIGHT-HAND SIDE VECTOR
C
C NOTE
C ----
C IF B IS NOT REQUIRED BY CALLING PROGRAM, THEN
C B AND X MAY SHARE THE SAME STORAGE.
C
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
      DIMENSION A(NR,*),X(N),B(N)
C
C FORWARD SOLVE, RESULT IN X
C
      CALL FORSLV(NR,N,A,X,B)
C
C BACK SOLVE, RESULT IN X
C
      CALL BAKSLV(NR,N,A,X,X)
      RETURN
      END
