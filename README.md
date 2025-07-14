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



## Data Processing

``` shell
pip install git+https://github.com/mori0091/ase2msx
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
