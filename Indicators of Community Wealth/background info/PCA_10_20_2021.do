****  	Manuscript: Stocks of Wealth and the Value-Added Food and Agriculture Sector
****	Code developed by:  
**** 	Alessandro Bonanno (Colorado State University); 
**** 	Todd M. Schmit (Cornell University); 
****	Becca R.B. Jablonski (Colorado State University)
****    John Pender (USDA ERS)
****    Allison Bauman (Colorado State University)
**** 	Last version: August 2021  
****	For ease of exposition, this code includes the final model specifications only 

clear all
set more off
set matsize 800

** Change directory to folder with data files **
use "C:\Users\bjab\Dropbox (Personal)\CSU\Journal Articles\Journal of Agricultural and Resource Economics\2020 - VA NETS paper\R1\capitals_new.dta"
**use "D:\Dropbox\CSU\Journal Articles\Journal of Agricultural and Resource Economics\2020 - VA NETS paper\R1\capitals_new.dta"


*** drop pc1b pc1c pc1f pc1h pc2h pc1n pc2n pc1s pc2s

*** Data sources and detailed variable definitions are available in Table 1 

**** Principal Component Analysis
**** PCA For each Capital follow the same steps 
* 0) Check, for some of the variables, that they are divided by either population, 
* 	 square miles or other suitable variables - check "Stats file" 
* 1) run summary stats and obtain correlation matrix to look for variables that present missing observations 
*	 or those that have very large correlation  - the former will be omitted; the latter may or may not 
* 	 be omitted  - IMPORTANT: check notes for each capital to see what veriable has been omitted and why 
* 2) Run PCA on the final variables (TWICE - first showing all the components and then 
* 	 retaininig the components with eigenvactors greater than 1
* 3) Check rotated components' loadings - this is not important when only one component is retained but it 
* 	 may help assessing what variables "belong" to each component when there are multiple components to be retained 
* 4) save the loadings of the variables in each retained component and check correlation among components

*******************
** BUILT capital **
*******************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
** replace foodbev_est_CBP=10000*foodbev_est_CBP/pop_15_CBP
** replace est_CBP=10000*est_CBP/pop_15_CBP
** replace broad=100*broad_prct
** replace highway_km=1/(highway_popwtdist/1000)

** Incorporate older data
replace broad_11=broad_11*100
replace highway_km=1/(highway_popwtdist/1000) 

** 1 summary stats and eliminate variables (check notes)
global built broad_11 highway_km
*describe $built
*summarize $built
*corr $built
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $built, comp ($ncomp)
pca $built, mineigen (1)

** 3 Component rotations 
rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix builtpromaxloadings=e(r_L)
matrix list builtpromaxloadings
predict pc1b pc2b, score 

**********************
** Cultural capital **
**********************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
** pub_lib create_indus museums art_cult already per 100000 popn so no need to change
** replace create_jobs=100*create_jobs/total_emp
** replace pub_lib=pub_lib
** replace create_indus=create_indus
** replace nonwhite_pop=100*nonwhite_pop/pop_15_CBP 
** replace museums=museums 
** replace art_cult=art_cult
** replace RDI22010=RDI22010

** Incorporate older data
** nonwhite_pop_10 "The data that I found was the percentage of the population that is white and I took 1-the number to get nonwhite. I then divided it by 100 to get a percentage. The numbers in Todd's data set are raw and divided by population, you don't need to do this."
** pub_lib create_indus museums art_cult already per 100000 popn so no need to change 
replace create_jobs=100*create_jobs/total_emp
replace pub_lib=pub_lib
replace create_indus_09=create_indus_09
replace RDI22010=RDI22010
replace museums=museums
replace art_cult=art_cult

** 1 summary stats and eliminate variables (check notes)
global cult pub_lib museums create_jobs create_indus_09 RDI22010
*describe $cult
*summarize $cult
*corr $cult 
/* Note: the variables "museums" and "art_cult" will drop approximately 240 and 290 observations each 
			museums       2,906           1    5.130827   .0001215   159.8119
			art_cult      2,765           1    6.444793   .0026417   225.9223
			 - I decided to drop art_cult and to keep museums;  
			museums and pub_lib are correlated 0.6522  */

