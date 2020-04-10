import 'dart:io';
import 'package:prompter_sg/prompter_sg.dart';

import 'package:converter/src/converter.dart';

void main() {
  final prompter = Prompter();

  final choice = prompter.askBinary('Are you here to convert an image');
  if (!choice) {
    exit(0);
  }

  final String format =
      prompter.askMultiple('Select Format:', buildFormatOptions());

  final selectedFile =
      prompter.askMultiple('Select an image to convert', buildFileOptions());

  final newPath = convertImage(selectedFile, format);

  final shouldOpen = prompter.askBinary('Open the image?');
  if (shouldOpen) {
    Process.run('open', [newPath]);
  }
}

List<Option> buildFormatOptions() {
  return [Option('Convert to jpeg', 'jpeg'), Option('Convert to png', 'png')];
}

List<Option> buildFileOptions() {
  // Get a reference to the current working directory
  return Directory.current.listSync().where((entity) {
    return FileSystemEntity.isFileSync(entity.path) &&
        entity.path.contains(RegExp(r'\.(png|jpg|jpeg)'));
  }).map((entity) {
    final filename = entity.path.split(Platform.pathSeparator).last;
    return Option(filename, entity);
  }).toList();
}
