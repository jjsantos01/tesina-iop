clear all
set pagesize 10000
if c(username)=="biiacscide14"{
global A "F:\JUAN SO\"
set matsize 800
}
else{
global A "E:\"
set matsize 10000
}
global E "${A}Datos\emovi\2011\"
global D "${A}dropbox\tesina\emovi2011\"
global T "${D}tablas\"
adopath + "${D}do\"

*!wget https://www.dropbox.com/s/l17l8cdc4sf5k59/bases_de_datos_emovi-2011_1.zip?dl=1
*unzipfile bases_de_datos_emovi-2011_1, replace

use "${E}emovi2011modEntrevistado.dta", clear
qui{
****************************
** Recoding missing*********
****************************
recode p27_1 p27_2	p32_1	 p54	p56	p124	p127a	p127b p133a	p134a	p133b	p134b	p151	p154_1	p155	esc_ent	p50	p169	p18	p19	p173_1	p173_2	p174_1	p174_2	p177	p43_1	p47	p73	p74	p143a	p143b	p160 p83 p43 p126* p153 p154 p162 (98 99 =.)
recode p129a	p129b	p131a	p131b	p138a	p138b	p22_	p28	p30	p33	p46* p71 p78 p144a	p144b	p148a	p149a	p156* p157* p158* p159* p44* p62 p81 (8 9=.)
recode p82	p90	p93	p49 (999998 999999 9999998=.) 
recode edattan_deta (989 999=.)
recode p32_1 (94=.)
recode p72 (998 999=.)
****************************
*** Rellenando missings ****
****************************
* Modificando pregunta: Número de personas que viven en el hogar
replace p6 = p3 if p4==1
* Modificando pregunta: Ocupación del padre
replace p139ai08 = 0 if p138a == 2 // Ocupación del padre, 0 indica que el padre no trabajaba
label define p139ai08 0 "No trabajaba", modify
* Modificando pregunta: Ocupación de la madre
replace p141bi08 = 0 if p138b == 2 // Ocupación de la madre, 0 indica que madre no trabaja
label define p141bi08 0 "No trabajaba", modify
* Modificando pregunta: estado en el que vivía a los 14 años
replace p32_1 = p27_1 if p29 == 97 // Estado en el que vivía  a los 14 años, p29 == 97 significa que vivía en el mismo estado que nació
replace p32_1 = 90 if p31 == 2 // p31 == 2, vivía en el extranjero cuando tenía 14 años
label define p32_1 90 "En otro país", modify
* Modificando pregunta: edad a la que terminó la primaria
replace p54 = 0 if p18==97 | p54==96 | p54==97 // p18==97, el entrevistado no estudió o no terminó
label define p54 0 "Sin estudios/no terminó", modify
rename p54 edad_prim
* Modificando pregunta: edad a la que terminó la secundaria
replace p56 = 0 if p18==1 | p18==2 | p18==97 | p56==96 | p56==97 // p18==97 el entrevistado no estudió,p18==2 el entrevistado no llegó a secundaria, no la terminó o sigue estudiando
label define p56 0 "Sin estudios/no llegó/no terminó", modify
rename p56 edad_secu
* Modificando pregunta: años de escolaridad del padre
replace yearschlp = . if p131a==. // p131a==. el entrevistado no contestó si su padre asistió a la escuela
replace yearschlp = . if  p133a==. & p131a==1 //  p133a==. & p131a==1 el entrevistado contestó que su padre asistió a la escuela, pero no reportó a qué nivel educativo llegó
* Modificando pregunta: Nivel de educación que alcanzó el padre, codifificación internacional
replace edattan_gralp = . if yearschlp==.
rename edattan_gralp niveledu_pad
gen niveledu_pad2 = niveledu_pad
replace niveledu_pad=5 if niveledu_pad==.
label define edattan_gralp 5 "missing", add
label values niveledu_pad edattan_gralp
* Modificando pregunta: años de escolaridad de la madre
replace yearschlm = . if p131b==. // p131b==. el entrevistado no contestó si su madre asistió a la escuela
replace yearschlm = . if  p133b==. & p131b==1 //  p133a==. & p131a==1 el entrevistado contestó que su madre asistió a la escuela, pero no reportó a qué nivel educativo llegó
* Modificando pregunta: Nivel de educación que alcanzó la madre, codifificación internacional
replace edattan_gralm = . if yearschlm==.
rename edattan_gralm  niveledu_mad
gen niveledu_mad2 = niveledu_mad
replace niveledu_mad=5 if niveledu_mad==.
label define edattan_gralm 5 "missing", add
label values niveledu_mad edattan_gralm
* Modificando pregunta: años de escolaridad del entrevistado
replace yearschl = . if esc_ent==.
* Modificando pregunta: Nivel de escolaridad del entrevistado, codificación internacional
replace edattan_esp = . if yearschl==.
rename edattan_esp niveledu
* Modificando pregunta: Nivel de escolaridad del entrevistado, codificación internacional detallada
replace edattan_det = . if yearschl==.
rename edattan_det niveledu_det
* Modificando pregunta: Cuánto gana por los trabajos que realiza sin contar su trabajo principal
recode p90 (.=0)
* Modificando pregunta: Cuánto recibe de ingreso no laboral
recode p93 (.=0)
* Modificando pregunta: cuál es el rango de ingresos del hogar
replace p50 = 0 if p49!=0 & p49!=.
label define p50 0 "Respondió el valor", modify
* Modificando pregunta: Cuántas personas tiene a cargo en su trabajo
replace p72 = 0 if p71==2 // p71==2 significa que no tiene personas a cargo
* Modificando pregunta: cuando tenía 14 años, había servicio doméstico algunos días en su casa
replace p156l = 0 if p156k==1 // p156k==1 significan que tenían servicio permanente
label define p156l 0 "Tenía servicio permanente", modify
* Modificando pregunta: Ingreso que recibe por su trabajo principal
replace p82 = 0 if p62==3 & p82==. // p62==3 significa que no trabaja
* Recoding variable sexo
rename sex_ent sexo
recode sexo (2=0)
label define sexo 1 "Hombre" 0 "Mujer", replace
label values sexo sexo
* Creando variable de condición de trabajador
gen trabaj = (p21_==1 |p21_==2 | p21_==3 | p21_==7 | p21_==8 ) if p21_!=.
label define trabaj 1 "Sí trabaja" 0 "No trabaja", replace
label values trabaj trabaj
* Renombrando variable de edad
rename edad_ent edad
label var edad edad
* Renombrando variable de escolaridad del entrevistado
rename yearschl escol
label var escol "Escolaridad del entrevistado"
* Creando variable de rezago educativo
qui sum edad_prim, detail 
gen rez_prim = sign(edad_prim -r(p50))+2 if edad_prim!=0
replace rez_prim = 0 if edad_prim==0
label define rez_prim 0 "Sin estudios/no terminó" 1 "Rezagado" 2 "No rezagado" 3 "Adelantado"
label values rez_prim rez_prim
* Creando variable de rezago educativo
qui sum edad_secu, detail 
gen rez_secu = sign(edad_secu -r(p50))+2 if edad_secu!=0
replace rez_secu = 0 if edad_secu==0
label define rez_secu 0 "Sin estudios/no terminó" 1 "Rezagado" 2 "No rezagado" 3 "Adelantado"
label values rez_secu rez_secu
* Creando variable de nivel socioeconómico AMAI del hogar entrevistado
gen niv_soc = (nivel_sa<=3) if nivel_sa!=.
label var niv_soc "Nivel socioeconómico"
label define niv_soc 0 "Bajo" 1 "Alto"
label values  niv_soc niv_soc
* Creando variable de residencia urbana del entrevistado
gen urbano = (tamloc>=2) if tamloc!=.
label var urbano "La persona vive en zona urbana"
* variable de la persona nació en zona rural o ciudad mediana
gen nac_pue = (p28==1) if p28!=.
gen nac_ciume = (p28==2 | p28==3) if p28!=.
label var nac_pue "Entrevistado nació en un pueblo"
label var nac_ciume "Entrevistado nació en ciudad mediana"
* variable de la persona vivía en zona rural o ciudad a los 14 años
gen lugar14 = p33 
replace lugar14 = p28 if p29==97 // el entrevistado contestó que siempre ha vivido ahí
recode lugar14 (2 3=2) (4 5=3)
label var lugar14 "Tipo de lugar donde vivía a los 14 años"
label define lugar14 1 "Pueblo" 2 "Ciudad chica-mediana" 3 "Ciudad grande-metrópolis", replace
label values lugar14 lugar14
* Número de cuartos en la vivienda
rename p43 ncuartos
label var ncuartos "Número de cuartos"
* El entrevistado tiene alguna discapacidad
gen disc = (p22_==1) if p22_!=.

* bienes del hogar y activos financieros
local bien44 loccom terreno casavac depa_alq anim maq_agr negoc
local bien46 compu estuf lavad refri dvd tv boiler cel aspi microon tosta internet aguaent bano elect serdom_pe serdom_par telf tvcable
local bien52 accion ahorr cuenban tcredito
local lab44 `""Entrevistado tiene local comercial" "Entrevistado tiene terreno" "Entrevistado tiene casa de vacaciones" "Entrevistado tiene casa para alquiler" "Entrevistado tiene animales" "Entrevistado tiene maquinaria agrícola" "Entrevistado tiene un negocio""'
local lab46 `""Entrevistado tiene computadora" "Entrevistado tiene estufa" "Entrevistado tiene lavadora" "Entrevistado tiene refrigeradora" "Entrevistado tiene dvd" "Entrevistado tiene tv" "Entrevistado tiene boiler" "Entrevistado tiene celular" "Entrevistado tiene aspiradora" "Entrevistado tiene horno de microondas" "Entrevistado tiene tostador" "Entrevistado tiene internet" "Entrevistado tiene agua entubada" "Entrevistado tiene baño" "Entrevistado tiene electricidad " "Entrevistado tiene serv. dom. completo" "Entrevistado tiene serv. dom. parcial" "Entrevistado tiene teléfono fijo" "Entrevistado tiene tv de cable""'
local lab52 `" "Entrevistado tiene acciones" "Entrevistado tiene ahorros" "Entrevistado tiene cuenta bancaria" "Entrevistado tiene tarjeta de crédito" "'
foreach i in 44 46 52{
	local h = 0
	foreach x of local bien`i'{
		local h =`=`h'+1'
		gen `x' = (p`i'`:word `h' of `c(alpha)''==1) if p`i'`:word `h' of `c(alpha)''!=.
		label var `x' "`:word `h' of `lab`i'''"
}
}
gen nvehic = p47
replace nvehic = 0 if p47==97
gen nvehic2=1 if (p47==0 |p47==97) // versión de Vélez y Stabridis 2, lin152 , parece estar mal calculado
replace nvehic2=p47 if p47<97
label var nvehic "No. de veh. del entrevistasdo"

* Ingreso del hogar
gen inghog=p49
****Aquí reemplazamos los missing con el promedio del intervalo de ingreso declarado (en la última categoría por el valor mínimo)****;
foreach x in 1500	3000	5250	8500	12000	28000	71000 100000{
	local h = `=`h'+1'
	replace inghog = `x'  if  p50==`h'
}
label var inghog "Ingreso del hogar"

* Entrevistado trabaja
gen ent_trab = (p62==1 |  p62==2) if p62!=.
label var ent_trab "Entrevistado trabaja"

* Ocupación del entrevistado
gen oc=p70_op if p70_op!=94  & p70_op!=98
replace oc=1300 if oc==13
replace oc=int(oc/100)
gen ocup = 1 if oc==11
replace ocup = 0 if ent_trab ==0
local ocup `" "oc==12" "oc==13 | oc==14" "oc==21" "oc==41" "oc==51 | oc==52 | oc==54" "oc==53 | oc==55" "oc==61 | oc==62" "oc==71 | oc==72" "oc==81 | oc==82" "oc==83" "'
local h = 2
foreach x of local ocup{
	replace ocup = `h++' if `x'
}
label var ocup "Ocupación del entrevistado"
label define ocup 0 "No trabaja" 1 "Profesionistas" 2 "Técnicos" 3 "Trabajadores de la educación y del arte" 4 "Funcionarios y directivos" 5 "Trabajadores agropecuarios" 6 "Trabajadores industriales, artesanos y ayudantes" 7 "Operadores de transporte" 8 "Oficinistas" 9 "Comerciantes" 10 "Trabajadores de servicios personales" 11 "Trabajadores de protección y vigilancia" , replace
label values ocup ocup
* Tipo de empleo: empresario, auto-empleado o empleado
gen empr = (p73==1) if p73!=.
replace empr = 0 if ent_trab==0
gen autoemp = (p73==2) if p73!=.
replace autoemp = 0 if ent_trab==0
gen empl = (p73>=3) if p73!=.
replace empl = 0 if ent_trab==0
label var empr    "Entrevistado es empresario"
label var autoemp "Entrevistado es auto-empleado"
label var empl    "Entrevistado es empleado"

* Horas trabajadas por entrevistado
gen hrs_trab=p74
replace hrs_trab = 0 if ent_trab==0
label var hrs_trab "Horas semanales trabajadas por entrevistado"
* Seguro de salud
gen derechh= (p78==1) if p78!=.
label var derechh "Entrevistado cuenta con seguro de salud"
* Recibe salario (dinero, no en especie)
gen rec_pago= (p81==1) if p81!=.
replace rec_pago = 0 if ent_trab==0
label var rec_pago "Entrevistado recibe salario"
* Salario que recibe
gen inglab=p82
replace inglab = 0 if ent_trab==0
****Aquí reemplazamos los missing con el promedio del intervalo de ingreso declarado (en la última categoría por el valor mínimo)****;
local h = 1
foreach x in 1500	3000	5250	8500	12000	28000	71000 100000{
	replace inglab = `x'  if  p83==`h++'
}
* generamos variable para identificar inputados
gen ing_input = (p83!=.)
label var inglab "Ingreso laboral del entrevistado"
* Salario por hora
gen ing_hr = inglab/hrs_trab
replace ing_hr = 0 if hrs_trab==0
* Comparando el hogar actual
gen compar_hog = p169
label var compar_hog "Comparación de hogar del entrevistado con otros hogares de México"
gen compar_hog_pad = 1 if p124==1 | p124==2
replace compar_hog_pad = 2 if p124==3 | p124==4
replace compar_hog_pad = 3 if p124==5 | p124==6
replace compar_hog_pad = 4 if p124==7 | p124==8
replace compar_hog_pad = 5 if p124==9 | p124==9
label define compar_hog_pad 1 "Más bajo" 2 "Bajo" 3 "Medio" 4 "Alto" 5 "Más alto", replace
label values compar_hog_pad compar_hog_pad
label var compar_hog_pad "Comparación de hogar del padre con otros hogares de México"
* Padres hablaban lengua indígena
gen pad_hablind = (p129a==1) if p129a!=.
gen mad_hablind = (p129b==1) if p129b!=.
egen indig = anymatch(pad_hablind mad_hablind), values(1)
label var pad_hablind "Padre habla(ba) lengua indígena"
label var mad_hablind "Madre habla(ba) lengua indígena"
* Renombrando escolaridad de los padres
rename yearschlp escol_pad
rename yearschlm escol_mad
* Padres trabjaban cuando tenía 14 años
gen trab_pad = (p138a==1) if p138a!=. & p138a!=7
gen trab_mad = (p138b==1) if p138b!=. & p138b!=7
label var trab_pad "Padre del entrevistado trabaja"
label var trab_mad "Madre del entrevistado trabaja"
* Ocupación de los padres
local pad p139a
local mad p141b
foreach y in pad mad{
	gen oc_`y'=``y''_op if (``y''_op<94 | ``y''_op>1000) & ``y''_op!=.
	replace oc_`y'=``y''_op*10 if ``y''_op>100 & ``y''_op<1000
	replace oc_`y'=int(oc_`y'/100)
	gen ocup_`y' = 0 if trab_`y' ==0
	local ocup `" "oc_`y'==11" "oc_`y'==12" "oc_`y'==13 | oc_`y'==14" "oc_`y'==21" "oc_`y'==41" "oc_`y'==51 | oc_`y'==52 | oc_`y'==54" "oc_`y'==53 | oc_`y'==55" "oc_`y'==61 | oc_`y'==62" "oc_`y'==71 | oc_`y'==72" "oc_`y'==81 | oc_`y'==82" "oc_`y'==83" "'
	local h = 1
	foreach x of local ocup{
		replace ocup_`y' = `h++' if `x'
	}
	local l="`=substr("``y''",5,1)'"
	gen empr_`y' = (p143`l'==1) if p143`l'!=.
	replace empr_`y'=0 if trab_`y'==0
	gen autoemp_`y' = (p143`l'==2) if p143`l'!=.
	replace autoemp_`y'=0 if trab_`y'==0
	gen empl_`y' =(p143`l'>=3) if p143`l'!=.
	replace empl_`y'=0 if trab_`y'==0
	label define ocup_`y' 0 "No trabaja" 1 "Profesionistas" 2 "Técnicos" 3 "Trabajadores de la educación y del arte" 4 "Funcionarios y directivos" 5 "Trabajadores agropecuarios" 6 "Trabajadores industriales, artesanos y ayudantes" 7 "Operadores de transporte" 8 "Oficinistas" 9 "Comerciantes" 10 "Trabajadores de servicios personales" 11 "Trabajadores de protección y vigilancia", replace
	label values ocup_`y' ocup_`y'
}
foreach x in padre madre{
	local l="`=substr("`x'", 1,3)'"
	label var ocup_`l' "Ocupación de `x' del entrevistado"
	label var empr_`l' "`x' del entrevistado es empresario"
	label var autoemp_`l' "`x' del entrevistado es auto-empleado"
	label var empl_`l'    "`x' del entrevistado es empleado"
}
***Clasificación ocupacional del padre
gen cls_p=p139a_op if p139a_op<94 | (p139a_op>99 & p139a_op<9990)
replace cls_p=cls_p*100 if cls_p<100
replace cls_p=cls_p*10 if cls_p<1000
gen cls1_p=int(cls_p/100)

*Se agrupan los cos de la CMO
gen clas_ocup_pad=1 if cls1_p==41
replace clas_ocup_pad=0 if trab_pad==0 
replace clas_ocup_pad=2 if cls1_p==54 | cls1_p==72 | cls1_p==81 | cls1_p==82 | cls1_p==83
replace clas_ocup_pad=3 if cls1_p==51 | cls1_p==52 | cls1_p==53 | cls1_p==55
replace clas_ocup_pad=4 if cls1_p==71
replace clas_ocup_pad=5 if cls1_p==12 | cls1_p==13 | cls1_p==14 | cls1_p==62
replace clas_ocup_pad=6 if cls1_p==11 | cls1_p==21 | cls1_p==61


*** Clasificción ocupacional de la madre
gen cls_m=p141b_op if p141b_op<94 | (p141b_op>99 & p141b_op<9990)
replace cls_m=cls_m*100 if cls_m<100
replace cls_m=cls_m*10 if cls_m<1000
gen cls1_m=int(cls_m/100)

*Se agrupan los c󤩧os de la CMO
gen clas_ocup_mad=1 if cls1_m==41
replace clas_ocup_mad=0 if trab_mad==0
replace clas_ocup_mad=2 if cls1_m==54 | cls1_m==72 | cls1_m==81 | cls1_m==82 | cls1_m==83
replace clas_ocup_mad=3 if cls1_m==51 | cls1_m==52 | cls1_m==53 | cls1_m==55
replace clas_ocup_mad=4 if cls1_m==71
replace clas_ocup_mad=5 if cls1_m==12 | cls1_m==13 | cls1_m==14 | cls1_m==62
replace clas_ocup_mad=6 if cls1_m==11 | cls1_m==21 | cls1_m==61

label define clases 6 "No manual alta calif" 5 "No manual baja calif" 4 "Comercio" 3 "Manual alta calif" 2 "Manual baja calif" 1 "Agrícolas" 0 "No trabajaba", replace
label values clas_ocup_mad clas_ocup_pad clases


* El entrevistado vivía con ambos padre
gen viv_ambpad= (p151==3) if p151!=.
label var viv_ambpad "Entrevistado vivía con ambos padres"
* La casa en que vivía a los 14 años era propia.
gen casa_propia_pad=(p153==2 |  p153==3 | p153==4) if p153!=.
label var casa_propia_pad "Casa propia cuando entrevistado tenía 14 años"
* número de cuartos en casa donde vivía a los 14 años
gen ncuartos_pad = p154 
label var ncuartos_pad "Número de cuartos en casa de los padres" 

* bienes del hogar y activos financieros cuando tenía 14 años
local bien159 loccom terreno casavac depa_alq accion ahorr cuenban tcredito anim maq_agr
local bien156 estuf lavad refri tv boiler aspi tosta aguaent bano elect serdom_pe serdom_par telf
local bien157 tvcable compu dvd microon 
local bien158 cel internet
local lab159 `""Padre tenía local comercial" "Padre tenía terreno" "Padre tenía casa de vacaciones" "Padre tenía casa para alquiler" "Padre tenía acciones" "Padre tenía ahorros" "Padre tenía cuenta bancaria" "Padre tenía tarjeta de crédito" "Padre tenía animales" "Padre tenía maquinaria agrícola" "'
local lab156 `" "Padre tenía estufa" "Padre tenía lavadora" "Padre tenía refrigeradora" "Padre tenía tv" "Padre tenía boiler" "Padre tenía aspiradora" "Padre tenía tostador" "Padre tenía agua entubada" "Padre tenía baño" "Padre tenía electricidad " "Padre tenía serv. dom. completo" "Padre tenía serv. dom. parcial" "Padre tenía teléfono fijo" "'
local lab157 `" "Padre tenía tv de cable" "Padre tenía computadora" "Padre tenía dvd" "Padre tenía horno de microondas" "'
local lab158 `" "Padre tenía celular" "Padre tenía internet" "'
forvalues i=156/159{
	local h = 0
	foreach z of local bien`i'{
		local h =`=`h'+1'
		gen `z'_pad = (p`i'`:word `h' of `c(alpha)''==1) if p`i'`:word `h' of `c(alpha)''!=.
		label var `z'_pad "`:word `h' of `lab`i'''"
}
}
gen nvehic_pad = p160
replace nvehic_pad = 0 if p160==97
label var nvehic_pad "No de vehículos que tenía el padre"
** variable Número de hermanos
gen nherm = 0 if p161==2
replace nherm = 1 if p162>=1 & p162<=3
replace nherm = 2 if p162>3 & p162!=.

