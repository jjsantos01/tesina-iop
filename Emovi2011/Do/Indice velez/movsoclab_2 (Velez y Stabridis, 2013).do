capture log close;
#delimit;
set more off;

************************************************************************************
CODIGO PARA CONSTRUIR UNA BASE A NIVEL INDIVIDUO
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
log using "$logs\ems1_2.log",replace;

use "$tempdat\miemb_emovi2011.dta", clear;
keep if miemb_entr==1;

label var estud "La persona es estudiante";

keep idllave edad escol trabaj estud trab_srteb trabaj_medt entv_jhog sexo tipo_entr;
sort  idllave;

label define sexo 0 "Mujer" 1 "Hombre";
label values sexo sexo;


foreach x in trabaj estud trab_srteb trabaj_medt entv_jhog {;
label define `x' 0 "No" 1 "Sí";
label values `x' `x';
};

save "$tempdat\soloent_emovi2011.dta", replace; 

*******************************************************************************************;
*******SOLO TRABAJAREMOS CON AQUELLOS INDIVIDUOS CUYA ENTREVISTA YA FUE COMPLETADA*********;
*******************************************************************************************;

****TODAS LAS ENTREVISTAS SE COMPLETARON******;

use "$data\Emovi2011.dta", clear;


gen niv_soc=1 if nivel_sa<=3;
replace niv_soc=0 if nivel_sa>=4 & nivel_sa!=.;
	
label var niv_soc "Nivel socioeconómico";
label define niv_soc 0 "Bajo" 1 "Alto";
label values  niv_soc niv_soc;

recode sex_ent 2=0;
label define sex_ent 0 "Mujer" 1 "Hombre", modify;
label values sex_ent sex_ent;

gen urbano=1 if tamloc>=2 & tamloc!=.;
replace urbano=0 if tamloc==1;

gen unido=1 if (p24==1 | p24==5);
replace unido=0 if  (p24==2 | p24==3 |p24==4 | p24==6);
label var unido "La persona está unida";
label var urbano "La persona vive en zona urbana";

gen nac_pue=1 if p28==1;
replace nac_pue=0 if (p28>=2 & p28<=5);

gen nac_ciume=1 if (p28==2 | p28==3);
replace nac_ciume=0 if (p28==1 |  p28==4 |  p28==5);

label var nac_pue "Entrevistado nació en un pueblo";
label var nac_ciume "Entrevistado nació en ciudad mediana";

gen casa_propia=1 if (p39==2 |  p39==3 |  p39==4);
replace casa_propia=0 if (p39==1 |  p39==5 |  p39==6 |  p39==7 |  p39==8);

label var casa_propia "La casa es propia";

gen casa_escr=1 if p40==1;
replace casa_escr=0 if p40==2;
label var casa_escr "La casa tiene escrituras";
gen ncuartos=p43 if p43<98;
label var ncuartos "Número de cuartos";  

gen loccom=1 if p44a==1;
replace loccom=0 if p44a==2;
gen terreno=1 if p44b==1;
replace terreno=0 if p44b==2;
gen casavac=1 if p44c==1;
replace casavac=0 if p44c==2;
gen depa_alq=1 if p44d==1;
replace depa_alq=0 if p44d==2;
gen anim=1 if p44e==1;
replace anim=0 if p44e==2;
gen maq_agr=1 if p44f==1;
replace maq_agr=0 if p44f==2;
gen negoc=1 if p44g==1;
replace negoc=0 if p44g==2;

label var loccom "Entrevistado tiene local comercial";
label var terreno "Entrevistado tiene terreno";
label var casavac "Entrevistado tiene casa de vacaciones";
label var depa_alq "Entrevistado tiene casa para alquiler";
label var anim "Entrevistado tiene animales";
label var maq_agr "Entrevistado tiene maquinaria agrícola";
label var negoc "Entrevistado tiene un negocio";


