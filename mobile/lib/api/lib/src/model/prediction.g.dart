// @dart=2.19
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Prediction extends Prediction {
  @override
  final User user;
  @override
  final String userId;
  @override
  final String matchId;
  @override
  final num scoreFirstEquipe;
  @override
  final num scoreSecondEquipe;
  @override
  final num numberOfDiamondsBet;
  @override
  final num pointsEarned;
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final num version;

  factory _$Prediction([void Function(PredictionBuilder)? updates]) =>
      (PredictionBuilder()..update(updates))._build();

  _$Prediction._({
    required this.user,
    required this.userId,
    required this.matchId,
    required this.scoreFirstEquipe,
    required this.scoreSecondEquipe,
    required this.numberOfDiamondsBet,
    required this.pointsEarned,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : super._();
  @override
  Prediction rebuild(void Function(PredictionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PredictionBuilder toBuilder() => PredictionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Prediction &&
        user == other.user &&
        userId == other.userId &&
        matchId == other.matchId &&
        scoreFirstEquipe == other.scoreFirstEquipe &&
        scoreSecondEquipe == other.scoreSecondEquipe &&
        numberOfDiamondsBet == other.numberOfDiamondsBet &&
        pointsEarned == other.pointsEarned &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, user.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, matchId.hashCode);
    _$hash = $jc(_$hash, scoreFirstEquipe.hashCode);
    _$hash = $jc(_$hash, scoreSecondEquipe.hashCode);
    _$hash = $jc(_$hash, numberOfDiamondsBet.hashCode);
    _$hash = $jc(_$hash, pointsEarned.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Prediction')
          ..add('user', user)
          ..add('userId', userId)
          ..add('matchId', matchId)
          ..add('scoreFirstEquipe', scoreFirstEquipe)
          ..add('scoreSecondEquipe', scoreSecondEquipe)
          ..add('numberOfDiamondsBet', numberOfDiamondsBet)
          ..add('pointsEarned', pointsEarned)
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class PredictionBuilder implements Builder<Prediction, PredictionBuilder> {
  _$Prediction? _$v;

  UserBuilder? _user;
  UserBuilder get user => _$this._user ??= UserBuilder();
  set user(UserBuilder? user) => _$this._user = user;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _matchId;
  String? get matchId => _$this._matchId;
  set matchId(String? matchId) => _$this._matchId = matchId;

  num? _scoreFirstEquipe;
  num? get scoreFirstEquipe => _$this._scoreFirstEquipe;
  set scoreFirstEquipe(num? scoreFirstEquipe) =>
      _$this._scoreFirstEquipe = scoreFirstEquipe;

  num? _scoreSecondEquipe;
  num? get scoreSecondEquipe => _$this._scoreSecondEquipe;
  set scoreSecondEquipe(num? scoreSecondEquipe) =>
      _$this._scoreSecondEquipe = scoreSecondEquipe;

  num? _numberOfDiamondsBet;
  num? get numberOfDiamondsBet => _$this._numberOfDiamondsBet;
  set numberOfDiamondsBet(num? numberOfDiamondsBet) =>
      _$this._numberOfDiamondsBet = numberOfDiamondsBet;

  num? _pointsEarned;
  num? get pointsEarned => _$this._pointsEarned;
  set pointsEarned(num? pointsEarned) => _$this._pointsEarned = pointsEarned;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  num? _version;
  num? get version => _$this._version;
  set version(num? version) => _$this._version = version;

  PredictionBuilder() {
    Prediction._defaults(this);
  }

  PredictionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _user = $v.user.toBuilder();
      _userId = $v.userId;
      _matchId = $v.matchId;
      _scoreFirstEquipe = $v.scoreFirstEquipe;
      _scoreSecondEquipe = $v.scoreSecondEquipe;
      _numberOfDiamondsBet = $v.numberOfDiamondsBet;
      _pointsEarned = $v.pointsEarned;
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Prediction other) {
    _$v = other as _$Prediction;
  }

  @override
  void update(void Function(PredictionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Prediction build() => _build();

  _$Prediction _build() {
    _$Prediction _$result;
    try {
      _$result =
          _$v ??
          _$Prediction._(
            user: user.build(),
            userId: BuiltValueNullFieldError.checkNotNull(
              userId,
              r'Prediction',
              'userId',
            ),
            matchId: BuiltValueNullFieldError.checkNotNull(
              matchId,
              r'Prediction',
              'matchId',
            ),
            scoreFirstEquipe: BuiltValueNullFieldError.checkNotNull(
              scoreFirstEquipe,
              r'Prediction',
              'scoreFirstEquipe',
            ),
            scoreSecondEquipe: BuiltValueNullFieldError.checkNotNull(
              scoreSecondEquipe,
              r'Prediction',
              'scoreSecondEquipe',
            ),
            numberOfDiamondsBet: BuiltValueNullFieldError.checkNotNull(
              numberOfDiamondsBet,
              r'Prediction',
              'numberOfDiamondsBet',
            ),
            pointsEarned: BuiltValueNullFieldError.checkNotNull(
              pointsEarned,
              r'Prediction',
              'pointsEarned',
            ),
            id: BuiltValueNullFieldError.checkNotNull(id, r'Prediction', 'id'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'Prediction',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'Prediction',
              'updatedAt',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'Prediction',
              'version',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'user';
        user.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Prediction',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
