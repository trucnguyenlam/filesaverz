import 'dart:io';

import 'package:filesaver/addons/bytesConverter.dart';
import 'package:filesaver/addons/characterLimiter.dart';
import 'package:filesaver/addons/datesConverter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../FileSaverState.dart';

Widget body(
        {required Color primaryColor,
        required Color secondaryColor,
        required TextStyle secondaryTextStyle}) =>
    Consumer<FileSaverState>(builder: (context, value, child) {
      String directoryPath =
          value.initialDirectory == null ? '/' : value.initialDirectory!.path;

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: directoryPath.split('/').length > 2
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () =>
                              value.browse(Directory(directoryPath).parent),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            padding: const EdgeInsets.symmetric(
                                horizontal: NavigationToolbar.kMiddleSpacing,
                                vertical: 7.5),
                            child: Text(
                              Directory(directoryPath)
                                  .parent
                                  .path
                                  .split('/')
                                  .last,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp, size: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: NavigationToolbar.kMiddleSpacing,
                              vertical: 7.5),
                          child: Text(
                            directoryPath.split('/').last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: secondaryTextStyle,
                          ),
                        ),
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: NavigationToolbar.kMiddleSpacing,
                        vertical: 5.0),
                    child: Text(
                      directoryPath,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: secondaryTextStyle,
                    ),
                  ),
          ),
          value.entityList.isEmpty
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.folder_sharp,
                        color: primaryColor.withOpacity(0.25),
                        size: kToolbarHeight,
                      ),
                      Text(
                        'Folder is empty',
                        style: TextStyle(
                            color: secondaryTextStyle.color!.withOpacity(0.25),
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        ///Default Text
                        String itemName =
                            value.entityList[index].path.split('/').last;
                        String itemExt = value.entityList[index] is File
                            ? itemName.split('.').last
                            : '';

                        ///Default Icon
                        Widget icon = value.entityList[index] is File
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Icon(
                                    Icons.insert_drive_file_sharp,
                                    color: primaryColor.withOpacity(0.35),
                                    size: kToolbarHeight,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: secondaryColor,
                                          border: Border.all(
                                              width: 1, color: primaryColor)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2.5),
                                      child: Row(
                                        children: [
                                          Text(
                                            itemExt.toLimit(4).toUpperCase(),
                                            style: secondaryTextStyle.copyWith(
                                                fontSize: 10,
                                                color: primaryColor),
                                          ),
                                        ],
                                      ))
                                ],
                              )
                            : Icon(
                                Icons.folder_sharp,
                                color: primaryColor.withOpacity(0.75),
                                size: kToolbarHeight,
                              );

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (value.entityList[index] is Directory) {
                                value.browse(
                                    value.entityList[index] as Directory);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: NavigationToolbar.kMiddleSpacing),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  icon,
                                  const SizedBox(width: 5),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        itemName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: secondaryTextStyle,
                                      ),
                                      const SizedBox(height: 5),
                                      DefaultTextStyle(
                                          style: secondaryTextStyle.copyWith(
                                              color: secondaryTextStyle.color
                                                  ?.withOpacity(0.25),
                                              fontWeight: FontWeight.normal,
                                              fontSize: 11),
                                          child: Text.rich(TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${value.entityList[index].statSync().modified.convertToDates()}   '),
                                            value.entityList[index] is File
                                                ? TextSpan(
                                                    text:
                                                        '|   ${(value.entityList[index] as File).statSync().size.convertToBytes()}')
                                                : const TextSpan()
                                          ]))),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      itemCount: value.entityList.length,
                      shrinkWrap: true,
                    ),
                  ),
                ),
        ],
      );
    });