gen compu=1 if p46a==1;
replace compu=0 if p46a==2;
gen estuf=1 if p46b==1;
replace estuf=0 if p46b==2;
gen lavad=1 if p46c==1;
replace lavad=0 if p46c==2;
gen refri=1 if p46d==1;
replace refri=0 if p46d==2;
gen dvd=1 if p46e==1;
replace dvd=0 if p46e==2;
gen tv=1 if p46f==1;
replace tv=0 if p46f==2;
gen boiler=1 if p46g==1;
replace boiler=0 if p46g==2;
gen cel=1 if p46h==1;
replace cel=0 if p46h==2;
gen aspi=1 if p46i==1;
replace aspi=0 if p46i==2;
gen microon=1 if p46j==1;
replace microon=0 if p46j==2;
gen tosta=1 if p46k==1;
replace tosta=0 if p46k==2;
gen internet=1 if p46l==1;
replace internet=0 if p46l==2;
gen aguaent=1 if p46m==1;
replace aguaent=0 if p46m==2;
gen baño=1 if p46n==1;
replace baño=0 if p46n==2;
gen elect=1 if p46o==1;
replace elect=0 if p46o==2;
gen serdom_pe=1 if p46p==1;
replace serdom_pe=0 if p46p==2;
gen serdom_par=1 if p46q==1;
replace serdom_par=0 if p46q==2;
gen telf=1 if p46r==1;
replace telf=0 if p46r==2;
gen tvcable=1 if p46s==1;
replace tvcable=0 if p46s==2;
gen nvehic=1 if (p47==0 |p47==97);
replace nvehic=p47 if p47<97;

label var compu "Entrevistado tiene computadora";
label var estuf "Entrevistado tiene estufa";
label var lavad "Entrevistado tiene lavadora";
label var refri "Entrevistado tiene refrigeradora";
label var dvd "Entrevistado tiene dvd";
label var tv "Entrevistado tiene tv";
label var boiler "Entrevistado tiene boiler";
label var cel "Entrevistado tiene celular";
label var aspi "Entrevistado tiene aspiradora";
label var microon "Entrevistado tiene horno de microondas";
label var tosta "Entrevistado tiene tostador";
label var internet "Entrevistado tiene internet";
label var aguaent "Entrevistado tiene agua entubada";
label var baño "Entrevistado tiene baño";
label var elect "Entrevistado tiene electricidad ";
label var serdom_pe "Entrevistado tiene serv. dom. completo";
label var serdom_par "Entrevistado tiene serv. dom. parcial";
label var telf "Entrevistado tiene teléfono fijo";
label var tvcable "Entrevistado tiene tv de cable ";
label var nvehic "No. de veh. del entrevistasdo";

gen inghog=p49 if p49<999998;
****Aquí reemplazamos los missing con el promedio del intervalo de ingreso declarado****;
replace inghog=1500  if  p50==1 & p49>=999998;
replace inghog=3000  if  p50==2 & p49>=999998;
replace inghog=5250  if  p50==3 & p49>=999998;
replace inghog=8500  if  p50==4 & p49>=999998;
replace inghog=12000 if  p50==5 & p49>=999998;
replace inghog=28000 if  p50==6 & p49>=999998;
replace inghog=71000 if  p50==7 & p49>=999998;
****Aquí reemplazamos los missing con el valor mínimo del intervalo de ingreso declarado****;
replace inghog=100000 if p50==8 & p49>=999998;
label var inghog "Ingreso del hogar";
gen accion=1 if p52a==1;
replace accion=0 if p52a==2;
label var accion "Entrevistado tiene acciones";
gen ahorr=1 if p52b==1;
replace ahorr=0 if p52b==2;
label var ahorr "Entrevistado tiene ahorros";
gen cuenban=1 if p52c==1;
replace cuenban=0 if p52c==2;
label var cuenban "Entrevistado tiene cuenta bancaria";
gen tcredito=1 if p52d==1;
replace tcredito=0 if p52d==2;
label var tcredito "Entrevistado tiene tarjeta de crédito";
gen oport=1 if p53b==1;
replace oport=0 if p53b==2;
label var oport "Entrevistado es beneficiario de Oportunidades";

