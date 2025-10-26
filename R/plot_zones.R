#' Plot illustrative blast zones (data frame aware)
#'
#' @param zones data frame from compute_zones_local()$zones
#' @export
plot_zones <- function(zones) {
  stopifnot(is.data.frame(zones))
  library(ggplot2)

  df <- do.call(rbind, lapply(seq_len(nrow(zones)), function(i) {
    theta <- seq(0, 2 * pi, length.out = 200)
    data.frame(
      x = zones$radius_km[i] * cos(theta),
      y = zones$radius_km[i] * sin(theta),
      zone = zones$description[i],
      overpressure = zones$overpressure_psi[i]
    )
  }))

  ggplot(df, aes(x, y, fill = zone)) +
    geom_polygon(alpha = 0.25, color = "black") +
    coord_equal() +
    labs(
      x = "Distance (km, illustrative only)",
      y = "Distance (km, illustrative only)",
      fill = "Damage Zone",
      title = "Illustrative Blast Zones"
    ) +
    theme_minimal()
}
