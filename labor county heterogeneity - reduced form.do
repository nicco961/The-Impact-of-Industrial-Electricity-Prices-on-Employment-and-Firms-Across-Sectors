
use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\final data\labor_electricity_merged.dta", clear


***set scheme cleanplot, permanently
***set scheme plottig, permanently

tab Industry_group

replace post_deregulation = 1 if treated_der == 1 & year > 2000

gen coal_interaction = post_deregulation * Capacity_Coal

drop if year > 2008


replace rate_electricity = log(rate_electricity)

**************
*manufacturing
**************


****IV regressions************


preserve 

keep if x > 25
keep if Industry_group == "Manufacturing"
tab Industry

sort County_State year Industry
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]

reghdfe Employment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev1_manufacturing


reghdfe Establishment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev3_manufacturing


restore


**************
*Services
**************


preserve 

keep if x > 25

keep if Industry_group == "Services"


sort County_State year Industry
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]

reghdfe Employment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev1_service


reghdfe Establishment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev3_service



restore


**************
*Primary Sector
**************


preserve 

keep if x > 25

keep if Industry_group == "Primary Sector"

sort County_State year Industry
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]

reghdfe Employment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev1_primary_sector


reghdfe Establishment_by_group post_deregulation coal_interaction population_pers, absorb(year County_State) cluster(utility)
eststo ev3_primary_sector


restore



* Export Regression Table with-stage F-statistics
esttab ev1_manufacturing ev3_manufacturing using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\OLS results\rf_manufacturing.tex", replace tex keep(post_deregulation coal_interaction) p star(* 0.1 ** 0.05 *** 0.01) 



* Export Regression Table with-stage F-statistics
esttab ev1_service ev3_service using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\OLS results\rf_services.tex", replace tex keep(post_deregulation coal_interaction) p star(* 0.1 ** 0.05 *** 0.01) 



* Export Regression Table with-stage F-statistics
esttab ev1_primary_sector ev3_primary_sector using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\OLS results\rf_primary_sector.tex", replace tex keep(post_deregulation coal_interaction) p star(* 0.1 ** 0.05 *** 0.01) 



