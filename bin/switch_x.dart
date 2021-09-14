// cSpell:ignore writeln

library switch_x.executable;

import 'dart:async';
import 'dart:io';

import 'package:switch_x/switch_x.dart';

Future<int> main(List<String> args) async {
  await runZonedGuarded(() async {
    exitCode = await run(args);
  }, (Object e, StackTrace stackTrace) {
    stderr.writeln("INTERNAL ERROR: Sorry! can't switch between two file. "
        "\n");
    stderr.writeln(e.toString());
    stderr.writeln(stackTrace.toString());
    exitCode = 2;
  });
  return exitCode;
}
