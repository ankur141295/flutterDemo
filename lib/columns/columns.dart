import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/widgets/commonAppBar.dart';

class Columns extends StatefulWidget {
  @override
  _ColumnsState createState() => _ColumnsState();
}

enum ColumnNumber { column1, column2, column3 }

class _ColumnsState extends State<Columns> {
  ColumnNumber columnNumber;

  int column1Width = 1;
  int column2Width = 1;
  int column3Width = 1;

  Widget _appBar(Key key) {
    return CommonAppBar(
      key: key,
      title: Text(kColumns),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _updateState(BuildContext context, ColumnNumber column) {
    switch (column) {
      case ColumnNumber.column1:
        setState(() {
          column1Width = 2;
          column2Width = 1;
          column3Width = 1;
        });

        break;
      case ColumnNumber.column2:
        setState(() {
          column1Width = 1;
          column2Width = 2;
          column3Width = 1;
        });
        break;
      case ColumnNumber.column3:
        setState(() {
          column1Width = 1;
          column2Width = 1;
          column3Width = 2;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.9;

    return Scaffold(
      appBar: _appBar(UniqueKey()),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: column1Width,
              child: GestureDetector(
                onTap: () {
                  _updateState(context, ColumnNumber.column1);
                },
                child: ColumnContainer(
                  title: kColumn1,
                  height: height,
                  color: Colors.greenAccent.withAlpha(150),
                ),
              ),
            ),
            Expanded(
              flex: column2Width,
              child: GestureDetector(
                onTap: () {
                  _updateState(context, ColumnNumber.column2);
                },
                child: ColumnContainer(
                  title: kColumn2,
                  height: height,
                  color: Colors.amberAccent.withAlpha(150),
                ),
              ),
            ),
            Expanded(
              flex: column3Width,
              child: GestureDetector(
                onTap: () {
                  _updateState(context, ColumnNumber.column3);
                },
                child: ColumnContainer(
                  title: kColumn3,
                  height: height,
                  color: Colors.pinkAccent.withAlpha(150),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ColumnContainer extends StatelessWidget {
  const ColumnContainer(
      {Key key,
      @required this.height,
      @required this.title,
      @required this.color})
      : super(key: key);

  final double height;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Align(
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
