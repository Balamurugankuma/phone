import 'package:flutter/cupertino.dart';

class contact {
  int? id;
  String? name;
  String? phone_number;
  contact({this.id, this.name, this.phone_number});
  Map<String, dynamic> tomap() {
    final mapping = <String, dynamic>{};
    if (id != null) {
      mapping['id'] = id;
    }
    mapping['name'] = name;
    mapping['phone_number'] = phone_number;
    return mapping;
  }

  factory contact.fromMap(Map<String, dynamic> map) {
    return contact(
      id: map['id'],
      name: map['name'],
      phone_number: map['phone_number'],
    );
  }
}
