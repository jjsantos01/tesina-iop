clear all
set more off
set pagesize 10000
if c(username)=="biiacscide14"{
global A "F:\JUAN SO\"
set matsize 10000
}
else{
global A "E:\"
set matsize 10000
}
global E "${A}Datos\emovi\2011\"
global D "${A}dropbox\tesina\emovi2011\"
global T "${D}tablas\"
adopath + "${D}do\"

global rep = 2

global educ1 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2" // Todas las variables
global educ2 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte
global educ3 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2" // Sin sexo
global educ4 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte o sexo
global educ5 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca_edad i.cohort2" // con índice de riqueza teniendo en cuenta la edad
global twopm1 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2" // Todas las variables
global twopm2 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte
global twopm3 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2 " // Sin sexo
global twopm4 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte ni sexo
/*
global educ1 "i.niveledu_pad i.niveledu_mad"
global educ2 "i.niveledu_pad i.niveledu_mad"
global educ3 "i.niveledu_pad i.niveledu_mad"
global educ4 "i.niveledu_pad i.niveledu_mad"
global educ5 "i.niveledu_pad i.niveledu_mad"
global twopm1 "i.niveledu_pad i.niveledu_mad"
global twopm2 "i.niveledu_pad i.niveledu_mad"
global twopm3 "i.niveledu_pad i.niveledu_mad"
global twopm4 "i.niveledu_pad i.niveledu_mad"
*/
cd "${E}"

*REVISAR TODAS LAS VARIABLES

timer on 1
use "${D}Emovi2011Ent", clear
* Eliminando observaciones con missing
keep if muestra == 1




****************************************************************************
*** IOP urbano/rural y/o por regiones socioeconómicas***********************
****************************************************************************

** OTROS MODELOS
*****Nivel educativo, regresión lineal (sin pesos)
qui reg escol ${educ1}
estimates store reg2
iop_nb escol ${educ1}
*****Nivel educativo, regresión lineal (sin missing como una categoría aparte)
qui reg escol i.sexo i.indig i.disc i.nherm i.niveledu_mad2 i.niveledu_pad2  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2 [iw=ponderel]
estimates store reg3
iop_nb escol i.sexo i.indig i.disc i.nherm i.niveledu_mad2 i.niveledu_pad2  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca i.cohort2 [iw=ponderel]
*****Nivel educativo, regresión lineal con variable de comparación del hogar en lugar de índice de riqueza
qui reg escol i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.compar_hog_pad i.cohort2 [iw=ponderel]
estimates store reg4
iop_nb escol i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.compar_hog_pad i.cohort2 [iw=ponderel]
*****Nivel educativo, regresión lineal con índice de riqueza al que se le quito el efecto de edad
qui reg escol ${educ4} [iw=ponderel]
estimates store reg5
estimates table reg*, eq(1) star stats(N)

***** Nivel educativo, binomial negativo
qui nbreg escol ${educ1} [iw=ponderel]
estimates store nbreg1
estimates table nbreg*, eq(1) star stats(N)

*****************************************************************************
*Participación laboral probit
qui probit ent_trab i.(sexo  indig cohort2 niveledu_mad niveledu_pad trab_mad ocup_pad lugar14 riq_mca)
estimates store prob1
margins, dydx(*)
mat participacion = r(table)'
estimates table prob*, eq(1) star stats(N)

twopm (inglab i.sexo i.indig i.cohort2  i.niveledu_mad i.niveledu_pad i.trab_mad i.ocup_pad i.lugar14 i.riq_mca) (inglab  i.sexo i.indig i.cohort2 i.niveledu_mad i.niveledu_pad  i.trab_mad i.ocup_pad i.lugar14 i.riq_mca), firstpart(probit) secondpart(regress, log)
estimates store twopm2
estimates table twopm*, eq(1:1) star stats(N)

* Educación Modelo binomial negativo
iop_nb escol i.sexo i.indig i.niveledu_mad i.niveledu_pad  i.trab_mad i.ocup_pad i.lugar14 i.riq_mca i.cohort2, nb
* Educación modelo OLS iop
iop escol niveledumad2-niveledumad4 niveledupad2-niveledupad4 , type(c)
