// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.gift;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => new Gift(
    json['name'] as String,
    json['photo'] as String,
    json['description'] as String,
    (json['price'] as num)?.toDouble(),
    json['website'] as String,
    json['store'] as String,
    json['purchased'] as bool);

abstract class _$GiftSerializerMixin {
  String get name;
  String get photo;
  String get description;
  double get price;
  String get website;
  String get store;
  bool get purchased;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'photo': photo,
        'description': description,
        'price': price,
        'website': website,
        'store': store,
        'purchased': purchased
      };
}
