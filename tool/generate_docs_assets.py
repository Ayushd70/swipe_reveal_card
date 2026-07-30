#!/usr/bin/env python3
"""Generate docs screenshots and demo GIF for swipe_reveal_card."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "doc"
SHOTS = OUT / "screenshots"
W, H = 780, 400
BG = (242, 244, 248, 255)
CARD = (255, 255, 255, 255)
ACTION_BG = (232, 236, 255, 255)
SHADOW = (0, 0, 0, 28)
PRIMARY = (27, 77, 255)
TEXT = (28, 32, 40)
MUTED = (100, 110, 125)
GREEN = (11, 122, 75)
RED = (211, 47, 47)
AVATAR = (214, 224, 255)


def font(size: int, bold: bool = False) -> ImageFont.ImageFont:
    candidates = [
        (
            "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
            if bold
            else "/System/Library/Fonts/Supplemental/Arial.ttf"
        ),
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def make_frame(progress: float) -> Image.Image:
    """progress 0 = resting, 1 = fully revealed."""
    progress = max(0.0, min(1.0, progress))
    img = Image.new("RGBA", (W, H), BG)
    draw = ImageDraw.Draw(img)

    margin = 48
    card_y = 126
    card_h = 148
    card_w = W - margin * 2
    radius = 20
    max_reveal = 200
    offset = int(-max_reveal * progress)

    # Viewport mimics device width: only the card column is "on screen"
    viewport = (margin, card_y - 20, margin + card_w, card_y + card_h + 20)

    # Action pane (full width of card + revealed area)
    pane = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    pdraw = ImageDraw.Draw(pane)
    pdraw.rounded_rectangle(
        (margin + offset, card_y, margin + card_w, card_y + card_h),
        radius=radius,
        fill=ACTION_BG,
    )

    # Actions text on the right side of the pane (under where card slides away)
    action_f = font(22, bold=True)
    labels = [
        ("✎  Edit", PRIMARY, 22),
        ("▣  Archive", GREEN, 60),
        ("⌫  Delete", RED, 98),
    ]
    ax_text = margin + card_w - 150
    for label, color, y_off in labels:
        pdraw.text((ax_text, card_y + y_off), label, font=action_f, fill=color)

    # Soft shadow
    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(shadow)
    sdraw.rounded_rectangle(
        (
            margin + offset + 2,
            card_y + 10,
            margin + offset + card_w,
            card_y + card_h + 12,
        ),
        radius=radius,
        fill=SHADOW,
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(14))

    # Card body
    card = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    cdraw = ImageDraw.Draw(card)
    cdraw.rounded_rectangle(
        (margin + offset, card_y, margin + offset + card_w, card_y + card_h),
        radius=radius,
        fill=CARD,
    )

    ax, ay = margin + offset + 28, card_y + 42
    cdraw.ellipse((ax, ay, ax + 64, ay + 64), fill=AVATAR)
    cdraw.rectangle((ax + 20, ay + 18, ax + 44, ay + 46), outline=PRIMARY, width=3)
    cdraw.line((ax + 26, ay + 28, ax + 32, ay + 36), fill=PRIMARY, width=3)
    cdraw.line((ax + 32, ay + 36, ax + 42, ay + 22), fill=PRIMARY, width=3)

    title_f = font(28, bold=True)
    sub_f = font(20)
    cdraw.text((ax + 84, card_y + 42), "Ship checklist", font=title_f, fill=TEXT)
    cdraw.text(
        (ax + 84, card_y + 82),
        "Docs, tests, and pub.dev dry-run",
        font=sub_f,
        fill=MUTED,
    )
    cdraw.text(
        (margin + offset + card_w - 48, card_y + 54),
        "‹",
        font=font(36),
        fill=MUTED,
    )

    # Clip everything to the card viewport so resting looks like a normal card
    mask = Image.new("L", (W, H), 0)
    ImageDraw.Draw(mask).rectangle(viewport, fill=255)

    composed = Image.new("RGBA", (W, H), BG)
    for layer in (shadow, pane, card):
        clipped = Image.composite(layer, Image.new("RGBA", (W, H), (0, 0, 0, 0)), mask)
        composed = Image.alpha_composite(composed, clipped)

    return composed.convert("RGB")


def main() -> None:
    SHOTS.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)

    resting = make_frame(0)
    revealed = make_frame(1)
    resting.save(SHOTS / "resting.png", optimize=True)
    revealed.save(SHOTS / "revealed.png", optimize=True)

    frames: list[Image.Image] = []
    for _ in range(10):
        frames.append(resting)
    steps = 14
    for i in range(1, steps + 1):
        frames.append(make_frame(i / steps))
    for _ in range(12):
        frames.append(revealed)
    for i in range(1, steps + 1):
        frames.append(make_frame(1 - i / steps))
    for _ in range(8):
        frames.append(resting)

    frames[0].save(
        OUT / "demo.gif",
        save_all=True,
        append_images=frames[1:],
        duration=65,
        loop=0,
        optimize=True,
    )
    print(f"Wrote {SHOTS / 'resting.png'}")
    print(f"Wrote {SHOTS / 'revealed.png'}")
    print(f"Wrote {OUT / 'demo.gif'}")


if __name__ == "__main__":
    main()
