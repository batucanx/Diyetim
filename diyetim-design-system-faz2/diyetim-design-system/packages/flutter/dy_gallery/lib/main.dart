import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

void main() => runApp(const DyGallery());

const _long = 'Diyetisyenime bugünkü tüm öğünlerimi onay için gönder; ğüşıöç İ harfleri kırpılmamalı';

/// Widgetbook kataloğu: her component için gerçek API ile kullanım örnekleri.
/// Eklentiler: tema (light/dark), metin ölçeği (1,0–2,0), cihaz boyutu, semantik görünümü.
class DyGallery extends StatelessWidget {
  const DyGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(themes: [
          WidgetbookTheme(name: 'Light', data: DyTheme.light()),
          WidgetbookTheme(name: 'Dark', data: DyTheme.dark()),
        ]),
        TextScaleAddon(min: 1.0, max: 2.0, divisions: 4),
        ViewportAddon([IosViewports.iPhone13, AndroidViewports.samsungGalaxyS20, MacosViewports.macbookPro]),
        AlignmentAddon(),
      ],
      directories: [
        WidgetbookCategory(name: 'A · Primitives', children: [
          WidgetbookComponent(name: 'DyText', useCases: [
            WidgetbookUseCase(name: 'Tipografi ölçeği', builder: (context) => _pad(DyStack(gap: DySpacing.sm, children: [
                  for (final s in DyTextStyle.values) DyText(context.knobs.boolean(label: 'Uzun metin') ? _long : '${s.wire} · Günaydın, Elif', style: s),
                ]))),
          ]),
          WidgetbookComponent(name: 'DyNumber', useCases: [
            WidgetbookUseCase(name: 'Değer, birim, gizli, boş', builder: (context) => _pad(DyStack(gap: DySpacing.md, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  DyNumber(context.knobs.double.input(label: 'Değer', initialValue: 941), unit: context.knobs.string(label: 'Birim', initialValue: 'kcal'), style: DyTextStyle.numericXl, label: 'Kalan kalori'),
                  const DyNumber(68.4, unit: 'kg', style: DyTextStyle.numericLg),
                  const DyNumber(0.48, format: DyNumberFormat.percent),
                  const DyNumber(null, unit: 'mg/dL'),
                  const DyNumber(null, visibility: DyVisibility.hidden, label: 'Kilo'),
                ]))),
          ]),
          WidgetbookComponent(name: 'DyIcon', useCases: [
            WidgetbookUseCase(name: 'İkon seti', builder: (context) => _pad(Wrap(spacing: DySpacing.lg, runSpacing: DySpacing.lg, children: [
                  for (final i in DyIcons.all) Tooltip(message: i.name, child: DyIcon(i, size: DyIconSize.lg)),
                ]))),
          ]),
          WidgetbookComponent(name: 'DySurface', useCases: [
            WidgetbookUseCase(name: 'Katman ve derinlik', builder: (context) => _pad(DyStack(children: [
                  for (final e in DyElevation.values)
                    DySurface(elevation: e, padding: const EdgeInsets.all(DySpacing.xl), child: DyText('elevation ${e.wire}', style: DyTextStyle.h4)),
                  for (final l in DySurfaceLevel.values)
                    DySurface(level: l, padding: const EdgeInsets.all(DySpacing.lg), radius: DyRadius.md, child: DyText('surface ${l.wire}', tone: l == DySurfaceLevel.inverse ? DyTextTone.onInverse : DyTextTone.primary)),
                ]))),
          ]),
          WidgetbookComponent(name: 'DySkeleton', useCases: [
            WidgetbookUseCase(name: 'Öğün kartı iskeleti', builder: (context) => _pad(const DySurface(padding: EdgeInsets.all(DySpacing.xl), child: Row(spacing: DySpacing.lg, children: [
                  DySkeleton(width: DySize.fab, height: DySize.fab, radius: DyRadius.md),
                  Expanded(child: DySkeleton(shape: DySkeletonShape.text, lines: 3)),
                ])))),
          ]),
        ]),
        WidgetbookCategory(name: 'B · Form ve giriş', children: [
          WidgetbookComponent(name: 'DyButton', useCases: [
            WidgetbookUseCase(name: 'Etkileşimli', builder: (context) => _pad(DyButton(
                  label: context.knobs.string(label: 'Etiket', initialValue: 'Öğünü kaydet'),
                  variant: context.knobs.object.dropdown(label: 'Varyant', options: DyButtonVariant.values, labelBuilder: (v) => v.wire),
                  size: context.knobs.object.dropdown(label: 'Boyut', options: DyButtonSize.values, initialOption: DyButtonSize.md, labelBuilder: (v) => v.wire),
                  state: context.knobs.object.dropdown(label: 'Durum', options: DyComponentState.values, labelBuilder: (v) => v.wire),
                  lockedReason: 'Plan dışı ekleme kapalı',
                  fullWidth: context.knobs.boolean(label: 'Tam genişlik'),
                  onPressed: () {},
                ))),
            WidgetbookUseCase(name: 'Tüm varyantlar', builder: (context) => _pad(DyStack(gap: DySpacing.md, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (final v in DyButtonVariant.values) DyButton(label: v.wire, variant: v, onPressed: () {}),
                  DyButton(label: 'Kaydediliyor', state: DyComponentState.loading, onPressed: () {}),
                  DyButton(label: 'Besin ekle', state: DyComponentState.locked, lockedReason: 'Kapalı', onPressed: () {}),
                  Row(spacing: DySpacing.md, children: [
                    DyIconButton(icon: DyIcons.bell, label: 'Bildirimler', variant: DyIconButtonVariant.surface, onPressed: () {}),
                    DyFab(icon: DyIcons.camera, label: 'Öğün fotoğrafı çek', onPressed: () {}),
                  ]),
                ]))),
          ]),
          WidgetbookComponent(name: 'DyTextField', useCases: [
            WidgetbookUseCase(name: 'Durumlar', builder: (context) => _pad(DyStack(children: [
                  DyTextField(label: 'Ad', placeholder: 'Adın', description: 'Diyetisyenin seni bu adla görür.',
                      state: context.knobs.object.dropdown(label: 'Durum', options: DyComponentState.values, labelBuilder: (v) => v.wire), lockedReason: 'Kapalı',
                      error: context.knobs.boolean(label: 'Hata') ? 'Bu alan zorunlu.' : null),
                  const DyTextField(label: 'E-posta', initialValue: 'elif@ornek.com', success: 'Doğrulandı'),
                  const DyTextField(label: 'Porsiyon', initialValue: '1 kase (200 g)', state: DyComponentState.locked, lockedReason: 'Diyetisyenin gramaj değişikliğini kapattı.'),
                  const DySearchField(label: 'Besin ara', placeholder: 'Yulaf, tavuk, mercimek…'),
                  const _NumberDemo(),
                  const DyTextarea(label: 'Diyetisyen notu', maxLength: 200),
                ]))),
          ]),
          WidgetbookComponent(name: 'DySelect', useCases: [
            WidgetbookUseCase(name: 'Tek ve çoklu', builder: (context) => _pad(const _SelectDemo())),
          ]),
          WidgetbookComponent(name: 'Seçim kontrolleri', useCases: [
            WidgetbookUseCase(name: 'Checkbox · Radio · Switch · Segmented', builder: (context) => _pad(const _ChoiceDemo())),
          ]),
        ]),
        WidgetbookCategory(name: 'C · Durum ve geri bildirim', children: [
          WidgetbookComponent(name: 'DyTag', useCases: [
            WidgetbookUseCase(name: 'Durum etiketleri', builder: (context) => _pad(Wrap(spacing: DySpacing.sm, runSpacing: DySpacing.sm, children: [
                  for (final s in DyMealStatus.values) DyStatusTag(s.style),
                  for (final s in DyAppointmentStatus.values) DyStatusTag(s.style),
                  for (final s in DyLabValueStatus.values) DyStatusTag(s.style),
                  for (final s in DyDataSource.values) DySourceTag(s),
                  const DyBadge(count: 3, label: '3 bildirim'),
                  const DyBadge(count: 240, label: '240 bildirim', tone: DyBadgeTone.neutral),
                ]))),
          ]),
          WidgetbookComponent(name: 'DyAlert', useCases: [
            WidgetbookUseCase(name: 'Tonlar', builder: (context) => _pad(DyStack(children: [
                  for (final t in DyFeedbackTone.values) DyAlert(title: 'Başlık · ${t.wire}', tone: t, message: 'Açıklama metni.', onDismiss: () {}),
                  DyTooltip(message: 'Öğün fotoğrafı çek', child: DyIconButton(icon: DyIcons.camera, label: 'Kamera', variant: DyIconButtonVariant.surface, onPressed: () {})),
                ]))),
          ]),
          WidgetbookComponent(name: 'DyToast', useCases: [
            WidgetbookUseCase(name: 'Snackbar', builder: (context) => _pad(Builder(builder: (context) => DyButton(label: 'Göster', onPressed: () => DyToast.show(context, message: 'Öğle öğünü kaydedildi', actionLabel: 'Geri al', onAction: () {}))))),
          ]),
          WidgetbookComponent(name: 'Durum ekranları', useCases: [
            WidgetbookUseCase(name: 'Boş', builder: (context) => DyEmptyState(title: 'Bugün için öğün yok', description: 'Diyetisyenin henüz bugünün planını yayınlamadı.', action: DyButton(label: 'Besin ara', iconStart: DyIcons.search, onPressed: () {}))),
            WidgetbookUseCase(name: 'Hata', builder: (context) => DyErrorState(kind: context.knobs.object.dropdown(label: 'Tür', options: DyErrorKind.values, labelBuilder: (k) => k.wire), onAction: () {})),
            WidgetbookUseCase(name: 'Çevrimdışı', builder: (context) => DyOfflineState(pendingCount: context.knobs.int.slider(label: 'Bekleyen', initialValue: 3, min: 0, max: 20), onRetry: () {})),
          ]),
        ]),
      ],
    );
  }
}

