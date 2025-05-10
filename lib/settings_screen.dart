import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_update/utils/utils/colors.dart';
import 'theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  void _saveTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.isDarkMode = _isDarkMode;
    themeProvider.notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Theme saved!")));
  }

  @override
  Widget build(BuildContext context) {
        final customColors = Theme.of(context).extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text("Theme Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Choose your theme:", style: TextStyle(fontSize: 18)),

            RadioListTile<bool>(
              title:  Text(
                "Light Theme",
                style: TextStyle(color: customColors.suqarBackgroundColor),
              ),
              value: false,
              groupValue: _isDarkMode,
              activeColor: customColors.suqarBackgroundColor,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value!;
                });
              },
            ),
            RadioListTile<bool>(
              title:  Text(
                "Dark Theme",
                style: TextStyle(color: customColors.suqarBackgroundColor),
              ),
              value: true,
              groupValue: _isDarkMode,
              activeColor: customColors.suqarBackgroundColor,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value!;
                });
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveTheme, child: const Text("Save")),
          ],
        ),
      ),
    );
  }
}
