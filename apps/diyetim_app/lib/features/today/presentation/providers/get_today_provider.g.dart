// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_today_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetToday)
final getTodayProvider = GetTodayProvider._();

final class GetTodayProvider
    extends $AsyncNotifierProvider<GetToday, TodayEntity> {
  GetTodayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodayProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodayHash();

  @$internal
  @override
  GetToday create() => GetToday();
}

String _$getTodayHash() => r'a76062e12c574ca56130237c62a10560a5fa56e1';

abstract class _$GetToday extends $AsyncNotifier<TodayEntity> {
  FutureOr<TodayEntity> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TodayEntity>, TodayEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TodayEntity>, TodayEntity>,
              AsyncValue<TodayEntity>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
