// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'calculation_logic.dart';
import 'widgets/neumorphic_container.dart'; 
import 'widgets/neumorphic_button.dart';   
import 'screens/theme_settings_screen.dart';

// PREF keys
const String PREF_INCOME_KEY = 'monthly_income_v_final_custom_theme_combined'; 
const String PREF_TRANSPORT_KEY = 'monthly_transport_fee_v_final_custom_theme_combined';
const String PREF_THEME_MODE_KEY = 'theme_mode_v_final_custom_theme_combined';
const String PREF_ROLLED_OVER_SAVINGS = 'rolled_over_savings_v_final_custom_theme_combined';
const String PREF_LAST_ROLLOVER_DATE = 'last_rollover_date_v_final_custom_theme_combined';
const String PREF_ACCENT_COLOR_KEY = 'accent_color_v_final_custom_theme_combined';


void main() {
  runApp(ZenithSavingsApp());
}

class ZenithSavingsApp extends StatefulWidget {
  @override
  _ZenithSavingsAppState createState() => _ZenithSavingsAppState();
}

class _ZenithSavingsAppState extends State<ZenithSavingsApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _currentAccentColor = Color(0xFF00FFFF); 

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadAccentColor();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final String? theme = prefs.getString(PREF_THEME_MODE_KEY);
    if (mounted && theme != null) {
      setState(() {
        if (theme == 'light') _themeMode = ThemeMode.light;
        else _themeMode = ThemeMode.dark; 
      });
    } else if (mounted) {
        setState(() { _themeMode = ThemeMode.dark; });
    }
  }

  Future<void> _loadAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    final int? colorValue = prefs.getInt(PREF_ACCENT_COLOR_KEY);
    if (mounted && colorValue != null) {
      setState(() {
        _currentAccentColor = Color(colorValue);
      });
    }
  }

  Future<void> _toggleTheme(ThemeMode themeMode) async {
    if (mounted) {
      setState(() { _themeMode = themeMode; });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREF_THEME_MODE_KEY, themeMode == ThemeMode.light ? 'light' : 'dark');
  }

  Future<void> _changeAccentColor(Color newColor) async {
    if (mounted) {
      setState(() {
        _currentAccentColor = newColor;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PREF_ACCENT_COLOR_KEY, newColor.value);
  }
  
  TextTheme _buildTextTheme(TextTheme base, Color primaryTextColor, Color secondaryTextColor, Color currentAccent, bool isDark) {
    return GoogleFonts.poppinsTextTheme(base).copyWith(
      headlineSmall: GoogleFonts.poppins(fontSize: 26.0, fontWeight: FontWeight.w600, color: primaryTextColor, 
        shadows: isDark ? [Shadow(color: currentAccent.withOpacity(0.3), blurRadius: 8)] : null),
      titleLarge: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w600, color: primaryTextColor),
      titleMedium: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w500, color: secondaryTextColor),
      bodyLarge: GoogleFonts.poppins(fontSize: 15.0, color: primaryTextColor, height: 1.5),
      bodyMedium: GoogleFonts.poppins(fontSize: 13.0, color: secondaryTextColor, height: 1.4),
      headlineMedium: GoogleFonts.poppins(fontSize: 38.0, fontWeight: FontWeight.bold, color: primaryTextColor,
        shadows: isDark ? [Shadow(color: currentAccent.withOpacity(0.5), blurRadius: 10), Shadow(color: currentAccent.withOpacity(0.2), blurRadius: 20)] : null),
      labelLarge: GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.w600, color: primaryTextColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color userSelectedAccent = _currentAccentColor;

    final Color lightScaffoldBg = Colors.white;
    final Color lightElementBg = Colors.white;
    final Color lightPrimaryText = Colors.black;
    final Color lightSecondaryText = Colors.grey.shade700;
    final Brightness lightAccentBrightness = ThemeData.estimateBrightnessForColor(userSelectedAccent);
    final Color onLightAccentColor = lightAccentBrightness == Brightness.dark ? Colors.white : Colors.black;

    final Color darkScaffoldBgSolid = Color(0xFF1A1D21);
    final Color darkElementBg = Color(0xFF23272C); 
    final Color darkPrimaryText = Color(0xFFEAEAEA);
    final Color darkSecondaryText = Color(0xFFA0A0B0);
    final Brightness darkAccentBrightness = ThemeData.estimateBrightnessForColor(userSelectedAccent);
    final Color onDarkAccentColor = darkAccentBrightness == Brightness.light ? darkScaffoldBgSolid : darkPrimaryText;

    return MaterialApp(
      title: 'Zenith Savings',
      theme: ThemeData(
        brightness: Brightness.light, primaryColor: userSelectedAccent,
        scaffoldBackgroundColor: lightScaffoldBg,
        colorScheme: ColorScheme.light(
          primary: userSelectedAccent, secondary: userSelectedAccent.withOpacity(0.7), surface: lightElementBg,
          background: lightScaffoldBg, error: Colors.red.shade700, onPrimary: onLightAccentColor,
          onSecondary: onLightAccentColor, onSurface: lightPrimaryText, onBackground: lightPrimaryText, onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightScaffoldBg, foregroundColor: lightPrimaryText, elevation: 0,
          titleTextStyle: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: lightPrimaryText),
          iconTheme: IconThemeData(color: userSelectedAccent),
        ),
        textTheme: _buildTextTheme(ThemeData.light().textTheme, lightPrimaryText, lightSecondaryText, userSelectedAccent, false),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.poppins(color: lightSecondaryText, fontSize: 15),
          hintStyle: GoogleFonts.poppins(color: lightSecondaryText.withOpacity(0.7), fontSize: 15),
          prefixIconColor: lightSecondaryText.withOpacity(0.8), 
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), border: InputBorder.none,
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
            foregroundColor: userSelectedAccent, textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
        )),
        dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),
        iconTheme: IconThemeData(color: lightSecondaryText, size: 24),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, primaryColor: userSelectedAccent,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.dark(
          primary: userSelectedAccent, secondary: userSelectedAccent.withOpacity(0.6), surface: darkElementBg, background: darkScaffoldBgSolid,
          error: Colors.redAccent.shade100, onPrimary: onDarkAccentColor, onSecondary: darkPrimaryText, 
          onSurface: darkPrimaryText, onBackground: darkPrimaryText, onError: darkScaffoldBgSolid,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, foregroundColor: darkPrimaryText, elevation: 0,
          titleTextStyle: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: darkPrimaryText, shadows: [Shadow(color: userSelectedAccent.withOpacity(0.3), blurRadius: 8)]),
          iconTheme: IconThemeData(color: userSelectedAccent),
        ),
        textTheme: _buildTextTheme(ThemeData.dark().textTheme, darkPrimaryText, darkSecondaryText, userSelectedAccent, true),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.poppins(color: darkSecondaryText, fontSize: 15),
          hintStyle: GoogleFonts.poppins(color: darkSecondaryText.withOpacity(0.7), fontSize: 15),
          prefixIconColor: darkSecondaryText.withOpacity(0.8),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18), border: InputBorder.none,
        ),
         textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
            foregroundColor: userSelectedAccent, textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)
         )),
        dividerTheme: DividerThemeData(color: Colors.grey.shade800, thickness: 1),
        iconTheme: IconThemeData(color: userSelectedAccent.withOpacity(0.8), size: 24),
      ),
      themeMode: _themeMode,
      home: InitialLoadingScreen(
        toggleTheme: _toggleTheme,
        changeAccentColor: _changeAccentColor,
        currentAccentColor: _currentAccentColor,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
                colors: [Color(0xFF23272C), Color(0xFF1A1D21)],
                begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.7]
              )
            : null, 
        color: isDark ? null : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: child,
    );
  }
}


class InitialLoadingScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final Function(Color) changeAccentColor;
  final Color currentAccentColor;
  final ThemeMode currentThemeMode;

  InitialLoadingScreen({
    required this.toggleTheme, 
    required this.changeAccentColor,
    required this.currentAccentColor,
    required this.currentThemeMode,
  });
  @override
  _InitialLoadingScreenState createState() => _InitialLoadingScreenState();
}
class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() { super.initState(); _checkSavedDataAndNavigate(); }
  Future<void> _checkSavedDataAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final String? incomeStr = prefs.getString(PREF_INCOME_KEY);
    final String? transportStr = prefs.getString(PREF_TRANSPORT_KEY);
    await Future.delayed(Duration(milliseconds: 1500));
    if (mounted) {
      if (incomeStr != null && transportStr != null) {
        final double? income = double.tryParse(incomeStr);
        final double? transport = double.tryParse(transportStr);
        if (income != null && transport != null) {
          SavingsPlan plan = SavingsPlan(monthlyIncome: income, monthlyTransportFee: transport);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(
            plan: plan, 
            toggleTheme: widget.toggleTheme,
            changeAccentColor: widget.changeAccentColor,
            currentAccentColor: widget.currentAccentColor,
            currentThemeMode: widget.currentThemeMode,
          )));
          return;
        }
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InputScreen(
        toggleTheme: widget.toggleTheme,
        changeAccentColor: widget.changeAccentColor,
        currentAccentColor: widget.currentAccentColor,
        currentThemeMode: widget.currentThemeMode,
      )));
    }
  }
  @override
  Widget build(BuildContext context) { 
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color glowColor = Theme.of(context).primaryColor;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeumorphicContainer(
                type: NeumorphicType.convex, shape: BoxShape.circle, padding: EdgeInsets.all(20),
                blurRadius: 20, distance: 10,
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Icon(Icons.savings_outlined, size: 70, color: glowColor,
                  shadows: isDark ? [Shadow(color: glowColor.withOpacity(0.7), blurRadius: 15)] : null,
                )
              ).animate().scale(duration: 800.ms, curve: Curves.elasticOut).then(delay: 200.ms).shake(hz:2, duration: 300.ms),
              SizedBox(height: 30),
              Text("Zenith Savings", style: Theme.of(context).textTheme.headlineSmall)
                  .animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
              SizedBox(height: 10),
              Text("Your Path to Financial Peak.", style: Theme.of(context).textTheme.titleMedium)
                   .animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),
              SizedBox(height: 40),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(glowColor), strokeWidth: 3)
                  .animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;
  final Function(Color) changeAccentColor;
  final Color currentAccentColor;
  final ThemeMode currentThemeMode;

  InputScreen({
    required this.toggleTheme, 
    required this.changeAccentColor,
    required this.currentAccentColor,
    required this.currentThemeMode,
  });
  @override
  _InputScreenState createState() => _InputScreenState();
}
class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _transportController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() { super.initState(); _loadSavedData(); }
  Future<void> _loadSavedData() async { 
    final prefs = await SharedPreferences.getInstance();
    if(mounted){
      _incomeController.text = prefs.getString(PREF_INCOME_KEY) ?? '';
      _transportController.text = prefs.getString(PREF_TRANSPORT_KEY) ?? '';
    }
  }
  Future<void> _saveDataAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      if(mounted) setState(() => _isLoading = true);
      final double income = double.parse(_incomeController.text);
      final double transport = double.parse(_transportController.text);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PREF_INCOME_KEY, _incomeController.text);
      await prefs.setString(PREF_TRANSPORT_KEY, _transportController.text);
      await prefs.remove(PREF_ROLLED_OVER_SAVINGS);
      await prefs.remove(PREF_LAST_ROLLOVER_DATE);
      SavingsPlan plan = SavingsPlan(monthlyIncome: income, monthlyTransportFee: transport);
      if(mounted) setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushReplacement( context, MaterialPageRoute(builder: (context) => DashboardScreen(
            plan: plan, 
            toggleTheme: widget.toggleTheme,
            changeAccentColor: widget.changeAccentColor,
            currentAccentColor: widget.currentAccentColor,
            currentThemeMode: widget.currentThemeMode,
        )));
      }
    }
  }
  Future<void> _clearSavedData() async { 
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PREF_INCOME_KEY); await prefs.remove(PREF_TRANSPORT_KEY);
    await prefs.remove(PREF_ROLLED_OVER_SAVINGS); await prefs.remove(PREF_LAST_ROLLOVER_DATE);
    _incomeController.clear(); _transportController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text("All saved data cleared.", style: TextStyle(color: Theme.of(context).colorScheme.onError)),
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.8), behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: EdgeInsets.all(10),
      ));
    }
  }
  @override
  void dispose() { _incomeController.dispose(); _transportController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color generalIconColor = Theme.of(context).iconTheme.color!; 

     return GradientBackground(
       child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Financial Input'),
          actions: [
             IconButton(
              icon: Icon(Icons.palette_outlined, 
                shadows: isDark ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 8)] : null,
              ),
              tooltip: "Theme Settings",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeSettingsScreen(
                  toggleTheme: widget.toggleTheme,
                  changeAccentColor: widget.changeAccentColor,
                  currentThemeMode: widget.currentThemeMode,
                  currentAccentColor: widget.currentAccentColor,
                )));
              }
            ),
            IconButton(
              icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
              tooltip: "Toggle Theme Mode",
              onPressed: () => widget.toggleTheme(isDark ? ThemeMode.light : ThemeMode.dark),
            ),
            IconButton(icon: Icon(Icons.delete_sweep_outlined), tooltip: "Clear Saved Data", onPressed: _clearSavedData),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Your Financial Snapshot', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 200.ms).slideY(begin: -0.1),
                  SizedBox(height: 10),
                  Text('Enter details for your savings plan.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                    .animate().fadeIn(delay: 300.ms).slideY(begin: -0.1),
                  SizedBox(height: 45),
                  NeumorphicContainer(
                    type: NeumorphicType.concave, borderRadius: 12,
                    padding: EdgeInsets.zero, blurRadius: 6, distance: 3,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    child: TextFormField(
                      controller: _incomeController,
                      decoration: InputDecoration(labelText: 'Monthly Income', prefixIcon: Icon(Icons.account_balance_wallet_outlined, color: generalIconColor)),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: Theme.of(context).textTheme.bodyLarge,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter income.' : (double.tryParse(v) == null) ? 'Valid number.' : (double.parse(v) < 0) ? 'Income >= 0.' : null,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  SizedBox(height: 30),
                  NeumorphicContainer(
                     type: NeumorphicType.concave, borderRadius: 12,
                     padding: EdgeInsets.zero, blurRadius: 6, distance: 3,
                     backgroundColor: Theme.of(context).colorScheme.background,
                    child: TextFormField(
                      controller: _transportController,
                      decoration: InputDecoration(labelText: 'Monthly Transportation Fee', prefixIcon: Icon(Icons.directions_bus_filled_outlined, color: generalIconColor)),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: Theme.of(context).textTheme.bodyLarge,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      validator: (v) => (v == null || v.isEmpty) ? 'Enter transport fee.' : (double.tryParse(v) == null) ? 'Valid number.' : (double.parse(v) < 0) ? 'Fee >= 0.' : null,
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
                  SizedBox(height: 60),
                  _isLoading
                      ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                      : NeumorphicButton(
                          onPressed: _saveDataAndNavigate,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: Theme.of(context).colorScheme.background,
                          child: Center( 
                            child: Text('Generate Savings Plan', 
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor, 
                                shadows: isDark 
                                    ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 8)] 
                                    : null,
                              )
                            ),
                          ),
                        ).animate().fadeIn(delay: 600.ms).scaleXY(begin: 0.9, end: 1.0, duration: 200.ms),
                ],
              ),
            ),
          ),
        ),
           ),
     );
  }
}

