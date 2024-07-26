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
log using "$logs\ems1_1.log",replace;

use "$data\Emovi2011.dta", clear;

sort idllave;
keep idllave folio strat strat_ nivel_sa reg entrvd sex_ent edad_ent esc_ent actecoent p9_ent idloc 
tamloc filtro_p1_1 cve_edo_1 edo cve_mpio_1 edompo localidad est_ent_v2_1 est_ent_v3_1 p3 p4_1 p5_1
 p6_1 p7_1jh_op p7_1jh p7_1_01 edad_1_01 p9_1_01 p10_1_01 p11_01 vive_01 p12_01 p13_01 sexo_01 p15_01
 p16_01 p17_01 p18_01 p19_01 p20_01 p21_01 p22_01 p22_1_01 p22_2_01 p23_01 p24- ponderel;
 
save "$tempdat\emovi11_ent.dta", replace; 


use "$data\Emovi2011.dta", clear;

keep idllave entrvd p11_01- p23_17;
gen str nombre = "";
gen vivh=.;
gen motv_nviv=.;
gen sexo=.;
gen edad=.;
gen parentes_ent=.;
gen parentes_jh=.;
gen niv_esc=.;
gen grad_esc=.;
gen cert_niv=.;
gen trabaja=.;
save "$tempdat\e11_todo.dta", replace; 

keep idllave entrvd p11_01 vive_01 p12_01 p13_01 sexo_01 p15_01 p16_01 p17_01 p18_01 p19_01 p20_01 p21_01 p22_01
p22_1_01 p22_2_01 p23_01;
gen wave1=1;
save "$tempdat\e11_1.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd p11_02 vive_02 p12_02 p13_02 sexo_02 p15_02 p16_02 p17_02 p18_02 p19_02 p20_02 p21_02 p22_02
p22_1_02 p22_2_02 p23_02;
drop if p16_02==.;
gen wave2=1;
save "$tempdat\e11_2.dta", replace; 

