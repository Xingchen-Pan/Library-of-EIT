/// 图内标签的数据定义与本地化文案。
part of '../library_floor_map.dart';

/// 图内标签的显示优先级：主要空间先于设施/馆藏说明参与碰撞判断。
enum _FloorLabelPriority { primary, secondary }

/// 图内标签的定义；[id] 唯一，[labelKey] 相同的条目共用同一文案（镜像标签）。
class _FloorLabel {
  const _FloorLabel(
    this.id,
    this.x,
    this.y,
    this.width,
    this.maxHeight, {
    this.labelKey,
    this.priority = _FloorLabelPriority.secondary,
    this.alwaysHighlighted = false,
  });

  final String id;

  /// 用于解析文案与语义的空间键；为空时使用 [id]。
  final String? labelKey;
  final double x;
  final double y;

  /// 标签可用的最大宽度与高度，单位为设计坐标。
  final double width;
  final double maxHeight;
  final _FloorLabelPriority priority;
  final bool alwaysHighlighted;

  String get effectiveLabelKey => labelKey ?? id;
}

/// 区域名直接标在地图上，缩放到可读尺寸后显示。
List<_FloorLabel> _floorLabels(int floor) => switch (floor) {
  2 => _secondFloorLabels,
  3 => _thirdFloorLabels,
  5 => _fifthFloorLabels,
  _ => const [],
};

/// 用设施锚点 + 标签偏移生成标签，避免坐标在数据与测试里重复。
_FloorLabel _anchoredLabel(
  int floor,
  String id,
  double width,
  double maxHeight, {
  String? labelKey,
  _FloorLabelPriority priority = _FloorLabelPriority.secondary,
  bool alwaysHighlighted = false,
}) {
  final anchor = _FloorMapAnchors.label(floor, id);
  return _FloorLabel(
    id,
    anchor.dx,
    anchor.dy,
    width,
    maxHeight,
    labelKey: labelKey,
    priority: priority,
    alwaysHighlighted: alwaysHighlighted,
  );
}

