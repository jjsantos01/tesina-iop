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

global rep = 100

global educ1 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Todas las variables
global educ2 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte
global educ3 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin sexo
global educ4 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte o sexo
global educ5 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca_edad" // con índice de riqueza teniendo en cuenta la edad
global twopm1 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Todas las variables
global twopm2 "i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte
global twopm3 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin sexo
global twopm4 "i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca" // Sin cohorte ni sexo

cd "${E}"

timer on 1
use "${D}Emovi2011Ent", clear
* Eliminando observaciones con missing
keep if muestra == 1

		****************************************************
		******REGRESIONES***********************************
		****************************************************

* Nivel educativo, regresión lineal
qui reg escol ${educ1} [iw=ponderel]
estimates store escol
* Two part, participación e ingreso laboral
qui twopm (inglab $twopm1) (inglab $twopm1) [iw=ponderel] if inglab!=. , firstpart(probit) secondpart(regress, log)
estimates store inglab1
* Two part, participación e ingreso laboral x hora
qui twopm (ing_hr $twopm1) (ing_hr $twopm1) [iw=ponderel] if ing_hr!=., firstpart(probit) secondpart(regress, log)
estimates store ing_hr
esttab escol inglab1 ing_hr using "${T}regresiones", cells(b(fmt(2) star) ) starlevels(* 0.1 ** 0.05 *** 0.01) nonum ///
 drop("5.niv*") replace unstack csv plain

		*******************************************************
		**** CÁLCULO IOP CON S.E. BOOTSTRAPPING*****************
		********************************************************

**~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~Todas cohortes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Educación****
iop_nb escol ${educ1} [iw=ponderel], bootstrap(${rep})
mat iop_educ = r(iop)\r(SD_iop)\r(N_mat)
mat roweq iop_educ = "escol"
** Inglab****
iop_tp inglab ${twopm1} [iw=ponderel], first(inglab ${twopm1}) bootstrap(${rep})
mat iop_inglab = r(iop)\r(SD_iop)\r(N_mat)
mat roweq iop_inglab = "inglab"
** Inglab>0***
iop_nb inglab ${twopm1} [iw=ponderel] if inglab>0, bootstrap(${rep})
mat iop_inglab2 = r(iop)\r(SD_iop)\r(N_mat)
mat roweq iop_inglab2 = "inglab2"
** Ing x hra****
iop_tp ing_hr ${twopm1} [iw=ponderel], first(ing_hr ${twopm1}) bootstrap(${rep})
mat iop_ing_hr = r(iop)\r(SD_iop)\r(N_mat)
mat roweq iop_ing_hr = "ing_hr"
mat iop_total = iop_educ\iop_inglab\iop_inglab2\iop_ing_hr

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~ IOP por cohortes de edad~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set more off
forvalues i=1/4{
	* Educación
	qui iop_nb escol ${educ2} if cohort2==`i' [iw=ponderel], bootstrap(${rep})
	mat iop_escol_coh`i' = r(iop)\r(SD_iop)\r(N_mat)
	mat coleq iop_escol_coh`i' = "coh `i'"
	mat roweq iop_escol_coh`i' = "escol"
	* Inglab
	foreach x in inglab ing_hr{
		qui iop_tp `x' ${twopm2} [iw=ponderel] if cohort2==`i', first(`x' ${twopm2}) bootstrap(${rep})
		mat iop_`x'_coh`i' = r(iop)\r(SD_iop)\r(N_mat)
		mat coleq iop_`x'_coh`i' = "coh `i'"
		mat roweq iop_`x'_coh`i' = "`x'"
	}
	* Inglab>0
	qui iop_nb inglab ${twopm2} [iw=ponderel] if inglab>0 & cohort2==`i', bootstrap(${rep})
	mat iop_inglab2_coh`i' = r(iop)\r(SD_iop)\r(N_mat)
	mat coleq iop_inglab2_coh`i' = "coh `i'"
	mat roweq iop_inglab2_coh`i' = "inglab2"
	* todas
	mat iop_coh`i' = iop_escol_coh`i'\iop_inglab_coh`i'\iop_inglab2_coh`i'\iop_ing_hr_coh`i'
	}
