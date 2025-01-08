import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AnimationController? animationController;

bool isSaved = false;
List<int> savedList = [];

isSavedItem(int selected, Function() savedItem, Function() unSavedItem) {
  final isExist = savedList.contains(selected);
  if (isExist) {
    savedList.remove(selected);

    //call unsaved item bloc
    unSavedItem();
  } else {
    savedList.add(selected);
    isSaved = !isSaved;

    //call save to items bloc
    savedItem();
  }
}

bool isExist(int selected) {
  final isExist = savedList.contains(selected);
  return isExist;
}
