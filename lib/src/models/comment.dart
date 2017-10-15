library models.comment;

import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment extends Object with _$CommentSerializerMixin {
  final String text;
  final DateTime datetime;

  Comment(this.text, this.datetime);

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
