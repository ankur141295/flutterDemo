import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogamedemo/database/model_class/contact.dart';
import 'package:gogamedemo/utilities/constants/constants.dart';
import 'package:gogamedemo/utilities/sqflite/database_helper.dart';
import 'package:gogamedemo/utilities/widgets/scrollanimation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ContactEditPage extends StatefulWidget {
  ContactEditPage({@required this.contact});

  final Contact contact;

  @override
  _ContactEditPageState createState() => _ContactEditPageState();
}

class _ContactEditPageState extends State<ContactEditPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final helper = DatabaseHelper();

  final _fNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobile1Controller = TextEditingController();

  final _textSecondFocusNode = FocusNode();
  final _textThirdFocusNode = FocusNode();
  String _localFileName;
  File _image;

  @override
  void initState() {
    _initValue();
    super.initState();
  }

  void _initValue() {
    _fNameController.text = widget.contact.name ?? '';
    _mobile1Controller.text = widget.contact.mobile ?? '';
    _emailController.text = widget.contact.email ?? '';
    _localFileName = widget.contact.image ?? '';
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }

  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      await _cropImage(image);
    }
    Navigator.pop(context);
  }

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _cropImage(image);
    }
    Navigator.pop(context);
  }

  Future<void> _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      cropStyle: CropStyle.circle,
      sourcePath: image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: kPrimaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
    );
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (builder) {
          return Container(
            height: 200.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      kAddImage,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    CloseButton(),
                  ],
                ),
                Divider(
                  height: 1.0,
                  thickness: 1.0,
                  color: Colors.grey[600],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: getCameraImage,
                        child: BottomSheetItem(
                          imageName: 'images/ic_camera.png',
                          imageText: kCamera,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: getGalleryImage,
                        child: BottomSheetItem(
                          imageName: 'images/ic_gallery.png',
                          imageText: kGallery,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_localFileName != null &&
                              _localFileName.isNotEmpty) {
                            Navigator.pop(context);
                            setState(() {
                              _localFileName = '';
                            });
                          } else if (_image != null) {
                            Navigator.pop(context);
                            setState(() {
                              _image = null;
                            });
                          }
                        },
                        child: BottomSheetItem(
                          imageName: 'images/ic_delete.png',
                          imageText: kDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _fNameController?.dispose();
    _emailController?.dispose();
    _mobile1Controller?.dispose();
    super.dispose();
  }

  Widget _appBar() {
    return AppBar(
      title: Text(kContact),
      automaticallyImplyLeading: false,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        OutlineButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderSide: BorderSide.none,
          onPressed: () {
            _onSaveClicked();
          },
          child: Text(
            kSave,
            style: TextStyle(color: Colors.grey[200]),
          ),
        ),
      ],
    );
  }

  void _onSaveClicked() async {
    _scaffoldKey.currentState?.hideCurrentSnackBar();
    if (widget.contact.id == null) {
      if (_fNameController.text.isNotEmpty &&
          _mobile1Controller.text.isNotEmpty) {
        String base64Image = '';
        if (_image != null) {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          base64Image = base64Encode(imageBytes);
        }
        int result = await helper.insertContact(
          Contact(_fNameController.text ?? '', _emailController.text ?? '',
              base64Image, _mobile1Controller.text ?? ''),
        );

        if (result != 0) {
          Navigator.pop(context, 'new');
        } else {
          _showSnackBar('Something went wrong');
        }
      } else {
        _showSnackBar('Please add name and contact');
      }
    } else {
      if (_fNameController.text.isNotEmpty &&
          _mobile1Controller.text.isNotEmpty) {
        String base64Image = _localFileName ?? '';
        if (_image != null) {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          base64Image = base64Encode(imageBytes);
        }
        int result = await helper.updateContact(
          Contact.withId(
              widget.contact.id,
              _mobile1Controller.text ?? '',
              base64Image,
              _emailController.text ?? '',
              _fNameController.text ?? ''),
        );

        if (result != 0) {
          Navigator.pop(context, 'update');
        } else {
          _showSnackBar('Something went wrong');
        }
      } else {
        _showSnackBar('Please add name and contact');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: _appBar(),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoScrollAnimation(),
          child: SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.maxFinite,
                    child: Center(
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 10.0,
                            color: Colors.grey[200],
                          ),
                          color: Colors.grey[200],
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
                        child: GestureDetector(
                          onTap: _showModalBottomSheet,
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFb4e5f5),
                            backgroundImage: _image != null
                                ? FileImage(_image)
                                : _localFileName.isNotEmpty
                                    ? MemoryImage(base64Decode(_localFileName))
                                    : null,
                            child: Text(
                              _image != null || _localFileName.isNotEmpty
                                  ? ''
                                  : kAddPicture,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
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
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        ProfileTextField(
                          textEditingController: _fNameController,
                          textFocusNode: _textSecondFocusNode,
                          icon: Icons.person,
                          labelText: kName,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextField(
                            cursorColor: kPrimaryColor,
                            focusNode: _textSecondFocusNode,
                            maxLength: 40,
                            maxLengthEnforced: true,
                            controller: _emailController,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_textThirdFocusNode),
                            decoration: InputDecoration(
                              isDense: false,
                              helperText: '',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                              counterText: '',
                              labelText: kEmail,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: TextField(
                            focusNode: _textThirdFocusNode,
                            cursorColor: kPrimaryColor,
//                          maxLength: 10,
//                          maxLengthEnforced: true,
                            controller: _mobile1Controller,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              isDense: false,
                              helperText: '',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Platform.isIOS
                                    ? Icons.phone_iphone
                                    : Icons.phone_android,
                              ),
                              counterText: '',
                              labelText: kMobile,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField(
      {@required this.textEditingController,
      this.textFocusNode,
      this.focusNode,
      @required this.icon,
      @required this.labelText});

  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final IconData icon;
  final String labelText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextField(
        focusNode: focusNode,
        cursorColor: kPrimaryColor,
        controller: textEditingController,
        style: TextStyle(
          fontSize: 18,
        ),
        keyboardType: TextInputType.text,
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(textFocusNode),
        decoration: InputDecoration(
          isDense: false,
          helperText: '',
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
//          contentPadding: EdgeInsets.all(20),
          labelText: labelText,
        ),
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  BottomSheetItem({@required this.imageName, @required this.imageText});

  final String imageName;
  final String imageText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            imageName,
            height: 50,
            width: 50,
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            imageText,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
