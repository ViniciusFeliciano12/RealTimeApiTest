import 'package:flutter/widgets.dart';

import 'interfaces/inavigation_service.dart';

class NavigationService extends INavigationService {
  int actualIndex = 0;
  bool visibility = true;
  @override
  void setVisibility(bool visibilityParameter) {
    visibility = visibility;
  }

  @override
  bool getVisibility() {
    return actualIndex == 1 && visibility;
  }

  @override
  void navigateAndReplace(BuildContext context, Widget page, [int? index]) {
    if (index != null && actualIndex == index) {
      return;
    }
    changeIndex(index);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }

  @override
  void navigateWithoutReplace(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
      ),
    );
  }

  @override
  void changeIndex(int? index) {
    if (index != null) {
      actualIndex = index;
    }
  }

  @override
  void backToLastPage(BuildContext context) {
    Navigator.of(context).pop();
  }
}
