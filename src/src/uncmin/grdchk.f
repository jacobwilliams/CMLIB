      SUBROUTINE GRDCHK(N,X,FCN,F,G,TYPSIZ,SX,FSCALE,RNF,
     +     ANALTL,WRK1,MSG,IPR)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
C
C PURPOSE
C -------
C CHECK ANALYTIC GRADIENT AGAINST ESTIMATED GRADIENT
C
C PARAMETERS
C ----------
C N            --> DIMENSION OF PROBLEM
C X(N)         --> ESTIMATE TO A ROOT OF FCN
C FCN          --> NAME OF SUBROUTINE TO EVALUATE OPTIMIZATION FUNCTION
C                  MUST BE DECLARED EXTERNAL IN CALLING ROUTINE
C                       FCN:  R(N) --> R(1)
C F            --> FUNCTION VALUE:  FCN(X)
C G(N)         --> GRADIENT:  G(X)
C TYPSIZ(N)    --> TYPICAL SIZE FOR EACH COMPONENT OF X
C SX(N)        --> DIAGONAL SCALING MATRIX:  SX(I)=1./TYPSIZ(I)
C FSCALE       --> ESTIMATE OF SCALE OF OBJECTIVE FUNCTION FCN
C RNF          --> RELATIVE NOISE IN OPTIMIZATION FUNCTION FCN
C ANALTL       --> TOLERANCE FOR COMPARISON OF ESTIMATED AND
C                  ANALYTICAL GRADIENTS
C WRK1(N)      --> WORKSPACE
C MSG         <--  MESSAGE OR ERROR CODE
C                    ON OUTPUT: =-21, PROBABLE CODING ERROR OF GRADIENT
C IPR          --> DEVICE TO WHICH TO SEND OUTPUT
C
      DIMENSION X(N),G(N)
      DIMENSION SX(N),TYPSIZ(N)
      DIMENSION WRK1(N)
      EXTERNAL FCN
C
C COMPUTE FIRST ORDER FINITE DIFFERENCE GRADIENT AND COMPARE TO
C ANALYTIC GRADIENT.
C
      CALL FSTOFD(1,1,N,X,FCN,F,WRK1,SX,RNF,WRK,1)
      KER=0
      DO 5 I=1,N
        GS=MAX(ABS(F),FSCALE)/MAX(ABS(X(I)),TYPSIZ(I))
        IF(ABS(G(I)-WRK1(I)).GT.MAX(ABS(G(I)),GS)*ANALTL) KER=1
    5 CONTINUE
      IF(KER.EQ.0) GO TO 20
        WRITE(IPR,901)
        WRITE(IPR,902) (I,G(I),WRK1(I),I=1,N)
        MSG=-21
   20 CONTINUE
      RETURN
  901 FORMAT(47H0GRDCHK    PROBABLE ERROR IN CODING OF ANALYTIC,
     +       19H GRADIENT FUNCTION./
     +       16H GRDCHK     COMP,12X,8HANALYTIC,12X,8HESTIMATE)
  902 FORMAT(11H GRDCHK    ,I5,3X,E20.13,3X,E20.13)
      END
