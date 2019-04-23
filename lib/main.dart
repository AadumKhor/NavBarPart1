import 'package:flutter/material.dart';

typedef Tabchange = Function(int, bool);

class NavigationBar extends StatefulWidget {
  Key key;
  @required
  Color bgcolor;
  final Tabchange tabchange;
  final List<BottomNaviItem> items;
  final double elevation;

  NavigationBar(
      {this.key,
      this.bgcolor = Colors.white,
      this.elevation = 20.0,
      this.tabchange,
      this.items})
      : assert(items != null && items.length > 0),
        assert(tabchange == null),
        super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class BottomNaviItem {
  String title;
  Color color;
  String icon;

  BottomNaviItem({this.title, this.color, this.icon}) : super();

  _BottomNaviItemState create(int index, Tabchange tabChange,
          _NavigationBarState parentState, double titleWidth) =>
      _BottomNaviItemState(
        title: this.title,
        icon: this.icon,
        backgroudColor: this.color,
        index: index,
        tabChange: tabChange,
        parentState: parentState,
        maxTitleWidth: titleWidth,
      );
}

class _BottomNaviItemState extends StatefulWidget {
  final String title;
  final String icon;
  final Color backgroudColor;
  final int index;
  final Tabchange tabChange;
  final _NavigationBarState parentState;
  final double maxTitleWidth;

  _BottomNaviItemState({
    Key key,
    @required this.title,
    @required this.icon,
    @required this.backgroudColor,
    @required this.index,
    @required this.tabChange,
    @required this.parentState,
    @required this.maxTitleWidth,
  })  : assert(title != null),
        assert(icon != null),
        assert(backgroudColor != null),
        assert(index >= 0),
        assert(tabChange != null),
        assert(parentState != null),
        assert(maxTitleWidth > 0),
        super(key: key);

  @override
  __BottomNaviItemStateState createState() => __BottomNaviItemStateState();
}

class __BottomNaviItemStateState extends State<_BottomNaviItemState>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool _isOpen = false;

  set isOpen(bool isOpen){}
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => null;
}
