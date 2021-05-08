import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/config/Config.dart';
import 'package:flutter_jd/model/CategoryModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CateGroyPage extends StatefulWidget {
  @override
  _CateGroyPageState createState() => _CateGroyPageState();
}

class _CateGroyPageState extends State<CateGroyPage>
    with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;
  List<CategoryItemModel> _leftCateData = [];
  List<CategoryItemModel> _rightCateData = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    _getLeftCateData();
  }

  //获取左侧分类数据
  _getLeftCateData() async {
    var api = "${Config.domain}api/pcate";
    print(api);
    var result = await Dio().get(api);
    setState(() {
      _leftCateData = CategoryModel.fromJson(result.data).result;
    });
    _getRightCateData(_leftCateData[0].sId);
  }

  //获取右侧分类数据
  _getRightCateData(pid) async {
    var api = "${Config.domain}api/pcate?pid=${pid}";
    var result = await Dio().get(api);
    setState(() {
      _rightCateData = CategoryModel.fromJson(result.data).result;
    });
  }

  //左侧分类
  Widget _leftCate(leftWidth) {
    if (_leftCateData.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        // color: Colors.red,
        child: ListView.builder(
          itemCount: _leftCateData.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectIndex = index;
                      _getRightCateData(_leftCateData[index].sId);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58.h,
                    padding: EdgeInsets.only(top: 21.h),
                    child: Text("${_leftCateData[index].title}",
                        textAlign: TextAlign.center),
                    color: _selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          },
        ),
      );
    } else {
      return Container(
        width: leftWidth,
        height: double.infinity,
        child: Center(
          child: Text("加载中"),
        ),
      );
    }
  }

  //右侧分类
  Widget _rightCate(rightItemWidth, rightItemHeight) {
    if (_rightCateData.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10.w),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: rightItemWidth / rightItemHeight,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.w),
              itemCount: _rightCateData.length,
              itemBuilder: (context, index) {
                var pic = Config.domain +
                    (_rightCateData[index].pic.replaceAll('\\', '/'));
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/productList",
                        arguments: {"cid": _rightCateData[index].sId});
                  },
                  child: Container(
                    // padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.network(pic, fit: BoxFit.cover),
                        ),
                        Container(
                          height: 20.h,
                          child: Text("${_rightCateData[index].title}"),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          child: Center(
            child: Text("加载中"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //左侧宽度
    var leftWidth = ScreenUtil().screenWidth / 4;
    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth =
        (ScreenUtil().screenWidth - leftWidth - 20.w - 20.w) / 3;
    //获取计算后的宽度
    rightItemWidth = rightItemWidth.w;
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + 28.h;
    return Row(
      children: <Widget>[
        _leftCate(leftWidth),
        _rightCate(rightItemWidth, rightItemHeight)
      ],
    );
  }
}
