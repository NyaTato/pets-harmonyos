"""Replace unlicensed demo photos with reproducible, self-drawn JPEG placeholders."""

from hashlib import sha256
from pathlib import Path
from shutil import copy2

from PIL import Image, ImageDraw


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "entry/src/main/resources/rawfile"
BACKUP = ROOT / ".asset_backup/rawfile"


def draw_placeholder(path: Path) -> None:
    digest = sha256(path.name.encode("utf-8")).digest()
    background = tuple(185 + digest[i] % 48 for i in range(3))
    accent = tuple(50 + digest[i + 3] % 90 for i in range(3))
    image = Image.new("RGB", (640, 480), background)
    canvas = ImageDraw.Draw(image)
    if path.parent.name == "pets":
        canvas.ellipse((235, 175, 405, 345), fill=accent)
        for x, y in ((230, 145), (290, 115), (350, 115), (410, 145)):
            canvas.ellipse((x - 27, y - 27, x + 27, y + 27), fill=accent)
    else:
        canvas.ellipse((255, 95, 385, 225), fill=accent)
        canvas.ellipse((175, 240, 465, 515), fill=accent)
    canvas.rectangle((0, 0, 639, 479), outline=accent, width=10)
    image.save(path, format="JPEG", quality=85, exif=b"")


def draw_icon(path: Path) -> None:
    size = (144, 144) if path.name == "startIcon.png" else (1024, 1024)
    width, height = size
    if path.name == "background.png":
        image = Image.new("RGBA", size, (232, 247, 245, 255))
    else:
        image = Image.new("RGBA", size, (0, 0, 0, 0))
        canvas = ImageDraw.Draw(image)
        color = (19, 135, 127, 255)
        scale = width / 1024
        def box(coords: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
            return tuple(round(value * scale) for value in coords)
        canvas.ellipse(box((360, 470, 665, 735)), fill=color)
        for x, y in ((335, 405), (445, 335), (570, 335), (685, 405)):
            canvas.ellipse(box((x - 55, y - 55, x + 55, y + 55)), fill=color)
    image.save(path, format="PNG")


def main() -> None:
    replaced = 0
    for category in ("pets", "avatars"):
        for path in sorted((ASSETS / category).glob("*.jpg")):
            relative = path.relative_to(ASSETS)
            backup = BACKUP / relative
            if not backup.exists():
                backup.parent.mkdir(parents=True, exist_ok=True)
                copy2(path, backup)
            draw_placeholder(path)
            replaced += 1
    icons = [*sorted((ROOT / "AppScope/resources/base/media").glob("*.png")),
             *sorted((ROOT / "entry/src/main/resources/base/media").glob("*.png"))]
    for path in icons:
        backup = ROOT / ".asset_backup" / path.relative_to(ROOT)
        if not backup.exists():
            backup.parent.mkdir(parents=True, exist_ok=True)
            copy2(path, backup)
        draw_icon(path)
    print(f"Replaced {replaced} JPEG photos and {len(icons)} PNG icons; originals remain in ignored .asset_backup/")


if __name__ == "__main__":
    main()
