// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class ChatModel {
  String? sender;
  String? message;
  DateTime? timeStamp;
  ChatModel({
    this.sender,
    this.message,
    this.timeStamp,
  });

  ChatModel copyWith({
    String? sender,
    String? message,
    DateTime? timeStamp,
  }) {
    return ChatModel(
      sender: sender ?? this.sender,
      message: message ?? this.message,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'message': message,
      'timeStamp': timeStamp?.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      sender: map['sender'] != null ? map['sender'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      timeStamp: map['timeStamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatModel(sender: $sender, message: $message, timeStamp: $timeStamp)';

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.sender == sender &&
        other.message == message &&
        other.timeStamp == timeStamp;
  }

  @override
  int get hashCode => sender.hashCode ^ message.hashCode ^ timeStamp.hashCode;
}

class ChatRoomModel {
  String? chatroomid;
  String? lastmessage;
  Map<String, dynamic>? participants;
  List<String>? users;
  String? lastActive;
  ChatRoomModel({
    this.chatroomid,
    this.lastmessage,
    this.participants,
    this.users,
    this.lastActive,
  });

  ChatRoomModel copyWith({
    String? chatroomid,
    String? lastmessage,
    Map<String, dynamic>? participants,
    List<String>? users,
    String? lastActive,
  }) {
    return ChatRoomModel(
      chatroomid: chatroomid ?? this.chatroomid,
      lastmessage: lastmessage ?? this.lastmessage,
      participants: participants ?? this.participants,
      users: users ?? this.users,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatroomid': chatroomid,
      'lastmessage': lastmessage,
      'participants': participants,
      'users': users,
      'lastActive': lastActive,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatroomid:
          map['chatroomid'] != null ? map['chatroomid'] as String : null,
      lastmessage:
          map['lastmessage'] != null ? map['lastmessage'] as String : null,
      participants: map['participants'] != null
          ? Map<String, dynamic>.from(
              map['participants'] as Map<String, dynamic>)
          : null,
      users: map['users'] != null
          ? List<String>.from(map['users'] as List<dynamic>)
          : null,
      lastActive:
          map['lastActive'] != null ? map['lastActive'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoomModel.fromJson(String source) =>
      ChatRoomModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatRoomModel(chatroomid: $chatroomid, lastmessage: $lastmessage, participants: $participants, users: $users, lastActive: $lastActive)';
  }

  @override
  bool operator ==(covariant ChatRoomModel other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other.chatroomid == chatroomid &&
        other.lastmessage == lastmessage &&
        collectionEquals(other.participants, participants) &&
        collectionEquals(other.users, users) &&
        other.lastActive == lastActive;
  }

  @override
  int get hashCode {
    return chatroomid.hashCode ^
        lastmessage.hashCode ^
        participants.hashCode ^
        users.hashCode ^
        lastActive.hashCode;
  }
}
