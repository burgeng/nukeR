compute_zones_local <- function(
    yield_mt = 1.0,
    burst_height_m = 500,
    multipliers = c(0.5, 1, 2, 4, 8)
) {
  if (yield_mt <= 0) stop("Yield must be positive")

  fireball_radius_m <- 900 * (yield_mt)^(1/3)
  fireball_touches_ground <- burst_height_m < fireball_radius_m
  scale_factor <- if (fireball_touches_ground) 0.8 else 1.0
  fallout_factor <- if (fireball_touches_ground) 1.0 else 0.2

  # Metadata describing each illustrative zone
  zone_table <- data.frame(
    zone_id = seq_along(multipliers),
    multiplier = multipliers,
    overpressure_psi = c(50, 20, 10, 5, 2),   # educational, not empirical
    description = c(
      "Fireball / vaporization zone",
      "Severe destruction (reinforced concrete)",
      "Heavy damage (buildings collapse)",
      "Moderate damage (houses destroyed)",
      "Light damage (windows broken)"
    ),
    radius_km = scale_factor * multipliers * (yield_mt)^(1/3)
  )

  list(
    zones = zone_table,
    fireball_touches_ground = fireball_touches_ground,
    fireball_radius_m = fireball_radius_m,
    fallout_factor = fallout_factor
  )
}
