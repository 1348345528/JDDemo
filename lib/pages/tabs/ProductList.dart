

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/Widget/loading.dart';
import 'package:flutter_jd/config/Config.dart';
import 'package:flutter_jd/model/ProductModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductList extends StatefulWidget {
  Map arguments;

  ProductList({this.arguments});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _pageLoading = true;

  //商品数据
  List<ProductItemModel> _productList = [];

  //分页
  int _page = 1;

  //排序
  //价格升序 sort=price_1
  // 价格降序 sort=price_-1
  // 销量升序 sort=salecount_1
  // 销量降序 sort=salecount_-1
  String _sort = "";

  //解决重复请求的问题
  bool _flag = true;

  //是否有数据
  bool _hasMore = true;

  //每页有多少条数据
  int _pageSize = 8;

  ScrollController _scrollController = new ScrollController();

  /*二级导航数据*/
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
          -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];

  int _selectHeader = 1;


  @override
  void initState() {
    super.initState();
    _getProductListData();

    //下拉分页
    //监听滚动条滚动事件

    //监听滚动条事件
    _scrollController.addListener(() {
      print("---------------------------------");
      print(_scrollController.position.pixels);
      print(_scrollController.position.maxScrollExtent);
      print("---------------------------------");
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (_flag && _hasMore) {
          _getProductListData();
        }
      }
    });
  }

  //获取商品列表的数据
  _getProductListData() async {
    setState(() {
      _flag = false;
    });

    var api =
        "${Config.domain}api/plist?cid=${widget.arguments["cid"]}&page=${_page}&sort=${_sort}&pageSize=${this._pageSize}";
    print(api);
    var result = await Dio().get(api);
    setState(() {
      _productList.addAll(ProductModel.fromJson(result.data).result);
      if (ProductModel.fromJson(result.data).result.length < 8) {
        _hasMore = false;
      }
      _pageLoading = false;
      _flag = true;
      _page++;
    });
  }

  //显示加载中的圈圈
  Widget _showMore(index) {
    if (this._hasMore) {
      return (index == this._productList.length - 1)
          ? LoadingWidget()
          : Text("");
    } else {
      return (index == this._productList.length - 1)
          ? Text("--我是有底线的--")
          : Text("");
    }
  }

  //商品列表
  Widget _productListWidget() {
    if (!_pageLoading) {
      return Container(
        margin: EdgeInsets.only(top: 40.h),
        padding: EdgeInsets.all(10.h),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _productList.length,
          itemBuilder: (context, index) {
            var pic =
                Config.domain + (_productList[index].pic.replaceAll('\\', '/'));
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100.h,
                      height: 100.h,
                      child: Image.network(
                        pic,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100.h,
                        margin: EdgeInsets.only(left: 10.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_productList[index].title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 16.h,
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child: Text("4g"),
                                ),
                                Container(
                                  height: 16.h,
                                  margin: EdgeInsets.only(right: 10.w),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child: Text("5g"),
                                )
                              ],
                            ),
                            Text(
                              "${_productList[index].price}",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Divider(height: 25.h),
                _showMore(index)
              ],
            );
          },
        ),
      );
    } else {
      return LoadingWidget();
    }
  }

  //导航点击
  _subHeaderChange(id){
    if(id==4){
      _scaffoldKey.currentState.openEndDrawer();
      setState(() {
        _selectHeader = id;
      });
    }else{
      setState(() {
        _selectHeader = id;
      });
    }
  }

  //筛选导航
  Widget _navigationWidget() {
    return Positioned(
      top: 0,
      height: 50.h,
      width: 360.w,
      child: Container(
        width: 360.w,
        height: 50.h,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1.w, color: Color.fromRGBO(233, 233, 233, 0.9)))),
        child: Row(
          children: _subHeaderList.map((value) {
            return Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 16.h, 0, 16.h),
                  child: Text(
                    "${value["title"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectHeader == value["id"]?Colors.red:Colors.black
                    ),
                  ),
                ),
                onTap: () {
                  _subHeaderChange(value["id"]);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  //抽屉
  Widget _drawer() {
    return Drawer(
      child: Container(
        child: Text("实现筛选"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("商品列表"),
        actions: [Text("")],
      ),
      endDrawer: _drawer(),
      body: Stack(
        children: [
          _productListWidget(),
          _navigationWidget(),
        ],
      ),
    );
  }
}
