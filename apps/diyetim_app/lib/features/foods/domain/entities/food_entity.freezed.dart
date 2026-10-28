// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodSearchPageEntity {

 String get query; int get page; int get pageSize; int get totalResults; List<FoodSummaryEntity> get items; AttributionEntity? get attribution;
/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSearchPageEntityCopyWith<FoodSearchPageEntity> get copyWith => _$FoodSearchPageEntityCopyWithImpl<FoodSearchPageEntity>(this as FoodSearchPageEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodSearchPageEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSearchPageEntity&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageSize, _this.pageSize) || other.pageSize == _this.pageSize)&&(identical(other.totalResults, _this.totalResults) || other.totalResults == _this.totalResults)&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.attribution, _this.attribution) || other.attribution == _this.attribution));
}


@override
int get hashCode {
  final _this = this as FoodSearchPageEntity;
  return Object.hash(runtimeType,_this.query,_this.page,_this.pageSize,_this.totalResults,const DeepCollectionEquality().hash(_this.items),_this.attribution);
}

@override
String toString() {
  final _this = this as FoodSearchPageEntity;
  return 'FoodSearchPageEntity(query: ${_this.query}, page: ${_this.page}, pageSize: ${_this.pageSize}, totalResults: ${_this.totalResults}, items: ${_this.items}, attribution: ${_this.attribution})';
}


}

/// @nodoc
abstract mixin class $FoodSearchPageEntityCopyWith<$Res>  {
  factory $FoodSearchPageEntityCopyWith(FoodSearchPageEntity value, $Res Function(FoodSearchPageEntity) _then) = _$FoodSearchPageEntityCopyWithImpl;
@useResult
$Res call({
 String query, int page, int pageSize, int totalResults, List<FoodSummaryEntity> items, AttributionEntity? attribution
});


$AttributionEntityCopyWith<$Res>? get attribution;

}
/// @nodoc
class _$FoodSearchPageEntityCopyWithImpl<$Res>
    implements $FoodSearchPageEntityCopyWith<$Res> {
  _$FoodSearchPageEntityCopyWithImpl(this._self, this._then);

  final FoodSearchPageEntity _self;
  final $Res Function(FoodSearchPageEntity) _then;

/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? page = null,Object? pageSize = null,Object? totalResults = null,Object? items = null,Object? attribution = freezed,}) {
  return _then(FoodSearchPageEntity(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<FoodSummaryEntity>,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as AttributionEntity?,
  ));
}
/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttributionEntityCopyWith<$Res>? get attribution {
    if (_self.attribution == null) {
    return null;
  }

  return $AttributionEntityCopyWith<$Res>(_self.attribution!, (value) {
    return _then(_self.copyWith(attribution: value));
  });
}
}


/// Adds pattern-matching-related methods to [FoodSearchPageEntity].
extension FoodSearchPageEntityPatterns on FoodSearchPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSearchPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSearchPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSearchPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _FoodSearchPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSearchPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSearchPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  int page,  int pageSize,  int totalResults,  List<FoodSummaryEntity> items,  AttributionEntity? attribution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSearchPageEntity() when $default != null:
return $default(_that.query,_that.page,_that.pageSize,_that.totalResults,_that.items,_that.attribution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  int page,  int pageSize,  int totalResults,  List<FoodSummaryEntity> items,  AttributionEntity? attribution)  $default,) {final _that = this;
switch (_that) {
case _FoodSearchPageEntity():
return $default(_that.query,_that.page,_that.pageSize,_that.totalResults,_that.items,_that.attribution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  int page,  int pageSize,  int totalResults,  List<FoodSummaryEntity> items,  AttributionEntity? attribution)?  $default,) {final _that = this;
switch (_that) {
case _FoodSearchPageEntity() when $default != null:
return $default(_that.query,_that.page,_that.pageSize,_that.totalResults,_that.items,_that.attribution);case _:
  return null;

}
}

}

/// @nodoc


