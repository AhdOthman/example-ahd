import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/provider/homeprovider.dart';
import 'package:subrate/provider/notificationprovider.dart';
import 'package:subrate/provider/profileprovider.dart';
import 'package:subrate/provider/programprovider.dart';
import 'package:subrate/provider/storageprovider.dart';
import 'package:subrate/provider/taskprovider.dart';
import 'package:subrate/provider/walletprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/screens/onboarding/onboarding_screen.dart';
import 'package:subrate/screens/splash/splash_screen.dart';
import 'package:subrate/translations/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set the status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(EasyLocalization(
      startLocale: const Locale('en'),
      path: 'assets/translations',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      assetLoader: const CodegenLoader(),
      child: MyApp(
        showHome: showHome,
      )));
}

class MyApp extends StatelessWidget {
  final bool? showHome;

  const MyApp({super.key, this.showHome});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Routers routers = Routers();
    return OverlaySupport.global(
      child: Sizer(builder: (context, orientation, deviceType) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: MultiProvider(
            providers: [
              ListenableProvider<AuthProvider>(create: (_) => AuthProvider()),
              ListenableProvider<AppProvider>(create: (_) => AppProvider()),
              ListenableProvider<NotificationProvider>(
                  create: (_) => NotificationProvider()),
              ListenableProvider<HomeProvider>(create: (_) => HomeProvider()),
              ListenableProvider<Profileprovider>(
                  create: (_) => Profileprovider()),
              ListenableProvider<ProgramProvider>(
                  create: (_) => ProgramProvider()),
              ListenableProvider<TaskProvider>(create: (_) => TaskProvider()),
              ListenableProvider<StorageProvider>(
                  create: (_) => StorageProvider()),
              ListenableProvider<WalletProvider>(
                  create: (_) => WalletProvider()),
            ],
            child: Consumer<AuthProvider>(builder: (context, auth, _) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                title: 'Subrate',
                theme: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  fontFamily: 'Cascadia Code',
                  // This is the theme of your application.
                  //
                  // TRY THIS: Try running your application with "flutter run". You'll see
                  // the application has a purple toolbar. Then, without quitting the app,
                  // try changing the seedColor in the colorScheme below to Colors.green
                  // and then invoke "hot reload" (save your changes or press the "hot
                  // reload" button in a Flutter-supported IDE, or press "r" if you used
                  // the command line to start the app).
                  //
                  // Notice that the counter didn't reset back to zero; the application
                  // state is not lost during the reload. To reset the state, use hot
                  // restart instead.
                  //
                  // This works for code too, not just values: Most code changes can be
                  // tested with just a hot reload.
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                routes: routers.routes,
                home: auth.isAuth
                    ? const SplashScreen()
                    : FutureBuilder(
                        future: auth.autologin(),
                        builder: (context, authSnap) {
                          print('auth token ${auth.token} ${auth.isAuth}');
                          if (authSnap.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (authSnap.hasError) {
                            return const Center(
                                child: Text('An error occurred'));
                          } else {
                            return showHome == true
                                ? const SplashScreen()
                                : const OnBoardingScreen();
                          }
                        },
                      ),
              );
            }),
          ),
        );
      }),
    );
  }

  // Widget _buildHomeScreen(BuildContext context, AuthProvider auth) {
  //   return auth.isAuth
  //       ? const SplashScreen()
  //       : FutureBuilder(
  //           future: auth.autologin(),
  //           builder: (context, authSnap) {
  //             print('auth token ${auth.token} ${auth.isAuth}');
  //             if (authSnap.connectionState == ConnectionState.waiting) {
  //               return const Center(
  //                 child: CircularProgressIndicator(),
  //               );
  //             } else if (authSnap.hasError) {
  //               return const Center(child: Text('An error occurred'));
  //             } else {
  //               return showHome == true
  //                   ? const SplashScreen()
  //                   : const OnBoardingScreen();
  //             }
  //           },
  //         );
  // }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
