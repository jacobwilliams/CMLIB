 
      REAL FUNCTION rc(x,y,ier)
c***BEGIN PROLOGUE  rc
c***DATE WRITTEN   790801   (yymmdd)
c***REVISION DATE  830622   (yymmdd)
c***CATEGORY NO.  b5
c***KEYWORDS  elementary functions,elliptic integrals
c             duplication theorem,taylor series
c***AUTHOR  carlson b.c. ames laboratory-doe,iowa state university
c           notis e.m.   ames laboratory-doe,iowa state university
c                        ames, iowa  50011
c           pexton r.l.  lawrence livermore national laboratory
c                        livermore, california  94550
c***PURPOSE  the routine calculates an approximation result to
c            rc(x,y) = integral from zero to infinity of
c                              -1/2     -1
c                    (1/2)(t+x)    (t+y)  dt,
c            where x is nonnegative and y is positive.
c***DESCRIPTION
c
c   1.     rc
c          standard fortran function routine
c          real version
c          the routine calculates an approximation result to
c          rc(x,y) = integral from zero to infinity of
c
c                              -1/2     -1
c                    (1/2)(t+x)    (t+y)  dt,
c
c          where x is nonnegative and y is positive. the duplication
c          theorem is iterated until the variables are nearly equal,
c          and the function is then expanded in taylor series to fifth
c          order.  logarithmic, inverse circular, and inverse hyper-
c          bolic functions can be expressed in terms of rc.
c
c
c   2.     calling sequence
c          rc( x, y, ier )
c
c          parameters on entry     values assigned by the calling subrou
c
c          x      - real,nonnegative variable
c
c          y      - real,positive variable
c
c
c
c          on return     values assigned by the rc subroutine
c
c          rc     - real approximation to the integral
c
c          ier     - integer to indicate normal or abnormal termination.
c
c                     ier = 0 normal and reliable termination of the
c                             routine. it is assumed that the requested
c                             accuracy has been achieved.
c
c                     ier >  0 abnormal termination of the routine
c
c          x and y are unaltered.
c
c
c   3.    error messages
c
c         value of ier assigned by the rc subroutine
c
c                  value assigned         error message printed
c                  ier = 1                x.lt.0.0e0.or.y.le.0.0e0
c                      = 2                x+y.lt.lolim
c                      = 3                amax1(x,y) .gt. uplim
c
c
c   4.     control parameters
c
c                  values of lolim,uplim,and errtol are set by the
c                  subroutine.
c
c          lolim and uplim determine the valid range of x and y
c
c          lolim  - lower limit of valid arguments
c
c                   not less  than 5 * (machine minimum)  .
c
c          uplim  - upper limit of valid arguments
c
c                   not greater than (machine maximum) / 5 .
c
c
c                     acceptable values for:   lolim      uplim
c                     ibm 360/370 series   :   3.0e-78     1.0e+75
c                     cdc 6000/7000 series :   1.0e-292    1.0e+321
c                     univac 1100 series   :   1.0e-37     1.0e+37
c                     cray                 :   2.3e-2466   1.09e+2465
c                     vax 11 series        :   1.5e-38     3.0e+37
c
c          errtol determines the accuracy of the answer
c
c                 the value assigned by the subroutine will result
c                 in solution precision within 1-2 decimals of
c                 "machine precision".
c
c
c          errtol  - relative error due to truncation is less than
c                    16 * errtol ** 6 / (1 - 2 * errtol).
c
c
c              the accuracy of the computed approximation to the integra
c              can be controlled by choosing the value of errtol.
c              truncation of a taylor series after terms of fifth order
c              introduces an error less than the amount shown in the
c              second column of the following table for each value of
c              errtol in the first column.  in addition to the truncatio
c              error there will be round-off error, but in practice the
c              total error from both sources is usually less than the
c              amount given in the table.
c
c
c
c          sample choices:  errtol   relative truncation
c                                    error less than
c                           1.0e-3    2.0e-17
c                           3.0e-3    2.0e-14
c                           1.0e-2    2.0e-11
c                           3.0e-2    2.0e-8
c                           1.0e-1    2.0e-5
c
c
c                    decreasing errtol by a factor of 10 yields six more
c                    decimal digits of accuracy at the expense of one or
c                    two more iterations of the duplication theorem.
c
c
c
c
c***LONG DESCRIPTION
c
c                  rc special comments
c
c
c
c
c                  check: rc(x,x+z) + rc(y,y+z) = rc(0,z)
c
c                  where x, y, and z are positive and x * y = z * z
c
c
c                    rc(0,1/4)=rc(1/16,1/8)=pi=3.14159...
c
c                    rc(9/4,2)=ln(2)
c
c
c          on input:
c
c          x and y are the variables in the integral rc(x y).
c
c          on output:
c
c          x and y are unaltered.
c
c
c
c
c          ********************************************************
c
c          warning: changes in the program may improve speed at the
c          expense of robustness.
c
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  special functions via rc
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c
c                  ln x                x gt 0
c
c                                            2
c                  ln(x) = (x-1) rc(((1+x)/2)  , x )
c
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arcsin x            -1 le x le 1
c
c                                      2
c                  arcsin x = x rc (1-x  ,1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arccos x            0 le x le 1
c
c
c                                     2      2
c                  arccos x = sqrt(1-x ) rc(x  ,1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arctan x            -inf. lt x lt inf.
c
c                                       2
c                  arctan x = x rc(1,1+x  )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arccot x            0 le x lt inf.
c
c                                 2   2
c                  arccot x = rc(x  ,x +1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arcsinh x           -inf. lt x lt inf.
c
c                                      2
c                  arcsinh x = x rc(1+x  ,1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arccosh x           x ge 1
c
c                                    2        2
c                  arccosh x = sqrt(x -1) rc(x  ,1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arctanh x           -1 lt x lt 1
c
c                                        2
c                  arctanh x = x rc(1,1-x  )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c                  arccoth x           x gt 1
c
c                                  2   2
c                  arccoth x = rc(x  ,x -1 )
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c
c
c
c
c   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c
c
c
c          subroutines or functions needed
c              - xerror
c              - r1mach
c              - fortran abs, amax1,amin1, sqrt
c
c***REFERENCES
c
c
c          carlson,b.c.and notis,e.m.
c          algorithms for incomplete elliptic integrals
c          acm transactions on mathematical software,vol.7,no.3,
c          sept,1981,pages 398-403
c
c
c          carlson,b.c.
c          computing elliptic integrals by duplication
c          numer.math.33,(1979),1-16
c
c
c          carlson,b.c.
c          elliptic integrals of the first kind
c          siam j.math.anal.8(1977),231-242
c
c
c
c***ROUTINES CALLED  xerror,r1mach
c
c
c***END PROLOGUE  rc
c
c
c
c                  rc routine begins
c                  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c
c
c
c
c
c
      integer ier
      real c1, c2, errtol, lamda, lolim
      real mu, s, sn, uplim, x, xn, y, yn
c
c
c
c
c
c***FIRST EXECUTABLE STATEMENT  rc
c
c
c
c
c
      errtol=(r1mach(3)/16.0)**(1.0/6.0)
c
c
c
      lolim = 5.0e0 * r1mach(1)
      uplim = r1mach(2) / 5.0e0
c
c
      c1 = 1.0e0/7.0e0
      c2 = 9.0e0/22.0e0
c
c
c
c
c
c         call error handler if necessary.
c
c
    5 rc=0.0e0
      if (x.lt.0.0e0.or.y.le.0.0e0) then
      ier=1
      call xerror (39h*** rc   error x.lt.0.0e0.or.y.le.0.0e0,39,1,1 )
      return
      endif
      if (x+y.lt.lolim)   then
      ier=2
      call xerror (27h*** rc   error x+y.lt.lolim,27,2,1 )
      return
      endif
      if (amax1(x,y).gt.uplim) then
      ier=3
      call xerror (34h*** rc   error amax1(x,y).gt.uplim,34,3,1 )
      return
      endif
c
c
c
   20 ier = 0
      xn = x
      yn = y
c
c
c
   30 mu = (xn+yn+yn)/3.0e0
      sn = (yn+mu)/mu - 2.0e0
      if ( abs(sn).lt.errtol) go to 40
      lamda = 2.0e0* sqrt(xn)* sqrt(yn) + yn
      xn = (xn+lamda)*0.250e0
      yn = (yn+lamda)*0.250e0
      go to 30
c
   40 s = sn*sn*(0.30e0+sn*(c1+sn*(0.3750e0+sn*c2)))
      rc = (1.0e0+s)/ sqrt(mu)
c
c
c
   50 return
c
c
c
c
      END
