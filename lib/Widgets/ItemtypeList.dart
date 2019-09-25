import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final List<String> itemTypeList = [
  'Books',
  'Clothes',
  'Household goods',
  'Toys',
  'Food',
  'Money',
  'School supplies',
  'Stationary'
];

final Map<String, Map<String, String>> itemTypeListMap = {
  'vi': {
    'Books': 'Sách',
    'Clothes': 'Quần áo',
    'Household goods': 'Đồ gia dụng',
    'Toys': 'Đồ chơi',
    'Food': 'Thức ăn',
    'Money': 'Tiền mặt',
    'School supplies': 'Đồ dùng học tập',
    'Stationary': 'Văn phòng phẩm'
  },
  'en': {
    'Books': 'Books',
    'Clothes': 'Clothes',
    'Household goods': 'Household goods',
    'Toys': 'Toys',
    'Food': 'Food',
    'Money': 'Money',
    'School supplies': 'School supplies',
    'Stationary': 'Stationary'
  }
};

class ItemTypeList extends StatefulWidget {
  final List<bool> indexList;
  ItemTypeList(this.indexList);
  @override
  State<StatefulWidget> createState() {
    return ItemTypeListState(indexList);
  }
}

class ItemTypeListState extends State<ItemTypeList> {
  List<bool> indexList;
  ItemTypeListState(this.indexList);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            RaisedButton(
                onPressed: () {
                  List<String> resultList = List();
                  for (int i = 0; i < indexList.length; ++i) {
                    if (indexList[i]) resultList.add(itemTypeList[i]);
                  }
                  Navigator.pop(context, [resultList, indexList]);
                },
                child: Text(
                  "Done",
                  //style: TextStyle(fontSize: 11),
                ))
          ],
          title: Text("Tags",
              style: const TextStyle(
                fontSize: 22,
                fontFamily: 'Manjari',
              )),
        ),
        body: ListView.builder(
            itemCount: itemTypeList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  splashColor: (indexList[index])
                      ? Colors.white
                      : Colors.deepOrange[600],
                  onTap: () {
                    setState(() {
                      indexList[index] = !indexList[index];
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    color: (indexList[index])
                        ? Colors.deepOrange[600]
                        : Colors.white,
                    child: Text(
                      itemTypeListMap[setLanguage][itemTypeList[index]],
                      style: TextStyle(
                          color:
                              (indexList[index]) ? Colors.white : Colors.black),
                    ),
                  ));
            }));
  }
}
