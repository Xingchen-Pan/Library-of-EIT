/// 绘制可缩放、可叠加位置标记的楼层示意。
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:library_app/features/catalog/domain/book.dart';
import 'package:library_app/features/library/presentation/library_labels.dart';
import 'package:library_app/gen/l10n/app_localizations.dart';
import 'package:library_app/shared/ui/app_theme.dart';
import 'package:material_ui/material_ui.dart';

part 'library_floor_map/floor_map_anchors.dart';
part 'library_floor_map/floor_map_drawing.dart';
part 'library_floor_map/floor_map_geometry.dart';
part 'library_floor_map/floor_map_label_data.dart';
part 'library_floor_map/floor_map_label_view.dart';
part 'library_floor_map/floor_map_controller.dart';
part 'library_floor_map/floor_map_controls.dart';
part 'library_floor_map/floor_2_drawing.dart';
part 'library_floor_map/floor_3_drawing.dart';
part 'library_floor_map/floor_5_drawing.dart';

/// 应用当前提供平面图的楼层。
const supportedLibraryFloors = <int>[2, 3, 5];

/// 指定楼层是否有可展示的平面图。
bool hasLibraryFloorPlan(int floor) => supportedLibraryFloors.contains(floor);

class LibraryFloorMap extends StatefulWidget {
  const LibraryFloorMap({
    required this.floor,
    this.shelfMarker,
    this.shelfPosition,
    super.key,
  });

  final int floor;
  final String? shelfMarker;
  final ShelfMapPosition? shelfPosition;

  @override
  State<LibraryFloorMap> createState() => _LibraryFloorMapState();
}

class _LibraryFloorMapState extends State<LibraryFloorMap>
    with SingleTickerProviderStateMixin {
  late final _FloorMapViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _FloorMapViewController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant LibraryFloorMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.floor != widget.floor) _controller.resetForFloor();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap() => _controller.handleDoubleTap(context.size);

  @override
  Widget build(BuildContext context) {
    final floor = widget.floor;
    final l10n = AppLocalizations.of(context);
    if (!hasLibraryFloorPlan(floor)) {
      return _buildUnsupportedFloor(l10n, floor);
    }
    return AspectRatio(
      aspectRatio: _LibraryFloorMapGeometry.aspectRatio,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => Stack(
          fit: StackFit.expand,
          children: [
            Semantics(
              label: _mapSemanticsLabel(floor, l10n),
              child: GestureDetector(
                onDoubleTapDown: _controller.handleDoubleTapDown,
                onDoubleTap: _handleDoubleTap,
                child: InteractiveViewer(
                  transformationController:
                      _controller.transformationController,
                  minScale: _LibraryFloorMapGeometry.minimumScale,
                  maxScale: _LibraryFloorMapGeometry.maximumScale,
                  boundaryMargin: const EdgeInsets.all(
                    _LibraryFloorMapGeometry.boundaryMargin,
                  ),
                  onInteractionStart: (_) => _controller.stopAnimation(),
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        _buildMapContent(context, constraints, floor, l10n),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: _LibraryFloorMapGeometry.overlayInset,
              end: _LibraryFloorMapGeometry.overlayInset,
              child: _MapResetButton(
                visible: _controller.isViewTransformed,
                label: l10n.mapResetView,
                onPressed: _controller.resetView,
              ),
            ),
            PositionedDirectional(
              bottom: _LibraryFloorMapGeometry.hintBottomInset,
              start: 0,
              end: 0,
              child: _MapZoomHint(
                visible: !_controller.showLabels,
                label: l10n.mapZoomHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedFloor(AppLocalizations l10n, int floor) => Semantics(
    label: '${l10n.floorLabelFormat(floor)} ${l10n.mapDisclaimer}',
    child: AspectRatio(
      aspectRatio: _LibraryFloorMapGeometry.aspectRatio,
      child: Center(
        child: Text(
          l10n.floorPlanUnavailable,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );

  String _mapSemanticsLabel(int floor, AppLocalizations l10n) {
    final areas = {
      for (final label in _floorLabels(floor))
        _mapAreaLabel(l10n, label.effectiveLabelKey),
      if (floor == 3) l10n.mapJiangWeiyue,
    };
    return '${l10n.floorLabelFormat(floor)} ${l10n.mapDisclaimer}, '
        '${areas.join(', ')}';
  }

  Widget _buildMapContent(
    BuildContext context,
    BoxConstraints constraints,
    int floor,
    AppLocalizations l10n,
  ) => SizedBox(
    width: constraints.maxWidth,
    height: constraints.maxHeight,
    child: Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _FloorPainter(floor, l10n.mapJiangWeiyue),
          ),
        ),
        if (_controller.showLabels)
          Positioned.fill(
            child: _FloorLabelLayer(
              floor: floor,
              l10n: l10n,
              labelScale: _controller.labelScale,
              mapSize: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
        if (widget.shelfMarker != null &&
            widget.shelfPosition?.isNormalized == true)
          Positioned(
            // 按标记自身尺寸对齐底部中心，保证不同语言和字号下尖端仍落在书架锚点。
            left: constraints.maxWidth * widget.shelfPosition!.x,
            top: constraints.maxHeight * widget.shelfPosition!.y,
            child: FractionalTranslation(
              translation: const Offset(-.5, -1),
              child: _ShelfPin(
                label: widget.shelfMarker!,
                semanticLabel: l10n.shelfMarker,
              ),
            ),
          ),
      ],
    ),
  );
}

class _ShelfPin extends StatelessWidget {
  const _ShelfPin({required this.label, required this.semanticLabel});

  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.brandRed,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: _LibraryFloorMapGeometry.pinVerticalInset,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // ignore: saropa_lints/require_minimum_contrast -- 白色文字与品牌红对比度约为 9:1。
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
      Icon(
        Icons.location_on,
        color: AppColors.brandRed,
        size: _LibraryFloorMapGeometry.pinIconSize,
        semanticLabel: semanticLabel,
      ),
    ],
  );
}
