import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/widgets/commonAppBar.dart';

class TextImage extends StatefulWidget {
  @override
  _TextImageState createState() => _TextImageState();
}

class _TextImageState extends State<TextImage> {
  var _images = [
    'https://images.pexels.com/photos/709552/pexels-photo-709552.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
    'https://images.pexels.com/photos/747964/pexels-photo-747964.jpeg?cs=srgb&dl=person-on-a-bridge-near-a-lake-747964.jpg&fm=jpg',
    'https://images.pexels.com/photos/814499/pexels-photo-814499.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
  ];

  var _desc = [
    'Amazon Rainforest, Brazil',
    'Schönau am Königssee, Germany',
    'Gablenz, Germany'
  ];

  int _counter = 0;

  Widget _appBar(Key key) {
    return CommonAppBar(
      key: key,
      title: Text(kTextImage),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Decoration _decoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(4, 5),
          color: Colors.black12,
          blurRadius: 7,
        ),
        BoxShadow(
          offset: Offset(-7, -7),
          color: Colors.white,
          blurRadius: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(UniqueKey()),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 400,
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.all(20),
            decoration: _decoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  fadeOutDuration: Duration(milliseconds: 100),
                  placeholder: (context, url) =>
                      Image.asset('images/search.png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('images/error.png'),
                  imageUrl: _images[_counter],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  _desc[_counter],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(20),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _counter == 0
                          ? Container()
                          : RaisedButton(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              onPressed: () {
                                if (_counter > 0) {
                                  setState(() {
                                    _counter--;
                                  });
                                }
                              },
                              child: Text(
                                kPrev,
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                            ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: _counter == _images.length - 1
                          ? Container()
                          : RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: kPrimaryColor,
                              onPressed: () {
                                if (_counter < _images.length) {
                                  setState(() {
                                    _counter++;
                                  });
                                }
                              },
                              child: Text(
                                kNext,
                                style: TextStyle(color: Colors.grey[200]),
                              ),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Image.network(
//                      _images[0],
//                      loadingBuilder: (context, child, loadingProgress) {
//                        if (loadingProgress == null) return child;
//                        return Center(
//                          child: CircularProgressIndicator(
//                              value: loadingProgress.expectedTotalBytes != null
//                                  ? loadingProgress.cumulativeBytesLoaded /
//                                      loadingProgress.expectedTotalBytes
//                                  : null),
//                        );
//                      },
//                    )
