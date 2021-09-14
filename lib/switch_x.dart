// cSpell:ignore pubspec, writeln
// ignore_for_file: avoid_print
library switch_x.run;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;

/// [filename] common name of two file like: `pubspec` for pubspec.yaml, pubspec.x.yaml
/// [x] difference between file name like: `x` for pubspec.yaml, pubspec.x.yaml
/// [startsWith] check for file content starts with given string
/// [force] force switch ignore [startsWith]
Future<int> switchX({
  String fileName = 'pubspec',
  String x = 'x',
  String? startsWith,
  bool force = false,
}) async {
  print('Switching pubspec ${force ? 'using force' : ''}...');
  final _dir = Directory.current.path;
  final x = File(path.join(_dir, '$fileName.yaml'));
  final y = File(path.join(_dir, '$fileName.$x.yaml'));
  final xContent = await x.readAsString();
  if (!force && startsWith == null || xContent.startsWith('#$startsWith')) {
    print('no need to switch. already using correct $fileName file.');
    return 1;
  }
  final yContent = await y.readAsString();
  await x.writeAsString(yContent);
  await y.writeAsString(xContent);
  print('Successfully switched');
  return 0;
}
