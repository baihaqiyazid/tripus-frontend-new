import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

class CustomRefresh extends StatelessWidget {
  final VoidCallback refreshData;
  final VoidCallback loadData;
  final Widget child;
  final RefreshController refreshController;

  CustomRefresh({required this.refreshController, required this.refreshData, required this.loadData, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: refreshData,
        header: CustomHeader(
          builder: (context, mode) {
            if (mode == RefreshStatus.idle) {
              return const Center(child: Text("Load more"));
            } else if (mode == RefreshStatus.refreshing) {
              return const Center(
                child: SizedBox(
                    width: 50, height: 50, child: CupertinoActivityIndicator()),
              );
            } else if (mode == RefreshStatus.failed) {
              return const Center(child: Text("Load Failed!Click retry!"));
            } else {
              return const Center();
            }
          },
        ),
        footer: CustomFooter(
          builder: (context, mode) {
            if (mode == LoadStatus.idle) {
              return const Center(child: Text("Load more"));
            } else if (mode == LoadStatus.loading) {
              return const Center(
                child: SizedBox(
                    width: 50, height: 50, child: CupertinoActivityIndicator()),
              );
            } else if (mode == LoadStatus.failed) {
              return const Center(child: Text("Load Failed!Click retry!"));
            } else {
              return const Center();
            }
          },
        ),
        onLoading: () => loadData,
        child: child);
  }
}
