      SUBROUTINE DDPST (EL,F,FA,H,IMPL,JACOBN,MATDIM,MITER,ML,MU,N,NDE,
     8   NQ,SAVE2,T,Y,YH,YWT,UROUND,NFE,NJE,A,DFDY,IER,IPVT,SAVE1,
     8   ISWFLG,BND)
C***BEGIN PROLOGUE  DDPST
C***REFER TO  DDRIV3
C  Subroutine DDPST is called to reevaluate the partials.
C  If MITER is 1, 2, 4, or 5, the matrix
C  P = I - L(0)*H*Jacobian is stored in DFDY and subjected to LU
C  decomposition, with the results also stored in DFDY.
C***ROUTINES CALLED  DGEFA,DGBFA,DNRM2
C***DATE WRITTEN   790601   (YYMMDD)
C***REVISION DATE  850320   (YYMMDD)
C***CATEGORY NO.  I1A2,I1A1B
C***AUTHOR  KAHANER, D. K., NATIONAL BUREAU OF STANDARDS,
C           SUTHERLAND, C. D., LOS ALAMOS NATIONAL LABORATORY
C***END PROLOGUE  DDPST
      DOUBLE PRECISION A(MATDIM,*), BND, DFDY(MATDIM,*), DFDYMX, DY,
     8     EL(13,12), EPSJ, ETA, ETATST, FACTOR, H, SAVE1(*), SAVE2(*),
     8     DNRM2, T, UROUND, Y(*), YH(N,*), YJ, YWT(*)
      INTEGER IPVT(*)
      LOGICAL IER, LOOP
      PARAMETER(ETATST = .5D0, ITERMX = 3)