mat iop_coh = iop_coh1, iop_coh2, iop_coh3, iop_coh4
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~ IOP por sexo y cohorte~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set more off
forvalues i=0/1{
	*** Por sexo
	* Escol
	qui iop_nb escol ${educ3} if sexo==`i' [iw=ponderel], bootstrap(${rep})
	mat iop_escol_sex`i' = r(iop)\r(SD_iop)\r(N_mat)
	mat coleq iop_escol_sex`i' = "sex `i'"
	mat roweq iop_escol_sex`i' = "escol"
	* Inglab
	foreach x in inglab ing_hr{
		qui iop_tp `x' ${twopm3} [iw=ponderel] if sexo==`i', first(`x' ${twopm3}) bootstrap(${rep})
		mat iop_`x'_sex`i' = r(iop)\r(SD_iop)\r(N_mat)
		mat coleq iop_`x'_sex`i' = "sex `i'"
		mat roweq iop_`x'_sex`i' = "`x'"
	}
	* Inglab>0
	qui iop_nb inglab ${twopm2} [iw=ponderel] if inglab>0 & sexo==`i', bootstrap(${rep})
	mat iop_inglab2_sex`i' = r(iop)\r(SD_iop)\r(N_mat)
	mat coleq iop_inglab2_sex`i' = "sex `i'"
	mat roweq iop_inglab2_sex`i' = "inglab2"
	
	mat iop_sex`i' = iop_escol_sex`i'\iop_inglab_sex`i'\iop_inglab2_sex`i'\iop_ing_hr_sex`i'
	
	*** Por sexo y cohorte
	forvalues j=1/4{
		* Escol
		qui iop_nb escol ${educ4} if cohort2==`j' & sexo==`i' [iw=ponderel], bootstrap(${rep})
		mat iop_escol_`j'_`i' = r(iop)\r(SD_iop)\r(N_mat)
		mat coleq iop_escol_`j'_`i' = "coh `j' sex `i'"
		mat roweq iop_escol_`j'_`i' = "escol"
		* Inglab e ing_hr
	foreach x in inglab ing_hr{
		qui iop_tp `x' ${twopm4} [iw=ponderel] if cohort2==`j' & sexo==`i', first(`x' ${twopm4}) bootstrap(${rep})
		mat iop_`x'_`j'_`i' = r(iop)\r(SD_iop)\r(N_mat)
		mat coleq iop_`x'_`j'_`i' = "coh `j' sex `i'"
		mat roweq iop_`x'_`j'_`i' = "`x'"
		}
		* Inglab>0
		qui iop_nb inglab ${twopm2} [iw=ponderel] if inglab>0 & cohort2==`j' & sexo==`i', bootstrap(${rep})
		mat iop_inglab2_`j'_`i' = r(iop)\r(SD_iop)\r(N_mat)
		mat coleq iop_inglab2_`j'_`i' = "coh `j' sex `i'"
		mat roweq iop_inglab2_`j'_`i' = "inglab2"
		* todas
		mat iop_`j'_`i' = iop_escol_`j'_`i'\iop_inglab_`j'_`i'\iop_inglab2_`j'_`i'\iop_ing_hr_`j'_`i'
}
}
mat iop_coh_sex = iop_sex0,iop_1_0,iop_2_0,iop_3_0,iop_4_0,iop_sex1,iop_1_1,iop_2_1,iop_3_1,iop_4_1
** Exportando resultado
* iop_r2
mat iop = iop_total,iop_coh, iop_coh_sex
esttab matrix(iop,fmt(3) transpose) using "${T}iop_r2", keep(*iop_r2) nonum plain replace csv noobs
*iop_a
mat iop = iop_total,iop_coh, iop_coh_sex
esttab matrix(iop,fmt(3) transpose) using "${T}iop_a", keep(*iop_a) nonum plain replace csv noobs

			**********************************
			**** DESCOMPOSICIÓN***************
			**********************************
**~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~Todas cohortes~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*** Educación
iop_nb escol ${educ1} [iw=ponderel], shapley(iop_r2)
mat decomp_escol = r(iop_r2)\100*e(shapley_rel)'
mat roweq decomp_escol = "escol"
mat coleq decomp_escol = "Total"
**** Ingreso, modelo two part
iop_tp inglab ${twopm1} [iw=ponderel], first(inglab ${twopm1}) shapley(iop_r2)
mat decomp_inglab = r(iop_r2)\100*e(shapley_rel)'
mat roweq decomp_inglab = "inglab"
mat coleq decomp_inglab = "Total"
**** Ingreso por hora, modelo two part
iop_tp ing_hr ${twopm1} [iw=ponderel], first(ing_hr ${twopm1}) shapley(iop_r2)
mat decomp_ing_hr = r(iop_r2)\100*e(shapley_rel)'
mat roweq decomp_ing_hr = "ing_hr"
mat coleq decomp_ing_hr = "Total"


mat decomp_total = decomp_escol\decomp_inglab\decomp_ing_hr
**~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~descomposición por cohortes~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set more off
forvalues i=1/4{
	* escol
	qui iop_nb escol ${educ2} if cohort2==`i' [iw=ponderel], shapley(iop_r2)
	mat decomp_escol_coh`i' = r(iop_r2)\100*e(shapley_rel)'\.
	mat coleq decomp_escol_coh`i' = "coh `i'"
	mat roweq decomp_escol_coh`i' = "escol"
	* inglab e ingreso por hora
	foreach x in inglab ing_hr{
		qui iop_tp `x' ${twopm2} [iw=ponderel] if cohort2==`i', first(`x' ${twopm2}) shapley(iop_r2)
		mat decomp_`x'_coh`i' = r(iop_r2)\100*e(shapley_rel)'\.
		mat coleq decomp_`x'_coh`i' = "coh `i'"
		mat roweq decomp_`x'_coh`i' = "`x'"
	}
	mat decomp_coh`i' = decomp_escol_coh`i'\decomp_inglab_coh`i'\decomp_ing_hr_coh`i'
	}
mat decomp_coh = decomp_coh1, decomp_coh2, decomp_coh3, decomp_coh4
**~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~Descomposición por sexo~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set more off
forvalues i=0/1{
	* Escol
	qui iop_nb escol ${educ3} if sexo==`i' [iw=ponderel], shapley(iop_r2)
	mat decomp_escol_sex`i' = r(iop_r2)\100*e(shapley_rel)'\.
	mat coleq decomp_escol_sex`i' = "sex `i'"
	mat roweq decomp_escol_sex`i' = "escol"
	* Inglab e ing x hr
	foreach x in inglab ing_hr{
		qui iop_tp `x' ${twopm3} [iw=ponderel] if sexo==`i', first(`x' ${twopm3}) shapley(iop_r2)
		mat decomp_`x'_sex`i' = r(iop_r2)\100*e(shapley_rel)'\.
		mat coleq decomp_`x'_sex`i' = "sex `i'"
		mat roweq decomp_`x'_sex`i' = "`x'"
	}
	mat decomp_sex`i' = decomp_escol_sex`i'\decomp_inglab_sex`i'\decomp_ing_hr_sex`i'
	}
mat decomp_sex = decomp_sex0, decomp_sex1
** Exportando resultado
set more off
foreach x in total coh sex{
	clear
	svmat decomp_`x'
	gen roweq=""
	local h = 1
	foreach y in `:roweq decomp_`x''{
		qui replace roweq = "`y'" in `h++'
	}
	gen rown=""
	local h = 1
	foreach y in `:rown decomp_`x''{
		qui replace rown = "`y'" in `h++'
		}
	foreach z in escol inglab ing_hr{
		preserve
		keep if roweq =="`z'"
		tempfile decomp_`x'_`z'
		save `decomp_`x'_`z''
		restore
	}
}
* Escol
use `decomp_total_escol', clear
gen orden = _n 
merge 1:1 roweq rown using `decomp_coh_escol', nogen
merge 1:1 roweq rown using `decomp_sex_escol', nogen
reshape wide decomp*, i(orden rown) j(roweq) string
tempfile decomp_escol
save `decomp_escol'
* Inglab
use `decomp_total_inglab', clear
merge 1:1 roweq rown using `decomp_coh_inglab', nogen
merge 1:1 roweq rown using `decomp_sex_inglab', nogen
reshape wide decomp*, i(rown) j(roweq) string
tempfile decomp_inglab
save `decomp_inglab'
* Ing x hr
use `decomp_total_ing_hr', clear
merge 1:1 roweq rown using `decomp_coh_ing_hr', nogen
merge 1:1 roweq rown using `decomp_sex_ing_hr', nogen
reshape wide decomp*, i(rown) j(roweq) string
* todos
merge 1:1 rown using `decomp_escol', nogen
merge 1:1 rown using `decomp_inglab', nogen
sort orden
drop orden
order rown *escol *inglab
export excel using "${T}decomp.xlsx", first(var) replace
timer off 1
timer list 1
