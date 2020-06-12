import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gogamedemo/database/contact_page/contactEditPage.dart';
import 'package:gogamedemo/database/model_class/contact.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/sqflite/database_helper.dart';
import 'package:gogamedemo/utilities/widgets/commonAppBar.dart';
import 'package:sqflite/sqflite.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool _showFab = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _databaseHelper = DatabaseHelper();
  final _scrollController = ScrollController();
  List<Contact> _contactList = List<Contact>();

  @override
  void initState() {
    _updateListView();
    super.initState();
    _fabVisibility();
  }

  Widget _appBar() {
    return CommonAppBar(
      title: Text(kContact),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context, false);
        },
      ),
    );
  }

  void _showSnackBar(String message, [bool showButton, Function onPressed]) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(message),
        action: showButton != null && showButton
            ? SnackBarAction(label: kUndo, onPressed: onPressed)
            : null,
      ),
    );
  }

  void _delete(Contact contact) async {
    String name = contact.name;
    String mobile = contact.mobile;
    String email = contact.email;
    String image = contact.image;

    int result = await _databaseHelper.deleteContact(contact.id);
    _scaffoldKey.currentState?.hideCurrentSnackBar();
    if (result != 0) {
      _showSnackBar('Item deleted', true, () async {
        int val = await _databaseHelper
            .insertContact(Contact(name, email, image, mobile));
        _scaffoldKey.currentState?.hideCurrentSnackBar();
        if (val == 0) {
          _showSnackBar('Something went wrong');
        }
        _updateListView();
      });
      _updateListView();
    } else {
      _showSnackBar('Something went wrong');
    }
  }

  Future<void> _updateListView() async {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Contact>> contactListFuture =
          _databaseHelper.getContactList();
      contactListFuture.then((contactList) {
        setState(() {
          this._contactList = contactList;
        });
      });
    });
  }

  Decoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
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

  Widget _listTile(int index) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20,
          backgroundImage: _contactList[index].image.isEmpty
              ? CachedNetworkImageProvider(
                  'http://sg-fs.com/wp-content/uploads/2017/08/user-placeholder.png',
                  scale: 1.0)
              : MemoryImage(
                  base64Decode(_contactList[index].image),
                )),
      subtitle: Text(
        _contactList[index].mobile,
        style: TextStyle(fontSize: 12.0, color: Colors.grey),
      ),
      trailing: GestureDetector(
        child: Icon(
          Icons.delete,
          color: Colors.grey,
        ),
        onTap: () {
          _delete(_contactList[index]);
        },
      ),
      title: Text(
        _contactList[index].name,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _fabVisibility() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _showFab = false;
        });
      } else {
        setState(() {
          _showFab = true;
        });
      }
    });
  }

  Widget _fabWidget() {
    return Visibility(
      visible: _showFab,
      child: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        elevation: 10.0,
        onPressed: () async {
          _scaffoldKey.currentState?.hideCurrentSnackBar();
          String contactCreated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactEditPage(
                contact: Contact('', '', '', ''),
              ),
            ),
          );

          if (contactCreated != null && contactCreated == 'new') {
            _showSnackBar('Contact Added');
          }
          await _updateListView();
        },
      ),
    );
  }

  void _listCardPressed(Contact contact, int index) async {
    _scaffoldKey.currentState?.hideCurrentSnackBar();
    String contactUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactEditPage(
          contact: contact,
        ),
      ),
    );

    if (contactUpdated != null && contactUpdated == 'update') {
      _scaffoldKey.currentState?.hideCurrentSnackBar();
      _showSnackBar('Contact Updated');
    }
    await _updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      floatingActionButton: _fabWidget(),
      body: SafeArea(
        child: _contactList.isEmpty
            ? Center(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: 350,
                  width: 350,
                  child: Image.asset('images/noDataFound.png'),
                ),
              )
            : ListView.separated(
                itemCount: _contactList.length,
                controller: _scrollController,
                padding: EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return Container(
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: _boxDecoration(),
                        child: Material(
                          type: MaterialType.transparency,
                          color: Colors.grey[200],
                          child: InkWell(
                            highlightColor: Colors.grey[300].withOpacity(0.85),
                            splashColor: Colors.transparent,
                            onTap: () {
                              _listCardPressed(_contactList[index], index);
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              child: _listTile(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
              ),
      ),
    );
  }
}
