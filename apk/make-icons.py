"""Generate launcher icons + splash dari logo notedwork (icon-512.png).

- mipmap ic_launcher(.png) & ic_launcher_round(.png): resize logo per densitas.
- mipmap ic_launcher_foreground(.png): logo di atas background #0A0C10
  (adaptive icon = background color + foreground, jadi foreground dikasih
  padding agar aman dari potongan lingkaran launcher).
- drawable*/splash.png: logo di tengah canvas #0A0C10 sesuai ukuran bawaan.
- ponytail: 1 sumber PNG (ceiling: logo statis); upgrade ke Image Asset
  Studio saat butuh padding/mask presisi per OEM.
"""
from PIL import Image
import os
import sys

BG = (10, 12, 16, 255)  # #0A0C10 — samakan theme_color web
# Bisa dioverride: python make-icons.py [path-icon-512.png]
# Default: folder web C:/Project/notedwork/public/icon-512.png
SRC = sys.argv[1] if len(sys.argv) > 1 else os.environ.get(
    "NOTEDWORK_ICON", "C:/Project/notedwork/public/icon-512.png"
)

DENS = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
FG = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}
SPLASH = {
    "drawable/splash.png": (480, 320),
    "drawable-land-hdpi/splash.png": (800, 480),
    "drawable-land-mdpi/splash.png": (480, 320),
    "drawable-land-xhdpi/splash.png": (1280, 720),
    "drawable-land-xxhdpi/splash.png": (1600, 960),
    "drawable-land-xxxhdpi/splash.png": (1920, 1280),
    "drawable-port-hdpi/splash.png": (480, 800),
    "drawable-port-mdpi/splash.png": (320, 480),
    "drawable-port-xhdpi/splash.png": (720, 1280),
    "drawable-port-xxhdpi/splash.png": (960, 1600),
    "drawable-port-xxxhdpi/splash.png": (1280, 1920),
}

logo = Image.open(SRC).convert("RGBA")
res = "android/app/src/main/res"

for dens, size in DENS.items():
    icon = logo.resize((size, size), Image.LANCZOS)
    icon.save(f"{res}/mipmap-{dens}/ic_launcher.png")
    icon.save(f"{res}/mipmap-{dens}/ic_launcher_round.png")
    print(f"launcher {dens} {size}x{size}")

for dens, size in FG.items():
    canvas = Image.new("RGBA", (size, size), BG)
    inner = int(size * 0.66)  # safe zone adaptive icon
    small = logo.resize((inner, inner), Image.LANCZOS)
    canvas.alpha_composite(small, ((size - inner) // 2,) * 2)
    fg = canvas.convert("RGB")
    fg.save(f"{res}/mipmap-{dens}/ic_launcher_foreground.png")
    print(f"foreground {dens} {size}x{size}")

for rel, (w, h) in SPLASH.items():
    canvas = Image.new("RGBA", (w, h), BG)
    side = int(min(w, h) * 0.45)
    small = logo.resize((side, side), Image.LANCZOS)
    canvas.alpha_composite(small, ((w - side) // 2, (h - side) // 2))
    canvas.convert("RGB").save(f"{res}/{rel}")
    print(f"splash {rel} {w}x{h}")

print("OK")
