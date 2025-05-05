class SearchHelperBattery {
  static bool matchesBatteryQuery(Map<String, dynamic> battery, String query) {
    query = query.toLowerCase();
    return _batteryMatchesQuery(battery, query);
  }

  static bool _batteryMatchesQuery(Map<String, dynamic> battery, String query) {
    // Check all possible fields in the battery data
    return battery.values.any((value) =>
    value != null && value.toString().toLowerCase().contains(query));
  }
}