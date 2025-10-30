
use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\final data\labor_electricity_merged.dta", clear

tab Industry_group

gen water_interaction = post_deregulation * Capacity_Water
gen coal_interaction = post_deregulation * Capacity_Coal


drop if year > 2008

drop x

gen x = "Non Deregulated"

foreach state in "CA" "CT" "DE" "DC" "IL" "ME" "MD" "MA" "MI" "NH" "NJ" "NY" "OH" "OR" "PA" "RI" "TX" {
    replace x = "Deregulated" if State == "`state'"
}

encode x, gen(treated_deregulation)
drop x

drop treated_der

**************
*manufacturing
**************




preserve 


sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Manufacturing"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 0.87 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(6(0.5)8) yscale(range(6 8))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_manufacturing.png", as(png) name("Graph") replace

restore


******Services


preserve 


sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Services"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 1.14 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(7(0.5)9) yscale(range(7 9))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_services.png", as(png) name("Graph") replace

restore


****Primary Sector


preserve 

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Primary Sector"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 0.69 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(5(0.5)7) yscale(range(5 7)) 
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_primary_sector.png", as(png) name("Graph") replace


restore


**************
*manufacturing high coal counties
**************

sum Capacity_Coal if year == 1992, d


preserve 

keep if Capacity_Coal > 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Manufacturing"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 0.47 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(6(0.5)8) yscale(range(6 8))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_manufacturing_high_coal.png", as(png) name("Graph") replace

restore


**************
*manufacturing low coal counties
**************

preserve 

keep if Capacity_Coal < 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Manufacturing"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 1.66 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(6(0.5)8) yscale(range(6 8))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_manufacturing_low_coal.png", as(png) name("Graph") replace

restore




**************
*service high coal counties
**************

sum Capacity_Coal if year == 1992, d


preserve 

keep if Capacity_Coal > 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Services"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 0.7 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(7(0.5)9) yscale(range(7 9))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_service_high_coal.png", as(png) name("Graph") replace

restore




**************
*service low coal counties
**************

preserve 

keep if Capacity_Coal < 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Services"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 1.79 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(7(0.5)9) yscale(range(7 9))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_service_low_coal.png", as(png) name("Graph") replace

restore






**************
*primary sector high coal counties
**************

sum Capacity_Coal if year == 1992, d


preserve 

keep if Capacity_Coal > 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Primary Sector"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 0.33 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(5.5(0.5)7.5) yscale(range(5.5 7.5))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_primary_high_coal.png", as(png) name("Graph") replace

restore




**************
*service low coal counties
**************

preserve 

keep if Capacity_Coal < 0.38

sort County_State Industry_group year
drop if County_State == County_State[_n-1] & year == year[_n-1] & Industry_group == Industry_group[_n-1]
keep if Industry_group == "Primary Sector"

bysort treated_der: sum Employment_by_group if year == 1999

replace Employment_by_group = Employment_by_group - 1.1 if treated_der == 1

lgraph Employment_by_group year, by(treated_der) errortype(ci(90)) ylabel(5.5(0.5)7.5) yscale(range(5.5 7.5))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\reduced_form_primary_low_coal.png", as(png) name("Graph") replace

restore