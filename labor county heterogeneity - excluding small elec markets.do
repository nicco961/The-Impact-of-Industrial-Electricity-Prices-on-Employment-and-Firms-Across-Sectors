
use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\final data\labor_electricity_merged.dta", clear


***set scheme cleanplot, permanently
***set scheme plottig, permanently

tab Industry_group

replace post_deregulation = 1 if treated_der == 1 & year > 2000

gen coal_interaction = post_deregulation * Capacity_Coal

drop if year > 2008 


drop if counties_per_utility < 4



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

ivreghdfe Employment_by_group (rate_electricity = i.post_deregulation c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster) first
eststo ev1_manufacturing


ivreghdfe Establishment_by_group (rate_electricity = i.post_deregulation  c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster)
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

ivreghdfe Employment_by_group (rate_electricity = i.post_deregulation c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster) first
eststo ev1_service


ivreghdfe Establishment_by_group (rate_electricity = i.post_deregulation  c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster)
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


ivreghdfe Employment_by_group (rate_electricity = i.post_deregulation c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster) first
eststo ev1_primary


ivreghdfe Establishment_by_group (rate_electricity = i.post_deregulation  c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility_cluster)
eststo ev3_primary


restore



* Export Regression Table with-stage F-statistics
esttab ev1_manufacturing ev3_manufacturing using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\IV results excl small elec markets\iv_manufacturing.tex", replace tex keep(rate_electricity) p star(* 0.1 ** 0.05 *** 0.01) 



* Export Regression Table with-stage F-statistics
esttab ev1_service ev3_service using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\IV results excl small elec markets\iv_services.tex", replace tex keep(rate_electricity) p star(* 0.1 ** 0.05 *** 0.01) 



* Export Regression Table with-stage F-statistics
esttab ev1_primary ev3_primary using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\IV results excl small elec markets\iv_primary_sector.tex", replace tex keep(rate_electricity) p star(* 0.1 ** 0.05 *** 0.01) 



