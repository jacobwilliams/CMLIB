      FUNCTION VNORM(V,NCOMP)
C***BEGIN PROLOGUE  VNORM
C***REFER TO  DEABM,DEBDF,DERKF
C
C     Compute the maximum norm of the vector V(*) of length NCOMP and
C     return the result as VNORM.
C***ROUTINES CALLED  (NONE)
C***END PROLOGUE  VNORM
C
C
      DIMENSION V(NCOMP)
C***FIRST EXECUTABLE STATEMENT  VNORM
      VNORM=0.
      DO 10 K=1,NCOMP
   10   VNORM=AMAX1(VNORM,ABS(V(K)))
      RETURN
      END
