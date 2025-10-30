
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



keep if x > 25
tab Industry

sort County_State year
drop if County_State == County_State[_n-1] & year == year[_n-1] 


reghdfe Employment_by_county rate_electricity population_pers, absorb(year County_State) cluster(utility)
eststo ev1


reghdfe Establishment_by_county rate_electricity population_pers, absorb(year County_State) cluster(utility)
eststo ev3





* Export Regression Table with-stage F-statistics
esttab ev1 ev3 using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\OLS results\ols_all_sectors.tex", replace tex keep(rate_electricity) p star(* 0.1 ** 0.05 *** 0.01) 


