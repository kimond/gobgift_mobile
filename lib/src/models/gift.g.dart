// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.gift;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) =>
    new Gift(json['id'] as int, json['wishList'] as int, json['name'] as String,
        photo: json['photo'] as String,
        description: json['description'] as String,
        price: (json['price'] as num)?.toDouble(),
        website: json['website'] as String,
        store: json['store'] as String,
        purchased: json['purchased'] as bool);

abstract class _$GiftSerializerMixin {
  int get wishList;
  String get name;
  String get photo;
  String get description;
  double get price;
  String get website;
  String get store;
  bool get purchased;
  int get _id;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{
      'wishList': wishList,
      'name': name,
      'photo': photo,
      'description': description,
      'price': price,
      'website': website,
      'store': store,
      'purchased': purchased,
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
