## Test environments
* win-build (devel and release)

## R CMD check results

this notification has been generated automatically.
Your package graticule_0.0.3.tar.gz has been built (if working) and checked for Windows.
Please check the log files and (if working) the binary package at:
http://win-builder.r-project.org/Wd2hx3X37e8i
The files will be removed after roughly 72 hours.
Installation time in seconds: 6
Check time in seconds: 83
Check result: ERROR
R version 3.2.1 (2015-06-18)


* using log directory 'd:/RCompile/CRANguest/R-release/graticule.Rcheck'
* using R version 3.2.1 (2015-06-18)
* using platform: x86_64-w64-mingw32 (64-bit)
* using session charset: ISO8859-1
* checking for file 'graticule/DESCRIPTION' ... OK
* checking extension type ... Package
* this is package 'graticule' version '0.0.3'
* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Michael D. Sumner <mdsumner@gmail.com>'
New submission

Possibly mis-spelled words in DESCRIPTION:
  Meridional (3:8)
  graticule (7:21)
Found the following (possibly) invalid URLs:
  URL: http://www.manifold.net
    From: inst/doc/graticule.html
    Status: 404
    Message: Not Found
* checking package namespace information ... OK
* checking package dependencies ... NOTE
  No repository set, so cyclic dependency check skipped
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking whether package 'graticule' can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking 'build' directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* loading checks for arch 'i386'
** checking whether the package can be loaded ... OK
** checking whether the package can be loaded with stated dependencies ... OK
** checking whether the package can be unloaded cleanly ... OK
** checking whether the namespace can be loaded with stated dependencies ... OK
** checking whether the namespace can be unloaded cleanly ... OK
** checking loading without being on the library search path ... OK
** checking use of S3 registration ... OK
* loading checks for arch 'x64'
** checking whether the package can be loaded ... OK
** checking whether the package can be loaded with stated dependencies ... OK
** checking whether the package can be unloaded cleanly ... OK
** checking whether the namespace can be loaded with stated dependencies ... OK
** checking whether the namespace can be unloaded cleanly ... OK
** checking loading without being on the library search path ... OK
** checking use of S3 registration ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking installed files from 'inst/doc' ... OK
* checking files in 'vignettes' ... OK
* checking examples ...
** running examples for arch 'i386' ... ERROR
Running examples in 'graticule-Ex.R' failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: graticule
> ### Title: graticule: graticule lines for maps
> ### Aliases: graticule graticule-package
> 
> ### ** Examples
> 
> library(rgdal)
rgdal: version: 1.0-4, (SVN revision 548)
 Geospatial Data Abstraction Library extensions to R successfully loaded
 Loaded GDAL runtime: GDAL 1.11.2, released 2015/02/10
 Path to GDAL shared files: D:/temp/RtmpSskfCh/RLIBS_3da81581ce5/rgdal/gdal
 GDAL does not use iconv for recoding strings.
 Loaded PROJ.4 runtime: Rel. 4.9.1, 04 March 2015, [PJ_VERSION: 491]
 Path to PROJ.4 shared files: D:/temp/RtmpSskfCh/RLIBS_3da81581ce5/rgdal/proj
 Linking to sp version: 1.1-1 
> x <- as.matrix(expand.grid(x = seq(100, 240, by = 15), y = seq(-85, -30, by = 15)))
> prj <- "+proj=laea +lon_0=180 +lat_0=-70"
> px <- project(x, prj)
> g <- graticule(unique(x[,1]), unique(x[,2]))
> pg <- spTransform(g, CRS(prj))
> plot(px, type = "n")
> plot(pg, add = TRUE)
> 
> g2 <- graticule(unique(x[,1]), unique(x[,2]), ylim = c(-90, 0), xlim = c(110, 250))
> pg2 <- spTransform(g2, CRS(prj))
Warning in .spTransform_Line(input[[i]], to_args = to_args, from_args = from_args,  :
  1 projected point(s) not finite
non finite transformation detected:
  x   y         
100 -90 NaN NaN 
Error in .spTransform_Line(input[[i]], to_args = to_args, from_args = from_args,  : 
  failure in Lines 1 Line 1 points 1
Calls: spTransform ... spTransform -> .spTransform_Lines -> .spTransform_Line
Execution halted
** running examples for arch 'x64' ... OK
* checking for unstated dependencies in 'tests' ... OK
* checking tests ...
** running tests for arch 'i386' ... OK
  Running 'testthat.R'
** running tests for arch 'x64' ... OK
  Running 'testthat.R'
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in 'inst/doc' ... OK
* checking running R code from vignettes ... OK
* checking re-building of vignette outputs ... OK
* checking PDF version of manual ... OK
* DONE
Status: 1 ERROR, 2 NOTEs
