import 'package:dy_ui/dy_ui.dart';
import 'package:flutter/material.dart';

/// Entegrasyon denetimi: "Bugün" yalnızca kütüphane component'lerinden birleştirilir.
/// Bu bir ekran tasarımı değildir; Faz 3'teki gerçek ekranın içeriği ve hiyerarşisi ayrıca tasarlanacaktır.
/// Amaç: A–E gruplarının tema, ölçek, semantik ve yerleşim açısından birlikte çalıştığını göstermek.
class IntegrationToday extends StatelessWidget {
  const IntegrationToday({super.key, this.offline = true});
  final bool offline;

  @override
  Widget build(BuildContext context) {
    final dy = context.dy;
    return Scaffold(
      backgroundColor: dy.colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(DySize.appBar),
        child: DyAppBar(title: 'Bugün', actions: [DyIconButton(icon: DyIcons.bell, label: 'Bildirimler', onPressed: () {})]),
      ),
      body: ListView(padding: const EdgeInsets.all(DySpacing.lg), children: [
        if (offline) ...[DyOfflineState(pendingCount: 2, onRetry: () {}), const SizedBox(height: DySpacing.lg)],
        DyCard(
          variant: DyCardVariant.hero,
          child: Wrap(spacing: DySpacing.lg, runSpacing: DySpacing.lg, crossAxisAlignment: WrapCrossAlignment.center, children: [
            DyProgressRing(
              value: 859,
              max: 1800,
              label: 'Kalori',
              valueText: '859 / 1.800 kcal',
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const DyNumber(941, style: DyTextStyle.numericLg, fractionDigits: 0),
                Text('kcal kaldı', style: dy.text(DyTextStyle.caption, tone: DyTextTone.muted)),
              ]),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: DySize.sidebar),
              child: const Column(mainAxisSize: MainAxisSize.min, spacing: DySpacing.sm, children: [
                DyProgressBar(value: 142, max: 220, label: 'Karbonhidrat', valueText: '142 / 220 g', tone: DyProgressTone.carb, showLabel: true, compact: true),
                DyProgressBar(value: 68, max: 120, label: 'Protein', valueText: '68 / 120 g', tone: DyProgressTone.protein, showLabel: true, compact: true),
                DyProgressBar(value: 41, max: 60, label: 'Yağ', valueText: '41 / 60 g', tone: DyProgressTone.fat, showLabel: true, compact: true),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: DySpacing.lg),
        DyCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const DyCardHeader(title: 'Öğünler', subtitle: '2 / 4 kaydedildi'),
            DyList(semanticLabel: 'Bugünkü öğünler', children: [
              DyListItem(leading: const DyIcon(DyIcons.leaf), title: 'Kahvaltı', description: 'Yulaf, yoğurt, ceviz', trailing: const Text('320 kcal'), meta: [DyStatusTag(DyMealStatus.approved.style)], onTap: () {}),
              DyListItem(leading: const DyIcon(DyIcons.flame), title: 'Öğle yemeği', description: 'Mercimek çorbası, salata', trailing: const Text('540 kcal'), meta: [DyStatusTag(DyMealStatus.pendingReview.style)], onTap: () {}),
              DyListItem(leading: const DyIcon(DyIcons.clock), title: 'Akşam yemeği', description: 'Somon, bulgur', trailing: const Text('19:00'), meta: [DyStatusTag(DyMealStatus.planned.style)], onTap: () {}),
            ]),
          ]),
        ),
        const SizedBox(height: DySpacing.lg),
        const DyStatCard(label: 'Kilo', value: null, visibility: DyVisibility.hidden),
      ]),
      bottomNavigationBar: DyBottomNavigation(
        selectedIndex: 0,
        onSelected: (_) {},
        centerAction: DyIcons.camera,
        centerActionLabel: 'Öğün fotoğrafı ekle',
        onCenterAction: () {},
        destinations: const [
          DyNavDestination(label: 'Bugün', icon: DyIcons.home),
          DyNavDestination(label: 'Plan', icon: DyIcons.plan),
          DyNavDestination(label: 'İlerleme', icon: DyIcons.chart),
          DyNavDestination(label: 'Profil', icon: DyIcons.user),
        ],
      ),
    );
  }
}
