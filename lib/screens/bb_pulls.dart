import 'package:flutter/material.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/bitbucket.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/issue_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/S.dart';

class BbPullsScreen extends StatelessWidget {
  final String owner;
  final String name;
  const BbPullsScreen(this.owner, this.name);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    return ListStatefulScaffold<BbPulls, String?>(
      title: AppBarTitle(AppLocalizations.of(context)!.pullRequests),
      fetch: (nextUrl) async {
        final res = await context.read<AuthModel>().fetchBbWithPage(
            nextUrl ?? '/repositories/$owner/$name/pullrequests');
        return ListPayload(
          cursor: res.cursor,
          hasMore: res.hasMore,
          items: <BbPulls>[
            for (var v in res.items) BbPulls.fromJson(v),
          ],
        );
      },
      itemBuilder: (v) {
        int pullNumber =
            int.parse(v.pullRequestLink!.replaceFirst(RegExp(r'.*\/'), ''));
        return IssueItem(
          avatarUrl: v.author!.avatarUrl,
          author: v.author!.displayName,
          title: v.title,
          subtitle: '#$pullNumber',
          commentCount: 0,
          updatedAt: v.createdOn,
          url:
              '${auth.activeAccount!.domain}/$owner/$name/pull-requests/$pullNumber',
        );
      },
    );
  }
}
