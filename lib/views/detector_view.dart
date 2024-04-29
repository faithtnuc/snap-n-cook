import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:snapncook/providers/detector_provider.dart';
import 'package:ultralytics_yolo/camera_preview/camera_preview.dart';
import 'package:ultralytics_yolo/predict/detect/detect.dart';

class DetectorView extends StatefulWidget {
  const DetectorView({super.key});

  @override
  State<DetectorView> createState() => _DetectorViewState();
}

class _DetectorViewState extends State<DetectorView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetectorProvider>(
        builder: (context, detectorProvider, Widget? child) {
          return FutureBuilder<bool>(
            future: detectorProvider.checkPermissions(),
            builder: (context, snapshot) {
              final allPermissionsGranted = snapshot.data ?? false;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (allPermissionsGranted) {
                return const Center(
                  child: Text('Permissions not granted'),
                );
              }

              return FutureBuilder<ObjectDetector>(
                future: detectorProvider.initObjectDetectorWithLocalModel(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    //print(snapshot.error);
                    return const Center(child: Text('Error loading model'));
                  }

                  final predictor = snapshot.data;
                  if (predictor == null) {
                    return const Center(child: Text('Model not loaded yet'));
                  }
                  return Stack(
                    children: [
                      UltralyticsYoloCameraPreview(
                          predictor: predictor,
                          controller: detectorProvider.controller,
                          onCameraCreated: (){
                            predictor.loadModel(useGpu: false);
                          },
                        ),
                      /*StreamBuilder(stream: predictor.detectionResultStream, builder: (context, snapshot){
                        //predictor.setConfidenceThreshold(0.7);
                        final DetectedObject secondPredictor;
                        if(snapshot.data != null){
                         secondPredictor = snapshot.data!.last!;
                        }else{return Text("error");}
                        final Rect rect = Rect.fromLTRB(secondPredictor.boundingBox.left, secondPredictor.boundingBox.top, secondPredictor.boundingBox.right, secondPredictor.boundingBox.bottom);
                        return CustomPaint(
                          size: Size(rect.left-rect.right, rect.top-rect.bottom),
                          painter: MyPainter(rect),
                        );
                                          /*return Column(
                                            children: [
                                              Text("${snapshot.data?.first?.label}", style: TextStyle(color: Colors.red, fontSize: 16),),
                                              Text("${snapshot.data?.first?.confidence}", style: TextStyle(color: Colors.black, fontSize: 12),),
                                              Text("${snapshot.data?.first?.boundingBox.}", style: TextStyle(color: Colors.blue, fontSize: 12),),
                                            ],
                                          );*/
                                        })*/
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/*class MyPainter extends CustomPainter {
  MyPainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Color of the box
      ..style = PaintingStyle.stroke // Stroke style
      ..strokeWidth = 2.0; // Stroke width

    // Draw the box on the canvas
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}*/
