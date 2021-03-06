      SUBROUTINE SQRLSS(A,LDA,M,N,KR,B,X,RSD,JPVT,QRAUX)
C***BEGIN PROLOGUE  SQRLSS
C***REVISION NOVEMBER 15, 1980
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C***CATEGORY NO.  E2G1A
C***KEYWORD(S)  OVERDETERMINED,LEAST SQUARES,LINEAR EQUATIONS
C***AUTHOR  D. KAHANER (NBS)
C***DATE WRITTEN
C***PURPOSE
C      SOLVES AN OVERDETERMINED, UNDERDETERMINED, OR SINGULAR SYSTEM OF
C      LINEAR EQUATIONS IN LEAST SQUARE SENSE.
C***DESCRIPTION
C
C     SQRLSS USES THE LINPACK SUBROUTINE SQRSL TO SOLVE AN OVERDETERMINE
C     UNDERDETERMINED, OR SINGULAR LINEAR SYSTEM IN A LEAST SQUARES
C     SENSE.  IT MUST BE PRECEEDED BY SQRANK .
C     THE SYSTEM IS  A*X  APPROXIMATES  B  WHERE  A  IS  M  BY  N  WITH
C     RANK  KR  (DETERMINED BY SQRANK),  B  IS A GIVEN  M-VECTOR,
C     AND  X  IS THE  N-VECTOR TO BE COMPUTED.  A SOLUTION  X  WITH
C     AT MOST  KR  NONZERO COMPONENTS IS FOUND WHICH MINIMIMZES
C     THE 2-NORM OF THE RESIDUAL,  A*X - B .
C
C     ON ENTRY
C
C        A,LDA,M,N,KR,JPVT,QRAUX
C              THE OUTPUT FROM SQRANK .
C
C        B     REAL(M) .
C              THE RIGHT HAND SIDE OF THE LINEAR SYSTEM.
C
C     ON RETURN
C
C        X     REAL(N) .
C              A LEAST SQUARES SOLUTION TO THE LINEAR SYSTEM.
C
C        RSD   REAL(M) .
C              THE RESIDUAL, B - A*X .  RSD MAY OVERWITE  B .
C
C      USAGE....
C        ONCE THE MATRIX A HAS BEEN FORMED, SQRANK SHOULD BE
C      CALLED ONCE TO DECOMPOSE IT.  THEN FOR EACH RIGHT HAND
C      SIDE, B, SQRLSS SHOULD BE CALLED ONCE TO OBTAIN THE
C      SOLUTION AND RESIDUAL.
C
C     INTEGER J,K,INFO
C     REAL T
C
C***REFERENCE(S)
C      DONGARRA, ET AL, LINPACK USERS GUIDE, SIAM, 1979
C***ROUTINES CALLED  SQRSL
C***END PROLOGUE
      INTEGER LDA,M,N,KR,JPVT(*)
      REAL A(LDA,*),B(*),X(*),RSD(*),QRAUX(*)
C***FIRST EXECUTABLE STATEMENT
      IF (KR .NE. 0)
     1   CALL SQRSL(A,LDA,M,KR,QRAUX,B,RSD,RSD,X,RSD,RSD,110,INFO)
      DO 40 J = 1, N
         JPVT(J) = -JPVT(J)
         IF (J .GT. KR) X(J) = 0.0
   40 CONTINUE
      DO 70 J = 1, N
         IF (JPVT(J) .GT. 0) GO TO 70
         K = -JPVT(J)
         JPVT(J) = K
   50    CONTINUE
            IF (K .EQ. J) GO TO 60
            T = X(J)
            X(J) = X(K)
            X(K) = T
            JPVT(K) = -JPVT(K)
            K = JPVT(K)
         GO TO 50
   60    CONTINUE
   70 CONTINUE
      RETURN
      END
