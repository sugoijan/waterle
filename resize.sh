#!/bin/sh
# Generate web-sized photos in img/ from the Unsplash originals in originals/.
# Each output is a 600x800 center crop (3:4), JPEG quality 80. macOS only (uses sips).
set -e
W=600; H=800
rm -f img/*.jpg
: > img/CREDITS.txt
i=0
for src in originals/*.jpg; do
  i=$((i + 1))
  out=$(printf 'img/%02d.jpg' "$i")
  sw=$(sips -g pixelWidth "$src" | awk '/pixelWidth/{print $2}')
  sh=$(sips -g pixelHeight "$src" | awk '/pixelHeight/{print $2}')
  # scale so the image covers WxH, then crop the center
  if [ $((sw * H)) -gt $((sh * W)) ]; then
    sips -s format jpeg -s formatOptions 80 --resampleHeight $H -c $H $W "$src" --out "$out" >/dev/null
  else
    sips -s format jpeg -s formatOptions 80 --resampleWidth $W -c $H $W "$src" --out "$out" >/dev/null
  fi
  printf '%s  %s\n' "$(basename "$out")" "$(basename "$src" .jpg)" >> img/CREDITS.txt
done
echo "wrote $i images"