final _secondFloorLabels = <_FloorLabel>[
  _FloorLabel(
    'exhibition_area',
    548,
    263,
    260,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _FloorLabel(
    'study_hall',
    548,
    616,
    230,
    52,
    priority: _FloorLabelPriority.primary,
    alwaysHighlighted: true,
  ),
  _anchoredLabel(2, 'service_desk', 210, 52),
  _anchoredLabel(2, 'self_service_reference_desk', 250, 44),
  _anchoredLabel(2, 'self_service_circulation', 160, 44),
  _anchoredLabel(
    2,
    'south_entrance',
    220,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _FloorLabel('complete_collection_paintings', 360, 764, 260, 52),
  _anchoredLabel(2, 'newspapers_magazines', 190, 42),
  _anchoredLabel(
    2,
    'newspapers_magazines_mirror',
    190,
    42,
    labelKey: 'newspapers_magazines',
  ),
  _anchoredLabel(2, 'library_lounge', 150, 42),
  _anchoredLabel(
    2,
    'library_lounge_mirror',
    150,
    42,
    labelKey: 'library_lounge',
  ),
  _anchoredLabel(2, 'security_desk', 140, 42),
  _anchoredLabel(2, 'self_service_printing', 190, 42),
];

final _thirdFloorLabels = <_FloorLabel>[
  _FloorLabel(
    'bozhi_collection',
    548,
    230,
    370,
    52,
    priority: _FloorLabelPriority.primary,
    alwaysHighlighted: true,
  ),
  _FloorLabel(
    'xinlong_classroom',
    257,
    280,
    230,
    52,
    priority: _FloorLabelPriority.primary,
    alwaysHighlighted: true,
  ),
  _anchoredLabel(
    3,
    'pc_monitor_area',
    200,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _anchoredLabel(
    3,
    'computer_monitor_area',
    200,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _FloorLabel(
    'seminar_rooms_304_312',
    154,
    617,
    280,
    42,
    priority: _FloorLabelPriority.primary,
  ),
  _anchoredLabel(3, 'soundproof_booth', 190, 30),
  _anchoredLabel(
    3,
    'soundproof_booth_mirror',
    190,
    30,
    labelKey: 'soundproof_booth',
  ),
  _anchoredLabel(3, 'books_ab', 260, 30),
  _anchoredLabel(3, 'books_bh', 260, 30),
  _FloorLabel('books_i_oxford', 750, 617, 220, 44),
  _anchoredLabel(3, 'librarian_picks', 200, 42, alwaysHighlighted: true),
  _anchoredLabel(3, 'cpc_special_collection', 240, 42, alwaysHighlighted: true),
  _FloorLabel(
    'seminar_rooms_304_312_mirror',
    942,
    617,
    280,
    42,
    labelKey: 'seminar_rooms_304_312',
    priority: _FloorLabelPriority.primary,
  ),
];

final _fifthFloorLabels = <_FloorLabel>[
  _anchoredLabel(
    5,
    'computer_area',
    180,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _anchoredLabel(
    5,
    'computer_monitor_area',
    180,
    52,
    priority: _FloorLabelPriority.primary,
  ),
  _anchoredLabel(5, 'soundproof_booth', 300, 30),
  _anchoredLabel(
    5,
    'soundproof_booth_mirror',
    300,
    30,
    labelKey: 'soundproof_booth',
  ),
  _FloorLabel(
    'classical_reading_room',
    548,
    1001,
    270,
    52,
    priority: _FloorLabelPriority.primary,
    alwaysHighlighted: true,
  ),
  _FloorLabel(
    'seminar_rooms_501_513',
    154,
    617,
    280,
    42,
    priority: _FloorLabelPriority.primary,
  ),
  _FloorLabel(
    'seminar_rooms_501_513_mirror',
    942,
    617,
    280,
    42,
    labelKey: 'seminar_rooms_501_513',
    priority: _FloorLabelPriority.primary,
  ),
  _anchoredLabel(5, 'books_jk', 250, 35),
  _anchoredLabel(5, 'books_ko', 250, 35),
  _anchoredLabel(5, 'books_tz', 250, 30),
  _anchoredLabel(5, 'books_ot', 250, 30),
  _anchoredLabel(5, 'english_fiction', 200, 44),
  _anchoredLabel(5, 'course_reserves', 220, 44),
  _FloorLabel('books_i', 718, 617, 130, 44),
];

String _mapAreaLabel(AppLocalizations l10n, String key) => switch (key) {
  'south_entrance' => l10n.mapSouthEntrance,
  'pc_monitor_area' => l10n.mapPcAndMonitorZone,
  'self_service_reference_desk' => l10n.mapSelfServiceReferenceDesk,
  'self_service_circulation' => l10n.mapSelfServiceCirculation,
  'complete_collection_paintings' => l10n.mapCompleteCollectionPaintings,
  'newspapers_magazines' => l10n.mapNewspapersMagazines,
  'library_lounge' => l10n.mapLibraryLounge,
  'security_desk' => l10n.mapSecurityDesk,
  'self_service_printing' => l10n.mapSelfServicePrinting,
  'librarian_picks' => l10n.mapLibrarianPicks,
  'cpc_special_collection' => l10n.mapCpcSpecialCollection,
  'books_i' => l10n.mapBooksI,
  'books_ab' => l10n.mapBookRange('A–B'),
  'books_bh' => l10n.mapBookRange('B–H'),
  'books_jk' => l10n.mapBookRange('J–K'),
  'books_ko' => l10n.mapBookRange('K–O'),
  'books_ot' => l10n.mapBookRange('O–T'),
  'books_tz' => l10n.mapBookRange('T–Z'),
  'books_i_oxford' => l10n.mapBooksIAndOxford,
  'english_fiction' => l10n.mapEnglishFiction,
  'course_reserves' => l10n.mapCourseReserves,
  // 地图内使用不带编号的通用文案；不要回退到表内的“研讨室 501–513”。
  'seminar_rooms_304_312' => l10n.mapDiscussionRooms,
  'seminar_rooms_501_513' => l10n.mapDiscussionRooms,
  _ => librarySpaceLabel(l10n, key),
};
