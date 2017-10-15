// GENERATED CODE - DO NOT MODIFY BY HAND

part of models.comment;

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => new Comment(
    json['text'] as String,
    json['datetime'] == null
        ? null
        : DateTime.parse(json['datetime'] as String));

abstract class _$CommentSerializerMixin {
  String get text;
  DateTime get datetime;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'text': text, 'datetime': datetime?.toIso8601String()};
}
