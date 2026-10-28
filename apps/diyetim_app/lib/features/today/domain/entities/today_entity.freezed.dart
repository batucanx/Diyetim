// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayEntity {

 DateTime get date; DietitianNoteEntity? get dietitianNote; List<MealEntity> get meals;
/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayEntityCopyWith<TodayEntity> get copyWith => _$TodayEntityCopyWithImpl<TodayEntity>(this as TodayEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TodayEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayEntity&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.dietitianNote, _this.dietitianNote) || other.dietitianNote == _this.dietitianNote)&&const DeepCollectionEquality().equals(other.meals, _this.meals));
}


@override
int get hashCode {
  final _this = this as TodayEntity;
  return Object.hash(runtimeType,_this.date,_this.dietitianNote,const DeepCollectionEquality().hash(_this.meals));
}

@override
String toString() {
  final _this = this as TodayEntity;
  return 'TodayEntity(date: ${_this.date}, dietitianNote: ${_this.dietitianNote}, meals: ${_this.meals})';
}


}

/// @nodoc
abstract mixin class $TodayEntityCopyWith<$Res>  {
  factory $TodayEntityCopyWith(TodayEntity value, $Res Function(TodayEntity) _then) = _$TodayEntityCopyWithImpl;
@useResult
$Res call({
 DateTime date, DietitianNoteEntity? dietitianNote, List<MealEntity> meals
});


$DietitianNoteEntityCopyWith<$Res>? get dietitianNote;

}
/// @nodoc
class _$TodayEntityCopyWithImpl<$Res>
    implements $TodayEntityCopyWith<$Res> {
  _$TodayEntityCopyWithImpl(this._self, this._then);

  final TodayEntity _self;
  final $Res Function(TodayEntity) _then;

/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? dietitianNote = freezed,Object? meals = null,}) {
  return _then(TodayEntity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dietitianNote: freezed == dietitianNote ? _self.dietitianNote : dietitianNote // ignore: cast_nullable_to_non_nullable
as DietitianNoteEntity?,meals: null == meals ? _self.meals : meals // ignore: cast_nullable_to_non_nullable
as List<MealEntity>,
  ));
}
/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DietitianNoteEntityCopyWith<$Res>? get dietitianNote {
    if (_self.dietitianNote == null) {
    return null;
  }

  return $DietitianNoteEntityCopyWith<$Res>(_self.dietitianNote!, (value) {
    return _then(_self.copyWith(dietitianNote: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayEntity].
extension TodayEntityPatterns on TodayEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayEntity value)  $default,){
final _that = this;
switch (_that) {
case _TodayEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TodayEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  DietitianNoteEntity? dietitianNote,  List<MealEntity> meals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayEntity() when $default != null:
return $default(_that.date,_that.dietitianNote,_that.meals);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  DietitianNoteEntity? dietitianNote,  List<MealEntity> meals)  $default,) {final _that = this;
switch (_that) {
case _TodayEntity():
return $default(_that.date,_that.dietitianNote,_that.meals);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  DietitianNoteEntity? dietitianNote,  List<MealEntity> meals)?  $default,) {final _that = this;
switch (_that) {
case _TodayEntity() when $default != null:
return $default(_that.date,_that.dietitianNote,_that.meals);case _:
  return null;

}
}

}

/// @nodoc


class _TodayEntity implements TodayEntity {
  const _TodayEntity({required this.date, this.dietitianNote, required  List<MealEntity> meals}): _meals = meals;
  

@override final  DateTime date;
@override final  DietitianNoteEntity? dietitianNote;
 final  List<MealEntity> _meals;
@override List<MealEntity> get meals {
  if (_meals is EqualUnmodifiableListView) return _meals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meals);
}


/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayEntityCopyWith<_TodayEntity> get copyWith => __$TodayEntityCopyWithImpl<_TodayEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.dietitianNote, dietitianNote) || other.dietitianNote == dietitianNote)&&const DeepCollectionEquality().equals(other.meals, _meals));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,dietitianNote,const DeepCollectionEquality().hash(_meals));
}

