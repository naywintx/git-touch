import 'dart:convert';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/bitbucket.dart';
import 'package:git_touch/models/theme.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/utils/utils.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/markdown_view.dart';
import 'package:git_touch/widgets/repo_header.dart';
import 'package:git_touch/widgets/table_view.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class BbRepoScreen extends StatelessWidget {
  final String owner;
  final String name;
  final String? branch;
  const BbRepoScreen(this.owner, this.name, {this.branch});

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<Tuple3<BbRepo, String?, List<BbBranch>>>(
      title: AppBarTitle(AppLocalizations.of(context)!.repository),
      fetch: () async {
        final auth = context.read<AuthModel>();
        final r = await auth.fetchBbJson('/repositories/$owner/$name');
        final repo = BbRepo.fromJson(r);
        final res = await auth.fetchBb(
            '/repositories/$owner/$name/src/${repo.mainbranch!.name}/README.md');
        final readme =
            res.statusCode >= 400 ? null : utf8.decode(res.bodyBytes);
        final branches = await auth
            .fetchBbWithPage('/repositories/$owner/$name/refs/branches')
            .then((v) {
          return [for (var branch in v.items) BbBranch.fromJson(branch)];
        });
        return Tuple3(repo, readme, branches);
      },
      bodyBuilder: (t, _) {
        final theme = Provider.of<ThemeModel>(context);
        final p = t.item1;
        final branches = t.item3;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RepoHeader(
              avatarUrl: p.avatarUrl,
              avatarLink: null,
              owner: p.ownerLogin,
              name: p.slug,
              description: p.description,
              homepageUrl: p.website,
            ),
            CommonStyle.border,
            TableView(
              items: [
                TableViewItem(
                  leftIconData: Octicons.code,
                  text: const Text('Code'),
                  rightWidget: Text(filesize(p.size)),
                  url:
                      '/bitbucket/$owner/$name/src/${branch ?? p.mainbranch!.name}',
                ),
                TableViewItem(
                  leftIconData: Octicons.issue_opened,
                  text: const Text('Issues'),
                  url: '/bitbucket/$owner/$name/issues',
                ),
                TableViewItem(
                  leftIconData: Octicons.git_pull_request,
                  text: const Text('Pull requests'),
                  url: '/bitbucket/$owner/$name/pulls',
                ),
                TableViewItem(
                  leftIconData: Octicons.history,
                  text: const Text('Commits'),
                  url:
                      '/bitbucket/$owner/$name/commits/${branch ?? p.mainbranch!.name}',
                ),
                TableViewItem(
                  leftIconData: Octicons.git_branch,
                  text: Text(AppLocalizations.of(context)!.branches),
                  rightWidget: Text('${(branch ?? p.mainbranch!.name)!} • ${branches.length}'),
                  onTap: () async {
                    if (branches.length < 2) return;

                    await theme.showPicker(
                      context,
                      PickerGroupItem(
                        value: branch,
                        items: branches
                            .map((b) => PickerItem(b.name, text: b.name))
                            .toList(),
                        onClose: (ref) {
                          if (ref != branch) {
                            theme.push(
                                context, '/bitbucket/$owner/$name?branch=$ref',
                                replace: true);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            CommonStyle.verticalGap,
            if (t.item2 != null) MarkdownFlutterView(t.item2),
            CommonStyle.verticalGap,
          ],
        );
      },
    );
  }
}
