/// 提供楼层地图共用的 Canvas 几何和绘制工具。
part of '../library_floor_map.dart';

/// 以参考平面图的空间边界重绘；设施符号是位置说明，不表达设备在线状态。
class _FloorPainter extends CustomPainter {
  const _FloorPainter(this.floor, this.jiangWeiyueLabel);

  final int floor;
  final String jiangWeiyueLabel;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(_LibraryFloorMapGeometry.scaleFor(size));
    canvas.translate(
      -_LibraryFloorMapGeometry.canvasOffsetX,
      -_LibraryFloorMapGeometry.canvasOffsetY,
    );
    final drawing = _FloorDrawing(canvas, floor, jiangWeiyueLabel);
    drawing.draw();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _FloorPainter oldDelegate) =>
      oldDelegate.floor != floor ||
      oldDelegate.jiangWeiyueLabel != jiangWeiyueLabel;
}

/// 将建筑轮廓、空间边界与设施分别绘制在相同的逻辑平面上。
class _FloorDrawing {
  _FloorDrawing(this.canvas, this.floor, this.jiangWeiyueLabel);

  final Canvas canvas;
  final int floor;
  final String jiangWeiyueLabel;
  final Paint _wall = Paint()
    ..color = AppColors.mapWall
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4
    ..strokeJoin = StrokeJoin.round;
  final Paint _space = Paint()..color = AppColors.mapSpace;
  final Paint _paper = Paint()..color = AppColors.surface;
  final Paint _collection = Paint()
    ..color = AppColors.brandYellow
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  static const _center = Offset(548, 616);

  void draw() {
    _outerBoundary();
    if (floor == 2) {
      _secondFloor();
    } else {
      _upperFloorCore();
      _seminarRooms();
      if (floor == 3) {
        _thirdFloor();
      } else {
        _fifthFloor();
      }
    }
    _elevators();
    _washroomsAndPantry();
  }

  void _outerBoundary() {
    final points = floor == 5
        ? const [
            Offset(108, 423),
            Offset(352, 178),
            Offset(742, 178),
            Offset(984, 423),
            Offset(984, 810),
            Offset(739, 1055),
            Offset(352, 1055),
            Offset(108, 810),
          ]
        : const [
            Offset(108, 323),
            Offset(252, 178),
            Offset(841, 178),
            Offset(985, 323),
            Offset(985, 910),
            Offset(841, 1055),
            Offset(252, 1055),
            Offset(108, 910),
          ];
    _polygon(points, fill: _paper);
    if (floor == 2) {
      // 南门是外墙上唯一经本层原图标明的公共入口。
      canvas.drawLine(
        const Offset(484, 1055),
        const Offset(609, 1055),
        Paint()
          ..color = AppColors.surface
          ..strokeWidth = 7,
      );
      _icon(
        Icons.south,
        _FloorMapAnchors.feature(2, 'south_entrance'),
        color: AppColors.success,
      );
    }
  }

  void _northwestCore() {
    final path = Path()
      ..moveTo(275, 589)
      ..lineTo(275, 463)
      ..lineTo(398, 345)
      ..lineTo(507, 345)
      ..lineTo(507, 436)
      ..arcTo(
        Rect.fromCircle(center: _center, radius: 185),
        -1.794,
        -1.202,
        false,
      )
      ..close();
    _path(path, fill: _space);
  }

  void _northeastCore() {
    final upper = Path()
      ..moveTo(583, 345)
      ..lineTo(694, 345)
      ..lineTo(734, 384)
      ..lineTo(654, 465)
      ..arcTo(
        Rect.fromCircle(center: _center, radius: 185),
        -.958,
        -.423,
        false,
      )
      ..close();
    _path(upper, fill: _space);
    final path = Path()
      ..moveTo(754, 402)
      ..lineTo(816, 462)
      ..lineTo(816, 589)
      ..lineTo(723, 589)
      ..arcTo(
        Rect.fromCircle(center: _center, radius: 177),
        -.153,
        -.704,
        false,
      )
      ..lineTo(754, 402)
      ..close();
    _path(path, fill: _space);
  }