@override
String toString() {
    return 'TodayEntity(date: $date, dietitianNote: $dietitianNote, meals: $meals)';
}


}

/// @nodoc
abstract mixin class _$TodayEntityCopyWith<$Res> implements $TodayEntityCopyWith<$Res> {
  factory _$TodayEntityCopyWith(_TodayEntity value, $Res Function(_TodayEntity) _then) = __$TodayEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DietitianNoteEntity? dietitianNote, List<MealEntity> meals
});


@override $DietitianNoteEntityCopyWith<$Res>? get dietitianNote;

}
/// @nodoc
class __$TodayEntityCopyWithImpl<$Res>
    implements _$TodayEntityCopyWith<$Res> {
  __$TodayEntityCopyWithImpl(this._self, this._then);

  final _TodayEntity _self;
  final $Res Function(_TodayEntity) _then;

/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? dietitianNote = freezed,Object? meals = null,}) {
  return _then(_TodayEntity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,dietitianNote: freezed == dietitianNote ? _self.dietitianNote : dietitianNote // ignore: cast_nullable_to_non_nullable
as DietitianNoteEntity?,meals: null == meals ? _self._meals : meals // ignore: cast_nullable_to_non_nullable
as List<MealEntity>,
  ));
}

/// Create a copy of TodayEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DietitianNoteEntityCopyWith<$Res>? get dietitianNote {
    if (_self.dietitianNote == null) {
    return null;
  }

  return $DietitianNoteEntityCopyWith<$Res>(_self.dietitianNote!, (value) {
    return _then(_self.copyWith(dietitianNote: value));
  });
}
}

/// @nodoc
mixin _$DietitianNoteEntity {

 String get id; String get text; DateTime get createdAt; String get authorName; String? get authorAvatarUrl; bool get authorVerified;
/// Create a copy of DietitianNoteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DietitianNoteEntityCopyWith<DietitianNoteEntity> get copyWith => _$DietitianNoteEntityCopyWithImpl<DietitianNoteEntity>(this as DietitianNoteEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DietitianNoteEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DietitianNoteEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.authorName, _this.authorName) || other.authorName == _this.authorName)&&(identical(other.authorAvatarUrl, _this.authorAvatarUrl) || other.authorAvatarUrl == _this.authorAvatarUrl)&&(identical(other.authorVerified, _this.authorVerified) || other.authorVerified == _this.authorVerified));
}


@override
int get hashCode {
  final _this = this as DietitianNoteEntity;
  return Object.hash(runtimeType,_this.id,_this.text,_this.createdAt,_this.authorName,_this.authorAvatarUrl,_this.authorVerified);
}

@override
String toString() {
  final _this = this as DietitianNoteEntity;
  return 'DietitianNoteEntity(id: ${_this.id}, text: ${_this.text}, createdAt: ${_this.createdAt}, authorName: ${_this.authorName}, authorAvatarUrl: ${_this.authorAvatarUrl}, authorVerified: ${_this.authorVerified})';
}


}

