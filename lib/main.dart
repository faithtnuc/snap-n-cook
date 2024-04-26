import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapncook/providers/camera_provider.dart';
import 'package:snapncook/views/camera_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CameraProvider>(
      create: (context) => CameraProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CameraView(),
      ),
    );
  }
}

