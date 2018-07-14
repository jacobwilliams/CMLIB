
## NIST Core Math Library (CMLIB)

### Summary

                    ( Version 3.0  ---  April 1988 )

    A  collection  of  non-proprietary,   easily   transportable   Fortran
    subprogram packages solving a variety of mathematical and  statistical
    problems.

              Compiled by   Ronald F. Boisvert (boisvert@nist.gov)
                            Sally E. Howe
                            David K. Kahaner

                            Computing and Applied Mathematics Laboratory
                            National Institute of Standards and Technology
                            Gaithersburg, MD 20899

    Although most applications will only  use  a  small  number  of  CMLIB
    modules, there are no name conflicts within the library and  thus  all
    of CMLIB can easily be installed. All  the  documentation  is  machine
    readable.

### Disclaimer

Inclusion of computer programs in the NIST Core Math Library (CMLIB)
does not imply certification, recommendation, or endorsement by the
National Institute of Standards and Technology, nor does it imply
that the programs are necessarily the best available for the purpose.

### Listing

 * [ADAPT](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/adapt) A subroutine for evaluation of the integral  of  a  user
  specified function on a hyper rectangle of  dimension  2
  through 20.
 * [AMOSLIB](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/amoslib) A  collection  of   special   function   routines   with
  particular  emphasis  on  the   special   functions   of
  statistics.
 * [BLAS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/blas) Basic  linear  algebra  subroutines.   Perform   various
  elementary matrix and vector opertaions.
 * [BOCLS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/bocls) Solves bounded and  linearly  constrained  linear  least
  squares problems.
 * [BSPLINE](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/bspline) Subroutines for computing with piecewise polynomials (B-
  splines). Includes  interpolation,  differentiation  and
  integration with B-splines.
 * [BVSUP](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/bvsup) Solves linear two-point boundary  value  problems  using
  superposition   voupled   with   an   orthonormalization
  procedure and a variable-step integration scheme.
 * [CDRIV](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/cdriv) Solves initial value problems for  systems  of  ordinary
  differential  equations   including   stiff   equations.
  Complex   differential   equations,   real   independent
  variable.
 * [CLUSTER](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/cluster) Subroutines  for  cluster  analysis  and   related  line
  printer  graphics.  Included are routines for clustering
  variables  and/or observations  using algorithms such as
  direct  joining  and splitting,  Fisher's  exact optimi-
  zation, single-link, K-means, and minimum mutations, and
  routines for estimating missing values.
 * [CPQR79](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/cpqr79) two subprograms for finding all (complex) zeros of  real
  or complex polynomials. (Based on EISPACK software.)
 * [CPZERO](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/cpzero) two subprograms for finding all (complex) zeros of  real
  or complex polynomials. (Based on Newton's method.)
 * [DBSPLIN](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/dbsplin) Subroutines for computing with piecewise polynomials (B-
  splines). Double precision version of BSPLINE package.
 * [DDASSL](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/ddassl) Solves the system of differential/algebraic equations of
  the form g(t,y,yprime) = 0. (Double precision version of
  SDASSL)
 * [DEPAC](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/depac) A suite of programs for solving initial  value  problems
  for ordinary differential equations.
 * [DDRIV](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/ddriv) Solves initial value problems for  systems  of  ordinary
  differential equations, including stiff systems. (Double
  precision version of SDRIV).
 * [DNL2SN](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/dnl2sn) A collection of  two  subprograms  for  nonlinear  least
  squares  problems  and  three  subprograms  for  general
  unconstrained minimization  problems.  Double  precision
  version of NL2SN.
 * [DQRLSS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/dqrlss) Solves linear least squares problem in the  matrix  form
  Ax=b.  Uses  LINPACK  routines.  Easy  to  use.   Double
  Precision version of SQRLSS.
 * [DTENSBS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/dtensbs) Interpolation of two and three dimensional gridded  data
  using tensor products of one dimensional B-spline  basis
  functions. Double precision version of TENSBS.
 * [EISPACK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/eispack) Solves various linear algebraic eigenvalue problems.
 * [FC](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/fc) Solves constrained least squares problems.
 * [FCNPAK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/fcnpak) A collection of special function routines, including the
  associated Legendre functions (Ferrers  functions),  the
  normalized Legendre polynomials, and elliptic  integrals
  of the first, second, and third kinds.
 * [FFTPKG](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/fftpkg) Subroutines for computing the fast Fourier transform  in
  various forms.
 * [FNLIB](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/fnlib) Portable  special   function   routines   (e.g.   Bessel
  functions, the error function, etc.)
 * [FISHPAK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/fishpak) FISHPAK  solves  separable   elliptic   boundary   value
  problems in two and three dimensions using a variety  of
  coordinate systems.
 * [LICEPAK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/licepak) Solves various  linear  algebraic  eigenvalue  problems.
  (Provides an interface to the EISPACK package).
 * [LINDRV](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/lindrv) Programs to solve linear systems of algebraic  equations
  in a number of forms. Provides an easy to use  interface
  to the LINPACK package.
 * [LINPAKC](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/linpakc) Analyse and solve various systems  of  linear  algebraic
  equations. (Complex precision version of LINPACK).
 * [LINPAKD](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/linpakd) Analyse and solve various systems  of  linear  algebraic
  equations. (Double precision version of LINPACK).
 * [LINPAKS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/linpaks) Analyse and solve various systems  of  linear  algebraic
  equations. (Single precision version of LINPACK).
 * [LOTPS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/lotps) A set of programs for smooth interpolation of  scattered
  data in two dimensions using thin-plate splines.
 * [MACHCON](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/machcon) Functions that return machine-dependent constants. These
  are used by many routines in CMLIB.
 * [MXENTRP](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/mxentrp) compute maximum entropy spectrum estimates  for  equally
  spaced time series.
 * [NL2SN](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/nl2sn) A collection of  two  subprograms  for  nonlinear  least
  squares  problems  and  three  subprograms  for  general
  unconstrained minimization problems.
 * [ODRPACK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/odrpack) A  collection  of  subprograms for  computing a weighted
  orthogonal  distance  regression  or ordinary  linear or
  nonlinear least squares solution.  (Both single and dou-
  ble precision versions are available.)
 * [PCHIPD](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/pchipd) is a set of programs  for  interpolation  of  univariate
  data and which is specially adapted  to  producing  fits
  which are are aesthetically pleasing.  (Double precision
  version of PCHIP).
 * [PCHIPS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/pchips) is a set of programs  for  interpolation  of  univariate
  data and which is specially adapted  to  producing  fits
  which are are aesthetically pleasing.  (Single precision
  version of PCHIP).
 * [Q1DA](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/q1da) evaluates one dimensional integrals automatically,  easy
  to use but very powerful.
 * [QUADPKD](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/quadpkd) is a set of programs for evaluating  definite  integrals
  of functions  of  one  variable;  the  double  precision
  version of QUADPKS.
 * [QUADPKS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/quadpks) is a set of programs for evaluating  definite  integrals
  of  functions  of  one  variable;   including   singular
  integrands and infinite intervals .
 * [RV](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/rv) generates uniform random numbers or normal numbers  with
  zero  mean  and  standard   deviation   one.   Portable,
  reproducible, and with a long cycle
 * [SDASSL](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/sdassl) Solves the system of differential/algebraic equation  of
  the form g(t,y,yprime) = 0.
 * [SDRIV](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/sdriv) Solves initial value problems for  systems  of  ordinary
  differential equations, including stiff systems.
 * [SGLSS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/sglss) Solves over or underdetermined linear systems  in  least
  squares sense.
 * [SLRPACK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/slrpack) A collection of subprograms for simple linear regression
 * [SLVBLK](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/slvblk) solves linear systems of algebraic equations  where  the
  coefficient matrix is in "almost block diagonal" form
 * [SNLS1E](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/snls1e) Solves non-linear least squares problems and  non-linear
  systems of equations.
 * [SPLP](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/splp) Solves linear programming problems  (minimize  a  linear
  function of  n  variables  subject  to  linear  equality
  constraints).
 * [SQRLSS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/sqrlss) Solves linear least squares problem in the  matrix  form
  Ax=b. Uses LINPACK routines. Easy to use.
 * [SSORT](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/ssort) Fast in-core sorting of arrays.
 * [TENSBS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/tensbs) Interpolation of two and three dimensional gridded  data
  using tensor products of one dimensional B-spline  basis
  functions.
 * [TWODQ](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/twodq) Automatic evaluation of two dimensional  integral  of  a
  function f(x,y) on one or more triangles in the plane.
 * [UNCMIN](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/uncmin) Solves the  unconstrained  minimization  problem  for  a
  real-valued  twice-continuously-differentiable  function
  of n variables.
 * [VFFT](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/vfft) A vectorized package of Fortran subprograms for the fast
  Fourier transform of multiple real sequences.
 * [VHS3](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/vhs3) A vectorized  package of  Fortran  subprograms  for  the
  solution of a three-dimensional  Helmholtz equation on a
  staggered grid.
 * [VSFFT](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/vsfft) A vectorized package of Fortran subprograms for the fast
  transform  of  multiple  real  sequences  defined  on  a
  staggered grid.
 * [XBLAS](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/xblas) Extended  basic  linear  algebra  subroutines.   Perform
  various matrix and vector operations not  found  in  the
  BLAS.
 * [XERROR](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/xerror) Error  handling  utilities.  These  are  used  by   most
  subprograms in CMLIB.
 * [ZEROIN](https://github.com/jacobwilliams/CMLIB/tree/master/src/src/zeroin) Finds zeros of a function of one variable.

### Revision history

 * Version 1.0  March 1986
 * Version 2.0  March 1987
 * Version 3.0  April 1988

#### Summary of changes

```
          Version 1.0 (March 1986)  to  Version 2.0 (March 1987)

 NEW SUBLIBRARIES

   CLUSTER  = cluster analysis
   VFFT     = multiple real FFTs (with Cyber 205 vector version)
   VSFFT    = multiple real staggered grid FFTs (with Cyber 205 vector
              version)
   VHS3     = solution of Poisson/Helmholtz equation on a staggered
              grid in three dimensions (with Cyber 205 vector version)

 MODIFIED SUBLIBRARIES (source, documentation, and tests changed)

   SDRIV    = new version (dimensions of WORK, IWORK changed)
   DDRIV    = new version (dimensions of WORK, IWORK changed)
   CDRIV    = new version (dimensions of WORK, IWORK changed)
   FCNPAK   = new version of all routines except RC, RD, RF
   AMOSLIB  = added four new subprograms: BESY, DBESJ, DPSIFN, PSIFN

 OTHER MODIFICATIONS

   ADAPT    = test program changed (changed MAXPTS and WORKSTR from
              2000 to 3000)
   BLAS     = test program changed (calls to DQDOTA and DQDOTI removed)
```

#### Summary of changes

```
          Version 2.0 (March 1987)  to  Version 3.0 (April 1988)


 NEW SUBLIBRARIES

   ODRPACK  = orthogonal distance regression
   PCHIPD   = piecewise cubic Hermite interpolation (double precision

 MODIFIED SUBLIBRARIES (source, documentation, and tests changed)

   VFFT     = added routines for multiple trigonometric transforms,
              e.g. sine, cosine (with Cyber 205 versions)
   QUADPKS  = added routine EA for accelerating convergence of
              sequences
   QUADPKD  = added routine DEA for accelerating convergence of
              sequences (double precision version of EA)
   PCHIPS   = new version
   FCNPAK   = new version Legendre function routines XDLEGF, XSLEGF,
              XDNRMP, XSNRMP

 OTHER MODIFICATIONS

   AMOSLIB  = added missing internal routines BESYNU, YAIRY, DBESY,
              DASYJY, DBSYNU, DYAIRY
   BOCLS    = added missing internal routine DMOUT
   FC       = minor change to test program
   LINDRV   = minor change to test programs LINDRV1 and LINDRV2
   MACHCON  = added machine constants for Cyber 180 NOS/VE, SUN 3,
              and CONVEX C-120
   SDRIV    = added assignment G=0.0 before RETURN in function G
   SLRPACK  = minor change to test program
   VFFT     = fixed reference to function PIMACH in VRADB3, VRADB5,
              VRADBG, VRADF3, VRADF5, VRADFG, VRFTI1
   VHS3     = fixed reference to function PIMACH in VSCOSI, VSCSQI
```
