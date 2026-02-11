import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(
    this.faces,
    this.imageSize,
    this.rotation,
    this.cameraLensDirection,
  );

  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.green;

    for (final Face face in faces) {
      final double left = translateX(
        face.boundingBox.left,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final double top = translateY(
        face.boundingBox.top,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final double right = translateX(
        face.boundingBox.right,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );
      final double bottom = translateY(
        face.boundingBox.bottom,
        size,
        imageSize,
        rotation,
        cameraLensDirection,
      );

      /// Fixed Oval Dimensions (Adjust as Needed)
      final double ovalWidth = (right - left) * 1.2;

      /// Slightly larger than the detected face width
      final double ovalHeight = (bottom - top) * 1.5;

      /// Taller for better coverage

      /// Center the oval on the detected face
      final double ovalLeft = left - (ovalWidth - (right - left)) / 2;
      final double ovalTop = top - (ovalHeight - (bottom - top)) / 2;

      final Rect ovalRect =
          Rect.fromLTWH(ovalLeft, ovalTop, ovalWidth, ovalHeight);

      /// Draw the oval
      canvas.drawOval(ovalRect, paint);
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

/// ============================================================================
/// ============================= OLD CODE =====================================
/// ============================================================================

/// import 'package:camera/camera.dart';
/// import 'package:flutter/material.dart';
/// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
/// import 'coordinates_translator.dart';
//
/// class FaceDetectorPainter extends CustomPainter {
///   FaceDetectorPainter(
///     this.faces,
///     this.imageSize,
///     this.rotation,
///     this.cameraLensDirection,
///   );
//
///   final List<Face> faces;
///   final Size imageSize;
///   final InputImageRotation rotation;
///   final CameraLensDirection cameraLensDirection;
//
///   @override
///   void paint(Canvas canvas, Size size) {
///     final Paint paint1 = Paint()
///       ..style = PaintingStyle.stroke
///       ..strokeWidth = 2.0
///       ..color = Colors.green;
//
///     for (final Face face in faces) {
///       final left = translateX(
///         face.boundingBox.left,
///         size,
///         imageSize,
///         rotation,
///         cameraLensDirection,
///       );
///       final top = translateY(
///         face.boundingBox.top,
///         size,
///         imageSize,
///         rotation,
///         cameraLensDirection,
///       );
///       final right = translateX(
///         face.boundingBox.right,
///         size,
///         imageSize,
///         rotation,
///         cameraLensDirection,
///       );
///       final bottom = translateY(
///         face.boundingBox.bottom,
///         size,
///         imageSize,
///         rotation,
///         cameraLensDirection,
///       );
//
///       canvas.drawRect(
///         Rect.fromLTRB(left, top, right, bottom),
///         paint1,
///       );
///     }
///   }
//
///   @override
///   bool shouldRepaint(FaceDetectorPainter oldDelegate) {
///     return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
///   }
/// }
