
use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\final data\labor_electricity_merged.dta", clear

***set scheme cleanplot, permanently
***set scheme plottig, permanently

keep if year > 1991

***Summary stats

tab post_deregulation treated_der




preserve


sort County_State year
drop if County_State == County_State[_n-1] & year == year[_n-1]
keep if year == 1992

label variable per_capita_dividends_rent ""
label variable per_capita_income_maintenance ""
label variable per_capita_personal_income ""
label variable per_capita_personal_transfers ""
label variable per_capita_unempl_insurance ""
label variable population_persons ""

keep if nnm != .

keep County State per_capita_dividends_rent per_capita_income_maintenance per_capita_personal_income per_capita_personal_transfers per_capita_unempl_insurance population_persons share_employment_manufacturing treated_der Capacity_Coal Capacity_Gas Capacity_Nuclear Capacity_Oil Capacity_Water



*GENERATE TABLE

cd "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\tables"	


replace per_capita_personal_income = log(per_capita_personal_income)
replace per_capita_unempl_insurance = log(per_capita_unempl_insurance)

bysort treated_der: ci means per_capita_personal_income population_persons share_employment_manufacturing Capacity_Coal Capacity_Gas Capacity_Oil Capacity_Water


esttab using "summary_statistics.tex", ///
    cells("mean sd min max") ///
    label ///
    title("Summary Statistics") ///
    replace


restore
