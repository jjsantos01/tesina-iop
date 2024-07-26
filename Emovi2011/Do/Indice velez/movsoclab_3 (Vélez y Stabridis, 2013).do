capture log close;
#delimit;
set more off;

************************************************************************************
CODIGO PARA CONSTRUIR ÍNDICES DE RIQUEZA
AUTOR: ROBERTO VELEZ Y OMAR STABRIDIS 
PROYECTO: "MOVILIDAD SOCIAL POR TIPO DE EMPLEO EN MEXICO"
Código escrito por O. Stabridis
************************************************************************************;
*==================================================================================*;
gl data= "C:\EMOVI\DATA";
gl bases= "C:\EMOVI\BASES";
gl tempdat ="C:\EMOVI\TEMP_DATA";
gl logs = "C:\EMOVI\LOGS";
gl outreg ="C:\EMOVI\OUTREG";
gl cleandat = "C:\EMOVI\CLEAN_DATA";
gl code = "C:\EMOVI\CODE";
gl graphs = "C:\EMOVI\GRAPHS";
*==================================================================================*;
log using "$logs\ems1_3.log",replace;


use "$tempdat\muestra_emovi11final.dta", clear;

mca  estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad 
baño_pad elect_pad serdom_pe_pad  telf_pad loccom_pad terreno_pad casavac_pad 
depa_alq_pad accion_pad ahorr_pad cuenban_pad anim_pad maq_agr_pad , method(burt);

mca  estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad 
baño_pad elect_pad telf_pad loccom_pad  , method(burt);


***FINAL****;
gen pad=1 if estuf_pad!=. & lavad_pad!=. &  refri_pad!=. &  tv_pad!=. &  boiler_pad!=. &  
aspi_pad!=. &  tosta_pad!=. &  aguaent_pad!=. & baño_pad!=. &  elect_pad!=. &  telf_pad!=. ; 
mca  estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad 
baño_pad elect_pad telf_pad if pad==1  , method(burt); 


***CON ESTA COMBINACIÓN DE VARIABLES EXPLICAMOS 91% DE LA INERCIA*****;
mca  estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad
baño_pad elect_pad , method(burt); 


predict pad_c1 if pad==1;
 
xtile pad_prel1 =pad_c1, nq(5);
**el primer quintil es el más rico y el quinto el más pobre*****;
gen pad_iriq=0 if pad_prel1==5;
replace pad_iriq=1 if pad_prel1==4;
replace pad_iriq=2 if pad_prel1==3;
replace pad_iriq=3 if pad_prel1==2;
replace pad_iriq=4 if pad_prel1==1;

*****generando la clase de acuerdo al índice de riqueza*****;
gen pad_classoc=0 if pad_iriq==0;
replace pad_classoc=1 if pad_iriq>0 & pad_iriq<4;
replace pad_classoc=2 if pad_iriq==4;

gen pad_pob=1 if pad_classoc==0;
replace pad_pob=0 if pad_classoc!=0 & pad_classoc!=.;
gen pad_cmed=1 if pad_classoc==1;
replace pad_cmed=0 if pad_classoc!=1 & pad_classoc!=.;
gen pad_ric=1 if pad_classoc==2;
replace pad_ric=0 if pad_classoc!=2 & pad_classoc!=.;

label var pad_c1       "1era. dim. ind. de riqueza del padre";
label var pad_iriq     "Quintiles de riqueza del padre";
label var pad_classoc  "Clase social del padre";

label var pad_pob      "Padre es pobre";
label var pad_cmed     "Padre es de clase media";
label var pad_ric      "Padre es rico";

label define pad_iriq 0 "Quintil 1" 1 "Quintil 2" 2 "Quintil 3" 3 "Quintil 4" 4 "Quintil 5";
																																																																																																																																																																												
label values pad_iriq pad_iriq;
label define pad_classoc 0 "Pobre" 1 "Clase media" 2 "Rico";
label values pad_classoc pad_classoc;

