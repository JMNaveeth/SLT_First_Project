import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_update/utils/utils/colors.dart' as customColors;
import 'theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: isDarkMode ? Colors.black : Colors.white, // Dynamic icon color
      ),
      onPressed: () {
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      },
    );
  }
}