use "$tempdat\e11_todo.dta", clear; 
keep idllave entrvd  p11_03 vive_03 p12_03 p13_03 sexo_03 p15_03 p16_03 p17_03 p18_03 p19_03 p20_03 p21_03 p22_03
p22_1_03 p22_2_03 p23_03;
drop if p16_03==.;
gen wave3=1;
save "$tempdat\e11_3.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_04 vive_04 p12_04 p13_04 sexo_04 p15_04 p16_04 p17_04 p18_04 p19_04 p20_04 p21_04 p22_04
p22_1_04 p22_2_04 p23_04;
drop if p16_04==.;
gen wave4=1;
save "$tempdat\e11_4.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_05 vive_05 p12_05 p13_05 sexo_05 p15_05 p16_05 p17_05 p18_05 p19_05 p20_05 p21_05 p22_05
p22_1_05 p22_2_05 p23_05;
drop if p16_05==.;
gen wave5=1;
save "$tempdat\e11_5.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_06 vive_06 p12_06 p13_06 sexo_06 p15_06 p16_06 p17_06 p18_06 p19_06 p20_06 p21_06 p22_06
p22_1_06 p22_2_06 p23_06;
drop if p16_06==.;
gen wave6=1;
save "$tempdat\e11_6.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_07 vive_07 p12_07 p13_07 sexo_07 p15_07 p16_07 p17_07 p18_07 p19_07 p20_07 p21_07 p22_07
p22_1_07 p22_2_07 p23_07;
drop if p16_07==.;
gen wave7=1;
save "$tempdat\e11_7.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_08 vive_08 p12_08 p13_08 sexo_08 p15_08 p16_08 p17_08 p18_08 p19_08 p20_08 p21_08 p22_08
p22_1_08 p22_2_08 p23_08;
drop if p16_08==.;
gen wave8=1;
save "$tempdat\e11_8.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_09 vive_09 p12_09 p13_09 sexo_09 p15_09 p16_09 p17_09 p18_09 p19_09 p20_09 p21_09 p22_09
p22_1_09 p22_2_09 p23_09;
drop if p16_09==.;
gen wave9=1;
save "$tempdat\e11_9.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_10 vive_10 p12_10 p13_10 sexo_10 p15_10 p16_10 p17_10 p18_10 p19_10 p20_10 p21_10 p22_10
p22_1_10 p22_2_10 p23_10;
drop if p16_10==.;
gen wave10=1;
save "$tempdat\e11_10.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_11 vive_11 p12_11 p13_11 sexo_11 p15_11 p16_11 p17_11 p18_11 p19_11 p20_11 p21_11 p22_11
p22_1_11 p22_2_11 p23_11;
drop if p16_11==.;
gen wave11=1;
save "$tempdat\e11_11.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_12 vive_12 p12_12 p13_12 sexo_12 p15_12 p16_12 p17_12 p18_12 p19_12 p20_12 p21_12 p22_12
p22_1_12 p22_2_12 p23_12;
drop if p16_12==.;
gen wave12=1;
save "$tempdat\e11_12.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_13 vive_13 p12_13 p13_13 sexo_13 p15_13 p16_13 p17_13 p18_13 p19_13 p20_13 p21_13 p22_13
p22_1_13 p22_2_13 p23_13;
drop if p16_13==.;
gen wave13=1;
save "$tempdat\e11_13.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_14 vive_14 p12_14 p13_14 sexo_14 p15_14 p16_14 p17_14 p18_14 p19_14 p20_14 p21_14 p22_14
p22_1_14 p22_2_14 p23_14;
drop if p16_14==.;
gen wave14=1;
save "$tempdat\e11_14.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_15 vive_15 p12_15 p13_15 sexo_15 p15_15 p16_15 p17_15 p18_15 p19_15 p20_15 p21_15 p22_15
p22_1_15 p22_2_15 p23_15;
drop if p16_15==.;
gen wave15=1;
save "$tempdat\e11_15.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_16 vive_16 p12_16 p13_16 sexo_16 p15_16 p16_16 p17_16 p18_16 p19_16 p20_16 p21_16 p22_16
p22_1_16 p22_2_16 p23_16;
drop if p16_16==.;
gen wave16=1;
save "$tempdat\e11_16.dta", replace; 

use "$tempdat\e11_todo.dta", clear;
keep idllave entrvd  p11_17 vive_17 p12_17 p13_17 sexo_17 p15_17 p16_17 p17_17 p18_17 p19_17 p20_17 p21_17 p22_17
p22_1_17 p22_2_17 p23_17;
drop if p16_17==.;
gen wave17=1;
save "$tempdat\e11_17.dta", replace; 


use "$tempdat\e11_1.dta", clear;
forvalues i=2/17 {;
append using "$tempdat\e11_`i'.dta";
};
 
 
gen miembro=1 if wave1==1;
 forvalues i=2/17 {;
replace miembro=`i' if wave`i'==1;
}; 

gen str nombre="";
 forvalues i=1/9 {;
replace nombre=p11_0`i' if p11_0`i'!="" & miembro==`i';
}; 
 forvalues i=10/17 {;
replace nombre=p11_`i' if p11_`i'!="" & miembro==`i';
}; 
 
gen vivh=.;
forvalues i=1/9 {;
replace vivh=1 if vive_0`i'==1 &  miembro==`i';
replace vivh=0 if vive_0`i'==2 &  miembro==`i';
}; 
forvalues i=10/17 {;
replace vivh=1 if vive_`i'==1 &  miembro==`i';
replace vivh=0 if vive_`i'==2 &  miembro==`i';
}; 

gen meses_nvh=.;
forvalues i=1/9 {;
replace meses_nvh=p12_0`i' if p12_0`i'!=99  &  miembro==`i';
}; 
forvalues i=10/17 {;
replace meses_nvh=p12_`i' if p12_`i'!=99  &  miembro==`i';
}; 

