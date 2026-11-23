/// 绘制图书馆二层的空间边界与设施.
part of '../library_floor_map.dart';

extension _Floor2Drawing on _FloorDrawing {
  void _secondFloor() {
    _northwestCore();
    _northeastCore();
    final southwest = Path()
      ..moveTo(108, 807)
      ..lineTo(275, 807)
      ..lineTo(275, 644)
      ..lineTo(370, 644)
      ..arcTo(
        Rect.fromCircle(center: _FloorDrawing._center, radius: 180),
        2.985,
        -1.052,
        false,
      )
      ..lineTo(484, 886)
      ..lineTo(108, 886)
      ..close();
    final southeast = Path()
      ..moveTo(723, 644)
      ..lineTo(816, 644)
      ..lineTo(816, 807)
      ..lineTo(985, 807)
      ..lineTo(985, 886)
      ..lineTo(608, 886)
      ..lineTo(608, 786)
      ..arcTo(
        Rect.fromCircle(center: _FloorDrawing._center, radius: 180),
        1.231,
        -1.075,
        false,
      )
      ..close();
    _path(southwest, fill: _space);
    _path(southeast, fill: _space);
    _arc(180, .156, 1.075, _collection);
    _arc(180, 1.933, 1.052, _collection);
    _readingRings();
    for (final x in [243.0, 777.0]) {
      _polygon([
        Offset(x, 941),
        Offset(x + 87, 941),
        Offset(x + 87, 971),
        Offset(x, 971),
      ], fill: _space);
    }
    _icon(
      Icons.local_library_outlined,
      _FloorMapAnchors.feature(2, 'newspapers_magazines'),
      color: AppColors.warning,
    );
    _icon(
      Icons.local_library_outlined,
      _FloorMapAnchors.feature(2, 'newspapers_magazines_mirror'),
      color: AppColors.warning,
    );
    _icon(
      Icons.weekend_outlined,
      _FloorMapAnchors.feature(2, 'library_lounge_mirror'),
      color: AppColors.warning,
    );
    _icon(
      Icons.weekend_outlined,
      _FloorMapAnchors.feature(2, 'library_lounge'),
      color: AppColors.warning,
    );
    _icon(
      Icons.person_outline,
      _FloorMapAnchors.feature(2, 'security_desk'),
      color: AppColors.warning,
    );
    _icon(
      Icons.menu_book_outlined,
      _FloorMapAnchors.feature(2, 'self_service_circulation'),
      color: AppColors.warning,
    );
    _icon(
      Icons.people_outline,
      _FloorMapAnchors.feature(2, 'service_desk'),
      color: AppColors.warning,
    );
    _icon(
      Icons.print_outlined,
      _FloorMapAnchors.feature(2, 'self_service_printing'),
      color: AppColors.warning,
    );
    _icon(
      Icons.desktop_windows_outlined,
      _FloorMapAnchors.feature(2, 'self_service_reference_desk'),
      color: AppColors.warning,
    );
  }
}
