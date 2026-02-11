import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payhive/utils/widgets/image_builder.dart';

class ViewDocument extends ModalRoute<void> {
  ViewDocument({
    this.docPath,
    this.file,
  });

  final String? docPath;
  final File? file;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.2);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation animation,
    Animation secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  bool findExtensionOfDocument() {
    if (docPath!.contains(".pdf") ||
        docPath!.contains(".doc") ||
        docPath!.contains(".docx")) {
      return true;
    } else {
      return false;
    }
  }

  showDocument() {

    /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ///
    /// ----------------- LOAD DOCUMENT FROM NETWORK ----------------------- ///
    /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ///

    if (docPath!.contains("http")) {
      return imageBuilder(
        docPath,
        height: 50.0,
        width: 50.0,
      );
    }

    /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ///
    /// --------------- LOAD DOCUMENT FROM LOCAL DEVICE -------------------- ///
    /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ///

    else {
      return Image.file(
        file!,
      );
    }
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
        child: Container(
      height: MediaQuery.of(context).size.height / 1.85,
      width: MediaQuery.of(context).size.width / 1.06,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width / 1.16,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(MediaQuery.of(context).size.width / 20),
                bottomRight:
                    Radius.circular(MediaQuery.of(context).size.width / 20),
                bottomLeft:
                    Radius.circular(MediaQuery.of(context).size.width / 20),
              ),
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(MediaQuery.of(context).size.width / 30),
              child: showDocument(),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius:
                      BorderRadius.circular(MediaQuery.of(context).size.width),
                ),
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width / 100),
                child: Icon(CupertinoIcons.clear_circled,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.height / 34),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

///  Widget _buildOverlayContent(BuildContext context) {
//     return Center(
//         child: Container(
//       height: MediaQuery.of(context).size.height / 1.85,
//       width: MediaQuery.of(context).size.width / 1.06,
//       decoration: const BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height / 2,
//             width: MediaQuery.of(context).size.width / 1.16,
//             padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft:
//                     Radius.circular(MediaQuery.of(context).size.width / 20),
//                 bottomRight:
//                     Radius.circular(MediaQuery.of(context).size.width / 20),
//                 bottomLeft:
//                     Radius.circular(MediaQuery.of(context).size.width / 20),
//               ),
//             ),
//             child: ClipRRect(
//               borderRadius:
//                   BorderRadius.circular(MediaQuery.of(context).size.width / 30),
//               child: showDocument(),
//             ),
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.redAccent,
//                   borderRadius:
//                       BorderRadius.circular(MediaQuery.of(context).size.width),
//                 ),
//                 padding:
//                     EdgeInsets.all(MediaQuery.of(context).size.width / 100),
//                 child: Icon(CupertinoIcons.clear_circled,
//                     color: Colors.black,
//                     size: MediaQuery.of(context).size.height / 34),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