class _FoodSearchPageEntity extends FoodSearchPageEntity {
  const _FoodSearchPageEntity({required this.query, required this.page, required this.pageSize, required this.totalResults, required  List<FoodSummaryEntity> items, this.attribution}): _items = items,super._();
  

@override final  String query;
@override final  int page;
@override final  int pageSize;
@override final  int totalResults;
 final  List<FoodSummaryEntity> _items;
@override List<FoodSummaryEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  AttributionEntity? attribution;

/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSearchPageEntityCopyWith<_FoodSearchPageEntity> get copyWith => __$FoodSearchPageEntityCopyWithImpl<_FoodSearchPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSearchPageEntity&&(identical(other.query, query) || other.query == query)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.attribution, attribution) || other.attribution == attribution));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,page,pageSize,totalResults,const DeepCollectionEquality().hash(_items),attribution);
}

@override
String toString() {
    return 'FoodSearchPageEntity(query: $query, page: $page, pageSize: $pageSize, totalResults: $totalResults, items: $items, attribution: $attribution)';
}


}

/// @nodoc
abstract mixin class _$FoodSearchPageEntityCopyWith<$Res> implements $FoodSearchPageEntityCopyWith<$Res> {
  factory _$FoodSearchPageEntityCopyWith(_FoodSearchPageEntity value, $Res Function(_FoodSearchPageEntity) _then) = __$FoodSearchPageEntityCopyWithImpl;
@override @useResult
$Res call({
 String query, int page, int pageSize, int totalResults, List<FoodSummaryEntity> items, AttributionEntity? attribution
});


@override $AttributionEntityCopyWith<$Res>? get attribution;

}
/// @nodoc
class __$FoodSearchPageEntityCopyWithImpl<$Res>
    implements _$FoodSearchPageEntityCopyWith<$Res> {
  __$FoodSearchPageEntityCopyWithImpl(this._self, this._then);

  final _FoodSearchPageEntity _self;
  final $Res Function(_FoodSearchPageEntity) _then;

/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? page = null,Object? pageSize = null,Object? totalResults = null,Object? items = null,Object? attribution = freezed,}) {
  return _then(_FoodSearchPageEntity(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<FoodSummaryEntity>,attribution: freezed == attribution ? _self.attribution : attribution // ignore: cast_nullable_to_non_nullable
as AttributionEntity?,
  ));
}

/// Create a copy of FoodSearchPageEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttributionEntityCopyWith<$Res>? get attribution {
    if (_self.attribution == null) {
    return null;
  }

  return $AttributionEntityCopyWith<$Res>(_self.attribution!, (value) {
    return _then(_self.copyWith(attribution: value));
  });
}
}

/// @nodoc
mixin _$FoodSummaryEntity {

 String get id; String get name; String? get brand; ServingEntity get defaultServing;
/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSummaryEntityCopyWith<FoodSummaryEntity> get copyWith => _$FoodSummaryEntityCopyWithImpl<FoodSummaryEntity>(this as FoodSummaryEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodSummaryEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSummaryEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.defaultServing, _this.defaultServing) || other.defaultServing == _this.defaultServing));
}


@override
int get hashCode {
  final _this = this as FoodSummaryEntity;
  return Object.hash(runtimeType,_this.id,_this.name,_this.brand,_this.defaultServing);
}

@override
String toString() {
  final _this = this as FoodSummaryEntity;
  return 'FoodSummaryEntity(id: ${_this.id}, name: ${_this.name}, brand: ${_this.brand}, defaultServing: ${_this.defaultServing})';
}


}

/// @nodoc
abstract mixin class $FoodSummaryEntityCopyWith<$Res>  {
  factory $FoodSummaryEntityCopyWith(FoodSummaryEntity value, $Res Function(FoodSummaryEntity) _then) = _$FoodSummaryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? brand, ServingEntity defaultServing
});


$ServingEntityCopyWith<$Res> get defaultServing;

}
/// @nodoc
class _$FoodSummaryEntityCopyWithImpl<$Res>
    implements $FoodSummaryEntityCopyWith<$Res> {
  _$FoodSummaryEntityCopyWithImpl(this._self, this._then);

  final FoodSummaryEntity _self;
  final $Res Function(FoodSummaryEntity) _then;

/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = freezed,Object? defaultServing = null,}) {
  return _then(FoodSummaryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,defaultServing: null == defaultServing ? _self.defaultServing : defaultServing // ignore: cast_nullable_to_non_nullable
as ServingEntity,
  ));
}
/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServingEntityCopyWith<$Res> get defaultServing {
  
  return $ServingEntityCopyWith<$Res>(_self.defaultServing, (value) {
    return _then(_self.copyWith(defaultServing: value));
  });
}
}


