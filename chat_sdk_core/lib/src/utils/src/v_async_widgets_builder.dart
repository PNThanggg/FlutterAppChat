import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

// switch between different widgets with animation
// depending on api call status
class VAsyncWidgetsBuilder extends StatelessWidget {
  final ChatLoadingState loadingState;
  final Widget Function()? loadingWidget;
  final Widget Function() successWidget;
  final Widget Function()? errorWidget;
  final Widget Function()? emptyWidget;
  final VoidCallback? onRefresh;

  const VAsyncWidgetsBuilder({
    super.key,
    required this.loadingState,
    this.loadingWidget,
    this.errorWidget,
    this.onRefresh,
    required this.successWidget,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (loadingState == ChatLoadingState.success) {
      return successWidget();
    } else if (loadingState == ChatLoadingState.error) {
      if (errorWidget == null) {
        return GestureDetector(
          onTap: onRefresh,
          child: const Center(
            child: Icon(
              Icons.refresh,
              size: 50,
              color: Colors.red,
            ),
          ),
        );
      } else {
        return errorWidget!();
      }
    } else if (loadingState == ChatLoadingState.loading) {
      if (loadingWidget == null) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else {
        return loadingWidget!();
      }
    } else if (loadingState == ChatLoadingState.empty) {
      if (emptyWidget == null) {
        return const SizedBox();
      } else {
        return emptyWidget!();
      }
    } else {
      return successWidget();
    }
  }
}
