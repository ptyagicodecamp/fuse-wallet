import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fusecash/generated/i18n.dart';
import 'package:fusecash/models/app_state.dart';
import 'package:fusecash/models/views/bottom_bar.dart';
import 'package:fusecash/screens/buy/buy.dart';
import 'package:fusecash/screens/cash_home/cash_header.dart';
import 'package:fusecash/screens/cash_home/cash_home.dart';
import 'package:fusecash/screens/cash_home/dai_explained.dart';
import 'package:fusecash/screens/send/receive.dart';
import 'package:fusecash/screens/send/send_contact.dart';
import 'package:fusecash/widgets/drawer.dart';
import 'package:flutter/services.dart';

class CashModeScaffold extends StatefulWidget {
  final int tabIndex;
  CashModeScaffold({Key key, this.tabIndex}) : super(key: key);
  @override
  _CashModeScaffoldState createState() => _CashModeScaffoldState();
}

class _CashModeScaffoldState extends State<CashModeScaffold> {
  int _currentIndex = 0;

  List<Widget> _pages(bool isDefualtCommunity) {
    if (isDefualtCommunity) {
      return [
        CashHomeScreen(),
        SendToContactScreen(),
        DaiExplainedScreen(),
        ReceiveScreen()
      ];
    } else {
      return [
        CashHomeScreen(),
        SendToContactScreen(),
        BuyScreen(),
        ReceiveScreen()
      ];
    }
  }

  _onTap(int itemIndex) {
    setState(() {
      _currentIndex = itemIndex;
    });
  }

  BottomNavigationBarItem bottomBarItem(title, img) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: 5),
          child: SvgPicture.asset('assets/images/$img\.svg'),
        ),
        activeIcon: Padding(
          padding: EdgeInsets.only(top: 5),
          child: SvgPicture.asset('assets/images/$img\_selected.svg'),
        ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: new Text(title,
              style: new TextStyle(
                  fontSize: 13.0, color: const Color(0xFF292929))),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));

    return new StoreConnector<AppState, BottomBarViewModel>(
        converter: BottomBarViewModel.fromStore,
        builder: (_, vm) {
          final List<Widget> pages = _pages(vm.isDefaultCommunity);
          return Scaffold(
              key: widget.key,
              drawer: DrawerWidget(),
              drawerEdgeDragWidth: 0,
              appBar: _currentIndex != 0
                  ? null
                  : new PreferredSize(
                      child: CashHeader(),
                      preferredSize:
                          new Size(MediaQuery.of(context).size.width, 350.0)),
              bottomNavigationBar: BottomNavigationBar(
                onTap: _onTap,
                selectedFontSize: 13,
                unselectedFontSize: 13,
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                backgroundColor: Theme.of(context).bottomAppBarColor,
                showUnselectedLabels: true,
                items: [
                  bottomBarItem(I18n.of(context).home, 'home'),
                  bottomBarItem(I18n.of(context).send_button, 'send'),
                  vm.isDefaultCommunity
                      ? bottomBarItem(I18n.of(context).dai_points, 'daipoints')
                      : bottomBarItem(I18n.of(context).buy, 'buy'),
                  bottomBarItem(I18n.of(context).receive, 'receive'),
                ],
              ),
              body: pages[_currentIndex]);
        });
  }
}