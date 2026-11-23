/// 绘制图书馆五层的空间边界与设施.
part of '../library_floor_map.dart';

extension _Floor5Drawing on _FloorDrawing {
  void _fifthFloor() {
    _line(const [
      Offset(279, 986),
      Offset(352, 948),
      Offset(739, 948),
      Offset(808, 986),
    ]);
    _dashed(const [Offset(377, 253), Offset(197, 425), Offset(197, 516)]);
    _dashed(const [Offset(197, 720), Offset(197, 810), Offset(352, 948)]);
    _dashed(const [Offset(718, 253), Offset(897, 425), Offset(897, 516)]);
    _dashed(const [Offset(897, 720), Offset(897, 810), Offset(741, 948)]);
    for (final (key, angle) in [
      ('books_jk', math.pi / 4),
      ('books_ko', -math.pi / 4),
      ('books_tz', -math.pi / 4),
      ('books_ot', math.pi / 4),
    ]) {
      _shelf(_FloorMapAnchors.feature(5, key), angle);
    }
    for (final key in ['soundproof_booth', 'soundproof_booth_mirror']) {
      final booth = _FloorMapAnchors.feature(5, key);
      _booth(booth);
      _booth(Offset(booth.dx, booth.dy + 97));
    }
    final fiction = Paint()
      ..color = AppColors.brandYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(
      Rect.fromCircle(
        center: _FloorMapAnchors.feature(5, 'english_fiction'),
        radius: 24,
      ),
      .9,
      math.pi * 1.5,
      false,
      fiction,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: _FloorMapAnchors.feature(5, 'course_reserves'),
        radius: 24,
      ),
      -2.3,
      math.pi * 1.5,
      false,
      fiction,
    );
    _icon(
      Icons.print_outlined,
      const Offset(298, 617),
      color: AppColors.warning,
    );
    _icon(
      Icons.menu_book_outlined,
      const Offset(780, 617),
      color: AppColors.warning,
    );
  }
}
