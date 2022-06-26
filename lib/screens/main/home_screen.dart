import 'dart:developer';

import 'package:creative_movers/blocs/cache/cache_cubit.dart';
import 'package:creative_movers/blocs/nav/nav_bloc.dart';
import 'package:creative_movers/blocs/profile/profile_bloc.dart';
import 'package:creative_movers/di/injector.dart';
import 'package:creative_movers/helpers/routes.dart';
import 'package:creative_movers/resources/app_icons.dart';
import 'package:creative_movers/screens/main/buisness_page/views/my_page_tab.dart';
import 'package:creative_movers/screens/main/chats/views/chat_screen.dart';
import 'package:creative_movers/screens/main/contacts/views/contact_screen.dart';
import 'package:creative_movers/screens/main/feed/views/feed_screen.dart';
import 'package:creative_movers/screens/main/profile/views/account_settings_screen.dart';
import 'package:creative_movers/screens/main/profile/views/profile_edit_screen.dart';
import 'package:creative_movers/screens/main/widgets/nav_selected_icon.dart';
import 'package:creative_movers/screens/widget/welcome_dialog.dart';
import 'package:creative_movers/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:page_transition/page_transition.dart';

List<GlobalKey<NavigatorState>> homeNavigatorKeys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.showWelcomeDialog = false})
      : super(key: key);

  final bool? showWelcomeDialog;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screens = [
    const FeedScreen(),
    const MyPageTab(),
    const ContactScreen(),
    const ChatScreen(),
    const AccountSettingsScreen()
  ];

  int _navIndex = 0;
  final NavBloc _navBloc = injector.get<NavBloc>();

  @override
  void initState() {
    _navBloc.add(SwitchNavEvent(_navIndex));
    injector.get<ProfileBloc>().add(GetUsernameEvent());
    injector.get<ProfileBloc>().add(const FetchUserProfileEvent());
    Future.delayed(const Duration(seconds: 4))
        .then((value) => _showDialogIfNecessary());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavBloc, NavState>(
      bloc: _navBloc,
      listener: (context, state) {
        if (state is BuyerNavItemSelected) {
          _navIndex = state.selectedIndex;
        }
      },
      builder: (context, state) {
        return WillPopScope(
            onWillPop: () async {
              final isFirstRouteInCurrentTab =
                  !await homeNavigatorKeys[_navIndex].currentState!.maybePop();
              debugPrint('isFirstRouteInCurrentTab: ' +
                  isFirstRouteInCurrentTab.toString());
              // let system handle back button if we're on the first route
              return isFirstRouteInCurrentTab;
            },
            child: Scaffold(
                backgroundColor: AppColors.smokeWhite,
                body: IndexedStack(index: _navIndex, children: <Widget>[
                  _buildOffstageNavigator(0),
                  _buildOffstageNavigator(1),
                  _buildOffstageNavigator(2),
                  _buildOffstageNavigator(3),
                  _buildOffstageNavigator(4),
                ]),
                bottomNavigationBar: BottomNavigationBar(
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor: AppColors.grey,
                  selectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.bold),
                  currentIndex: _navIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    setState(() {
                      _navBloc.add(SwitchNavEvent(index));
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.rss_feed_outlined),
                      label: 'FEED',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.wallet_travel),
                      label: 'Biz Page',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle_outlined),
                      label: 'Connects',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.messenger_outlined),
                      label: 'Chats',
                    ),
                    BottomNavigationBarItem(
                        icon: CircleAvatar(
                          radius: 14,
                          backgroundImage:
                              AssetImage('assets/images/slide_i.png'),
                        ),
                        label: 'Profile'),
                  ],
                )));
      },
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return screens.elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _navBloc.currentTabIndex != index,
      child: Navigator(
        key: homeNavigatorKeys[index],
        // observers: [MyRouteObserver()],
        onGenerateRoute: (routeSettings) {
          debugPrint('Navigating to: ${routeSettings.name} --------------- ');
          debugPrint(
              'Navigating to: ${routeSettings.arguments} --------------- ');

          PageTransitionType? transitionType;
          var arguments = routeSettings.arguments;
          if (arguments != null) {
            var args = arguments as Map;
            transitionType = args['transition-type'];
            log("Transition:$transitionType");
          }

          if (transitionType != null) {
            return PageTransition(
              child: Builder(builder: (context) {
                if (routeSettings.name == '/') {
                  return routeBuilders[routeSettings.name]!(context);
                } else {
                  return AppRoutes.routes[routeSettings.name]!(context);
                }
              }),
              type: transitionType,
              alignment: Alignment.center,
              childCurrent: const SizedBox.shrink(),
              settings: routeSettings,
              // duration: Duration(milliseconds: 300),
            );
          }

          return CupertinoPageRoute(
              builder: (context) {
                if (routeSettings.name == '/') {
                  return routeBuilders[routeSettings.name]!(context);
                } else {
                  return AppRoutes.routes[routeSettings.name]!(context);
                }
              },
              settings: routeSettings);

          // return PageRouteBuilder(
          //     settings:
          //         routeSettings, // Pass this to make popUntil(), pushNamedAndRemoveUntil(), works
          //     pageBuilder: (_, __, ___) {
          //       if (routeSettings.name == '/') {
          //         return routeBuilders[routeSettings.name]!(context);
          //       } else {
          //         return BuyerRoutes.routes[routeSettings.name]!(context);
          //       }
          //     },
          //     transitionsBuilder: (_, a, __, c) =>
          //         FadeTransition(opacity: a, child: c));
          // Unknown route
          // return MaterialPageRoute(builder: (_) => UnknownPage());

          // return PageRouteBuilder(
          //     pageBuilder: (context, anim1, anim2) {
          //       if (routeSettings.name == '/') {
          //         return routeBuilders[routeSettings.name]!(context);
          //       } else {
          //         return BuyerRoutes.routes[routeSettings.name]!(context);
          //       }
          //     },
          //     transitionsBuilder:
          //         (context, animation, secondaryAnimation, child) => index == 2
          //             ? SlideTransition(
          //                 position: Tween<Offset>(
          //                   begin: const Offset(0.0, 1.0),
          //                   end: const Offset(0.0, 0.0),
          //                 ).animate(animation),
          //                 child: child)
          //             : SlideTransition(
          //                 position: Tween<Offset>(
          //                   begin: const Offset(1.0, 0.0),
          //                   end: const Offset(0.0, 0.0),
          //                 ).animate(animation),
          //                 child: child),
          //     settings: routeSettings,
          //     reverseTransitionDuration: Duration(milliseconds: 200),
          //     transitionDuration: Duration(milliseconds: 200));
        },
      ),
    );
  }

  _showDialogIfNecessary() {
    if (widget.showWelcomeDialog!) {
      showDialog(
          context: homeNavigatorKeys[0].currentState!.context,
          builder: (_) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: WelcomeDialog(
                    onNavigate: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const ProfileEditScreen()));
                      // _navBloc.add(SwitchNavEvent(4));
                      // Navigator.of(homeNavigatorKeys[4].currentState!.context)
                      //     .pushNamed(profileEditPath);
                    },
                  ))));
    }
  }
}

