# 0002 · "Bugün" ekranının içerik hiyerarşisi

Tarih: 28 Ekim 2026 · Durum: kabul edildi

## Karar

Danışan uygulamasının "Bugün" ekranı yukarıdan aşağıya:

1. **Diyetisyen notu** — diyetisyenin en son notu: kim yazdı (avatar + ad), ne zaman, metin. Kaynak etiketi
   `dietitian`. Not yoksa bu bölüm hiç çizilmez (boş kart gösterilmez).
2. **Öğünler** — günün öğünleri sırayla: ad, saat, içerik özeti, kalori ve durum (`DyMealStatus`).
   Durum etiketi `meta` satırında, kalori `trailing`'de.

Kalori halkası ve makrolar bu sürümde "Bugün"de yer almaz; ilerleme sekmesinin konusudur.

## Neden

Danışanın günü diyetisyenin yönlendirmesiyle başlar: not, öğünlerin nasıl okunacağını belirler
("Bugün kahvaltıda yumurtayı atlama"). Not öğünlerin altında kalırsa kaydırılmadan görülmez.

## Davranış

- Yükleme: not ve öğün listesi için ayrı iskeletler, gerçek içerikle aynı ölçüde (yerleşim kaymaz).
- Hata: tek `DyErrorState` + "Tekrar dene"; not ve öğünler aynı uç noktadan geldiği için ayrı hata yok.
- Öğün yok: `DyEmptyState` ("Diyetisyenin henüz bugünün planını yayınlamadı").
- Uzun not: ilk 4 satır, "Devamını oku" ile genişler.