/// @nodoc
abstract mixin class $DietitianNoteEntityCopyWith<$Res>  {
  factory $DietitianNoteEntityCopyWith(DietitianNoteEntity value, $Res Function(DietitianNoteEntity) _then) = _$DietitianNoteEntityCopyWithImpl;
@useResult
$Res call({
 String id, String text, DateTime createdAt, String authorName, String? authorAvatarUrl, bool authorVerified
});




}
/// @nodoc
class _$DietitianNoteEntityCopyWithImpl<$Res>
    implements $DietitianNoteEntityCopyWith<$Res> {
  _$DietitianNoteEntityCopyWithImpl(this._self, this._then);

  final DietitianNoteEntity _self;
  final $Res Function(DietitianNoteEntity) _then;

/// Create a copy of DietitianNoteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? authorName = null,Object? authorAvatarUrl = freezed,Object? authorVerified = null,}) {
  return _then(DietitianNoteEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,authorVerified: null == authorVerified ? _self.authorVerified : authorVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DietitianNoteEntity].
extension DietitianNoteEntityPatterns on DietitianNoteEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DietitianNoteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DietitianNoteEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DietitianNoteEntity value)  $default,){
final _that = this;
switch (_that) {
case _DietitianNoteEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DietitianNoteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DietitianNoteEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  String authorName,  String? authorAvatarUrl,  bool authorVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DietitianNoteEntity() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.authorName,_that.authorAvatarUrl,_that.authorVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  String authorName,  String? authorAvatarUrl,  bool authorVerified)  $default,) {final _that = this;
switch (_that) {
case _DietitianNoteEntity():
return $default(_that.id,_that.text,_that.createdAt,_that.authorName,_that.authorAvatarUrl,_that.authorVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  DateTime createdAt,  String authorName,  String? authorAvatarUrl,  bool authorVerified)?  $default,) {final _that = this;
switch (_that) {
case _DietitianNoteEntity() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.authorName,_that.authorAvatarUrl,_that.authorVerified);case _:
  return null;

}
}

}

/// @nodoc


class _DietitianNoteEntity implements DietitianNoteEntity {
  const _DietitianNoteEntity({required this.id, required this.text, required this.createdAt, required this.authorName, this.authorAvatarUrl, this.authorVerified = false});
  

@override final  String id;
@override final  String text;
@override final  DateTime createdAt;
@override final  String authorName;
@override final  String? authorAvatarUrl;
@override@JsonKey() final  bool authorVerified;

/// Create a copy of DietitianNoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DietitianNoteEntityCopyWith<_DietitianNoteEntity> get copyWith => __$DietitianNoteEntityCopyWithImpl<_DietitianNoteEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DietitianNoteEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.authorVerified, authorVerified) || other.authorVerified == authorVerified));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text,createdAt,authorName,authorAvatarUrl,authorVerified);
}

@override
String toString() {
    return 'DietitianNoteEntity(id: $id, text: $text, createdAt: $createdAt, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, authorVerified: $authorVerified)';
}


}

