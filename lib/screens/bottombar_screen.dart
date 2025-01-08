import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subrate/provider/appprovider.dart';
import 'package:subrate/screens/home/home_screen.dart';
import 'package:subrate/screens/profile/profile_screen.dart';
import 'package:subrate/screens/programs/programs_screen.dart';
import 'package:subrate/screens/wallet/wallet_screen.dart';
import 'package:subrate/theme/app_colors.dart';
import 'package:subrate/theme/assets_managet.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'package:subrate/widgets/app/bottombar_item.dart';

class BottomBarScreen extends StatefulWidget {
  static const String routeName = '/bottomappbar';

  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // int _selectedIndex = 0;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     print(_selectedIndex);
  //   });
  // }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ProgramsScreen(),
    const WalletScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _widgetOptions.elementAt(appProvider.selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: BottomBarItem(
              iconPath: home,
              selectedIndex: appProvider.selectedIndex,
              index: 0,
              title:
                  // authProvider.languageKey == 'ar' ? 'الرئيسية' : 'Home',

                  LocaleKeys.home.tr(),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomBarItem(
              iconPath: progrmsIcon,
              selectedIndex: appProvider.selectedIndex,
              index: 1,
              title: LocaleKeys.programs.tr(),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomBarItem(
              iconPath: wallet,
              selectedIndex: appProvider.selectedIndex,
              index: 2,
              title: LocaleKeys.wallet.tr(),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BottomBarItem(
              isForProfile: true,
              iconPath: account,
              selectedIndex: appProvider.selectedIndex,
              index: 3,
              title: LocaleKeys.account.tr(),
            ),
            label: '',
          ),
        ],
        currentIndex: appProvider.selectedIndex,
        onTap: appProvider.onItemTapped,
      ),
    );
  }
}
