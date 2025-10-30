rho_sigma_delta_cov <- function(eps_L_pE, eps_E_pE, eps_w_pE,
                                se_eps_L_pE, se_eps_E_pE, se_eps_w_pE,
                                corr_ab = 0) {
  a <- eps_L_pE
  b <- eps_E_pE
  c <- eps_w_pE
  
  # Estimates
  rho_hat   <- 1 + (c - 1) / (a - b)
  sigma_hat <- -(a - b) / (c - 1)
  
  # Gradient vectors
  grad_rho   <- c(-(c - 1) / (a - b)^2,
                  (c - 1) / (a - b)^2,
                  1 / (a - b))
  grad_sigma <- c(-1 / (c - 1),
                  1 / (c - 1),
                  (a - b) / (c - 1)^2)
  
  # Variance-covariance matrix of (a,b,c)
  var_a <- se_eps_L_pE^2
  var_b <- se_eps_E_pE^2
  var_c <- se_eps_w_pE^2
  cov_ab <- corr_ab * se_eps_L_pE * se_eps_E_pE
  
  Sigma <- matrix(c(var_a, cov_ab, 0,
                    cov_ab, var_b, 0,
                    0,      0,     var_c),
                  nrow = 3, byrow = TRUE)
  
  # Delta method variances
  var_rho   <- t(grad_rho)   %*% Sigma %*% grad_rho
  var_sigma <- t(grad_sigma) %*% Sigma %*% grad_sigma
  
  se_rho   <- sqrt(var_rho)
  se_sigma <- sqrt(var_sigma)
  
  # 95% confidence intervals
  z <- 1.96
  rho_ci   <- c(rho_hat - z * se_rho, rho_hat + z * se_rho)
  sigma_ci <- c(sigma_hat - z * se_sigma, sigma_hat + z * se_sigma)
  
  return(list(
    rho = rho_hat,
    se_rho = se_rho,
    rho_CI95 = rho_ci,
    sigma = sigma_hat,
    se_sigma = se_sigma,
    sigma_CI95 = sigma_ci
  ))
}



# services
rho_sigma_delta_cov(
  eps_L_pE = 0.067, se_eps_L_pE = 0.09,
  eps_E_pE = -0.56, se_eps_E_pE = 0.17,
  eps_w_pE =  0, se_eps_w_pE = 0,
  corr_ab = 0.05
)

#manufacturing
rho_sigma_delta_cov(
  eps_L_pE = -0.433, se_eps_L_pE = 0.18,
  eps_E_pE = -1.34, se_eps_E_pE = 0.33,
  eps_w_pE =  -0.018, se_eps_w_pE = 0.007,
  corr_ab = 0.5
)