label var nherm "No de hermanos del entrevistado"
label define nherm 0 "No tiene hermanos" 1 "Entre 1 y 3" 2 "Más de 3 hermanos", replace
label values nherm nherm
* generando cohortes
gen cohort = 1 if edad>=25 & edad<=29
replace cohort = 2 if edad>=30 & edad<=39
replace cohort = 3 if edad>=40 & edad<=49
replace cohort = 4 if edad>=50 & edad<=59
replace cohort = 5 if edad>=60
label define cohort 1 "Entre 25 y 29" 2 "Entre 30 y 39" 3 "Entre 40 y 49" 4 "Entre 50 y 59" 5 "60 o más", replace
label values cohort cohort

gen cohort2 = 1 if edad>=25 & edad<=34
replace cohort2 = 2 if edad>=35 & edad<=44
replace cohort2 = 3 if edad>=45 & edad<=54
replace cohort2 = 4 if edad>=55

label define cohort2 1 "Entre 25 y 34" 2 "Entre 35 y 44" 3 "Entre 45 y 54" 4 "55 o más", replace
label values cohort2 cohort2
* Creando índice de riqueza padres por cohorte de edad
gen riq_pca =.
gen riq_mca =.
forvalues i=1/4{
	/*pca
	qui: pca estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad bano_pad elect_pad serdom_pe_pad  telf_pad loccom_pad terreno_pad casavac_pad depa_alq_pad accion_pad ahorr_pad cuenban_pad anim_pad maq_agr_pad nvehic_pad if cohort2==`i'
	qui:predict pca_c1_`i' pca_c2_`i' pca_c3_`i' if cohort2==`i'
	egen pca_`i' = rowtotal(pca_c1_`i' pca_c2_`i' pca_c3_`i') if cohort2==`i'
	xtile riq_pca_`i' = pca_`i'  if cohort2==`i', nq(5)
	replace riq_pca = riq_pca_`i' if cohort2==`i'
	*/
	*mca
	qui: mca estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad bano_pad elect_pad serdom_pe_pad  telf_pad loccom_pad terreno_pad casavac_pad depa_alq_pad accion_pad ahorr_pad cuenban_pad anim_pad maq_agr_pad nvehic_pad if cohort2==`i'
	qui: predict mca_`i'
	xtile riq_mca_`i' = mca_`i' if cohort2==`i', nq(5)
	qui: replace riq_mca = riq_mca_`i' if cohort2==`i'
}
recode riq_mca (1=5) (2=4) (4=2) (5=1)
* Quitando efecto de edad sobre índide de riqueza
qui: mca estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad bano_pad elect_pad serdom_pe_pad  telf_pad loccom_pad terreno_pad casavac_pad depa_alq_pad accion_pad ahorr_pad cuenban_pad anim_pad maq_agr_pad nvehic_pad
predict ind_mca
qui: lpoly ind_mca edad, gen(mca_edad) at(edad) nograph
gen mca_noedad = ind_mca-mca_edad
xtile riq_mca_edad = mca_noedad, nq(5)
* etiquetando índices de riqueza
label define riq 1 "Más bajo" 2 "Bajo" 3 "Medio" 4 "Alto" 5 "Más alto", replace
label values riq_mca riq_mca_edad riq_pca riq
* observaciones con missings
egen miss = rowmiss(cohort escol_pad escol_mad lugar14 escol ent_trab  hrs_trab inglab indig trab_pad trab_mad riq_mca)
gen muestra2 = (miss==0)

