#' bandit posterior
#'
#' Utility function for calculating the posterior probability of each machine being "good" in 
#' two armed bandit problem. Calculated result is based on observed win loss data, prior belief about 
#' which machine is good and the probability of the good and bad machine paying out.
#'
#' @param data data frame containing win loss data
#' @param prior prior vector containing the probabilities of Machine 1 and Machine 2 being good, defaults to 0.5 and 0.5 respectively.
#' @param win_probs vector containing the probabilities of winning on the good and bad machine respectively.
#' @return A vector containing the posterior probability of Machine 1 and Machine 2 being the good machine.
#' @seealso \code{\link{bandit_sim}} to generate data and
#'          \code{\link{plot_bandit_posterior}} to visualize.
#' @examples
#' data = data.frame(machine = c(1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L), 
#'                   outcome = c("W", "L", "W", "L", "L", "W", "L", "L", "L", "W"))
#' bandit_posterior(data)
#' plot_bandit_posterior(data)
#' 
#' @export


bandit_posterior <- function(data, prior = c(m1_good = 0.5, m2_good = 0.5), win_probs = c(good = 1 / 2, bad = 1 / 3)) {
  if (length(names(prior)) == 0) {
    names(prior) <- c("m1_good", "m2_good")
  }
  if (length(names(win_probs)) == 0) {
    names(prior) <- c("good", "bad")
  }

  m1_good_and_data <- prior["m1_good"] * win_probs["good"]^sum(data$machine == 1L & data$outcome == "W") *
    (1 - win_probs["good"])^sum(data$machine == 1L & data$outcome == "L") *
    win_probs["bad"]^sum(data$machine == 2L & data$outcome == "W") *
    (1 - win_probs["bad"])^sum(data$machine == 2L & data$outcome == "L")

  m2_good_and_data <- prior["m2_good"] * win_probs["bad"]^sum(data$machine == 1L & data$outcome == "W") *
    (1 - win_probs["bad"])^sum(data$machine == 1L & data$outcome == "L") *
    win_probs["good"]^sum(data$machine == 2L & data$outcome == "W") *
    (1 - win_probs["good"])^sum(data$machine == 2L & data$outcome == "L")
  return(
    c(
      m1_good_and_data / (m1_good_and_data + m2_good_and_data),
      m2_good_and_data / (m1_good_and_data + m2_good_and_data)
    )
  )
}

#' plot_bandit_posterior
#'
#' Generates a plot that shows the bandit posterior values as they are sequentially updated 
#' by the provided win / loss data.
#'
#' @param data data frame containing win loss data
#' @param prior prior vector containing the probabilities of Machine 1 and Machine 2 being good, defaults to 50-50.
#' @param win_probs vector containing the probabilities of winning on the good and bad machine respectively.
#' @seealso \code{\link{bandit_sim}} to generate data to use below
#'
#' @examples
#' # capture data from the `shiny` app `bandit_sim`.
#' data = data.frame(machine = c(1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 2L, 2L), 
#'                   outcome = c("W", "L", "W", "L", "L", "W", "L", "L", "L", "W"))
#' plot_bandit_posterior(data)
#'
#' @export


plot_bandit_posterior <- function(data,
                                  prior = c(m1_good = 0.5, m2_good = 0.5),
                                  win_probs = c(good = 1 / 2, bad = 1 / 3)) {
  r <- tibble::tibble(
    "P(M1 is good | Data)" = c(prior[["m1_good"]], rep(NA, nrow(data))),
    "P(M2 is good | Data)" = c(prior[["m2_good"]], rep(NA, nrow(data)))
  )

  for (i in 1:nrow(data)) {
    bp <- bandit_posterior(data[1:i, ], prior, win_probs)
    r[i+1, 1] <- bp[["m1_good"]]
    r[i+1, 2] <- bp[["m1_good"]]
  }

  r <- dplyr::mutate(r, play = dplyr::row_number())
  r <- tidyr::gather(r, outcome, prob, -play)

  ggplot(r, aes_string(x = "play", y = "prob", color = "outcome")) +
    geom_line(size = 1.5) +
    labs(x = "Play #", y = "Posterior Prob.") +
    scale_color_manual(values = c("#428bca", "#5cb85c"))
}
