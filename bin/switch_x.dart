library switchX.executable;

import 'dart:async';
import 'dart:io';

import 'package:switch_x/switch_x.dart';

Future<int> main(List<String> arguments) async {
  await runZonedGuarded(() async {
    // Run the link checker. The returned value will be the program's exit code.
    exitCode = await switchX();
  }, (Object e, StackTrace stackTrace) {
    stderr.writeln("INTERNAL ERROR: Sorry! Please open "
        "https://github.com/filiph/switchX/issues/new "
        "in your favorite browser and copy paste the following output there:"
        "\n");
    stderr.writeln(e.toString());
    stderr.writeln(stackTrace.toString());
    exitCode = 2;
  });
  return exitCode;
}
