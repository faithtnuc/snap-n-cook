import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapncook/providers/camera_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraProvider>(builder: (context, cameraProvider, Widget? child) {
        return cameraProvider.isCameraInitialized ? CameraPreview(cameraProvider.cameraController) : const Text("Loading Preview...");
      },),
    );
  }

  void _initCamera() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    await cameraProvider.initCamera();
  }

  void _disposeCamera() {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    cameraProvider.cameraController.dispose();
  }

}
