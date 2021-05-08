import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/pages/tabs/Cart.dart';
import 'package:flutter_jd/pages/tabs/Categroy.dart';
import 'package:flutter_jd/pages/tabs/Home.dart';
import 'package:flutter_jd/pages/tabs/User.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 1;
  var _pageController;

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  List<Widget> _pageList = [
    HomePage(),
    CateGroyPage(),
    CartPage(),
    UserPage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("JDShop")
        ),
        body: PageView(
          controller: _pageController,
          children:  _pageList
        ),
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("首页")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                title: Text("分类")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                title: Text("购物车")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text("我的")
            )
          ],
        )
    );
  }
}