  void _upperFloorCore() {
    _northwestCore();
    _northeastCore();
    final southwest = Path()
      ..moveTo(275, 644)
      ..lineTo(370, 644)
      ..arcTo(
        Rect.fromCircle(center: _center, radius: 180),
        2.985,
        -1.192,
        false,
      )
      ..lineTo(507, 887)
      ..lineTo(398, 887)
      ..lineTo(275, 770)
      ..close();
    final southeast = Path()
      ..moveTo(723, 644)
      ..lineTo(816, 644)
      ..lineTo(816, 770)
      ..lineTo(692, 887)
      ..lineTo(583, 887)
      ..lineTo(583, 791)
      ..arcTo(
        Rect.fromCircle(center: _center, radius: 180),
        1.375,
        -1.219,
        false,
      )
      ..close();
    _path(southwest, fill: _space);
    _path(southeast, fill: _space);
    final leftZone = floor == 3 ? 'pc_monitor_area' : 'computer_area';
    for (final key in [leftZone, 'computer_monitor_area']) {
      _icon(
        Icons.desktop_windows_outlined,
        _FloorMapAnchors.feature(floor, key),
        color: AppColors.warning,
      );
    }
    _arc(180, .156, 1.219, _collection);
    _arc(180, 1.793, 1.192, _collection);
    _arc(185, -2.996, 1.202, _collection);
    _arc(185, -1.381, .423, _collection);
    _arc(177, -.857, .704, _collection);
    canvas.drawCircle(_center, 130, _paper);
    canvas.drawCircle(_center, 130, _wall);
    for (final (position, angle) in [
      (const Offset(356, 418), -math.pi / 4),
      (const Offset(791, 489), math.pi / 2),
      (const Offset(353, 808), -3 * math.pi / 4),
      (const Offset(739, 808), 3 * math.pi / 4),
    ]) {
      _exit(position, angle);
    }
  }

  void _seminarRooms() {
    // 两排门洞分别朝向中间通道：上排短底墙，下排短顶墙。
    for (final (west, east, y) in [
      (134.0, 918.0, 540.0),
      (134.0, 918.0, 637.0),
    ]) {
      final upper = y == 540;
      final fullY = upper ? y : y + 55;
      final doorY = upper ? y + 55 : y;
      _line([Offset(108, fullY), Offset(241, fullY)]);
      _line([Offset(west, doorY), Offset(west + 41, doorY)]);
      _line([Offset(155, y), Offset(155, y + 55)]);
      _line([
        Offset(200, upper ? y : y + 5),
        Offset(200, upper ? y + 50 : y + 55),
      ]);
      _line([Offset(853, fullY), Offset(985, fullY)]);
      _line([Offset(east, doorY), Offset(east + 42, doorY)]);
      _line([Offset(939, y), Offset(939, y + 55)]);
      _line([
        Offset(895, upper ? y : y + 5),
        Offset(895, upper ? y + 50 : y + 55),
      ]);
    }
    final base = floor * 100;
    for (final (number, x, y) in [
      (base + 8, 132.0, 568.0),
      (base + 9, 177.0, 568.0),
      (base + 10, 132.0, 665.0),
      (base + 11, 177.0, 665.0),
      (base + 4, 917.0, 568.0),
      (base + 5, 962.0, 568.0),
      (base + 6, 917.0, 665.0),
      (base + 7, 962.0, 665.0),
    ]) {
      _text('$number', Offset(x, y), fontSize: 20);
    }
    _text('${base + 12}', const Offset(477, 871), fontSize: 22);
    if (floor == 5) {
      _text('501', const Offset(421, 365), fontSize: 22);
      _text('502', const Offset(477, 365), fontSize: 22);
      _text('503', const Offset(612, 365), fontSize: 22);
      _text('513', const Offset(612, 871), fontSize: 22);
    }
  }

