import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/detector_provider.dart';
import 'package:snapncook/providers/ingredient_list_provider.dart';
import 'package:snapncook/views/detected_ingredients_view.dart';
import 'package:ultralytics_yolo/camera_preview/camera_preview.dart';
import 'package:ultralytics_yolo/predict/detect/detect.dart';

import '../utils/camera_guideline_painter.dart';

class DetectorView extends StatelessWidget {
  const DetectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.close, color: Colors.white, size: 20.6.sp,)),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 4.8.w),
            decoration: BoxDecoration(
                color: Colors.black45,
                border: Border.all(color: Colors.grey.shade600, width: 0.6),
                borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            child: const Text("Malzemelerinize sonraki sayfada ekleme çıkarma yapabilirsiniz", style: TextStyle(color: Colors.white),),
          ),
          SizedBox(height: 4.h,),
          FloatingActionButton(shape: RoundedRectangleBorder(side: BorderSide(width: 8.sp,color: Colors.white),borderRadius: BorderRadius.circular(20)),onPressed: ()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const DetectedIngredientsView()), (route) => false), backgroundColor: Colors.black.withAlpha(60), foregroundColor: Colors.white, child: Icon(size: 24.sp, Icons.check_rounded, shadows: const [Shadow(
            blurRadius: 20.0,
            color: Colors.white,
            offset: Offset(0, 0),
          ),],),),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                          onCameraCreated: () {
                            predictor.loadModel(useGpu: true);
                            predictor.setConfidenceThreshold(0.85);
                            predictor.detectionResultStream.listen(
                              (event) {
                                if (event != null && event.isNotEmpty) {
                                  if (!context.read<IngredientListProvider>().myIngredients.any((ingredient) => ingredient.label == event.last?.label)) {
                                    context.read<IngredientListProvider>().addIngredient('${event.last?.label}', event.last!.confidence, event.last!.boundingBox);
                                  }
                                }
                              },
                            );
                          }),
                      Consumer<IngredientListProvider>(
                        builder: (BuildContext context, ingredientListProvider, Widget? child) {
                          return ingredientListProvider.myIngredients.isNotEmpty ? Padding(
                            padding: EdgeInsets.fromLTRB(4.w, 10.h, 50.w, 6.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ingredients", style: TextStyle(fontSize: 19.sp, color: Colors.grey.shade200, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: ingredientListProvider.myIngredients.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "- ${ingredientListProvider.myIngredients[index].label.toUpperCase()}", style: TextStyle(fontSize: 18.sp, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ) : const SizedBox.shrink();
                        },
                      ),
                      Center(
                        child: CustomPaint(
                          painter: CameraGuidelinePainter(),
                          child: Container(),
                        ),
                      ),
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
