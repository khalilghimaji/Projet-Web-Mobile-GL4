// @dart=3.9
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String email;
  @override
  final String password;
  @override
  final String imageUrl;
  @override
  final bool isEmailVerified;
  @override
  final String? verificationToken;
  @override
  final bool isMFAEnabled;
  @override
  final String? mfaSecret;
  @override
  final BuiltList<String>? recoveryCodes;
  @override
  final String googleId;
  @override
  final String githubId;
  @override
  final String firebaseUid;
  @override
  final num diamonds;
  @override
  final num score;
  @override
  final String? refreshToken;
  @override
  final BuiltList<Prediction> predictions;
  @override
  final BuiltList<Notification> notifications;
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final num version;

  factory _$User([void Function(UserBuilder)? updates]) =>
      (UserBuilder()..update(updates))._build();

  _$User._({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.isEmailVerified,
    this.verificationToken,
    required this.isMFAEnabled,
    this.mfaSecret,
    this.recoveryCodes,
    required this.googleId,
    required this.githubId,
    required this.firebaseUid,
    required this.diamonds,
    required this.score,
    this.refreshToken,
    required this.predictions,
    required this.notifications,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : super._();
  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        password == other.password &&
        imageUrl == other.imageUrl &&
        isEmailVerified == other.isEmailVerified &&
        verificationToken == other.verificationToken &&
        isMFAEnabled == other.isMFAEnabled &&
        mfaSecret == other.mfaSecret &&
        recoveryCodes == other.recoveryCodes &&
        googleId == other.googleId &&
        githubId == other.githubId &&
        firebaseUid == other.firebaseUid &&
        diamonds == other.diamonds &&
        score == other.score &&
        refreshToken == other.refreshToken &&
        predictions == other.predictions &&
        notifications == other.notifications &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        version == other.version;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, lastName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, isEmailVerified.hashCode);
    _$hash = $jc(_$hash, verificationToken.hashCode);
    _$hash = $jc(_$hash, isMFAEnabled.hashCode);
    _$hash = $jc(_$hash, mfaSecret.hashCode);
    _$hash = $jc(_$hash, recoveryCodes.hashCode);
    _$hash = $jc(_$hash, googleId.hashCode);
    _$hash = $jc(_$hash, githubId.hashCode);
    _$hash = $jc(_$hash, firebaseUid.hashCode);
    _$hash = $jc(_$hash, diamonds.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, predictions.hashCode);
    _$hash = $jc(_$hash, notifications.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'User')
          ..add('firstName', firstName)
          ..add('lastName', lastName)
          ..add('email', email)
          ..add('password', password)
          ..add('imageUrl', imageUrl)
          ..add('isEmailVerified', isEmailVerified)
          ..add('verificationToken', verificationToken)
          ..add('isMFAEnabled', isMFAEnabled)
          ..add('mfaSecret', mfaSecret)
          ..add('recoveryCodes', recoveryCodes)
          ..add('googleId', googleId)
          ..add('githubId', githubId)
          ..add('firebaseUid', firebaseUid)
          ..add('diamonds', diamonds)
          ..add('score', score)
          ..add('refreshToken', refreshToken)
          ..add('predictions', predictions)
          ..add('notifications', notifications)
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('version', version))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _lastName;
  String? get lastName => _$this._lastName;
  set lastName(String? lastName) => _$this._lastName = lastName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  bool? _isEmailVerified;
  bool? get isEmailVerified => _$this._isEmailVerified;
  set isEmailVerified(bool? isEmailVerified) =>
      _$this._isEmailVerified = isEmailVerified;

  String? _verificationToken;
  String? get verificationToken => _$this._verificationToken;
  set verificationToken(String? verificationToken) =>
      _$this._verificationToken = verificationToken;

  bool? _isMFAEnabled;
  bool? get isMFAEnabled => _$this._isMFAEnabled;
  set isMFAEnabled(bool? isMFAEnabled) => _$this._isMFAEnabled = isMFAEnabled;

  String? _mfaSecret;
  String? get mfaSecret => _$this._mfaSecret;
  set mfaSecret(String? mfaSecret) => _$this._mfaSecret = mfaSecret;

  ListBuilder<String>? _recoveryCodes;
  ListBuilder<String> get recoveryCodes =>
      _$this._recoveryCodes ??= ListBuilder<String>();
  set recoveryCodes(ListBuilder<String>? recoveryCodes) =>
      _$this._recoveryCodes = recoveryCodes;

  String? _googleId;
  String? get googleId => _$this._googleId;
  set googleId(String? googleId) => _$this._googleId = googleId;

  String? _githubId;
  String? get githubId => _$this._githubId;
  set githubId(String? githubId) => _$this._githubId = githubId;

  String? _firebaseUid;
  String? get firebaseUid => _$this._firebaseUid;
  set firebaseUid(String? firebaseUid) => _$this._firebaseUid = firebaseUid;

  num? _diamonds;
  num? get diamonds => _$this._diamonds;
  set diamonds(num? diamonds) => _$this._diamonds = diamonds;

  num? _score;
  num? get score => _$this._score;
  set score(num? score) => _$this._score = score;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  ListBuilder<Prediction>? _predictions;
  ListBuilder<Prediction> get predictions =>
      _$this._predictions ??= ListBuilder<Prediction>();
  set predictions(ListBuilder<Prediction>? predictions) =>
      _$this._predictions = predictions;

  ListBuilder<Notification>? _notifications;
  ListBuilder<Notification> get notifications =>
      _$this._notifications ??= ListBuilder<Notification>();
  set notifications(ListBuilder<Notification>? notifications) =>
      _$this._notifications = notifications;

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

  UserBuilder() {
    User._defaults(this);
  }

  UserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _lastName = $v.lastName;
      _email = $v.email;
      _password = $v.password;
      _imageUrl = $v.imageUrl;
      _isEmailVerified = $v.isEmailVerified;
      _verificationToken = $v.verificationToken;
      _isMFAEnabled = $v.isMFAEnabled;
      _mfaSecret = $v.mfaSecret;
      _recoveryCodes = $v.recoveryCodes?.toBuilder();
      _googleId = $v.googleId;
      _githubId = $v.githubId;
      _firebaseUid = $v.firebaseUid;
      _diamonds = $v.diamonds;
      _score = $v.score;
      _refreshToken = $v.refreshToken;
      _predictions = $v.predictions.toBuilder();
      _notifications = $v.notifications.toBuilder();
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _version = $v.version;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  User build() => _build();

  _$User _build() {
    _$User _$result;
    try {
      _$result =
          _$v ??
          _$User._(
            firstName: BuiltValueNullFieldError.checkNotNull(
              firstName,
              r'User',
              'firstName',
            ),
            lastName: BuiltValueNullFieldError.checkNotNull(
              lastName,
              r'User',
              'lastName',
            ),
            email: BuiltValueNullFieldError.checkNotNull(
              email,
              r'User',
              'email',
            ),
            password: BuiltValueNullFieldError.checkNotNull(
              password,
              r'User',
              'password',
            ),
            imageUrl: BuiltValueNullFieldError.checkNotNull(
              imageUrl,
              r'User',
              'imageUrl',
            ),
            isEmailVerified: BuiltValueNullFieldError.checkNotNull(
              isEmailVerified,
              r'User',
              'isEmailVerified',
            ),
            verificationToken: verificationToken,
            isMFAEnabled: BuiltValueNullFieldError.checkNotNull(
              isMFAEnabled,
              r'User',
              'isMFAEnabled',
            ),
            mfaSecret: mfaSecret,
            recoveryCodes: _recoveryCodes?.build(),
            googleId: BuiltValueNullFieldError.checkNotNull(
              googleId,
              r'User',
              'googleId',
            ),
            githubId: BuiltValueNullFieldError.checkNotNull(
              githubId,
              r'User',
              'githubId',
            ),
            firebaseUid: BuiltValueNullFieldError.checkNotNull(
              firebaseUid,
              r'User',
              'firebaseUid',
            ),
            diamonds: BuiltValueNullFieldError.checkNotNull(
              diamonds,
              r'User',
              'diamonds',
            ),
            score: BuiltValueNullFieldError.checkNotNull(
              score,
              r'User',
              'score',
            ),
            refreshToken: refreshToken,
            predictions: predictions.build(),
            notifications: notifications.build(),
            id: BuiltValueNullFieldError.checkNotNull(id, r'User', 'id'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'User',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'User',
              'updatedAt',
            ),
            version: BuiltValueNullFieldError.checkNotNull(
              version,
              r'User',
              'version',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recoveryCodes';
        _recoveryCodes?.build();

        _$failedField = 'predictions';
        predictions.build();
        _$failedField = 'notifications';
        notifications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