// SizedBox(
//         height: 55,
//         width: 55,
//         child: BottomNavigationBar(
//           selectedFontSize: 0.0,
//           unselectedFontSize: 0.0,
//           selectedIconTheme: const IconThemeData(size: 1),
//           unselectedIconTheme: const IconThemeData(size: 2),
//           elevation: 25,
//           iconSize: 0,
//           type: BottomNavigationBarType.shifting,
//           showUnselectedLabels: false,
//           showSelectedLabels: false,
//           items: bottomNavItems,
//           currentIndex: _screenIndex,
//           onTap: (index) {
//             setState(() {
//               _screenIndex = index;
//             });
//           },
//         ),
//       ),

// BottomNavyBar(
//           selectedIndex: _screenIndex,
//           showElevation: true, // use this to remove appBar's elevation
//           itemCornerRadius: 8,
//           containerHeight: kToolbarHeight + 8,
//           onItemSelected: (index) => setState(() {
//             _screenIndex = index;
//             // _pageController.animateToPage(index,
//             //     duration: Duration(milliseconds: 300), curve: Curves.ease);
//           }),
//           items: [
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/feed.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: const Text(
//                   'Feeds',
//                   style: TextStyle(
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/biz.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: const Text(
//                   'Biz Page',
//                   style: TextStyle(color: AppColors.primaryColor),
//                 ),
//                 activeColor:
//                     _screenIndex == 1 ? AppColors.primaryColor : AppColors.white,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 // icon: const Icon(Icons.work_outline),
//                 icon: SvgPicture.asset(
//                   'assets/svgs/chats.svg',
//                   color: AppColors.primaryColor,
//                 ),
//                 title: Text(
//                   'Chats',
//                   style: TextStyle(
//                     color: _screenIndex == 2
//                         ? AppColors.primaryColor
//                         : AppColors.white,
//                   ),
//                 ),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.transparent),
//             BottomNavyBarItem(
//                 icon: const CircleAvatar(
//                   radius: 17,
//                   backgroundImage: AssetImage('assets/images/slide_i.png'),
//                 ),
//                 title: const Text('Profile'),
//                 activeColor: AppColors.primaryColor,
//                 inactiveColor: Colors.blueGrey),
//           ],
//         )
