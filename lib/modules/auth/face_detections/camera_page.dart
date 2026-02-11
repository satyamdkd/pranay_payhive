import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:payhive/modules/auth/face_detections/faces.dart';
import 'package:payhive/modules/auth/face_detections/verify_&_submit.dart';
import 'package:payhive/modules/auth/salary/view/aadhar_verify.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import '../../../services/di/di.dart';
import '../../../utils/theme/apptheme.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
    required this.customPaint,
    required this.onImage,
    this.onCameraFeedReady,
    this.onCameraLensDirectionChanged,
    this.initialCameraLensDirection = CameraLensDirection.back,
  });

  final CustomPaint? customPaint;
  final Function(InputImage inputImage) onImage;
  final VoidCallback? onCameraFeedReady;

  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || widget.customPaint == null) {
      return Center(
        child: CircularProgressIndicator(color: appColors.white),
      );
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(height / 30),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(height / 40),
                  child: CameraPreview(
                    _controller!,
                    child: widget.customPaint!,
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: height / 40),
                  child: Row(
                    children: [
                      SizedBox(width: width / 40),
                      GestureDetector(
                        onTap: () {
                          if (isSelfieReUploading) {
                            Get.back();
                          } else {
                            Get.offAll(AadharVerifySalaried(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 500));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: appColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: appColors.bottomNavLightColor,
                            ),
                          ),
                          height: height / 10,
                          width: height / 10,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.clear_rounded,
                            size: height / 14,
                            color: appColors.bottomNavLightColor,
                          ),
                        ),
                      ),
                      SizedBox(width: width / 20),
                      Text(
                        "Focus on your face",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: appColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: height / 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: height / 3,
                  child: InkWell(
                    onTap: takePicture,
                    child: Image.asset(
                      "assets/images/button_photo.png",
                      height: height / 4.5,
                    ),
                  ),
                ),
                Positioned(
                  bottom: height / 40,
                  child: Text(
                    "Ensure proper lighting for smooth KYC processing.\nIf you are wearing glasses, a cap, or anything that\nhides your full face, please remove it before\ntaking a selfie.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: appColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: height / 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget child() => Padding(
        padding: EdgeInsets.all(height / 20),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    SizedBox(width: width / 80),
                    Container(
                      decoration: BoxDecoration(
                        color: appColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: appColors.bottomNavLightColor,
                        ),
                      ),
                      height: height / 10,
                      width: height / 10,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.clear_rounded,
                        size: height / 14,
                        color: appColors.bottomNavLightColor,
                      ),
                    ),
                    SizedBox(width: width / 20),
                    Text(
                      "Focus on your fac",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: appColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: height / 20,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                child: InkWell(
                  onTap: takePicture,
                  child: Image.asset(
                    "assets/images/button_photo.png",
                    height: height / 4.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  SizedBox spacing({passedHeight}) =>
      SizedBox(height: passedHeight ?? height / 20);

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      startLiveFeed();
    }
  }

  Future startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<void> takePicture() async {
    if (facesDetected.length > 1) {
      showSnackBar(
        message:
            "There are too many people in the frame. Please take a selfie of yourself only.",
        title: "Face Verification",
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (facesDetected.isEmpty) {
      showSnackBar(
        message: "No face detected! Try again.",
        title: "Face Verification",
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile file = await _controller!.takePicture();
      if (mounted) {
        Get.off(() => VerifyAndSubmit(imagePath: file.path));
      }
    } catch (e) {
      debugPrint("Error capturing image: $e");
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    /// get image rotation
    /// it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    //// `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    /// in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    /// print(
    ///     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        /// front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        /// back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);

      /// print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;

    /// print('final rotation: $rotation');

    /// get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    /// validate format depending on platform
    /// only supported formats:
    /// * nv21 for Android
    /// * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
