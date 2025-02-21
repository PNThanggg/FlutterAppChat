import '../states.dart';

abstract class BaseControllerAbs implements SBaseController {
  void setStateLoading();

  void update();

  void setStateSuccess();

  void setStateError();

  void setStateEmpty();
}