gen sexo=.;
forvalues i=1/9 {;
replace sexo=1 if sexo_0`i'==1 & miembro==`i';
replace sexo=0 if sexo_0`i'==2 & miembro==`i';
}; 
forvalues i=10/17 {;
replace sexo=1 if sexo_`i'==1 & miembro==`i';
replace sexo=0 if sexo_`i'==2 & miembro==`i';
}; 

gen edad=.;
forvalues i=1/9 {;
replace edad=p15_0`i' if p15_0`i'!=98  & p15_0`i'!=99 & miembro==`i';
}; 
forvalues i=10/17 {;
replace edad=p15_`i' if p15_`i'!=98  & p15_`i'!=99 & miembro==`i';
}; 

gen parentes_ent=.;
forvalues i=1/9 {;
replace parentes_ent=p16_0`i' if p16_0`i'!=99  &  miembro==`i';
}; 
forvalues i=10/17 {;
replace parentes_ent=p16_`i' if p16_`i'!=99  &  miembro==`i';
}; 

gen parentes_noent=.;
forvalues i=1/9 {;
replace parentes_noent=p17_0`i' if p17_0`i'!=99  &  miembro==`i';
}; 
forvalues i=10/17 {;
replace parentes_noent=p17_`i' if p17_`i'!=99  &  miembro==`i';
}; 

******ESCOLARIDAD*********;
gen escol=.;

