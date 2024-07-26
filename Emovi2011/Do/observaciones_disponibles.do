global E "E:\Datos\emovi\2011\"
global D "E:\dropbox\tesina\emovi2011\"
global T "E:\dropbox\tesina\emovi2011\Tablas\"

cd "${E}"

foreach mod in educ ing1 ing2 pobr ocup{
import excel "${T}Listado variables Emovi 2011.xlsx", clear sheet(lista) first

levelsof mod_`mod', local(loc_`mod') clean
tempfile file_`mod'
save `file_`mod''

use `loc_`mod'' using "${E}Emovi2011Ent", clear

global names
capture mat drop miss
foreach x of local loc_`mod'{
qui count if `x'==.
mat miss = (nullmat(miss),r(N))
global names "$names miss`x'"
}
mat colnames miss = $names
clear
svmat miss, n(col)
gen a=1
reshape long miss, i(a) j(pregunta) string
merge 1:1 pregunta using `file_`mod'', nogen keep(3) keepusing(imp_`mod')
gsort -imp_`mod' miss
mkmat miss, rown(pregunta)

use `loc_`mod'' using "${E}Emovi2011Ent", clear

global varmiss
global nvarmiss
capture matrix drop obs_disp
foreach x in `:rown miss'{
global varmiss $varmiss `x'
global nvarmiss $nvarmiss disp`x'
egen miss`x' = rmiss2($varmiss)
qui count if miss`x'==0
mat obs_disp = nullmat(obs_disp),r(N)
}
mat colnames obs_disp = $nvarmiss

clear
svmat obs_disp, n(col)
gen a=1
reshape long disp, i(a) j(pregunta) string
merge 1:1 pregunta using `file_`mod'', nogen keep(3) keepusing(imp_`mod' variable)
drop a
gsort -imp_`mod' -disp
order pregunta variable disp
export excel using "${T}obs_disp.xlsx", first(variable) sheet(`mod')  sheetreplace
}
* 