class DashboardScreen extends StatefulWidget {
  final SavingsPlan plan;
  final Function(ThemeMode) toggleTheme;
  final Function(Color) changeAccentColor;
  final Color currentAccentColor;
  final ThemeMode currentThemeMode;

  DashboardScreen({
    required this.plan, 
    required this.toggleTheme,
    required this.changeAccentColor,
    required this.currentAccentColor,
    required this.currentThemeMode,
  });
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  double _rolledOverSavings = 0.0;
  DateTime? _lastRolloverDate;

  @override
  void initState() { super.initState(); _loadRolloverData(); }
  Future<void> _loadRolloverData() async { 
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _rolledOverSavings = prefs.getDouble(PREF_ROLLED_OVER_SAVINGS) ?? 0.0;
        String? dateStr = prefs.getString(PREF_LAST_ROLLOVER_DATE);
        if (dateStr != null) _lastRolloverDate = DateTime.tryParse(dateStr);
      });
    }
  }
  Future<void> _addDailyAllowanceToSavings() async {
    DateTime now = DateTime.now(); DateTime today = DateTime(now.year, now.month, now.day);
    if (_lastRolloverDate != null && _lastRolloverDate!.year == today.year && _lastRolloverDate!.month == today.month && _lastRolloverDate!.day == today.day) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Today's allowance already processed."), backgroundColor: Colors.orange[800]));
      return;
    }
    if (widget.plan.recommendedDailySpendingAndGroceries <= 0) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No daily allowance to roll over."), backgroundColor: Colors.red[800]));
      return;
    }
    final amountToRollOver = widget.plan.recommendedDailySpendingAndGroceries;
    double newRolledOverSavings = _rolledOverSavings + amountToRollOver;
    
    if (mounted) {
      setState(() { 
        _rolledOverSavings = newRolledOverSavings;
        _lastRolloverDate = today; 
      });
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(PREF_ROLLED_OVER_SAVINGS, _rolledOverSavings);
    await prefs.setString(PREF_LAST_ROLLOVER_DATE, today.toIso8601String());
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("\$${amountToRollOver.toStringAsFixed(2)} added to Extra Savings! Your savings are updated."), backgroundColor: Colors.green[700]));
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color iconColor, {bool isPrimary = false, Duration delay = const Duration(milliseconds: 300)}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final NeumorphicType cardType = isPrimary ? NeumorphicType.convex : NeumorphicType.flat;
    final Color effectiveIconColor = isDark && isPrimary ? Theme.of(context).primaryColor : iconColor;
    
    final TextStyle? headlineStyle = Theme.of(context).textTheme.headlineMedium;
    final TextStyle? titleLargeStyle = Theme.of(context).textTheme.titleLarge;
    final TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;

    final Color valueTextColorIfNull = isDark ? Colors.white : Colors.black;
    final Color titleTextColorIfNull = isDark ? Colors.white70 : Colors.black54;

    final Color valueTextColor = isDark && isPrimary 
        ? Theme.of(context).primaryColor 
        : (isPrimary ? (headlineStyle?.color ?? valueTextColorIfNull) : (titleLargeStyle?.color ?? valueTextColorIfNull));
    final Color titleTextColor = isDark && isPrimary 
        ? Theme.of(context).primaryColor.withOpacity(0.8) 
        : (titleMediumStyle?.color ?? titleTextColorIfNull);


    return NeumorphicContainer(
      type: cardType, borderRadius: 20, padding: const EdgeInsets.all(22.0),
      distance: isPrimary ? 6 : 4, blurRadius: isPrimary ? 12 : 8,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Row(
        children: [
          NeumorphicContainer(
            type: NeumorphicType.concave, shape: BoxShape.circle, padding: EdgeInsets.all(10),
            distance: 2, blurRadius: 4,
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Icon(icon, size: isPrimary ? 30 : 26, color: effectiveIconColor,
              shadows: isDark && isPrimary ? [Shadow(color: effectiveIconColor.withOpacity(0.5), blurRadius: 10)] : null,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: titleMediumStyle?.copyWith(color: titleTextColor)),
                SizedBox(height: 8),
                Text(value, style: (isPrimary ? headlineStyle : titleLargeStyle?.copyWith(fontWeight: FontWeight.bold))
                    ?.copyWith(color: valueTextColor)
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay, duration: 600.ms).slideX(begin: 0.2, curve: Curves.easeOutQuart);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color dailySpendingColor = Theme.of(context).primaryColor;
    Color savingsColor = isDark ? Color(0xFF4CAF50) : Color(0xFF388E3C);
    Color specialFoodColor = isDark ? Colors.deepPurpleAccent[100]! : Colors.deepPurple[400]!;
    Color extraSavingsColor = Theme.of(context).colorScheme.secondary;

    bool canShowMeaningfulPlan = widget.plan.calculationSuccess && (widget.plan.guaranteedMonthlySavings > 0 || widget.plan.recommendedDailySpendingAndGroceries > 0 || widget.plan.moneyAfterTransportAndSpecialFood >= 0);
    DateTime now = DateTime.now(); DateTime todayForCheck = DateTime(now.year, now.month, now.day);
    bool canRolloverToday = _lastRolloverDate == null || _lastRolloverDate!.isBefore(todayForCheck);

    Color rolloverButtonTextColor = Theme.of(context).textTheme.labelLarge!.color!;
        if (!canRolloverToday) { 
            rolloverButtonTextColor = isDark ? Colors.grey[600]! : Colors.grey[500]!;
        } else if (isDark) { 
            rolloverButtonTextColor = Theme.of(context).colorScheme.onSecondary; 
        }

    double totalMonthlySavings = widget.plan.guaranteedMonthlySavings + _rolledOverSavings;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Zenith Plan'),
           actions: [ 
              IconButton(
                icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                  shadows: isDark ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 8)] : null,
                ),
                tooltip: "Toggle Theme Mode",
                onPressed: () => widget.toggleTheme(isDark ? ThemeMode.light : ThemeMode.dark),
              ),
              IconButton(
                icon: Icon(Icons.palette_outlined,
                 shadows: isDark ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 8)] : null,
                ),
                tooltip: "Theme Settings",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeSettingsScreen(
                    toggleTheme: widget.toggleTheme,
                    changeAccentColor: widget.changeAccentColor,
                    currentThemeMode: widget.currentThemeMode,
                    currentAccentColor: widget.currentAccentColor,
                  )));
                }
              ),
              IconButton(
                icon: Icon(Icons.edit_note_rounded, 
                  shadows: isDark ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 8)] : null,
                ),
                tooltip: "Edit Plan Inputs",
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InputScreen(
                    toggleTheme: widget.toggleTheme,
                    changeAccentColor: widget.changeAccentColor,
                    currentAccentColor: widget.currentAccentColor,
                    currentThemeMode: widget.currentThemeMode,
                ))),
              ),
           ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 15),
              if (canShowMeaningfulPlan) ...[
                _buildInfoCard(
                  context, 
                  'Total Monthly Savings:', 
                  '\$${totalMonthlySavings.toStringAsFixed(2)}',
                  Icons.account_balance_outlined, 
                  savingsColor, 
                  isPrimary: true, 
                  delay: 300.ms
                ),
                if (_rolledOverSavings > 0)
                   _buildInfoCard(
                      context, 
                      '(Includes Rolled-Over Savings):', 
                      '\$${_rolledOverSavings.toStringAsFixed(2)}',
                      Icons.add_task_rounded, 
                      extraSavingsColor, 
                      delay: 350.ms 
                    ),
                _buildInfoCard(context, 'Daily Groceries & Other Needs:', '\$${widget.plan.recommendedDailySpendingAndGroceries_formatted}', Icons.shopping_basket_rounded, dailySpendingColor, isPrimary: true, delay: 400.ms ),
                _buildInfoCard(context, 'Monthly Special Food Fund:', '\$${widget.plan.monthlySpecialFoodFund_formatted}', Icons.cake_rounded, specialFoodColor, delay: 500.ms),
                SizedBox(height: 25),
                if(widget.plan.recommendedDailySpendingAndGroceries > 0)
                  NeumorphicButton(
                    onPressed: canRolloverToday ? _addDailyAllowanceToSavings : null,
                    backgroundColor: canRolloverToday 
                        ? (isDark ? Theme.of(context).colorScheme.secondary.withOpacity(0.5) : Theme.of(context).colorScheme.secondary.withOpacity(0.8)) 
                        : (isDark ? Colors.grey[800]!.withOpacity(0.5) : Colors.grey[350]),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_task_outlined, size: 22, color: rolloverButtonTextColor),
                        SizedBox(width: 10),
                        Text(canRolloverToday ? "Roll Over Today's Allowance" : "Today's Allowance Processed", 
                             style: Theme.of(context).textTheme.labelLarge?.copyWith(color: rolloverButtonTextColor)),
                      ],
                    ),
                  ).animate(target: canRolloverToday ? 1 : 0).fadeIn(delay: 550.ms).slideY(begin:0.3),
                SizedBox(height: 15),
                NeumorphicContainer(
                  type: NeumorphicType.flat, padding: EdgeInsets.all(18),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  child: Column(
                      children: [
                         Text("Strategy: ${widget.plan.appliedStrategyName}", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                         SizedBox(height: 8),
                         if(widget.plan.savingsTierDetail.isNotEmpty)
                           Padding(
                             padding: const EdgeInsets.only(bottom:8.0),
                             child: Text(widget.plan.savingsTierDetail, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                           ),
                         Text(
                          widget.plan.statusMessage.replaceFirst("${widget.plan.appliedStrategyName}. ", "").replaceFirst("(${widget.plan.appliedStrategyName})", "").trim(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    )
                ).animate().fadeIn(delay: 600.ms),
              ] else ...[ 
                NeumorphicContainer(
                  type: NeumorphicType.flat,
                  backgroundColor: isDark ? Theme.of(context).colorScheme.error.withOpacity(0.15) : Theme.of(context).colorScheme.error.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal:16.0, vertical: 24.0),
                  child: Column(
                      children: [
                        Icon(Icons.error_outline_rounded, size: 52, color: Theme.of(context).colorScheme.error),
                        SizedBox(height: 18),
                        Text(widget.plan.appliedStrategyName.isNotEmpty ? widget.plan.appliedStrategyName : 'Plan Status',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.error), textAlign: TextAlign.center),
                        SizedBox(height: 12),
                        Text(widget.plan.statusMessage, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error), textAlign: TextAlign.center),
                      ],
                    ),
                ).animate().fadeIn(delay: 300.ms).shake(hz: 2, duration: 400.ms, curve: Curves.easeOut),
              ],
              SizedBox(height: 24),
              Center( 
                child: TextButton.icon(
                  icon: Icon(Icons.insights_rounded, color: Theme.of(context).primaryColor),
                  label: Text("View Calculation Breakdown", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).primaryColor)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InsightsScreen(plan: widget.plan))),
                  style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                ),
              ).animate().fadeIn(delay: (canShowMeaningfulPlan ? 700 : 400).ms),
              SizedBox(height: 20),
            ],
          ),
        ),
           ),
     );
  }
}

