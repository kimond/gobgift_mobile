import 'package:build_runner/build_runner.dart';
import 'package:json_serializable/generators.dart';
import 'package:source_gen/source_gen.dart';

final List<BuildAction> buildActions = [
  new BuildAction(
      new PartBuilder(const [
        const JsonSerializableGenerator(),
      ]),
      'gobgift_mobile',
      inputs: const ['lib/src/models/*.dart'])
];