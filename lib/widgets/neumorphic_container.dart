// lib/widgets/neumorphic_container.dart
import 'package:flutter/material.dart';

enum NeumorphicType {
  flat, // Slight shadow for definition
  convex, // Extruded out
  concave // Pressed in
}

class NeumorphicContainer extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor; // Explicit background color for the container
  final NeumorphicType type;
  final double blurRadius;
  final double distance;
  final BoxShape shape;
  final Gradient? gradient; // For more advanced styling

  NeumorphicContainer({
    Key? key,
    this.child,
    this.borderRadius = 15.0,
    this.padding = const EdgeInsets.all(12.0),
    this.backgroundColor,
    this.type = NeumorphicType.flat,
    this.blurRadius = 10.0, // Default blur
    this.distance = 5.0,   // Default distance
    this.shape = BoxShape.rectangle,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor = backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    // Define shadow colors based on the baseColor to ensure they blend well
    Color lightShadowColor;
    Color darkShadowColor;

      if (isDark) {
      // Slightly softer shadows for dark mode
      lightShadowColor = _getSlightlyLighter(baseColor, 0.12); // Was 0.15
      darkShadowColor = _getSlightlyDarker(baseColor, 0.30);   // Was 0.35
    } else {
      lightShadowColor = Colors.white.withOpacity(0.8); // Was 0.9
      darkShadowColor = Colors.grey.shade400.withOpacity(0.6); // Was 0.8
    }
    
    if (baseColor.computeLuminance() < 0.05 && isDark) { 
        lightShadowColor = Colors.white.withOpacity(0.05); // Was 0.06
        darkShadowColor = Colors.black.withOpacity(0.45); // Was 0.5
    }

    List<BoxShadow> boxShadows;

    switch (type) {
      case NeumorphicType.concave:
        boxShadows = [
          // Simulating inner shadow with inset-like effect
          BoxShadow(
              color: darkShadowColor,
              offset: Offset(distance * 0.5, distance * 0.5), // Dark shadow inside top-left
              blurRadius: blurRadius * 0.8,
              spreadRadius: -1 // Negative spread for inset feel
              ),
          BoxShadow(
              color: lightShadowColor,
              offset: Offset(-distance * 0.5, -distance * 0.5), // Light shadow inside bottom-right
              blurRadius: blurRadius * 0.8,
              spreadRadius: -1),
        ];
        break;
      case NeumorphicType.convex:
        boxShadows = [
          BoxShadow(
              color: darkShadowColor,
              offset: Offset(distance, distance),
              blurRadius: blurRadius),
          BoxShadow(
              color: lightShadowColor,
              offset: Offset(-distance, -distance),
              blurRadius: blurRadius),
        ];
        break;
      case NeumorphicType.flat:
      default:
        boxShadows = [
          BoxShadow(
              color: darkShadowColor.withOpacity(isDark ? 0.5 : 0.3), // Softer for flat
              offset: Offset(distance * 0.6, distance * 0.6),
              blurRadius: blurRadius * 0.7),
          BoxShadow(
              color: lightShadowColor.withOpacity(isDark ? 0.7 : 0.9), // Softer for flat
              offset: Offset(-distance * 0.6, -distance * 0.6),
              blurRadius: blurRadius * 0.7),
        ];
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        gradient: gradient,
        borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
        shape: shape,
        boxShadow: boxShadows,
      ),
      child: child,
    );
  }

  Color _getSlightlyLighter(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  Color _getSlightlyDarker(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final newLightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }
}
