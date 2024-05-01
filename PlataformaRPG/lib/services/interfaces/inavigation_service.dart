import 'package:flutter/widgets.dart';

abstract class INavigationService {
  void navigateAndReplace(BuildContext context, Widget page, [int? index]);
  void navigateWithoutReplace(BuildContext context, Widget page);
  void backToLastPage(BuildContext context);
  void changeIndex(int? index);
  void setVisibility(bool visibilityParameter);
  bool getVisibility();
}
