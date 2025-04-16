import 'ac_details_model.dart';

class SearchHelperAC {
  static bool matchesACQuery(AcLogData log, AcIndoorData? indoor, AcOutdoorData? outdoor, String query) {
    query = query.toLowerCase();
    return _logMatchesQuery(log, query) ||
        (indoor != null && _indoorMatchesQuery(indoor, query)) ||
        (outdoor != null && _outdoorMatchesQuery(outdoor, query));
  }

  static bool _logMatchesQuery(AcLogData log, String query) {
    return (log.region?.toLowerCase() ?? '').contains(query) ||
        (log.rtom?.toLowerCase() ?? '').contains(query) ||
        (log.station?.toLowerCase() ?? '').contains(query) ||
        (log.location?.toLowerCase() ?? '').contains(query) ||
        (log.rtomBuildingId?.toLowerCase() ?? '').contains(query) ||
        (log.floorNumber?.toLowerCase() ?? '').contains(query) ||
        (log.officeNumber?.toLowerCase() ?? '').contains(query);
  }

  static bool _indoorMatchesQuery(AcIndoorData indoor, String query) {
    return (indoor.brand?.toLowerCase() ?? '').contains(query) ||
        (indoor.model?.toLowerCase() ?? '').contains(query) ||
        (indoor.capacity?.toLowerCase() ?? '').contains(query) ||
        (indoor.serialNumber?.toLowerCase() ?? '').contains(query) ||
        (indoor.qrIn?.toLowerCase() ?? '').contains(query) ||
        (indoor.type?.toLowerCase() ?? '').contains(query) ||
        (indoor.category?.toLowerCase() ?? '').contains(query);
  }

  static bool _outdoorMatchesQuery(AcOutdoorData outdoor, String query) {
    return (outdoor.brand?.toLowerCase() ?? '').contains(query) ||
        (outdoor.model?.toLowerCase() ?? '').contains(query) ||
        (outdoor.capacity?.toLowerCase() ?? '').contains(query) ||
        (outdoor.qrOut?.toLowerCase() ?? '').contains(query) ||
        (outdoor.compressorModel?.toLowerCase() ?? '').contains(query) ||
        (outdoor.compressorBrand?.toLowerCase() ?? '').contains(query);
  }
}