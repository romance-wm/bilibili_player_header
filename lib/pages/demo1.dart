import 'package:bilibili_player_header/widget/CustomSliverPersistentHeader.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart' hide NestedScrollView;

class Demo1 extends StatefulWidget {
  @override
  _Demo1State createState() => _Demo1State();
}

class _Demo1State extends State<Demo1> with TickerProviderStateMixin {
  ScrollController _sc = ScrollController();
  bool _isShowTitle = false;
  double _opacity = 0;
  double height = 0;
  double pinHeight = 300;
  double playerHeight = 300;
  double maxHeight = 300;

  ///  滚动显示的距离
  double isShowHeight = 100;
  bool isPlay = true;

  @override
  void initState() {
    _sc.addListener(offsetListener);
    super.initState();
  }

  offsetListener() {
    setState(() {
      height = _sc.offset;
    });
    if ((maxHeight - _sc.offset) < isShowHeight && !_isShowTitle) {
      _isShowTitle = true;
      _opacity = 1;
      setState(() {});
    } else if ((maxHeight - _sc.offset) > isShowHeight && _isShowTitle) {
      _opacity = 0;
      _isShowTitle = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _sc.removeListener(offsetListener);
    _sc.dispose();
    super.dispose();
  }

  toPlay() {
    isPlay = !isPlay;
    pinHeight = isPlay ? playerHeight : kToolbarHeight;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toPlay();
        },
        child: Text('${!isPlay ? '播放' : '暂停'}'),
      ),
      body: Stack(
        children: <Widget>[
          NestedScrollView(
            controller: _sc,
            headerSliverBuilder: (ctx, b) {
              return [
                SliverPersistentHeader(
                  delegate: CustomSliverPersistentHeader(
                      child: Container(
                        height: maxHeight - height,
                        color: Colors.red,
                      ),
                      maxHeight: maxHeight,
                      minHeigth: playerHeight),
                ),
              ];
            },
            pinnedHeaderSliverHeightBuilder: () {
              return pinHeight;
            },
            innerScrollPositionKeyBuilder: () {
              return Key('tab1');
            },
            body: Column(
              children: <Widget>[
                Expanded(
                    child: NestedScrollViewInnerScrollPositionKeyWidget(
                        Key('tab1'), TabItem('tab1'))),
              ],
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: _opacity,
              child: Container(
                color: Theme.of(context).primaryColor,
                height: maxHeight - height,
              ),
            ),
          ),
          if (_isShowTitle)
            Container(
              height: kToolbarHeight,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    toPlay();
                  },
                  child: Text('立即播放'),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class TabItem extends StatefulWidget {
  final String name;
  TabItem(this.name);
  @override
  _TabItemState createState() => _TabItemState();
}

class _TabItemState extends State<TabItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: List.generate(50, (index) {
        return ListTile(
          title: Text('$index'),
        );
      }),
    );
  }
}