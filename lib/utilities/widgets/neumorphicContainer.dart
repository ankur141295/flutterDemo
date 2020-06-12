import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  NeumorphicContainer(
      {@required this.title, @required this.icon, @required this.onTap});

  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
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
          ),
          child: Material(
            type: MaterialType.transparency,
            color: Colors.grey[200],
            child: InkWell(
              highlightColor: Colors.grey[300].withOpacity(0.85),
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style:
                              TextStyle(color: Colors.black87, fontSize: 18.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            child: Icon(
                          icon,
                          color: Colors.grey,
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
