class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text('SliverAppBar'),
          pinned: false,
          floating: true,
          snap: true,
          elevation: 0.0,
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
              child: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('SliverPersistentHeader',
                        style: TextStyle(color: Colors.white, fontSize: 20.0))
                  ],
                ),
              ),
            ),
          )),
        ),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.red),
              Container(color: Colors.purple),
              Container(color: Colors.green),
              Container(color: Colors.orange),
              Container(color: Colors.yellow),
              Container(color: Colors.pink),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final PreferredSize child;

  _SliverAppBarDelegate({this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => child.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
