// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.group;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) =>
    new Group(json['name'] as String);

abstract class _$GroupSerializerMixin {
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}
