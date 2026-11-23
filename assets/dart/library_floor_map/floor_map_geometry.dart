/// 楼层地图共享的设计尺寸、缩放阈值与覆盖控件参数。
part of '../library_floor_map.dart';

abstract final class _LibraryFloorMapGeometry {
  static const designWidth = 1000.0;
  static const designHeight = 1100.0;
  static const aspectRatio = designWidth / designHeight;

  /// 绘制坐标在画布上的左上偏移，用于把楼层内容放在可视区域中间。
  static const canvasOffsetX = 47.0;
  static const canvasOffsetY = 66.5;

  static const minimumScale = 1.0;
  static const maximumScale = 5.0;
  static const boundaryMargin = 32.0;
  static const labelVisibilityScale = 2.2;
  static const labelHideScale = 2.1;
  static const labelScaleStep = .05;
  static const labelMaxWidthFraction = .5;
  static const labelMinWidth = 90.0;
  static const labelWidthHeadroom = 1.5;
  static const labelMaxTextScale = 1.3;
  static const viewTransformedTolerance = .01;
  static const doubleTapScale = 2.6;

  static const zoomAnimationDuration = Duration(milliseconds: 220);
  static const labelRevealDuration = Duration(milliseconds: 180);
  static const overlayFadeDuration = Duration(milliseconds: 160);
  static const overlayInset = 12.0;
  static const hintBottomInset = 16.0;
  static const overlayButtonSize = 48.0;
  static const hintMaxTextScale = 1.3;

  static const pinIconSize = 28.0;
  static const pinVerticalInset = 5.0;

  static double scaleFor(Size viewport) =>
      math.min(viewport.width / designWidth, viewport.height / designHeight);
}

/// 供地图回归测试读取设计画布尺寸，仅供测试把渲染位置换算回设计坐标。
///
/// 数值与生产绘制共用 [_LibraryFloorMapGeometry]，测试不得再抄一份。
@visibleForTesting
Size get libraryFloorMapDesignSize => const Size(
  _LibraryFloorMapGeometry.designWidth,
  _LibraryFloorMapGeometry.designHeight,
);

/// 供地图回归测试读取绘制内容在设计画布上的左上偏移。
@visibleForTesting
Offset get libraryFloorMapCanvasOffset => const Offset(
  _LibraryFloorMapGeometry.canvasOffsetX,
  _LibraryFloorMapGeometry.canvasOffsetY,
);

/// 供地图回归测试读取标签由隐藏变为显示所需的最小缩放倍数。
@visibleForTesting
double get libraryFloorMapLabelVisibilityScale =>
    _LibraryFloorMapGeometry.labelVisibilityScale;

/// 供地图回归测试读取标签保持显示所需的最小缩放倍数（回滞下界）。
@visibleForTesting
double get libraryFloorMapLabelHideScale =>
    _LibraryFloorMapGeometry.labelHideScale;

/// 供地图回归测试读取双击放大的目标缩放倍数。
@visibleForTesting
double get libraryFloorMapDoubleTapScale =>
    _LibraryFloorMapGeometry.doubleTapScale;
