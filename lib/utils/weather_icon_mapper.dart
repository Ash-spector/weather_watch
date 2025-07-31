String getIconForCondition(String condition) {
  condition = condition.toLowerCase();

  if (condition.contains('clear')) return 'assets/icons/sun.png';
  if (condition.contains('cloud') || condition.contains('overcast')) return 'assets/icons/cloud_day.png';
  if (condition.contains('rain')) return 'assets/icons/rain.png';

  // fallback icon
  return 'assets/icons/cloud_day.png';
}
