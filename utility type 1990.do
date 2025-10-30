import excel "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\raw data\county electricity price data\sales data\Sales_Ult_Cust_1990.xlsx", sheet("States") cellrange(A3:S3272) firstrow clear

destring DataYear, replace
destring R S Q, replace
gen rate_electricity = Q/R
drop if S<1000
keep DataYear UtilityNumber UtilityName State R S Q rate_electricity
rename Q revenues
rename R sales
rename S costumers
sort DataYear UtilityNumber UtilityName State
drop if UtilityNumber == UtilityNumber[_n-1] & State == State[_n-1]

merge m:1 UtilityNumber State using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\energy data\yearly data\service type\2001_investor_bundled_utilities.dta"

drop if State == "HI" | State == "AK"

replace Ownership = "Public Owned" if Ownership == ""
drop if _m == 2

gen count = 1

collapse (sum) sales count costumers, by(Ownership)

rename count number_utilities
replace sales = sales/1000000

rename sales sales_electricity_Tw
