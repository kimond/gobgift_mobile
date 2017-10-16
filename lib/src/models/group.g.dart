// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.group;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) =>
    new Group(json['id'] as int, json['name'] as String);

abstract class _$GroupSerializerMixin {
  int get id;
  String get name;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    val['name'] = name;
    return val;
  }
}
