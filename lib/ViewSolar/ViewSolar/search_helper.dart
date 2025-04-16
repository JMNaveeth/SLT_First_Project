class SearchHelper {
  static bool matchesSiteQuery(Map<String, dynamic> site, String query) {
    query = query.toLowerCase();
    return _siteMatchesQuery(site, query);
  }

  static bool matchesPanelQuery(Map<String, dynamic> panel, String query) {
    query = query.toLowerCase();
    return _panelMatchesQuery(panel, query);
  }

  static bool matchesInverterQuery(
      Map<String, dynamic> inverter, String query) {
    query = query.toLowerCase();
    return _inverterMatchesQuery(inverter, query);
  }

  static bool _siteMatchesQuery(Map<String, dynamic> site, String query) {
    return (site['region']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['station']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['rtom']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['station_address']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['solar_system_capacity_kWp']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['site_id']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['latitude']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['longitude']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['supplier_name']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['supplier_address']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['supplier_email']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['supplier_phone_number']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['electricity_company']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['tariff_scheme']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['phase_type']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['solar_scheme']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['qr_tag']?.toString().toLowerCase() ?? '').contains(query) ||
        (site['account_number']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['contract_demand_kVA']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (site['average_maximum_demand_kVA_before']?.toString().toLowerCase() ??
                '')
            .contains(query) ||
        (site['average_maximum_demand_kVA_after']?.toString().toLowerCase() ??
                '')
            .contains(query);
  }

  static bool _panelMatchesQuery(Map<String, dynamic> panel, String query) {
    return (panel['module_manufacturer']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['model']?.toString().toLowerCase() ?? '').contains(query) ||
        (panel['brand']?.toString().toLowerCase() ?? '').contains(query) ||
        (panel['nominal_power']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['panel_id']?.toString().toLowerCase() ?? '').contains(query) ||
        (panel['manufacturing_country']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['country_of_origin']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['module_manufacturing_year']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['pv_module_type']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['module_dimensions']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['module_weight']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['maximum_system_voltage']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['maximum_series_fuse_rating']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['maximum_reverse_current']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['nominal_voltage']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['nominal_current']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['open_circuit_voltage']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['short_circuit_current']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['module_efficiency']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['max_performance_degression_per_anum']
                    ?.toString()
                    .toLowerCase() ??
                '')
            .contains(query) ||
        (panel['product_warranty']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (panel['linear_power_performance_warranty']?.toString().toLowerCase() ??
                '')
            .contains(query) ||
        (panel['uploaded_by']?.toString().toLowerCase() ?? '').contains(query) ||
        (panel['updated_time']?.toString().toLowerCase() ?? '').contains(query);
  }

  static bool _inverterMatchesQuery(
      Map<String, dynamic> inverter, String query) {
    return (inverter['inverter_manufacturer']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['inverter_capacity']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['inverter_efficiency']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['inverter_id']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['inverter_origin']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['uploaded_by']?.toString().toLowerCase() ?? '')
            .contains(query) ||
        (inverter['updated_time']?.toString().toLowerCase() ?? '')
            .contains(query);
  }
}
