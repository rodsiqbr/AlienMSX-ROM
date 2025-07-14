# AlienMSX; MSX1-based platform game (based on Alien movie)

## LICENSE

Copyright (c) 2024 8bSoftR (Rodrigo Siqueira)

This software is Freeware.  

GitHub AlienMSX project  
<https://github.com/rodsiqbr/AlienMSX-ROM>

## Requirements

- **MSX Templates for VisualStudio** by Danilo Angelo (https://github.com/DamnedAngel/MSX-Templates-for-VisualStudio)
- **Tiled**
- **Arkos Tracker 2**
- **Python** (https://www.python.org/)



## Processing Game Data

``` shell
py png2tiles.py -i intro --zx0 IntroTS_16x6.png >introts.h
py png2tiles.py -i score --zx0 ScoreTSv3_16x4.png >scorets.h
py png2tiles.py -i font1 --zx0 Font1TS_32x2.png >font1ts.h
py png2tiles.py -i font2 --zx0 Font2TS_32x2.png >font2ts.h

py png2tiles.py -i game0 --zx0 Game0TSv4_16x5.png >game0ts.h
py png2tiles.py -i game1 --zx0 Game1TSv2_16x5.png >game1ts.h
py png2tiles.py -i fatal --zx0 Game_FatalTS_16x2.png >fatalts.h
py png2tiles.py -i alien --zx0 --no-colors AlienTS_12x2.png >alients.h
py png2tiles.py -i nostromo --zx0 --no-colors NostromoTS_16x10.png >nostrots.h
py png2tiles.py -i explosion --zx0 ExplosionTSv1_16x1.png >explosts.h
py png2tiles.py -i intro --zx0 --no-colors IntroTSv2_BW_13x9.png >introts.h
py png2tiles.py -i injoy --zx0 JoyTS_5x1.png >joyts.h

py mapgen2.py -t Game0 --zx0 --max-ents 24 --room-height 21 maplevel1v4.json maplvl1 > maplvl1.h
py mapgen2.py -t Game1 --zx0 --max-ents 24 --room-height 21 maplevel2v2.json maplvl2 > maplvl2.h
py mapgen2.py -t Game0 -m MapDiff -e EntityDiff --zx0 --max-ents 24 --room-height 21 maplevel1v4.json maplvl3 > maplvl3.h

png2sprites.py --zx0 -i player_obj Player_Full_16x4.png > player.h
png2sprites.py --zx0 -i object_sprite Objects_12x2.png > objects.h
png2sprites.py --zx0 -i enemy_sprite Enemies_12x2.png > enemies.h

py txtgen2.py --zx0 gametext.json gametext >gametext.h
```

## Processing Music/SFX Data

``` shell
py png2tiles.py -i intro --zx0 IntroTS_16x6.png >introts.h
```

## Usage

``` shell
ase2msx A.ase
```

Creates xxx.  

The following files will be generated:
- aseprite's meta-data     : `A.json` (exported by aseprite)
- aseprite's sprite sheet  : `A.png` (exported by aseprite)

See also:  
- **ubox MSX Lib** by Juan J. Martínez (https://gitlab.com/reidrac/ubox-msx-lib)
