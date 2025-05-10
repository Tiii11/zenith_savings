// lib/screens/theme_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Ensure this is imported
import '../widgets/neumorphic_container.dart';
import '../widgets/neumorphic_button.dart';
import '../main.dart'; // For GradientBackground

class ThemeSettingsScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final Function(Color) changeAccentColor;
  final ThemeMode currentThemeMode;
  final Color currentAccentColor;

  const ThemeSettingsScreen({
    Key? key,
    required this.toggleTheme,
    required this.changeAccentColor,
    required this.currentThemeMode,
    required this.currentAccentColor,
  }) : super(key: key);

  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late Color _pickerColor; // This will hold the temporarily selected color in the dialog
  late Color _appliedAccentColor; // This will hold the color applied to the theme
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _pickerColor = widget.currentAccentColor;
    _appliedAccentColor = widget.currentAccentColor;
    _selectedThemeMode = widget.currentThemeMode;
  }

  void _openColorPicker() {
    Color colorBeforeDialog = _pickerColor; 
    showDialog(
      context: context,
      builder: (context) {
        Color dialogPickerColor = _pickerColor; // Local variable for the dialog's state
        return AlertDialog(
          title: Text('Pick Accent Color', style: GoogleFonts.poppins(color: Theme.of(context).textTheme.titleLarge?.color)),
          contentPadding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: SingleChildScrollView(
            child: BlockPicker( // Using BlockPicker for simplicity and good neumorphic look
              pickerColor: dialogPickerColor, // Use the dialog's local color state
              onColorChanged: (color) {
                 // Update the dialog's local color state immediately for feedback in picker
                 // No need for setState here as BlockPicker handles its internal state for selection
                 dialogPickerColor = color; 
              },
              availableColors: [
                Color(0xFF00FFFF), Color(0xFF007AFF), Color(0xFF34C759), Color(0xFFFF9500),
                Color(0xFFFF2D55), Color(0xFF5856D6), Color(0xFFA2845E), Color(0xFF5AC8FA),
                Color(0xFFFFD60A), Colors.grey.shade500, Color(0xFF8E8E93), Color(0xFFFF3B30)
              ],
              layoutBuilder: (context, colors, child) {
                return Container(
                  width: double.maxFinite,
                  height: 280, 
                  child: GridView.count(
                    crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, // Increased spacing
                    children: colors.map((Color color) => child(color)).toList(),
                  ),
                );
              },
              itemBuilder: (color, isCurrentColor, changeColor) {
                 return GestureDetector( // Use GestureDetector for the tap
                    onTap: changeColor,
                    child: NeumorphicContainer(
                      type: isCurrentColor ? NeumorphicType.concave : NeumorphicType.convex,
                      shape: BoxShape.circle,
                      padding: EdgeInsets.all(isCurrentColor ? 6 : 2), // Visual feedback for selection
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      distance: 3,
                      blurRadius: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: isCurrentColor ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.7), width: 2.5) : null,
                        ),
                      ),
                    ),
                 );
              },
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly, // Better spacing for actions
          actionsPadding: EdgeInsets.only(bottom: 16, left:16, right: 16),
          actions: <Widget>[
            NeumorphicButton(
              onPressed: () {
                Navigator.of(context).pop();
                // No need to revert _pickerColor as it wasn't changed directly by onColorChanged
              },
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Text('Cancel', style: GoogleFonts.poppins(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.8))),
            ),
            NeumorphicButton(
              onPressed: () {
                setState(() { // Update the screen's state for the displayed color circle
                  _appliedAccentColor = dialogPickerColor; 
                  _pickerColor = dialogPickerColor; // Sync pickerColor with applied
                });
                widget.changeAccentColor(dialogPickerColor); // Call the callback to change the app's theme
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: dialogPickerColor, 
              child: Text('Apply', style: GoogleFonts.poppins(color: ThemeData.estimateBrightnessForColor(dialogPickerColor) == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Theme Settings'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Appearance Customization', // Changed title
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: isDark ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headlineSmall?.color
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
              SizedBox(height: 30),

              NeumorphicContainer(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Adjusted padding
                backgroundColor: Theme.of(context).colorScheme.background,
                type: NeumorphicType.flat, // Use flat for section containers
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mode', style: Theme.of(context).textTheme.titleLarge),
                    Row(
                      children: [
                        NeumorphicButton( // Button for Light Mode
                          onPressed: () {
                            if (_selectedThemeMode != ThemeMode.light) {
                              setState(() => _selectedThemeMode = ThemeMode.light);
                              widget.toggleTheme(ThemeMode.light);
                            }
                          },
                          padding: EdgeInsets.all(12), // Adjusted padding
                          // No 'type' parameter for NeumorphicButton, it handles its own state
                          backgroundColor: _selectedThemeMode == ThemeMode.light 
                              ? Theme.of(context).primaryColor.withOpacity(isDark ? 0.2 : 0.1) // Visual cue for active
                              : Theme.of(context).colorScheme.background,
                          child: Icon(Icons.light_mode_outlined, 
                            color: _selectedThemeMode == ThemeMode.light 
                                ? Theme.of(context).primaryColor 
                                : Theme.of(context).iconTheme.color?.withOpacity(0.7)
                          ),
                        ),
                        SizedBox(width: 15), // Increased spacing
                         NeumorphicButton( // Button for Dark Mode
                           onPressed: () {
                            if (_selectedThemeMode != ThemeMode.dark) {
                              setState(() => _selectedThemeMode = ThemeMode.dark);
                              widget.toggleTheme(ThemeMode.dark);
                            }
                           },
                           padding: EdgeInsets.all(12),
                           backgroundColor: _selectedThemeMode == ThemeMode.dark 
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Theme.of(context).colorScheme.background,
                           child: Icon(Icons.dark_mode_outlined, 
                            color: _selectedThemeMode == ThemeMode.dark 
                                ? Theme.of(context).primaryColor 
                                : Theme.of(context).iconTheme.color?.withOpacity(0.7)
                          ),
                         ),
                      ],
                    )
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin:0.1),
              SizedBox(height: 35),
              NeumorphicContainer(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                backgroundColor: Theme.of(context).colorScheme.background,
                type: NeumorphicType.flat,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Accent Color', style: Theme.of(context).textTheme.titleLarge),
                    GestureDetector(
                      onTap: _openColorPicker,
                      child: NeumorphicContainer(
                        type: NeumorphicType.convex, // Display as convex
                        shape: BoxShape.circle,
                        padding: EdgeInsets.all(4),
                        backgroundColor: Theme.of(context).colorScheme.background,
                        distance: 3, // Subtle effect for the color display
                        blurRadius: 6,
                        child: Container(
                          width: 44, // Slightly larger
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _appliedAccentColor, // Show the applied accent color
                            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5), width: 2)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin:0.1),
               SizedBox(height: 60),
               Center(
                 child: Text(
                   "Personalize your Zenith Savings experience.", // Updated text
                   style: Theme.of(context).textTheme.bodyMedium,
                 ).animate().fadeIn(delay: 500.ms),
               )
            ],
          ),
        ),
      ),
    );
  }
}