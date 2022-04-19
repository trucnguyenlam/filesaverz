/// Libarary of [FileSaver].
///
/// A package to browse folder and get path out of it.
library filesaver;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../addons/filesaverfunction.dart';
import '../widgets/header.dart';
import '../widgets/body.dart';
import '../widgets/footer.dart';
import '../styles/style.dart';
import '../state/filesaverstate.dart';

/// File explorer to browse and select folder path.
class FileSaver extends StatelessWidget {
  /// An optional header of [FileSaver].
  ///
  /// Default value is [header].
  final Widget? headerBuilder;

  /// An optional body of [FileSaver].
  ///
  /// Displaying list of [FileSystemEntity].
  /// Default value is [body].
  final Widget? bodyBuilder;

  /// An optional footer of [FileSaver].
  ///
  /// Displaying option to input file name and select file types.
  /// Default value is [header].
  final Widget? footerBuilder;

  final FileSaverStyle? style;

  /// Default name that will be saved later. If user insert a new name, than it will be replaced.
  ///
  /// ```dart
  /// String initialFileName = 'Untitled File';
  /// ```
  final String initialFileName;

  /// An optional [Directory].
  ///
  /// Default value in android is calling a [MethodChannel] of `Environment.getExternalStorageDirectory()`.
  /// Where another platform will using [Directory.systemTemp] and if it doesn't exist, it will using [Directory.current].
  final Directory? initialDirectory;

  /// A list [String] of file types.
  ///
  /// ```dart
  /// List<String> fileTypes = ['txt','rtf','html'];
  /// ```
  final List<String> fileTypes;

  ///
  FileSaver.builder(
      {Key? key,
      required this.initialFileName,
      required this.fileTypes,
      this.initialDirectory,
      Widget? Function(BuildContext context, FileSaverState state)?
          headerBuilder,
      Widget? Function(BuildContext context, FileSaverState state)? bodyBuilder,
      Widget? Function(BuildContext context, FileSaverState state)?
          footerBuilder,
      this.style})
      : headerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => headerBuilder == null
                ? header(
                    context: context,
                    state: value,
                    style: style ?? FileSaverStyle())
                : headerBuilder(context, value)!),
        bodyBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => bodyBuilder == null
                ? body(
                    context: context,
                    state: value,
                    style: style ?? FileSaverStyle())
                : bodyBuilder(context, value)!),
        footerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => footerBuilder == null
                ? footer(
                    context: context,
                    state: value,
                    fileName: value.fileName,
                    fileTypes: value.fileTypes,
                    style: style ?? FileSaverStyle())
                : footerBuilder(context, value)!),
        super(key: key);

  FileSaver(
      {Key? key,
      required this.initialFileName,
      required this.fileTypes,
      this.initialDirectory,
      this.style})
      : headerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => header(
                context: context,
                state: value,
                style: style ?? FileSaverStyle())),
        bodyBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => body(
                context: context,
                state: value,
                style: style ?? FileSaverStyle())),
        footerBuilder = Consumer<FileSaverState>(
            builder: (context, value, child) => footer(
                context: context,
                state: value,
                fileName: value.fileName,
                fileTypes: value.fileTypes,
                style: style ?? FileSaverStyle())),
        super(key: key);

  FileSaver.copyWith(
      {Key? key,
      required FileSaver fileSaver,
      Widget? headerBuilder,
      Widget? bodyBuilder,
      Widget? footerBuilder,
      Color? primaryColor,
      Color? secondaryColor,
      TextStyle? primaryTextStyle,
      TextStyle? secondaryTextStyle,
      String? initialFileName,
      Directory? initialDirectory,
      List<String>? fileTypes,
      FileSaverStyle? style})
      : headerBuilder = headerBuilder ?? fileSaver.headerBuilder,
        bodyBuilder = bodyBuilder ?? fileSaver.bodyBuilder,
        footerBuilder = footerBuilder ?? fileSaver.footerBuilder,
        style = style ?? FileSaverStyle(),
        initialFileName = initialFileName ?? fileSaver.initialFileName,
        initialDirectory = initialDirectory ?? fileSaver.initialDirectory,
        fileTypes = fileTypes ?? fileSaver.fileTypes,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => FileSaverState(
            initialDirectory: initialDirectory,
            fileName: initialFileName,
            fileTypes: fileTypes),
        builder: (providerContext, providerChild) {
          Provider.of<FileSaverState>(providerContext, listen: false)
              .initState();

          return Scaffold(
            backgroundColor: style?.secondaryColor,
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  headerBuilder!,
                  Expanded(child: bodyBuilder!),
                ],
              ),
            ),
            bottomSheet: footerBuilder,
          );
        });
  }
}

extension SavePath on FileSaver {
  Future<String?> savePath(BuildContext context) => savefunction(context, this);
}
