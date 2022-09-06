import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/models/bitbucket.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/widgets/action_entry.dart';
import 'package:git_touch/widgets/repository_item.dart';
import 'package:git_touch/widgets/user_header.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:git_touch/utils/utils.dart';

class BbUserScreen extends StatelessWidget {
  final String? login;
  final bool isTeam;
  const BbUserScreen(this.login, {this.isTeam = false});
  bool get isViewer => login == null;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthModel>(context);
    final accountId = auth.activeAccount!.accountId;
    final finalLogin = login ?? auth.activeAccount!.login;
    return RefreshStatefulScaffold<Tuple2<BbUser, Iterable<BbRepo>>>(
      title: Text(isViewer
          ? 'Me'
          : isTeam
              ? 'Team'
              : 'User'),
      fetch: () async {
        final res = await Future.wait([
          auth
              .fetchBbJson('/${isTeam ? 'teams' : 'users'}/$accountId')
              .then((value) => BbUser.fromJson(value)),
          auth
              .fetchBbWithPage('/repositories/$finalLogin')
              .then((value) => [for (var v in value.items) BbRepo.fromJson(v)]),
        ]);
        return Tuple2(res[0] as BbUser, res[1] as Iterable<BbRepo>);
      },
      action: isViewer
          ? const ActionEntry(
              iconData: Ionicons.cog,
              url: '/settings',
            )
          : null,
      bodyBuilder: (data, _) {
        final user = data.item1;
        final repos = data.item2;
        return Column(
          children: <Widget>[
            UserHeader(
              login: finalLogin,
              avatarUrl: user.avatarUrl,
              name: user.displayName,
              createdAt: user.createdOn,
              isViewer: isViewer,
              bio: null,
            ),
            CommonStyle.border,
            Column(
              children: <Widget>[
                for (var v in repos) RepositoryItem.bb(payload: v)
              ],
            )
          ],
        );
      },
    );
  }
}
