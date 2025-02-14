import 'package:ferry/ferry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/graphql/__generated__/github.req.gql.dart';
import 'package:git_touch/graphql/__generated__/github.var.gql.dart';
import 'package:git_touch/models/auth.dart';
import 'package:git_touch/scaffolds/refresh_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/object_tree.dart';
import 'package:git_touch/widgets/table_view.dart';
import 'package:provider/provider.dart';

class GhGistsFilesScreen extends StatelessWidget {
  final String id;
  final String login;
  const GhGistsFilesScreen(this.login, this.id);

  @override
  Widget build(BuildContext context) {
    return RefreshStatefulScaffold<GGistData_user_gist?>(
      title: AppBarTitle(AppLocalizations.of(context)!.files),
      fetch: () async {
        final req = GGistReq((b) => b
          ..vars.login = login
          ..vars.name = id);
        final OperationResponse<GGistData, GGistVars?> res =
            await context.read<AuthModel>().gqlClient.request(req).first;
        final gist = res.data!.user!.gist;
        return gist;
      },
      bodyBuilder: (payload, _) {
        return TableView(
          items: payload!.files!.map((v) {
            final uri = Uri(
              path: '/github/$login/gists/$id/${v.name}',
              queryParameters: {
                'content': v.text,
              },
            ).toString();
            return ObjectTreeItem(
              url: uri,
              type: 'file',
              name: v.name ?? '',
              downloadUrl: null,
              size: v.size,
            );
          }),
        );
      },
    );
  }
}
