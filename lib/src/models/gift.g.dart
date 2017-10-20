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
  int get id;
  int get wishList;
  String get name;
  String get photo;
  String get description;
  double get price;
  String get website;
  String get store;
  bool get purchased;
  Map<String, dynamic> toJson() {
    var val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    val['wishList'] = wishList;
    val['name'] = name;
    val['photo'] = photo;
    val['description'] = description;
    val['price'] = price;
    val['website'] = website;
    val['store'] = store;
    val['purchased'] = purchased;
    return val;
  }
}