qui reg escol i.sexo i.indig i.disc i.nherm i.niveledu_mad i.niveledu_pad  i.trab_mad i.clas_ocup_pad i.lugar14 i.riq_mca [iw=ponderel]
gen muestra = e(sample)==1

keep idllave strat reg entrvd niv_soc sexo edad* cohort cohort2 urbano lugar14 nac_pue nac_ciume disc escol niveledu* rez* clas_ocup* riq_mca riq_mca_edad ing_input ///
indig ing_hr casa_propia ncuartos loccom terreno casavac depa_alq maq_agr anim negoc compu estuf lavad refri dvd tv boiler cel aspi microon ///
tosta internet aguaent bano elect serdom_pe serdom_par telf tvcable nvehic inghog accion ahorr cuenban ///
tcredito ent_trab ocup empr autoemp empl hrs_trab derechh rec_pago inglab compar_hog compar_hog_pad ///
pad_hablind mad_hablind *pad *mad nherm  ponderel muestra 

/*
tempfile emovi2011ent
save `emovi2011ent'

use "${E}Emovi2011modHogar.dta", clear
gen nhijos = ((p16_==3 | p16_==4) & p15_<=5)
collapse (max) nhijos, by(idllave)
label var nhijos "El entrevistado tiene hijo menor de 5 años"
label define nhijos 0 "No tiene hijos menores de 5 años" 1 "Tiene hijos menores de 5 años"
label values nhijos nhijos

merge 1:1 idllave using `emovi2011ent', nogen
*/
}
save "${D}Emovi2011Ent", replace
*zipfile "${E}Emovi2011Ent.dta", saving("${D}Emovi2011Ent.zip", replace)
