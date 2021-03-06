      SUBROUTINE CDSCL (HMAX,N,NQ,RMAX,H,RC,RH,YH)
C***BEGIN PROLOGUE  CDSCL
C***REFER TO  CDRIV3
C   This subroutine rescales the YH array whenever the step size
C   is changed.
C***ROUTINES CALLED  (NONE)
C***DATE WRITTEN   790601   (YYMMDD)
C***REVISION DATE  850319   (YYMMDD)
C***CATEGORY NO.  I1A2,I1A1B
C***AUTHOR  KAHANER, D. K., NATIONAL BUREAU OF STANDARDS,
C           SUTHERLAND, C. D., LOS ALAMOS NATIONAL LABORATORY
C***END PROLOGUE  CDSCL
      COMPLEX YH(N,*)
      REAL H, HMAX, RC, RH, RMAX, R1
C***FIRST EXECUTABLE STATEMENT  CDSCL
      IF (H .LT. 1.E0) THEN
        RH = MIN(ABS(H)*RH, ABS(H)*RMAX, HMAX)/ABS(H)
      ELSE
        RH = MIN(RH, RMAX, HMAX/ABS(H))
      END IF
      R1 = 1.E0
      DO 10 J = 1,NQ
        R1 = R1*RH
        DO 10 I = 1,N
 10       YH(I,J+1) = YH(I,J+1)*R1
      H = H*RH
      RC = RC*RH
      END
