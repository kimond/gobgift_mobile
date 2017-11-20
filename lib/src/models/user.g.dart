// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.comment;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => new User(
    json['id'] as int,
    json['username'] as String,
    json['first_name'] as String,
    json['last_name'] as String);

abstract class _$UserSerializerMixin {
  int get id;
  String get username;
  String get firstName;
  String get lastName;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'first_name': firstName,
        'last_name': lastName
      };
}