** 2 Principal Component Analysis
pca $cult, comp ($ncomp)
pca $cult, mineigen (1)

** 3 Component rotations 
  rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix cultpromaxloadings=e(r_L)
matrix list cultpromaxloadings
predict pc1c pc2c, score 

***********************
** FINANCIAL capital **
***********************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
** replace localgovfin=localgovfin/pop_12
** replace deposits=deposits/pop_15_CBP
** replace owner_occupied=owner_occupied/pop_15_CBP

** Add older data
replace localgovfin_07=localgovfin_07/pop_10_CBP
replace deposits=deposits/pop_15_CBP
replace owner_occupied_2010=owner_occupied_2010/pop_10_CBP


** 1 summary stats and eliminate variables (check notes)
global finan localgovfin owner_occupied deposits 
*describe $finan
*summarize $finan
*corr $finan
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $finan, comp ($ncomp)
pca $finan, mineigen (1)

** 3 Component rotations 
  rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix finanpromaxloadings=e(r_L)
matrix list finanpromaxloadings
predict pc1f, score 

*******************
** HUMAN capital **
*******************
** 0 make sure that all variables are expressed in a per-capita or per-square mile 
** replace ed_attain=100*ed_attain/adult_pop_15
** replace food_secure_rev=100*food_secure_rev
** replace insured_rev=100*insured_rev
** replace primary_care=10000*primary_care/pop_15_CBP

** Add older data
** Note: ed_attain_10 is already a proportion of the adult population. Don't divide by population like is done in the Stata file. 

replace ed_attain_10=ed_attain_10*100
replace food_secure_10=100*food_secure_10
replace insured_10=100*insured_10
replace primary_care_10=10000*primary_care_10/pop_10_CBP

** 1 summary stats and eliminate variables (check notes)
global human health_factor health_outcome food_secure_10 insured_10 ed_attain_10 primary_care_10 
*describe $human
*summarize $human
*corr $human


** 2 Principal Component Analysis
pca $human, comp ($ncomp)
pca $human, mineigen (1)

** 3 Component rotations 
  rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix humanpromaxloadings=e(r_L)
matrix list humanpromaxloadings
predict pc1h pc2h, score 

*********************
** Natural capital **
*********************
** 0 divide by acres 
replace prime_farmland=100*prime_farmland/acres
replace conserve_acre=100*conserve_acre/acre_all
replace acre_FSA = 100*acre_FSA/acre_all
replace acre_NFS = 100*acre_NFS/acre_all

** note no older data to add

** 1 summary stats and eliminate variables (check notes)
global nat natamen_scale acre_NFS prime_farmland conserve_acre acre_FSA  
*describe $nat
*summarize $nat
*corr $nat
/* Note: 	the variable "acre_org" and "crop_div" drop, respectively  circa 450 and 350 observations 
			acre_org 2,593    328.6205    2020.279          0      61159
			crop_div 2,687    4.043728    1.814345          1   21.69364  */

** 2 Principal Component Analysis
pca $nat, comp ($ncomp)
pca $nat, mineigen (1)

** 3 Component rotations 
  rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix natpromaxloadings=e(r_L)
matrix list natpromaxloadings
predict pc1n pc2n, score 

********************
** SOCPOL capital **
********************
** 0 divide nccs14 by 100,000 pop
** replace nccs14=1000*nccs14/pop_14
** replace pvote12=100*pvote12
** replace respn10=100*respn10

** add older data 
replace nccs09=1000*nccs09/pop_10_CBP
replace pvote08=100*pvote08
replace respn10=100*respn10

** 1 summary stats and eliminate variables (check notes)
global socpol assn09 nccs09 pvote08 respn10 
*describe $socpol
*summarize $socpol
*corr $socpol
/* Note: no variables dropped */

** 2 Principal Component Analysis
pca $socpol, comp ($ncomp)
pca $socpol, mineigen (1)

** 3 Component rotations 
  rotate, promax /* oblique */

** 4 Save loadings of the retained components 
matrix socpolpromaxloadings=e(r_L)
matrix list socpolpromaxloadings
predict pc1s pc2s, score 