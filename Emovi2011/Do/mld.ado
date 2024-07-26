capture program drop mld
program define mld, rclass
version 14
syntax varlist(max=1) [if] [in] [iweight fweight]
marksample muestra
qui{
sum `varlist' [`weight'`exp'] if `muestra'
local mean=r(mean)
tempvar mld
gen `mld'=ln(r(mean)/`varlist') if `muestra'
sum `mld' [`weight'`exp'] if `muestra'
local MLD=r(mean)
return scalar mld =  `MLD'
}
disp "`MLD'"
end
