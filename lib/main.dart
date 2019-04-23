import 'package:flutter/material.dart';

import 'dart:math' as math;

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
    int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  bool _isAnimationFlag = false;

  bool get isAnimation => _isAnimationFlag;

  set isAnimation(flag) => _isAnimationFlag = flag;

  double _maxTitleWidth = -1.0;

  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    text: TextSpan(
      text: "",
      style: TextStyle(fontSize: 14.0),
    ),
  );

  @override
  void initState() {
    super.initState();

    // 计算最大的width
    widget.items.forEach((item) {
      textPainter.text = TextSpan(
          text: item.title, style: TextStyle(fontSize: 14.0));
      textPainter.layout();
      final _width = textPainter.size.width;
      print("_width:$_width");
      if (_maxTitleWidth < _width) {
        _maxTitleWidth = _width;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = math.max(
        MediaQuery.of(context).padding.bottom - 14.0 / 2.0, 0.0);
//    print("additionalBottomPadding:$additionalBottomPadding");
    return Semantics(
      explicitChildNodes: true,
      child: Material(
        elevation: widget.elevation,
        color: widget.bgcolor,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
          child: Material(
            // Splashes.
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(bottom: additionalBottomPadding),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: _createContainer(_createChilds(_maxTitleWidth)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createContainer(List<Widget> childs) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: childs,
      ),
    );
  }

  List<Widget> _createChilds(double _maxTitleWidth) {
    _NavigationBarState state = this;
    List<Widget> childs = [];
    widget.items.asMap().forEach((index, item) {
      childs.add(Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: item.create(index, widget.tabchange, state, _maxTitleWidth),
      ));
    });
//    childs.add(Container(
//      color: Colors.black,
//      height: kBottomNavigationBarHeight,
//      width: 5,
//    ));
    return childs;
  }

  void changeIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      widget.tabchange(index, true);
      setState(() {
        _isAnimationFlag = true;
      });
    } else {
      widget.tabchange(index, false);
    }
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
  bool _isOpen = false; // bool that checkes whether it is already selected
  bool get isOpen => _isOpen;
  set isOpen(bool isOpen) {}

  AnimationController _controller; // main animation controller
  Animation<Color> _bgColorAnimation; // animation for the bg color change
  Animation<Color> _iconColorAnimation; // icon change and its color change
  Tween<double> _widthTween; // the movement of icons
  Animation<double> _widthAnimation; // animation for the above movement

  bool get wantKeepAlive =>
      true; // * preexsting override maybe to keep to alive

  @override
  void initState() {
    super.initState();
    final mainColor = widget.backgroudColor;
    _isOpen = (widget.index == 0);
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    _iconColorAnimation = new ColorTween(begin: Colors.black87, end: mainColor)
        .animate(_controller);
    _bgColorAnimation = new ColorTween(
            begin: Colors.transparent, end: mainColor.withOpacity(0.12))
        .animate(_controller);
     _widthTween = Tween(begin: 0.0, end: 1.0);
    _widthAnimation = _widthTween.animate(_controller);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.addStatusListener((status) {
//      print("status:$status--controller:$_animationController");
      if (status == AnimationStatus.completed) {
        _isOpen = true;
        widget.parentState.isAnimation = false;
      } else if (status == AnimationStatus.dismissed) {
        _isOpen = false;
        widget.parentState.isAnimation = false;
      }
    });
    _isOpen = widget.index == widget.parentState.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    _animationIndex(widget.parentState.selectedIndex);
  }
}
