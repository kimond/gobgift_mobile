// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.gift;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Gift _$GiftFromJson(Map<String, dynamic> json) => new Gift(
    json['id'] as int,
    json['name'] as String,
    json['photo'] as String,
    json['description'] as String,
    (json['price'] as num)?.toDouble(),
    json['website'] as String,
    json['store'] as String,
    json['purchased'] as bool);

abstract class _$GiftSerializerMixin {
  int get id;
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