/// @nodoc
abstract mixin class _$DietitianNoteEntityCopyWith<$Res> implements $DietitianNoteEntityCopyWith<$Res> {
  factory _$DietitianNoteEntityCopyWith(_DietitianNoteEntity value, $Res Function(_DietitianNoteEntity) _then) = __$DietitianNoteEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, DateTime createdAt, String authorName, String? authorAvatarUrl, bool authorVerified
});




}
/// @nodoc
class __$DietitianNoteEntityCopyWithImpl<$Res>
    implements _$DietitianNoteEntityCopyWith<$Res> {
  __$DietitianNoteEntityCopyWithImpl(this._self, this._then);

  final _DietitianNoteEntity _self;
  final $Res Function(_DietitianNoteEntity) _then;

/// Create a copy of DietitianNoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? authorName = null,Object? authorAvatarUrl = freezed,Object? authorVerified = null,}) {
  return _then(_DietitianNoteEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: freezed == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,authorVerified: null == authorVerified ? _self.authorVerified : authorVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MealEntity {

 String get id; String get name; String? get time; DyMealStatus get status;/// Gizliyse [calories] her zaman null'dır (değer istemciye inmez).
 DyVisibility get caloriesVisibility;/// null + visible: değer henüz bilinmiyor.
 double? get calories; List<MealItemEntity> get items;
/// Create a copy of MealEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntityCopyWith<MealEntity> get copyWith => _$MealEntityCopyWithImpl<MealEntity>(this as MealEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MealEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.caloriesVisibility, _this.caloriesVisibility) || other.caloriesVisibility == _this.caloriesVisibility)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as MealEntity;
  return Object.hash(runtimeType,_this.id,_this.name,_this.time,_this.status,_this.caloriesVisibility,_this.calories,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as MealEntity;
  return 'MealEntity(id: ${_this.id}, name: ${_this.name}, time: ${_this.time}, status: ${_this.status}, caloriesVisibility: ${_this.caloriesVisibility}, calories: ${_this.calories}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $MealEntityCopyWith<$Res>  {
  factory $MealEntityCopyWith(MealEntity value, $Res Function(MealEntity) _then) = _$MealEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? time, DyMealStatus status, DyVisibility caloriesVisibility, double? calories, List<MealItemEntity> items
});




}
/// @nodoc
class _$MealEntityCopyWithImpl<$Res>
    implements $MealEntityCopyWith<$Res> {
  _$MealEntityCopyWithImpl(this._self, this._then);

  final MealEntity _self;
  final $Res Function(MealEntity) _then;

/// Create a copy of MealEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? time = freezed,Object? status = null,Object? caloriesVisibility = null,Object? calories = freezed,Object? items = null,}) {
  return _then(MealEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DyMealStatus,caloriesVisibility: null == caloriesVisibility ? _self.caloriesVisibility : caloriesVisibility // ignore: cast_nullable_to_non_nullable
as DyVisibility,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<MealItemEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [MealEntity].
extension MealEntityPatterns on MealEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealEntity value)  $default,){
final _that = this;
switch (_that) {
case _MealEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MealEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? time,  DyMealStatus status,  DyVisibility caloriesVisibility,  double? calories,  List<MealItemEntity> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealEntity() when $default != null:
return $default(_that.id,_that.name,_that.time,_that.status,_that.caloriesVisibility,_that.calories,_that.items);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? time,  DyMealStatus status,  DyVisibility caloriesVisibility,  double? calories,  List<MealItemEntity> items)  $default,) {final _that = this;
switch (_that) {
case _MealEntity():
return $default(_that.id,_that.name,_that.time,_that.status,_that.caloriesVisibility,_that.calories,_that.items);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? time,  DyMealStatus status,  DyVisibility caloriesVisibility,  double? calories,  List<MealItemEntity> items)?  $default,) {final _that = this;
switch (_that) {
case _MealEntity() when $default != null:
return $default(_that.id,_that.name,_that.time,_that.status,_that.caloriesVisibility,_that.calories,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _MealEntity implements MealEntity {
  const _MealEntity({required this.id, required this.name, this.time, required this.status, this.caloriesVisibility = DyVisibility.visible, this.calories, required  List<MealItemEntity> items}): _items = items;
  

@override final  String id;
@override final  String name;
@override final  String? time;
@override final  DyMealStatus status;
/// Gizliyse [calories] her zaman null'dır (değer istemciye inmez).
@override@JsonKey() final  DyVisibility caloriesVisibility;
/// null + visible: değer henüz bilinmiyor.
@override final  double? calories;
 final  List<MealItemEntity> _items;
@override List<MealItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of MealEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealEntityCopyWith<_MealEntity> get copyWith => __$MealEntityCopyWithImpl<_MealEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.time, time) || other.time == time)&&(identical(other.status, status) || other.status == status)&&(identical(other.caloriesVisibility, caloriesVisibility) || other.caloriesVisibility == caloriesVisibility)&&(identical(other.calories, calories) || other.calories == calories)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,time,status,caloriesVisibility,calories,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'MealEntity(id: $id, name: $name, time: $time, status: $status, caloriesVisibility: $caloriesVisibility, calories: $calories, items: $items)';
}


}

/// @nodoc
abstract mixin class _$MealEntityCopyWith<$Res> implements $MealEntityCopyWith<$Res> {
  factory _$MealEntityCopyWith(_MealEntity value, $Res Function(_MealEntity) _then) = __$MealEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? time, DyMealStatus status, DyVisibility caloriesVisibility, double? calories, List<MealItemEntity> items
});




}
/// @nodoc
class __$MealEntityCopyWithImpl<$Res>
    implements _$MealEntityCopyWith<$Res> {
  __$MealEntityCopyWithImpl(this._self, this._then);

  final _MealEntity _self;
  final $Res Function(_MealEntity) _then;

/// Create a copy of MealEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? time = freezed,Object? status = null,Object? caloriesVisibility = null,Object? calories = freezed,Object? items = null,}) {
  return _then(_MealEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DyMealStatus,caloriesVisibility: null == caloriesVisibility ? _self.caloriesVisibility : caloriesVisibility // ignore: cast_nullable_to_non_nullable
as DyVisibility,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<MealItemEntity>,
  ));
}


}

