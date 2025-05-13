class SearchHelperGenerator {
  static bool matchesGeneratorQuery(
      Map<String, dynamic> generator, String query) {
    query = query.toLowerCase();
    return _generatorMatchesQuery(generator, query);
  }

  static bool _generatorMatchesQuery(
      Map<String, dynamic> generator, String query) {
    return generator.values.any((value) =>
        value != null && value.toString().toLowerCase().contains(query));
  }
}