class InsightsScreen extends StatefulWidget {
  final SavingsPlan plan;
  InsightsScreen({required this.plan});

  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isBold = false, Color? valueColor, bool isEmphasized = false}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final baseStyle = Theme.of(context).textTheme.bodyLarge;
    final valueStyle = baseStyle?.copyWith(
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          color: valueColor ?? (isDark && isEmphasized ? Theme.of(context).primaryColor : baseStyle.color),
          fontSize: isEmphasized ? (baseStyle.fontSize ?? 15) + 2.5 : baseStyle.fontSize,
          shadows: isDark && isEmphasized ? [Shadow(color: Theme.of(context).primaryColor.withOpacity(0.4), blurRadius: 6)] : null,
        );
    final labelStyle = baseStyle?.copyWith(color: baseStyle.color?.withOpacity(0.65));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          SizedBox(width: 16),
          Text(value, style: valueStyle, textAlign: TextAlign.right),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    bool canShowFullDetails = plan.calculationSuccess && (plan.guaranteedMonthlySavings > 0 || plan.recommendedDailySpendingAndGroceries > 0 || plan.moneyAfterTransportAndSpecialFood >=0);
    Color emphasisColor = Theme.of(context).primaryColor;
    Color savingsColorInsight = Theme.of(context).brightness == Brightness.dark ? Color(0xFF66BB6A) : Color(0xFF388E3C);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text("Calculation Breakdown")),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: NeumorphicContainer(
            type: NeumorphicType.flat,
            padding: const EdgeInsets.all(22.0),
            backgroundColor: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Financial Plan Details", style: Theme.of(context).textTheme.headlineSmall),
                 if(plan.appliedStrategyName.isNotEmpty &&
                    !["Error", "Income Deficit", "Funds Exhausted Early", "Zero Remainder"].contains(plan.appliedStrategyName))
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 2.0),
                    child: Text("Strategy: ${plan.appliedStrategyName}", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: emphasisColor, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
                  ),
                Divider(height: 30, thickness: 1),

                _buildDetailRow(context, "Monthly Income:", "\$${plan.monthlyIncome_formatted}"),
                _buildDetailRow(context, "Less Transportation:", "-\$${plan.monthlyTransportFee_formatted}"),
                _buildDetailRow(context, "Income After Transport (MAT):", "\$${plan.moneyAfterTransportation_formatted}", isBold: true),
                SizedBox(height: 12),

                _buildDetailRow(context, "Less Monthly Special Food Fund:", "-\$${plan.monthlySpecialFoodFund_formatted}"),
                _buildDetailRow(context, "Remainder (MATSF):", "\$${plan.moneyAfterTransportAndSpecialFood_formatted}", isBold: true, isEmphasized: true, valueColor: plan.moneyAfterTransportAndSpecialFood < 0 ? Theme.of(context).colorScheme.error : null),
                SizedBox(height: 12),

                if (canShowFullDetails) ...[
                  if(plan.savingsTierDetail.isNotEmpty)
                     _buildDetailRow(context, "Savings Approach:", plan.savingsTierDetail, isEmphasized: false),
                  _buildDetailRow(context, "Planned Monthly Savings:", "\$${plan.guaranteedMonthlySavings_formatted}", isBold: true, isEmphasized: true, valueColor: savingsColorInsight),
                  _buildDetailRow(context, "Pot for Daily Needs (monthly):", "\$${plan.monthlyPotForDailySpendingAndGroceries_formatted}"),
                  _buildDetailRow(context, "Daily Groceries & All Other Needs:", "\$${plan.recommendedDailySpendingAndGroceries_formatted}", isBold: true, isEmphasized: true, valueColor: emphasisColor),
                  
                  if (plan.statusMessage.contains("CRITICAL NOTE:") || plan.statusMessage.contains("extreme savings approach"))
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: NeumorphicContainer(
                        type: NeumorphicType.concave,
                        padding: EdgeInsets.all(12),
                        backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        child: Text(
                          plan.statusMessage.substring(plan.statusMessage.indexOf("NOTE:") > -1 ? plan.statusMessage.indexOf("NOTE:") : (plan.statusMessage.indexOf("extreme") > -1 ? plan.statusMessage.indexOf("Your entire") : plan.statusMessage.length)),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ),
                ] else if (plan.statusMessage.isNotEmpty) ... [
                   Divider(height: 30, thickness: 1),
                   Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(plan.statusMessage, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                  ),
                ],
                 Divider(height: 35, thickness: 1),
                  Text(
                    "This plan prioritizes maximum savings. The daily figure must cover ALL groceries and other day-to-day expenses. Discipline is key.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                    textAlign: TextAlign.center,
                  ),
              ],
            ).animate().fadeIn(duration: 400.ms),
          ),
        ),
           ),
     );
  }
}