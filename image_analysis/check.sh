import -window root work/screen.png

convert work/screen.png -crop 320x320+15+42 work/screen.png # ! to check and fine tune
# this should give exactly the image frame provided as work/frame_ok.png

convert work/screen.png -resize 32x32 -type Grayscale -channel RGB -threshold 50% work/screen.png

# need: is the tamagotchi crying ?
convert work/screen.png -crop 8x8+25+28 work/need.png

# top right
convert work/screen.png -crop 8x8+25+12 work/top.png

# bottom right
convert work/screen.png -crop 8x8+25+20 work/bot.png

# middle (zzz with light off)
convert work/screen.png -crop 8x8+17+12 work/middle.png

# clock: check the "m" of "am"/"pm"
convert work/screen.png -crop 8x4+3+24 work/clock.png

# selection choice
convert work/screen.png -crop 8x8+1+20 work/sel.png

# hearts
# h1 = sel
convert work/screen.png -crop 8x8+9+20 work/h2.png
convert work/screen.png -crop 8x8+17+20 work/h3.png
# h4 = bot

rm work/screen.png
