import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/config/Config.dart';
import 'package:flutter_jd/model/FocusModel.dart';
import 'package:flutter_jd/model/ProductModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<FocusItemModel> _focusData  = [];

  List<ProductItemModel> _hotProductData = [];

  List<ProductItemModel> _recProductData = [];
  @override
  void initState(){
   super.initState();
   _getFocusData();
   _getHotProduct();
   _getRecProduct();
  }

  //获取轮播图图片
  _getFocusData() async{
     var api = "${Config.domain}api/focus";
     var result = await Dio().get(api);
     setState(() {
       _focusData =  FocusModel.fromJson(result.data).result;
     });
  }

  //获取猜你喜欢商品
  _getHotProduct() async{
    var api = "${Config.domain}api/plist?is_hot=1";
    var result = await Dio().get(api);

    setState(() {
      _hotProductData = ProductModel.fromJson(result.data).result;
    });
  }

  //获取热门推荐的商品
  _getRecProduct() async{
    var api = "${Config.domain}api/plist?is_best=1";
    var result = await Dio().get(api);

    setState(() {
      _recProductData = ProductModel.fromJson(result.data).result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if(this._focusData.length>0){
      return Container(
        width: 392.h,
        height: 196.h,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic=this._focusData[index].pic;
              return new Image.network(
                "${Config.domain}${pic.replaceAll('\\', '/')}",
                fit: BoxFit.fill,
              );
            },
            itemCount: _focusData.length,
            pagination: new SwiperPagination(),
            autoplay: true,
          ),
        ),
      );
    }else{
      return Container(
        width: 392.h,
        height: 196.h,
        child: Center(
          child: Text("加载中"),
        ),
      );
    }
  }

  //标题
  Widget _titleWidget(value) {
    return Container(
      height: 20.h,
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.red, width: 5.w))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  //猜你喜欢
  Widget _hotProduct() {
    return Container(
      height: 125.h,
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String pic=this._hotProductData[index].pic;
          return Column(
            children: [
              Container(
                height: 110.h,
                margin: EdgeInsets.only(left: 10.w),
                child: Image.network(
                    "${Config.domain}${pic.replaceAll('\\', '/')}",
                    fit: BoxFit.cover),
              )
            ],
          );
        },
        itemCount: _hotProductData.length,
      ),
    );
  }

  //热门推荐
  Widget _hotRecommend() {
    return Container(
      padding: EdgeInsets.all(10.h),
      child: Wrap(
        runSpacing: 10.h,
        spacing: 10.w,
        children: _recProductList(),
      ),
    );
  }

  //推荐商品
  List<Widget> _recProductList() {
    var itemWidth = (ScreenUtil().screenWidth - 35) / 2;

    List<Widget> productList =  _recProductData.map((element) {
        var pic = Config.domain+element.pic.replaceAll('\\', '/');

        return Container(
          padding: EdgeInsets.all(5),
          width: itemWidth,
          decoration: BoxDecoration(
              border:
              Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: Image.network(
                    "${pic}",
                    fit: BoxFit.cover,
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  "${element.title}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "￥${element.price}",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${element.oldPrice}",
                        style: TextStyle(color: Colors.black54, fontSize: 14,decoration: TextDecoration.lineThrough),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
    }).toList();

  return productList;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _swiperWidget(),
        SizedBox(height: 5.h),
        _titleWidget("猜你喜欢"),
        SizedBox(height: 5.h),
        _hotProduct(),
        _titleWidget("热门推荐"),
        _hotRecommend()
      ],
    );
  }
}