gen prim_priv=1 if p58a<=2;
replace prim_priv=0 if p58a>=3 & p58a<=4;
gen sec_priv=1 if p58b<=2 | p58c<=2 ;
replace sec_priv=0 if (p58b>=3 & p58b<=4) | (p58c>=3 & p58c<=4);
gen prepa_priv=1 if p58d<=2 | p58e<=2 ;
replace prepa_priv=0 if (p58d>=3 & p58d<=4) | (p58e>=3 & p58e<=4);
gen uni_priv=1 if p58f<=2;
replace uni_priv=0 if p58f>=3 & p58f<=4;

label var prim_priv "Entrevistado fue a primaria privada";
label var sec_priv "Entrevistado fue a secundaria privada";
label var prepa_priv "Entrevistado fue a preparatoria privada";
label var uni_priv "Entrevistado fue a universidad privada";

egen x=rowtotal(prim_priv sec_priv prepa_priv uni_priv)if (prim_priv!=. |sec_priv!=. |prepa_priv!=. |uni_priv!=.);

gen esc_priv=1 if x>=3 & x<=.;
replace esc_priv=1 if x<=2;
label var esc_priv "Entrevistado fue a escuelas privadas";
 
gen ent_trab=1 if p62==1 |  p62==2;
replace ent_trab=0 if p62==3;

label var ent_trab "Entrevistado trabaja";

gen oc=p70_op if p70_op!=94  & p70_op!=98;
replace oc=1300 if oc==13;

replace oc=int(oc/100);

gen ocup=1 if oc==11;
replace ocup=2 if oc==12;
replace ocup=3 if oc==13 | oc==14;
replace ocup=4 if oc==21;
replace ocup=5 if oc==41;
replace ocup=6 if oc==51 | oc==52 | oc==54;
replace ocup=7 if oc==53 | oc==55;
replace ocup=8 if oc==61 | oc==62;
replace ocup=9 if oc==71 | oc==72;
replace ocup=10 if oc==81 | oc==82;
replace ocup=11 if oc==83;
label var ocup "Ocupación del entrevistado";
label define ocup 1 "Profesionistas" 2 "Técnicos" 3 "Trabajadores de la educación y del arte" 4 "Funcionarios y directivos" 
5 "Trabajadores agropecuarios" 6 "Trabajadores industriales, artesanos y ayudantes" 7 "Operadores de transporte" 8 "Oficinistas" 9
 "Comerciantes" 10 "Trabajadores de servicios personales" 11 "Trabajadores de protección y vigilancia";
label values ocup ocup;

gen empr=1 if p73==1;
replace empr=0 if p73>1 & p73<98; 
gen autoemp=1 if p73==2;
replace autoemp=0 if p73!=2 & (p73==1 | (p73>=3 & p73<98));
gen empl=1 if (p73>=3 & p73<98);
replace empl=0 if (p73<=2);

label var empr    "Entrevistado es empresario";
label var autoemp "Entrevistado es auto-empleado";
label var empl    "Entrevistado es empleado";

gen hrs_trab=p74  if p74<98;
label var hrs_trab "Horas semanales trabajadas por entrevistado";
gen tamemp=1 if p77<=3;
replace tamemp=2 if p77>=4 & p77<=6;
replace tamemp=3 if p77>=7 & p77<=9;
label var tamemp "Tamaño de empresa donde trab. entrevistado";
label define tamemp 1 "micro" 2 "pequeña" 3 "mediana o grande";
label values tamemp tamemp;

gen derechh=1 if p78==1;
replace derechh=0 if p78==2;

label var derechh "Entrevistado cuenta con seguro de salud";
gen sindi=1 if p80==1;
replace sindi=0 if p80==2;
label var sindi "Entrevistado pertenece a un sindicato";

