import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jd/service/SearchService.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _keyWords ;

  List _historyListData = [];

  @override
  void initState() {
      super.initState();
      _getHistroyListData();
  }

  //获取历史记录数据
  _getHistroyListData() async{
      var result = await SearchService.getSearchData();
      setState(() {
        _historyListData = result;
      });
  }

  //历史记录Widget
  Widget _histroyListWidget(){
      return _historyListData.length>0?Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("历史记录",style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
            children: _historyListData.map((e){
              return Column(
                children: [
                  ListTile(
                    title: Text(e),
                  ),
                  Divider(height: 1.h,)
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 50.h,),
          InkWell(
            onTap: null,
            child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromRGBO(233, 233, 233, 1),
                        width: 1.w
                    )
                ),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete),
                    Text("清空历史记录")
                  ],
                )
            ),
          )
        ],
      ):Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 30.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(30)
          ),
          child: TextField(
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30)
              )
            ),
            onChanged: (value){
              _keyWords = value;
            },
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              SearchService.setSearchData(_keyWords);

              Navigator.pushReplacementNamed(context, "/productList",arguments: {
                  "keyWords":_keyWords,
                  "type":"search"
              });
            },
            child: Container(
              height: 30.h,
              width: 35.h,
              child: Row(
                children: [
                  Text("搜索")
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.w),
        child:  ListView(
          children: [
            Container(
              child: Text("热搜",style: Theme.of(context).textTheme.title),
            ),
            Divider(),
            Wrap(
              children: [
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 0.9),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("笔记本电脑"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Container(
                  padding:EdgeInsets.all(10.w),
                  margin: EdgeInsets.all(10.w),
                  child: Text("女装"),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)
                  ),
                )
              ],
            ),
            SizedBox(height: 10.h),
            _histroyListWidget()
          ],
        ),
      )
    );
  }
}