  void _readingRings() {
    final corridors = Path()
      ..addRect(const Rect.fromLTWH(537, 450, 21, 332))
      ..addRect(const Rect.fromLTWH(382, 606, 332, 21));
    for (final (outer, inner) in [(140.0, 112.0), (84.0, 56.0)]) {
      final ring = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: _center, radius: outer)),
        Path()..addOval(Rect.fromCircle(center: _center, radius: inner)),
      );
      _path(
        Path.combine(PathOperation.difference, ring, corridors),
        fill: _space,
      );
    }
  }

  void _elevators() {
    for (final (x, y) in [
      (432.0, 434.0),
      (344.0, 559.0),
      (745.0, 559.0),
      (300.0, 672.0),
      (345.0, 672.0),
      (742.0, 672.0),
      (787.0, 672.0),
      (719.0, 733.0),
    ]) {
      canvas.drawCircle(Offset(x, y), 19, Paint()..color = AppColors.mapWall);
      _icon(Icons.elevator, Offset(x, y), color: AppColors.surface, size: 26);
    }
  }

  void _washroomsAndPantry() {
    _icon(Icons.wc, const Offset(702, 382));
    _icon(Icons.wc, const Offset(754, 435));
    _icon(
      Icons.local_cafe_outlined,
      floor == 2 ? const Offset(716, 477) : const Offset(670, 361),
    );
  }

  void _booth(Offset center) {
    final bounds = Rect.fromCenter(center: center, width: 26, height: 35);
    canvas.drawRect(bounds, _paper);
    canvas.drawRect(bounds, _collection);
    canvas.drawRect(
      bounds.deflate(4),
      Paint()
        ..color = AppColors.mapWall
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
    canvas.drawCircle(
      center + const Offset(7, 0),
      1.5,
      Paint()..color = AppColors.mapWall,
    );
  }

  void _shelf(Offset center, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    final shelfPaint = Paint()
      ..color = AppColors.brandYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(const Rect.fromLTWH(-20, -17, 40, 34), shelfPaint);
    canvas.drawLine(const Offset(-20, 0), const Offset(20, 0), shelfPaint);
    for (var column = 0; column < 6; column++) {
      final x = -16 + column * 6.0;
      canvas.drawLine(Offset(x, -17), Offset(x, -3), shelfPaint);
      canvas.drawLine(Offset(x, 3), Offset(x, 17), shelfPaint);
    }
    canvas.restore();
  }

  void _exit(Offset center, double angle) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawRect(
      const Rect.fromLTWH(-15, -15, 30, 30),
      Paint()..color = AppColors.success,
    );
    final arrow = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawLine(const Offset(0, -10), const Offset(0, 10), arrow);
    _line(const [Offset(-7, 3), Offset(0, 10), Offset(7, 3)], paint: arrow);
    canvas.restore();
  }

  void _dashed(List<Offset> points) {
    if (points.isEmpty) return;
    final firstPoint = points[0];
    final path = Path()..moveTo(firstPoint.dx, firstPoint.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    for (final metric in path.computeMetrics()) {
      for (var distance = 0.0; distance < metric.length; distance += 17) {
        canvas.drawPath(
          metric.extractPath(distance, math.min(distance + 9, metric.length)),
          _collection,
        );
      }
    }
  }

  void _icon(
    IconData icon,
    Offset center, {
    Color color = AppColors.mapWall,
    double size = 37,
  }) {
    final text = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    text.dispose();
  }

  void _text(
    String value,
    Offset center, {
    double fontSize = 23,
    Color color = AppColors.mapWall,
    double? maxWidth,
    int maxLines = 1,
  }) {
    final text = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      textAlign: maxWidth == null ? TextAlign.start : TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth ?? double.infinity);
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2));
    text.dispose();
  }

  void _arc(double radius, double start, double sweep, Paint paint) =>
      canvas.drawArc(
        Rect.fromCircle(center: _center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );

  void _polygon(List<Offset> points, {Paint? fill}) {
    if (points.isEmpty) return;
    final firstPoint = points[0];
    final path = Path()..moveTo(firstPoint.dx, firstPoint.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    _path(path..close(), fill: fill);
  }

  void _path(Path path, {Paint? fill}) {
    if (fill != null) {
      canvas.drawPath(path, fill);
    }
    canvas.drawPath(path, _wall);
  }

  void _line(List<Offset> points, {Paint? paint}) {
    if (points.isEmpty) return;
    final firstPoint = points[0];
    final path = Path()..moveTo(firstPoint.dx, firstPoint.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paint ?? _wall);
  }
}