gen rec_pago=1 if p81==1;
replace rec_pago=0 if p81==2;

label var rec_pago "Entrevistado recibe salario";

gen inglab_ent=p82 if p82<999998;
****Aquí reemplazamos los missing con el promedio del intervalo de ingreso declarado****;
replace inglab_ent=1500   if  p83==1 & p82>=999998;
replace inglab_ent=3000   if  p83==2 & p82>=999998;
replace inglab_ent=5250   if  p83==3 & p82>=999998;
replace inglab_ent=8500   if  p83==4 & p82>=999998;
replace inglab_ent=12000  if  p83==5 & p82>=999998;
replace inglab_ent=28000  if  p83==6 & p82>=999998;
replace inglab_ent=71000  if  p83==7 & p82>=999998;
****Aquí reemplazamos los missing con el valor mínimo del intervalo de ingreso declarado****;
replace inglab_ent=100000 if  p83==8 & p82>=999998;

label var inglab_ent "Ingreso laboral del entrevistado";
forvalues i=1/9 {;
gen hij`i'=1 if p120_0`i'!=.;
}; 

forvalues i=10/13 {;
gen hij`i'=1 if p120_`i'!=.;
}; 

egen nhijos=rowtotal(hij1 hij2 hij3 hij4 hij5 hij6 hij7 hij8 hij9 hij10 hij11 hij12 hij13);  

label var nhijos "No. de hijos del entrevistado";

gen compar_hog_pad=p124 if p124<98;
label var compar_hog_pad "Comparación de hogar del padre con otros hogares de México";
gen viv_pa=1 if p125a==1;
replace viv_pa=1 if p125a==2;

gen viv_ma=1 if p125b==1;
replace viv_ma=1 if p125b==2;

label var viv_pa "Padre del entrevistado vive";
label var viv_ma "Madre del entrevistado vive";

***corte de edad en 39 años para los padres más jóvenes***;
gen añonac_pad=1900+p125a if p125a<72;
replace añonac_pad=1972 if p125a>=72 & p125a<98;

gen añonac_mad=1900+p125b if p125b<72;
replace añonac_mad=1972 if p125b>=72 & p125b<98;

label var añonac_pad "Año de nacimiento del padre";
label var añonac_mad "Año de nacimiento de la madre";

gen edad_pad=2011-añonac_pad;
gen edad_mad=2011-añonac_mad;
label var edad_pad "Edad del padre";
label var edad_mad "Edad de la madre";

gen pad_hablind=1 if p129a==1;
replace pad_hablind=0 if p129a==2;

gen mad_hablind=1 if p129b==1;
replace mad_hablind=0 if p129b==2;

gen escpriv_pad=1 if (p132a==1 | p132a==2);
replace escpriv_pad=0 if (p132a==3 | p132a==4);

gen escpriv_mad=1 if (p132b==1 | p132b==2);
replace escpriv_mad=0 if (p132b==3 | p132b==4);

label var pad_hablind "Padre habla(ba) lengua indígena";
label var mad_hablind "Madre habla(ba) lengua indígena";
label var escpriv_pad "Padre fue a escuelas privadas";
label var escpriv_mad "Madre fue a escuelas privadas";


gen escol_pad=0 if p131a==2;
replace escol_pad=0 if p133a==1;
replace escol_pad=1 if (p133a==2 & p134a==1) | (p133a==8 & p134a==1);
replace escol_pad=2 if (p133a==2 & p134a==2) | (p133a==8 & p134a==2);
replace escol_pad=3 if (p133a==2 & p134a==3) | (p133a==8 & p134a==3);
replace escol_pad=4 if (p133a==2 & p134a==4) | (p133a==8 & p134a==4);
replace escol_pad=5 if (p133a==2 & p134a==5) | (p133a==8 & p134a==5);
replace escol_pad=6 if (p133a==2 & p134a>=6 & p134a<97) | (p133a==8 & p134a>=6 & p134a<97);
replace escol_pad=7 if (p133a==3 & (p134a==1)) | (p133a==4 & (p134a==1))| (p133a==9 & (p134a==1));
replace escol_pad=8 if (p133a==3 & (p134a==2)) | (p133a==4 & (p134a==2))| (p133a==9 & (p134a==2));
replace escol_pad=9 if (p133a==3 & p134a>=3 & p134a<97) | (p133a==4 & p134a>=3 & p134a<97)|
 (p133a==9 & p134a>=3 & p134a<97);