save "$cleandat\emovi11final.dta", replace;


********CONSTRUYENDO EL ÍNDICE DE RIQUEZA PARA EL ENTREVISTADO***;
mca loccom terreno casavac depa_alq anim maq_agr negoc compu estuf lavad refri dvd tv boiler cel 
aspi microon tosta internet aguaent baño elect  telf tvcable  accion ahorr 
cuenban tcredito, method(burt);


***FINAL****;
gen ent=1 if compu!=. & lavad!=. & refri!=. & dvd!=. & boiler!=. & cel!=. & aspi!=. &
microon!=. &  tosta!=. &  internet!=. & baño!=. & telf!=. & tvcable!=. & ahorr!=. & 
cuenban!=. &  tcredito!=.; 

mca  compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if ent==1, method(burt);

predict ent_c1 if ent==1;
 
xtile ent_prel1 =ent_c1, nq(5);
**el primer quintil es el más rico y el quinto el más pobre*****;
gen ent_iriq=0 if ent_prel1==5;
replace ent_iriq=1 if ent_prel1==4;
replace ent_iriq=2 if ent_prel1==3;
replace ent_iriq=3 if ent_prel1==2;
replace ent_iriq=4 if ent_prel1==1;

*****generando la clase de acuerdo al índice de riqueza*****;
gen ent_classoc=0 if ent_iriq==0;
replace ent_classoc=1 if ent_iriq>0 & ent_iriq<4;
replace ent_classoc=2 if ent_iriq==4;

gen ent_pob=1 if ent_classoc==0;
replace ent_pob=0 if ent_classoc!=0 & ent_classoc!=.;
gen ent_cmed=1 if ent_classoc==1;
replace ent_cmed=0 if ent_classoc!=1 & ent_classoc!=.;
gen ent_ric=1 if ent_classoc==2;
replace ent_ric=0 if ent_classoc!=2 & ent_classoc!=.;

label var ent_c1       "1era. dim. ind. de riqueza del entrevistado";
label var ent_iriq     "Quintiles de riqueza del entrevistado";
label var ent_classoc  "Clase social del entrevistado";

label var ent_pob      "Entrevistado es pobre";
label var ent_cmed     "Entrevistado es de clase media";
label var ent_ric      "Entrevistado es rico";

label define ent_iriq 0 "Quintil 1" 1 "Quintil 2" 2 "Quintil 3" 3 "Quintil 4" 4 "Quintil 5";
label values ent_iriq ent_iriq;
label define ent_classoc 0 "Pobre" 1 "Clase media" 2 "Rico";
label values ent_classoc ent_classoc;

gen movilidad=2 if ent_iriq>pad_iriq & ent_iriq!=. & pad_iriq!=.;
replace movilidad=1 if ent_iriq==pad_iriq & ent_iriq!=. & pad_iriq!=.;
replace movilidad=0 if ent_iriq<pad_iriq & ent_iriq!=. & pad_iriq!=.;

label var movilidad "Movilidad intergeneracional";
label define movilidad 0 "Movilidad negativa" 1 "Sin movilidad" 2 "Movilidad positiva";
label values movilidad movilidad;
gen car_empl=0 if empr==1;
replace car_empl=1 if autoemp==1;
replace car_empl=2 if empl==1;

gen car_empl_pad=0 if empr_pad==1;
replace car_empl_pad=1 if autoemp_pad==1;
replace car_empl_pad=2 if empl_pad==1;


label var car_empl "Carac. del empleo del entrevistado";
label define car_empl 0 "Empresario" 1 "Autoempleado" 2 "Empleado";
label values car_empl car_empl;

label var car_empl_pad "Carac. del empleo del padre";
label define car_empl_pad 0 "Empresario" 1 "Autoempleado" 2 "Empleado";
label values car_empl_pad car_empl_pad;
tab pad_iriq, gen(quin_pad);

