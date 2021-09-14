import 'package:cli_pkg/cli_pkg.dart' as pkg;
import 'package:grinder/grinder.dart';

void main(List<String> args) {
  pkg.name.value = "switchX";
  pkg.humanName.value = "switchX";
  pkg.githubRepo.value = "filiph/switchX";
  pkg.addAllTasks();
  grind(args);
}

@DefaultTask()
@Task()
Future test() => TestRunner().testAsync();

@Task()
void clean() => defaultClean();
