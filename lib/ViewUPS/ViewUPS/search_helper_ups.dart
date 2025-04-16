class SearchHelperUPS {
  static bool matchesUPSQuery(Map<String, dynamic> ups, String query) {
    query = query.toLowerCase();
    return _upsMatchesQuery(ups, query);
  }

  static bool _upsMatchesQuery(Map<String, dynamic> ups, String query) {
    // Check all possible fields in the UPS data
    return ups.values.any((value) =>
        value != null && value.toString().toLowerCase().contains(query));
  }
}
