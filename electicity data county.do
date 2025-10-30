use "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\energy data\county data\electricity data county.dta", clear

merge m:1 County State using "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\data\energy data\energy mix 1990\energy mix 1990 county.dta"

keep if _m == 3
drop _m

encode State, gen(State_id)

egen cluster_state_post = group(State_id post_deregulation)

drop if strpos(County, "-") > 0
keep if year > 1991

egen state_year_id = group(State_id year)

gen x = "Non Deregulated"

foreach state in "CA" "CT" "DE" "DC" "IL" "ME" "MD" "MA" "MI" "NH" "NJ" "NY" "OH" "OR" "PA" "RI" "TX" {
    replace x = "Deregulated" if State == "`state'"
}

encode x, gen(treated_deregulation)
drop x

drop if year > 2008

sort State_id year rate_electricity
drop if State_id == State_id[_n-1] & year == year[_n-1] & rate_electricity == rate_electricity[_n-1]


preserve
replace rate_electricity = rate_electricity - 12 if treated_der == 1

bysort treated_der: sum rate_electricity if year == 2008

lgraph rate_electricity year, by(treated_dere) ylabel(0(25)100) ytitle("Electricity Price ($/Mw)") xtitle("Year") plotregion(color(white)) errortype(ci(90))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\County Electricity Prices Deregulated Markets.png", as(png) name("Graph") replace
restore

sum Capacity_Coal, d

preserve
replace rate_electricity = rate_electricity - 6.2 if treated_der == 1
keep if Capacity_Coal > 0.31

lgraph rate_electricity year, by(treated_dere) ylabel(0(25)100)  ytitle("Electricity Price ($/Mw)") xtitle("Year") plotregion(color(white)) errortype(ci(90))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\County Electricity Prices Deregulated Markets High Coal.png", as(png) name("Graph") replace
restore

preserve

replace rate_electricity = rate_electricity - 20.8 if treated_der == 1
keep if Capacity_Coal < 0.31

lgraph rate_electricity year, by(treated_dere) ylabel(0(25)150) ytitle("Electricity Price ($/Mw)") xtitle("Year") plotregion(color(white)) errortype(ci(90))
graph export "C:\Users\nicco\OneDrive\Desktop\Industry occupation electricity prices\results\figures\County Electricity Prices Deregulated Markets Low Coal.png", as(png) name("Graph") replace
restore
