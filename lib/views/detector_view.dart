import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/detector_provider.dart';
import 'package:snapncook/providers/ingredient_list_provider.dart';
import 'package:snapncook/views/detected_ingredients_view.dart';
import 'package:ultralytics_yolo/camera_preview/camera_preview.dart';
import 'package:ultralytics_yolo/predict/detect/detect.dart';

class DetectorView extends StatelessWidget {
  const DetectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=> Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const DetectedIngredientsView()), (route) => false), label: const Text("Ready to Cook?", style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.deepOrange.shade600, foregroundColor: Colors.black,),
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
                                  if (!context.read<IngredientListProvider>().ingredients.any((ingredient) => ingredient.label == event.last?.label)) {
                                    context.read<IngredientListProvider>().addIngredient('${event.last?.label}', event.last!.confidence, event.last!.boundingBox);
                                  }
                                }
                              },
                            );
                          }),
                      Consumer<IngredientListProvider>(
                        builder: (BuildContext context, ingredientListProvider, Widget? child) {
                          return ingredientListProvider.ingredients.isNotEmpty ? Padding(
                            padding: EdgeInsets.fromLTRB(4.w, 10.h, 50.w, 6.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ingredients", style: TextStyle(fontSize: 19.sp, color: Colors.grey.shade200, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: ingredientListProvider.ingredients.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        "- ${ingredientListProvider.ingredients[index].label.toUpperCase()}", style: TextStyle(fontSize: 18.sp, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ) : const SizedBox.shrink();
                        },
                      )
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
