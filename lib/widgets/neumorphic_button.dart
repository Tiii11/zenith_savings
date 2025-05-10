// lib/widgets/neumorphic_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // <<< ADD THIS IMPORT
import 'neumorphic_container.dart'; 

class NeumorphicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? splashColor;

  const NeumorphicButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.splashColor,
  }) : super(key: key);

  @override
  _NeumorphicButtonState createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseButtonColor = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    final Color defaultSplashColor = isDark 
                                     ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                     : Theme.of(context).colorScheme.primary.withOpacity(0.1);


    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      child: NeumorphicContainer(
        type: _isPressed ? NeumorphicType.concave : NeumorphicType.convex,
        borderRadius: widget.borderRadius,
        backgroundColor: baseButtonColor,
        padding: EdgeInsets.zero, 
        distance: 4.0, 
        blurRadius: 8.0,
        child: Material( 
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed, 
            borderRadius: BorderRadius.circular(widget.borderRadius),
            splashColor: widget.splashColor ?? defaultSplashColor,
            highlightColor: widget.splashColor?.withOpacity(0.5) ?? defaultSplashColor.withOpacity(0.5),
            child: Padding(
              padding: widget.padding,
              child: widget.child,
            ),
          ),
        ),
      ),
    )
    .animate(target: _isPressed ? 0.98 : 1.0) // Animate scale based on press state
    .scale(duration: 100.ms, curve: Curves.easeOut) // Use .ms extension
    .animate(target: widget.onPressed == null ? 0.6 : 1.0) // Animate fade if disabled
    .fade(duration: 200.ms); // Use .ms extension
  }
}