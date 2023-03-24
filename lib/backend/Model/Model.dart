// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Model {
  String? email;
  String? fullname;
  String? number;
  String? address;
  String? decp;
  String? uid;
  String? brief;
  String? imgurl;
  Model({
    this.email,
    this.fullname,
    this.number,
    this.address,
    this.decp,
    this.uid,
    this.brief,
    this.imgurl,
  });

  Model copyWith({
    String? email,
    String? fullname,
    String? number,
    String? address,
    String? decp,
    String? uid,
    String? brief,
    String? imgurl,
  }) {
    return Model(
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      number: number ?? this.number,
      address: address ?? this.address,
      decp: decp ?? this.decp,
      uid: uid ?? this.uid,
      brief: brief ?? this.brief,
      imgurl: imgurl ?? this.imgurl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'fullname': fullname,
      'number': number,
      'address': address,
      'decp': decp,
      'uid': uid,
      'brief': brief,
      'imgurl': imgurl,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      email: map['email'] != null ? map['email'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      decp: map['decp'] != null ? map['decp'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      brief: map['brief'] != null ? map['brief'] as String : null,
      imgurl: map['imgurl'] != null ? map['imgurl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) => Model.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Model(email: $email, fullname: $fullname, number: $number, address: $address, decp: $decp, uid: $uid, brief: $brief, imgurl: $imgurl)';
  }

  @override
  bool operator ==(covariant Model other) {
    if (identical(this, other)) return true;
  
    return 
      other.email == email &&
      other.fullname == fullname &&
      other.number == number &&
      other.address == address &&
      other.decp == decp &&
      other.uid == uid &&
      other.brief == brief &&
      other.imgurl == imgurl;
  }

  @override
  int get hashCode {
    return email.hashCode ^
      fullname.hashCode ^
      number.hashCode ^
      address.hashCode ^
      decp.hashCode ^
      uid.hashCode ^
      brief.hashCode ^
      imgurl.hashCode;
  }

  
  }