C***FIRST EXECUTABLE STATEMENT  DDPST
      NJE = NJE + 1
      IER = .FALSE.
      IF (MITER .EQ. 1 .OR. MITER .EQ. 2) THEN
        IF (MITER .EQ. 1) THEN
          CALL JACOBN (N, T, Y, DFDY, MATDIM, ML, MU)
          IF (ISWFLG .EQ. 3) BND = DNRM2(N*N, DFDY, 1)
          FACTOR = -EL(1,NQ)*H
          DO 110 J = 1,N
            DO 110 I = 1,N
 110          DFDY(I,J) = FACTOR*DFDY(I,J)
        ELSE IF (MITER .EQ. 2) THEN
          EPSJ = UROUND**(1.D0/3.D0)
          DO 170 J = 1,N
            DY = EPSJ*MAX(ABS(YWT(J)), ABS(Y(J)))
            IF (DY .EQ. 0.D0) DY = EPSJ
            ITER = 0
 120        YJ = Y(J)
            Y(J) = Y(J) + DY
            CALL F (N, T, Y, SAVE1)
            Y(J) = YJ
            NFE = NFE + 1
            ITER = ITER + 1
            IF (ITER .LT. ITERMX) THEN
              DO 130 I = 1,N
                IF (SAVE1(I) .NE. SAVE2(I)) THEN
                  ETA = ABS(SAVE2(I))*UROUND/
     8            (ABS(SAVE2(I) - SAVE1(I)) + ABS(SAVE2(I))*UROUND)
                  IF (ETA .GE. ETATST) THEN
                    DY = DY*10.D0
                    GO TO 120
                  END IF
                END IF
 130            CONTINUE
            END IF
            FACTOR = -EL(1,NQ)*H/DY
            DO 140 I = 1,N
 140          DFDY(I,J) = (SAVE1(I) - SAVE2(I))*FACTOR
 170        CONTINUE
          IF (ISWFLG .EQ. 3) BND = DNRM2(N*N, DFDY, 1)/(-EL(1,NQ)*H)
        END IF
        IF (IMPL .EQ. 0) THEN
          DO 190 I = 1,N
 190        DFDY(I,I) = DFDY(I,I) + 1.D0
        ELSE IF (IMPL .EQ. 1) THEN
          CALL FA (N, T, Y, A, MATDIM, ML, MU, NDE)
          DO 210 J = 1,N
            DO 210 I = 1,N
 210          DFDY(I,J) = DFDY(I,J) + A(I,J)
        ELSE IF (IMPL .EQ. 2) THEN
          CALL FA (N, T, Y, A, MATDIM, ML, MU, NDE)
          DO 230 I = 1,NDE
 230        DFDY(I,I) = DFDY(I,I) + A(I,1)
        END IF
        CALL DGEFA (DFDY, MATDIM, N, IPVT, INFO)
        IF (INFO .NE. 0) IER = .TRUE.
      ELSE IF (MITER .EQ. 4 .OR. MITER .EQ. 5) THEN
        IF (MITER .EQ. 4) THEN
          CALL JACOBN (N, T, Y, DFDY(ML+1,1), MATDIM, ML, MU)
          FACTOR = -EL(1,NQ)*H
          MW = ML + MU + 1
          DO 260 J = 1,N
            I1 = MAX(ML+1, MW+1-J)
            I2 = MIN(MW+N-J, MW+ML)
            DO 260 I = I1,I2
 260          DFDY(I,J) = FACTOR*DFDY(I,J)
        ELSE IF (MITER .EQ. 5) THEN
          EPSJ = UROUND**(1.D0/3.D0)
          MW = ML + MU + 1
          J2 = MIN(MW, N)
          DO 340 J = 1,J2
            DO 265 K = J,N,MW
              DY = EPSJ*MAX(ABS(YWT(K)), ABS(Y(K)))
              IF (DY .EQ. 0.D0) DY = EPSJ
              DFDY(MW,K) = Y(K)
 265          Y(K) = Y(K) + DY
            ITER = 0
 270        CALL F (N, T, Y, SAVE1)
            NFE = NFE + 1
            ITER = ITER + 1
            IF (ITER .LT. ITERMX) THEN
              LOOP = .FALSE.
              DO 290 K = J,N,MW
                I1 = MAX(1, K-MU)
                I2 = MIN(K+ML, N)
                DO 280 I = I1,I2
                  IF (SAVE1(I) .NE. SAVE2(I)) THEN
                    ETA = ABS(SAVE2(I))*UROUND/
     8              (ABS(SAVE2(I) - SAVE1(I)) + ABS(SAVE2(I))*UROUND)
                    IF (ETA .GE. ETATST) THEN
                      DY = (Y(K) - DFDY(MW,K))*10.D0
                      Y(K) = DFDY(MW,K) + DY
                      LOOP = .TRUE.
                      GO TO 290
                    END IF
                  END IF
 280              CONTINUE
 290            CONTINUE
              IF (LOOP) GO TO 270
            END IF
            DO 330 K = J,N,MW
              DY = Y(K) - DFDY(MW,K)
              Y(K) = DFDY(MW,K)
              FACTOR = -EL(1,NQ)*H/DY
              I1 = MAX(ML+1, MW+1-K)
              I2 = MIN(MW+N-K, MW+ML)
              DO 300 I = I1,I2
                I3 = K + I - MW
 300            DFDY(I,K) = FACTOR*(SAVE1(I3) - SAVE2(I3))
 330          CONTINUE
 340        CONTINUE
        END IF
        IF (ISWFLG .EQ. 3) THEN
          DFDYMX = 0.D0
          DO 345 J = 1,N
            I1 = MAX(ML+1, MW+1-J)
            I2 = MIN(MW+N-J, MW+ML)
            DO 345 I = I1,I2
 345          DFDYMX = MAX(DFDYMX, ABS(DFDY(I,J)))
          BND = 0.D0
          IF (DFDYMX .NE. 0.D0) THEN
            DO 350 J = 1,N
              I1 = MAX(ML+1, MW+1-J)
              I2 = MIN(MW+N-J, MW+ML)
              DO 350 I = I1,I2
 350            BND = BND + (DFDY(I,J)/DFDYMX)**2
            BND = DFDYMX*SQRT(BND)/(-EL(1,NQ)*H)
          END IF
        END IF
        IF (IMPL .EQ. 0) THEN
          DO 360 J = 1,N
 360        DFDY(MW,J) = DFDY(MW,J) + 1.D0
        ELSE IF (IMPL .EQ. 1) THEN
          CALL FA (N, T, Y, A(ML+1,1), MATDIM, ML, MU, NDE)
          DO 380 J = 1,N
            I1 = MAX(ML+1, MW+1-J)
            I2 = MIN(MW+N-J, MW+ML)
            DO 380 I = I1,I2
 380          DFDY(I,J) = DFDY(I,J) + A(I,J)
        ELSE IF (IMPL .EQ. 2) THEN
          CALL FA (N, T, Y, A, MATDIM, ML, MU, NDE)
          DO 400 J = 1,NDE
 400        DFDY(MW,J) =  DFDY(MW,J) + A(J,1)
        END IF
        CALL DGBFA (DFDY, MATDIM, N, ML, MU, IPVT, INFO)
        IF (INFO .NE. 0) IER = .TRUE.
      ELSE IF (MITER .EQ. 3) THEN
        IFLAG = 1
        CALL USERS (Y, YH(1,2), YWT, SAVE1, SAVE2, T, H, EL(1,NQ), IMPL,
     8              N, NDE, IFLAG)
      END IF
      END
