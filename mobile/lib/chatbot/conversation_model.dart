import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mental_health_app/repository/firebase_repostiories.dart';

part 'conversation_model.g.dart';

class DateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ConversationDataModel {
  @JsonKey(includeFromJson: false, includeToJson: false)
  late final String id;
  final String name;
  final String model;
  @DateTimeConverter()
  final DateTime dateAccessed;
  @DateTimeConverter()
  final DateTime dateCreated;
  final String uid;
  ConversationDataModel(
      this.name, this.model, this.dateAccessed, this.dateCreated, this.uid);

  Map<String, dynamic> toJson() => _$ConversationDataModelToJson(this);

  factory ConversationDataModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationDataModelFromJson(json);

  factory ConversationDataModel.fromQueryDocSnapshot(
      QueryDocumentSnapshot<Object?> e) {
    print((e.data()! as Map<String, dynamic>)['date_accessed']);
    final ConversationDataModel c =
        ConversationDataModel.fromJson(e.data()! as Map<String, dynamic>);
    c.id = e.id;
    return c;
  }
}
