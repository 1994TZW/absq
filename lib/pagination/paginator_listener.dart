import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:absq/widget/callbacks.dart';

typedef ToObj = Function(Map<String, dynamic> data, String id);

/*
 * PaginatorListener load data in page 
 * and listen to document change based on 'update_time' and 'delete_time' fields
 * of the document
 */
class PaginatorListener<T> {
  final log = Logger('PaginatorListener');

  List<String> ids = [];
  List<T> data = [];
  DocumentSnapshot? prev;
  int rowPerLoad = 10;
  bool ended = false;
  bool isLoading = false;
  bool insertNewByListener = false;
  ToObj toObj;
  CallBack? onChange;

  StreamSubscription<QuerySnapshot>? listener;
  Query listeningQuery;
  Query pageQuery;

  PaginatorListener(this.listeningQuery, this.pageQuery, this.toObj,
      {this.onChange, this.rowPerLoad = 10, this.insertNewByListener = true}) {
    refresh();
  }

  Future<bool> refresh() {
    _clearState();
    _initListener();
    return _load();
  }

  void _clearState() {
    prev = null;
    ids = [];
    data = [];
    ended = false;
    isLoading = false;
    listener?.cancel();
    listener = null;
  }

  void close() {
    _clearState();
  }

  final String updateTimeField = 'update_time';
  final String deleteTimeField = 'delete_time';
  final String isDeletedField = 'is_deleted';
  void _initListener() {
    Query _query =
        listeningQuery.orderBy(updateTimeField, descending: true).limit(1);
    _query
        .get(const GetOptions(source: Source.server))
        .then((QuerySnapshot snapshot) {
      int count = snapshot.docs.length;
      int updateTime = 0;
      if (count == 1) {
        updateTime =
            (snapshot.docs[0].data() as Map<String, dynamic>)[updateTimeField];
      }

      Query _queryListener = listeningQuery
          .where(updateTimeField, isGreaterThan: updateTime)
          .orderBy(updateTimeField, descending: true);

      listener =
          _queryListener.snapshots(includeMetadataChanges: true).listen((qs) {
        for (var c in qs.docChanges) {
          switch (c.type) {
            case DocumentChangeType.added:
              _update(c.doc.id, c.doc.data() as Map<String, dynamic>);
              break;
            case DocumentChangeType.modified:
              _update(c.doc.id, c.doc.data() as Map<String, dynamic>);
              break;
            case DocumentChangeType.removed:
              _remove(c.doc.id, c.doc.data() as Map<String, dynamic>);
              break;
            default:
          }
          if (onChange != null) onChange!();
        }
      });
    });
  }

  void _update(String id, Map<String, dynamic> map) {
    T t = toObj(map, id);
    if (ids.contains(id)) {
      var deleted = map[deleteTimeField];
      var isDeleted = map[isDeletedField];
      if ((deleted ?? 0) > 0 || (isDeleted ?? false)) {
        data.removeAt(ids.indexOf(id));
        ids.remove(id);
      } else {
        data.removeAt(ids.indexOf(id));
        data.insert(ids.indexOf(id), t);
      }
    } else if (insertNewByListener) {
      data.insert(0, t);
      ids.insert(0, id);
    }
  }

  void _add(String id, Map<String, dynamic> map) {
    T t = toObj(map, id);
    if (!ids.contains(id)) {
      data.add(t);
      ids.add(id);
    }
  }

  void _remove(String id, Map<String, dynamic> map) {
    if (ids.contains(id)) {
      data.removeAt(ids.indexOf(id));
      ids.remove(id);
    }
  }

  Future<bool> loadMore() {
    return _load();
  }

  Future<bool> _load({CallBack? onStarted, CallBack? onFinished}) async {
    if (ended) return ended;
    Query _query =
        prev != null ? pageQuery.startAfterDocument(prev!) : pageQuery;
    try {
      isLoading = true;
      if (onStarted != null) {
        onStarted();
      }
      if (onChange != null) onChange!();
      await _query
          .where(deleteTimeField, isEqualTo: 0)
          .limit(rowPerLoad)
          .get(const GetOptions(source: Source.server))
          .then((QuerySnapshot snapshot) {
        int count = snapshot.docs.length;
        ended = count < rowPerLoad;
        prev = count > 0 ? snapshot.docs[count - 1] : prev;
        for (var e in snapshot.docs) {
          _add(e.id, e.data() as Map<String, dynamic>);
        }
      });
    } catch (e) {
      log.warning("Error!! $e");
    } finally {
      isLoading = false;
      if (onFinished != null) onFinished();
      if (onChange != null) onChange!();
    }
    return ended;
  }
}