replace escol_pad=10 if (p133a==5 & (p134a==1)) | (p133a==6 & (p134a==1))| (p133a==7 & (p134a==1));
replace escol_pad=11 if (p133a==5 & (p134a==2)) | (p133a==6 & (p134a==2))| (p133a==7 & (p134a==2));
replace escol_pad=12 if (p133a==5 & p134a>=3 & p134a<97) | (p133a==6 & p134a>=3 & p134a<97)
| (p133a==7 & p134a>=3 & p134a<97);
replace escol_pad=13 if (p133a==10 & (p134a==1));
replace escol_pad=14 if (p133a==10 & (p134a==2));
replace escol_pad=15 if (p133a==10 & (p134a==3));
replace escol_pad=16 if (p133a==10 & (p134a==4));
replace escol_pad=17 if (p133a==10 &  p134a>=5 & p134a<97);
replace escol_pad=18 if (p133a==11 & (p134a==1));
replace escol_pad=19 if (p133a==11 & (p134a==2));
replace escol_pad=20 if (p133a==11 & p134a>=3 & p134a<97);

gen escol_mad=0 if p131b==2;
replace escol_mad=0 if p133b==1;
replace escol_mad=1 if (p133b==2 & p134b==1) | (p133b==8 & p134b==1);
replace escol_mad=2 if (p133b==2 & p134b==2) | (p133b==8 & p134b==2);
replace escol_mad=3 if (p133b==2 & p134b==3) | (p133b==8 & p134b==3);
replace escol_mad=4 if (p133b==2 & p134b==4) | (p133b==8 & p134b==4);
replace escol_mad=5 if (p133b==2 & p134b==5) | (p133b==8 & p134b==5);
replace escol_mad=6 if (p133b==2 & p134b>=6 & p134b<97) | (p133b==8 & p134b>=6 & p134b<97);
replace escol_mad=7 if (p133b==3 & (p134b==1)) | (p133b==4 & (p134b==1))| (p133b==9 & (p134b==1));
replace escol_mad=8 if (p133b==3 & (p134b==2)) | (p133b==4 & (p134b==2))| (p133b==9 & (p134b==2));
replace escol_mad=9 if (p133b==3 & p134b>=3 & p134b<97) | (p133b==4 & p134b>=3 & p134b<97)|
 (p133b==9 & p134b>=3 & p134b<97);
replace escol_mad=10 if (p133b==5 & (p134b==1)) | (p133b==6 & (p134b==1))| (p133b==7 & (p134b==1));
replace escol_mad=11 if (p133b==5 & (p134b==2)) | (p133b==6 & (p134b==2))| (p133b==7 & (p134b==2));
replace escol_mad=12 if (p133b==5 & p134b>=3 & p134b<97) | (p133b==6 & p134b>=3 & p134b<97)
| (p133a==7 & p134b>=3 & p134b<97);
replace escol_mad=13 if (p133b==10 & (p134b==1));
replace escol_mad=14 if (p133b==10 & (p134b==2));
replace escol_mad=15 if (p133b==10 & (p134b==3));
replace escol_mad=16 if (p133b==10 & (p134b==4));
replace escol_mad=17 if (p133b==10 &  p134b>=5 & p134b<97);
replace escol_mad=18 if (p133b==11 & (p134b==1));
replace escol_mad=19 if (p133b==11 & (p134b==2));
replace escol_mad=20 if (p133b==11 & p134b>=3 & p134b<97);

