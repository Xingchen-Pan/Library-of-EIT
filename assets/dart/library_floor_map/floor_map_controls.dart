/// 提供楼层地图上的缩放复位按钮和缩放提示。
part of '../library_floor_map.dart';

class _MapResetButton extends StatelessWidget {
  const _MapResetButton({
    required this.visible,
    required this.label,
    required this.onPressed,
  });

  final bool visible;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: _LibraryFloorMapGeometry.overlayFadeDuration,
    child: visible
        ? Material(
            key: const ValueKey('map-reset-view'),
            color: Theme.of(context).colorScheme.surface,
            elevation: 3,
            shadowColor: AppColors.mapWall.withValues(alpha: .3),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: label,
              onPressed: onPressed,
              icon: Icon(Icons.zoom_out_map, size: 20, semanticLabel: label),
              color: Theme.of(context).colorScheme.onSurface,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: _LibraryFloorMapGeometry.overlayButtonSize,
                height: _LibraryFloorMapGeometry.overlayButtonSize,
              ),
            ),
          )
        : const SizedBox.shrink(key: ValueKey('map-reset-hidden')),
  );
}

class _MapZoomHint extends StatelessWidget {
  const _MapZoomHint({required this.visible, required this.label});

  final bool visible;
  final String label;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: _LibraryFloorMapGeometry.overlayFadeDuration,
    child: visible
        ? Semantics(
            key: const ValueKey('map-zoom-hint'),
            label: label,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    child: MediaQuery.withClampedTextScaling(
                      maxScaleFactor: _LibraryFloorMapGeometry.hintMaxTextScale,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.mapSpace.withValues(alpha: .96),
                          border: Border.all(color: AppColors.mapLine),
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
                            vertical: 3,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.zoom_in,
                                size: 14,
                                color: AppColors.muted,
                                semanticLabel: label,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(color: AppColors.muted),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink(key: ValueKey('map-zoom-hint-hidden')),
  );
}
