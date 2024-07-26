use "${E}Emovi2011Ent", clear
keep if muestra == 1
preserve
			local indepvars = "niveledu_mad niveledu_pad"
			local depvars = "escol"
			local stat = "fg1r"
			local K=wordcount("`indepvars'")
			drop _all
			set obs 2

			foreach var of local indepvars {
				gen `var'=1 in 1/1
				replace `var'=0 in 2/2
				}
				
			fillin `indepvars'
			drop _fillin
			gen result=.
			mkmat `indepvars' result , matrix(combinations) 
			matrix list combinations
		restore

		local numcomb=rowsof(combinations)
		local numcols=colsof(combinations)

		//di as error "(542)I have to perform `numcomb' regressions"
		matrix combinations[1,`numcols']=0
		forvalues i=2/`numcomb'{
		local thisvars=""
			foreach var of local indepvars{
				matrix mymat=combinations[`i',"`var'"]
				local test=mymat[1,1]
				
				if(`test'==1){
					local thisvars="`thisvars' `var'"
					}
				}
			//di "`thisvars'"
			di "`depvars' `thisvars'"
			iop `depvars' `thisvars' [`weight'`exp'], type(c)
			matrix combinations[`i',`numcols']=r(`stat')
			}
			preserve
			drop _all
			matrix list combinations
			svmat combinations,names(col)
			/* Start computing the shapley value*/
			sum result
			local full=r(max)
			
		egen t=rowtotal(`indepvars')
replace t=t-1
gen _weight = round(exp(lnfactorial(abs(t))),1) * round(exp(lnfactorial(`K'-abs(t)-1)),1)
drop t


tempvar file1
save `file1', replace

matrix newshapley=[.]
foreach var of local indepvars{
	local i=subinstr("`indepvars'","`var'","",1)
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

