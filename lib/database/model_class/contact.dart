class Contact {
  String _name, _mobile, _image, _email;
  int _id;

  Contact(this._name, this._email, this._image, this._mobile);

  Contact.withId(this._id, this._mobile, this._image, this._email, this._name);

  int get id => _id;

  get email => _email;

  set email(value) {
    _email = value;
  }

  get image => _image;

  set image(value) {
    _image = value;
  }

  get mobile => _mobile;

  set mobile(value) {
    _mobile = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['name'] = _name;
    map['mobile'] = _mobile;
    map['image'] = _image;
    map['email'] = _email;

    return map;
  }

  Contact.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._mobile = map['mobile'];
    this._email = map['email'];
    this._image = map['image'];
  }
}
