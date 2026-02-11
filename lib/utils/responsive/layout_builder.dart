import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, double maxWidth, double maxHeight)
      builder;

  const ResponsiveLayout({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(
          context,
          constraints.maxWidth,
          constraints.maxHeight,
        );
      },
    );
  }
}
