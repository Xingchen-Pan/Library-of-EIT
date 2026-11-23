/// 绘制图书馆三层的空间边界与设施.
part of '../library_floor_map.dart';

extension _Floor3Drawing on _FloorDrawing {
  void _thirdFloor() {
    _polygon(const [
      Offset(252, 178),
      Offset(841, 178),
      Offset(729, 282),
      Offset(364, 282),
    ], fill: _space);
    _polygon(const [
      Offset(152, 278),
      Offset(252, 178),
      Offset(364, 282),
      Offset(258, 383),
    ], fill: _space);
    _line(const [Offset(108, 440), Offset(201, 440), Offset(258, 383)]);
    _line(const [Offset(729, 282), Offset(834, 383), Offset(941, 278)]);
    _line(const [Offset(834, 383), Offset(891, 440), Offset(985, 440)]);
    _dashed(const [
      Offset(198, 741),
      Offset(198, 830),
      Offset(344, 973),
      Offset(452, 973),
    ]);
    _dashed(const [
      Offset(892, 741),
      Offset(892, 830),
      Offset(746, 973),
      Offset(641, 973),
    ]);
    _shelf(_FloorMapAnchors.feature(3, 'books_ab'), math.pi / 4);
    _shelf(_FloorMapAnchors.feature(3, 'books_bh'), -math.pi / 4);
    for (final key in ['soundproof_booth', 'soundproof_booth_mirror']) {
      final booth = _FloorMapAnchors.feature(3, key);
      _booth(booth);
      _booth(Offset(booth.dx, booth.dy + 42));
    }
    final librarian = _FloorMapAnchors.feature(3, 'librarian_picks');
    canvas.drawCircle(
      librarian,
      42,
      Paint()..color = AppColors.brandYellow.withValues(alpha: .25),
    );
    canvas.drawCircle(librarian, 42, _collection);
    // CPC 两段书架围绕锚点排布，锚点同时供标签定位和测试读取。
    final cpc = _FloorMapAnchors.feature(3, 'cpc_special_collection');
    for (final dx in [-61.0, 13.0]) {
      final bounds = Rect.fromLTWH(cpc.dx + dx, cpc.dy, 48, 20);
      canvas.drawRect(
        bounds,
        Paint()..color = AppColors.brandYellow.withValues(alpha: .25),
      );
      canvas.drawRect(bounds, _collection);
    }
    _icon(
      Icons.print_outlined,
      const Offset(554, 826),
      color: AppColors.warning,
    );
    _text(
      jiangWeiyueLabel,
      const Offset(646, 872),
      fontSize: 17,
      maxWidth: 170,
      maxLines: 2,
    );
  }
}
