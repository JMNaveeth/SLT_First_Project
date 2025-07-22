import 'package:flutter/material.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
import 'http_get_service.dart';
// import '../AddSolar/http_get_service.dart';
import 'package:provider/provider.dart';
// import 'package:theme_update/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SiteDetailScreen extends StatefulWidget {
  final Map<String, dynamic> siteData;
  final String searchQuery;

  SiteDetailScreen({required this.siteData, this.searchQuery = ''});

  @override
  _SiteDetailScreenState createState() => _SiteDetailScreenState();
}

class _SiteDetailScreenState extends State<SiteDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late TabController _tabController;
  List<Map<String, dynamic>> panelData = [];
  List<Map<String, dynamic>> inverterData = [];
  String selectedSection = 'Site';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      HttpGetService service = HttpGetService();
      List<Map<String, dynamic>> allPanelData = await service
          .getPanelsDataBySiteId(widget.siteData['site_id']);
      List<Map<String, dynamic>> allInverterData = await service
          .getInverterDataBySiteId(widget.siteData['site_id']);

      // Filter the data by site_id
      panelData =
          allPanelData
              .where((panel) => panel['site_id'] == widget.siteData['site_id'])
              .toList();
      inverterData =
          allInverterData
              .where(
                (inverter) => inverter['site_id'] == widget.siteData['site_id'],
              )
              .toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  InlineSpan getHighlightedText(
    String text,
    String searchQuery,
    Color textColor,
    Color highlightColor,
  ) {
    if (searchQuery.isEmpty || text.isEmpty) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = searchQuery.toLowerCase();
    final start = lowerText.indexOf(lowerQuery);
    if (start == -1) {
      return TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: 16),
      );
    }
    final end = start + lowerQuery.length;
    return TextSpan(
      children: [
        if (start > 0)
          TextSpan(
            text: text.substring(0, start),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
        TextSpan(
          text: text.substring(start, end),
          style: TextStyle(
            color: textColor,
            backgroundColor: highlightColor,
            fontSize: 16,
          ),
        ),
        if (end < text.length)
          TextSpan(
            text: text.substring(end),
            style: TextStyle(color: textColor, fontSize: 16),
          ),
      ],
    );
  }

  Widget buildSectionHeader(String title) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: customColors.mainTextColor,
          ),
        ),
      ),
    );
  }

 Widget buildDetailContainer(
  String title,
  dynamic detail, {
  String? searchQuery,
}) {
  final customColors = Theme.of(context).extension<CustomColors>()!;

  final String detailText = detail != null ? detail.toString() : 'N/A';
  final bool isPhone = title == 'Telephone number';
  final bool isEmail = title == 'Supplier Email';

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: customColors.suqarBackgroundColor,
      boxShadow: [
        BoxShadow(
          color: customColors.subTextColor.withOpacity(0.2),
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:   ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: customColors.mainTextColor,
          ),
        ),
        Expanded(
          child: isPhone && detail != null
              ? GestureDetector(
                  onTap: () async {
                    final Uri telUri = Uri(
                      scheme: 'tel',
                      path: detail.toString(),
                    );
                    if (await canLaunchUrl(telUri)) {
                      await launchUrl(telUri);
                    } else {
                      print('Could not launch $telUri');
                    }
                  },
                  child: Text(
                    detailText,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              : isEmail && detail != null
                  ? GestureDetector(
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: detail.toString(),
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          print('Could not launch $emailUri');
                        }
                      },
                      child: Text(
                        detailText,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text.rich(
                      getHighlightedText(
                        detailText,
                        searchQuery ?? '',
                        customColors.subTextColor,
                        customColors.hinttColor,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
        ),
      ],
    ),
  );
}

  Widget buildSiteInformation() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        buildSectionHeader('Location Details'),
        const Divider(),
        buildDetailContainer(
          'Site ID',
          widget.siteData['site_id'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Region',
          widget.siteData['region'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'RTOM',
          widget.siteData['rtom'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Station',
          widget.siteData['station'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Station Address',
          widget.siteData['station_address'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Latitude',
          widget.siteData['latitude'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Longitude',
          widget.siteData['longitude'],
          searchQuery: widget.searchQuery,
        ),
        const Divider(),
        buildSectionHeader('Supplier Details'),
        const Divider(),
        buildDetailContainer(
          'Supplier Name',
          widget.siteData['supplier_name'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Supplier Address',
          widget.siteData['supplier_address'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Supplier Email',
          widget.siteData['supplier_email'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Telephone number',
          widget.siteData['supplier_phone_number'],
          searchQuery: widget.searchQuery,
        ),
        const Divider(),
        buildSectionHeader('General Details'),
        const Divider(),
        buildDetailContainer(
          'Electricity Company',
          widget.siteData['electricity_company'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Tariff Scheme',
          widget.siteData['tariff_scheme'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Phase type',
          widget.siteData['phase_type'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Solar Scheme',
          widget.siteData['solar_scheme'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Solar System Capacity (kWp)',
          widget.siteData['solar_system_capacity_kWp'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'QR Tag',
          widget.siteData['qr_tag'],
          searchQuery: widget.searchQuery,
        ),
        const Divider(),
        buildSectionHeader('Account Details'),
        const Divider(),
        buildDetailContainer(
          'Account Number',
          widget.siteData['account_number'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Contract Demand (kVA)',
          widget.siteData['contract_demand_kVA'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Avg Max Demand (kVA) Before',
          widget.siteData['average_maximum_demand_kVA_before'],
          searchQuery: widget.searchQuery,
        ),
        buildDetailContainer(
          'Avg Max Demand (kVA) After',
          widget.siteData['average_maximum_demand_kVA_after'],
          searchQuery: widget.searchQuery,
        ),
      ],
    );
  }

  Widget buildGradientTabBar() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: customColors.suqarBackgroundColor,
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Site'),
          Tab(text: 'Panel'),
          Tab(text: 'Inverter'),
        ],
        labelColor: Colors.white,
        unselectedLabelColor: customColors.mainTextColor,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.grey, Colors.grey]),
          borderRadius: BorderRadius.circular(50),
          color: Colors.red,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solar Details',
          style: TextStyle(
            color: customColors.mainTextColor,
            fontFamily: 'outfit',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        centerTitle: true,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),
      body: Container(
        color: customColors.mainBackgroundColor,
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: buildGradientTabBar(), // Gradient TabBar
                    ),
                    const SizedBox(height: 1),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          // Prevent horizontal swiping
                          return true; // Consume the scroll notification
                        },
                        child: TabBarView(
                          controller: _tabController,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable swipe gestures

                          children: [
                            SingleChildScrollView(
                              child: buildSiteInformation(),
                            ),
                            SingleChildScrollView(
                              child: buildPanelInformation(),
                            ),
                            SingleChildScrollView(
                              child: buildInverterInformation(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget buildPanelInformation() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          panelData.map((panel) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildSectionHeader('Module Details'),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Panel ID',
                    panel['panel_id'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Module Manufacturer',
                    panel['module_manufacturer'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Manufacturing Country',
                    panel['manufacturing_country'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Country of Origin',
                    panel['country_of_origin'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Model',
                    panel['model'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Brand',
                    panel['brand'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Manufacturing Year',
                    panel['module_manufacturing_year'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'PV Module Type',
                    panel['pv_module_type'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Module Dimensions',
                    panel['module_dimensions'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Module Weight',
                    panel['module_weight'],
                    searchQuery: widget.searchQuery,
                  ),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildSectionHeader('Electrical Specifications'),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Max System Voltage',
                    panel['maximum_system_voltage'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Max Series Fuse Rating',
                    panel['maximum_series_fuse_rating'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Max Reverse Current',
                    panel['maximum_reverse_current'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Nominal Power',
                    panel['nominal_power'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Nominal Voltage',
                    panel['nominal_voltage'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Nominal Current',
                    panel['nominal_current'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Open Circuit Voltage',
                    panel['open_circuit_voltage'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Short Circuit Current',
                    panel['short_circuit_current'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Module Efficiency',
                    panel['module_efficiency'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Performance Degression',
                    panel['max_performance_degression_per_anum'],
                    searchQuery: widget.searchQuery,
                  ),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildSectionHeader('Warranty Details'),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Product Warranty',
                    panel['product_warranty'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Power Performance Warranty',
                    panel['linear_power_performance_warranty'],
                    searchQuery: widget.searchQuery,
                  ),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildSectionHeader('Upload Details'),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Uploaded by',
                    panel['uploaded_by'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Uploaded time',
                    panel['updated_time'],
                    searchQuery: widget.searchQuery,
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget buildPanelDetail(String title, dynamic detail) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: customColors.mainTextColor,
            ),
          ),
          Expanded(child: Text(detail != null ? detail.toString() : 'N/A')),
        ],
      ),
    );
  }

  Widget buildInverterInformation() {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          inverterData.asMap().entries.map((entry) {
            int index = entry.key; // Get the index
            Map<String, dynamic> inverter =
                entry.value; // Get the inverter data

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: customColors.mainTextColor), // Subtext color
                  buildSectionHeader('(${index + 1}) Inverter Details '),
                  // Add inverter number in header
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Inverter ID',
                    inverter['inverter_id'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Inverter Manufacturer',
                    inverter['inverter_manufacturer'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Inverter Origin',
                    inverter['inverter_origin'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Inverter Efficiency',
                    inverter['inverter_efficiency'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Inverter Capacity',
                    inverter['inverter_capacity'],
                    searchQuery: widget.searchQuery,
                  ),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildSectionHeader('Upload Details'),
                  Divider(color: customColors.subTextColor), // Subtext color
                  buildDetailContainer(
                    'Uploaded by',
                    inverter['uploaded_by'],
                    searchQuery: widget.searchQuery,
                  ),
                  buildDetailContainer(
                    'Uploaded time',
                    inverter['updated_time'],
                    searchQuery: widget.searchQuery,
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget buildInverterDetail(String title, dynamic detail) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: customColors.mainTextColor,
            ),
          ),
          Expanded(child: Text(detail != null ? detail.toString() : 'N/A')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
