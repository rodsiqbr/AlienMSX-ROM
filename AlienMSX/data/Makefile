OUTPUT := ../generated

GENERATED := $(OUTPUT)/tiles01.h $(OUTPUT)/player.h $(OUTPUT)/enemy.h $(OUTPUT)/map.h

all: $(GENERATED)

$(OUTPUT)/tiles.h: tiles.png
	png2tiles.py -i tiles01 --zx0 $< > $@
py png2tiles.py -i intro --zx0 IntroTS_16x6.png >introts.h
--py png2tiles.py -i score --zx0 ScoreTS_15x3.png >scorets.h
py png2tiles.py -i score --zx0 ScoreTSv3_16x4.png >scorets.h
py png2tiles.py -i font1 --zx0 Font1TS_32x2.png >font1ts.h
py png2tiles.py -i font2 --zx0 Font2TS_32x2.png >font2ts.h
--py png2tiles.py -i font3 --zx0 Font3TS_32x2.png >font3ts.h
--py png2tiles.py -i game0 --zx0 game0ts.png >game0ts.h
--py png2tiles.py -i game0 --zx0 game0tsv1.png >game0ts.h
--py png2tiles.py -i game0 --zx0 game0tsv2.png >game0ts.h
--py png2tiles.py -i game0 --zx0 game0tsv3_16x6.png >game0ts.h
--py png2tiles.py -i game1 --zx0 game1tsv1_16x6.png >game1ts.h

py png2tiles.py -i game0 --zx0 Game0TSv4_16x5.png >game0ts.h
py png2tiles.py -i game1 --zx0 Game1TSv2_16x5.png >game1ts.h
py png2tiles.py -i fatal --zx0 Game_FatalTS_16x2.png >fatalts.h
py png2tiles.py -i alien --zx0 --no-colors AlienTS_12x2.png >alients.h
py png2tiles.py -i nostromo --zx0 --no-colors NostromoTS_16x10.png >nostrots.h
py png2tiles.py -i explosion --zx0 ExplosionTSv1_16x1.png >explosts.h

--py mapgen.py -t Game0 --zx0 --max-ents 24 --room-height 21 alienmap.json alienmap > alienmap.h
--py mapgen.py -t Game0 --zx0 --max-ents 24 --room-height 21 maplevel1.json maplvl1 > maplvl1.h
--py mapgen2.py -t Game0 --zx0 --max-ents 24 --room-height 21 maplevel1v3.json maplvl1 > maplvl1.h
--py mapgen2.py -t Game1 --zx0 --max-ents 24 --room-height 21 maplevel2v1.json maplvl2 > maplvl2.h
py mapgen2.py -t Game0 --zx0 --max-ents 24 --room-height 21 maplevel1v4.json maplvl1 > maplvl1.h
py mapgen2.py -t Game1 --zx0 --max-ents 24 --room-height 21 maplevel2v2.json maplvl2 > maplvl2.h
py mapgen2.py -t Game0 -m MapDiff -e EntityDiff --zx0 --max-ents 24 --room-height 21 maplevel1v4.json maplvl3 > maplvl3.h


--py txtgen.py --zx0 levels.json levels >levels.h
--py txtgen.py --zx0 credits.json credits >credits.h

py txtgen2.py --zx0 gametext.json gametext >gametext.h

$(OUTPUT)/player.h: player.png
--	png2sprites.py --zx0 -i player_ash Player_Ash_16x2.png > plyr_ash.h
--      png2sprites.py --zx0 -i player_ripley Player_Ripley_16x2.png > plyr_rip.h
        png2sprites.py --zx0 -i player_obj Player_Full_16x4.png > player.h
	png2sprites.py --zx0 -i object_sprite Objects_12x2.png > objects.h
	png2sprites.py --zx0 -i enemy_sprite Enemies_12x2.png > enemies.h

$(OUTPUT)/enemy.h: enemy.png
	png2sprites.py -i enemy_sprite $< > $@

$(OUTPUT)/map.h: map.json map_conf.json
	py mapgen.py -t Game0 --zx0 --max-ents 20 --room-height 21 alienmap.json alienmap > $@

.PHONY: all clean
clean:
	rm -f $(OUTPUT)/*

1234567890123
NO CARD
NO KEY
NO BATTERY
NO PLIER
NO SCREWDRIVR

>>0:00<<