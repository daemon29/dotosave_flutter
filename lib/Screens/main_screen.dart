import 'package:LadyBug/Widgets/BottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Main_Screen extends StatefulWidget {
  final String currentUserId;
  Main_Screen({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _Main_Screen createState() => new _Main_Screen(currentUserId: currentUserId);
}

class _Main_Screen extends State<Main_Screen> {
  final String currentUserId;
  _Main_Screen({Key key, @required this.currentUserId});
  var _file = null;
  bool _visible = false;
  bool _send_clickable = false;
  Image getImage(var _file) {
    if (_file == null) return Image.asset("Images/image_02.png");
    return Image.file(_file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: null,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(1,1,1,10),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Flexible(
                              flex: 1,
                              child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              "https://i.imgur.com/BoN9kdC.png"))))),
                          SizedBox(
                            width: 10,
                          ),
                          new Flexible(
                              flex: 5,
                              child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'What\'s in your mind?'),
                                      keyboardType: TextInputType.multiline,
                                      onChanged: (str) {
                                        if (str.length > 0) {
                                          setState(() {
                                            _send_clickable = true;
                                          });
                                        } else
                                          setState(() {
                                            _send_clickable = false;
                                          });
                                      },
                                      maxLines: null,
                                    ),
                                    Visibility(
                                        visible: _visible,
                                        child: Container(
                                            child: Stack(
                                          children: [
                                            getImage(_file),
                                            Positioned(
                                              right: 2,
                                              top: 2,
                                              child: IconButton(
                                                icon: Icon(Icons.close),
                                                tooltip: 'Remove image',
                                                onPressed: () {
                                                  setState(() {
                                                    _visible = false;
                                                  });
                                                },
                                                iconSize: 32,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ))),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            var image =
                                                await ImagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (image == null) return;
                                            setState(() {
                                              _file = image;
                                              _visible = true;
                                            });
                                          },
                                        ),
                                        RawMaterialButton(
                                          constraints: BoxConstraints.tight(
                                              Size(36, 36)),
                                          child: Icon(
                                            Icons.insert_emoticon,
                                            color: Colors.blue,
                                            size: 32,
                                          ),
                                          onPressed: () {},
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        FlatButton(
                                          onPressed: _send_clickable
                                              ? () {
                                                  /*...*/
                                                }
                                              : null,
                                          padding: EdgeInsets.all(0.0),
                                          color: Colors.blue,
                                          disabledColor: Colors.blue[100],
                                          splashColor: Colors.blueAccent,
                                          child: Text(
                                            "Send",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ]))
                        ],
                      ))))
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(context, currentUserId),
    );
  }
}
