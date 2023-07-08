/// Project run command : flutter run -d chrome --web-browser-flag "--disable-web-security"



import 'dart:io';
import 'package:app/screens/components/team_builder_screen.dart';
import 'package:app/screens/main_screen.dart';

import './providers/search_provider.dart';
import './providers/basic_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:provider/provider.dart';

import './screens/auth screens/login_screen.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   HttpOverrides.global = new MyHttpOverrides();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCE4ejo_vBIKWbKNyAGeabG4PaDnixhZxU",
          authDomain: "gamehub-984bb.firebaseapp.com",
          projectId: "gamehub-984bb",
          storageBucket: "gamehub-984bb.appspot.com",
          messagingSenderId: "693406391829",
          appId: "1:693406391829:web:7661712261c36f1a95781c",
          measurementId: "G-HFMQB3MLS2"
          // apiKey: "AIzaSyCE4ejo_vBIKWbKNyAGeabG4PaDnixhZxU",
          // authDomain: "gamehub-984bb.firebaseapp.com",
          // databaseURL: "", // **DATABASEURL MUST BE GIVEN.**
          // projectId: "gamehub-984bb",
          // storageBucket: "gamehub-984bb.appspot.com",
          // messagingSenderId: "693406391829",
          // appId: "1:693406391829:web:9a26cad439b111c495781c"),
      )
    );
  } else {
    await Firebase.initializeApp();
  }
  Provider.debugCheckInvalidValueType = null;


  runApp(

    ChangeNotifierProvider(
      create: (context)=>BasicProvider(),
    child: const MyApp(),
    )
    //   MultiProvider(
    //     providers:[
    //       // Provider<SearchProvider>(create: (_)=>SearchProvider(),),
    //       Provider<BasicProvider>(create: (_)=>BasicProvider(),),
    //
    //     ] ,
    //     child: const MyApp(),
    //   )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Something went Wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            print('firebase connected');

          }
          return MaterialApp(
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
              debugShowCheckedModeBanner: false,
              title: 'Fyba',
              theme: ThemeData(
                useMaterial3: true,
                primarySwatch: Colors.indigo,
              ),
              home:
              // MyHomePage(),
              //  ApiData(),
              // AdminPage()
              // ApiToFirestoreScreen()
              // const ApiDataFromFirebase()
              const LoginScreen()
            // HexWidget()
            //   const TeamBuilderScreen()
            // MainScreen()
            // LandingPage(),
          );
        });
  }
}
