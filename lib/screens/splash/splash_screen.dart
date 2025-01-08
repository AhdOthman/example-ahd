import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    final Routers routers = Routers();
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    appProvider.getCountries();
    Future.delayed(Duration(seconds: 2), () {
      authProvider.isAuth
          ? routers.navigateToBottomBarScreen(context)
          : routers.navigateToSigninScreen(context);
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
