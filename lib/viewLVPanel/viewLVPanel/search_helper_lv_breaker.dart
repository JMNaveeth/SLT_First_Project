class SearchHelperLVBreaker {
  static bool matchesLVBreakerQuery(Map<String, dynamic> breaker, String query) {
    query = query.toLowerCase();
    return _lvBreakerMatchesQuery(breaker, query);
  }

  static bool _lvBreakerMatchesQuery(Map<String, dynamic> breaker, String query) {
    // Check all possible fields in the LV Breaker data
    return breaker.values.any((value) =>
    value != null && value.toString().toLowerCase().contains(query));
  }
}