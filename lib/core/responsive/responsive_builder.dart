import 'package:flutter/material.dart';
import 'context_responsive_ext.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  bool isTablet,
);

class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, context.isTablet);
      },
    );
  }
}
