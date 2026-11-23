/// 图内标签的测量、绘制与淡入动画。
part of '../library_floor_map.dart';

TextStyle _floorLabelTextStyle(BuildContext context) {
  final base = Theme.of(context).textTheme.labelSmall;
  return base?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.mapWall,
        height: 1.2,
      ) ??
      const TextStyle(fontSize: 11, fontWeight: FontWeight.w600);
}

/// 标签的屏幕尺寸；放不下时返回 null，由调用方决定隐藏。
({double width, double height})? _measureAreaLabel(
  BuildContext context,
  String value,
  double mapWidth,
  _FloorLabel label,
  double zoomScale,
) {
  final style = _floorLabelTextStyle(context);
  final horizontalPadding = AppSpacing.sm * 2;
  const verticalPadding = 7.0;
  final textScaler = MediaQuery.textScalerOf(context)
      .clamp(maxScaleFactor: _LibraryFloorMapGeometry.labelMaxTextScale);
  final textDirection = Directionality.of(context);

  final natural = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: textDirection,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();
  final naturalWidth = natural.width;
  natural.dispose();

  final designedWidth =
      mapWidth * label.width / _LibraryFloorMapGeometry.designWidth;
  final widthCap = math.min(
    mapWidth * _LibraryFloorMapGeometry.labelMaxWidthFraction,
    math.max(
      designedWidth * _LibraryFloorMapGeometry.labelWidthHeadroom,
      _LibraryFloorMapGeometry.labelMinWidth,
    ),
  );
  final maxWidth = math.min(naturalWidth + horizontalPadding, widthCap);
  final painter = TextPainter(
    text: TextSpan(text: value, style: style),
    textDirection: textDirection,
    textScaler: textScaler,
    maxLines: 2,
  )..layout(maxWidth: maxWidth - horizontalPadding);
  final availableHeight =
      label.maxHeight *
      mapWidth /
      _LibraryFloorMapGeometry.designWidth *
      zoomScale;
  final labelHeight = painter.height + verticalPadding;
  final fits = !painter.didExceedMaxLines && painter.height <= availableHeight;
  if (!fits) {
    painter.dispose();
    return null;
  }
  final result = (width: maxWidth, height: labelHeight);
  painter.dispose();
  return result;
}

/// 在缩放后的地图上按设计坐标布置标签，并按优先级碰撞过滤。
class _FloorLabelLayer extends StatelessWidget {
  const _FloorLabelLayer({
    required this.floor,
    required this.l10n,
    required this.labelScale,
    required this.mapSize,
  });

  final int floor;
  final AppLocalizations l10n;
  final double labelScale;
  final Size mapSize;

  @override
  Widget build(BuildContext context) {
    final labels = _floorLabels(floor);
    final acceptedBounds = <Rect>[];
    final widgets = <Widget>[];
    // 主要空间优先出现；重叠时隐藏，继续放大后相邻名称分开再显示。
    for (final priority in _FloorLabelPriority.values) {
      for (final label in labels.where((item) => item.priority == priority)) {
        final value = _mapAreaLabel(l10n, label.effectiveLabelKey);
        final layout = _measureAreaLabel(
          context,
          value,
          mapSize.width,
          label,
          labelScale,
        );
        if (layout == null) continue;
        final anchor = Offset(
          mapSize.width *
              (label.x - _LibraryFloorMapGeometry.canvasOffsetX) /
              _LibraryFloorMapGeometry.designWidth,
          mapSize.height *
              (label.y - _LibraryFloorMapGeometry.canvasOffsetY) /
              _LibraryFloorMapGeometry.designHeight,
        );
        final bounds = Rect.fromCenter(
          center: anchor * labelScale,
          width: layout.width,
          height: layout.height,
        );
        if (acceptedBounds.any(bounds.overlaps)) continue;
        acceptedBounds.add(bounds);
        widgets.add(
          _FloorAreaLabel(
            key: ValueKey('map-label-${label.id}'),
            value: value,
            left: anchor.dx,
            top: anchor.dy,
            maxWidth: layout.width,
            zoomScale: labelScale,
            isHighlighted: label.alwaysHighlighted,
          ),
        );
      }
    }
    return Stack(children: widgets);
  }
}

/// 图内区域标签：随地图定位，但反向缩放以保持屏幕字号稳定。
class _FloorAreaLabel extends StatelessWidget {
  const _FloorAreaLabel({
    required this.value,
    required this.left,
    required this.top,
    required this.maxWidth,
    required this.zoomScale,
    required this.isHighlighted,
    super.key,
  });

  final String value;
  final double left;
  final double top;
  final double maxWidth;
  final double zoomScale;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final style = _floorLabelTextStyle(
      context,
    ).copyWith(color: isHighlighted ? AppColors.brandRed : AppColors.mapWall);
    return Positioned(
      left: left,
      top: top,
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5),
        child: Transform.scale(
          scale: 1 / zoomScale,
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: _LibraryFloorMapGeometry.labelMaxTextScale,
            child: _LabelReveal(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? AppColors.userBadgeBackground
                        : AppColors.surface,
                    border: Border.all(
                      color: isHighlighted
                          ? AppColors.brandRed
                          : AppColors.mapLine,
                      width: isHighlighted ? 1.4 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mapWall.withValues(alpha: .12),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 3.5,
                    ),
                    child: ExcludeSemantics(
                      child: Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: style,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 标签出现时轻微淡入和放大，避免缩放跨过阈值时突然跳出。
class _LabelReveal extends StatefulWidget {
  const _LabelReveal({required this.child});

  final Widget child;

  @override
  State<_LabelReveal> createState() => _LabelRevealState();
}

class _LabelRevealState extends State<_LabelReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _LibraryFloorMapGeometry.labelRevealDuration,
    )..forward();
    final curve = CurveTween(curve: Curves.easeOutCubic);
    _opacity = _controller.drive(curve);
    _scale = _controller.drive(Tween<double>(begin: .92, end: 1).chain(curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: ScaleTransition(scale: _scale, child: widget.child),
  );
}
