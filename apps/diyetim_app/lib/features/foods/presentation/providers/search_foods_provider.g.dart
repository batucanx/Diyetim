// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_foods_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ekrandaki arama metni (gecikmeli). Görünüm her tuşta değil, yazma durunca günceller.

@ProviderFor(FoodSearchQuery)
final foodSearchQueryProvider = FoodSearchQueryProvider._();

/// Ekrandaki arama metni (gecikmeli). Görünüm her tuşta değil, yazma durunca günceller.
final class FoodSearchQueryProvider
    extends $NotifierProvider<FoodSearchQuery, String> {
  /// Ekrandaki arama metni (gecikmeli). Görünüm her tuşta değil, yazma durunca günceller.
  FoodSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodSearchQueryHash();

  @$internal
  @override
  FoodSearchQuery create() => FoodSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$foodSearchQueryHash() => r'7031f6be983510931ee878b5dac2df6bf374dea4';

/// Ekrandaki arama metni (gecikmeli). Görünüm her tuşta değil, yazma durunca günceller.

abstract class _$FoodSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.

@ProviderFor(SearchFoods)
final searchFoodsProvider = SearchFoodsFamily._();

/// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.
final class SearchFoodsProvider
    extends $AsyncNotifierProvider<SearchFoods, FoodSearchPageEntity> {
  /// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.
  SearchFoodsProvider._({
    required SearchFoodsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'searchFoodsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchFoodsHash();

  @override
  String toString() {
    return r'searchFoodsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SearchFoods create() => SearchFoods();

  @override
  bool operator ==(Object other) {
    return other is SearchFoodsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchFoodsHash() => r'edc24f9b6be03a85145824a30cca6731ca839b4e';

/// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.

final class SearchFoodsFamily extends $Family
    with
        $ClassFamilyOverride<
          SearchFoods,
          AsyncValue<FoodSearchPageEntity>,
          FoodSearchPageEntity,
          FutureOr<FoodSearchPageEntity>,
          String
        > {
  SearchFoodsFamily._()
    : super(
        retry: null,
        name: r'searchFoodsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.

  SearchFoodsProvider call(String query) =>
      SearchFoodsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchFoodsProvider';
}

/// Bir arama metninin sonuçları. Metin değişince eski aile örneği bırakılır; geç gelen eski yanıt yeni sonucu ezmez.

abstract class _$SearchFoods extends $AsyncNotifier<FoodSearchPageEntity> {
  late final _$args = ref.$arg as String;
  String get query => _$args;

  FutureOr<FoodSearchPageEntity> build(String query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<FoodSearchPageEntity>, FoodSearchPageEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<FoodSearchPageEntity>,
                FoodSearchPageEntity
              >,
              AsyncValue<FoodSearchPageEntity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
