import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/widgets/commonAppBar.dart';

class Rows extends StatefulWidget {
  @override
  _RowsState createState() => _RowsState();
}

enum RowNumber { row1, row2, row3 }

class _RowsState extends State<Rows> {
  RowNumber rowNumber;
  double row1Height = ScreenUtil.screenHeight * 0.1;
  double row2Height = ScreenUtil.screenHeight * 0.1;
  double row3Height = ScreenUtil.screenHeight * 0.1;

  Widget _appBar(Key key) {
    return CommonAppBar(
      key: key,
      title: Text(kRows),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _updateState(BuildContext context, RowNumber row) {
    switch (row) {
      case RowNumber.row1:
        setState(() {
          row1Height = ScreenUtil.screenHeight * 0.2;
          row2Height = ScreenUtil.screenHeight * 0.05;
          row3Height = ScreenUtil.screenHeight * 0.05;
        });
        break;
      case RowNumber.row2:
        setState(() {
          row2Height = ScreenUtil.screenHeight * 0.2;
          row1Height = ScreenUtil.screenHeight * 0.05;
          row3Height = ScreenUtil.screenHeight * 0.05;
        });
        break;
      case RowNumber.row3:
        setState(() {
          row3Height = ScreenUtil.screenHeight * 0.2;
          row2Height = ScreenUtil.screenHeight * 0.05;
          row1Height = ScreenUtil.screenHeight * 0.05;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(UniqueKey()),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _updateState(context, RowNumber.row1);
                    },
                    child: AnimatedRow(
                      row1Height: row1Height,
                      color: Colors.greenAccent.withAlpha(150),
                      title: kRow1,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _updateState(context, RowNumber.row2);
                    },
                    child: AnimatedRow(
                      row1Height: row2Height,
                      color: Colors.amberAccent.withAlpha(150),
                      title: kRow2,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _updateState(context, RowNumber.row3);
                    },
                    child: AnimatedRow(
                      row1Height: row3Height,
                      color: Colors.pinkAccent.withAlpha(150),
                      title: kRow3,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedRow extends StatelessWidget {
  const AnimatedRow(
      {Key key,
      @required this.row1Height,
      @required this.color,
      @required this.title})
      : super(key: key);

  final double row1Height;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: row1Height,
      width: width,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(20),
              color: Colors.black87,
              fontWeight: FontWeight.w500),
        ),
      ),
      color: color,
    );
  }
}
