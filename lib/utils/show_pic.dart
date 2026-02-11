import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class ShowPic extends StatefulWidget {
  const ShowPic({super.key, required this.image});

  final File image;

  @override
  State<ShowPic> createState() => _ShowPicState();
}

class _ShowPicState extends State<ShowPic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () {
            getTempFromImageApi(widget.image);
          },
          child: const Text(
            "CLICK",
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
              color: Colors.black,
              radius: 40,
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (temp != '')
                    SizedBox(
                      height: 100,
                      child: Text('Temperature: $temp',
                          style: TextStyle(
                              fontSize: 26,
                              height: 1.5,
                              color: temp == 'Temperature not detected'
                                  ? Colors.red
                                  : Colors.black)),
                    ),
                  Image.file(
                    widget.image,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
    );
  }

  String temp = '';

  bool isLoading = false;

  Map<String, dynamic>? imageApiRes;
  getTempFromImageApi(file) async {
    isLoading = true;
    setState(() {});

    final network = dio.Dio();

    try {
      final fileName = file.path.split('/').last;
      final formData = dio.FormData.fromMap({
        "image": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await network.post(
        'https://jazzhygiene.com/api/imageread',
        data: formData,
        options: dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is String) {
          imageApiRes = jsonDecode(response.data);
        } else {
          imageApiRes = response.data;
        }

        if (imageApiRes != null && imageApiRes!['temperature'] != null) {
          temp = imageApiRes!['temperature'];
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint("Upload failed: $e");
    } finally {
      isLoading = false;
      setState(() {});
    }
  }
}
