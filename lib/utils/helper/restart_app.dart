import 'package:flutter/material.dart';

/// A utility widget that allows the entire application to be rebuilt from scratch.
///
/// Wrap your root widget (e.g., MaterialApp) with this class to enable
/// a "soft restart" of your application.
///
/// Example:
/// ```
/// void main() {
///   runApp(const RestartAppWidget(child: MyApp()));
/// }
///
/// // To trigger a restart from anywhere in the app:
/// RestartAppWidget.restartApp(context);
/// ```
class RestartApp extends StatefulWidget {
  final Widget child;

  const RestartApp({super.key, required this.child});

  /// A static method to find the [RestartAppWidgetState] from the widget tree
  /// and call its restart method. This is the public API for this widget.
  static void restartApp(BuildContext context) {
    // This looks up the widget tree for the state object and calls the method.
    // It's a robust way to access the state from any descendant widget.
    context.findAncestorStateOfType<_RestartAppWidgetState>()?.restartApp();
  }

  @override
  State<RestartApp> createState() => _RestartAppWidgetState();
}

class _RestartAppWidgetState extends State<RestartApp> {
  // A Key is used to uniquely identify a widget. When the key changes,
  // Flutter understands that it should discard the old widget and its state
  // and create a new one. This is the core of our restart logic.
  Key _key = UniqueKey();

  /// This method is called to trigger the "soft restart".
  void restartApp() {
    setState(() {
      // By changing the key, we force Flutter to rebuild the widget tree
      // below this point.
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // The KeyedSubtree widget is what links our _key to the child widget.
    // Whenever _key changes, KeyedSubtree and its entire child hierarchy
    // are discarded and recreated.
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}