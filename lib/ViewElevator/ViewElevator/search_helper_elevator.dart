class SearchHelperElevator {
  static bool matchesElevatorQuery(Map<String, dynamic> elevator, String query) {
    query = query.toLowerCase();
    return _elevatorMatchesQuery(elevator, query);
  }

  static bool _elevatorMatchesQuery(Map<String, dynamic> elevator, String query) {
    // Check all possible fields in the elevator data
    return elevator.values.any((value) =>
    value != null && value.toString().toLowerCase().contains(query));
  }
}