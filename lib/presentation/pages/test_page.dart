import 'package:flutter/material.dart';

class Sample2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: MySliverAppBar(expandedHeight: 300),
            pinned: true,
          ),
          SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (_, index) => ListTile(
                    title: Text("Index: $index"),
                  ),
                ),
              ))
        ],
      ),
    )));
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Opacity(
                    opacity: shrinkOffset < 100
                        ? 1
                        : shrinkOffset > 300
                            ? 0
                            : (expandedHeight - shrinkOffset) / expandedHeight,
                    child: Image.asset(
                      'assets/pill2.png',
                      width: 200,
                      height: 200,
                    ))),
            Text(
              'Циркумфлекc',
              style: TextStyle(
                  fontSize: (15 * shrinkOffset / 100) < 16
                      ? 16
                      : (16 * shrinkOffset / 100) > 22
                          ? 22
                          : 16 * shrinkOffset / 100),
            ),
            Text('Осталось 50 таблеток')
          ],
        ),

        // Center(
        //   child: Opacity(
        //     opacity: shrinkOffset / expandedHeight,
        //     child: Text(
        //       "Цикруемфлексм",
        //       style: TextStyle(
        //         fontWeight: FontWeight.w700,
        //         fontSize: 23,
        //       ),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   top: expandedHeight / 2 - shrinkOffset,
        //   left: MediaQuery.of(context).size.width / 4,
        //   child: Opacity(
        //     opacity: (1 - shrinkOffset / expandedHeight),
        //     child: Card(
        //       elevation: 10,
        //       child: SizedBox(
        //         height: expandedHeight,
        //         width: MediaQuery.of(context).size.width / 2,
        //         child: FlutterLogo(),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
