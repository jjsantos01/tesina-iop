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
global G "${D}graficas\"
global G2 "${A}dropbox\tesina\entrega 6\figuras\"
adopath + "${D}do\"

import excel using "${T}Resultados_iop.xlsx", sheet(grafica_iop) first clear
drop if cohorte=="" | cohorte=="Todos"
encode cohorte, gen(coh)
encode sex, gen(sexo)
drop cohorte sex
reshape wide iop*, i(coh) j(sexo)
foreach x of varlist *1{
label var `x' "Hombres"
}
foreach x of varlist *2{
label var `x' "Mujeres"
}
foreach x of varlist *3{
label var `x' "Total"
}
* iop escol
scatter iop_escol* coh, connect(l l l) msymbol(o d t) msize(medlarge medlarge medlarge) ///
	lp("-" "_" "-.-") lw(medthick medthick medthick) graphregion(fcolor(white)) subtitle("Años de escolaridad") ///
	ytit("Índice desigualdad de oportunidades") legend(col(1) pos(6) ring(0)) xscale(reverse) name(iop_escol, replace) nodraw
* iop inglab tp
scatter iop_inglab_tp* coh, connect(l l l) msymbol(o d t) msize(medlarge medlarge medlarge) ///
	lp("-" "_" "-.-") lw(medthick medthick medthick) graphregion(fcolor(white)) subtitle("Ingreso laboral TP") ///
	 xscale(reverse) yscale(off) legend(off) name(iop_inglab_tp, replace) nodraw
* iop inglab pos
scatter iop_inglab_pos* coh, connect(l l l) msymbol(o d t) msize(medlarge medlarge medlarge) ///
	lp("-" "_" "-.-") lw(medthick medthick medthick) graphregion(fcolor(white)) subtitle("Ingreso laboral >0") ///
	xscale(reverse) yscale(off) legend(off) name(iop_inglab_pos, replace) nodraw
	
graph combine iop_escol iop_inglab_tp iop_inglab_pos, row(1) ycomm xcom graphregion(fcolor(white)) ///
	name(iop_coh_sex, replace) saving("${G}iop_coh_sex", replace)
graph export "${G}iop_coh_sex.pdf", replace 
graph export "${G2}iop_coh_sex.pdf", replace 