label var escol_pad "Años de escolaridad del padre";
label var escol_mad "Años de escolaridad de la madre";

gen trab_pad=1 if p138a==1;
replace trab_pad=0 if p138a==2;

gen trab_mad=1 if p138b==1;
replace trab_mad=0 if p138b==2;


label var trab_pad "Padre del entrevistado trabaja";
label var trab_mad "Madre del entrevistado trabaja";

gen oc_pad=p139a_op if (p139a_op<94 | p139a_op>1000) & p139a_op!=.;
replace oc_pad=p139a_op*10 if p139a_op>100 & p139a_op<1000;

replace oc_pad=int(oc_pad/100);

gen ocup_pad=1 if oc_pad==11;
replace ocup_pad=2 if oc_pad==12;
replace ocup_pad=3 if oc_pad==13 | oc_pad==14;
replace ocup_pad=4 if oc_pad==21;
replace ocup_pad=5 if oc_pad==41;
replace ocup_pad=6 if oc_pad==51 | oc_pad==52 | oc_pad==54;
replace ocup_pad=7 if oc_pad==53 | oc_pad==55;
replace ocup_pad=8 if oc_pad==61 | oc_pad==62;
replace ocup_pad=9 if oc_pad==71 | oc_pad==72;
replace ocup_pad=10 if oc_pad==81 | oc_pad==82;
replace ocup_pad=11 if oc_pad==83;
label var ocup_pad "Ocupación del padre del entrevistado";
label define ocup_pad 1 "Profesionistas" 2 "Técnicos" 3 "Trabajadores de la educación y del arte" 4 "Funcionarios y directivos" 
5 "Trabajadores agropecuarios" 6 "Trabajadores industriales, artesanos y ayudantes" 7 "Operadores de transporte" 8 "Oficinistas" 9
 "Comerciantes" 10 "Trabajadores de servicios personales" 11 "Trabajadores de protección y vigilancia";
label values ocup_pad ocup_pad;

gen empr_pad=1 if p143a==1;
replace empr_pad=0 if p143a>1 & p143a<98; 
gen autoemp_pad=1 if p143a==2;
replace autoemp_pad=0 if p143a!=2 & (p143a==1 | (p143a>=3 & p143a<98));
gen empl_pad=1 if (p143a>=3 & p143a<98);
replace empl_pad=0 if (p143a<=2);

label var empr_pad    "Padre del entrevistado es empresario";
label var autoemp_pad "Padre del entrevistado es auto-empleado";
label var empl_pad    "Padre del entrevistado es empleado";


gen oc_mad=p141b_op if (p141b_op<94 | p141b_op>1000) & p141b_op!=.;
replace oc_mad=p141b_op*10 if p141b_op>100 & p141b_op<1000;

replace oc_mad=int(oc_mad/100);

gen ocup_mad=1 if oc_mad==11;
replace ocup_mad=2 if oc_mad==12;
replace ocup_mad=3 if oc_mad==13 | oc_mad==14;
replace ocup_mad=4 if oc_mad==21;
replace ocup_mad=5 if oc_mad==41;
replace ocup_mad=6 if oc_mad==51 | oc_mad==52 | oc_mad==54;
replace ocup_mad=7 if oc_mad==53 | oc_mad==55;
replace ocup_mad=8 if oc_mad==61 | oc_mad==62;
replace ocup_mad=9 if oc_mad==71 | oc_mad==72;
replace ocup_mad=10 if oc_mad==81 | oc_mad==82;
replace ocup_mad=11 if oc_mad==83;
label var ocup_mad "Ocupación de la madre del entrevistado";
label define ocup_mad 1 "Profesionistas" 2 "Técnicos" 3 "Trabajadores de la educación y del arte" 4 "Funcionarios y directivos" 
5 "Trabajadores agropecuarios" 6 "Trabajadores industriales, artesanos y ayudantes" 7 "Operadores de transporte" 8 "Oficinistas" 9
 "Comerciantes" 10 "Trabajadores de servicios personales" 11 "Trabajadores de protección y vigilancia";