forvalues i=1/9 {;
replace escol=0 if (p18_0`i'==1  | p18_0`i'==97)  &  miembro==`i';
replace escol=1 if (p18_0`i'==2 & (p19_0`i'==1)) | (p18_0`i'==8 & (p19_0`i'==1));
replace escol=2 if (p18_0`i'==2 & (p19_0`i'==2)) | (p18_0`i'==8 & (p19_0`i'==2));
replace escol=3 if (p18_0`i'==2 & (p19_0`i'==3)) | (p18_0`i'==8 & (p19_0`i'==3));
replace escol=4 if (p18_0`i'==2 & (p19_0`i'==4)) | (p18_0`i'==8 & (p19_0`i'==4));
replace escol=5 if (p18_0`i'==2 & (p19_0`i'==5)) | (p18_0`i'==8 & (p19_0`i'==5));
replace escol=6 if (p18_0`i'==2 & p19_0`i'>=6 & p19_0`i'<97) | (p18_0`i'==8 & p19_0`i'>=6 & p19_0`i'<97);
replace escol=7 if (p18_0`i'==3 & (p19_0`i'==1)) | (p18_0`i'==4 & (p19_0`i'==1))| (p18_0`i'==9 & (p19_0`i'==1));
replace escol=8 if (p18_0`i'==3 & (p19_0`i'==2)) | (p18_0`i'==4 & (p19_0`i'==2))| (p18_0`i'==9 & (p19_0`i'==2));
replace escol=9 if (p18_0`i'==3 & p19_0`i'>=3 & p19_0`i'<97) | (p18_0`i'==4 & p19_0`i'>=3 & p19_0`i'<97)|
 (p18_0`i'==9 & p19_0`i'>=3 & p19_0`i'<97);
replace escol=10 if (p18_0`i'==5 & (p19_0`i'==1)) | (p18_0`i'==6 & (p19_0`i'==1))| (p18_0`i'==7 & (p19_0`i'==1));
replace escol=11 if (p18_0`i'==5 & (p19_0`i'==2)) | (p18_0`i'==6 & (p19_0`i'==2))| (p18_0`i'==7 & (p19_0`i'==2));
replace escol=12 if (p18_0`i'==5 & p19_0`i'>=3 & p19_0`i'<97) | (p18_0`i'==6 & p19_0`i'>=3 & p19_0`i'<97)
| (p18_0`i'==7 & p19_0`i'>=3 & p19_0`i'<97);
replace escol=13 if (p18_0`i'==10 & (p19_0`i'==1));
replace escol=14 if (p18_0`i'==10 & (p19_0`i'==2));
replace escol=15 if (p18_0`i'==10 & (p19_0`i'==3));
replace escol=16 if (p18_0`i'==10 & (p19_0`i'==4));
replace escol=17 if (p18_0`i'==10 &  p19_0`i'>=5 & p19_0`i'<97);
replace escol=18 if (p18_0`i'==11 & (p19_0`i'==1));
replace escol=19 if (p18_0`i'==11 & (p19_0`i'==2));
replace escol=20 if (p18_0`i'==11 & p19_0`i'>=3 & p19_0`i'<97);
}; 

forvalues i=10/17 {;
replace escol=0 if (p18_`i'==1  |  p18_`i'==97)  &  miembro==`i';
replace escol=1 if (p18_`i'==2 & (p19_`i'==1)) | (p18_`i'==8 & (p19_`i'==1));
replace escol=2 if (p18_`i'==2 & (p19_`i'==2)) | (p18_`i'==8 & (p19_`i'==2));
replace escol=3 if (p18_`i'==2 & (p19_`i'==3)) | (p18_`i'==8 & (p19_`i'==3));
replace escol=4 if (p18_`i'==2 & (p19_`i'==4)) | (p18_`i'==8 & (p19_`i'==4));
replace escol=5 if (p18_`i'==2 & (p19_`i'==5)) | (p18_`i'==8 & (p19_`i'==5));
replace escol=6 if (p18_`i'==2 & p19_`i'>=6 & p19_`i'<97) | (p18_`i'==8 & p19_`i'>=6 & p19_`i'<97);
replace escol=7 if (p18_`i'==3 & (p19_`i'==1)) | (p18_`i'==4 & (p19_`i'==1))| (p18_`i'==9 & (p19_`i'==1));
replace escol=8 if (p18_`i'==3 & (p19_`i'==2)) | (p18_`i'==4 & (p19_`i'==2))| (p18_`i'==9 & (p19_`i'==2));
replace escol=9 if (p18_`i'==3 & p19_`i'>=3 & p19_`i'<97) | (p18_`i'==4 & p19_`i'>=3 & p19_`i'<97)|
 (p18_`i'==9 & p19_`i'>=3 & p19_`i'<97);
replace escol=10 if (p18_`i'==5 & (p19_`i'==1)) | (p18_`i'==6 & (p19_`i'==1))| (p18_`i'==7 & (p19_`i'==1));
replace escol=11 if (p18_`i'==5 & (p19_`i'==2)) | (p18_`i'==6 & (p19_`i'==2))| (p18_`i'==7 & (p19_`i'==2));
replace escol=12 if (p18_`i'==5 & p19_`i'>=3 & p19_`i'<97) | (p18_`i'==6 & p19_`i'>=3 & p19_`i'<97)
| (p18_`i'==7 & p19_`i'>=3 & p19_`i'<97);
replace escol=13 if (p18_`i'==10 & (p19_`i'==1));
replace escol=14 if (p18_`i'==10 & (p19_`i'==2));
replace escol=15 if (p18_`i'==10 & (p19_`i'==3));
replace escol=16 if (p18_`i'==10 & (p19_`i'==4));
replace escol=17 if (p18_`i'==10 & p19_`i'>=5 & p19_`i'<97);
replace escol=18 if (p18_`i'==11 & (p19_`i'==1));
replace escol=19 if (p18_`i'==11 & (p19_`i'==2));
replace escol=20 if (p18_`i'==11 & p19_`i'>=3 & p19_`i'<97);
}; 

gen trabaj=.;

forvalues i=1/9 {;
replace trabaj=1 if (p21_0`i'==1 |p21_0`i'==2 | p21_0`i'==3 | p21_0`i'==7 | 
p21_0`i'==8   &  miembro==`i');
replace trabaj=0 if (p21_0`i'==4 |p21_0`i'==5 | p21_0`i'==6 | p21_0`i'==9 | 
 p21_0`i'==10 | p21_0`i'==11   &  miembro==`i');
}; 

forvalues i=10/17 {;
replace trabaj=1 if (p21_`i'==1 |p21_`i'==2 | p21_`i'==3 | p21_`i'==7 | 
p21_`i'==8   &  miembro==`i');
replace trabaj=0 if (p21_`i'==4 |p21_`i'==5 | p21_`i'==6 | p21_`i'==9 | 
 p21_`i'==10 | p21_`i'==11   &  miembro==`i');
}; 

gen estud=.; 
forvalues i=1/9 {;
replace estud=1 if (p21_0`i'==6  &  miembro==`i');
replace estud=0 if (p21_0`i'!=6  & p21_0`i'!=. & miembro==`i');
};

forvalues i=10/17 {;
replace estud=1 if (p21_`i'==6  &  miembro==`i');
replace estud=0 if (p21_`i'!=6  & p21_`i'!=. & miembro==`i');
};

gen trab_srteb=.; 
forvalues i=1/9 {;
replace trab_srteb=1 if (p21_0`i'==2  &  miembro==`i');
replace trab_srteb=0 if (p21_0`i'!=2  & p21_0`i'!=. & miembro==`i');
};

forvalues i=10/17 {;
replace trab_srteb=1 if (p21_`i'==2  &  miembro==`i');
replace trab_srteb=0 if (p21_`i'!=2  & p21_`i'!=. & miembro==`i');
};

gen trabaj_medt=.;

forvalues i=1/9 {;
replace trabaj_medt=1 if (p21_0`i'==7   &  miembro==`i');
replace trabaj_medt=0 if (p21_0`i'!=7  & p21_0`i'!=. & miembro==`i');
}; 

forvalues i=10/17 {;
replace trabaj_medt=1 if (p21_`i'==7 &  miembro==`i');
replace trabaj_medt=0 if (p21_`i'!=7  & p21_`i'!=. & miembro==`i');
}; 

sort idllave miembro;
keep idllave miembro entrvd nombre vivh meses_nvh sexo edad parentes_ent 
parentes_noent escol trabaj estud trab_srteb trabaj_medt;

gen entv_jhog=1 if parentes_ent==1  & parentes_noent==.;
replace  entv_jhog=0 if parentes_ent==1  & parentes_noent!=.;

gen miemb_entr=1 if parentes_ent==1;
replace miemb_entr=0 if parentes_ent!=1;

gen sexo_entr=1 if sexo==1 & miemb_entr==1;
replace sexo_entr=0 if sexo==0 & miemb_entr==1;

gen tipo_entr=1 if entv_jhog==1 & sexo_entr==1;
replace tipo_entr=2 if entv_jhog==1 & sexo_entr==0;
replace tipo_entr=3 if entv_jhog==0 & sexo_entr==1;
replace tipo_entr=4 if entv_jhog==0 & sexo_entr==0;

label var miembro "Código de miembro en el hogar";
label var nombre "Nombre del entrevistado";
label var vivh "Miembro vive en el hogar";
label var meses_nvh "Meses que no vive en el hogar";
label var sexo "Sexo de la persona";
label var edad "Edad de la persona";
label var parentes_ent "Parentesco respecto al entrevistado";
label var parentes_noent "Parentesco respecto al jefe de hogar";
label var escol "Años de escolaridad";
label var trabaj "La persona trabaja";
label var estud "La persona es estudiante";
label var trab_srteb "La persona es trabajador sin retribución";
label var trabaj_medt "La persona es trabajador de medio tiempo";
label var entv_jhog "El entrevistado es jefe de hogar";
label var miemb_entr "La persona es el entrevistado";
label var sexo_entr "Sexo del entrevistado";
label var tipo_entr "Tipo de entrevistado";
label define tipo_entr 1 "Entrevistado jefe de hogar" 2 "Entrevistada jefe de hogar"
3 "Entrevistado no jefe de hogar" 4 "Entrevistada no jefe de hogar";
label values tipo_entr tipo_entr;

save "$tempdat\miemb_emovi2011.dta", replace; 

log close;