Widget _pad(Widget child) => SingleChildScrollView(padding: const EdgeInsets.all(DySpacing.xl), child: child);

class _NumberDemo extends StatefulWidget {
  const _NumberDemo();
  @override
  State<_NumberDemo> createState() => _NumberDemoState();
}

class _NumberDemoState extends State<_NumberDemo> {
  double? v = 150;
  @override
  Widget build(BuildContext context) => DyNumberField(label: 'Gramaj', unit: 'g', value: v, step: 10, min: 0, max: 1000, onChanged: (x) => setState(() => v = x));
}

class _SelectDemo extends StatefulWidget {
  const _SelectDemo();
  @override
  State<_SelectDemo> createState() => _SelectDemoState();
}

class _SelectDemoState extends State<_SelectDemo> {
  String? meal = 'lunch';
  Set<String> cats = {'sut'};
  static const meals = [
    DySelectOption(value: 'breakfast', label: 'Kahvaltı'),
    DySelectOption(value: 'lunch', label: 'Öğle yemeği'),
    DySelectOption(value: 'dinner', label: 'Akşam yemeği', enabled: false),
    DySelectOption(value: 'snack', label: 'Ara öğün', description: 'İkindi veya gece'),
  ];
  static const categories = [DySelectOption(value: 'sut', label: 'Süt ürünleri'), DySelectOption(value: 'sebze', label: 'Sebze'), DySelectOption(value: 'tahil', label: 'Tahıl')];

