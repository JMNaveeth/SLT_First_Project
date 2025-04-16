import 'PrecisionAcViewCustom.dart';

class SearchHelperPrecisionAC {
  static bool matchesPrecisionACQuery(PrecisionAC ac, String query) {
    query = query.toLowerCase();
    return _precisionACMatchesQuery(ac, query);
  }

  static bool _precisionACMatchesQuery(PrecisionAC ac, String query) {
    return (ac.precisionACId?.toLowerCase() ?? '').contains(query) ||
        (ac.region?.toLowerCase() ?? '').contains(query) ||
        (ac.rtom?.toLowerCase() ?? '').contains(query) ||
        (ac.station?.toLowerCase() ?? '').contains(query) ||
        (ac.location?.toLowerCase() ?? '').contains(query) ||
        (ac.officeNo?.toLowerCase() ?? '').contains(query) ||
        (ac.qrTag?.toLowerCase() ?? '').contains(query) ||
        (ac.model?.toLowerCase() ?? '').contains(query) ||
        (ac.serialNumber?.toLowerCase() ?? '').contains(query) ||
        (ac.manufacturer?.toLowerCase() ?? '').contains(query) ||
        (ac.installationDate?.toLowerCase() ?? '').contains(query) ||
        (ac.status?.toLowerCase() ?? '').contains(query) ||
        (ac.coolingCapacity?.toLowerCase() ?? '').contains(query) ||
        (ac.powerSupply?.toLowerCase() ?? '').contains(query) ||
        (ac.refrigerantType?.toLowerCase() ?? '').contains(query) ||
        (ac.dimensions?.toLowerCase() ?? '').contains(query) ||
        (ac.weight?.toLowerCase() ?? '').contains(query) ||
        (ac.noiseLevel?.toLowerCase() ?? '').contains(query) ||
        (ac.noOfCompressors?.toLowerCase() ?? '').contains(query) ||
        (ac.serialNumberOfCompressors?.toLowerCase() ?? '').contains(query) ||
        (ac.conditionIndoorAirFilters?.toLowerCase() ?? '').contains(query) ||
        (ac.conditionIndoorUnit?.toLowerCase() ?? '').contains(query) ||
        (ac.conditionOutdoorUnit?.toLowerCase() ?? '').contains(query) ||
        (ac.otherSpecifications?.toLowerCase() ?? '').contains(query) ||
        (ac.airflow?.toLowerCase() ?? '').contains(query) ||
        (ac.airflow_type?.toLowerCase() ?? '').contains(query) ||
        (ac.noOfRefrigerantCircuits?.toLowerCase() ?? '').contains(query) ||
        (ac.noOfEvaporatorCoils?.toLowerCase() ?? '').contains(query) ||
        (ac.noOfCondenserCircuits?.toLowerCase() ?? '').contains(query) ||
        (ac.noOfCondenserFans?.toLowerCase() ?? '').contains(query) ||
        (ac.No_of_Indoor_Fans?.toLowerCase() ?? '').contains(query) ||
        (ac.condenserMountingMethod?.toLowerCase() ?? '').contains(query) ||
        (ac.supplierName?.toLowerCase() ?? '').contains(query) ||
        (ac.supplierEmail?.toLowerCase() ?? '').contains(query) ||
        (ac.supplierContactNo?.toLowerCase() ?? '').contains(query) ||
        (ac.warrantyDetails?.toLowerCase() ?? '').contains(query) ||
        (ac.warrantyExpireDate?.toLowerCase() ?? '').contains(query) ||
        (ac.amcExpireDate?.toLowerCase() ?? '').contains(query) ||
        (ac.latitude?.toLowerCase() ?? '').contains(query) ||
        (ac.longitude?.toLowerCase() ?? '').contains(query) ||
        (ac.updatedBy?.toLowerCase() ?? '').contains(query) ||
        (ac.updatedTime?.toLowerCase() ?? '').contains(query);
  }
}
