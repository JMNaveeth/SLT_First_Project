class SearchHelperSPD {
  static bool matchesSPDQuery(Map<String, dynamic> spd, String query) {
    query = query.toLowerCase();
    return _spdMatchesQuery(spd, query);
  }

  static bool _spdMatchesQuery(Map<String, dynamic> spd, String query) {
    // Check all possible fields in the SPD data
    return spd.values.any((value) =>
        value != null && value.toString().toLowerCase().contains(query));
  }
}
