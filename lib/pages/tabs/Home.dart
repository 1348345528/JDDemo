import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/model/FocusModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<FocusItemModel> _focusData  = [];
  @override
  void initState(){
   super.initState();
   _getFocusData();
   print(_focusData);
  }

  //获取轮播图图片
  _getFocusData() async{
     var api = "https://jd.itying.com/api/focus";
     Map<String,dynamic> result = (await Dio().get(api)) as Map<String, dynamic>;
     setState(() {
       _focusData =  FocusModel.fromJson(result).result;
     });
  }

  //轮播图
  Widget _swiperWidget() {
    if(this._focusData.length>0){
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                _focusData[index].url,
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
      return Text("加载中");
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

  //热门商品
  Widget _hotProduct() {
    return Container(
      height: 125.h,
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                height: 110.h,
                margin: EdgeInsets.only(left: 10.w),
                child: Image.network(
                    "https://www.itying.com/images/flutter/hot${index + 1}.jpg",
                    fit: BoxFit.cover),
              )
            ],
          );
        },
        itemCount: 10,
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
        children: [
          _recProductList(),
          _recProductList(),
          _recProductList(),
          _recProductList(),
          _recProductList(),
          _recProductList()
        ],
      ),
    );
  }

  //推荐商品
  Widget _recProductList() {
    var itemWidth = (ScreenUtil().screenWidth - 84) / 2;

    return Container(
      padding: EdgeInsets.all(5),
      width: itemWidth.h,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Image.network(
              "https://www.itying.com/images/flutter/list1.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              "YIMU日本醋酸早春白色西装外套女春秋设计感小众2021新款高端套装",
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
                    "￥188.0",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "￥198.0",
                    style: TextStyle(color: Colors.black54, fontSize: 14,decoration: TextDecoration.lineThrough),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
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
