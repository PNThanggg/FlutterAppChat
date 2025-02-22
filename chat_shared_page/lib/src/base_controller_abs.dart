import 'base_controller.dart';

abstract class BaseControllerAbs implements BaseController {
  void setStateLoading();

  void update();

  void setStateSuccess();

  void setStateError();

  void setStateEmpty();
}