/// Adds pattern-matching-related methods to [FoodSummaryEntity].
extension FoodSummaryEntityPatterns on FoodSummaryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSummaryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSummaryEntity value)  $default,){
final _that = this;
switch (_that) {
case _FoodSummaryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSummaryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? brand,  ServingEntity defaultServing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSummaryEntity() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.defaultServing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? brand,  ServingEntity defaultServing)  $default,) {final _that = this;
switch (_that) {
case _FoodSummaryEntity():
return $default(_that.id,_that.name,_that.brand,_that.defaultServing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? brand,  ServingEntity defaultServing)?  $default,) {final _that = this;
switch (_that) {
case _FoodSummaryEntity() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.defaultServing);case _:
  return null;

}
}

}

/// @nodoc


class _FoodSummaryEntity implements FoodSummaryEntity {
  const _FoodSummaryEntity({required this.id, required this.name, this.brand, required this.defaultServing});
  

@override final  String id;
@override final  String name;
@override final  String? brand;
@override final  ServingEntity defaultServing;

/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSummaryEntityCopyWith<_FoodSummaryEntity> get copyWith => __$FoodSummaryEntityCopyWithImpl<_FoodSummaryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSummaryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.defaultServing, defaultServing) || other.defaultServing == defaultServing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,brand,defaultServing);
}

@override
String toString() {
    return 'FoodSummaryEntity(id: $id, name: $name, brand: $brand, defaultServing: $defaultServing)';
}


}

/// @nodoc
abstract mixin class _$FoodSummaryEntityCopyWith<$Res> implements $FoodSummaryEntityCopyWith<$Res> {
  factory _$FoodSummaryEntityCopyWith(_FoodSummaryEntity value, $Res Function(_FoodSummaryEntity) _then) = __$FoodSummaryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? brand, ServingEntity defaultServing
});


@override $ServingEntityCopyWith<$Res> get defaultServing;

}
/// @nodoc
class __$FoodSummaryEntityCopyWithImpl<$Res>
    implements _$FoodSummaryEntityCopyWith<$Res> {
  __$FoodSummaryEntityCopyWithImpl(this._self, this._then);

  final _FoodSummaryEntity _self;
  final $Res Function(_FoodSummaryEntity) _then;

/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = freezed,Object? defaultServing = null,}) {
  return _then(_FoodSummaryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,defaultServing: null == defaultServing ? _self.defaultServing : defaultServing // ignore: cast_nullable_to_non_nullable
as ServingEntity,
  ));
}

/// Create a copy of FoodSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServingEntityCopyWith<$Res> get defaultServing {
  
  return $ServingEntityCopyWith<$Res>(_self.defaultServing, (value) {
    return _then(_self.copyWith(defaultServing: value));
  });
}
}

/// @nodoc
mixin _$ServingEntity {

 String get id; String get description; double? get metricAmount; String? get metricUnit; double get calories; double get carbohydrate; double get protein; double get fat;
/// Create a copy of ServingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServingEntityCopyWith<ServingEntity> get copyWith => _$ServingEntityCopyWithImpl<ServingEntity>(this as ServingEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ServingEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServingEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.metricAmount, _this.metricAmount) || other.metricAmount == _this.metricAmount)&&(identical(other.metricUnit, _this.metricUnit) || other.metricUnit == _this.metricUnit)&&(identical(other.calories, _this.calories) || other.calories == _this.calories)&&(identical(other.carbohydrate, _this.carbohydrate) || other.carbohydrate == _this.carbohydrate)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.fat, _this.fat) || other.fat == _this.fat));
}


@override
int get hashCode {
  final _this = this as ServingEntity;
  return Object.hash(runtimeType,_this.id,_this.description,_this.metricAmount,_this.metricUnit,_this.calories,_this.carbohydrate,_this.protein,_this.fat);
}

