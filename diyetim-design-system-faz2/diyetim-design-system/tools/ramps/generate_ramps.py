"""Diyetim primitive renk rampaları: OKLCH parametrelerinden sRGB hex üretir (yazım aracı, build'in parçası değil)."""
import json, math
from pathlib import Path


def oklch_to_srgb(L, C, h):
    a = C * math.cos(math.radians(h)); b = C * math.sin(math.radians(h))
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l, m, s = l_ ** 3, m_ ** 3, s_ ** 3
    r = 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s
    g = -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s
    bb = -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
    return r, g, bb

def enc(x):
    return 12.92 * x if x <= 0.0031308 else 1.055 * x ** (1 / 2.4) - 0.055

def to_hex(L, C, h):
    c = C
    while True:
        rgb = oklch_to_srgb(L, c, h)
        if all(-1e-4 <= v <= 1 + 1e-4 for v in rgb) or c <= 0:
            break
        c -= 0.002
    rgb = [min(1, max(0, enc(max(0, v)))) for v in rgb]
    return "#" + "".join(f"{round(v * 255):02X}" for v in rgb)

def lum(hexc):
    v = [int(hexc[i:i + 2], 16) / 255 for i in (1, 3, 5)]
    v = [x / 12.92 if x <= 0.04045 else ((x + 0.055) / 1.055) ** 2.4 for x in v]
    return 0.2126 * v[0] + 0.7152 * v[1] + 0.0722 * v[2]

def contrast(a, b):
    la, lb = sorted([lum(a), lum(b)], reverse=True)
    return (la + 0.05) / (lb + 0.05)

STEPS = ["25", "50", "100", "200", "300", "400", "500", "600", "700", "800", "900", "950"]
LIGHT = [0.985, 0.968, 0.935, 0.885, 0.805, 0.705, 0.600, 0.520, 0.440, 0.360, 0.285, 0.215]
CHROMA_SHAPE = [0.10, 0.18, 0.32, 0.52, 0.78, 0.95, 1.0, 0.95, 0.85, 0.72, 0.58, 0.46]

def ramp(hue, peak):
    return {s: to_hex(L, peak * k, hue) for s, L, k in zip(STEPS, LIGHT, CHROMA_SHAPE)}

def neutral(hue, chroma, lights):
    return {s: to_hex(L, chroma, hue) for s, L in lights.items()}

primitive = {
    "pine": ramp(188, 0.085),
    "stone": {"0": "#FFFFFF", **neutral(75, 0.006, dict(zip(STEPS, [0.988, 0.972, 0.942, 0.900, 0.835, 0.735, 0.620, 0.530, 0.440, 0.330, 0.240, 0.185])))},
    "ink": neutral(175, 0.009, {"25": 0.975, "50": 0.955, "100": 0.925, "200": 0.865, "300": 0.775, "400": 0.665, "500": 0.545, "600": 0.425, "700": 0.335, "750": 0.295, "800": 0.262, "850": 0.232, "900": 0.205, "950": 0.178}),
    "leaf": ramp(148, 0.13),
    "amber": ramp(56, 0.14),
    "brick": ramp(28, 0.16),
    "slate": ramp(252, 0.10),
    "wheat": ramp(86, 0.13),
    "sky": ramp(226, 0.10),
    "plum": ramp(300, 0.095),
    "olive": ramp(122, 0.105),
}

def P(ref):
    fam, step = ref.split(".")
    return primitive[fam][step]

def dtcg_primitive():
    return {"$description": "Primitive renk rampaları. tools/ramps/generate_ramps.py ile OKLCH parametrelerinden üretilir; component'ler doğrudan okumaz.",
            "color": {fam: {s: {"$type": "color", "$value": v} for s, v in r.items()} for fam, r in primitive.items()}}

if __name__ == "__main__":
    # Rampa parametreleri değiştiğinde çalıştırılır. Semantic eşleme tokens/semantic.*.json içinde elle yönetilir.
    target = Path(__file__).resolve().parents[2] / "tokens" / "primitive.color.json"
    target.write_text(json.dumps(dtcg_primitive(), indent=2, ensure_ascii=False) + "\n")
    print("yazıldı:", target)
