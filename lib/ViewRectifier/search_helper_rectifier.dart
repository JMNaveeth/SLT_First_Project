class SearchHelperRectifier {
  static bool matchesRectifierQuery(Map<String, dynamic> rectifier, String query) {
    query = query.toLowerCase();
    return _rectifierMatchesQuery(rectifier, query);
  }

  static bool _rectifierMatchesQuery(Map<String, dynamic> rectifier, String query) {
    // Check all possible fields in the rectifier data
    return rectifier.values.any((value) =>
    value != null && value.toString().toLowerCase().contains(query));
  }
}