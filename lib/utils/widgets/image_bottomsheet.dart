// import 'package:flutter/material.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
//
// class AppBottomSheet {
//   static kImagePickerBottomSheet(
//     BuildContext context, {
//     VoidCallback? onCameraTap,
//     VoidCallback? onGalleryTap,
//   }) {
//     return showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return _Popover(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: height / 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   GestureDetector(
//                     onTap: onCameraTap,
//                     child: Container(
//                       width: 110,
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: appColors.primaryLight.withOpacity(0.4),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.camera_alt_rounded,
//                               size: 40, color: appColors.primaryLight),
//                           SizedBox(height: height / 70),
//                           Text(
//                             "Camera",
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: appColors.primaryLight,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "Poppins"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: onGalleryTap,
//                     child: Container(
//                       width: 110,
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: appColors.primaryLight.withOpacity(0.4),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(Icons.photo_rounded,
//                               size: 40, color: appColors.primaryLight),
//                           SizedBox(height: height / 70),
//                           Text(
//                             "Gallery",
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                                 color: appColors.primaryLight,
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: "Poppins"),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: height / 30),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   static kDefaultBottomSheet(BuildContext context, {Widget? body}) {
//     return showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (context) {
//         return _Popover(
//           child: body,
//         );
//       },
//     );
//   }
// }
//
// class _Popover extends StatelessWidget {
//   const _Popover({this.child});
//
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return SingleChildScrollView(
//       child: Container(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         margin: EdgeInsets.all(height / 20),
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [_buildHandle(context), if (child != null) child!],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHandle(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return FractionallySizedBox(
//       widthFactor: 0.25,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Container(
//           height: 5.0,
//           decoration: BoxDecoration(
//             color: theme.dividerColor,
//             borderRadius: const BorderRadius.all(Radius.circular(2.5)),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//

import 'package:flutter/material.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class AppBottomSheet {
  static Future<void> kImagePickerBottomSheet(
    BuildContext context, {
    VoidCallback? onCameraTap,
    VoidCallback? onGalleryTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(24),
              // Softer, more modern shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    "Choose Image Source",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Select where you'd like to get your image from.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color
                        ?.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Animate the buttons' entry
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 30),
                        child: child,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ImageOptionButton(
                        icon: Icons.camera_alt_outlined,
                        label: "Camera",
                        color: appColors.primaryColor,
                        onTap: onCameraTap,
                      ),
                      _ImageOptionButton(
                        icon: Icons.photo_library_outlined,
                        label: "Gallery",
                        color: appColors.primaryColor,
                        onTap: onGalleryTap,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ImageOptionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ImageOptionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<_ImageOptionButton> createState() => _ImageOptionButtonState();
}

class _ImageOptionButtonState extends State<_ImageOptionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.forward();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          width: 130,
          height: 120,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: widget.color.withValues(alpha: 0.1),
                child: Icon(widget.icon, size: 28, color: widget.color),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
