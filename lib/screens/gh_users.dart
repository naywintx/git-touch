import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:git_touch/graphql/__generated__/github.data.gql.dart';
import 'package:git_touch/graphql/__generated__/github.req.gql.dart';
import 'package:git_touch/graphql/__generated__/github.var.gql.dart';
import 'package:git_touch/scaffolds/list_stateful.dart';
import 'package:git_touch/widgets/app_bar_title.dart';
import 'package:git_touch/widgets/user_item.dart';
import 'package:git_touch/models/auth.dart';
import 'package:provider/provider.dart';

class GhFollowers extends StatelessWidget {
  final String login;
  const GhFollowers(this.login);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserItem, String?>(
      title: const AppBarTitle('Followers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GFollowersReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GFollowersData, GFollowersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.user!.followers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.gql(p);
      },
    );
  }
}

class GhFollowing extends StatelessWidget {
  final String login;
  const GhFollowing(this.login);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserItem, String?>(
      title: const AppBarTitle('Following'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GFollowingReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GFollowingData, GFollowingVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.user!.following;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.gql(p);
      },
    );
  }
}

class GhMembers extends StatelessWidget {
  final String login;
  const GhMembers(this.login);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserItem, String?>(
      title: const AppBarTitle('Members'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GMembersReq((b) {
          b.vars.login = login;
          b.vars.after = cursor;
        });
        final OperationResponse<GMembersData, GMembersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.organization!.membersWithRole;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.gql(p);
      },
    );
  }
}

class GhWachers extends StatelessWidget {
  final String owner;
  final String name;
  const GhWachers(this.owner, this.name);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserItem, String?>(
      title: const AppBarTitle('Wachers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GWatchersReq((b) {
          b.vars.owner = owner;
          b.vars.name = name;
          b.vars.after = cursor;
        });
        final OperationResponse<GWatchersData, GWatchersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.repository!.watchers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.gql(p);
      },
    );
  }
}

class GhStargazers extends StatelessWidget {
  final String owner;
  final String name;
  const GhStargazers(this.owner, this.name);

  @override
  Widget build(BuildContext context) {
    return ListStatefulScaffold<GUserItem, String?>(
      title: const AppBarTitle('Stargazers'),
      fetch: (cursor) async {
        final auth = context.read<AuthModel>();
        final req = GStargazersReq((b) {
          b.vars.owner = owner;
          b.vars.name = name;
          b.vars.after = cursor;
        });
        final OperationResponse<GStargazersData, GStargazersVars?> res =
            await auth.gqlClient.request(req).first;
        final p = res.data!.repository!.stargazers;
        return ListPayload(
          cursor: p.pageInfo.endCursor,
          hasMore: p.pageInfo.hasNextPage,
          items: p.nodes!,
        );
      },
      itemBuilder: (p) {
        return UserItem.gql(p);
      },
    );
  }
}
