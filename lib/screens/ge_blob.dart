import 'package:flutter/material.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/gitee.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/action_entry.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/blob_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class GeBlobScreen extends StatelessWidget {
  final String owner;
  final String name;
  final String sha;
  final String path;
  const GeBlobScreen(this.owner, this.name, this.sha, this.path);

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<String?>(
      title: AppBarTitle(AppLocalizations.of(context)!.file),
      fetch: () async {
        final auth = context.read<AuthModel>();
        final res = await auth.fetchGitee('/repos/$owner/$name/git/blobs/$sha');
        return GiteeBlob.fromJson(res).content;
      },
      action: const ActionEntry(iconData: Ionicons.cog, url: '/choose-code-theme'),
      bodyBuilder: (content, _) {
        return BlobView(path, base64Text: content);
      },
    );
  }
}
