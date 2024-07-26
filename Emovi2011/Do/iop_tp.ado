* Version 1, 27/03/2016
capture program drop iop_tp
program define iop_tp, rclass
version 14
syntax varlist(numeric ts fv) [if] [in] [iweight pweight aweight][, First(varlist fv) secondlog LOgit Shapley(str) BOOTstrap(integer 0)] 
preserve
marksample muestra
* Dependent and independent variable First part
tokenize `first'
local depvar_first `1'
macro shift
local indepvars_first `*'
* Dependent and independent variable Second part
tokenize `varlist'
local depvar_second `1'
macro shift
local indepvars_second `*'
** First part is probit or logit; probit default
if ("`logit'"!=""){
local regfirst = "logit"
}
else{
local regfirst = "probit"
}
** Second part dependent variable in log or levels; levels default
if ("`secondlog'"!=""){
local log = "log"
local duan = "duan"
}
keep if `muestra'
* Calculating IOp
quietly{
	* Running two part model
	twopm (`depvar_first' `indepvars_first') (`depvar_second' `indepvars_second') [`weight'`exp'] if `muestra', firstpart(`regfirst') secondpart(regress, `log' )
	scalar N = e(N)
	tempvar depvar_hat
	* Fitted values
	predict `depvar_hat' if `muestra', `duan'
	* mld of dependent variable
	mld `depvar_second' [`weight'`exp'] if `muestra'
	scalar mld_1=r(mld)
	* mld of contrafactual distribution
	mld `depvar_hat'  [`weight'`exp'] if `muestra'
	scalar iop_a=r(mld)
	* Variance of depvar and contrafactual
	iop_r2 `depvar_hat' `depvar_second' [`weight' `exp'] if `muestra'
	scalar iop_r2 = r(iop_r2)

	* Relative iop
	scalar iop_r = iop_a/mld_1
	mat iop = iop_a,iop_r,iop_r2
	mat colnames iop = "iop_a" "iop_r" "iop_r2"
	mat rownames iop = "iop"
	mat N_mat = N,N,N
	mat rownames N_mat = "N"
	return scalar iop_a = iop_a
	return scalar iop_r = iop_r
	return scalar iop_r2 = iop_r2
	return scalar N = N
	return matrix iop = iop
	return matrix N_mat = N_mat
	}
	disp "iop_a es:" as result iop_a
	disp "iop_r es:" as result iop_r
	disp "iop_r2 es:" as result iop_r2

	* Shapley decomposition
	if ("`shapley'"!=""){
		set more off
		iop_tp_shapley [`weight'`exp'] if `muestra', firstpart(`depvar_first' `indepvars_first') secondpart(`depvar_second' `indepvars_second') indice(`shapley')
		display _n _n as text"Decomposition (Shapley method)" _n "{hline 30}"
		di as text "Variable" _col(21) "Value" _col(32) "In percentage" _n "{hline 45}"
		local runner=1
		matrix define shapley_norm=e(shapley)
		matrix define shapley_rel_norm=e(shapley_rel)
		foreach var of local indepvars_second {
			di as text "`var'" _col(20) as result %9.6f shapley_norm[1,`runner'] _col(35) as result %5.2f 100*shapley_rel_norm[1,`runner'] "%"
			local runner=`runner'+1
			}
		di as text "{hline 45}"
		di as text "TOTAL" _col(20) as result %9.6f e(total)  _col(35) "100.00%"
		di as text "{hline 45}"
		}
	if(`bootstrap' & `bootstrap'>0 & "`shapley'"==""){
		iop_bootstrap_tp `depvar_second' `indepvars_second', nrep(`bootstrap') first(`depvar_first' `indepvars_first') `logit' `secondlog'
		matrix SD_iop = r(sd_iop_a), r(sd_iop_r), r(sd_iop_r2)
		mat colnames SD_iop = "iop_a" "iop_r" "iop_r2"
		mat rownames SD_iop = "Bootstrap SD"
		return scalar sd_iop_a = r(sd_iop_a)
		return scalar sd_iop_r = r(sd_iop_r)
		return scalar sd_iop_r2 = r(sd_iop_r2)
		return matrix SD_iop = SD_iop
		}
		
end 

*************************
*** Programas auxiliares*
*************************
***************************************************************
*** calcula mean logaritmic deviation**************************
***************************************************************
capture program drop mld
program define mld, rclass
version 14
syntax varlist(max=1) [if] [in] [iweight fweight]
marksample muestra2
qui{
sum `varlist' [`weight'`exp'] if `muestra2'
local mean=r(mean)
tempvar mld
gen `mld'=ln(r(mean)/`varlist') if `muestra2'
sum `mld' [`weight'`exp'] if `muestra2'
local MLD=r(mean)
return scalar mld =  `MLD'
}
end
********************************************************
*** calcula IOP relative with variance******************
********************************************************
capture program drop iop_r2
program define iop_r2, rclass
version 14
syntax varlist(max=2) [if] [in] [iweight fweight]
preserve
marksample muestra2
tokenize `varlist'
qui{
keep if `muestra2'
sum `1' [`weight'`exp']
local sd1=r(sd)
sum `2' [`weight'`exp']
local sd2=r(sd)
scalar iop_r2 = (`sd1'/`sd2')^2
return scalar iop_r2 = iop_r2
}
end
***************************************************************
*** Descomposición de shapley**********************************
***************************************************************
capture program drop iop_tp_shapley
program define iop_tp_shapley , eclass 
version 14
syntax [anything] [iweight fweight] [if] [in], SECONDpart(varlist fv) FIRSTpart(varlist fv) indice(str)
preserve
marksample muestra3
** Dependent and Independent variables first part
tokenize `firstpart'
local depvar_first `1'
macro shift
local indepvar_first = "`*'"
** Dependent and Independent variables second part
tokenize `secondpart'
local depvar_second `1'
macro shift
local indepvar_second_iop = "`*'"
local indepvar_second = subinstr("`*'","i.","",.)

* Differences in indep. variables first and second part
local FDS: list indepvar_first - indepvar_second_iop
* Common indep. variables first and second part
local FIS: list indepvar_first & indepvar_second_iop
* indice to be decomposed
if ("`indice'"!="iop_r" & "`indice'"!="iop_r2" ){
local indice = "iop_a"
}
quietly{
tempfile orgdb
save `orgdb'
keep if `muestra3'
tempfile usedb
save `usedb'

local K=wordcount("`indepvar_second'")
drop _all
set obs 2
foreach var of local indepvar_second {
	gen `var'=1 in 1/1
	replace `var'=0 in 2/2
	}
fillin `indepvar_second'
drop _fillin
gen result=.
mkmat `indepvar_second' result , matrix(combinations) 
matrix list combinations
*restore
use `usedb', clear
local numcomb=rowsof(combinations)
local numcols=colsof(combinations)
//di as error "(542)I have to perform `numcomb' regressions"
matrix combinations[1,`numcols']=0
forvalues i=2/`numcomb'{
local thisvars=""
local thisvars_first="`FDS'"
	foreach var of local indepvar_second_iop{
		matrix mymat=combinations[`i',"`=subinstr(`"`var'"',`"i."',`""',.)'"]
		local test=mymat[1,1]
		if(`test'==1){
			local thisvars="`thisvars' `var'"
			local thisvars_first="`thisvars_first' `var'"
			}
		}
	//di "`thisvars'"
	iop_tp `depvar_second' `thisvars' [`weight'`exp'], first(`depvar_first' `thisvars_first')
	matrix combinations[`i',`numcols']=r(`indice')
	}
	*preserve
	drop _all
	matrix list combinations
	svmat combinations,names(col)
	/* Start computing the shapley value*/
	sum result
	local full=r(max)
egen t=rowtotal(`indepvar_second')
replace t=t-1
gen _weight = round(exp(lnfactorial(abs(t))),1) * round(exp(lnfactorial(`K'-abs(t)-1)),1)
drop t


tempvar file1
save `file1', replace
matrix newshapley=[.]
foreach var of local indepvar_second{
	local i=subinstr("`indepvar_second'","`var'","",1)
	reshape wide result _weight, i(`i') j(`var')
	gen _diff = result1-result0
	sum _diff [iweight = _weight1]
	use `file1',clear
	
	matrix newshapley = (newshapley \ r(mean))
}
matrix newshapley = newshapley[2...,1]
matrix shapley=newshapley'
matrix shapley_rel=shapley/`full'
matrix result=(shapley\shapley_rel)
mat colnames shapley_rel = `indepvar_second'
use `orgdb', clear

}
ereturn matrix shapley shapley
ereturn matrix shapley_rel shapley_rel
ereturn scalar total=`full'
end

********************************************************
********* BOOTSTRAPING**********************************
********************************************************
capture program drop iop_bootstrap_tp
program define iop_bootstrap_tp , rclass 
version 14
syntax varlist(numeric fv) [iweight fweight] [if] [in][, Nrep(integer 50) First(varlist fv) secondlog LOgit]
marksample muestra4
** Begin bootstrap
noisily di as text "Bootstrapping..." _continue
qui{
tempfile orgdb
save `orgdb'
keep if `muestra4'
tempfile usedb
save `usedb'
capture mat drop estimates
forvalues i=1/`nrep'{
	preserve
	qui: keep if `muestra4'
	bsample
		iop_tp `varlist' if `muestra4' [`weight'`exp'], first(`first') `secondlog' `logit'
		mat estimates = nullmat(estimates) \ r(iop_a),r(iop_r),r(iop_r2)
	restore	
}	// end loop through iterations of bootstrap
matrix colnames estimates = "_est_iop_a"  "_est_iop_r" "_est_iop_r2"
svmat estimates, names(matcol)
local stats iop_a iop_r iop_r2
foreach stat of local stats{
	sum estimates_est_`stat'
	local BS_sd_`stat'=r(sd)
}
drop estimates_est_*
noisily di as result "done!" _n	
use `orgdb', clear
}
foreach stat of local stats{
	disp as text "Bootstrap S.E. of `stat':" as result `BS_sd_`stat''
}
return scalar sd_iop_a = `BS_sd_iop_a'
return scalar sd_iop_r = `BS_sd_iop_r'
return scalar sd_iop_r2 = `BS_sd_iop_r2'
end



