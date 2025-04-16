class SearchHelperTransformer {
  static bool matchesTransformerQuery(
      Map<String, dynamic> transformer, String query) {
    query = query.toLowerCase();
    return _transformerMatchesQuery(transformer, query);
  }

  static bool _transformerMatchesQuery(
      Map<String, dynamic> transformer, String query) {
    // Check all possible fields in the transformer data
    return transformer.values.any((value) =>
        value != null && value.toString().toLowerCase().contains(query));
  }
}
