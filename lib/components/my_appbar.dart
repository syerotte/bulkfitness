import 'package:bulkfitness/pages/profile/setting_page.dart';
import 'package:flutter/material.dart';

import 'package:bulkfitness/pages/profile/setting_page.dart';
import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton; // Control the back button display
  final bool showSettingButton; // Control the settings button display

  const MyAppbar({
    Key? key,
    this.showBackButton = false,
    this.showSettingButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Custom height
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white, // Color of the bottom border
            width: 1.0, // Thickness of the border
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Show back button if enabled
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous page
                  },
                ),
              ),

            // Show setting button if enabled
            if (showSettingButton)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingPage(), // Navigate to SettingPage
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Centered BULK text and icon
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                children: const [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "BULK",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120); // Custom height
}
