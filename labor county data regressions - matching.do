
use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\final data\labor_electricity_merged.dta", clear

keep if x > 25

tab post_deregulation treated_der

gen coal_interaction = post_deregulation * Capacity_Coal


drop if year > 2008


keep if nnm == 1

replace rate_electricity = log(rate_electricity)


****IV regressions************




 

keep if x > 25
tab Industry

sort County_State year
drop if County_State == County_State[_n-1] & year == year[_n-1] 

ivreghdfe Employment_by_county (rate_electricity = i.post_deregulation c.coal_interaction) population_pers [_aweight = population_1990], absorb(year County_State) cluster(utility) first
eststo ev1


ivreghdfe Establishment_by_county (rate_electricity = i.post_deregulation  c.coal_interaction) population_pers  [_aweight = population_1990], absorb(year County_State) cluster(utility)
eststo ev3



* Export Regression Table with First-stage F-statistics
esttab ev1 ev3 using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables\Matching\iv_all_sectors.tex", replace tex keep(rate_electricity) p star(* 0.1 ** 0.05 *** 0.01) 

