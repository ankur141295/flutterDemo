import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gogamedemo/columns/columns.dart';
import 'package:gogamedemo/database/contact_page/contactList.dart';
import 'package:gogamedemo/rows/rows.dart';
import 'package:gogamedemo/text_image/text_image.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/widgets/commonAppBar.dart';
import 'package:gogamedemo/utilities/widgets/neumorphicContainer.dart';
import 'package:gogamedemo/utilities/widgets/transitionPageRoute.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.grey[200],
        scaffoldBackgroundColor: Colors.grey[200],
        accentColor: kPrimaryColor,
        appBarTheme: AppBarTheme(
          color: kPrimaryColor,
          elevation: 2.0,
        ),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
    StaggeredTile.extent(1, 150),
    StaggeredTile.extent(1, 150),
    StaggeredTile.extent(1, 150),
    StaggeredTile.extent(1, 150),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    ScreenUtil.init(context,
        width: width, height: height, allowFontScaling: false);

    return Scaffold(
      appBar: CommonAppBar(
        key: UniqueKey(),
        title: Text(kGoGame),
        leading: null,
      ),
      body: SafeArea(
        child: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 30.0,
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
          children: <Widget>[
            NeumorphicContainer(
              title: kRows,
              icon: FontAwesomeIcons.rulerHorizontal,
              onTap: () {
                Navigator.push(
                  context,
                  TransitionPageRoute(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    alignment: Alignment.topLeft,
                    widget: Rows(),
                  ),
                );
              },
            ),
            NeumorphicContainer(
              icon: FontAwesomeIcons.rulerVertical,
              title: kColumns,
              onTap: () {
                Navigator.push(
                  context,
                  TransitionPageRoute(
                    duration: Duration(milliseconds: 900),
                    curve: Curves.elasticInOut,
                    alignment: Alignment.topRight,
                    widget: Columns(),
                  ),
                );
              },
            ),
            NeumorphicContainer(
              icon: FontAwesomeIcons.images,
              title: kTextImage,
              onTap: () {
                Navigator.push(
                  context,
                  TransitionPageRoute(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.ease,
                    alignment: Alignment.center,
                    widget: TextImage(),
                  ),
                );
              },
            ),
            NeumorphicContainer(
              icon: FontAwesomeIcons.database,
              title: kDataBase,
              onTap: () {
                Navigator.push(
                  context,
                  TransitionPageRoute(
                    duration: Duration(milliseconds: 400),
                    curve: Curves.fastOutSlowIn,
                    alignment: Alignment.center,
                    widget: ContactList(),
                  ),
                );
              },
            ),
          ],
          staggeredTiles: _staggeredTiles,
        ),
      ),
    );
  }
}