label values ocup_mad ocup_mad;

gen empr_mad=1 if p143b==1;
replace empr_mad=0 if p143b>1 & p143b<98; 
gen autoemp_mad=1 if p143b==2;
replace autoemp_mad=0 if p143b!=2 & (p143b==1 | (p143b>=3 & p143b<98));
gen empl_mad=1 if (p143b>=3 & p143b<98);
replace empl_mad=0 if (p143b<=2);

label var empr_mad    "Madre del entrevistado es empresario";
label var autoemp_mad "Madre del entrevistado es auto-empleado";
label var empl_mad    "Madre del entrevistado es empleado";

gen viv_ambpad=1 if p151==3;
replace viv_ambpad=0 if p151!=3 & p151<98;

label var viv_ambpad "Entrevistado vivía con ambos padres";
gen jhog_pad=1 if p152==1;
replace  jhog_pad=0 if (p152==2 |p152==3);
label var jhog_pad "Jefe de hogar era el padre";

gen casa_propia_pad=1 if (p153==2 |  p153==3 | p153==4);
replace casa_propia_pad=0 if (p153==1 | p153==5 |  p153==6 | p153==7 | p153==8);

label var casa_propia_pad "Casa propia cuando entrevistado tenía 14 años";

gen ncuartos_pad=p43 if p43<98;
label var ncuartos_pad "Número de cuartos en casa de los padres";  


gen estuf_pad=1 if p156a==1;
replace estuf_pad=0 if p156a==2;
gen lavad_pad=1 if p156b==1;
replace lavad_pad=0 if p156b==2;
gen refri_pad=1 if p156c==1;
replace refri_pad=0 if p156c==2;
gen tv_pad=1 if p156d==1;
replace tv_pad=0 if p156d==2;
gen boiler_pad=1 if p156e==1;
replace boiler_pad=0 if p156e==2;
gen aspi_pad=1 if p156f==1;
replace aspi_pad=0 if p156f==2;
gen tosta_pad=1 if p156g==1;
replace tosta_pad=0 if p156g==2;
gen aguaent_pad=1 if p156h==1;
replace aguaent_pad=0 if p156h==2;
gen baño_pad=1 if p156i==1;
replace baño_pad=0 if p156i==2;
gen elect_pad=1 if p156j==1;
replace elect_pad=0 if p156j==2;
gen serdom_pe_pad=1 if p156k==1;
replace serdom_pe_pad=0 if p156k==2;
gen serdom_par_pad=1 if p156l==1;
replace serdom_par_pad=0 if p156l==2;
gen telf_pad=1 if p156m==1;
replace telf_pad=0 if p156m==2;
gen tvcable_pad=1 if p157a==1;
replace tvcable_pad=0 if p157a==2;
gen compu_pad=1 if p157b==1;
replace compu_pad=0 if p157b==2;
gen dvd_pad=1 if p157c==1;
replace dvd_pad=0 if p157c==2;
gen microon_pad=1 if p157d==1;
replace microon_pad=0 if p157d==2;
gen cel_pad=1 if p158a==1;
replace cel_pad=0 if p158a==2;
gen internet_pad=1 if p158b==1;
replace internet_pad=0 if p158b==2;

gen loccom_pad=1 if p159a==1;
replace loccom_pad=0 if p159a==2;
gen terreno_pad=1 if p159b==1;
replace terreno_pad=0 if p159b==2;
gen casavac_pad=1 if p159c==1;
replace casavac_pad=0 if p159c==2;
gen depa_alq_pad=1 if p159d==1;
replace depa_alq_pad=0 if p159d==2;
gen accion_pad=1 if p159e==1;
replace accion_pad=0 if p159e==2;
gen ahorr_pad=1 if p159f==1;
replace ahorr_pad=0 if p159f==2;
gen cuenban_pad=1 if p159g==1;
replace cuenban_pad=0 if p159g==2;
gen tcredito_pad=1 if p159h==1;
replace tcredito_pad=0 if p159h==2;
gen anim_pad=1 if p159i==1;
replace anim_pad=0 if p159i==2;
gen maq_agr_pad=1 if p159j==1;
replace maq_agr_pad=0 if p159j==2;


