"""Nunito doğrulaması: Türkçe karakterler, tabular rakamlar (tnum), ağırlık ekseni.

Kullanım: python3 tools/fonts/verify_nunito.py <font.ttf> [--json çıktı.json]
Çıkış kodu: herhangi bir kontrol başarısızsa 1.
"""
import json
import sys
from fontTools.ttLib import TTFont

TURKISH = "çÇğĞıİöÖşŞüÜâÂîÎûÛ"
DIGITS = "0123456789"


def gsub_features(font):
    if "GSUB" not in font:
        return set()
    return {fr.FeatureTag for fr in font["GSUB"].table.FeatureList.FeatureRecord}


def tnum_widths(font):
    """tnum uygulandığında rakam glif genişlikleri; tek değer olmalı."""
    gsub = font["GSUB"].table
    cmap = font.getBestCmap()
    hmtx = font["hmtx"]
    base = {d: cmap[ord(d)] for d in DIGITS}
    mapped = dict(base)
    for fr in gsub.FeatureList.FeatureRecord:
        if fr.FeatureTag != "tnum":
            continue
        for li in fr.Feature.LookupListIndex:
            lookup = gsub.LookupList.Lookup[li]
            for st in lookup.SubTable:
                st = getattr(st, "ExtSubTable", st)
                mapping = getattr(st, "mapping", None)
                if mapping:
                    for d, g in list(mapped.items()):
                        if g in mapping:
                            mapped[d] = mapping[g]
    return {d: hmtx[g][0] for d, g in mapped.items()}, {d: hmtx[g][0] for d, g in base.items()}


def main():
    path = sys.argv[1]
    font = TTFont(path)
    cmap = font.getBestCmap()
    results = []

    missing = [c for c in TURKISH if ord(c) not in cmap]
    results.append({"check": "Bölünmez boşluk U+00A0 (sayı ile birim arası)", "ok": 0x00A0 in cmap, "detail": "var" if 0x00A0 in cmap else "eksik"})
    results.append({"check": "Bilgi: dar bölünmez boşluk U+202F", "ok": True, "info": True,
                    "detail": "var" if 0x202F in cmap else "YOK — DyNumber U+202F üretmemeli, yalnızca U+00A0 kullanır"})
    results.append({"check": "Türkçe karakterler (ç ğ ı İ ö ş ü, şapkalı ünlüler)", "ok": not missing, "detail": f"eksik: {''.join(missing)}" if missing else f"{len(TURKISH)} karakterin tümü var"})

    feats = gsub_features(font)
    # Bilgi amaçlı: Nunito 'tnum' içermez; rakamlar varsayılan olarak eşit genişlikte mi diye her ağırlıkta ölçülür.
    results.append({"check": "Bilgi: OpenType 'tnum' özelliği", "ok": True, "info": True,
                    "detail": ("var" if "tnum" in feats else "YOK — tabular davranış varsayılan rakam genişliklerine dayanır") + f"; GSUB: {', '.join(sorted(feats))}"})
    from fontTools.varLib import instancer
    per_weight = {}
    for w in (400, 500, 600, 700, 800):
        inst = instancer.instantiateVariableFont(TTFont(path), {"wght": w}) if "fvar" in font else font
        c, h = inst.getBestCmap(), inst["hmtx"]
        per_weight[w] = sorted({h[c[ord(d)]][0] for d in DIGITS})
    ok_digits = all(len(v) == 1 for v in per_weight.values())
    results.append({"check": "Varsayılan rakamlar her ağırlıkta eşit genişlik (400–800)", "ok": ok_digits,
                    "detail": ", ".join(f"{w}: {v}" for w, v in per_weight.items())})

    axes = {a.axisTag: (a.minValue, a.maxValue) for a in font["fvar"].axes} if "fvar" in font else {}
    wght = axes.get("wght")
    ok_w = bool(wght) and wght[0] <= 400 and wght[1] >= 800
    results.append({"check": "Ağırlık ekseni 400–800'ü kapsıyor", "ok": ok_w, "detail": f"wght: {wght}"})

    for r in results:
        print(("GEÇTİ " if r["ok"] else "KALDI ") + r["check"] + " — " + r["detail"])
    if "--json" in sys.argv:
        json.dump(results, open(sys.argv[sys.argv.index("--json") + 1], "w"), ensure_ascii=False, indent=2)
    sys.exit(0 if all(r["ok"] for r in results) else 1)


if __name__ == "__main__":
    main()
