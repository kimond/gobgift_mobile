// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.wish_list;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

WishList _$WishListFromJson(Map<String, dynamic> json) =>
    new WishList(json['_id'] as int, json['name'] as String);

abstract class _$WishListSerializerMixin {
  String get name;
  int get _id;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, '_id': _id};
}