gen nvehic_pad=1 if (p160==0 |p160==97);
replace nvehic_pad=p160 if p160<97;

gen compar_hog=p124 if p124<98;

label var estuf_pad "Padre tenía estufa";
label var lavad_pad "Padre tenía lavadora";
label var refri_pad "Padre tenía refrigeradora";
label var tv_pad "Padre tenía tv";
label var boiler_pad "Padre tenía boiler";
label var aspi_pad "Padre tenía aspiradora";
label var tosta_pad "Padre tenía tostador";
label var aguaent_pad "Padre tenía agua entubada";
label var baño_pad "Padre tenía baño";
label var elect_pad "Padre tenía electricidad ";
label var serdom_pe_pad "Padre tenía serv. dom. completo";
label var serdom_par_pad "Padre tenía serv. dom. parcial";
label var tvcable_pad "Padre tenía tv de cable ";
label var compu_pad "Padre tenía computadora";
label var dvd_pad "Padre tenía dvd";
label var microon_pad "Padre tenía horno de microondas";
label var cel_pad "Padre tenía celular";
label var internet_pad "Padre tenía internet";
label var loccom_pad "Padre tenía local comercial";
label var terreno_pad "Padre tenía terreno";
label var casavac_pad "Padre tenía casa de vacaciones";
label var depa_alq_pad "Padre tenía casa para alquilar";
label var accion_pad "Padre tenía acciones";
label var ahorr_pad "Padre tenía ahorros";
label var cuenban_pad "Padre tenía cuenta bancaria";
label var tcredito_pad "Padre tenía tarjeta bancaria";
label var anim_pad "Padre tenía animales";
label var maq_agr_pad "Padre tenía maquinaria agrícola";
label var nvehic_pad "Padre tenía vehículos";
label var compar_hog "Hogar del entrevistado respecto a otros de México";
label var telf_pad "Padre tenía teléfono fijo";



keep idllave entrvd niv_soc sex_ent urbano unido nac_pue nac_ciume casa_propia casa_escr ncuartos
loccom terreno casavac depa_alq maq_agr anim negoc compu estuf lavad refri dvd tv boiler cel aspi microon
tosta internet aguaent baño elect serdom_pe serdom_par telf tvcable nvehic inghog accion ahorr cuenban
tcredito oport prim_priv sec_priv prepa_priv uni_priv ent_trab ocup empr autoemp empl hrs_trab tamemp
derechh sindi rec_pago inglab_ent nhijos compar_hog_pad viv_pa viv_ma añonac_mad añonac_mad edad_pad
edad_mad pad_hablind mad_hablind escpriv_pad escpriv_mad escol_pad escol_mad trab_mad ocup_pad empr_pad
autoemp_pad empl_pad ocup_mad empr_mad autoemp_mad empl_mad viv_ambpad jhog_pad casa_propia_pad ncuartos_pad
estuf_pad lavad_pad refri_pad tv_pad boiler_pad aspi_pad tosta_pad aguaent_pad baño_pad elect_pad 
serdom_pe_pad serdom_par_pad telf_pad tvcable_pad compu_pad dvd_pad microon_pad cel_pad internet_pad
loccom_pad terreno_pad casavac_pad depa_alq_pad accion_pad ahorr_pad ahorr_pad cuenban_pad tcredito_pad 
anim_pad maq_agr_pad nvehic_pad compar_hog esc_priv ponderel;

 
 
save "$tempdat\muestra_emovi11.dta", replace;


merge idllave using  "$tempdat\soloent_emovi2011.dta"; 
sort idllave;
drop _merge;

save "$tempdat\muestra_emovi11final.dta", replace;

 
 log close;

