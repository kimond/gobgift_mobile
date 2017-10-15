// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.wish_list;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

WishList _$WishListFromJson(Map<String, dynamic> json) =>
    new WishList(json['name'] as String);

abstract class _$WishListSerializerMixin {
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}
