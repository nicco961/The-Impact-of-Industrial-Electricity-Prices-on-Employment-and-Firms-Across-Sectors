set.seed(123)

compute_rho <- function(eps_L, eps_E, eps_w) {
  f <- function(rho) {
    eps_E + eps_w / (rho - 1) + 1 / (1 - rho) - eps_L
  }
  tryCatch({
    uniroot(f, interval = c(-10, 0.99))$root
  }, error = function(e) NA)
}

run_mc_simulation <- function(n,
                              eps_L_mean, eps_L_se,
                              eps_E_mean, eps_E_se,
                              eps_w_mean, eps_w_se) {
  rho_vals <- numeric(n)
  sigma_vals <- numeric(n)
  
  for (i in 1:n) {
    eps_L <- rnorm(1, eps_L_mean, eps_L_se)
    eps_E <- rnorm(1, eps_E_mean, eps_E_se)
    eps_w <- rnorm(1, eps_w_mean, eps_w_se)
    
    rho <- compute_rho(eps_L, eps_E, eps_w)
    rho_vals[i] <- rho
    sigma_vals[i] <- ifelse(!is.na(rho), 1/(1 - rho), NA)
  }
  
  rho_vals <- na.omit(rho_vals)
  sigma_vals <- na.omit(sigma_vals)
  
  list(
    rho_median = median(rho_vals),
    rho_ci_lower = quantile(rho_vals, probs = 0.025),
    rho_ci_upper = quantile(rho_vals, probs = 0.975),
    sigma_median = median(sigma_vals),
    sigma_ci_lower = quantile(sigma_vals, probs = 0.025),
    sigma_ci_upper = quantile(sigma_vals, probs = 0.975)
  )
}

# Manufacturing values
manu_eps_L_mean <- -0.433
manu_eps_L_se <- 0.18

manu_eps_E_mean <- -1.34
manu_eps_E_se <- 0.33

manu_eps_w_mean <- -0.018
manu_eps_w_se <- 0.007

# Service values
serv_eps_L_mean <- 0.067
serv_eps_L_se <- 0.09

serv_eps_E_mean <- -0.56
serv_eps_E_se <- 0.17

serv_eps_w_mean <- 0
serv_eps_w_se <- 0.000001

n_sim <- 1000

manu_res <- run_mc_simulation(n_sim,
                              manu_eps_L_mean, manu_eps_L_se,
                              manu_eps_E_mean, manu_eps_E_se,
                              manu_eps_w_mean, manu_eps_w_se)

serv_res <- run_mc_simulation(n_sim,
                              serv_eps_L_mean, serv_eps_L_se,
                              serv_eps_E_mean, serv_eps_E_se,
                              serv_eps_w_mean, serv_eps_w_se)

latex_table <- c(
  "\\begin{table}[ht]",
  "\\centering",
  "\\caption{Elasticity Inputs and Simulation Results}",
  "\\renewcommand{\\arraystretch}{1.2}",              # increase row height slightly
  "\\resizebox{\\textwidth}{!}{%",                   # scale table to text width
  "\\begin{tabular}{lcc}",
  "\\hline",
  " & \\textbf{Service} & \\textbf{Manufacturing} \\\\",
  "\\hline",
  "\\multicolumn{3}{l}{\\textbf{Panel A: Input Elasticities (mean (SE))}} \\\\",
  paste0("$\\epsilon_{L,P_E}$ & ", sprintf("%.3f (%.3f)", serv_eps_L_mean, serv_eps_L_se), " & ", sprintf("%.3f (%.3f)", manu_eps_L_mean, manu_eps_L_se), " \\\\"),
  paste0("$\\epsilon_{E,P_E}$ & ", sprintf("%.3f (%.3f)", serv_eps_E_mean, serv_eps_E_se), " & ", sprintf("%.3f (%.3f)", manu_eps_E_mean, manu_eps_E_se), " \\\\"),
  paste0("$\\epsilon_{w,P_E}$ & ", sprintf("%.3f (%.6f)", serv_eps_w_mean, serv_eps_w_se), " & ", sprintf("%.3f (%.3f)", manu_eps_w_mean, manu_eps_w_se), " \\\\"),
  "\\hline",
  "\\multicolumn{3}{l}{\\textbf{Panel B: Simulation Results (Median (95\\% CI))}} \\\\",
  paste0("$\\rho$ & ",
         sprintf("%.3f (%.3f, %.3f)", serv_res$rho_median, serv_res$rho_ci_lower, serv_res$rho_ci_upper), " & ",
         sprintf("%.3f (%.3f, %.3f)", manu_res$rho_median, manu_res$rho_ci_lower, manu_res$rho_ci_upper), " \\\\"),
  paste0("$\\sigma = \\frac{1}{1-\\rho}$ & ",
         sprintf("%.3f (%.3f, %.3f)", serv_res$sigma_median, serv_res$sigma_ci_lower, serv_res$sigma_ci_upper), " & ",
         sprintf("%.3f (%.3f, %.3f)", manu_res$sigma_median, manu_res$sigma_ci_lower, manu_res$sigma_ci_upper), " \\\\"),
  "\\hline",
  "\\end{tabular}",
  "}",
  "\\end{table}"
)

filepath <- "C:/Users/nicco/OneDrive/Desktop/Industry occupation electricity prices/results/tables/Simulation/Simulation.tex"

writeLines(latex_table, filepath)

