// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.wish_list;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

WishList _$WishListFromJson(Map<String, dynamic> json) =>
    new WishList(json['id'] as int, json['name'] as String);

abstract class _$WishListSerializerMixin {
  String get name;
  int get _id;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{
      'name': name,
    };

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', _id);
    return val;
  }
}