gen edad_cu=edad*edad;
label var edad_cu "Edad del entrevistado al cuadrado";
gen año_nac=2011-edad;
label var año_nac "Año de nacimiento de la persona";

gen cohorte=0 if año_nac<1967;
replace cohorte=1 if año_nac>=1967;

label var cohorte "Cohorte de nacimiento";
label define cohorte 0 "1947-1966" 1 "1967-1986";
label values cohorte cohorte;



save "$cleandat\emovi11final.dta", replace;


***Revisando la coherencia del índice del padre del encuestado***;
**para el total**;
sum estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad
baño_pad elect_pad if pad_classoc!=.;
**por cada clase social**;
bysort pad_iriq: sum estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad
baño_pad elect_pad if pad_iriq!=.;

***Revisando la coherencia del índice del encuestado***;
**para el total**;
sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if ent_classoc!=.;
**por cada quintil**;
bysort ent_iriq: sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if ent_iriq!=.;

******CONSTRUYENDO EL ÍNDICE POR COHORTE DE NACIMIENTO****;
***COHORTE 1947-1966*****;
mca  compu  lavad refri dvd  boiler cel aspi microon tosta internet 
baño telf tvcable ahorr cuenban tcredito if ent==1 & cohorte==0, method(burt);

predict cohor0_c1 if ent==1 & cohorte==0;
 
xtile cohor0_prel1 =cohor0_c1, nq(5);
**el primer quintil es el más rico y el quinto el más pobre*****;
gen cohor0_iriq=0 if cohor0_prel1==5;
replace cohor0_iriq=1 if cohor0_prel1==4;
replace cohor0_iriq=2 if cohor0_prel1==3;
replace cohor0_iriq=3 if cohor0_prel1==2;
replace cohor0_iriq=4 if cohor0_prel1==1;

label var cohor0_c1       "1era. dim. ind. de riqueza del entrevistado, 1947-1966";
label var cohor0_iriq     "Quintiles de riqueza del entrevistado, 1947-1986";

label define cohor0_iriq 0 "Quintil 1" 1 "Quintil 2" 2 "Quintil 3" 3 "Quintil 4" 4 "Quintil 5";
label values cohor0_iriq cohor0_iriq;

***COHORTE 1967-1986*****;
mca  compu  lavad refri dvd  boiler cel aspi microon tosta internet 
baño telf tvcable ahorr cuenban tcredito if ent==1 & cohorte==1, method(burt);

predict cohor1_c1 if ent==1 & cohorte==1;
 
xtile cohor1_prel1 =cohor1_c1, nq(5);
**el primer quintil es el más rico y el quinto el más pobre*****;
gen cohor1_iriq=0 if cohor1_prel1==5;
replace cohor1_iriq=1 if cohor1_prel1==4;
replace cohor1_iriq=2 if cohor1_prel1==3;
replace cohor1_iriq=3 if cohor1_prel1==2;
replace cohor1_iriq=4 if cohor1_prel1==1;

label var cohor1_c1       "1era. dim. ind. de riqueza del entrevistado, 1967-1986";
label var cohor1_iriq     "Quintiles de riqueza del entrevistado, 1967-1986";

label define cohor1_iriq 0 "Quintil 1" 1 "Quintil 2" 2 "Quintil 3" 3 "Quintil 4" 4 "Quintil 5";
label values cohor1_iriq cohor1_iriq;


save "$cleandat\emovi11final.dta", replace;
save "$bases\emovi11final.dta", replace;

***Revisando la coherencia del índice del encuestado por cohorte***;
**para cohorte 1947-1966**;
sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if cohor0_iriq!=.;
**por cada quintil**;
bysort cohor0_iriq: sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if cohor0_iriq!=.;
**para cohorte 1967-1986**;
sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if cohor1_iriq!=.;
**por cada quintil**;
bysort cohor1_iriq: sum compu  lavad refri dvd  boiler cel aspi microon tosta internet  baño  telf tvcable 
ahorr cuenban tcredito if cohor1_iriq!=.;

log close;

