import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_jd/pages/tabs/Cart.dart';
import 'package:flutter_jd/pages/tabs/Categroy.dart';
import 'package:flutter_jd/pages/tabs/Home.dart';
import 'package:flutter_jd/pages/tabs/User.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        appBar: _currentIndex!=3?AppBar(
          leading: IconButton(
            icon: Icon(Icons.center_focus_weak),
            onPressed: null,
          ),
          title: InkWell(
            child: Container(
              height: 30.h,
              padding: EdgeInsets.only(left: 10.w),
              decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(
                children: [
                  Icon(Icons.search),
                  Text(
                      "笔记本",
                    style: TextStyle(
                      fontSize: 16.sp
                    ),
                  )
                ],
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, "/search");
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.message,size: 28,color: Colors.black87),
              onPressed: null,
            ),
          ],
        ):AppBar(
          title: Text("用户中心"),
        ),
        body: PageView(
          controller: _pageController,
          children:  _pageList,
          onPageChanged: (index){
            setState(() {
              this._currentIndex = index;
            });
          },
        ),
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.red,
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
