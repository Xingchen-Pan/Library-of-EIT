/// 图内设施与馆藏锚点：绘制、标签和回归测试共用的设计坐标。
part of '../library_floor_map.dart';

/// 一项设施在设计坐标中的图标位置与标签相对位置。
class _MapAnchor {
  const _MapAnchor(this.feature, this.labelOffset);

  final Offset feature;
  final Offset labelOffset;
}

/// 2F/3F/5F 主要设施的设计坐标。
///
/// 绘图只读 [feature]，标签由 feature + labelOffset 派生，回归测试读取同一来源，
/// 避免同一坐标在绘制、标签和测试里各写一份后漂移。
abstract final class _FloorMapAnchors {
  static const facilityRowY = 905.0;

  static const _anchors = <int, Map<String, _MapAnchor>>{
    2: {
      'service_desk': _MapAnchor(Offset(287, facilityRowY), Offset(0, -35)),
      'self_service_reference_desk': _MapAnchor(
        Offset(821, facilityRowY),
        Offset(0, -35),
      ),
      'self_service_circulation': _MapAnchor(
        Offset(198, facilityRowY),
        Offset(0, -35),
      ),
      'self_service_printing': _MapAnchor(
        Offset(906, facilityRowY),
        Offset(0, -35),
      ),
      'newspapers_magazines': _MapAnchor(Offset(275, 1024), Offset(0, -36)),
      'newspapers_magazines_mirror': _MapAnchor(
        Offset(820, 1024),
        Offset(0, -36),
      ),
      'library_lounge': _MapAnchor(Offset(744, 1024), Offset(0, -36)),
      'library_lounge_mirror': _MapAnchor(Offset(364, 1024), Offset(0, -36)),
      'security_desk': _MapAnchor(Offset(449, 1024), Offset(0, -36)),
      'south_entrance': _MapAnchor(Offset(548, 1022), Offset(0, 53)),
    },
    3: {
      'pc_monitor_area': _MapAnchor(Offset(160, 494), Offset(0, -32)),
      'computer_monitor_area': _MapAnchor(Offset(939, 494), Offset(0, -32)),
      'soundproof_booth': _MapAnchor(Offset(137, 849), Offset(45, 21)),
      'soundproof_booth_mirror': _MapAnchor(Offset(954, 849), Offset(-45, 21)),
      'books_ab': _MapAnchor(Offset(274, 900), Offset(0, 45)),
      'books_bh': _MapAnchor(Offset(822, 900), Offset(0, 45)),
      'librarian_picks': _MapAnchor(Offset(544, 952), Offset(0, -63)),
      'cpc_special_collection': _MapAnchor(Offset(545, 1028), Offset(0, -20)),
    },
    5: {
      'computer_area': _MapAnchor(Offset(160, 494), Offset(0, -32)),
      'computer_monitor_area': _MapAnchor(Offset(939, 494), Offset(0, -32)),
      'books_jk': _MapAnchor(Offset(275, 351), Offset(5, 47)),
      'books_ko': _MapAnchor(Offset(820, 351), Offset(-4, 47)),
      'books_tz': _MapAnchor(Offset(254, 869), Offset(6, 41)),
      'books_ot': _MapAnchor(Offset(838, 869), Offset(-6, 41)),
      'soundproof_booth': _MapAnchor(Offset(220, 569), Offset(0, 48)),
      'soundproof_booth_mirror': _MapAnchor(Offset(872, 569), Offset(0, 48)),
      'english_fiction': _MapAnchor(Offset(160, 800), Offset(50, 0)),
      'course_reserves': _MapAnchor(Offset(943, 800), Offset(-53, 0)),
    },
  };

  static _MapAnchor _lookup(int floor, String key) {
    final anchor = _anchors[floor]?[key];
    if (anchor == null) {
      throw StateError('Missing $floor F map anchor for $key');
    }
    return anchor;
  }

  static Offset feature(int floor, String key) => _lookup(floor, key).feature;

  static Offset label(int floor, String key) =>
      _lookup(floor, key).feature + _lookup(floor, key).labelOffset;
}

/// 供地图回归测试读取设施图标的设计坐标。
@visibleForTesting
Offset libraryFloorMapFeatureAnchor(int floor, String key) =>
    _FloorMapAnchors.feature(floor, key);

/// 供地图回归测试读取设施标签的设计坐标。
@visibleForTesting
Offset libraryFloorMapLabelAnchor(int floor, String key) =>
    _FloorMapAnchors.label(floor, key);
