# 0001 · Besin veri kaynağı: FatSecret, backend üzerinden

Tarih: 28 Ekim 2026 · Durum: kabul edildi

## Karar

Besin arama ve besin değerleri FatSecret Platform API'den gelir. İstemci FatSecret'a hiç bağlanmaz:

```
Flutter ──GET /api/foods/search?q=mercimek──▶ Diyetim Backend ──▶ FatSecret API
Flutter ◀──────── Diyetim besin modeli ─────── Backend (normalleştirir, önbellekler)
```

## Neden backend üzerinden

- FatSecret kimlik bilgileri (OAuth 2.0 client credentials) uygulama paketine girmez.
- Backend yanıtı Diyetim'in kendi modeline çevirir (`docs/api/openapi.yaml`). Sağlayıcı değişirse
  (Premier, TÜRKOMP, diyetisyenin kendi besinleri) Flutter değişmez.
- Önbellek ve kota yönetimi tek yerde.

## FatSecret planlarının etkisi (platform.fatsecret.com/api-editions, 28 Ekim 2026)

| | Basic (ücretsiz) | Premier (ücretli) |
| --- | --- | --- |
| Bölge | **Yalnız ABD** | 62+ ülke, Türkiye (`region=TR`, `language=tr`) dahil |
| Atıf | **Zorunlu** | Gerekmez |
| Kota | 5.000 çağrı/gün | Sınırsız |

Sonuçlar:

1. **Basic ile Türkçe arama sonuçları ABD veritabanından gelir.** "mercimek", "ayran", "simit" gibi aramalar
   zayıf ya da boş dönebilir. Türk kullanıcılar için Premier (ya da yerel bir ek kaynak) ürün kararıdır;
   geliştirme Basic ile başlayabilir.
2. **Atıf API'den gelir.** Yanıt `attribution` alanı taşır; Basic'te istemci "Powered by fatsecret"
   bağlantısını gösterir, Premier'de alan `null` gelir ve gösterilmez. İstemcide sağlayıcı adı sabit yazılmaz.
3. **Backend önbelleği zorunlu.** Arama sonuçları ve besin ayrıntıları önbelleklenir; kota dolduğunda
   backend `503` + `QUOTA_EXCEEDED` döner, istemci önbellekteki son sonucu ya da hata durumunu gösterir.

## Açık kalanlar

- Backend teknolojisi ve barındırma.
- Premier başvurusu (fiyat talep üzerine, pazara göre).
- FatSecret kullanım koşullarında veri saklama süresi sınırı olup olmadığı (önbellek süresini belirler).
