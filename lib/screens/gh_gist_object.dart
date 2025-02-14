import 'package:flutter/material.dart';
import 'package:git_touch/scaffolds/common.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/blob_view.dart';
import 'package:git_touch/widgets/action_entry.dart';

class GistObjectScreen extends StatelessWidget {
  final String login;
  final String id;
  final String file;
  final String? raw;
  final String? content;

  const GistObjectScreen(this.login, this.id, this.file, {this.raw, this.content});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        title: AppBarTitle(file),
        action: const ActionEntry(
          iconData: Ionicons.cog,
          url: '/choose-code-theme',
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: BlobView(
              file,
              text: content,
            )));
  }
}
