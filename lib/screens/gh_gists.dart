import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:git_touch/graphql/__generated__/github.var.gql.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/gists_item.dart';
import 'package:provider/provider.dart';
import 'package:git_touch/models/auth.dart';
import 'package:flutter_gen/gen_l10n/S.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/graphql/__generated__/github.req.gql.dart';

class GhGistsScreen extends StatelessWidget {
  final String login;
  const GhGistsScreen(this.login);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GGistsData_user_gists_nodes, String?>(
      title: AppBarTitle(AppLocalizations.of(context)!.gists),
      fetch: (page) async {
        final req = GGistsReq((b) => b
          ..vars.login = login
          ..vars.after = page);
        final OperationResponse<GGistsData, GGistsVars?> res =
            await context.read<AuthModel>().gqlClient.request(req).first;
        final gists = res.data!.user!.gists;
        return ListPayload(
          cursor: gists.pageInfo.endCursor,
          items: gists.nodes ?? [],
          hasMore: gists.pageInfo.hasNextPage,
        );
      },
      itemBuilder: (v) {
        final filenames = [for (var file in v.files!) file.name];
        // TODO: add gist comments
        return GistsItem(
          description: v.description,
          login: login,
          filenames: filenames,
          language: v.files![0].language!.name,
          avatarUrl: v.owner!.avatarUrl,
          updatedAt: v.updatedAt,
          id: v.name,
        );
      },
    );
  }
}
