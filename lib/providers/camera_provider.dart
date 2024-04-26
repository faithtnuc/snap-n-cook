import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraProvider extends ChangeNotifier{
  late final CameraController cameraController;
  late List<CameraDescription> cameras;

  bool isCameraInitialized = false;

  initCamera() async{
    if(await Permission.camera.request().isGranted){
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize();
      isCameraInitialized = true;
      notifyListeners();
    }else{
      print("Permission denied");
    }
  }

}