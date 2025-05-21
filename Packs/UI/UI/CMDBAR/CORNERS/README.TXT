The bitmaps at the four corners of the view reside in this directory.

The naming scheme for the bitmaps is as follows:
$race$num.rle
The rle should be a normal rle (produced from hicolor 15 bitmap via bmp2rle (name) 1 1 normal)
$race is the race string of the player and $num is an integer number in [0-3] which encodes bitmap positions:
0 - left top
1 - left bottom
2 - right top
3 - right bottom

Example: Gaul2.bmp is the bitmap for the right top corner for Gaul players.