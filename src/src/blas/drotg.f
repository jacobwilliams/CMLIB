      SUBROUTINE DROTG(DA,DB,DC,DS)
C***BEGIN PROLOGUE  DROTG
C***DATE WRITTEN   791001   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  D1B10
C***KEYWORDS  BLAS,GIVENS ROTATION,LINEAR ALGEBRA,VECTOR
C***AUTHOR  LAWSON, C. L., (JPL)
C           HANSON, R. J., (SNLA)
C           KINCAID, D. R., (U. OF TEXAS)
C           KROGH, F. T., (JPL)
C***PURPOSE  Construct d.p. plane Givens rotation
C***DESCRIPTION
C
C                B L A S  Subprogram
C    Description of Parameters
C
C     --Input--
C       DA  double precision scalar
C       DB  double precision scalar
C
C     --Output--
C       DA  double precision result R
C       DB  double precision result Z
C       DC  double precision result
C       DS  double precision result
C
C     Designed by C. L. Lawson, JPL, 1977 Sept 08
C
C
C     Construct the Givens transformation
C
C         ( DC  DS )
C     G = (        ) ,    DC**2 + DS**2 = 1 ,
C         (-DS  DC )
C
C     which zeros the second entry of the 2-vector  (DA,DB)**T .
C
C     The quantity R = (+/-)DSQRT(DA**2 + DB**2) overwrites DA in
C     storage.  The value of DB is overwritten by a value Z which
C     allows DC and DS to be recovered by the following algorithm.
C
C           If Z=1  set  DC=0.D0  and  DS=1.D0
C           If DABS(Z) .LT. 1  set  DC=DSQRT(1-Z**2)  and  DS=Z
C           If DABS(Z) .GT. 1  set  DC=1/Z  and  DS=DSQRT(1-DC**2)
C
C     Normally, the subprogram DROT(N,DX,INCX,DY,INCY,DC,DS) will
C     next be called to apply the transformation to a 2 by N matrix.
C***REFERENCES  LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C                 *BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C                 ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL
C                 SOFTWARE, VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C***ROUTINES CALLED  (NONE)
C***END PROLOGUE  DROTG
C
      DOUBLE PRECISION  DA, DB, DC, DS, U, V, R
C***FIRST EXECUTABLE STATEMENT  DROTG
      IF (DABS(DA) .LE. DABS(DB)) GO TO 10
C
C *** HERE DABS(DA) .GT. DABS(DB) ***
C
      U = DA + DA
      V = DB / U
C
C     NOTE THAT U AND R HAVE THE SIGN OF DA
C
      R = DSQRT(.25D0 + V**2) * U
C
C     NOTE THAT DC IS POSITIVE
C
      DC = DA / R
      DS = V * (DC + DC)
      DB = DS
      DA = R
      RETURN
C
C *** HERE DABS(DA) .LE. DABS(DB) ***
C
   10 IF (DB .EQ. 0.D0) GO TO 20
      U = DB + DB
      V = DA / U
C
C     NOTE THAT U AND R HAVE THE SIGN OF DB
C     (R IS IMMEDIATELY STORED IN DA)
C
      DA = DSQRT(.25D0 + V**2) * U
C
C     NOTE THAT DS IS POSITIVE
C
      DS = DB / DA
      DC = V * (DS + DS)
      IF (DC .EQ. 0.D0) GO TO 15
      DB = 1.D0 / DC
      RETURN
   15 DB = 1.D0
      RETURN
C
C *** HERE DA = DB = 0.D0 ***
C
   20 DC = 1.D0
      DS = 0.D0
      RETURN
C
      END
