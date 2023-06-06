// Turn given value into percentage. If min and max are the same returns 0. Returns 0 if value
// is below min, returns 100 if value is above max
func valueToPercentage(_ val: Float, min: Float, max: Float) -> Float {
  if min == max {
    return 0
  }
  var percentage = (val - min) / (max - min) * 100
  if percentage < 0 {
    percentage = 0
  } else if percentage > 100 {
    percentage = 100
  }
  return percentage
}

// Turn given percantage into value. Returns min if percent <= 0, returns max if percent >= 100
func percentageToValue(_ percentage: Float, min: Float, max: Float) -> Float {
  if percentage <= 0 {
    return min
  } else if percentage >= 100 {
    return max
  }
  return (percentage / 100) * (max - min) + min
}
