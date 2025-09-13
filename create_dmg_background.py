#!/usr/bin/env python3
"""Generate DMG background image.

Creates a 600x450 PNG with a subtle gradient, Mixtral branding,
installation instructions and an arrow pointing right.
"""
import os
import sys
from PIL import Image, ImageDraw, ImageFont

WIDTH, HEIGHT = 600, 450
TOP_COLOR = (245, 245, 245)
BOTTOM_COLOR = (210, 210, 210)
TEXT_COLOR = (20, 20, 20)


def gradient_rect(img):
    draw = ImageDraw.Draw(img)
    for y in range(HEIGHT):
        ratio = y / float(HEIGHT)
        r = int(TOP_COLOR[0] * (1 - ratio) + BOTTOM_COLOR[0] * ratio)
        g = int(TOP_COLOR[1] * (1 - ratio) + BOTTOM_COLOR[1] * ratio)
        b = int(TOP_COLOR[2] * (1 - ratio) + BOTTOM_COLOR[2] * ratio)
        draw.line([(0, y), (WIDTH, y)], fill=(r, g, b))


def draw_text(draw):
    font = ImageFont.load_default()
    draw.text((WIDTH / 2, 40), "Mixtral 8x7B", fill=TEXT_COLOR, anchor="mm", font=font)
    draw.text((WIDTH / 2, HEIGHT - 40), "Double-click to Install", fill=TEXT_COLOR, anchor="mm", font=font)


def draw_arrow(draw):
    # Horizontal arrow pointing right
    start = (WIDTH / 2 - 80, HEIGHT / 2)
    end = (WIDTH / 2 + 80, HEIGHT / 2)
    draw.line([start, end], fill=TEXT_COLOR, width=6)
    arrow_tip = [(end[0], end[1]), (end[0] - 20, end[1] - 15), (end[0] - 20, end[1] + 15)]
    draw.polygon(arrow_tip, fill=TEXT_COLOR)


def main(out_path):
    img = Image.new("RGB", (WIDTH, HEIGHT), TOP_COLOR)
    gradient_rect(img)
    draw = ImageDraw.Draw(img)
    draw_text(draw)
    draw_arrow(draw)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    img.save(out_path)


if __name__ == "__main__":
    output = sys.argv[1] if len(sys.argv) > 1 else "assets/background.png"
    main(output)