/// @nodoc
mixin _$MealItemEntity {

 String get name; DyDataSource? get source;
/// Create a copy of MealItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealItemEntityCopyWith<MealItemEntity> get copyWith => _$MealItemEntityCopyWithImpl<MealItemEntity>(this as MealItemEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MealItemEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealItemEntity&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.source, _this.source) || other.source == _this.source));
}


@override
int get hashCode {
  final _this = this as MealItemEntity;
  return Object.hash(runtimeType,_this.name,_this.source);
}

@override
String toString() {
  final _this = this as MealItemEntity;
  return 'MealItemEntity(name: ${_this.name}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $MealItemEntityCopyWith<$Res>  {
  factory $MealItemEntityCopyWith(MealItemEntity value, $Res Function(MealItemEntity) _then) = _$MealItemEntityCopyWithImpl;
@useResult
$Res call({
 String name, DyDataSource? source
});




}
/// @nodoc
class _$MealItemEntityCopyWithImpl<$Res>
    implements $MealItemEntityCopyWith<$Res> {
  _$MealItemEntityCopyWithImpl(this._self, this._then);

  final MealItemEntity _self;
  final $Res Function(MealItemEntity) _then;

/// Create a copy of MealItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? source = freezed,}) {
  return _then(MealItemEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DyDataSource?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealItemEntity].
extension MealItemEntityPatterns on MealItemEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealItemEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _MealItemEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MealItemEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DyDataSource? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealItemEntity() when $default != null:
return $default(_that.name,_that.source);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DyDataSource? source)  $default,) {final _that = this;
switch (_that) {
case _MealItemEntity():
return $default(_that.name,_that.source);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DyDataSource? source)?  $default,) {final _that = this;
switch (_that) {
case _MealItemEntity() when $default != null:
return $default(_that.name,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _MealItemEntity implements MealItemEntity {
  const _MealItemEntity({required this.name, this.source});
  

@override final  String name;
@override final  DyDataSource? source;

/// Create a copy of MealItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealItemEntityCopyWith<_MealItemEntity> get copyWith => __$MealItemEntityCopyWithImpl<_MealItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealItemEntity&&(identical(other.name, name) || other.name == name)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,source);
}

@override
String toString() {
    return 'MealItemEntity(name: $name, source: $source)';
}


}

/// @nodoc
abstract mixin class _$MealItemEntityCopyWith<$Res> implements $MealItemEntityCopyWith<$Res> {
  factory _$MealItemEntityCopyWith(_MealItemEntity value, $Res Function(_MealItemEntity) _then) = __$MealItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String name, DyDataSource? source
});




}
/// @nodoc
class __$MealItemEntityCopyWithImpl<$Res>
    implements _$MealItemEntityCopyWith<$Res> {
  __$MealItemEntityCopyWithImpl(this._self, this._then);

  final _MealItemEntity _self;
  final $Res Function(_MealItemEntity) _then;

/// Create a copy of MealItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? source = freezed,}) {
  return _then(_MealItemEntity(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DyDataSource?,
  ));
}


}

// dart format on
