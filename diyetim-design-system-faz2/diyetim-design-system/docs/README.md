# Diyetim Design System — dokümantasyon

| Belge | İçerik |
| --- | --- |
| [Faz 2 raporu](phase-2-report.md) | Yapılanlar, test sonuçları, doğrulanamayanlar, teknik borç |
| [Platform paritesi](platform-parity.md) | Flutter ↔ React ortak sözleşme ve bilinçli farklar |
| [Primitives](components/Primitives.md) | Text, NumberDisplay, Icon, Surface, Stack, Skeleton, Pressable, odak halkası |
| [Button](components/Button.md) | Button, IconButton, Fab |
| [TextField](components/TextField.md) | TextField, SearchField, NumberField, Textarea |
| [Select](components/Select.md) | Select, MultiSelect |
| [Seçim kontrolleri](components/Choice.md) | Checkbox, RadioGroup, Switch, SegmentedControl |
| [Durum ve geri bildirim](components/Feedback.md) | Tag, StatusTag, SourceTag, Badge, Tooltip, Alert, Banner, Toast, EmptyState, ErrorState, OfflineState, LoadingRegion |

Komutlar (depo kökünde):

```bash
pnpm install
pnpm tokens:build        # tokens/*.json + spec/*.json → CSS, TS, Dart
pnpm test                # tokens:check + token testleri + typecheck + web birim testleri
pnpm test:visual         # Playwright: görsel referanslar, axe, %200 ölçek, odak, hareket
cd packages/flutter/dy_ui && flutter test            # widget ve semantik testleri
flutter test --update-goldens --tags golden          # ilk kurulumda golden referansları
```
