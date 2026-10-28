@Tags(['golden'])
library;

import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

/// Görsel referanslar: her grup × light/dark × metin ölçeği 1,0 ve 2,0.
/// İlk kurulum: `flutter test --update-goldens --tags golden` (Nunito font dosyaları test ortamına yüklenir).
void main() {
  Widget buttons() => Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: DySpacing.md, children: [
        DyButton(label: 'Öğünü kaydet', size: DyButtonSize.lg, onPressed: () {}),
        DyButton(label: 'Plana ekle', variant: DyButtonVariant.secondary, iconStart: DyIcons.plus, onPressed: () {}),
        DyButton(label: 'Vazgeç', variant: DyButtonVariant.tertiary, onPressed: () {}),
        DyButton(label: 'Not ekle', variant: DyButtonVariant.ghost, onPressed: () {}),
        DyButton(label: 'Randevuyu iptal et', variant: DyButtonVariant.destructive, onPressed: () {}),
        DyButton(label: 'Kaydediliyor', state: DyComponentState.loading, onPressed: () {}),
        DyButton(label: 'Devre dışı', state: DyComponentState.disabled, onPressed: () {}),
        DyButton(label: 'Besin ekle', state: DyComponentState.locked, lockedReason: 'Kapalı', onPressed: () {}),
        Row(spacing: DySpacing.md, children: [DyIconButton(icon: DyIcons.bell, label: 'Bildirimler', variant: DyIconButtonVariant.surface, onPressed: () {}), DyFab(icon: DyIcons.camera, label: 'Fotoğraf', onPressed: () {})]),
      ]);

  Widget fields() => const Column(spacing: DySpacing.lg, children: [
        DySearchField(label: 'Besin ara', placeholder: 'Yulaf, tavuk, mercimek…'),
        DyTextField(label: 'Ad', placeholder: 'Adın', description: 'Diyetisyenin seni bu adla görür.'),
        DyNumberField(label: 'Gramaj', unit: 'g', value: 150, step: 10),
        DyTextField(label: 'Kilo', initialValue: '6,84', suffix: 'kg', error: 'Bu değer çok düşük görünüyor.'),
        DyTextField(label: 'Porsiyon', initialValue: '1 kase (200 g)', state: DyComponentState.locked, lockedReason: 'Diyetisyenin gramaj değişikliğini kapattı.'),
        DyTextarea(label: 'Not', initialValue: 'Harika bir tabak!', maxLength: 200),
      ]);

  Widget choices() => Column(spacing: DySpacing.md, children: [
        DyCheckbox(label: 'Hatırlatma al', description: 'Öğün saatinden 15 dk önce', value: true, onChanged: (_) {}),
        DyCheckbox(label: 'Tümünü seç', value: null, onChanged: (_) {}),
        DyCheckbox(label: 'Fotoğraf zorunlu', value: true, state: DyComponentState.locked, lockedReason: 'Klinik ayarı', onChanged: (_) {}),
        DySwitch(label: 'Kilo ve BMI', description: 'Danışan kendi kilosunu görür', value: true, onChanged: (_) {}),
        DySwitch(label: 'Kalori değerleri', value: false, onChanged: (_) {}),
        DySegmentedControl<String>(label: 'Dönem', value: 'w', onChanged: (_) {}, segments: const [DySegment(value: 'd', label: 'Gün'), DySegment(value: 'w', label: 'Hafta'), DySegment(value: 'm', label: 'Ay')]),
      ]);

  Widget data() => Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: DySpacing.md, children: [
        DyCard(variant: DyCardVariant.hero, child: DyList(children: [
          DyListItem(leading: const DyIcon(DyIcons.leaf), title: 'Kahvaltı', description: 'Yulaf, yoğurt, ceviz', trailing: DyStatusTag(DyMealStatus.approved.style), onTap: () {}),
          DyListItem(leading: const DyIcon(DyIcons.flame), title: 'Öğle yemeği', description: 'Onay bekliyor', trailing: DyStatusTag(DyMealStatus.pendingReview.style), onTap: () {}),
        ])),
        const Row(spacing: DySpacing.md, children: [
          DyProgressRing(value: 859, max: 1800, label: 'Kalori', size: DyProgressRingSize.md, child: Text('%48')),
          DyAvatar(name: 'Zeynep Kaya', verified: true, size: DyAvatarSize.lg),
          DyAvatarGroup(label: 'Randevular', people: [DyAvatarPerson(name: 'Elif Yıldız'), DyAvatarPerson(name: 'Şule Demir'), DyAvatarPerson(name: 'İsmail Işık'), DyAvatarPerson(name: 'Ömer Çelik')]),
        ]),
        const DyProgressBar(value: 142, max: 220, label: 'Karbonhidrat', valueText: '142 / 220 g', tone: DyProgressTone.carb, showLabel: true),
        const DyProgressBar(value: 68, max: 120, label: 'Protein', valueText: '68 / 120 g', tone: DyProgressTone.protein, showLabel: true),
        const DyStatCard(label: 'Onay bekleyen öğün', value: 12, delta: -5, deltaIntent: DyDeltaIntent.decreaseIsGood, deltaContext: 'dünden', icon: DyIcons.clock),
        DyFilterChips(label: 'Durum', options: const [DyFilterOption(value: 'a', label: 'Dikkat', count: 4), DyFilterOption(value: 'n', label: 'Yeni')], values: const {'a'}, onChanged: (_) {}),
      ]);

  final groups = {'buttons': buttons, 'fields': fields, 'choices': choices, 'data': data};
  for (final g in groups.entries) {
    for (final b in Brightness.values) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('golden ${g.key} ${b.name} ${scale}x', (tester) async {
          await pumpDy(tester, g.value(), brightness: b, textScale: scale, height: 1400, disableAnimations: true);
          await expectLater(find.byType(Scaffold), matchesGoldenFile('goldens/${g.key}_${b.name}_${scale}x.png'));
        });
      }
    }
  }
}
