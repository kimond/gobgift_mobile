// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.wish_list;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

WishList _$WishListFromJson(Map<String, dynamic> json) =>
    new WishList(json['id'] as int, json['name'] as String);

abstract class _$WishListSerializerMixin {
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
