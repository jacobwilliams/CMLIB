      SUBROUTINE DTBLOK ( BLOKS, INTEGS, NBLOKS, IPIVOT, IFLAG,
     *                    DETSGN, DETLOG )
C  COMPUTES THE DETERMINANT OF AN ALMOST BLOCK DIAGONAL MATRIX WHOSE
C  PLU FACTORIZATION HAS BEEN OBTAINED PREVIOUSLY IN FCBLOK.
C  *** THE LOGARITHM OF THE DETERMINANT IS COMPUTED INSTEAD OF THE
C  DETERMINANT ITSELF TO AVOID THE DANGER OF OVERFLOW OR UNDERFLOW
C  INHERENT IN THIS CALCULATION.
C
C***REVISION HISTORY  (YYMMDD)
C   000330  Modified array declarations.  (JEC)
C
C PARAMETERS
C    BLOKS, INTEGS, NBLOKS, IPIVOT, IFLAG  ARE AS ON RETURN FROM FCBLOK.
C            IN PARTICULAR, IFLAG = (-1)**(NUMBER OF INTERCHANGES DUR-
C            ING FACTORIZATION) IF SUCCESSFUL, OTHERWISE IFLAG = 0.
C    DETSGN  ON OUTPUT, CONTAINS THE SIGN OF THE DETERMINANT.
C    DETLOG  ON OUTPUT, CONTAINS THE NATURAL LOGARITHM OF THE DETERMI-
C            NANT IF DETERMINANT IS NOT ZERO. OTHERWISE CONTAINS 0.
C
      INTEGER INTEGS(3,NBLOKS),IPIVOT(*),IFLAG, I,INDEXP,IP,K,LAST
      REAL BLOKS(*),DETSGN,DETLOG
C
      DETSGN = IFLAG
      DETLOG = 0.
      IF (IFLAG .EQ. 0)                 RETURN
      INDEX = 0
      INDEXP = 0
      DO 2 I=1,NBLOKS
         NROW = INTEGS(1,I)
         LAST = INTEGS(3,I)
         DO 1 K=1,LAST
            IP = INDEX + NROW*(K-1) + IPIVOT(INDEXP+K)
            DETLOG = DETLOG + ALOG(ABS(BLOKS(IP)))
    1       DETSGN = DETSGN*SIGN(1.,BLOKS(IP))
         INDEX = NROW*INTEGS(2,I) + INDEX
    2    INDEXP = INDEXP + NROW
                                        RETURN
      END
