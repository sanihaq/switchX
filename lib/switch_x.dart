// cSpell:ignore pubspec, writeln, negatable
// ignore_for_file: avoid_print
library switch_x.run;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';

Future<int> run(List<String> arguments) async {
  const helpFlag = "help";
  const forceFlag = "force";
  const xOption = "set-x";
  const filenameOption = "filename";
  const fileExtensionOption = "fileExtension";
  const startOption = "startsWith";
  final parser = ArgParser(allowTrailingOptions: true)
    ..addFlag(helpFlag, abbr: 'h', negatable: false, help: "Prints this usage help.")
    ..addOption(filenameOption, abbr: 'n', help: "common name of file to switch between")
    ..addOption(fileExtensionOption,
        abbr: 'e', help: "file extension name of the files (default: yaml)")
    ..addOption(xOption, abbr: 'x', help: "difference between file name septate by .")
    ..addOption(startOption,
        abbr: 's', help: "check for file content starts with given string")
    ..addFlag(forceFlag,
        abbr: 'f', negatable: true, help: "common name of file to switch between");
  final args = parser.parse(arguments);
  if (args[helpFlag] == true) {
    print('''
switchX  
  --filename        -n        common name of two file like: `pubspec` for pubspec.yaml, pubspec.x.yaml
  --fileExtension   -e        file extension name of the files (default: yaml)
  --set-x           -x        difference between file name like: `x` for pubspec.yaml, pubspec.x.yaml
  --startsWith      -s        check for file content starts with given string
  --force           -f        force switch ignore [startsWith]
    ''');
    return 0;
  }
  return await switchX(
    fileName: args[filenameOption] as String? ?? 'pubspec',
    fileExtension: args[fileExtensionOption] as String? ?? 'yaml',
    x: args[xOption] as String? ?? 'x',
    startsWith: args[startOption] as String?,
    force: args[forceFlag] == true,
  );
}

/// [filename] common name of two file like: `pubspec` for pubspec.yaml, pubspec.x.yaml
/// [fileExtension] file extension name of the files (default: yaml)
/// [x] difference between file name like: `x` for pubspec.yaml, pubspec.x.yaml
/// [startsWith] check for file content starts with given string
/// [force] force switch ignore [startsWith]
Future<int> switchX({
  String fileName = 'pubspec',
  String fileExtension = 'yaml',
  String x = 'x',
  String? startsWith,
  bool force = false,
}) async {
  print('Switching pubspec ${force ? 'using force' : ''}...');
  final _dir = Directory.current.path;
  final _x = File(path.join(_dir, '$fileName.$fileExtension'));
  final _y = File(path.join(_dir, '$fileName.$x.$fileExtension'));
  if (!await _x.exists() || !await _y.exists()) {
    print(
        '$fileName.$fileExtension or $fileName.$x.$fileExtension file did not match with any existing file in root.');
    return 1;
  }
  final xContent = await _x.readAsString();
  if (!force && startsWith == null || xContent.startsWith('#$startsWith')) {
    print('no need to switch. already using correct $fileName file.');
    return 1;
  }
  final yContent = await _y.readAsString();
  await _x.writeAsString(yContent);
  await _y.writeAsString(xContent);
  print('Successfully switched');
  return 0;
}
