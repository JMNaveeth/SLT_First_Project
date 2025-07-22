import 'package:flutter/material.dart';
import 'package:theme_update/2nd%20sub%20folder/ComfortAC/AddComfortAC/AddIndoorOutdoorUnits.dart';
import 'package:theme_update/2nd%20sub%20folder/ComfortAC/UpdateComfortAC/selectComfortACtoUpdate.dart';
import 'package:theme_update/2nd%20sub%20folder/PrecisionAc/UpdatePrecisionAc/updatePrecisionACList.dart';
import 'package:theme_update/2nd%20sub%20folder/PrecisionAc/addPrecisionAc/AddPrecisionAc.dart';
import 'package:theme_update/2nd%20sub%20folder/SPD%20Maitenance/AddACSPD/AddacSPD.dart';
import 'package:theme_update/2nd%20sub%20folder/SPD%20Maitenance/AddDCSPD/AddDCSpd.dart';
import 'package:theme_update/2nd%20sub%20folder/SPD%20Maitenance/UpdateSPD/UpdateSPDDetails.dart';
import 'package:theme_update/2nd%20sub%20folder/UpdateGenerator/GatherUpdateGeneratorSelector.dart';
import 'package:theme_update/AddGenerator/GatherGenData.dart';
import 'package:theme_update/DEGRoutineInspection/AddRoutineInspect/selectDEGtoInspect.dart';
import 'package:theme_update/DEGRoutineInspection/RoutineInspectionView/DEGInspectionViewSelect.dart';
import 'package:theme_update/Rectifier/RectifierInspectionView/rectifierInspectionViewSelect.dart';
import 'package:theme_update/Rectifier/RectifierRoutineInspection/selectRectifierToInspect.dart';
import 'package:theme_update/UPSRoutineInspection/selectUPSToInspect.dart';
import 'package:theme_update/ViewGeneratorV2/ViewGenList.dart';
// import 'package:theme_update/settings_screen.dart';
// import 'package:theme_update/theme_provider.dart';
// import 'package:theme_update/theme_toggle_button.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'package:theme_update/widgets/theme%20change%20related%20widjets/settings_screen.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_provider.dart';
import 'package:theme_update/widgets/theme%20change%20related%20widjets/theme_toggle_button.dart';
import 'ViewComfortAC/ViewComfortAC/SelectComfortACUnit.dart';
import 'ViewElevator/ViewElevator/viewElevator.dart';
import 'ViewRectifier/ViewRectifierDetails.dart';
import 'ViewSPD/ViewSPD/ViewSPDDetails.dart';
import 'ViewSolar/ViewSolar/view_data_screen.dart';
import 'ViewTransformer/ViewTransformer/view_transformer_data.dart';
import 'ViewUPS/ViewUPS/ViewUPShighend.dart';
import 'viewBatterySystem/viewBatterySystem/ViewBatteryDetails.dart';
import 'viewLVPanel/viewLVPanel/viewLVbreaker.dart';
import 'viewPrecisionAC/viewPrecisionAC/PrecisionAcViewCustom.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        centerTitle: true,
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        child: Center(
          child: ElevatedButton(
            style: buttonStyle(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RectifierMenu()),
              );
            },
            child: const Text('Search'),
          ),
        ),
      ),
    );
  }
}

class RectifierMenu extends StatelessWidget {
  const RectifierMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Menu',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        iconTheme: IconThemeData(color: customColors.mainTextColor),
        backgroundColor: customColors.appbarColor,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        width: double.infinity, // Make sure background fills the width
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center vertically
            children: [
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => firstsub_folder()),
                  );
                },
                child: const Text('first sub folder'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => secondsub_folder()),
                  );
                },
                child: const Text('Second sub folder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom();
}

///////////////////////////2nd sub folder///////////////////////////

class secondsub_folder extends StatelessWidget {
  const secondsub_folder({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'second sub folder',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        centerTitle: true,
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center vertically
            children: [
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddacSPD()),
                  );
                },
                child: const Text('Add AC SPD'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDCSpd()),
                  );
                },
                child: const Text('Add DC SPD'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateSPDDetails()),
                  );
                },
                child: const Text('Update SPD Details'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GeneratorSelectPage(),
                    ),
                  );
                },
                child: const Text('Update Generator'),
              ),
               ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ACFormPage(),
                    ),
                  );
                },
                child: const Text('Add Comfort AC'),
              ),
               ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComfortAcUpdate(),
                    ),
                  );
                },
                child: const Text('Update Comfort AC'),
              ),
               ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPrecisionAcUnit(),
                    ),
                  );
                },
                child: const Text('add Precision Ac'),
              ),
               ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => updatePrecisionACList(),
                    ),
                  );
                },
                child: const Text('Update Precision Ac'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///////////////////////////1st sub folder///////////////////////////

class firstsub_folder extends StatelessWidget {
  const firstsub_folder({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'first sub folder',
          style: TextStyle(color: customColors.mainTextColor),
        ),
        centerTitle: true,
        backgroundColor: customColors.appbarColor,
        actions: [
          ThemeToggleButton(), // Use the reusable widget
        ],
      ),

      body: Container(
        color: customColors.mainBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center vertically
            children: [
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRectifierDetails(),
                    ),
                  );
                },
                child: const Text('View Rectifier'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewUPShighend()),
                  );
                },
                child: const Text('View UPS'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectComfortACUnit(),
                    ),
                  );
                },
                child: const Text('View Comfort AC'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewBatteryDetails(),
                    ),
                  );
                },
                child: const Text('View Battery System'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewLVBreaker()),
                  );
                },
                child: const Text('View LV Panel'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewElevatorDetails(),
                    ),
                  );
                },
                child: const Text('View Elevator'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewSPDDetails()),
                  );
                },
                child: const Text('View SPD'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewTransformerData(),
                    ),
                  );
                },
                child: const Text('View Transformer'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrecisionACList()),
                  );
                },
                child: const Text('View Precision AC'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDataScreen()),
                  );
                },
                child: const Text('View Solar'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewGenerator()),
                  );
                },
                child: const Text('View Generator'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GeneratorDetailAddPage(),
                    ),
                  );
                },
                child: const Text('Add Generator'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DEGInspectionViewSelect(),
                    ),
                  );
                },
                child: const Text('RoutineInspection View'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => selectDEGToInspect(),
                    ),
                  );
                },
                child: const Text('Add RoutineInspect'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => selectUPSToInspect(),
                    ),
                  );
                },
                child: const Text('UPSRoutineInspection'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RectifierInspectionViewSelect(),
                    ),
                  );
                },
                child: const Text('RectifierInspectionView'),
              ),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => selectRectifierToInspect(),
                    ),
                  );
                },
                child: const Text('RectifierRoutineInspection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
