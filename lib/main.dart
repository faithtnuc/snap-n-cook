import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:snapncook/providers/detector_provider.dart';
import 'package:snapncook/views/detected_ingredients_view.dart';
import 'package:snapncook/views/detector_view.dart';

import 'firebase_options.dart';
import 'providers/ingredient_list_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final userCredential =
    await FirebaseAuth.instance.signInAnonymously();
    //print("Signed in with temporary account.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        //print("Anonymous auth hasn't been enabled for this project.");
        throw Exception("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        //print("Unknown error.");
        throw Exception("Unknown error");
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DetectorProvider>(
          create: (context) => DetectorProvider(),
        ),
        ChangeNotifierProvider<IngredientListProvider>(
          create: (context) => IngredientListProvider(),
        )
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Snap & Cook',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const DetectorView(),
          );
        },
      ),
    );
  }
}
