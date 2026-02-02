import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'custom_notification_models.g.dart';

/// Simplified notification data for diamond updates
@BuiltValue()
abstract class DiamondUpdateData
    implements Built<DiamondUpdateData, DiamondUpdateDataBuilder> {
  num? get gain;
  num? get newDiamonds;

  DiamondUpdateData._();
  factory DiamondUpdateData([void Function(DiamondUpdateDataBuilder) updates]) =
      _$DiamondUpdateData;
}

/// Simplified notification data for ranking updates
@BuiltValue()
abstract class RankingUpdateData
    implements Built<RankingUpdateData, RankingUpdateDataBuilder> {
  BuiltList<RankingEntry>? get rankings;

  RankingUpdateData._();
  factory RankingUpdateData([void Function(RankingUpdateDataBuilder) updates]) =
      _$RankingUpdateData;
}

/// Simplified ranking entry
@BuiltValue()
abstract class RankingEntry
    implements Built<RankingEntry, RankingEntryBuilder> {
  String? get firstName;
  String? get lastName;
  num? get score;
  String? get imageUrl;

  RankingEntry._();
  factory RankingEntry([void Function(RankingEntryBuilder) updates]) =
      _$RankingEntry;
}

/// Union type for notification data - now with three nullable attributes
@BuiltValue()
abstract class NotificationDataUnion
    implements Built<NotificationDataUnion, NotificationDataUnionBuilder> {
  num? get gain;
  num? get newDiamonds;
  BuiltList<RankingEntry>? get rankings;

  NotificationDataUnion._();
  factory NotificationDataUnion([
    void Function(NotificationDataUnionBuilder) updates,
  ]) = _$NotificationDataUnion;
}