@override
String toString() {
  final _this = this as ServingEntity;
  return 'ServingEntity(id: ${_this.id}, description: ${_this.description}, metricAmount: ${_this.metricAmount}, metricUnit: ${_this.metricUnit}, calories: ${_this.calories}, carbohydrate: ${_this.carbohydrate}, protein: ${_this.protein}, fat: ${_this.fat})';
}


}

/// @nodoc
abstract mixin class $ServingEntityCopyWith<$Res>  {
  factory $ServingEntityCopyWith(ServingEntity value, $Res Function(ServingEntity) _then) = _$ServingEntityCopyWithImpl;
@useResult
$Res call({
 String id, String description, double? metricAmount, String? metricUnit, double calories, double carbohydrate, double protein, double fat
});




}
/// @nodoc
class _$ServingEntityCopyWithImpl<$Res>
    implements $ServingEntityCopyWith<$Res> {
  _$ServingEntityCopyWithImpl(this._self, this._then);

  final ServingEntity _self;
  final $Res Function(ServingEntity) _then;

/// Create a copy of ServingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? metricAmount = freezed,Object? metricUnit = freezed,Object? calories = null,Object? carbohydrate = null,Object? protein = null,Object? fat = null,}) {
  return _then(ServingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,metricAmount: freezed == metricAmount ? _self.metricAmount : metricAmount // ignore: cast_nullable_to_non_nullable
as double?,metricUnit: freezed == metricUnit ? _self.metricUnit : metricUnit // ignore: cast_nullable_to_non_nullable
as String?,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,carbohydrate: null == carbohydrate ? _self.carbohydrate : carbohydrate // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ServingEntity].
extension ServingEntityPatterns on ServingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServingEntity value)  $default,){
final _that = this;
switch (_that) {
case _ServingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ServingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  double? metricAmount,  String? metricUnit,  double calories,  double carbohydrate,  double protein,  double fat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServingEntity() when $default != null:
return $default(_that.id,_that.description,_that.metricAmount,_that.metricUnit,_that.calories,_that.carbohydrate,_that.protein,_that.fat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  double? metricAmount,  String? metricUnit,  double calories,  double carbohydrate,  double protein,  double fat)  $default,) {final _that = this;
switch (_that) {
case _ServingEntity():
return $default(_that.id,_that.description,_that.metricAmount,_that.metricUnit,_that.calories,_that.carbohydrate,_that.protein,_that.fat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  double? metricAmount,  String? metricUnit,  double calories,  double carbohydrate,  double protein,  double fat)?  $default,) {final _that = this;
switch (_that) {
case _ServingEntity() when $default != null:
return $default(_that.id,_that.description,_that.metricAmount,_that.metricUnit,_that.calories,_that.carbohydrate,_that.protein,_that.fat);case _:
  return null;

}
}

}

/// @nodoc


class _ServingEntity implements ServingEntity {
  const _ServingEntity({required this.id, required this.description, this.metricAmount, this.metricUnit, required this.calories, required this.carbohydrate, required this.protein, required this.fat});
  

@override final  String id;
@override final  String description;
@override final  double? metricAmount;
@override final  String? metricUnit;
@override final  double calories;
@override final  double carbohydrate;
@override final  double protein;
@override final  double fat;

/// Create a copy of ServingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServingEntityCopyWith<_ServingEntity> get copyWith => __$ServingEntityCopyWithImpl<_ServingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.metricAmount, metricAmount) || other.metricAmount == metricAmount)&&(identical(other.metricUnit, metricUnit) || other.metricUnit == metricUnit)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.carbohydrate, carbohydrate) || other.carbohydrate == carbohydrate)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.fat, fat) || other.fat == fat));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,description,metricAmount,metricUnit,calories,carbohydrate,protein,fat);
}

@override
String toString() {
    return 'ServingEntity(id: $id, description: $description, metricAmount: $metricAmount, metricUnit: $metricUnit, calories: $calories, carbohydrate: $carbohydrate, protein: $protein, fat: $fat)';
}


}

