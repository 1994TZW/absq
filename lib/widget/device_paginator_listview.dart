import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:absq/pagination/paginator_listener.dart';

typedef RowBuilder = Widget Function(dynamic);
typedef OnScroll = void Function(bool down);
typedef OnRemove(dynamic t);

class DevicePaginatorListView<Device> extends StatelessWidget {
  final PaginatorListener<Device> paginatorListener;
  final RowBuilder rowBuilder;
  final OnScroll? onScroll;
  final ScrollController _scrollController;
  final Color color;
  final OnRemove? onRemove;

  DevicePaginatorListView(
      {Key? key,
      required this.paginatorListener,
      required this.rowBuilder,
      this.onScroll,
      this.color = Colors.blueAccent,
      this.onRemove})
      : _scrollController = ScrollController(),
        super(key: key) {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        paginatorListener.loadMore();
      }
      if (onScroll != null) {
        var down = _scrollController.position.userScrollDirection ==
            ScrollDirection.forward;
        onScroll!(down);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool ended = paginatorListener.ended;
    int count = paginatorListener.data.length;

    if (ended) count++;

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return paginatorListener.refresh();
            },
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: count,
                itemBuilder: (BuildContext context, int index) {
                  if (ended && index == count - 1) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text("No more data")),
                    );
                  }
                  Device device = paginatorListener.data[index];
                  return Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: rowBuilder(device),
                    secondaryActions: onRemove != null
                        ? <Widget>[
                            onRemove == null
                                ? Container()
                                : IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () {
                                      if (onRemove != null) onRemove!(device);
                                    },
                                  ),
                          ]
                        : null,
                  );
                }),
          ),
        ),
        paginatorListener.isLoading ? _loadingRow() : Container()
      ],
    );
  }

  Widget _loadingRow() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(color)),
              Text(
                "Loading...",
                style: TextStyle(color: color),
              )
            ],
          ),
        ],
      ),
    );
  }
}
