import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/routers/routers.dart';
import 'package:subrate/theme/assets_managet.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showHome = false;
  @override
  void initState() {
    final Routers routers = Routers();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 0), () async {
      final prefs = await SharedPreferences.getInstance();
      showHome = prefs.getBool('showHome') ?? false;
      print('showHome $showHome');
    });
    appProvider.getCountries();
    Future.delayed(Duration(seconds: 2), () async {
      print('auth token ${authProvider.token} ${authProvider.isAuth}');

      if (showHome == false) {
        routers.navigateToOnboardingScreenScreen(context);
      } else {
        authProvider.isAuth
            ? routers.navigateToBottomBarScreen(context)
            : routers.navigateToSigninNewScreen(context);
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeh = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.red,
      body: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                subrateLogo,
                height: sizeh * .1,
              ),
              SizedBox(
                height: sizeh * .06,
              ),
              // Center(
              //     child: Lottie.asset('assets/json/cbg1FzjOae.json',
              //         height: sizeh * .11)),
            ],
          ),
        ),
      ),
    );
  }
}