  @override
  Widget build(BuildContext context) => DyStack(children: [
        DySelect<String>(label: 'Öğün tipi', options: meals, value: meal, onChanged: (v) => setState(() => meal = v)),
        DyMultiSelect<String>(label: 'Kategoriler', options: categories, values: cats, onChanged: (v) => setState(() => cats = v)),
        const DySelect<String>(label: 'Kilitli', options: meals, value: 'breakfast', state: DyComponentState.locked, lockedReason: 'Diyetisyen belirledi'),
        const DySelect<String>(label: 'Hata', options: meals, value: null, error: 'Öğün tipi seçin.'),
      ]);
}

class _ChoiceDemo extends StatefulWidget {
  const _ChoiceDemo();
  @override
  State<_ChoiceDemo> createState() => _ChoiceDemoState();
}

class _ChoiceDemoState extends State<_ChoiceDemo> {
  bool remind = true;
  bool weight = true;
  bool calories = false;
  String type = 'online';
  String period = 'w';

  @override
  Widget build(BuildContext context) => DyStack(children: [
        DyCheckbox(label: 'Hatırlatma al', description: 'Öğün saatinden 15 dk önce', value: remind, onChanged: (v) => setState(() => remind = v)),
        DyCheckbox(label: 'Tümünü seç', value: null, onChanged: (_) {}),
        DyCheckbox(label: 'Fotoğraf zorunlu', value: true, state: DyComponentState.locked, lockedReason: 'Klinik ayarı', onChanged: (_) {}),
        DyRadioGroup<String>(label: 'Görüşme tipi', value: type, onChanged: (v) => setState(() => type = v), options: const [
          DyRadioOption(value: 'online', label: 'Online (15 dk)'),
          DyRadioOption(value: 'clinic', label: 'Yüz yüze'),
          DyRadioOption(value: 'phone', label: 'Telefon', enabled: false),
        ]),
        DySurface(padding: const EdgeInsets.all(DySpacing.lg), child: DyStack(gap: DySpacing.md, children: [
          DySwitch(label: 'Kilo ve BMI', description: 'Danışan kendi kilosunu görür', value: weight, onChanged: (v) => setState(() => weight = v)),
          DySwitch(label: 'Kalori değerleri', description: 'Kapalıyken halka rakamsız gösterilir', value: calories, onChanged: (v) => setState(() => calories = v)),
          DySwitch(label: 'Öğün fotoğrafı zorunlu', value: true, state: DyComponentState.locked, lockedReason: 'Klinik ayarı', onChanged: (_) {}),
        ])),
        DySegmentedControl<String>(label: 'Dönem', value: period, onChanged: (v) => setState(() => period = v), segments: const [
          DySegment(value: 'd', label: 'Gün'), DySegment(value: 'w', label: 'Hafta'), DySegment(value: 'm', label: 'Ay'),
        ]),
      ]);
}
