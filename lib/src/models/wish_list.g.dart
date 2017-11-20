// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.wish_list;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

WishList _$WishListFromJson(Map<String, dynamic> json) =>
    new WishList(json['id'] as int, json['name'] as String,
        owner: json['owner'] == null
            ? null
            : new User.fromJson(json['owner'] as Map<String, dynamic>));

abstract class _$WishListSerializerMixin {
  String get name;
  int get _id;
  User get owner;
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
    val['owner'] = owner;
    return val;
  }
}
