clear all
set pagesize 10000
global E "E:\Datos\emovi\2011\"
global D "E:\dropbox\tesina\emovi2011\"
global T "E:\dropbox\tesina\emovi2011\tablas\"
global indep "sexo indig disc nherm niveledu_mad niveledu_pad  trab_mad clas_ocup_pad lugar14 riq_mca" // Todas las variables

cd "${E}"

use "${D}Emovi2011Ent", clear
* Eliminando observaciones con missing
keep if muestra == 1
* características de la muestra

******************************************************************************
* salario y años de educación segun variables de circunstancias, por cohortes*
******************************************************************************
global circuns1 sexo lugar14 indig niveledu_mad niveledu_pad riq_mca/*ocup_pad*/
global circuns2 clas_ocup_pad clas_ocup_mad trab_pad trab_mad
global ventaja inglab escol /*ing_hr*/ 
global ventaja2 inglab ent_trab escol

clear matrix
local inglab "& inglab>0"
foreach x of global circuns1 { // loop de variables de circunstancia
	forvalues i=4(-1)1{ // loop para cohorte
		foreach y of global ventaja { // loop de variables de ventaja
			qui estpost tabstat `y' if cohort2==`i' ``y'' [aw=ponderel], by(`x') stats(mean) // estadístico por cohorte 
			mat m`i'`x'`y' = e(mean)' //,e(count)', e(sd)', e(p10)', e(p50)', e(p90)', e(min)', e(max)', 
			mat coleq m`i'`x'`y' = "`y'`i'"
			qui reg `y' [iw=ponderel] if `y'!=. & cohort2==`i' ``y'' // Número de obs por cohores
			mat N`i'`y' = e(N)
		}
		* Matriz que contiene las ventajas para una cohorte
		local l:all matrices "m`i'`x'*"
		mat c_`x'`i' = `:subinstr local l " " ",", all' 
	}
	* Porcentaje que tiene circunstancia x
	foreach y of global ventaja{
		qui estpost tabstat `y' if muestra==1 ``y'' [aw=ponderel], by(`x') stats(mean) // estadístico por circunstancoa para todas las cohortes
		mat mean`x'`y' = e(mean)'
		mat coleq mean`x'`y' = "`y'"
		* Contando el total de observaciones
		qui reg `y' [iw=ponderel] if muestra==1 & `y'!=. ``y''
		scalar n`y'=e(N)
	}
	* matriz que contiene las ventajas para todas las cohortes
	local c:all matrices "c_`x'*"
	*Matriz que contiene promedio de circunstancia x para toda cohorte
	local l2: all matrices "mean`x'*"
	qui estpost tab `x' [iw=ponderel]
	mat `x'=e(pct)' , `:subinstr local l2 " " ",", all', `:subinstr local c " " ",", all'
	mat roweq `x' = "`x'"
	* Matriz que contiene todas las ventajas para todas las cohortes para todas las circunstacias
	mat descr= (nullmat(descr) \ `x')
}
* matriz que contiene el número de obsrevaciones por cohorte
local l:all matrices "N`i'*"
local l2: all scalars "n*"
qui reg escol [iw=ponderel]
mat N = e(N),`:subinstr local l2 " " ",", all', `:subinstr local l " " ",", all'
mat roweq N = "N"
mat descr = descr\N
esttab mat(descr, fmt(%5.1f)) using "${T}descriptivas", drop(Total missing) replace plain csv
esttab mat(descr, fmt(%5.1f)) using "${T}descriptivas", keep(Total) append plain csv
****************************************************************
* salario y años de educación segun ocupación de padre y madre
****************************************************************
clear matrix
local inglab "if inglab>0"
foreach x of global circuns2{	
	foreach y of global ventaja2{
		qui estpost tabstat `y' ``y'' [aw=ponderel], by(`x') stats(mean sd p10 p50 p90 min max N)
		mat `x'`y' = e(mean)' //,e(count)', e(sd)', e(p10)', e(p50)', e(p90)', e(min)', e(max)', 
		mat coleq `x'`y' = "`y'`i'"
		qui reg `x' [iw=ponderel] ``y''
		mat N`i'`y' = e(N)
	}
	local c:all matrices "`x'*"
	mat `x'= `:subinstr local c " " ",", all'
	qui estpost tab `x' [iw=ponderel]
	mat `x'=e(pct)',`x'
	mat roweq `x' = "`x'"
	mat ocup= (nullmat(ocup) \ `x')
}
local l:all matrices "N`i'*"
mat N = `:subinstr local l " " ",", all'
qui reg escol [iw=ponderel] if muestra==1
mat N = e(N),N
mat roweq N = "N"
mat ocup = ocup\N
esttab mat(ocup, fmt(%5.2f)) using "${T}ocup_padres", replace plain csv
**********************************************************************+
************************************************************************

* verificando diferencia entre observaciones incluidas y excluidas
use "${D}Emovi2011Ent", clear

foreach x of global indep{
	qui levelsof `x', local(l_`x')
	if (`:list sizeof l_`x''>2){
		foreach y of local l_`x'{
			local ttable1 `ttable1' `x'_`y'
			qui gen `x'_`y' = (`x'==`y') if `x'!=.
		}
	}
	else{
		local ttable2 `ttable2' `x'
	}
}
local ttable `ttable2' `ttable1'
logout, save("${T}ttest_miss") excel replace: ttable2 escol inglab `ttable', by(muestra)
drop `ttable1'
disp "`ttable'"