/// @nodoc
abstract mixin class _$ServingEntityCopyWith<$Res> implements $ServingEntityCopyWith<$Res> {
  factory _$ServingEntityCopyWith(_ServingEntity value, $Res Function(_ServingEntity) _then) = __$ServingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, double? metricAmount, String? metricUnit, double calories, double carbohydrate, double protein, double fat
});




}
/// @nodoc
class __$ServingEntityCopyWithImpl<$Res>
    implements _$ServingEntityCopyWith<$Res> {
  __$ServingEntityCopyWithImpl(this._self, this._then);

  final _ServingEntity _self;
  final $Res Function(_ServingEntity) _then;

/// Create a copy of ServingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? metricAmount = freezed,Object? metricUnit = freezed,Object? calories = null,Object? carbohydrate = null,Object? protein = null,Object? fat = null,}) {
  return _then(_ServingEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,metricAmount: freezed == metricAmount ? _self.metricAmount : metricAmount // ignore: cast_nullable_to_non_nullable
as double?,metricUnit: freezed == metricUnit ? _self.metricUnit : metricUnit // ignore: cast_nullable_to_non_nullable
as String?,calories: null == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as double,carbohydrate: null == carbohydrate ? _self.carbohydrate : carbohydrate // ignore: cast_nullable_to_non_nullable
as double,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as double,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$AttributionEntity {

 String get text; Uri? get url;
/// Create a copy of AttributionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttributionEntityCopyWith<AttributionEntity> get copyWith => _$AttributionEntityCopyWithImpl<AttributionEntity>(this as AttributionEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AttributionEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttributionEntity&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.url, _this.url) || other.url == _this.url));
}


@override
int get hashCode {
  final _this = this as AttributionEntity;
  return Object.hash(runtimeType,_this.text,_this.url);
}

@override
String toString() {
  final _this = this as AttributionEntity;
  return 'AttributionEntity(text: ${_this.text}, url: ${_this.url})';
}


}

/// @nodoc
abstract mixin class $AttributionEntityCopyWith<$Res>  {
  factory $AttributionEntityCopyWith(AttributionEntity value, $Res Function(AttributionEntity) _then) = _$AttributionEntityCopyWithImpl;
@useResult
$Res call({
 String text, Uri? url
});




}
/// @nodoc
class _$AttributionEntityCopyWithImpl<$Res>
    implements $AttributionEntityCopyWith<$Res> {
  _$AttributionEntityCopyWithImpl(this._self, this._then);

  final AttributionEntity _self;
  final $Res Function(AttributionEntity) _then;

/// Create a copy of AttributionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? url = freezed,}) {
  return _then(AttributionEntity(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttributionEntity].
extension AttributionEntityPatterns on AttributionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttributionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttributionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttributionEntity value)  $default,){
final _that = this;
switch (_that) {
case _AttributionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttributionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AttributionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  Uri? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttributionEntity() when $default != null:
return $default(_that.text,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  Uri? url)  $default,) {final _that = this;
switch (_that) {
case _AttributionEntity():
return $default(_that.text,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  Uri? url)?  $default,) {final _that = this;
switch (_that) {
case _AttributionEntity() when $default != null:
return $default(_that.text,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _AttributionEntity implements AttributionEntity {
  const _AttributionEntity({required this.text, this.url});
  

@override final  String text;
@override final  Uri? url;

/// Create a copy of AttributionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttributionEntityCopyWith<_AttributionEntity> get copyWith => __$AttributionEntityCopyWithImpl<_AttributionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttributionEntity&&(identical(other.text, text) || other.text == text)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,url);
}

@override
String toString() {
    return 'AttributionEntity(text: $text, url: $url)';
}


}

/// @nodoc
abstract mixin class _$AttributionEntityCopyWith<$Res> implements $AttributionEntityCopyWith<$Res> {
  factory _$AttributionEntityCopyWith(_AttributionEntity value, $Res Function(_AttributionEntity) _then) = __$AttributionEntityCopyWithImpl;
@override @useResult
$Res call({
 String text, Uri? url
});




}
/// @nodoc
class __$AttributionEntityCopyWithImpl<$Res>
    implements _$AttributionEntityCopyWith<$Res> {
  __$AttributionEntityCopyWithImpl(this._self, this._then);

  final _AttributionEntity _self;
  final $Res Function(_AttributionEntity) _then;

/// Create a copy of AttributionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? url = freezed,}) {
  return _then(_AttributionEntity(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as Uri?,
  ));
}


}

// dart format on
