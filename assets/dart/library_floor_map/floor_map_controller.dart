/// 管理地图缩放、平移、标签显隐阈值与视图动画。
part of '../library_floor_map.dart';

class _FloorMapViewController extends ChangeNotifier {
  _FloorMapViewController({required TickerProvider vsync})
    : _animationController = AnimationController(
        vsync: vsync,
        duration: _LibraryFloorMapGeometry.zoomAnimationDuration,
      ) {
    _animationController.addListener(_handleAnimationTick);
    transformationController.addListener(_handleTransformChanged);
  }

  final transformationController = TransformationController();
  final AnimationController _animationController;
  Animation<Matrix4>? _animation;
  Offset _doubleTapPosition = Offset.zero;
  bool _showLabels = false;
  bool _isViewTransformed = false;
  double _labelScale = 1;

  bool get showLabels => _showLabels;
  bool get isViewTransformed => _isViewTransformed;
  double get labelScale => _labelScale;

  void handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
  }

  void handleDoubleTap(Size? viewport) {
    if (_isViewTransformed) {
      resetView();
      return;
    }
    if (viewport == null || viewport.isEmpty) return;
    const targetScale = _LibraryFloorMapGeometry.doubleTapScale;
    final dx = (_doubleTapPosition.dx * (1 - targetScale)).clamp(
      viewport.width * (1 - targetScale),
      0.0,
    );
    final dy = (_doubleTapPosition.dy * (1 - targetScale)).clamp(
      viewport.height * (1 - targetScale),
      0.0,
    );
    _animateViewTo(
      Matrix4.identity()
        ..translateByDouble(dx, dy, 0, 1)
        ..scaleByDouble(targetScale, targetScale, targetScale, 1),
    );
  }

  void resetView() => _animateViewTo(Matrix4.identity());

  void resetForFloor() {
    _animationController.stop();
    _animation = null;
    transformationController.value = Matrix4.identity();
  }

  void stopAnimation() {
    if (!_animationController.isAnimating) return;
    _animationController.stop();
    _animation = null;
  }

  void _handleAnimationTick() {
    final animation = _animation;
    if (animation == null) return;
    transformationController.value = animation.value;
  }

  /// 只在标签显示阈值、视图变换状态或标签缩放比例变化时通知重建。
  void _handleTransformChanged() {
    final matrix = transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();
    final showLabels = _showLabels
        ? scale >= _LibraryFloorMapGeometry.labelHideScale
        : scale >= _LibraryFloorMapGeometry.labelVisibilityScale;
    final isViewTransformed =
        (scale - 1).abs() > _LibraryFloorMapGeometry.viewTransformedTolerance ||
        translation.x.abs() >
            _LibraryFloorMapGeometry.viewTransformedTolerance ||
        translation.y.abs() > _LibraryFloorMapGeometry.viewTransformedTolerance;
    final labelScaleChanged =
        showLabels &&
        (_labelScale - scale).abs() >= _LibraryFloorMapGeometry.labelScaleStep;
    if (showLabels == _showLabels &&
        isViewTransformed == _isViewTransformed &&
        !labelScaleChanged) {
      return;
    }
    _showLabels = showLabels;
    _isViewTransformed = isViewTransformed;
    _labelScale = showLabels ? scale : 1;
    notifyListeners();
  }

  void _animateViewTo(Matrix4 target) {
    stopAnimation();
    _animation = _animationController.drive(
      Matrix4Tween(
        begin: transformationController.value.clone(),
        end: target,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
    );
    unawaited(_animationController.forward(from: 0));
  }

  @override
  void dispose() {
    transformationController.removeListener(_handleTransformChanged);
    transformationController.dispose();
    _animationController.removeListener(_handleAnimationTick);
    _animationController.dispose();
    super.dispose();
  }
}
