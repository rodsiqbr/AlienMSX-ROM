// ----------------------------------------------------------
//	ALIEN ROM program (32KB cartridge) for MSX
// ----------------------------------------------------------

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#include "targetconfig.h"
#include "MSX/BIOS/msxbios.h"

#include "uboxlib/include/ubox.h"
#include "uboxlib/include/ap.h"
#include "uboxlib/include/spman.h"
#include "uboxlib/include/mplayer.h"
#include "uboxlib/include/ubox_ext.h"

#pragma disable_warning 218 // disable "z80instructionSize() failed to parse line node" SDCC error with ASM inline labels
#pragma disable_warning 85	// some variables not used in C context
#pragma disable_warning 59	// asm code inside C functions doesn´t return a value

#define LOCAL

// Include all Tilesets
#include "data/font1ts.h"    // font 1 Tileset (blue)
#include "data/font2ts.h"    // font 2 Tileset (white)
//#include "data/font3ts.h"  // font 3 Tileset (green) - NOT USED
#include "data/introts.h"    // intro Tileset
#include "data/scorets.h"    // score Tileset
#include "data/game0ts.h"    // game map level 1 and 3 Tileset
#include "data/game1ts.h"    // game map level 2 Tileset
#include "data/fatalts.h"    // game map Fatal Tilesets (same for Level 1, 2 and 3)
#include "data/alients.h"    // Alien creature Tileset
#include "data/nostrots.h"   // final screen Nostromo ship Tileset
#include "data/explosts.h"   // final screen Nostromo Explosion Tileset


// Include all texts, maps, sprites(player, objects and all the enemies)
#include "data/gametext.h"   // Intro text, Credits text, GameOver text ...
#include "data/player.h"     // Ash + Ripley sprite data
#include "data/objects.h"    // Objects sprite data
#include "data/enemies.h"    // Enemies sprite data

#include "data/maplvl1.h"    // Map Level 1
#include "data/maplvl2.h"    // Map Level 2
#include "data/maplvl3.h"    // Map Level 3 (differential map from Level 1)


// ----------------------------------------------------------
// DATA STRUCTURES SECTION
// ----------------------------------------------------------

typedef struct
{
	uint8_t x;             //    0 | entity x position
	uint8_t y;             //    1 | entity y position
	uint8_t dir;           //    2 | entity direction
	uint8_t status;        //    3 | entity status
	uint8_t hitflag;       //    4 | player was hit flag
	uint8_t pat;           //    5 | entity sprite pattern #
	uint8_t frame;         //    6 | entity sprite frame #
	uint8_t delay;         //    7 | entity sprite frame delay counter
	uint8_t type;          //    8 | entity type
//	void (*update)();      // 9-10 | not used, global update routine used instead
	uint8_t grabflag;      //    9 | player is grabbed by a facehugger flag
	uint8_t grabtimer;     //   10 | timer to trigger a hit if grabbed - NOT USED
} PlyEntity;

typedef struct
{
	uint8_t x;             //    0 | entity x position
	uint8_t y;             //    1 | entity y position
	uint8_t dir;           //    2 | entity direction
	uint8_t status;        //    3 | entity status
	uint8_t hitcounter;    //    4 | enemy hit counter
	uint8_t pat;           //    5 | entity sprite pattern # - NOT USED
	uint8_t frame;         //    6 | entity sprite frame #
	uint8_t delay;         //    7 | entity sprite frame delay counter
	uint8_t type;          //    8 | entity type
	uint8_t screenId;      //    9 | enemy screen id
	uint8_t objId;         //   10 | enemy object id
	uint8_t min_x;         //   11 | minimum x position at screen
	uint8_t max_x;         //   12 | maximum x position at screen
	uint8_t floor_y;       //   13 | floor y position
} EnemyEntity;

typedef struct
{
	uint8_t X;             //    0 | entity X position
	uint8_t Y;             //    1 | entity Y position
	uint8_t dir;           //    2 | entity direction
	uint8_t status;        //    3 | entity status
	uint8_t frame;         //    4 | entity sprite frame #
	uint8_t delay;         //    5 | entity sprite frame delay counter
	uint8_t type;          //    6 | entity type
	uint8_t min_X;         //    7 | minimum X position at screen
	uint8_t max_X;         //    8 | maximum X position at screen
  uint8_t last_X;        //    9 | last X position
	bool IsActive;         //   10 | is alien active at this screen?
	uint16_t iPosition;    // 11-12| relative upper-left tile position in VRAM NAME TABLE (values from 0 - 767)
} AlienEntity;

struct AnimatedTile
{
	uint16_t iPosition;    // 0-1 | relative tile position in VRAM NAME TABLE (values from 0 - 767)
	uint8_t cCycleMode;    //   2 | index at cycle table
	uint8_t cStep;         //   3 | current frame step in the cycle table (LEFT_MOST_TILE, 0x00 or RIGHT_MOST_TILE if this object is a Slider)
	uint8_t cLastFrame;    //   4 | last frame offset used for Tile pattern
	uint8_t cTile;	       //   5 | base tile
	uint8_t cTimer;        //   6 | **timer (in cycles) - only for special tiles (Locker ID or Mission # if object is an Interactive)
	uint8_t cTimeLeft;     //   7 | **remaining time (in cycles) - only for special tiles
	uint8_t cSpTileStatus; //   8 | **status - only for special tiles (ST_ENABLED[1], ST_DISABLED[0], ST_TIMEWAIT[2])
	uint8_t cSpObjID;      //   9 | **ObjectID - only for special tiles
};

struct AnimTileList
{
	uint8_t cTile;         //   0 | tile #
	uint16_t iPosition;    // 1-2 | relative tile position in VRAM NAME TABLE (values from 0 - 767)
};

struct ObjTileHistory
{
	uint8_t cScreenMap;    //   0 | screen map #. 0xFF if free record
	uint16_t iPosition;    // 1-2 | relative tile position in VRAM NAME TABLE (values from 0 - 767)
	uint8_t cTile;         //   3 | tile stored in the history
};

struct ObjectScreen
{
	uint8_t cObjID;        // 0 | Object ID. 0xFF if free record
	uint8_t cX0;           // 1 | x0 top left (0 - 255)
	uint8_t cX1;           // 2 | x1 bottom right (0 - 255)
	uint8_t cY0;           // 3 | y0 top left (0 - 192)
	uint8_t cY1;           // 4 | y1 bottom right (0 - 192)
//uint8_t cObjStatus;    // 4 | if Object Class = ANIM_CYCLE_FACEHUG_EGG then cObjStatus = (ST_EGG_CLOSED, ST_EGG_OPENED, ST_EGG_RELEASED, ST_EGG_DESTROYED)
	uint8_t cObjClass;     // 5 | Object Class (ANIM_CYCLE_NULL, ANIM_CYCLE_SLIDER_UP, ANIM_CYCLE_SLIDER_DOWN, ANIM_CYCLE_SLIDER_RIGHT, ANIM_CYCLE_SLIDER_LEFT, ANIM_CYCLE_FACEHUG_EGG)
};

struct FlashLightStatusData
{
	uint8_t  bFLightJustEnabled;    //    0 | Flag - true if FlashLight was just enabled
	uint16_t iCurrPlyPositionOffs;  //  1-2 | Player position (upper left block) absolute offset (values from 0 - 767)
	uint8_t  cCurrPlyTileX;         //    3 | Player tile X position
	uint8_t  cCurrPlyTileY;         //    4 | Player tile Y position
	uint8_t  cOffSetXLeft;          //    5 | FlashLight offset X at left (0, 1 or 2)
	uint8_t  cOffSetXRight;         //    6 | FlashLight offset X at right (0, 1 or 2)
	uint8_t  cOffSetYTop;           //    7 | FlashLight offset Y at top (0, 1 or 2)
	uint8_t  cOffSetYBottom;        //    8 | FlashLight offset Y at bottom (0, 1 or 2)
  uint16_t iVRAMAddrStartFL;      // 9-10 | VRAM Address from 1st flashlight tile
	uint8_t  cWidthFL;              //   11 | FlashLight Width
	uint8_t  cHeightFL;             //   12 | FlashLight Height
};


// ----------------------------------------------------------
// CONSTANT DATA AND DEFINES SECTION
// ----------------------------------------------------------

// N = n {0, 1, 2}: Tile offset to print at screen (base tile + N)
// N = 0xFF			: Blank Tile to print at screen
// N = 0xFE			: Stop animation (until animation restarts by an user action or a timer)
const uint8_t cCycleTable[] = {
                                0, 1, 0, 1, 0, 1, 1, 0, 1, 0,                         // 0 = acid
                                0, 1, 2, 2, 2, 1, 0xFF, 0xFF, 0xFF, 0xFF,             // 1 = steam
                                0, 1, 1, 0, 1, 0xFF, 0xFF, 0xFF, 1, 1,                // 2 = energy ray AND force field
                                0, 1, 2, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,    // 3 = oil drop (3H = step 7; 4H = step 0; 5H = step 1)
                                0, 1, 2, 0, 1, 2, 0, 1, 2, 0,                         // 4 = mat, anti-clockwise = 0
                                2, 1, 0, 2, 1, 0, 2, 1, 0, 2,                         // 5 = mat, clockwise = 1
																1, 1, 1, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,    // 6 = gate open
																1, 1, 1, 0, 0xFE, 0xFF, 0xFF, 0xFF, 0, 0xFE,          // 7 = gate close
																0, 0xFE, 1, 0xFE, 0xFF, 0xFE, 0xFE, 0xFE, 0xFE, 0xFE, // 8 = break wall 3 stages
																1, 0xFE, 0, 0xFE, 0xFE, 0xFF, 0xFE, 0xFE, 0xFE, 0xFE, // 9 = interactive 3 stages (on -> off = step 0 / off -> on = step 2 / collectible item = step 5)
																0, 1, 2, 0, 1, 2, 0, 1, 2, 0xFF,                      // 10 = portal
																1, 1, 1, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFE,    // 11 = locker open
																2, 0xFE, 0xFF, 0xFE, 0, 0xFE, 6, 0xFE, 0xFE, 0xFE,    // 12 = Facehugger Egg top (0, 2), Facehugger Egg body (4, 6)
																// Intro logo animation blocks
																16, 1, 1, 1, 1,							// I
																5, 3, 2, 2, 2,							// A
																26, 2, 2, 3, 3,							// N
																11, 1, 1, 1, 1,							// L
																20, 1, 1, 1, 1,							// E
																6, 2, 2, 3, 3,							// A		
																28, 1, 1, 1, 1,							// N		
																21, 2, 2, 0, 2,							// E		
																12, 0, 0, 0, 2,							// L		
																26, 1, 1, 1, 1,							// N		
																6, 0, 0, 2, 2,              // A		
                                21, 0, 2, 2, 0,             // E
};

// Nostromo ship tileset map RLEncoded
const uint8_t cNostromo_img_guide[] = { 6, 1, 3, 2,              // Line 1: 6 zeros then 1 tile, 3 zeros then 2 tiles
                                        14, 2, 3, 2,             // Line 2: 14 zeros then 2 tile2, 3 zeros then 2 tiles
																				13, 4, 2, 2,             // Line 3: you got it, right?!
																				13, 4, 1, 4,             // Line 4:
																				12, 3, 2, 5, 2, 2,       // Line 5:
																				7, 9, 3, 2,              // Line 6:
																				7, 9, 2, 4,              // Line 7:
																				4, 17,                   // Line 8:
																				5, 16,                   // Line 9:
																				2, 20,                   // Line 10:
																				1, 20,                   // Line 11:
																				1, 20,                   // Line 12:
																				5, 3, 2, 5, 1, 3, 0xFF,  // Line 13: 0xFF = EOF
};


#define ANIM_CYCLE_STEP_BLANK   0xFF
#define ANIM_CYCLE_STEP_STOP    0xFE

#define ANIM_CYCLE_NULL         0
#define ANIM_CYCLE_FORCEFIELD   2
#define ANIM_CYCLE_DROPPER      3
#define ANIM_CYCLE_BELT         4
#define ANIM_CYCLE_GATE_OPEN    6
#define ANIM_CYCLE_GATE_CLOSE   7
#define ANIM_CYCLE_WALL_BREAK   8
#define ANIM_CYCLE_INTERACTIVE  9
#define ANIM_CYCLE_PORTAL       10
#define ANIM_CYCLE_LOCKER_OPEN  11
#define ANIM_CYCLE_FACEHUG_EGG  12
#define ANIM_CYCLE_SLIDER_UP    50
#define ANIM_CYCLE_SLIDER_DOWN  51
#define ANIM_CYCLE_SLIDER_RIGHT 52
#define ANIM_CYCLE_SLIDER_LEFT  53

#define INTRO_BLOCK_OFFSET      13 // start row for Intro block animation data at cCycleTable[]


#define GAMESTAGE_INTRO    1
#define GAMESTAGE_LEVEL    2
#define GAMESTAGE_GAME     3
#define GAMESTAGE_GAMEOVER 4
#define GAMESTAGE_FINAL    5

// Special Tiles animation status
#define ST_DISABLED 0
#define ST_ENABLED  1
#define ST_TIMEWAIT 2

#define LEFT_MOST_TILE     0xE0
#define RIGHT_MOST_TILE    0xF0

#define UPD_OBJECT_EGG     0b00001111             // 0bxxxx1111 where xxxx = new status (ST_EGG_OPENED, ST_EGG_RELEASED, ST_EGG_DESTROYED) + 1111 = UPDATE_OBJ_EGG (15)
#define UPD_OBJECT_UP_8    ANIM_CYCLE_SLIDER_UP
#define UPD_OBJECT_DOWN_8  ANIM_CYCLE_SLIDER_DOWN
#define UPD_OBJECT_RIGHT_8 ANIM_CYCLE_SLIDER_RIGHT
#define UPD_OBJECT_LEFT_8  ANIM_CYCLE_SLIDER_LEFT

// entity types in the same order used in the map (see map_conf.json)
#define ET_UNUSED      0
#define ET_PLAYER      1    // entity - not a tile
#define ET_SAFEPLACE   2    // no animation - not a tile
#define ET_ENEMY       3    // entity - not a tile
#define ET_ANIMATE     4    // simple animated tile
#define ET_BELT        5    // simple animated tile
#define ET_DROPPER     6    // simple animated tile
#define ET_PORTAL      7    // simple animated tile
#define ET_FORCEFIELD  8    // simple animated tile
#define ET_EGG         9    // ** special animated tile
#define ET_GATE        10   // ** special animated tile
#define ET_WALL        11   // ** special animated tile
#define ET_INTERACTIVE 12   // ** special animated tile
#define ET_SLIDERFLOOR 13   // ** special animated tile
#define ET_LOCKER      14   // ** special animated tile

// types for our pattern groups used by spman
enum pattern_type
{
	PAT_PLAYER_WALK = 0,
	PAT_PLAYER_WALK_FLIP,
	PAT_PLAYER_FALL,
	PAT_PLAYER_JUMP,
	PAT_PLAYER_JUMP_FLIP,
	PAT_PLAYER_CLIMB,
	PAT_SHIELD,
	PAT_SHOT,
	PAT_SHOT_FLIP,
	PAT_EXPLOSION,
	PAT_MINIMAP,
	PAT_ENEMY_BASE,
	PAT_ENEMY_BASE_FLIP,
	PAT_ALIEN_TONGUE,
	PAT_ALIEN_TONGUE_FLIP
};

// sub-songs matching our Arkos song
// configure the song to use MSX AY
#define SONG_IN_GAME   0
#define SONG_SILENCE   1
#define SONG_GAME_OVER 2
#define SONG_INTRO     3
#define SONG_IN_GAME_2 4

// sound effects matching our Arkos efx song
// configure the song to use MSX AY
#define SFX_NONE         0x00
#define SFX_SELECT       0x01
#define SFX_GET_OBJECT   0x02
#define SFX_GATE         0x03
#define SFX_HIT          0x04
#define SFX_HURT         0x05
#define SFX_SHOOT        0x06
#define SFX_EXPLODE      0x07
#define SFX_TIMEOFF      0x08
#define SFX_PORTAL       0x09
#define SFX_TYPING       0x0A
#define SFX_MISSIONCPLT  0x0B
#define SXF_INTERACTIVE  0x0C
#define SFX_ALIENATTACK  0x0D
#define SFX_DEADPLAYER   0x0E

#define SFX_CHAN_NO      0x01  // options 0, 1 or 2


#define MAX_ANIM_TILES           32                 // max animated tiles per map
#define MAX_OBJECTS_PER_MAP      12                 // max objects / animated entities in a single map
#define MAX_ANIM_SPEC_TILES_FULL (9*2 + 2*1 + 3*3)  // max animated special tiles per map [MAX=31] ((5 gates + 1 locker + 3 walls * 2 tiles each) + 2 interactives * 1 tile each + 3 slider * 3 tiles each)
#define MAX_ANIM_SPEC_TILES      (9*2 + 2*1)        // max animated special tiles per map ((5 gates + 1 locker + 3 walls * 2 tiles each) + 2 interactives * 1 tile each (no sliders))

// map size in tiles
#define MAP_W 32
#define MAP_H 21
#define MAP_BYTES_SIZE (MAP_W * MAP_H)

#define NOSTROMO_IMG_WIDTH       21  // 20 nostromo tiles + 1 right blank tile for animations
#define NOSTROMO_IMG_HEIGHT      13

#define INITIAL_LIVES 3
#define MAX_LIVES     5
#define MAX_POWER     100   // 100% = full power
#define MAX_LEVEL     3     // # of levels

#define MAX_ENEMIES_PER_SCREEN      3
#define AVERAGE_ENEMIES_PER_SCREEN  2


// several player control status: sprite direction, status, jump stage, jump direction, color
#define PLYR_SPRT_DIR_RIGHT    0
#define PLYR_SPRT_DIR_LEFT     1

#define PLYR_STATUS_STAND      0x00
#define PLYR_STATUS_WALKING    0x01
#define PLYR_STATUS_FALLING    0x02
#define PLYR_STATUS_JUMPING    0x03
#define PLYR_STATUS_CLIMB      0x04
#define PLYR_STATUS_CLIMB_UP   0x05
#define PLYR_STATUS_CLIMB_DOWN 0x06
#define PLYR_STATUS_DEAD       0x0F

#define PLYR_JUMP_STAGE_UP     0
#define PLYR_JUMP_STAGE_DOWN   1

#define PLYR_JUMP_DIR_NONE     0     // should be 0 to jump to work
#define PLYR_JUMP_DIR_LEFT     1     // should be 1 to jump to work
#define PLYR_JUMP_DIR_RIGHT    2     // should be 2 to jump to work

#define PLYR_UP_JUMP_CYCLES    20  // # of cycles (Y offset) for a jump (8 + 8 + 4)
//{1, 1, 1, 1, 1, 1, 1, 1, 
// 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1,
// 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1}

#define PLYR_SPRITE_L1_COLOR_NORMAL 0xDF  // Magenta(13) and White(15) - Ash
#define PLYR_SPRITE_L2_COLOR_NORMAL 0x4E  // Blue(04) and Gray(14) - Rippley
#define PLYR_SPRITE_L1_COLOR_HIT    0x8B  // Red(08) and Light Yellow(11)
#define PLYR_SPRITE_L1_COLOR_DEAD   0x9E  // Light Red(09) and Gray(14)
#define PLYR_SPRITE_L1_COLOR_DARK   0xFE  // White(15) and Gray(14)

#define SHIELD_SPRITE_COLORS        0x7E  // Cyan(07) and Gray(14)
#define FACEHUG_SPRITE_COLORS       0xA9  // Yellow(10) and Light Red(09)
#define FACEHUG_SPRITE_COLOR_DARK   0x07  // Cyan(07)


uint8_t PLYR_PAT_WALK_IDX;
uint8_t PLYR_PAT_FALL_IDX;
uint8_t PLYR_PAT_CLIMB_IDX;
uint8_t PLYR_PAT_JUMP_IDX;

uint8_t ENEMY_PAT_BASE_IDX;
uint8_t ENEMY_PAT_BASE_FLIP_IDX;

uint8_t ALIEN_PAT_TONGUE_IDX;
uint8_t ALIEN_PAT_TONGUE_FLIP_IDX;


#define PLYR_WALK_CYCLE        4
#define PLYR_DEAD_CYCLE        5
const uint8_t ply_walk_frames[PLYR_WALK_CYCLE] = { 0, 1, 0, 2 };    // walk animation frames
const uint8_t ply_dead_pat_frames[PLYR_DEAD_CYCLE] =  {48, 64, 56, 72, 64 };  // dead player animation frames (pattern #)


#define SPRT_MAP_COLOR_CYCLE   4
const uint8_t color_frames[SPRT_MAP_COLOR_CYCLE] = { 11, 8, 10, 6 };

// several Enemy control status: sprite direction, status, jump stage, jump direction, color
#define ENEMY_SPRT_DIR_RIGHT     PLYR_SPRT_DIR_RIGHT   // 0
#define ENEMY_SPRT_DIR_LEFT      PLYR_SPRT_DIR_LEFT    // 1

#define ENEMY_STATUS_INACTIVE    0x00
#define ENEMY_STATUS_KILLED      0x05
#define ENEMY_STATUS_AWAKING     0x10
#define ENEMY_STATUS_WALKING     0x20
#define ENEMY_STATUS_JUMPING     0x30
#define ENEMY_STATUS_GRABBED     0x40
#define ENEMY_STATUS_HURT        0x50
#define ALIEN_STATUS_CHASE       0x60  // alien only
#define ALIEN_STATUS_ATTACK      0x70  // alien only

#define ENEMY_HIT_COUNT          2     // number of hits (shoots) before facehug to be hurt

const uint8_t enemy_awake_frames[] = { 0, 2, 2, 2, 2, 1, 1, 0, 0xFC };     // use frame 0, 2, 2, 2, 2, 1, 1, 0 then keep at 0
const uint8_t enemy_walk_frames[]  = { 0, 1, 0xFD };                       // use frame 0, 1 then restart
const uint8_t enemy_jump_frames[]  = { 2, 0xFC };                          // useframe 2 then keep at 2
const uint8_t enemy_grab_frames[]  = { 3, 0xFC };                          // use frame 3 then keep at 3
const uint8_t enemy_hurt_frames[]  = { 3, 3, 3, 3, 4, 4, 4, 4, 4, 0xFC };  // use frame 2, 4 then keep at 4

#define SPRITE_ANIM_FRAME_RESTART 0xFD
#define SPRITE_ANIM_FRAME_KEEP    0xFC

#define COLISION_FATAL       0b00000001
#define COLISION_SOLID       0b00000010
#define COLISION_GATE        0b00000100
#define COLISION_EMPTY       0b00001000
#define COLISION_FLOOR       0b00010000
#define COLISION_NEXTM       0b00100000
#define COLISION_OBJCT       0b01000000
#define COLISION_COLLECTIBLE 0b01000000
#define COLISION_INTER       0b10000000

// fonts usefull info
uint8_t FONT1_TILE_OFFSET;  // first font tile (' ') position in the Tileset
uint8_t FONT2_TILE_OFFSET; 

#define INTRO_CTRL_TILE_NR     (TS_FONT1_SIZE + 65) // first Control tile starts at position 65 in the 'Intro' Tileset
#define INTRO_BOX_TILE_NR      (TS_FONT1_SIZE + 94) // first Box Tile tile starts at position 94 in the 'Intro' Tileset
#define INTRO_MENU_POS_X        6                   // X position for Intro menu
#define INTRO_MENU_POS_Y       16                   // Y position for Intro menu
#define MAX_INTRO_MENU_OPTIONS  3                   // only 3 option in the intro menu

#define INTRO_CTRL_CYCLE        8
const uint8_t cCtrl_frames[INTRO_CTRL_CYCLE] = { 0 << 2, 1 << 2, 2 << 2, 3 << 2, 4 << 2, 3 << 2, 2 << 2, 1 << 2 };

// Score tile #defines for C & ASM code
#define SCORE_POWER_TL_OFFSET   11
#define SCORE_SLASH_TL_OFFSET   17     // SLASH character offset in 'Score' Tileset
#define SCORE_MISSION_TL_OFFSET 18
#define SCORE_MAP_TL_OFFSET     22
#define SCORE_PAUSE_TL_OFFSET   38     // PAUSE text offset in 'Score' Tileset
#define SCORE_ARISE_TL_OFFSET   41     // ARISE text offset in 'Score' Tileset
#define SCORE_BLACK_TL_OFFSET   44     // BLACK tile offset
#define SCORE_DIFFNT_TL_OFFSET  45     // DIFFERENTIAL tile offset (Map 3)
#define SCORE_COLON_TL_OFFSET   45     // COLON character offset in 'Score' Tileset
#define SCORE_OBJ_TL_OFFSET     46	   // start tile offset for Object tiles in 'Score' Tileset
#define SCORE_BATTERY_TL_OFFSET 46     // BATTERY Object offset in 'Score' Tileset
#define SCORE_AMNO_TL_OFFSET    47     // AMNO Object offset in 'Score' Tileset
#define SCORE_FLASHL_TL_OFFSET  56     // FLASHLIGHT Object offset in 'Score' Tileset
#define SCORE_GUN_TL_OFFSET     57     // GUN Object offset in 'Score' Tileset
#define SCORE_SHIELD_TL_OFFSET  59     // SHIELD Object offset in 'Score' Tileset
#define SCORE_LIFE_TL_OFFSET    60     // LIFE Object offset in 'Score' Tileset
#define SCORE_PORTAL_TL_OFFSET  61     // start tile offset for Portal tiles

#define SCORE_MINIMAP_Y_POS     0
#define SCORE_MINIMAP_X_POS     22


// Game tile #defines for C & ASM code
#define GAME_ALARM_TIMER_TL_OFFSET 04     // start tile offset for Timer Alarm tiles - only at Map 1 and 3 tileset

#define GAME_SPEC_TL_OFFSET	       08     // start tile offset for <Special> tiles
#define GAME_SPECSD_TL_OFFSET	     12 	  // start tile offset for <Special> <Solid> tiles
#define GAME_SP_BLT_TL_OFFSET      15 	  // start tile offset for <Special> Belt tiles
#define GAME_SP_GAT_TL_OFFSET	     24 	  // start tile offset for <Special> Gate (animated) tiles
#define GAME_WALL_BRK_TL_OFFSET    38 	  // Broken Wall tile offset
#define GAME_PWR_SWITCH_TL_OFFSET  40 	  // Power Switch <Interactive> tile offset
#define GAME_PWR_BUTTON_TL_OFFSET  42 	  // Power Button <Interactive> tile offset
#define GAME_PWR_LOCK_TL_OFFSET    44 	  // Lock Device <Interactive> tile offset
#define GAME_SOLD_TL_OFFSET	       46 	  // start tile offset for Solid tiles
#define GAME_HORIZ_FF_TL_OFFSET    67 	  // start tile offset for Horizontal ForceField tiles
#define GAME_EGG_TL_OFFSET	       70 	  // start tile offset for Egg tiles
#define GAME_COLLECT_TL_OFFSET	   76 	  // start tile offset for Collectible tiles
#define GAME_FATL_TL_OFFSET	       80 	  // start tile offset for Fatal (animated) tiles
#define GAME_ALIEN_TL_OFFSET	    100 	  // start tile offset for Alien (animated) tiles

// Nostromo explosion tile #defines for C & ASM code
#define EXPLO_STEP1_TL_OFFSET   16
#define EXPLO_STEP2_TL_OFFSET   19
#define EXPLO_STEP3_TL_OFFSET   20
#define EXPLO_STEP4_TL_OFFSET   21
#define EXPLO_STEP5_TL_OFFSET   29


#define BLANK_TILE               0x00                    // BLANK tile position in any Tileset
#define BLACK_TILE               SCORE_BLACK_TL_OFFSET   // BLACK tile position in Score Tileset [SCORE_BLACK_TL_OFFSET]

#define GAME_TEXT_CREDITS_LABEL_ID   0
#define GAME_TEXT_CREDITS_VALUE_ID   1
#define GAME_TEXT_LEVEL_1_INFO_ID    2
#define GAME_TEXT_LEVEL_2_INFO_ID    3
#define GAME_TEXT_LEVEL_3_INFO_ID    4
#define GAME_TEXT_LEVEL_COMPLETED_ID 5
#define GAME_TEXT_GAME_OVER_ID       6
#define GAME_TEXT_GAME_WIN_ID        7
#define GAME_TEXT_INTRO_CONTROL_ID   8
#define GAME_TEXT_INTRO_MENU_ID      9
#define GAME_TEXT_WIN_DEATH_ID       10        // :
#define GAME_TEXT_WIN_RESCUE_ID      11        // ;

// Tile Class attributes
#define TILE_TYPE_BLANK	         0b00000000    // Blank tile
#define TILE_TYPE_OBJECT         0b00000001    // Object tile
#define TILE_TYPE_SPECIAL        0b01000010    // Special tile (stair, cable)
#define TILE_TYPE_SPECIAL_SOLID  0b11000010    // Special Solid tile
#define TILE_TYPE_SPECIAL_BELT   0b10000011    // Belt tile
#define TILE_TYPE_SPECIAL_GATE   0b10010100    // Gate tile
#define TILE_TYPE_INTERACTIVE    0b10010101    // Interactive tile
#define TILE_TYPE_WALL           0b10010110    // Wall tile
#define TILE_TYPE_EGG            0b10000101    // Alien Egg tile
#define TILE_TYPE_COLLECTIBLE    0b00000110    // Collectible tile
#define TILE_TYPE_SOLID          0b10000111    // Solid tile
#define TILE_TYPE_FATAL_OR_SOLID 0b10000001    // Horizontal ForceField - Solid if walking on it, Fatal if passing thought it 
#define TILE_TYPE_FATAL	         0b00100111    // Fatal tile
#define TILE_TYPE_ALIEN          0b00100011    // Alien Creature tile
#define TILE_TYPE_PORTAL         0b00001111    // Portal tile
//                                 ||||||||
//                                 |||||| L 0 - ID
//                                 |||||L-- 2 - ID
//                                 ||||L--- 3 - Portal Class Flag
//                                 |||L---- 4 - Gate Class Flag
//                                 ||L----- 5 - Fatal Flag
//                                 |L------ 6 - Special Class (Stair) Flag
//                                 L------- 7 - Solid Flag

// primary object flags - cPlyObjects
#define MAX_OBJECTS              8
#define HAS_NO_OBJECT            0b00000000
#define HAS_OBJECT_KEY           0b00000001
#define HAS_OBJECT_YELLOW_CARD   0b00000010
#define HAS_OBJECT_GREEN_CARD    0b00000100
#define HAS_OBJECT_RED_CARD      0b00001000
#define HAS_OBJECT_TOOL          0b00010000
#define HAS_OBJECT_MAP           0b00100000
#define HAS_OBJECT_SCREW         0b01000000
#define HAS_OBJECT_KNIFE         0b10000000

// secondary object flags - cPlyAddtObjects
#define HAS_OBJECT_GUN           0b00000001
#define HAS_OBJECT_FLASHLIGHT    0b00000010

#define LIGHT_SCENE_ON_FL_ANY    0b00000001
#define LIGHT_SCENE_OFF_FL_OFF   0b00000000
#define LIGHT_SCENE_OFF_FL_ON    0b00000010
//                                       ||
//                                       |L 0 - Scene Lights Flag Off (0) / On (1)
//                                       L- 1 - FlashLight   Flag Off (0) / On (1)

#define INTERACTIVE_ACTION_LIGHT_ONOFF  0
#define INTERACTIVE_ACTION_LOCKER_OPEN  1
#define INTERACTIVE_ACTION_MISSION_CPLT 2
#define INTERACTIVE_ACTION_COLLECT_CPLT 3

#define GAME_LIGHTS_ACTION_NONE 0
#define GAME_LIGHTS_ACTION_ON   1
#define GAME_LIGHTS_ACTION_OFF  2

#define YELLOW_CARD_PTS        02
#define GREEN_CARD_PTS         03
#define RED_CARD_PTS           04

#define HEALTH_PACK_PTS        20
#define GUN_AMNO_PTS           10
#define AMNO_AMNO_PTS          15
#define SHIELD_PTS             15
#define FLASHLIGHT_BATTR_PTS   30
#define INVULNERABILITY_SHIELD 05
#define MAX_AMNO_SHIELD        99
#define ONE_SECOND_TIMER       30  // = 1 sec
#define ONE_THIRD_SECOND_TIMER 10  // = 300 msec

#define EGG_SHOTS_TO_DESTROY    7
#define ST_EGG_CLOSED           0  // ** must be 0 for animation to work
#define ST_EGG_OPENED           2
#define ST_EGG_RELEASED         3
#define ST_EGG_DESTROYED        4

#define ANIM_STEP_EGG_CLOSED    0  // ** must be 0 for animation to work
#define ANIM_STEP_EGG_OPENED    2  // ** must be 2 for animation to work

#define PLY_DIST_EGG_OPEN       8  // minimum # tiles distance from Player to Egg to open it
#define PLY_DIST_EGG_FH_RELEASE 6  // minimum # tiles distance from Player to an opened Egg to release Enemy (FaceHug)

#define HIT_PTS_FACEHUG         2
#define HIT_PTS_SMALL           4
#define HIT_PTS_MEDIUM          8
#define HIT_PTS_HIGH           12
#define HIT_PTS_TONGUE         50

#define SCORE_OBJECT_POINTS     7  //   7 points to the score when getting an object
#define SCORE_INTERACTV_POINTS 25  //  25 points to the score when activating an interactive
#define SCORE_ENEMY_HIT_POINTS 30  //  30 points to the score when hit an enemy
#define SCORE_COLLECTBL_POINTS 40  //  40 points to the score when collect a collectible item
#define SCORE_MISSION_POINTS   50  //  50 points to the score when complete a mission
#define SCORE_LEVELUP_POINTS  100  // 100 points to the score when level complete

#define SCORE_ADD_ANIM          4  // score points to increase for each score animation cycle
#define HIT_ANIM_TIMER          7
#define DEAD_ANIM_TIMER        25  // 5 cycles, each cycle = 5 distinct frame
#define KEY_PRESS_DELAY        16  // delay in cycles before accept a new key press

#define ENEMY_ANIM_DELAY       96  // cycles to change enemy frame
#define ALIEN_ANIM_DELAY        6  // cycles to change alien frame
#define PLAYER_ANIM_DELAY       3  // cycles to change player frame

#define CACHE_INVALID           0xFF

#define MAX_MISSIONS           4
#define MISSION_NOT_SET        0
#define MISSION_INCOMPLETE     1
#define MISSION_COMPLETE       2

#define LEVEL_01_MISSIONS_QTTY 3
#define LEVEL_02_MISSIONS_QTTY 3
#define LEVEL_03_MISSIONS_QTTY 4

#define CRC8_SALT_1            0b00000101
#define CRC8_SALT_2            0b11011001

#define SCR_SHIFT_RIGHT    0
#define SCR_SHIFT_LEFT     1
#define SCR_SHIFT_UP       2
#define SCR_SHIFT_DOWN     3
#define SCR_SHIFT_PORTAL   4

#define ANIMATE_OBJ_WALL   1
#define ANIMATE_OBJ_GATE   2
#define ANIMATE_OBJ_INTER  3
#define ANIMATE_OBJ_LOCKER 4
#define ANIMATE_OBJ_EGG    5
#define ANIMATE_OBJ_COLLC  6

#define GM_STATUS_LOOP_CONTINUE  0
#define GM_STATUS_CHANGE_MAP     1
#define GM_STATUS_TIME_IS_OVER   2
#define GM_STATUS_MISSION_CPLT   3
#define GM_STATUS_GAME_OVER      4
#define GM_STATUS_PLAYER_WIN     5


#define BOOL_FALSE 0
#define BOOL_TRUE  1


// ----------------------------------------------------------
// GLOBAL VARIABLES SECTION
// ----------------------------------------------------------

// Arkos data
extern uint8_t SONG[];
extern uint8_t EFFECTS[];

uint8_t cGameStage, cGameStatus, cLevel, cScreenMap, cScreenShiftDir, cMapX, cMapY;
uint8_t cPower,cLastPower;
uint16_t iScore;
uint8_t cScoretoAdd;
uint8_t cMissionStatus[MAX_MISSIONS]; // up to 4 missions per level
uint8_t cMissionQty, cRemainMission;
uint8_t cCtrl, cCtrlCmd;
uint8_t cCodeLenght, cMenuOption;
uint8_t cMeltdownMinutes, cMeltdownSeconds, cMeltdownTimerCtrl;
bool bIntroAnim;                      // enable/disable Intro animation with ESC key
bool bFinalMeltdown;                  // meltdown timer enabled/disabled

struct sprite_attr sGlbSpAttr;        // global sprite attribute struct - used by all entities

// Global variables for runtime speed optimization
uint16_t iGameCycles;
uint8_t cAnimTilesQty;
uint8_t cAnimSpecialTilesQty;
uint8_t cGlbSpecialTilesActive;
uint8_t cFatalFlag;   // used at is_player_jumping()
uint8_t cPortalFlag;  // used at is_player_jumping()
uint8_t cAnimCycleParityFlag;
bool bGlbSpecialProcessing;
bool bGlbMMEnabled;

uint8_t cAuxEntityX;   // used at Load_Entities() + its subroutines
uint8_t cAuxEntityY;   // used at Load_Entities() + its subroutines
uint8_t cObjType;      // used at Load_Entities() + its subroutines
uint8_t cGlbTile;      // used at Load_Entities() and Run_Game() + its subroutines
uint8_t cGlbObjData;   // used at Load_Entities() and Run_Game() + its subroutines
uint8_t cGlbSpObjID;   // used at Load_Entities() and Run_Game() + its subroutines
uint16_t iGlbPosition; // used at Load_Entities() and Run_Game() + its subroutines - values from 0 - 767
uint8_t cGlbFLDelay;

// our live entities - enemies and the player
PlyEntity sThePlayer;
EnemyEntity sEnemies[AVERAGE_ENEMIES_PER_SCREEN * MAPS];  // all the loaded enemy entities in the map
EnemyEntity *sGrabbedEnemyPtr;                            // when enemy grabs the player, this is the enemy entity ptr
AlienEntity sAlien;                                       // alien entity (1 single alien entity)

// Global variables for player control
uint8_t cGlbPlyFlag; // special global flag to describe player conflict with screen tiles

uint8_t cFFFlagColision;

uint8_t cGlbPlyJumpCycles;
uint8_t cGlbPlyJumpStage;
uint8_t cGlbPlyJumpDirection;
uint8_t cGlbPlyJumpDirCmd;
uint8_t cGlbPlyColor;
uint8_t cGlbWalkDir;
uint8_t cGlbPlyHitCount;
uint8_t cPlyNewX, cPlyNewY;
uint8_t cPlySafePlaceX, cPlySafePlaceY, cPlySafePlaceDir;
uint8_t cPlyPortalDestinyX, cPlyPortalDestinyY;
uint8_t cGlbPlyJumpTimer;     // timer to avoid an undesired jump just after a climp up
bool bGlbPlyMoved;            // TRUE if player has walked RIGHT/LEFT, climbed UP/DOWN or falling DOWN
bool bGlbPlyChangedPosition;  // TRUE if player has changed position (belt, colision, Moved)


uint8_t cPlyObjects, cPlyAddtObjects;
uint8_t cLives;
uint8_t cPlyRemainAmno;
uint8_t cPlyRemainShield;
uint8_t cPlyRemainFlashlight;
uint8_t cPlyHitTimer;
uint8_t cPlyDeadTimer;
uint8_t cRemainYellowCard;
uint8_t cRemainGreenCard;
uint8_t cRemainRedCard;
uint8_t cRemainKey;
uint8_t cRemainScrewdriver;
uint8_t cRemainKnife;

uint8_t cShotCount;
uint8_t cShotX, cShotY;
uint8_t cShotDir;
uint8_t cShotFrame;
uint8_t cShotPattern;
uint8_t cShotTrigTimer;

uint8_t cShieldFrame;
uint8_t cShieldUpdateTimer;
uint8_t cShieldPattern;

uint8_t cExplosionX, cExplosionY;
uint8_t cExplosionFrame;
uint8_t cShotExplosionPattern;

uint8_t cMiniMapX, cMiniMapY;
uint8_t cMiniMapFrame;
uint8_t cMiniMapPattern;

uint8_t cLastMMColor;     // color cache for MiniMap
uint8_t cLastShieldColor; // color cache for Shield
uint8_t cLastShotColor;   // color cache for Shot

uint8_t cGlbFlashLightAction;
uint8_t cGlbGameSceneLight;

uint8_t cFlashLUpdateTimer;

uint8_t cScreenEggsQtty;
uint8_t cCreatedEnemyQtty, cActiveEnemyQtty;
bool bCheckPlayerColision;
bool bCheckShotColision;
bool bShotColisionWithEnemy;

unsigned char cGlbBufNum[10];            // global buffer to support display_number(), display_objects(), display_power() and display_minimap() routines
unsigned char cBuffer[2048];             // general purpose buffer to unpack Tilesets, Colors, Maps and Sprites
unsigned char cGameText[GAMETEXT_SIZE];  // buffer to unpack Texts
unsigned char cAlienTileset[12 * 8 * 4]; // buffer to unpack and pre-process Alien animated tileset
unsigned char cTileClassLUT[256];        // tile class LookUp Table
unsigned char cPowerTile[8 * 3];         // copy buffer - Power tile from original Pattern table

// current map tile_map (uncompressed map data + entities) - can't use ROM directly because its compressed
uint8_t cMap_TileClass[MAP_BYTES_SIZE];
uint8_t cMap_ObjIndex[MAP_BYTES_SIZE];
uint8_t cMap_Data[MAP_BYTES_SIZE + (MAX_ANIM_TILES + MAX_ANIM_SPEC_TILES_FULL + MAX_ENEMIES_PER_SCREEN + 1) * 4];
uint8_t cTemp_Map_Data[MAP_BYTES_SIZE];


struct AnimatedTile sAnimTiles[MAX_ANIM_TILES];
struct AnimatedTile sAnimSpecialTiles[MAX_ANIM_SPEC_TILES_FULL];

struct AnimTileList sAnimTileList[MAX_ANIM_TILES + MAX_ANIM_SPEC_TILES_FULL];

#define MAX_OBJ_HISTORY_SIZE ((MAX_ANIM_SPEC_TILES + MAX_OBJECTS_PER_MAP) * MAPS)
struct ObjTileHistory sObjTileHistory[MAX_OBJ_HISTORY_SIZE + 1];

#define MAX_ANIMATED_OBJECTS (MAX_ENEMIES_PER_SCREEN + MAX_OBJECTS_PER_MAP)
struct ObjectScreen sObjScreen[MAX_ANIMATED_OBJECTS + 1];

#define MAX_LOCKERS_PER_LEVEL 16
bool cLockerOpened[MAX_LOCKERS_PER_LEVEL];

bool cAlienActiveatScreen[MAPS];   // for each screen: TRUE - Yes, activate Alien Creature, FALSE - No, do not activate Alien Creature

struct FlashLightStatusData sFlashLightStatusData;
struct FlashLightStatusData sFlashLightStatusDataAux;

struct AnimatedTile* pFreeAnimTile;
struct AnimatedTile* pFreeAnimSpecialTile;

struct AnimTileList* pAnimTileList;

struct ObjTileHistory* pFreeObjTileHistory;

struct ObjectScreen* pFreeObjectScreen;


// ----------------------------------------------------------
// GAME CODE SECTION
// ----------------------------------------------------------

/*
 * Unpack and load the right TileSet (pattern & color) to VDP memory.
 * IMPORTANT: must explicitly disable/enable screen when calling load_tileset()
 */
void load_tileset()
{
__asm
	ld a, (#_cGameStage)
	cp #GAMESTAGE_INTRO
	jr nz, _test_levelgs

  ; INTRO STAGE
_intro_stage :
	xor a
	ld (#_FONT1_TILE_OFFSET), a
	ld a, #TS_FONT1_SIZE + #TS_INTRO_SIZE
	ld (#_FONT2_TILE_OFFSET), a

	; upload font1 + intro + font 2 tileset
	ld hl, #_font1
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct

	ld hl, #_intro
	ld de, #_cBuffer + #TS_FONT1_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_font2
	ld de, #_cBuffer + #TS_FONT1_SIZE *#8 + #TS_INTRO_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_cBuffer
	call _ubox_set_tiles

	; now upload font1 color + intro color + font 2 color
	ld hl, #_font1_colors
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct

	ld hl, #_intro_colors
	ld de, #_cBuffer + #TS_FONT1_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_font2_colors
	ld de, #_cBuffer + #TS_FONT1_SIZE * #8 + #TS_INTRO_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_cBuffer
	call _ubox_set_tiles_colors
	ret


_test_levelgs :
	cp #GAMESTAGE_LEVEL
	jr nz, _test_gamegs

  ; GAME LEVEL STAGE
	; lets use same tiles from INTRO - FONT1 and FONT2
	jp _intro_stage


_test_gamegs :
	cp #GAMESTAGE_GAME
	jp nz, _test_gameovergs

	; GAME STAGE
	ld a, #TS_SCORE_SIZE + #TS_GAME0_SIZE + #TS_FATAL_SIZE
	ld (#_FONT1_TILE_OFFSET), a

	; upload score + gameX + fatal + font1 tileset
	ld hl, #_score
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct

	ld a, (#_cLevel)
	cp #2
	jr z, _ts_Level2
	ld hl, #_game0
	jr _continue_game_ts
_ts_Level2 :
	ld hl, #_game1
_continue_game_ts :
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_fatal
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8 + #TS_GAME0_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_font1
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8 + #TS_GAME0_SIZE * #8 + #TS_FATAL_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_cBuffer
	call _ubox_set_tiles

	; memcpy(cPowerTile, cBuffer + (SCORE_POWER_TILE + 1) * 8, 8 * 3); //copy the original power tile pattern
	ld hl, #_cBuffer + (#SCORE_POWER_TL_OFFSET + #01) * #8
	ld de, #_cPowerTile
	ld bc, #08 * #03
	ldir  ; ld (DE), (HL), then increments DE, HL, and decrements BC until BC = 0

	; now upload score colors + gameX colors + fatal colors + font1 colors
	ld hl, #_score_colors
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct

	ld a, (#_cLevel)
	cp #2
	jr z, _colorts_Level2
	ld hl, #_game0_colors
	jr _continue_game_colorts
_colorts_Level2 :
	ld hl, #_game1_colors
_continue_game_colorts :
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_fatal_colors
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8 + #TS_GAME0_SIZE * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_font1_colors
	ld de, #_cBuffer + #TS_SCORE_SIZE * #8 + #TS_GAME0_SIZE * #8 + #TS_FATAL_SIZE * #8
	call _zx0_uncompress_asm_direct
		
	ld hl, #_cBuffer
	call _ubox_set_tiles_colors
	ret

_test_gameovergs :
	cp #GAMESTAGE_GAMEOVER
	jr nz, _test_finalgs

	; GAME OVER STAGE
	jp _intro_stage


_test_finalgs :
	cp #GAMESTAGE_FINAL
	ret nz

	; due to Nostromo tileset size, its necessary to overide Font2, Font1 and Explosion
	xor a
	ld (#_FONT1_TILE_OFFSET), a
	ld a, #TS_FONT1_SIZE / #2
	ld (#_FONT2_TILE_OFFSET), a

	; upload font1 + font 2 + explosion + nostromo tileset
	ld hl, #_font2
	ld de, #_cBuffer + #TS_FONT1_SIZE * #4
	call _zx0_uncompress_asm_direct

	ld hl, #_font1
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct
	
	ld hl, #_explosion
	ld de, #_cBuffer + #16 * #8
	call _zx0_uncompress_asm_direct

	ld hl, #_nostromo
	ld de, #_cBuffer + #TS_FONT1_SIZE * #8 + #TS_FONT2_SIZE * #4
	call _zx0_uncompress_asm_direct

	ld hl, #_cBuffer
	call _ubox_set_tiles

	; upload font1 colors + font 2 colors + explosion colors + nostromo colors
	ld hl, #_font2_colors
	ld de, #_cBuffer + #TS_FONT1_SIZE * #4
	call _zx0_uncompress_asm_direct

	ld hl, #_font1_colors
	ld de, #_cBuffer
	call _zx0_uncompress_asm_direct

	ld hl, #_explosion_colors
	ld de, #_cBuffer + #16 * #8
	call _zx0_uncompress_asm_direct
		
	ld bc, #TS_NOSTROMO_SIZE * #8
	ld hl, #_cBuffer + #TS_FONT1_SIZE * #8 + #TS_FONT2_SIZE * #4
	ld e, #0xF0
_set_nostromo_color_loop :
	ld (hl), e
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, _set_nostromo_color_loop

	ld hl, #_cBuffer
	call _ubox_set_tiles_colors
__endasm;
}  // void load_tileset()


/*
 * Put a zero terminated string on the screen using tiles.
 * The font starts on the first tile from tileset cOffset and the first char has
 * ASCII value 31 (' ') - adjusted so we can use ASCII *uppercase* directly in our C code.
 * Returns the number of displayed characters.
 */
uint8_t display_text(uint8_t cX, uint8_t cY, uint8_t cOffset, const uint8_t* sMsg)
{
cX;
cY;
cOffset;
sMsg;

__asm
	push ix		;need to store IX and IY to secure C caller
	ld ix, #5 + #2
	add ix,sp
	ld l, 0 (ix)
	ld h, 1 (ix); HL = sMsg
	ld a, (hl)
	or a
	jr nz, _startText	; if sMsg==NULL, theres nothing to do
	ld l,#0
	pop ix
	ret

; Input: A = Text block # to be found (0 - 9 : ;)
; Output: A = BOOL_TRUE, HL = text buffer address
;         A = BOOL_FALSE
; Changes: A, B, C, E, H, L
_search_text_block :
	ld hl, #_cGameText
	ld bc, #GAMETEXT_SIZE
	ld e, a

_loop_text_search :
	ld a, #'<'
	cpir
	jr nz, _search_next_start_char
	cp (hl)
	jr nz, _search_next_start_char
	inc hl
	dec bc
	ld a, e
	add a, #'0'
	cp (hl)
	jr nz, _search_next_start_char
	inc hl
	ld a, #BOOL_TRUE
	ret

_search_next_start_char :
	ld a, b
	or c
	ld a, #BOOL_FALSE
	ret z
	dec bc
	inc hl
	jr _loop_text_search

_startText :
	ld	ix, #2 + #2
	add	ix, sp; IX = cX
	push de

	ld h, #0
	ld l, 1 (ix); HL = cY
	rlc l
	rlc l
	rlc l; L = cY * 8
	add hl, hl
	add hl, hl; HL = cY * 32
	ld b, #0
	ld c, 0 (ix); C = cX
	add hl, bc; HL = cY * 32 + cX
	ld bc, #UBOX_MSX_NAMTBL_ADDR
	add hl, bc; HL = VRAM_NAME_TBL + cY * 32 + cX
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)

	ld l, 3 (ix)
	ld h, 4 (ix)  ; HL = sMsg
	ld d, 2 (ix)  ; D = cOffset
	ld b, #0			; B = # of printed chars
_nextChar :
	ld a, (hl)
	or a
	jr z, _endText
	cp #' '
	jr z, _prt_blank 
	add	a, #0xe0; A = A - ' '
	add a, d	; A = A + cOffset
	jr _prt_char
_prt_blank :
	xor a
_prt_char :
  out (#0x98), a; write to VRAM
	inc b
	inc hl
	jr _nextChar

_endText :
	pop de
	pop ix
	ld l, b
__endasm;
}  // uint8_t display_text()

/*
 * Put an integer number (0 left formated) on the screen using tiles.
 */
void display_number(uint8_t cX, uint8_t cY, uint8_t cSize, uint16_t iValue)
{
__asm
	push ix; need to store IX and IY to restore after a C function call
	push iy
	ld	ix, #2 + #4
	add	ix, sp		; IX = cX

  ; fill cGlbBufNum with the right '0' tile#
	ld b,#5
	ld a, #1
	ld hl,#_cGlbBufNum
_fillLoop :
	ld (hl),a
	inc hl
	djnz _fillLoop
	dec hl      ; back IY to last buffer position
	push hl
	pop iy
	
;Binary to decimal ASCII
;Convert a 16-bit unsigned binary number to ASCII data
;HL = 16 bit unsigned to convert
	ld l, 3 (ix)
	ld h, 4 (ix)	; HL = iValue
_Cnvert :
	ld e,#0	    ;remainder = 0
	ld b,#16    ;16 bits in dividend
	or a        ;clear Carry to start

_DvLoop :
							;SHIFT THE NEXT BIT OF THE QUOTIENT INTO BIT 0 OF THE DIVIDEND
							;SHIFT NEXT MOST SIGNIFICANT BIT OF DIVIDEND INTO LEAST SIGNIFICANT BIT OF REMAINDER
							;HL HOLDS BOTH DIVIDEND AND QUOTIENT. QUOTIENT IS SHIFTED IN AS THE DIVIDEND IS SHIFTED OUT.
							;E IS THE REMAINDER.

							;DO A 24-BIT SHIFT LEFT, SHIFTING , CARRY TO L, L TO H, H TO E
	rl l				;CARRY (NEXT BIT OF QUOTIENT) TO BIT 0
	rl h				;SHIFT HIGH BYTE
	rl e				;SHIFT NEXT BIT OF DIVIDEND

							;IF REMAINDER IS 10 OR MORE, NEXT BIT OF QUOTIENT IS 1 (THIS BIT IS PLACED IN CARRY)
	ld a, e
	sub #10			;SUBTRACT 10 FROM REMAINDER;
	ccf					;COMPLEMENT CARRY
							;(THIS IS NEXT BIT OF QUOTIENT)
	jr nc, _DecCnt ;JUMP IF REMAINDER IS LESS THAN 10
	ld e, a			;OTHERWISE REMAINDER = DIFFERENCE BETWEEN PREVIOUS REMAINDER AND 10

_DecCnt :
	djnz _DvLoop ;CONTINUE UNTIL ALL BITS ARE DONE

							;SHIFT LAST CARRY INTO QUOTIENT
	rl l				;LAST BIT OF QUOTIENT TO BIT 0
	rl h

							;AT THIS POINT
							; HL = HL / 10
							; E = HL % 10
	ld a, #1
	add a, e
	ld 0 (iy), a		; INSERT THE NEXT CHARACTER IN ASCII
	dec iy

	ld a, h	; IF QUOTIENT IS NOT 0 THEN KEEP DIVIDING
	or l
	jr nz, _Cnvert

  ; _cGlbBufNum is now filled. Print it
	ld h, #0
	ld l, 1 (ix); HL = cY
	rlc l
	rlc l
	rlc l ; L = cY * 8
	add hl, hl
	add hl, hl; HL = cY * 32
	ld b, #0
	ld c, 0 (ix); C = cX
	add hl, bc; HL = cY * 32 + cX
	ld bc, #UBOX_MSX_NAMTBL_ADDR
	add hl, bc
	ex de,hl; DE = VRAM_NAME_TBL + cY * 32 + cX
	ld a, 2 (ix); A = cSize
	cp #5; Max cSize = 5
	jr c, _okSize
	ld a, #5
_okSize :
	ld c, a
	ld b, #0 ; BC = buffer size
	ld hl, #_cGlbBufNum + #05
	xor a; clear Carry Flag
	sbc hl, bc; set HL to the right buffer position based on cSize
	call #0x005C; LDIRVM - Block transfer to VRAM from memory
	pop iy
	pop ix
__endasm;
}  // void display_number()

/*
 * Update the Power battery based on cPower global variable (0-100).
 */
void display_power()
{
__asm
	ld a, (#_cPower)
	ld e, a
	ld a, (#_cLastPower)
	cp e
	ret z ; nothing to update
	ld b, #0xFF
	cp b
	jp nz, _calcPowerTile
	; first time, display the power tiles
	ld a, #SCORE_POWER_TL_OFFSET
	ld b, #5
	ld hl, #_cGlbBufNum
_fillBufP :
	ld (hl), a
	inc a
	inc hl
	djnz _fillBufP
	ld hl, #UBOX_MSX_NAMTBL_ADDR + (#2 * #32) + #2; (2, 2)
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)
	ld hl, #_cGlbBufNum
	ld b, #5
	ld c, #0x98
	;otir; writes B bytes from(HL) to VRAM
_lpOuti4 :
	outi; write 1 bytes from(HL) to VRAM and decrement B
	jr nz, _lpOuti4
_calcPowerTile :
	ld a,e
	ld (#_cLastPower), a
	; Calculate # of full power blocks and # of remainer for a non-full power block
	and #0b11111100
	rrca
	rrca
	ld e, a
	and #0b11111000
	rrca
	rrca
	rrca
	ld d, a ; D = # of full blocks
	ld a, e ; A = _cPower / 4
_mod8loop :
	cp #8
	jp c, _mod8found
	sub a, #8
	jp _mod8loop
_mod8found :
	ld e, a ; E = remain for a non-full power block

	; update the tiles based on the current power level
	ld c, #1 ; 3 blocks to fill
_newBlock :
	ld a, d ; full blocks
	cp c
	jp nc, _fill0xFF
	ld a,e ; remain
	or a
	jp z, _fill0x00
	; fill with Remainer
	ld a,#8
	sub e
	ld b, a
	ld a, #1
_sftRight :
	add a,a
	djnz _sftRight
	dec a
	cpl
	ld b,a
	ld e,#0
	jp _fillBuf
_fill0xFF :
	ld b, #0xFF
	jp _fillBuf
_fill0x00 :
	ld b, #0x00
_fillBuf :
	ld hl, #_cPowerTile
	ld a, c
	dec a
	add a,a
	add a,a
	add a,a
	inc a
	push de
	ld e,a
	ld d,#0
	add hl,de
	ld a, b
	ld b, #5
_lpFilBuf :
	ld (hl),a
	inc hl
	djnz _lpFilBuf
	pop de
	inc c
	ld a,c
	cp #4
	jp nz, _newBlock

	ld hl, #UBOX_MSX_PATTBL_ADDR + (#SCORE_POWER_TL_OFFSET + #01) * #8
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)

	ld hl, #_cPowerTile
	ld b, #8 * #3
	ld c, #0x98
_lpOuti6 :
	outi; write 1 bytes from(HL) to VRAM and decrement B
	jr nz, _lpOuti6
__endasm;
}  // void display_power()

/*
 * Increase the Player power.
 */
void increase_power(uint8_t cQtty)
{
__asm
	ld hl, #2
	add hl, sp
	ld a, (#_cPower)
	add a, (hl)
	cp #MAX_POWER + #1
	jr c, _PowerOk
	ld a, #MAX_POWER
_PowerOk :
	ld (#_cPower), a
	jp _display_power
__endasm;
}  // void increase_power()

/*
* Player was hit by something. Update status and decrease power
*/
void player_hit(uint8_t cPowerQtty)
{
__asm
	ld hl, #2
	add hl, sp
	ld a, (hl)
_player_hit_asm_direct :
	; if HIT_PTS_SMALL, check for Shield. If Shield active, no hit is set.
	; if HIT_PTS_FACEHUG, HIT_PTS_MEDIUM, HIT_PTS_HIGH or HIT_PTS_TONGUE hit happens regardless of the Shield.
	cp #HIT_PTS_SMALL
	jr nz, _hit_execute
	ld h, a
	ld a, (#_cPlyRemainShield)
	or a
	ret nz
	ld a, h
_hit_execute :
	ld (#_cGlbPlyHitCount), a
	ld a, #BOOL_TRUE
	ld (#_sThePlayer + #4), a  ; player.hitflag = TRUE
__endasm;
}  // void player_hit()

/*
* Update Color table from Mission tiles based on mission accomplished status
*/
void update_mission_status()
{
__asm
  ld hl, #_cMissionStatus
	;ld b, #MAX_MISSIONS
	;ld c, #0
	ld bc, #0x0400
	ld d, #0

_check_mission_complete :
	ld a, #MISSION_COMPLETE
	cp (hl)
	jr nz, _next_mission
	push bc
	push hl
	xor a ; clear carry flag
	ld a, #SCORE_MISSION_TL_OFFSET
	add a, c
	rla
	rla
	rla
	ld e, a
	ld hl, #UBOX_MSX_COLTBL_ADDR
	add hl, de
	ld a, #0xFC  ; Background = green, Foreground = white
	ld bc, #7
	call #0x0056  ; FILVRM - Fill VRAM with value
	pop hl
	pop bc
_next_mission :
	inc hl
	inc c
	djnz _check_mission_complete

	; mplayer_play_effect_p(SFX_MISSIONCPLT, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x000B; 00 + SFX_MISSIONCPLT
	call	_mplayer_play_effect_p_asm_direct

	; if Level = 3 and Mission_3 = Complete, enable bFinalMeltdown timer flag
	ld a, (#_cLevel)
	cp #3
	ret nz
	ld a, (#_bFinalMeltdown)
	cp #BOOL_TRUE
	ret z
	ld a, (#_cMissionStatus + #2)
	cp #MISSION_COMPLETE
	ret nz
	ld a, #BOOL_TRUE
	ld (#_bFinalMeltdown), a
	; set countdown timer to 10:00
	ld a, #10
	ld (#_cMeltdownMinutes), a
	xor a
	ld (#_cMeltdownSeconds), a
  ld (#_cMeltdownTimerCtrl), a
__endasm;
}  // void update_mission_status()

/*
* Display the number of lives
*/
void display_lives()
{
__asm
  ld hl, #UBOX_MSX_NAMTBL_ADDR + #2
	ld bc, #MAX_LIVES
	ld a, #BLANK_TILE
	call #0x0056; FILVRM - Fill VRAM with value
	ld a, (#_cLives)
	ld c, a
	ld a, #SCORE_LIFE_TL_OFFSET
	call #0x0056; FILVRM - Fill VRAM with value
__endasm;
}  // void display_lives()

/*
* Display/Hide the mini-map
*/
void display_minimap()
{
__asm
	ld a, #SCORE_MAP_TL_OFFSET
	ld (#_bGlbMMEnabled), a  ; bGlbMMEnabled = true
	ld hl, #_cGlbBufNum
	ld b, #6
_fillBufX :
	ld (hl), a
	inc a
	inc hl
	djnz _fillBufX

	ld bc, #3
	ld de, #UBOX_MSX_NAMTBL_ADDR + #SCORE_MINIMAP_Y_POS * #32 + #SCORE_MINIMAP_X_POS
	ld hl, #_cGlbBufNum
	call #0x005C  ; LDIRVM - Copia um bloco da RAM para a VRAM
	ld bc, #3
	ld de, #UBOX_MSX_NAMTBL_ADDR + (#SCORE_MINIMAP_Y_POS + #1) * #32 + #SCORE_MINIMAP_X_POS
	ld hl, #_cGlbBufNum + #3
	call #0x005C; LDIRVM - Copia um bloco da RAM para a VRAM
__endasm;
}  // void display_minimap()

/*
* Display the objects carried by the player
*/
void display_objects()
{
__asm
	ld a, #SCORE_OBJ_TL_OFFSET + #2  ; amno and battery
	ld c, a
	ld hl, #_cGlbBufNum + #MAX_OBJECTS
	ld a, (#_cPlyObjects)
	ld e, #0
	ld b, #MAX_OBJECTS
_stObjLoop :
	bit 0, a
	jr z, _noObj
	ld (hl), c
	dec hl
	inc e
_noObj :
	srl a
	inc c
	djnz _stObjLoop
	; add extra blank tile in the begining
  ld (hl), #0
	push hl
	inc e
	ld b, e  ; B = # of objects + blank tile
	ld hl, #UBOX_MSX_NAMTBL_ADDR + (#2 * #32) + (#32)
	ld d, #0
	xor a
	sbc hl, de
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)
	pop hl
	ld c, #0x98
	;otir; writes B bytes from(HL) to VRAM
_lpOuti3 :
	outi; write 1 bytes from(HL) to VRAM and decrement B
	jr nz, _lpOuti3
__endasm;
}  // void display_objects()

void display_score()
{
__asm
  ; display_number(2, 1, 5, iScore);
  ld	bc, (#_iScore)
	push	bc
	ld	de, #0x0501
	push	de
	ld	a, #2
	jr _displ_num
__endasm;
} // void display_score()

void display_level()
{
	display_number(28, 0, 1, cLevel);  // keep in C - cant call _displ_num due to stack parameter order
__asm
	; display_number(30, 0, 2, cScreenMap);
	ld	a, (#_cScreenMap)
	ld	c, a
	ld	b, #0x00
	push	bc
	ld	de, #0x0200
	push	de
	ld	a, #30
	jr _displ_num
__endasm;
}  // void display_level()

void display_gun_amno()
{
__asm
	; display_number(15, 2, 2, cPlyRemainAmno);
  ld	a, (#_cPlyRemainAmno)
	ld	c, a
	ld	b, #0x00
	push	bc
	ld	de, #0x0202
	push	de
	ld	a, #15
_displ_num :
	push	af
	inc	sp
	call	_display_number
	pop	af
	pop	af
	inc	sp
__endasm;
} // void display_gun_amno()

void display_shield()
{
__asm
	; display_number(10, 2, 2, cPlyRemainShield);
	ld	a, (#_cPlyRemainShield)
	ld	c, a
	ld	b, #0x00
	push	bc
	ld	de, #0x0202
	push	de
	ld	a, #10
	jr _displ_num
__endasm;
} // void display_shield()

void display_flashlight()
{
__asm
  ; display_number(20, 2, 2, cPlyRemainFlashlight);
	ld	a, (#_cPlyRemainFlashlight)
	ld	c, a
	ld	b, #0x00
	push	bc
	ld	de, #0x0202
	push	de
	ld	a, #20
	jr _displ_num
__endasm;
} // void display_flashlight()

/*
* Draw the Score text for all Map Level screens
* LIVES, LEVEL, SCORE, POWER, AMNO, SHIELD, MISSIONS
*/
void Draw_Score_Panel()
{
__asm
  ;put_tile_block(0, 0, SCORE_MAP_TL_OFFSET + 6, 2, 3);  // LIFE:, SCORE: & POWER:
	ld bc, #0x0000
	ld a, #SCORE_MAP_TL_OFFSET + #6
	ld de, #0x0203
  call _put_tile_block_asm_direct
	;put_tile_block(26, 0, SCORE_MAP_TL_OFFSET + 6 + 2 * 3, 2, 2);  // LEVEL: & MISSIONS:
	ld bc, #0x001A
	ld a, #SCORE_MAP_TL_OFFSET + #6 + #2 * #3
	ld de, #0x0202
	call _put_tile_block_asm_direct
	;put_tile_block(28, 1, SCORE_MISSION_TL_OFFSET, cMissionQty, 1);  // Missions 1, 2, 3 and 4
	ld bc, #0x011C
	ld e, #0x01
	ld a, (#_cMissionQty)
	ld d, a
	ld a, #SCORE_MISSION_TL_OFFSET
	call _put_tile_block_asm_direct

  ; ubox_put_tile(9, 2, SCORE_SHIELD_TL_OFFSET);
  ld a, #SCORE_SHIELD_TL_OFFSET
  ld bc, #0x0209
  call _put_tile_asm_direct
	; ubox_put_tile(14, 2, SCORE_AMNO_TL_OFFSET);
	ld a, #SCORE_AMNO_TL_OFFSET
	ld bc, #0x020E
	call _put_tile_asm_direct
	; ubox_put_tile(19, 2, SCORE_BATTERY_TL_OFFSET);
	ld a, #SCORE_BATTERY_TL_OFFSET
	ld bc, #0x0213
	call _put_tile_asm_direct
	; ubox_put_tile(29, 0, SCORE_SLASH_TL_OFFSET);
	ld a, #SCORE_SLASH_TL_OFFSET
	ld bc, #0x001D
	call _put_tile_asm_direct
__endasm;

	display_lives();
	display_score();
	display_power();
	display_level();
	display_gun_amno();
	display_flashlight();
	display_shield();
}  // Draw_Score_Panel()

void display_intro_credits()
{
__asm
	call _clear_box
	
	ld a, #GAME_TEXT_CREDITS_LABEL_ID
	call _search_text_block
	ld b, #INTRO_MENU_POS_Y
	ld c, #0x01
	ld de, #0x0000
	call _display_format_text_block

	ld a, #GAME_TEXT_CREDITS_VALUE_ID
	call _search_text_block
	ld b, #INTRO_MENU_POS_Y + #1
	ld c, #14
	ld de, #0x0000
	call _display_format_text_block

	call _clean_buff
	call _wait_fire

	; execute _clear_box again before returns
_clear_box :
	; Fill_Box(1, INTRO_MENU_POS, 30, 7, BLANK_TILE);
	xor a
	ld c, #0x01
	ld b, #INTRO_MENU_POS_Y
	ld de, #0x1E07
	jp _fill_block_asm_direct

_clean_buff :
	call	_ubox_wait
	; while (ubox_read_ctl(cCtrl) & UBOX_MSX_CTL_FIRE1);
	ld	a, (#_cCtrl)
	ld	l, a
	call	_ubox_read_ctl
	bit	4, l
	jr	nz, _clean_buff
	ret

_wait_fire :
	call	_ubox_wait
	; while (!(ubox_read_ctl(cCtrl) & UBOX_MSX_CTL_FIRE1));
	ld a, (#_cCtrl)
	ld l, a
	call _ubox_read_ctl
	bit	4, l
	jr z, _wait_fire
__endasm;
}  // display_intro_credits()

void display_game_logo()
{
__asm
	push iy

	; Set IY at Block size matrix
	ld iy, #_cCycleTable + #INTRO_BLOCK_OFFSET * #10
	ld b, #12 ; 12 animation steps
	ld c, #TS_FONT1_SIZE; First Intro tile
_new_anim_step :
	push bc
	call _anim_intro_block
	ld de, #05
	add iy, de
	ld	a, (#_bIntroAnim)
	or a
	jr	z, _no_wait
	ld	l, #0x08
	call	_ubox_wait_for
_no_wait :
	ld d, c ; D = Last tile used
	pop bc
	ld c, d
	djnz _new_anim_step

	; Display_Text(18, 7, FONT2_TILE_OFFSET, ".UNOFFICIAL");
	ld	hl, #__intro_str_0
	push	hl
	ld	a, (#_FONT2_TILE_OFFSET)
	push	af
	inc	sp
	ld	de, #0x0712
	push	de
	call	_display_text
	pop	af
	inc	sp
	pop af
	pop iy
	ret

	; C = First intro tile for this block
	; (iy + 0) = X
	; (iy + 1) = Block Size
	; Returns C = Last used tile
_anim_intro_block :
	push bc ; store initial C for future use
	ld b, #04 ; Logo height = 4
	push iy
	pop hl
	ld e, #2 ; Y
	ld a, (hl); X
	ld d, a; D = X
_new_logo_line :
	inc hl
	ld a, (hl) ; Block size
	or a
	jr z, _next_logo_line
	push bc

	ld a, c ; A = Tile
	ld c, d ; C = X
	ld d, (hl) ; D = Width
	ld b, e ; B = Y
	ld e, #01; Height

	push bc
	push hl	
	call	_put_tile_block_asm_direct
	push af
	call _check_escape
	pop af
	pop hl
	pop bc

	ld e, b
	ld d, c
	ld c, a ; Tile+=Block size

	pop af
	ld b, a
_next_logo_line :
	inc e
	djnz _new_logo_line
	
	pop de ; E = restore initial tile block
	ld a, e
	sub c ; A = # of displayed tiles

	push bc ; C = Last block tile used

	; change color table for selected tiles
	ld b, #4 ; 4 color animation
	push ix
	ld ix, #__intro_color_tbl
_new_color_anim :
	push bc

	ld h, #0
	ld l, e
	rlc l
	add hl, hl
	add hl, hl
	ld bc, #UBOX_MSX_COLTBL_ADDR
	add hl, bc

	ld c, a
	rlc c
	rlc c
	rlc c
	ld b, #0

	push af
	ld a, (ix)
	inc ix

	call #0x0056; FILVRM - Fill VRAM with value(HL, BC, A)
	call _check_escape
	ld	a, (#_bIntroAnim)
	or a
	jr	z, _no_wait2
	ld	l, #0x02
	call	_ubox_wait_for
_no_wait2 :
	pop af
	pop bc
	djnz _new_color_anim
	pop ix
	pop bc ; recover last block tile used
	ret

_check_escape :
	; if (ubox_read_keys(7) == UBOX_MSX_KEY_ESC) bIntroAnim = false;
	ld	l, #0x07
	call	_ubox_read_keys
	ld	a, l
	sub #UBOX_MSX_KEY_ESC
	ret	nz
	ld (#_bIntroAnim), a
	ret

__intro_str_0:
.ascii ".UNOFFICIAL"
.db 0x00

__intro_color_tbl:
.db 0b11100000; 14 << 4; // Gray
.db 0b01010000; 5 << 4;  // Light Blue
.db 0b01000000; 4 << 4;  // Dark Blue
.db 0b11110000; 15 << 4; // White
__endasm;
}  // void display_game_logo()


/*
* Display Intro Screen + Interactive menu and waits for user selection
*/
void draw_intro_screen()
{
__asm
  ; mplayer_init(SONG, SONG_SILENCE);
	ld a, #SONG_SILENCE
	ld hl, #_SONG
	call _mplayer_init_asm_direct

  call _ubox_disable_screen

	; upload intro tileset
	ld hl, #_cGameStage
	ld (hl), #GAMESTAGE_INTRO
	call _load_tileset

	; clear the screen
	ld	l, #BLANK_TILE
	call	_ubox_fill_screen
	call _ubox_enable_screen

	call _display_game_logo

	ld a, #SONG_INTRO
	ld hl, #_SONG
	call _mplayer_init_asm_direct

	ld a, (#_cCtrl)
	cp #UBOX_MSX_CTL_NONE
	jr nz, _cctrl_selected
	; display_text(3, INTRO_MENU_POS, FONT1_TILE_OFFSET, "PRESS FIRE OR TRIGGER >");
	ld a, #GAME_TEXT_INTRO_CONTROL_ID
	call _search_text_block
	ld b, #INTRO_MENU_POS_Y
	ld c, #0x03
	ld de, #0x0000
	call _display_format_text_block

	; wait until fire is pressed - can be space (control will be cursors), or any fire button on a joystick
	call _ubox_reset_tick
	ld c, #0
_cctrl_loop :
	ld a, (#_cCtrl)
	cp #UBOX_MSX_CTL_NONE
	jr nz, _finish_cctrl_loop
	call _ubox_select_ctl
	ld	a, l
	ld (#_cCtrl), a

	ld a, (#_ubox_tick)
	cp #15
	jr nz, _cctrl_loop
	push bc
	; put_tile_block(26, INTRO_MENU_POS, INTRO_CTRL_TILE_NR + 9 + (cCtrl_frames[cCont] << 2), 2, 2);
	ld hl, #_cCtrl_frames
	ld b, #0
	add hl, bc
	ld a, (hl)
  add a, #INTRO_CTRL_TILE_NR + #9
	ld c, #INTRO_MENU_POS_X + #20
	ld b, #INTRO_MENU_POS_Y
	ld de, #0x0202
	call	_put_tile_block_asm_direct
	pop bc
	inc c
	ld a, c
	cp #INTRO_CTRL_CYCLE
	jr nz, _cont_cctrl_anim
	ld c, #0
_cont_cctrl_anim :
	call _ubox_reset_tick
	jr _cctrl_loop

_finish_cctrl_loop :
	; put_tile_block(3, INTRO_MENU_POS, BLANK_TILE, 23, 1);
	xor a
	ld b, #INTRO_MENU_POS_Y
	ld c, #0x03
	ld de, #0x1701
	call	_fill_block_asm_direct

_cctrl_selected :
	; display the selected control
	ld a, (#_cCtrl)
	cp #UBOX_MSX_CTL_CURSOR
	jr nz, _try_joy_1

  ; put_tile_block(26, INTRO_MENU_POS, INTRO_CTRL_TILE_NR + 5, 2, 2);
	ld a, #INTRO_CTRL_TILE_NR + #5
	jr _disp_cctrl
_try_joy_1 :
	; put_tile_block(26, INTRO_MENU_POS, INTRO_CTRL_TILE_NR, 2, 2);
	ld a, #INTRO_CTRL_TILE_NR
_disp_cctrl :
	ld c, #INTRO_MENU_POS_X + #20
	ld b, #INTRO_MENU_POS_Y
	ld de, #0x0202
	call	_put_tile_block_asm_direct
	ld a, (#_cCtrl)
	cp #UBOX_MSX_CTL_PORT1
	jr z, _end_display_cctrl
_try_joy_2 :
	cp #UBOX_MSX_CTL_PORT2
	jr nz, _end_display_cctrl
	; ubox_put_tile(27, INTRO_MENU_POS, INTRO_CTRL_TILE_NR + 4);
	ld a, #INTRO_CTRL_TILE_NR + #4
	ld b, #INTRO_MENU_POS_Y
	ld c, #INTRO_MENU_POS_X + #20 + #1
	call _put_tile_asm_direct

_end_display_cctrl :
	; display_text(8, INTRO_MENU_POS, FONT1_TILE_OFFSET, "START GAME");
	; display_text(8, INTRO_MENU_POS + 1, FONT1_TILE_OFFSET, "GAME CREDITS");
	ld a, #GAME_TEXT_INTRO_MENU_ID
	call _search_text_block
	ld b, #INTRO_MENU_POS_Y
	ld c, #INTRO_MENU_POS_X
	ld de, #0x0000
	call _display_format_text_block

	xor a
	ld (#_cMenuOption), a
_start_user_selection :
	call _display_curr_selection

_select_user_option :
	call _clean_buff
	; continuous loop until 'Start Game' or 'Level Code + valid code ' selected
	call _ubox_reset_tick
_select_user_option_ex :
	ld a, (#_ubox_tick)
	cp #8
	jr nc, _try_up_or_down
	ld a, (#_cCtrl)
  ld l, a
	call _ubox_read_ctl
	ld a, l
	ld (#_cCtrlCmd), a
	jr _select_user_option_ex

_try_up_or_down :
	ld a, (#_cCtrlCmd)
  and #UBOX_MSX_CTL_UP
	jr z, _try_menu_down
	ld a, (#_cMenuOption)
	or a
	jr nz, _up_menu_option
	ld a, #MAX_INTRO_MENU_OPTIONS
_up_menu_option :
	dec a
	ld (#_cMenuOption), a
	jr _start_user_selection

_try_menu_down :
	ld a, (#_cCtrlCmd)
	and #UBOX_MSX_CTL_DOWN
	jr z, _try_menu_fire
	ld a, (#_cMenuOption)
	inc a
	cp #MAX_INTRO_MENU_OPTIONS
	jr nz, _down_menu_option
	xor a
_down_menu_option :
	ld (#_cMenuOption), a
	jr _start_user_selection

_try_menu_fire :
	ld a, (#_cCtrlCmd)
	and #UBOX_MSX_CTL_FIRE1
	jp z, _select_user_option
	
	ld a, (#_cMenuOption)
	cp #1
	jr nz, _try_level_code
	; credits
	call _display_intro_credits;
	jp _cctrl_selected

_try_level_code :
  cp #2
	ret nz ; start game selected
	
	xor a
	ld (#_cCodeLenght), a
	ld (#_cBuffer + #18), a

	call _display_ins_code

_get_input_code : 
	; ESC, RET and BACKSPACE
	ld l, #0x07
	call _ubox_read_keys
	ld a, l
	cp #UBOX_MSX_KEY_ESC
	jp z, _cctrl_selected
	cp #UBOX_MSX_KEY_BS
	jp z, _insert_backspace
	cp #UBOX_MSX_KEY_RET
	jp z, _decode_level_code

	; A and B
	ld l, #0x02
	call _ubox_read_keys
	ld a, l
	ld c, #0
	cp #UBOX_MSX_KEY_A
	jr nz, _test_B
	jr _new_key_typed
_test_B :
	inc c
	cp #UBOX_MSX_KEY_B
	jr nz, _test_C_to_J
	jr _new_key_typed

	; C to J
_test_C_to_J :
	ld l, #0x03
	call _ubox_read_keys
	ld a, l
	ld c, #2
	ld b, #8  ; 8 keys to check for line row #3
	ld d, #UBOX_MSX_KEY_C
_test_all_keys_from_row :
	cp d
	jr z, _new_key_typed
	inc c ; carry 0
	rl d
	djnz _test_all_keys_from_row

  ; K to R
	ld l, #0x04
	call _ubox_read_keys
	ld a, l
	ld c, #10
	ld b, #8  ; 8 keys to check for line row #4
	ld d, #UBOX_MSX_KEY_K
_test_all_keys_from_row_2 :
  cp d
	jr z, _new_key_typed
	inc c; carry 0
	rl d
	djnz _test_all_keys_from_row_2

	jp _get_input_code

_new_key_typed :
	ld hl, #_cCodeLenght
	ld a, (hl)
	cp #8
	jr z, _get_input_code
	ld a, c
	add a, #'A'
	ld c, (hl)
	inc (hl)
	ld b, #0
	ld hl, #_cBuffer + #10
	add hl, bc
	ld (hl), a

	call _display_ins_code
	; mplayer_play_effect_p(SFX_TYPING, SFX_CHAN_NO, 0);
_wait_and_reak_key_ex_2 :
	ld de, #0x000A; 00 + SFX_TYPING
_wait_and_reak_key_ex :
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	call	_mplayer_play_effect_p_asm_direct
_wait_and_reak_key :
	; wait some cycles before restart reading keyboard
	ld	l, #12
	call _ubox_wait_for
	jp _get_input_code

_display_ins_code :
	ld hl, #_cCodeLenght
	ld a, #8
	sub (hl)
	jr z, _disp_lvl_code
	ld b, a
	ld hl, #_cBuffer + #17
_upd_code_buffer :
	ld (hl), #'-'
	dec hl
	djnz _upd_code_buffer

_disp_lvl_code :
 ;; Display_Text(17, 18, FONT2_TILE_OFFSET, cBuffer + 10);
	ld hl, #_cBuffer + #10
	push hl
	ld a, (#_FONT2_TILE_OFFSET)
	push af
	inc	sp
	ld de, #0x1211
	push de
	call _display_text
	pop	af
	inc	sp
	pop af
	ret

_decode_level_code :
	ld a, (#_cCodeLenght)
	cp #8
	jr nz, _wait_and_reak_key
	; step 1: DEC 'A' to each CHAR code to generate original nibble
	; step 2: un - shuffle nibbles[4, 1, 8, 3, 5, 9, 2, 0] to [0, 1, 2, 3, 4, 5, *6, *7, 8, 9] (insert SALT_2)
	ld hl, #_cBuffer
	ld a, (#_cBuffer + #17)
	call _do_sub_and_rotate
	ld b, a
	ld a, (#_cBuffer + #11)
	call _do_sub_and_merge
	ld a, (#_cBuffer + #16)
	call _do_sub_and_rotate
	ld b, a
	ld a, (#_cBuffer + #13)
	call _do_sub_and_merge
	ld a, (#_cBuffer + #10)
	call _do_sub_and_rotate
	ld b, a
	ld a, (#_cBuffer + #14)
	call _do_sub_and_merge
	ld a, #CRC8_SALT_2
	ld (hl), a
	inc hl
	ld a, (#_cBuffer + #12)
	call _do_sub_and_rotate
	ld b, a
	ld a, (#_cBuffer + #15)
	call _do_sub_and_merge

	; step 3: compute back iScore[16 bit] + cLives[3 bit] + cLevel[2 bit] + SALT_1[3 bit] + SALT_2[8 bit] + CRC[8bit]
	; step 4: check SALT_1, cLives, cLeveland CRC. Reject code if fails
	ld hl, #_cBuffer
	ld de, #04
	call _crc8b
	ld b, a  ; calculated CRC8
	ld a, (#_cBuffer + #4) ; CRC8 byte from input code
	cp b
	jr nz, _lvl_code_invalid

	ld a, (#_cBuffer + #2) ; cLives[3 bit] + cLevel[2 bit] + SALT_1[3 bit]
	ld b, a
	and #0b00000111
	cp #CRC8_SALT_1
	jr nz, _lvl_code_invalid

	ld a, b
	rrca
	rrca
	rrca
	and #0b00000011 ; valid = 2 or 3
	ld c, a ; temp cLevel
	cp #2
	jr c, _lvl_code_invalid

	ld a, b
	rlca
	rlca
	rlca
	and #0b00000111; valid = 1 to 5
	ld d, a ; temp cLives
	or a
	jr z, _lvl_code_invalid
	cp #6
	jr nc, _lvl_code_invalid

	; code is valid!
	ld hl, #_cLevel
	ld (hl), c
	ld hl, #_cLives
	ld (hl), d
	ld hl, (#_cBuffer + #0)
	ld (#_iScore), hl
	ret ; exit from intro menu and start game with level code information

_lvl_code_invalid :
	; mplayer_play_effect_p(SFX_HURT, SFX_CHAN_NO, 0);
	ld de, #0x0005; 00 + SFX_HURT
	jp _wait_and_reak_key_ex


_do_sub_and_rotate :
	sub #'A'
	rlca
	rlca
	rlca
	rlca
	ret

_do_sub_and_merge :
	sub #'A'
	or b
	ld (hl), a
	inc hl
	ret

_insert_backspace :
	ld a, (#_cCodeLenght)
	or a
	jp z, _wait_and_reak_key
	dec a
	ld (#_cCodeLenght), a
	call _display_ins_code
	jp _wait_and_reak_key_ex_2

_display_curr_selection :
	; clear current selection
	; put_tile_block(6, INTRO_MENU_POS, BLANK_TILE, 1, MAX_INTRO_MENU_OPTIONS);
	xor a
	ld b, #INTRO_MENU_POS_Y
	ld c, #INTRO_MENU_POS_X - #2
	ld d, #0x01
	ld e, #MAX_INTRO_MENU_OPTIONS
	call	_fill_block_asm_direct

	; ubox_put_tile(6, INTRO_MENU_POS + cMenuOption, FONT1_TILE_OFFSET + '_' - ' '); // >
	ld a, (#_cMenuOption)
	add #INTRO_MENU_POS_Y
	ld b, a
	ld c, #INTRO_MENU_POS_X - #2
	ld a, (#_FONT1_TILE_OFFSET)
	add a, #'_' - #' '
	jp _put_tile_asm_direct
__endasm;
}  // void draw_intro_screen()

/*
* Display the right game map
* Tileset must already be set
* cMap_Data variable must alredy be set to the right map data
*/
void draw_map()
{
__asm
	ld a, (#_cGlbGameSceneLight)
	bit 0, a ; A = LIGHT_SCENE_ON_FL_ANY?
	halt
	jr nz, _do_draw_map

_do_scenelights_off :
	ld a, #BLACK_TILE
	ld bc, #MAP_BYTES_SIZE
	ld hl, #UBOX_MSX_NAMTBL_ADDR + #MAP_W * #3
	call #0x0056  ; FILVRM [Preenche um bloco da VRAM com um byte A = Byte de dado, BC = Comprimento, HL = Endereço VRAM]
	ret

_do_draw_map :
	ld hl, #_cMap_Data
	ld de, #UBOX_MSX_NAMTBL_ADDR + #MAP_W * #3
	ld bc, #MAP_BYTES_SIZE
	call #0x005C ; LDIRVM - Copia um bloco da RAM para a VRAM / BC = Comprimento, DE = Endereço VRAM, HL = Endereço RAM / Modifica : AF, BC, DE, HL, EI
__endasm;
} // void draw_map()

/*
* Reset the list of animated Objects at screen for each new screen
*/
void reset_screen_objects()
{
__asm
	ld hl, #_sObjScreen
	ld (#_pFreeObjectScreen), hl
	ld b, #MAX_ANIMATED_OBJECTS + #01
	ld de, #06
_reset_loop_2 :
	ld (hl), #0xFF
	add hl, de
	djnz _reset_loop_2
	xor a
	ld (#_cScreenEggsQtty), a
__endasm;
}  // void reset_screen_objects()

/*
* Detect if current animated object (slider) colides with the player. If YES, update player position and status accordly
* Input: C = update mode (UPD_OBJECT_UP_8, UPD_OBJECT_DOWN_8, UPD_OBJECT_RIGHT_8, UPD_OBJECT_LEFT_8)
*				 DE = struct ObjectScreen * 
* Changes: A, B, C, D, E, H, L
*/
void detect_player_colision()
{
__asm
	push ix
	push de
	pop ix ; IX = struct ObjectScreen*
	ld a, c

	cp #UPD_OBJECT_UP_8
	jp nz, _check_down_8
	; if (player.y >= Object.cY1) or (player.y + 15 < Object.cY0) then no_vertical_colision
	ld a, (#_sThePlayer + #1); A = player->y
	cp 4 (ix); ScreenObject->cY1
	jp nc, _no_vertical_colision
	add a, #15
	cp 3 (ix); ScreenObject->cY0
	jp c, _no_vertical_colision
	; if (player.x + 3 >= Object.cX1) or (player.x + 12 - 1 < Object.cX0) then no_horizontal_colision
	ld a, (#_sThePlayer); A = player->x
	add a, #3
	cp 2 (ix); ScreenObject->cX1
	jp nc, _no_horizontal_colision
	add a, #9 - #1
	cp 1 (ix); ScreenObject->cX0
	jp c, _no_horizontal_colision
	; colision detected. Need to check if its a body colision (update player X coordinate) or a foot colision (update player Y coordinate)
	; if (player.x + 5 >= Object.cX1) or (player.x + 10 < Object.cX0) then no_horizontal_colision
	sub #6
	cp 2 (ix); ScreenObject->cX1
	jp nc, _no_foot_colision
	add a, #5
	cp 1 (ix); ScreenObject->cX0
	jp c, _no_foot_colision
	; foot colision detected. Update player Y coordinate above the object and stop falling
	; if PLYR_STATUS_JUMPING, set cGlbPlyJumpTimer = ONE_SECOND_TIMER/2 before restoring status to PLYR_STATUS_STAND (avoid double jump)
	ld a, (#_sThePlayer + #03) ; A = sThePlayer.status
	cp #PLYR_STATUS_JUMPING
	jr nz, _set_status_stand
	ld a, #ONE_SECOND_TIMER >> #2
	ld (#_cGlbPlyJumpTimer), a
_set_status_stand :
	ld a, #PLYR_STATUS_STAND
	ld (#_sThePlayer + #03), a ; A = sThePlayer.status
	ld e, #256 - #16
_updt_Y_coordinate :
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a
	ld a, 3 (ix); A = ScreenObject->cY0
	add a, e
	ld (#_sThePlayer + #1), a ; player->y = ScreenObject->cY0 - 16 / player->y = ScreenObject->cY0 + 8
	ld a, e
	cp #8 ; if it comes from #UPD_OBJECT_DOWN_8, no need to check colision
	jp z, _end_detection

	ld b, #HIT_PTS_HIGH; strong colision - decrease HIT_PTS_HIGH power units
	ld d, #0
	; if (player.x + 4 >= Object.cX0) then no_horizontal_left_colision
	ld a, (#_sThePlayer); A = player->x
	add a, #4
	cp 1 (ix); ScreenObject->cX0
	jr nc, _no_horiz_left_colision
	; possible top left colision to be checked
	ld c, #4
	call _calcTileXYAddrInt
	ld a, (hl)
	; lets check the tile at player head for a solid one
	bit #7, a ; test if bit 7 (SOLID BIT) is set
	jp z, _end_detection
	ld a, 1 (ix); A = ScreenObject->cX0
	ld e, #256 - #4
	jp _end_horiz_upd

_no_horiz_left_colision :
	; if (player.x + 10 < Object.cX1) then end_detection (no horizontal right colision)
	add a, #6
	cp 2 (ix); ScreenObject->cX1
	jp c, _end_detection
	; possible top right colision to be checked
	ld c, #11
	call _calcTileXYAddrInt
	ld a, (hl)
	; lets check the tile at player head for a solid one
	bit #7, a; test if bit 7 (SOLID BIT) is set
	jp z, _end_detection
	ld a, 2 (ix); A = ScreenObject->cX1
	ld e, #256 - #11
  jp _end_horiz_upd

_check_down_8 :
	cp #UPD_OBJECT_DOWN_8
	jr nz, _check_right_8
	; if (player.x + 3 >= Object.cX1) or (player.x + 12 - 1 < Object.cX0) then no_horizontal_colision
	ld a, (#_sThePlayer); A = player->x
	add a, #3
	cp 2 (ix); ScreenObject->cX1
	jp nc, _no_horizontal_colision
	add a, #9 - #1
	cp 1 (ix); ScreenObject->cX0
	jp c, _no_horizontal_colision
	; if (player.y - 1 >= Object.cY1) or (player.y + 15 < Object.cY0) then no_vertical_colision
	ld a, (#_sThePlayer + #1); A = player->y
	dec a
	cp 4 (ix); ScreenObject->cY1
	jp nc, _no_vertical_colision
	add a, #15 + #1
	cp 3 (ix); ScreenObject->cY0
	jp c, _no_vertical_colision
	; colision detected. if ((player.status <> PLYR_STATUS_STAND) and (player.status <> PLYR_STATUS_WALKING)) then update Y coordinate, else update X coordinate
	ld e, #8
	ld a, (#_sThePlayer + #03) ; A = sThePlayer.status
	cp #PLYR_STATUS_FALLING
	jr nc, _updt_Y_coordinate

_no_foot_colision :
	; if (player.x + 8) < ((Object.cX1 + Object.cX0 + 1) / 2) move player LEFT else move player RIGHT
	ld a, 1 (ix); ScreenObject->cX0
	add a, 2 (ix); ScreenObject->cX1
	inc a
	rr a
	ld e, a
	ld a, (#_sThePlayer)
	add a, #8
	ld b, #HIT_PTS_HIGH ; strong colision - decrease HIT_PTS_HIGH power units
	cp e
	jr c, _left_colision_upd
	jr _right_colision_upd

_check_right_8 :
	cp #UPD_OBJECT_RIGHT_8
	jr nz, _check_left_8
	ld e, #8
_check_left_8_ex :
	; if (player.y + 16 <> Object.cY0) then no_vertical_colision
	ld a, (#_sThePlayer + #1); A = player->y
	add a, #16
	cp 3 (ix); ScreenObject->cY0
	jr nz, _test_side_colision
	; if ((player.x +- 8) + 5 >= Object.cX1) or ((player.x +- 8) + 10 < Object.cX0) then no_horizontal_colision
	ld a, (#_sThePlayer); A = player->x
	add a, e
	add a, #5
	cp 2 (ix); ScreenObject->cX1
	jr nc, _no_horizontal_colision
	add a, #5
	cp 1 (ix); ScreenObject->cX0
	jr c, _no_horizontal_colision
	; colision detected. Update player X coordinate above the object
	ld a, (#_sThePlayer); A = player->x
	add a, e
	ld (#_sThePlayer), a; player->x = ScreenObject->cX1 - 4 / player->x = ScreenObject->cX0 - 12

	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a

	jr _end_detection

_test_side_colision :
	; if (player.y >= Object.cY1) or (player.y + 15 < Object.cY0) then no_vertical_colision
	ld a, (#_sThePlayer + #1); A = player->y
	cp 4 (ix); ScreenObject->cY1
	jr nc, _no_vertical_colision
	add a, #15
	cp 3 (ix); ScreenObject->cY0
	jr c, _no_vertical_colision
	; possible vertical colision - check for horizontal
	; if (player.x + 3 >= Object.cX1) or (player.x + 12 - 1 < Object.cX0) then no_horizontal_colision
	ld a, (#_sThePlayer); A = player->x
	add a, #3
	cp 2 (ix); ScreenObject->cX1
	jr nc, _no_horizontal_colision
	add a, #9 - #1
	cp 1 (ix); ScreenObject->cX0
	jr c, _no_horizontal_colision
	; check for right or left colision
	ld b, #HIT_PTS_MEDIUM ; medium colision - decrease HIT_PTS_MEDIUM power units
	ld a, c
	cp #UPD_OBJECT_RIGHT_8
	jr z, _right_colision_upd
	; left side colision detected. Update player X coordinate
_left_colision_upd :
	ld a, 1 (ix); A = ScreenObject->cX0
	ld e, #256 - #12
	jr _end_horiz_upd
_right_colision_upd :
	; right side colision detected. Update player X coordinate
	ld a, 2 (ix) ; A = ScreenObject->cX1
	inc a ; A = ScreenObject->cX1 + 1
	ld e, #256 - #4
_end_horiz_upd :
	add a, e
	ld (#_sThePlayer), a   ; player->x = ScreenObject->cX1 - 4 / player->x = ScreenObject->cX0 - 12
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a
	ld a, b
	call _player_hit_asm_direct
	jr _end_detection

_check_left_8 :
	cp #UPD_OBJECT_LEFT_8
	jr nz, _end_detection
	ld e, #256 - #8
	jr _check_left_8_ex

_no_horizontal_colision :
_no_vertical_colision :
_end_detection :
	pop ix
__endasm;
}  // void detect_player_colision()

/* Input:
*   _cGlbSpObjID => ObjectScreen->cObjID
*   _cAuxEntityX, _cAuxEntityY => ObjectScreen->cX0, ObjectScreen->cY0
*   _cGlbWidth(B) => ObjectScreen->cX1, ObjectScreen->cY1
*   _cGlbCyle(H) => ObjectScreen->cObjClass
*   _cGlbStep(D) => ObjectScreen->cObjStatus for ANIM_CYCLE_FACEHUG_EGG only
*/
void insert_new_screen_object()
{
__asm
	; SLIDEFLOOR attributes : cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbCyle(H) and cGlbSpObjID
	; EGG attributes        : cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbFlag(E), cGlbCyle(H) and cGlbSpObjID
	; A, IX and IY can be used/changed
	; BC, DE, H cannot be used without push/pop first at the caller level

	ld a, (#_cGlbSpObjID)
_insert_new_screen_object_ex :
	ld iy, (#_pFreeObjectScreen)
	ld 0 (iy), a ; cObjID

	ld a, (#_cAuxEntityX)
	rlca
	rlca
	rlca
	ld 1 (iy), a ; cX0

	ld l, a
	ld a, b ; cGlbWidth
	rlca
	rlca
	rlca
	dec a
	; A = (#_cGlbWidth * 8) - 1
	add a, l
	ld 2 (iy), a ; cX1

	ld a, (#_cAuxEntityY)
	rlca
	rlca
	rlca
	add a, #8 * #3
	ld 3 (iy), a ; cY0

	add a, #8 - #1
	ld 4 (iy), a; cY1

	ld 5 (iy), h ; cObjClass = cGlbCyle
	
	inc iy
	inc iy
	inc iy
	inc iy
	inc iy
	inc iy
	ld (#_pFreeObjectScreen), iy

	ld a, h
	cp #ANIM_CYCLE_FACEHUG_EGG
	ret nz
  dec iy
	dec iy
	ld 0 (iy), d ; cObjStatus = cGlbStep [ST_EGG_CLOSED(0), ST_EGG_OPENED(2), ST_EGG_RELEASED(3)]
	ld iy, #_cScreenEggsQtty
	inc 0 (iy)
__endasm;
}  // void insert_new_screen_object()

/* Input:
*   IX = struct AnimatedTile * => (IX+9)=ObjectID
*   A = update mode (UPD_OBJECT_UP_8, UPD_OBJECT_DOWN_8, UPD_OBJECT_RIGHT_8, UPD_OBJECT_LEFT_8, UPD_OBJECT_EGG)
*  Changes: A, B, C, D, E, H, L
*/
void update_screen_object()
{
__asm
	; first lets find the screen object with same ObjectID
	ld b, 9 (ix); B = Object ID
_update_screen_object_ex :
	ld c, a
	ld hl, #_sObjScreen
	ld de, #6
_find_next_obj_scr :
	ld a, (hl)
	cp b; Object ID
	jr z, _obj_scr_found
	cp #0xFF; not found
	ret z
	add hl, de
	jr _find_next_obj_scr

_obj_scr_found :
	; HL = *ObjScreen
	ld d, h
	ld e, l; DE = struct ObjectScreen* (used at detect_player_colision())
	inc hl
	ld a, c; Update mode

	cp #UPD_OBJECT_UP_8
	jr nz, _test_8_down
	; cY0 -= 8; cY1 -= 8
	inc hl
	inc hl
	ld a, #256 - #8
	add a, (hl)
	ld(hl), a
	inc hl
	ld a, #256 - #8
	add a, (hl)
	ld(hl), a
	jr _upd_vertical

_test_8_down :
	cp #UPD_OBJECT_DOWN_8
	jr nz, _test_8_right
	; cY0 += 8; cY1 += 8
	inc hl
	inc hl
	ld a, #8
	add a, (hl)
	ld(hl), a
	inc hl
	ld a, #8
	add a, (hl)
	ld(hl), a
  jr _upd_vertical

_test_8_right :
	cp #UPD_OBJECT_RIGHT_8
	jr nz, _test_8_left
	; cX0 += 8; cX1 += 8
	ld a, #8
	add a, (hl)
	ld(hl), a
	inc hl
	ld a, #8
	add a, (hl)
	ld(hl), a
	jr _upd_horizontal

_test_8_left :
	cp #UPD_OBJECT_LEFT_8
	jr nz, _test_egg_upd
	; cX0 -= 8; cX1 -= 8
	ld a, #256 - #8
	add a, (hl)
	ld(hl), a
	inc hl
	ld a, #256 - #8
	add a, (hl)
	ld(hl), a
_upd_horizontal :
	inc hl
	inc hl
_upd_vertical :
	inc hl
	ld(hl), c
	jp _detect_player_colision

_test_egg_upd :
	and #UPD_OBJECT_EGG
	cp #UPD_OBJECT_EGG
	ret nz
	ld a, c
	rra
	rra
	rra
	rra
	and #UPD_OBJECT_EGG
	inc hl
	inc hl
	inc hl
	ld (hl), a ; set new status
	cp #ST_EGG_DESTROYED  ; if ST_EGG_DESTROYED, decrease # of eggs and invalidate this record
	ret nz
  inc hl
	ld (hl), #ANIM_CYCLE_NULL
	ld hl, #_cScreenEggsQtty
	dec (hl)
__endasm;
}  // void update_screen_object()

/*
* Display the Level info before showing the game map
*/
void draw_game_level_info()
{
__asm
  ld a, #SONG_SILENCE
  ld hl, #_SONG
  call _mplayer_init_asm_direct
  ld a, #GAMESTAGE_LEVEL
	ld (#_cGameStage), a
	call _load_tileset

  ; load correct level info
	ld a, (#_cLevel)
	add a, #GAME_TEXT_LEVEL_1_INFO_ID - #1
  call _search_text_block

	ld bc, #0x0202
	ld de, #0x0106
	call _display_format_text_block
	jp _wait_fire

; Input: B = Y (0 - 23)
;        C = X (0 - 31)
;        D = 0 (SFX OFF), 1 (SFX ON)
;        E = wait cycles between text lines
;        HL = text block address
; Output: none
; Changes: A, B, C, D, E, H, L
_display_format_text_block :
	push ix
	push hl
	pop ix
	ld a, 0 (ix)
_loop_LvlInfo_line :
	cp #'1'
	jr nz, _test0
	ld a, (#_FONT2_TILE_OFFSET)
	jr _do_LvlInfo
_test0 :
	ld a, (#_FONT1_TILE_OFFSET)

_do_LvlInfo :
	inc ix
	push ix  ; text address
	push af  ; tile offset
	inc sp
	push bc  ; Y, X
	call	_display_text
	xor a
	or d
	jr z, _no_sfx
	push hl; L = text lenght
	push de
	; mplayer_play_effect_p(SFX_TYPING, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x000A; 00 + SFX_TYPING
	call	_mplayer_play_effect_p_asm_direct
	pop de
	ld	l, e
	call	_ubox_wait_for
	pop hl
_no_sfx :
  pop bc
	inc b
	pop af
	dec sp
	pop ix

	ld h, #0
	inc l
	ex de, hl
	add ix, de
	ex de, hl
	
	ld a, 0 (ix)
	or a
	jr nz, _loop_LvlInfo_line
	pop ix
__endasm;
} // void draw_game_level_info()

/*
* Uncompress and load Sprites
*/
void Load_Sprites()
{
unsigned int iBuffOffset;

	// init sprites after every level
	spman_init();
	
	//uncompress "player_ash" + "player_ripley" sprite data
  zx0_uncompress(cBuffer, player_obj);
  if (cLevel == 1)
	  iBuffOffset=0;
  else
		iBuffOffset = PLAYER_OBJ_LEN / 2;

	// Walking Player: 3 frames x 2 sprites per frame = 6 sprites (16 x 16 each sprite) + Sprite Flip
	PLYR_PAT_WALK_IDX = spman_alloc_pat(PAT_PLAYER_WALK, cBuffer + iBuffOffset, 6, 0);
	spman_alloc_pat(PAT_PLAYER_WALK_FLIP, cBuffer + iBuffOffset, 6, 1);
	// Falling Player: 2 frames x 2 sprites per frame = 4 sprites (16 x 16 each sprite)
	PLYR_PAT_FALL_IDX = spman_alloc_pat(PAT_PLAYER_FALL, cBuffer + iBuffOffset + (3 * 2 * 4 * 8), 4, 0);
	// Jumping Player: 1 frames x 2 sprites per frame = 2 sprites (16 x 16 each sprite) + Sprite Flip
	PLYR_PAT_JUMP_IDX = spman_alloc_pat(PAT_PLAYER_JUMP, cBuffer + iBuffOffset + (3 * 2 * 4 * 8) + (2 * 2 * 4 * 8), 2, 0);
	spman_alloc_pat(PAT_PLAYER_JUMP_FLIP, cBuffer + iBuffOffset + (3 * 2 * 4 * 8) + (2 * 2 * 4 * 8), 2, 1);
	// Climbing Player: 2 frames x 2 sprites per frame = 4 sprites (16 x 16 each sprite)
	PLYR_PAT_CLIMB_IDX = spman_alloc_pat(PAT_PLAYER_CLIMB, cBuffer + iBuffOffset + (3 * 2 * 4 * 8) + (2 * 2 * 4 * 8) + (1 * 2 * 4 * 8), 4, 0);

	//uncompress "object_sprite"
	zx0_uncompress(cBuffer, object_sprite);
	// Shield: 2 frames x 1 sprite per frame = 2 sprites (16 x 16 each sprite)
	cShieldPattern = spman_alloc_pat(PAT_SHIELD, cBuffer, 2, 0);
	// Shot: 1 frame x 1 sprite per frame = 1 sprite (16 x 16 each sprite) + Sprite Flip
	cShotPattern = spman_alloc_pat(PAT_SHOT, cBuffer + (2 * 1 * 4 * 8), 1, 0);
	spman_alloc_pat(PAT_SHOT_FLIP, cBuffer + (2 * 1 * 4 * 8), 1, 1);

	// Shot Explosion: 1 frame x 1 sprite per frame = 1 sprite (16 x 16 each sprite)
	cShotExplosionPattern = spman_alloc_pat(PAT_EXPLOSION, cBuffer + (2 * 1 * 4 * 8) + (1 * 1 * 4 * 8) , 1, 0);

	// Minimap: 1 frame x 1 sprite per frame = 1 sprite (16 x 16 each sprite)
	cMiniMapPattern = spman_alloc_pat(PAT_MINIMAP, cBuffer + (2 * 1 * 4 * 8) + (1 * 1 * 4 * 8) + (1 * 1 * 4 * 8), 1, 0);

	// No need to load enemy sprites at level 1
	if (cLevel == 1) return;

	//uncompress "enemy_sprite"
	zx0_uncompress(cBuffer, enemy_sprite);
	// Enemy 5 frames x 1 sprite per frame = 5 sprites (16 x 16 each sprite)
	ENEMY_PAT_BASE_IDX = spman_alloc_pat(PAT_ENEMY_BASE, cBuffer, 5, 0);
	ENEMY_PAT_BASE_FLIP_IDX = spman_alloc_pat(PAT_ENEMY_BASE_FLIP, cBuffer, 5, 1);

	// Alien tongue 1 frame x 1 sprite per frame = 1 sprites (16 x 16 each sprite)
	ALIEN_PAT_TONGUE_IDX = spman_alloc_pat(PAT_ALIEN_TONGUE, cBuffer + (5 * 1 * 4 * 8), 1, 0);
	ALIEN_PAT_TONGUE_FLIP_IDX = spman_alloc_pat(PAT_ALIEN_TONGUE_FLIP, cBuffer + (5 * 1 * 4 * 8), 1, 1);
} // void Load_Sprites()


/*
* Reset some entities each new level
*/
void reset_locker_and_enemies()
{
__asm
	ld b, #MAX_LOCKERS_PER_LEVEL
	ld hl, #_cLockerOpened
_rst_locker:
	ld (hl), #BOOL_FALSE
	inc hl
	djnz _rst_locker

	xor a
	ld (#_cCreatedEnemyQtty), a
	ld (#_cActiveEnemyQtty), a
__endasm;
}

/*
* Uncompress and load entities data from Map
*/
void load_entities()
{
__asm
	call _reset_screen_objects
	push ix
	push iy

	; cAnimTilesQty = cAnimSpecialTilesQty = cGlbSpecialTilesActive = cGlbSpObjID = 0;
	xor a
	ld (#_cAnimTilesQty), a
	ld (#_cAnimSpecialTilesQty), a
	ld (#_cGlbSpecialTilesActive), a
	ld (#_cGlbSpObjID), a
	ld (#_sAlien + #10), a  ; IsActive = BOOL_FALSE

	; pFreeAnimTile = sAnimTiles;
	; pFreeAnimSpecialTile = sAnimSpecialTiles;
	ld hl, #_sAnimTiles
	ld (#_pFreeAnimTile), hl
	ld hl, #_sAnimSpecialTiles
	ld (#_pFreeAnimSpecialTile), hl

	; pMapData = cMap_Data + (MAP_H * MAP_W);
	ld hl, #_cMap_Data + #MAP_H * #MAP_W
_process_entity :
	ld a, (hl)
	; entity list ends with 0xFF
	cp #0xFF
	jp z, _end_entities
	and a, #0b11110000

	cp #ET_PLAYER << #4
	jr nz, _try_et_safeplace
	ld a, (#_sThePlayer + #8)  ; sThePlayer.type
	cp #ET_UNUSED
	jp nz, _get_next_entity_3
	ld a, (hl)
	and a, #0b00000001
	ld (#_sThePlayer + #2), a  ; sThePlayer.dir
	inc hl
	ld a, (hl)  ; x
	ld (#_sThePlayer), a  ; sThePlayer.x
	inc hl
	ld a, (hl)  ; y
	add a, #8 * #3
	ld (#_sThePlayer + #1), a  ; sThePlayer.y
	ld a, #PLYR_STATUS_STAND
	ld (#_sThePlayer + #3), a  ; sThePlayer.status
	ld a, #BOOL_FALSE
	ld (#_sThePlayer + #4), a  ; sThePlayer.hitflag
	ld (#_sThePlayer + #9), a  ; sThePlayer.grabflag
	ld a, #ET_PLAYER
	ld (#_sThePlayer + #8), a  ; sThePlayer.type
	; we dont use "sThePlayer.pat". Use global variables instead (PLYR_PAT_XXX_IDX)
	; we dont use "sThePlayer.update". Use update_player() directly
	inc hl
	jr _process_entity

_try_et_safeplace :
	cp #ET_SAFEPLACE << #4
	jr nz, _do_et_animated_tile
	ld a, (hl)
	and a, #0b00000001
	ld (#_cPlySafePlaceDir), a
	inc hl
	ld a, (hl)  ; x
	ld (#_cPlySafePlaceX), a
	inc hl
	ld a, (hl)  ; y
	add a, #8 * #3
	ld (#_cPlySafePlaceY), a
	inc hl
	jr _process_entity

_do_et_animated_tile :
	; backup Entity Type
	ld (#_cObjType), a

	; calculate X, Y and _iGlbPosition
	ld a, (hl)
	rl a
	and a, #0b00011110
	ld b, a
	inc hl
	ld a, (hl)
	rlc a
	and a, #0b00000001
	or b  ; A = X
	ld (#_cAuxEntityX), a

	ld a, (hl)
	rra
	rra
	and a, #0b00011111  ; A = Y
	ld (#_cAuxEntityY), a

	add a, #3
	add a, a
	add a, a
	add a, a  ; A = (Y + 3) * 8

	ld b, #0
	ld c, a
	ld iy, #0000
	add iy, bc
	add iy, iy
	add iy, iy  ; IY = (Y + 3) * 32

	ld a, (#_cAuxEntityX)
  ld c, a
  ld b, #0
  add iy, bc  ; IY = (Y + 3) * 32 + X
	; set iGlbPosition
	ld (#_iGlbPosition), iy

	; get the base tile from Map + Object History update
	ld bc, #_cMap_Data - (#3 * #32)
	add iy, bc
	ld a, 0 (iy)
	; set cGlbTile
	ld (#_cGlbTile), a

	; recover Entity Type
	ld a, (#_cObjType)

	; get the correct parameters for each entity type
	cp #ET_ANIMATE << #4
	jp z, _proc_param_animate
	cp #ET_GATE << #4
	jr z, _proc_param_gate
	cp #ET_FORCEFIELD << #4
	jp z, _proc_param_forcefield
	cp #ET_SLIDERFLOOR << #4
	jp z, _proc_param_sliderfloor
	cp #ET_DROPPER << #4
	jp z, _proc_param_dropper
	cp #ET_WALL << #4
	jp z, _proc_param_wall
	cp #ET_INTERACTIVE << #4
	jp z, _proc_param_interactive
	cp #ET_PORTAL << #4
	jp z, _proc_param_portal
	cp #ET_LOCKER << #4
	jp z, _proc_param_locker
	cp #ET_BELT << #4
	jp z, _proc_param_belt
	cp #ET_EGG << #4
	jp z, _proc_param_egg
	cp #ET_ENEMY << #4
	jp z, _proc_enemy
	jp _get_next_entity_3

_proc_param_gate :
	; if the gate is already opened (+Object History), no need to animate
	ld a, (#_cGlbTile)
	or a
	jp z, _get_next_entity_2
	; set GATE attributes: cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbFlag(E), cGlbCyle(H), cGlbDir(L) and cGlbSpObjID
	ld a, (hl)
	and #0b00000001
	ld b, a ; temp storage cGlbDir

	inc hl
	ld a, (hl)
	; convert sec->number of frames : TTTT * (60 / 2 / 7) = TTTT * 4
	rlca
	rlca
	and #0b00111100
	ld c, a

	ld a, (hl)
	and #0b01110000
	; cGlbFlag = Key(0b0KKK0000)
	ld e, a
	inc hl
	push hl

	ld h, #ANIM_CYCLE_GATE_OPEN
	ld l, b ; cGlbDir

	; cGlbWidth is always 2 for a Gate
	ld b, #2
	
	; cGlbStep = 0;
	ld d, #0

	ld iy, #_cGlbSpObjID
	inc 0 (iy)

	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_forcefield :
	; set FORCEFIELD attributes : cGlbWidth(B), cGlbStep(D), cGlbCyle(H) and cGlbDir(L)
	; cGlbFlag
	ld a, (hl)
	and #0b00000001
	inc hl
	ld b, (hl)
	inc hl
	push hl
	ld l, a
	ld h, #ANIM_CYCLE_FORCEFIELD
	ld d, #0
	jp _insert_new_entity_0

_proc_param_sliderfloor :
	; set SLIDEFLOOR attributes : cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbCyle(H) and cGlbSpObjID
	ld a, (hl)
	and #0b00000011
	add a, #ANIM_CYCLE_SLIDER_UP  ; 50 = UP (0), 51 = DOWN (1), 52 = RIGHT (2), 53 = LEFT (3)
	ld d, a ; temp storage cGlbCyle
	
	inc hl
	ld a, (hl)
	and #0b00001111
	ld b, a

	ld a, (hl)
	rra
	rra
	rra
	rra
	and #0b00001111
	ld c, a
	inc hl
	push hl

	ld h, d ; temp storage cGlbCyle
	ld d, #LEFT_MOST_TILE

	ld iy, #_cGlbSpObjID
	inc 0 (iy)

	call _insert_new_screen_object

	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_wall :
	; if the wall is already destroyed (+Object History), no need to animate
	ld a, (#_cGlbTile)
	or a
	jp z, _get_next_entity_2
	; set WALL attributes : cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbFlag(E), cGlbCyle(H) and cGlbSpObjID
	inc hl
	ld a, (hl)
	ld c, a
	inc hl
	push hl

	; adjust initial tile and step based on Object History in this screen
	; cGlbFlag = (TS_SCORE_SIZE + GAME_WALL_BRK_TL_OFFSET);
	;ld e, #TS_SCORE_SIZE + #GAME_WALL_BRK_TL_OFFSET
	ld a, (#_cGlbTile)
	cp #TS_SCORE_SIZE + #GAME_WALL_BRK_TL_OFFSET
	jr nz, _tst_wall_status_1
	ld d, #2
	jr _end_wall_status
_tst_wall_status_1 :
	cp #TS_SCORE_SIZE + #GAME_WALL_BRK_TL_OFFSET + #1
	jr nz, _tst_wall_status_2
	ld d, #4
	jr _end_wall_status
_tst_wall_status_2 :
	ld d, #0

_end_wall_status :
	; cGlbTile = cGlbFlag; /* base tile for Wall is always(GAME_TILE_OFFSET + GAME_WALL_BRK_TL_OFFSET) */
	ld e, #TS_SCORE_SIZE + #GAME_WALL_BRK_TL_OFFSET
	ld a, e
	ld (#_cGlbTile), a

	; wall width is always 2
	ld b, #2

	; TODO (improvement): Store the number of shots already received in the history of that object and restore it when you return to this screen
	; Store the number of remaining shots in 1 new Object History attribute, update whenever 1 new shot is fired and recover the pInsertAnimTile->cTimeLeft with each screen reload

	ld h, #ANIM_CYCLE_WALL_BREAK

	ld iy, #_cGlbSpObjID
	inc 0 (iy)
		
	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_interactive :
	; set INTERACTIVE attributes : cGlbWidth(B), cGlbStep(D), cGlbFlag(E), cGlbCyle(H), cGlbDir(L) and cGlbSpObjID
	; if Interactive is BLANK, no need to animate
	ld a, (#_cGlbTile)
	or a
	jp z, _get_next_entity_2
	
	ld a, (hl)
	and a, #0b00000011
	cp #INTERACTIVE_ACTION_COLLECT_CPLT
	jr z, _proceed_with_interactive_entity_ex

	; if Interactive is invalid, no need to animate
	ld a, (#_cGlbTile)
	cp #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET
	jr z, _proceed_with_interactive_entity
	cp #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET + #1
	jr z, _proceed_with_interactive_entity
	cp #TS_SCORE_SIZE + #GAME_PWR_BUTTON_TL_OFFSET
	jr z, _proceed_with_interactive_entity
	cp #TS_SCORE_SIZE + #GAME_PWR_LOCK_TL_OFFSET
	jr z, _proceed_with_interactive_entity
	; not a valid tile for an Interactive entity
	jp _get_next_entity_2

_proceed_with_interactive_entity :
  ld a, (hl)
	and a, #0b00000011
_proceed_with_interactive_entity_ex :
	inc hl

	; check for Action = INTERACTIVE_ACTION_LOCKER_OPEN or INTERACTIVE_ACTION_MISSION_CPLT or INTERACTIVE_ACTION_COLLECT_CPLT, then store the (Locker ID / Mission #) as ObjID
	cp #INTERACTIVE_ACTION_LIGHT_ONOFF
	jr nz, _intr_obj_lock_or_mission
	; cGlbFlag = ++cGlbSpObjID;
	ld iy, #_cGlbSpObjID
	inc 0 (iy)
	ld e, 0 (iy)
	jr _end_intr_obj
_intr_obj_lock_or_mission :
	; cGlbFlag = cGlbStep; /* extra information(Locker ID / Mission #) */
	ld e, (hl)

_end_intr_obj :
	inc hl
	push hl
	; cGlbStep = 0; cGlbCyle = ANIM_CYCLE_INTERACTIVE;
	; cGlbWidth is 2 for INTERACTIVE_ACTION_COLLECT_CPLT; otherwise always 1; cGlbDir = Action(0b000000aa)
	ld d, #0
	ld b, #1
	cp #INTERACTIVE_ACTION_COLLECT_CPLT
	jr nz, _interactive_is_not_collectible
	inc b ; cGlbWidth = 2
	ld d, #5 ; cGlbStep = 5

_interactive_is_not_collectible :
	ld h, #ANIM_CYCLE_INTERACTIVE
	ld l, a

	; adjust initial tile and step based on Object History in this screen
	; if (cGlbTile == (TS_SCORE_SIZE + GAME_PWR_SWITCH_TL_OFFSET + 1)) { cGlbTile--;  /* animate the power switch interative from base tile */  cGlbStep = 2; /* starts at animation stage 2 (PowerSwitch is OFF) */ }
	ld a, (#_cGlbTile)
	cp #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET + #1
	jr nz, _end_intr_obj_2
	dec a
	ld (#_cGlbTile), a
	ld d, #2

_end_intr_obj_2 :
	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_portal :
	; set PORTAL attributes : cGlbWidth(B), cGlbStep(D), cGlbFlag(E), cGlbCyle(H), cGlbDir(L)
	ld a, (hl)
	and #0b00000001
	inc hl
	; cGlbFlag
	ld e, (hl)
	inc hl
	push hl
	; cGlbDir
	ld l, a

	;cGlbCyle = ANIM_CYCLE_PORTAL;
	ld h, #ANIM_CYCLE_PORTAL

	;cGlbStep = 0;
	ld d, #0

	; cGlbWidth is always 3 for a Portal
	ld b, #3

	; store Player X and Y position as destination at this screen if Player is coming from a Portal
	;cPlyPortalDestinyY = ((pMapData[2] + 3) << 3) + 8; 
	ld a, (#_cAuxEntityY)
	add a, #3
	rlca
	rlca
	rlca
	add a, #8
	ld (#_cPlyPortalDestinyY), a

	; cPlyPortalDestinyX = _cAuxEntityX << 3;
	ld a, (#_cAuxEntityX)
	rlca
	rlca
	rlca
	ld c, a ; temp storage
	; if (!(pMapData[0] & 0b10000000)) cPlyPortalDestinyX += 4 else cPlyPortalDestinyX -= 12;
	xor a
	or l
	ld a, #4
	jr z, _portal_dir_end
	ld a, #256 - #12

_portal_dir_end :
	add a, c
	ld (#_cPlyPortalDestinyX), a
	jp _insert_new_entity_0

_proc_param_locker :
	; if Locker is BLANK, no need to animate
	ld a, (#_cGlbTile)
	or a
	jp z, _get_next_entity_2
		
	inc hl
	; cGlbFlag
	ld e, (hl)
	; cGlbStep
	ld d, #0

	; if (cLockerOpened[cGlbStep] == true)
	ld iy, #_cLockerOpened
	add iy, de
	ld a, 0 (iy)
	or a
	jr z, _lock_not_opened
	; Locker was opened before, now need to update screen tiles (this locker is not at ObjectHistory records)
	; cMap_Data[iGlbPosition - (3 * 32)] = cMap_Data[iGlbPosition + 32 - (3 * 32)] = BLANK_TILE;
	; cMap_TileClass[iGlbPosition - (3 * 32)] = cMap_TileClass[iGlbPosition + 32 - (3 * 32)] = TILE_TYPE_BLANK;
	
	ld iy, #_cMap_Data - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), #BLANK_TILE
	ld bc, #32
	add iy, bc
	ld 0 (iy), #BLANK_TILE

	ld iy, #_cMap_TileClass - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), #TILE_TYPE_BLANK
	ld bc, #32
	add iy, bc
	ld 0 (iy), #TILE_TYPE_BLANK

	jp _get_next_entity_1

_lock_not_opened :
	; set LOCKER attributes : cGlbWidth(B), cGlbStep(D), cGlbFlag(E) and cGlbCyle(H)
	inc hl
	push hl
	ld h, #ANIM_CYCLE_LOCKER_OPEN
	; cGlbWidth is always 2 for a locker
	ld b, #2
	
	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_belt :
	; set BELT attributes : cGlbWidth(B), cGlbStep(D), cGlbFlag(E), cGlbCyle(H), cGlbDir(L)
	ld a, (hl)
	and #0b00000001
	ld e, a ; cGlbDir temp storage

	inc hl
	; cGlbWidth
	ld b, (hl)
	inc hl
	push hl

	; cGlbDir
	ld l, e
	; cGlbCyle += ANIM_CYCLE_BELT;  /* 4 = anti - clockwise(0), 5 = clockwise(1) */
	ld a, #ANIM_CYCLE_BELT
	add a, l
	ld h, a

	; cGlbStep, cGlbFlag
	ld de, #0
	
	jp _insert_new_entity_0

_proc_param_egg :
	; if the egg is already destroyed (+Object History), no need to animate
	ld a, (#_cGlbTile)
	or a
	jp z, _get_next_entity_2
	; set EGG attributes : cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbFlag(E), cGlbCyle(H) and cGlbSpObjID
	inc hl
	ld c, (hl)  ; EggId
	inc hl
	push hl

	; if (cGlbTile == TS_SCORE_SIZE + GAME_EGG_TL_OFFSET) cGlbStep = 0; else cGlbStep = 2;
  ld d, #ST_EGG_CLOSED  ; 0
	cp #TS_SCORE_SIZE + #GAME_EGG_TL_OFFSET
	jr z, _cont_step_egg

	; try to find an enemy with same EggId + ScreenID. If found, check its status
	ld iy, #_sEnemies
	ld a, (#_cCreatedEnemyQtty)
	or a
	jr z, _no_active_corresp_enemy
	ld de, #14 ; sizeof(struct EnemyEntity)
	ld b, a
_try_find_active_enemy :
  ld a, (#_cScreenMap)
	cp 9 (iy) ; screenId
	jr nz, _check_new_active_enemy
	ld a, c
	cp 10 (iy) ; objId
	jp z, _check_enemy_status  ; corresponding enemy found - abort processing and check its status
_check_new_active_enemy :
	add iy, de
	djnz _try_find_active_enemy

_no_active_corresp_enemy :
  ld d, #ST_EGG_OPENED  ; 2
	jr _cont_step_egg

_check_enemy_status :
	ld a, 3 (iy)
	cp #ENEMY_STATUS_INACTIVE
	jr z, _no_active_corresp_enemy
	ld d, #ST_EGG_RELEASED  ; 3

_cont_step_egg:
	; cGlbFlag = Egg ID (00000III)
	ld e, c

	; cGlbCyle = ANIM_CYCLE_FACEHUG_EGG;
	ld h, #ANIM_CYCLE_FACEHUG_EGG

	; cGlbWidth is always 4 for an egg
	ld b, #4

	; cGlbTimer(C) - # of shots for destroy the egg
	ld c, #EGG_SHOTS_TO_DESTROY
	
	;cGlbSpObjID++;
	ld iy, #_cGlbSpObjID
	inc 0 (iy)

	;cGlbSpObjID |= (cGlbFlag << 4);
	ld a, e
	rlca
	rlca
	rlca
	rlca
	or 0 (iy)
	call _insert_new_screen_object_ex

	ld a, #ST_EGG_CLOSED  ; = #ANIM_STEP_EGG_CLOSED
	cp d
	jr z, _end_param_egg
	ld d, #ANIM_STEP_EGG_OPENED

_end_param_egg :
	ld ix, (#_pFreeAnimSpecialTile)
	jp _insert_new_entity

_proc_param_dropper :
	; set DROPPER attributes : cGlbWidth(B), cGlbStep(D) and cGlbCyle(H)
	inc hl
	ld a, (hl)
	and #0b00001111
	; cGlbWidth
	ld b, a

	ld a, (hl)
	rra
	rra
	rra
	rra
	and #0b00001111
	; cGlbStep
	ld d, a

	inc hl
	push hl
	; cGlbCyle
	ld h, #ANIM_CYCLE_DROPPER
	jp _insert_new_entity_0

_proc_enemy :
	ld a, (hl) ; XYYYYYcd
	; check if facehug (c=0) or alien (c=1)
	and #0b00000010
	jp z, _its_a_facehug
	; its an alien - check if Alien creature will be activated or not at this screen
	ld iy, #_cAlienActiveatScreen
	ld d, #0
	ld a, (#_cScreenMap)
	ld e, a
	add iy, de
	ld a, 0 (iy)
	or a
	jp z, _get_next_entity_2  ; do not activate Alien at this screen - abort processing

	ld a, #BOOL_TRUE
	ld (#_sAlien + #10), a  ; IsActive

	ld a, (hl) ; XYYYYYcd
	and #0b00000001
	ld (#_sAlien + #2), a ; dir

	inc hl
	ld a, (hl) ; 0IIIwwww
	and #0b00001111
	rlca
	ld b, a  ; Width * 2

	ld a, (#_cAuxEntityX)
  ld (#_sAlien + #7), a ; min_X
	add a, b
	dec a
	ld (#_sAlien + #8), a ; max_X

	ld a, (#_cAuxEntityY)
	ld (#_sAlien + #1), a ; Y

	push hl
	ld hl, (#_iGlbPosition)

	ld a, (#_sAlien + #2)
	cp #ENEMY_SPRT_DIR_RIGHT
	ld a, (#_cAuxEntityX)
	jr nz, _adjust_alien_init_position
	jr _set_alien_position
_adjust_alien_init_position :
	add a, b
	sub #4
	; also adjust _iGlbPosition
	ld d, #0
	ld e, b
	dec e
	dec e
	dec e
	dec e
	add hl, de
	ld (#_iGlbPosition), hl

_set_alien_position :
	ld (#_sAlien), a ; X
	ld (#_sAlien + #9), a ; last_X
	ld (#_sAlien + #11), hl ; iPosition

	ld iy, #_sAlien
	ld 3 (iy), #ENEMY_STATUS_WALKING
	ld 6 (iy), #ET_ENEMY
	ld 4 (iy), #0  ; frame
	ld 5 (iy), #1  ; delay - force to diplay alien at first cycle
	
	; insert alien (12 static tiles, 4x3) into cMap_Data[] as it was loaded from the map file
	ld hl, #_cMap_TileClass - #03 * #32
	ld bc, (#_iGlbPosition)
	add hl, bc
	ex de, hl
	ld hl, #_cMap_Data - (#03 * #32)
	add hl, bc
	ld b, #3
	ld c, #TS_SCORE_SIZE + #GAME_ALIEN_TL_OFFSET
_insert_alien_full_at_map :
	push bc
	ld b, #4
	ld a, #TILE_TYPE_ALIEN
_insert_alien_row_at_map :
	ld (de), a
	ld (hl), c
	inc c
	inc hl
	inc de
	djnz _insert_alien_row_at_map
	ld a, c
	ld bc, #28
	add hl, bc
	ex de, hl
	add hl, bc
	ex de, hl
	pop bc
	ld c, a
	djnz _insert_alien_full_at_map

	pop hl
	jp _get_next_entity_1

_its_a_facehug :
	inc hl
	ld a, (hl) ; 0IIIwwww
	rra
	rra
	rra
	rra
	and #0b00000111
	ld c, a  ; temp storage cGlbFlag (EnemyID)
	; try to find an enemy with same EnemyID+ScreenID. If found, abort enemy processing
	ld iy, #_sEnemies
	ld a, (#_cCreatedEnemyQtty)
	or a
	jr z, _insert_new_enemy
	ld de, #14  ; sizeof(struct EnemyEntity)
	ld b, a
_try_find_enemy :
	ld a, (#_cScreenMap)
	cp 9 (iy) ; screenId
	jr nz, _check_new_enemy
	ld a, c 
	cp 10 (iy) ; objId
	jp z, _get_next_entity_1  ; enemy found - abort processing
_check_new_enemy :
	add iy, de
	djnz _try_find_enemy
_insert_new_enemy :
	; iy = free EnemyEntity record
	; x, y, hitcounter, pat, frame and delay attributes will be set when Enemy released

	ld a, (hl); 0IIIwwww
	and #0b00001111
	rlca
	rlca
	rlca
	rlca
	ld b, a ; Width * 16

	ld a, (#_cAuxEntityX)
	rlca
	rlca
	rlca
	ld 11 (iy), a

	add a, b
	ld 12 (iy), a

	ld a, (#_cAuxEntityY)
	add a, #3
	rlca
	rlca
	rlca
	ld 13 (iy), a

	ld 3 (iy), #ENEMY_STATUS_INACTIVE

	ld 8 (iy), #ET_ENEMY

	ld a, (#_cScreenMap)
	ld 9 (iy), a

	ld 10 (iy), c

	dec hl
	ld a, (hl)  ; XYYYYYcd
	and #0b00000001
	ld 2 (iy), a
	
	ld iy, #_cCreatedEnemyQtty
	inc 0 (iy)
	jp _get_next_entity_2

_proc_param_animate :
	; set ANIMATE attributes : cGlbWidth(B), cGlbStep(D) and cGlbCyle(H)
	ld a, (hl)
	and #0b00000011  ; temp storage cGlbCyle
	inc hl
	ld d, (hl)
	inc hl
	push hl
	; cGlbCyle
	ld h, a
	; cGlbWidth is always 1 for Animate
	ld b, #1

_insert_new_entity_0 :
	ld ix, (#_pFreeAnimTile)
_insert_new_entity :
	; cGlbWidth(B), cGlbTimer(C), cGlbStep(D), cGlbFlag(E), cGlbCyle(H), cGlbDir(L), cGlbSpObjID, cObjType, cGlbTile and iGlbPosition
	; create the necessary AnimTile(Dropper, Belt, Animate, Portal, ForceField) or AnimSpecialTile(Gate, Wall, Interactive, Slider, Locker, Egg) records @ IX
	;pInsertAnimTile->iPosition = iGlbPosition; pInsertAnimTile->cCycleMode = cGlbCyle; pInsertAnimTile->cStep = cGlbStep;
	;pInsertAnimTile->cLastFrame = 0xAA; pInsertAnimTile->cTile = cGlbTile; pInsertAnimTile->cSpTileStatus = ST_DISABLED;
	ld a, (#_iGlbPosition)
	ld 0 (ix), a
	ld a, (#_iGlbPosition + #1)
	ld 1 (ix), a
	ld 2 (ix), h
	ld 3 (ix), d
	ld 4 (ix), #0xAA  ; not valid & non-blank
	ld a, (#_cGlbTile)
	ld 5 (ix),a
	ld 8 (ix), #ST_DISABLED

	ld a, (#_cObjType)

	; set parameters for each entity type
	cp #ET_ANIMATE << #4
	jp z, _upd_animtile_ptr
	cp #ET_GATE << #4
	jr z, _proc_et_gate
	cp #ET_FORCEFIELD << #4
	jp z, _proc_et_forcefield
	cp #ET_SLIDERFLOOR << #4
	jp z, _proc_et_sliderfloor
	cp #ET_DROPPER << #4
	jp z, _proc_et_dropper
	cp #ET_WALL << #4
	jp z, _proc_et_wall
	cp #ET_INTERACTIVE << #4
	jp z, _proc_et_interactive
	cp #ET_PORTAL << #4
	jp z, _proc_et_portal
	cp #ET_LOCKER << #4
	jp z, _proc_et_locker
	cp #ET_BELT << #4
	jp z, _proc_et_belt
	cp #ET_EGG << #4
	jp z, _proc_et_egg
	; jp _abort_this_entity  ; should never happen

_proc_et_gate :
	; pInsertAnimTile->cTimer = cGlbTimer;
	ld 6 (ix), c
	; store the ObjectID both in AnimSpecialTile record and cMap_ObjIndex[] map
	; pInsertAnimTile->cSpObjID = cMap_ObjIndex[iGlbPosition - (3 * 32)] = (cGlbSpObjID | (pMapData[0] & 0b01110000)); // Key + ObjectID (0kkkOOOO)
	ld a, (#_cGlbSpObjID)
	or e
	ld 9 (ix), a

	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), a

	; cGlbStep = 5; cGlbTile++; 
	ld d, #5
	ld iy, #_cGlbTile
	inc 0 (iy)

_next_gate_or_ff_tile_position :
; if (!cGlbFlag) iGlbPosition += 32 else iGlbPosition++
	ld a, l
	or a
	jr z, _gate_obj_vert
	ld bc, #1  ; Horizontal gate
	jr _gate_obj_create
_gate_obj_vert :
	ld bc, #32  ; Vertical gate
_gate_obj_create :
	ld iy, (#_iGlbPosition)
	add iy, bc
	ld (#_iGlbPosition), iy
	jp _upd_animtile_ptr_ex

_proc_et_forcefield :
	push bc
	jr _next_gate_or_ff_tile_position	

_proc_et_sliderfloor :
	;pInsertAnimTile->cTimer = pInsertAnimTile->cTimeLeft = cGlbTimer;
	ld 6 (ix), c
	ld 7 (ix), c

	;pInsertAnimTile->cSpObjID = cGlbSpObjID;
	ld a, (#_cGlbSpObjID)
	ld 9 (ix), a

	; if (cGlbWidth == 2) /*last tile from slider*/ cGlbStep = RIGHT_MOST_TILE else cGlbStep = 0
	ld d, #RIGHT_MOST_TILE
	ld a, b
	cp #2
	jr z, _not_lst_slider_tile
	ld d, #0

_not_lst_slider_tile :
	; calculate the next slider tile attributes
	; cGlbTile = cMap_Data[++iGlbPosition - (3 * 32)]; // get the base tile from Map
	push bc
	ld iy, #_cMap_Data - #03 * #32
	ld bc, (#_iGlbPosition)
	inc bc
	ld (#_iGlbPosition), bc
	add iy, bc
	ld a, 0 (iy)
	ld (#_cGlbTile), a
	jp _upd_animtile_ptr_ex

_proc_et_wall :
	; pInsertAnimTile->cTimer = pInsertAnimTile->cTimeLeft = cGlbTimer; /* # of shots for break the wall */
	ld 6 (ix), c
	ld 7 (ix), c

	; store the ObjectID both in AnimSpecialTile record and cMap_ObjIndex[] map
	; pInsertAnimTile->cSpObjID = cMap_ObjIndex[iGlbPosition - (3 * 32)] = cGlbSpObjID;
	ld a, (#_cGlbSpObjID)
	ld 9 (ix), a

	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), a

	; cMap_TileClass[iGlbPosition - (3 * 32)] = TILE_TYPE_WALL;
	ld iy, #_cMap_TileClass - #03 * #32
	add iy, bc
	ld 0 (iy), #TILE_TYPE_WALL

	; iGlbPosition += 32; /* Wall is always vertical */
	jp _gate_obj_vert

_proc_et_interactive :
	; store the ObjectID both in AnimSpecialTile record and cMap_ObjIndex[] map
	; pInsertAnimTile->cSpObjID = cMap_ObjIndex[iGlbPosition - (3 * 32)] = (cGlbTimer | ((pMapData[0] >> 2) & 0b00110000) | 0b10000000);   // Action + ObjectID (10aaOOOO)
	ld a, l
	rlca
	rlca
	rlca
	rlca
	or e
	or #0b10000000
	ld 9 (ix), a

	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), a

	; iGlbPosition += 32; /* 2 vertical tiles if INTERACTIVE_ACTION_COLLECT_CPLT */
	jp _gate_obj_vert

_proc_et_portal :
	; store the screen destination (0000DDDD) in cMap_ObjIndex[] map
	; cMap_ObjIndex[iGlbPosition - (3 * 32)] = cGlbFlag;  // Screen Destination (0000DDDD)
	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), e

	; cGlbStep++;
	inc d

	; iGlbPosition += 32; /* Vertical portal */
	jp _gate_obj_vert

_proc_et_locker :
	; pInsertAnimTile->cTimer = pInsertAnimTile->cTimeLeft = 0;
	ld 6 (ix), #0
	ld 7 (ix), #0

	; pInsertAnimTile->cSpObjID = 0b11000000 | cGlbFlag;  /* special mask to avoid Locker ObjID conflict with Gates and Interactive ObjIDs(1100OOOO) *//
	ld a, #0b11000000
	or e
	ld 9 (ix), a

	;cGlbStep = 5;
	ld d, #5

	; cGlbTile++;
	ld iy, #_cGlbTile
	inc 0 (iy)

	; iGlbPosition += 32; /* Vertical always */
	push bc
	jp _gate_obj_vert

_proc_et_belt :
	; calculate the next belt tile attributes
	; if (!cGlbFlag) /* first tile from mat */ { cGlbTile += 3; cGlbFlag = 1; }
	xor a
	or e
	jr nz, _not_first_mat_tile
	; cGlbFlag = 1;
	inc e
	; cGlbTile += 3;
	jr _cont_belt_et_0

_not_first_mat_tile :
	; else if (cGlbWidth == 2) cGlbTile += 3; // last tile from mat
	ld a, #2
	cp b
	jr nz, _cont_belt_et
_cont_belt_et_0 :
	; cGlbTile += 3;
	ld a, (#_cGlbTile)
	add a, #3
	ld (#_cGlbTile), a

_cont_belt_et :
	; store the Belt direction (cGlbCyle) in cMap_ObjIndex[] map
	; cMap_ObjIndex[iGlbPosition - (3 * 32)] = cGlbCyle;  /* Direction(000000dd) */
	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), h

	; iGlbPosition++;
	ld bc, (#_iGlbPosition)
	inc bc
	ld (#_iGlbPosition), bc

	jp _upd_animtile_ptr_ex

_proc_et_dropper :
	; calculate the next dropper tile attributes
	; cGlbStep = (10 + cGlbStep - 2) % 10;
	ld a, d
	add a, #10 - #2
	cp #10
	jr c, _drop_end_mod_10
	sub #10
_drop_end_mod_10 :
	ld d, a

	; iGlbPosition += 32;
	push bc
	jp _gate_obj_vert

_proc_et_egg :
	; pInsertAnimTile->cTimer = pInsertAnimTile->cTimeLeft = EGG_SHOTS_TO_DESTROY; /* # of shots for destroy the egg */
	ld 6 (ix), c
	ld 7 (ix), c

	; store the ObjectID both in AnimSpecialTile recordand cMap_ObjIndex[] map
	; pInsertAnimTile->cSpObjID = cMap_ObjIndex[iGlbPosition - (3 * 32)] = (cGlbFlag << 4) | cGlbSpObjID;  /* EggID + ObjectID(0iiiOOOO) */
	ld a, e
	rlca
	rlca
	rlca
	rlca
	;and a, #0b01110000
	ld iy, #_cGlbSpObjID
	or 0 (iy)
	ld 9 (ix), a

	ld l, b; temp storage cGlbWidht
	push bc
	ld iy, #_cMap_ObjIndex - #03 * #32
	ld bc, (#_iGlbPosition)
	add iy, bc
	ld 0 (iy), a

	ld a, l  ; temp storage cGlbWidht
	; if (cGlbWidth == 3) {cGlbStep += 4; iGlbPosition += 31;} else {cGlbTile++; iGlbPosition++;}
	cp #3
	jr nz, _egg_same_line
	; cGlbTile = TS_SCORE_SIZE + GAME_EGG_TL_OFFSET + 4; cGlbStep += 4; iGlbPosition += 31;
	ld a, #TS_SCORE_SIZE + #GAME_EGG_TL_OFFSET + #4  ; first egg body tile
	inc d
	inc d
	inc d
	inc d
	ld bc, #31 ; change from last tile from Egg top to first tile from Egg body
	jr _egg_obj_create
_egg_same_line :
	; cGlbTile++; iGlbPosition++;
	ld a, (#_cGlbTile)
	inc a
	ld bc, #1	

_egg_obj_create :
	ld (#_cGlbTile), a
	jp _gate_obj_create


	; update the right xxAnimTile pointer
_upd_animtile_ptr :
	push bc
_upd_animtile_ptr_ex : 
	ld bc, #10 ; sizeof (struct AnimatedTile)
	ld a, (#_cObjType)
	cp #ET_EGG << #4
	jr c, _anim_tile_obj	
	ld iy, (#_pFreeAnimSpecialTile)
	add iy, bc
	ld (#_pFreeAnimSpecialTile), iy
	ld iy, #_cAnimSpecialTilesQty
	jr _anim_tile_obj_end
_anim_tile_obj :
	ld iy, (#_pFreeAnimTile)
	add iy, bc
	ld (#_pFreeAnimTile), iy
	ld iy, #_cAnimTilesQty
_anim_tile_obj_end :
	inc 0 (iy)
	add ix, bc

	pop bc
	dec b
	jp nz, _insert_new_entity

_abort_this_entity :
	pop hl
	jp _process_entity

_get_next_entity_3 :
	inc hl
_get_next_entity_2 :
	inc hl
_get_next_entity_1 :
	inc hl
	jp _process_entity

_end_entities :
	pop iy
	pop ix
__endasm;
}  // void load_entities()

/* 
* Loads the right game level data (Tileset, Missions, Sprite Colors, cMapX/cMapY/cScreenMap) based on cLevel
*/
void load_gamelevel_data()
{
__asm
  ld hl, #_cGameStage
	ld (hl), #GAMESTAGE_GAME
	call _load_tileset

	; cMapX = cMapY = cScreenMap = 0;
	xor a
	ld (#_cMapX), a
	ld (#_cMapY), a
	ld (#_cScreenMap), a
	ld a, (#_cLevel)
	dec a
	jr nz, _try_Level2
	; Level = 1, Missions = 3
	ld a, #LEVEL_01_MISSIONS_QTTY
	jr _reset_missions
_try_Level2 :
	dec a
	jr nz, _try_Level3
	; Level = 2, Missions = 3
	ld a, #LEVEL_02_MISSIONS_QTTY
	jr _reset_missions
_try_Level3 :
	; Level = 3, Missions = 4
	ld a, #LEVEL_03_MISSIONS_QTTY

_reset_missions :
	ld (#_cMissionQty), a
	ld (#_cRemainMission), a
	ld b, a
	ld hl, #_cMissionStatus
_next_mission_reset :
	ld (hl), #MISSION_INCOMPLETE
	inc hl
	djnz _next_mission_reset
__endasm;
}  // void load_gamelevel_data()

/*
* Reset the Object History array each time a Level starts
*/
void reset_obj_history()
{
__asm
	ld hl, #_sObjTileHistory
	ld (#_pFreeObjTileHistory), hl
	ld bc, #MAX_OBJ_HISTORY_SIZE + #01
	ld de, #04
_reset_loop :
	ld (hl), #0xFF
	add hl, de
	dec bc; does not affect Z flag
	ld a, b
	or c
	jr nz, _reset_loop
__endasm;
}  // void reset_obj_history()

/* Input:
*   _cScreenMap => ObjTileHistory->cScreenMap
*   _iGlbPosition => ObjTileHistory->iPosition
*   A => ObjTileHistory->cTile
*/
void insert_new_obj_history()
{
__asm
	ld b, a ; B = cTile
_insert_new_obj_history_ex :
	ld hl, (#_pFreeObjTileHistory)
	ld a, (#_cScreenMap)
	ld (hl), a
	inc hl
	ld de, (#_iGlbPosition)
	ld (hl), e
	inc hl
	ld (hl), d
	inc hl
	ld (hl), b
	inc hl
	ld (#_pFreeObjTileHistory), hl
__endasm;
}  // insert_new_obj_history()

/* Input:
*   _cScreenMap => ObjTileHistory->cScreenMap
*   _iGlbPosition => ObjTileHistory->iPosition
*   A => ObjTileHistory->cTile
*/
void update_existing_obj_history()
{
__asm
	; find a record with same(_cScreenMap | _iGlbPosition)
	ld b, a; B = cTile
	ld a, (#_cScreenMap)
	ld c, a; C = _cScreenMap
	ld de, #04
	ld hl, #_sObjTileHistory
_find_new_record :
	ld a, (hl)
	cp #0xFF
	jr z, _insert_new_obj_history_ex ; does not exist - need to create it
	cp c
	jr z, _check_iPos
	add hl, de
	jr _find_new_record
_check_iPos :
	push bc
	ld bc, (#_iGlbPosition)
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl); DE = sObjTileHistory->iGlbPosition
	inc hl
	ex de, hl
	xor a
	sbc hl, bc
	ex de, hl
	pop bc
	jr z, _upd_tile
	inc hl
	ld de, #04
	jr _find_new_record
_upd_tile :
	; replace old Tile# with new one
	ld a, b
	ld (hl), a
__endasm;
}  // update_existing_obj_history()

void disable_gate_history(uint16_t iPosition)
{
__asm
	ld hl, #2
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl) ; DE = iPosition
;;;;	ld hl, (#_iGlbPosition)
;;;;	push hl
	ld (#_iGlbPosition), de
	xor a  ; blank Tile
	call _insert_new_obj_history
;;;;	pop hl
;;;;	ld (#_iGlbPosition), hl
__endasm;
}  // void disable_gate_history(uint16_t iPosition)

void update_wall_history(uint16_t iPosition, uint8_t cTile)
{
__asm
	ld hl, #2
	add hl, sp
	ld e, (hl)
	inc hl
	ld d, (hl); DE = iPosition
	inc hl
	ld a, (hl); A = cTile
;;;;	ld hl, (#_iGlbPosition)
;;;;	push hl
	ld (#_iGlbPosition), de
	call _update_existing_obj_history
;;;;	pop hl
;;;;	ld (#_iGlbPosition), hl
__endasm;
}  // void update_wall_history(uint16_t iPosition, uint8_t cTile)

/* Input:
*   _cScreenMap
*/
void update_object_history()
{
__asm
	ld a, (#_cScreenMap)
	ld c, a; C = _cScreenMap
	ld de, #04
	ld hl, #_sObjTileHistory
_lookup_record :
	ld a, (hl)
	cp #0xFF
	ret z; lookup finished
	cp c
	jr z, _do_upd_object
	add hl, de
	jr _lookup_record
_do_upd_object :
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl); DE = sObjTileHistory->iGlbPosition
	inc hl
	ld b, (hl) ; B = cTile
	inc hl
	push hl

	ld hl, #_cMap_Data - (#03 * #32)
	add hl, de
	ld (hl), b

	; update _cMap_TileClass
	ld hl, #_cMap_TileClass - (#03 * #32)
	add hl, de
	ld a, b
	call	_getTileClass
	ld (hl), a

	pop hl
	ld de, #04
	jr _lookup_record
__endasm;
} // void update_object_history()

/*
* Load the right game screen map data based on cLevel and cScreenMap
*/
void load_levelmap_data()
{
__asm
	ld a, (#_cLevel)
	cp #2
	jr z, _try_lvl_2
	ld	bc, #_maplvl1 ; level 1 and level 3 uses same base level map
	jr _do_map_loading
_try_lvl_2 :
	ld	bc, #_maplvl2

_do_map_loading :
	ld hl, #_cMap_Data
	call _calc_map_address_and_uncompress

	; Level 3 diffential map processing
	ld a, (#_cLevel)
	cp #3
	jr nz, _not_level_3
	ld bc, #_maplvl3
	ld hl, #_cBuffer
	call _calc_map_address_and_uncompress
	
	ld bc, #MAP_BYTES_SIZE
	ld hl, #_cBuffer
	ld de, #_cMap_Data
_loop_differential_proc :
	ld a, (hl)
	cp #SCORE_DIFFNT_TL_OFFSET
	jr z, _keep_original_tile
	ld (de), a
_keep_original_tile :
	inc hl
	inc de
	dec bc
	ld a, b
	or c
	jr nz, _loop_differential_proc
	ex de, hl
	; HL = 1st Entity byte from #_cMap_Data. Need to find last one(0xFF)
	;ld bc, (#MAX_ANIM_TILES + #MAX_ANIM_SPEC_TILES_FULL + #MAX_ENEMIES_PER_SCREEN + #1)* #4
	ld bc, #260
	ld a, #0xFF
	cpir
	dec hl
	ex de, hl
	; DE = Last Entity byte from #_cMap_Data = 0xFF
	; HL = 1st Entity byte from #_cBuffer. Need to copy from (HL) to (DE) until last byte (0xFF)
_continue_entity_copy :
	ld a, (hl)
	ldi  ; ld (de), (hl) / inc de / inc hl
	cp #0xFF
	jr nz, _continue_entity_copy

_not_level_3 :
	ld hl, #_cMap_Data
	ld bc, #MAP_BYTES_SIZE
	push ix
	ld ix, #_cMap_TileClass
_loop_map_data :
	ld a, (hl)
  call _getTileClass
	; update cMap_TileClass
	ld 0 (ix), a
	inc ix
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, _loop_map_data
	pop ix
  jp _update_object_history

_calc_map_address_and_uncompress :
	push hl
	ld	a, (#_cScreenMap)
	add a, a
	ld	h, #0x00
	ld	l, a
	add	hl, bc
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	pop hl
	ex de, hl
	; call _zx0_uncompress_asm_direct
	jp _zx0_uncompress_asm_direct
	; ret

; Input:  A = Tile Number
; Output: A = Tile Class
;         E = Original Tile Number
; Changes: A, D, E
_getTileClass :
  push hl
	ld hl, #_cTileClassLUT
	ld e, a
	ld d, #0
	add hl, de
	ld a, (hl)
	pop hl
	;ret
__endasm;
}  // void load_levelmap_data()

/*
* Fills cTileClassLUT[]  lookup table with the correct Tile Class for the game tileset
*/
void setup_tileclass_LUT()
{
__asm
  ld b, #255
	ld hl, #_cTileClassLUT
	xor a

_check_tile_loop :
  cp #TS_SCORE_SIZE + #GAME_FATL_TL_OFFSET
  jr nc, _setFatal
  cp #TS_SCORE_SIZE + #GAME_COLLECT_TL_OFFSET
  jr nc, _setCollect
  cp #TS_SCORE_SIZE + #GAME_EGG_TL_OFFSET
  jr nc, _setEgg
  cp #TS_SCORE_SIZE + #GAME_SOLD_TL_OFFSET
  jr nc, _setSolid
  cp #TS_SCORE_SIZE + #GAME_SP_GAT_TL_OFFSET
  jr nc, _setGate
  cp #TS_SCORE_SIZE + #GAME_SP_BLT_TL_OFFSET
  jr nc, _setBelt
  cp #TS_SCORE_SIZE + #GAME_SPECSD_TL_OFFSET
  jr nc, _setSpecialSolid
  cp #TS_SCORE_SIZE + #GAME_SPEC_TL_OFFSET
  jr nc, _setSpecialTile
  cp #TS_SCORE_SIZE + #0
  jr nc, _setBlank
  cp #SCORE_PORTAL_TL_OFFSET
  jr nc, _setPortal
  cp #SCORE_OBJ_TL_OFFSET
  jr nc, _setObject
  jr _setBlank
_setFatal :
  ld (hl), #TILE_TYPE_FATAL
	jr _check_for_next_tile
_setEgg :
  ld (hl), #TILE_TYPE_EGG
	jr _check_for_next_tile
_setSolid :
  ld (hl), #TILE_TYPE_SOLID
	jr _check_for_next_tile
_setGate :
  ld (hl), #TILE_TYPE_SPECIAL_GATE
	jr _check_for_next_tile
_setBelt :
  ld (hl), #TILE_TYPE_SPECIAL_BELT
	jr _check_for_next_tile
_setSpecialSolid :
  ld (hl), #TILE_TYPE_SPECIAL_SOLID
	jr _check_for_next_tile
_setSpecialTile :
  ld (hl), #TILE_TYPE_SPECIAL
	jr _check_for_next_tile
_setObject :
  ld (hl), #TILE_TYPE_OBJECT
	jr _check_for_next_tile
_setPortal :
  ld (hl), #TILE_TYPE_PORTAL
	jr _check_for_next_tile
_setCollect :
  ld (hl), #TILE_TYPE_COLLECTIBLE
	jr _check_for_next_tile
_setBlank :
  ld (hl), #TILE_TYPE_BLANK

_check_for_next_tile :
  inc hl
	inc a
  djnz _check_tile_loop

	; set special cases
	; 2 horizontal FF tiles
  ld hl, #_cTileClassLUT + #TS_SCORE_SIZE + #GAME_HORIZ_FF_TL_OFFSET
  ld (hl), #TILE_TYPE_FATAL_OR_SOLID
	inc hl
	ld (hl), #TILE_TYPE_FATAL_OR_SOLID

	; 2 wall tiles
	ld hl, #_cTileClassLUT + #TS_SCORE_SIZE + #GAME_WALL_BRK_TL_OFFSET
	ld (hl), #TILE_TYPE_WALL
	inc hl
	ld (hl), #TILE_TYPE_WALL

	; 6 interactive tiles
	ld hl, #_cTileClassLUT + #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET
	ld b, #6
_set_interactive_tileclass :
	ld (hl), #TILE_TYPE_INTERACTIVE
	inc hl
	djnz _set_interactive_tileclass
__endasm;
}  // void setup_tileclass_LUT()

/*
* Update player X and Y position after a shift screen map (left, right, up, down or teletransport.
* cScreenShiftDir = 0(right), 1(left), 2(up), 3(down) and 4(portal teletransport)
*/
void update_player_position()
{
__asm
	ld a, (#_cScreenShiftDir)
	cp #SCR_SHIFT_LEFT; 1
	jr z, _upd_shiftLeft
	cp #SCR_SHIFT_RIGHT; 0
	jr z, _upd_shiftRight
	cp #SCR_SHIFT_UP; 2
	jr z, _upd_shiftUp
	cp #SCR_SHIFT_DOWN; 3
	jr z, _upd_shiftDown
	; should be SCR_SHIFT_PORTAL
	; cp #SCR_SHIFT_PORTAL; 4
	; its a teletransport portal - if jumping then update player position or stop jumping
	ld a, (#_sThePlayer + #03) ; A = _sThePlayer.status
	cp #PLYR_STATUS_JUMPING
	jr nz, _end_portal_shift
	; player is still jumping
	ld a, (#_cGlbPlyJumpStage)
	cp #PLYR_JUMP_STAGE_UP
	jr nz, _end_portal_shift
	; jump stage is UP - update Player Y coordinate accordly
	ld a, (#_cPlyPortalDestinyX)
	ld (#_sThePlayer), a

	ld a, (#_cGlbPlyJumpCycles)
	ld b, a
	ld a, (#_cPlyPortalDestinyY)
	sub #PLYR_UP_JUMP_CYCLES
	add a, b  ; Y = cPlyPortalDestinyY - (PLYR_UP_JUMP_CYCLES - cGlbPlyJumpCycles)
	jr _upd_endShift_vert

_end_portal_shift :
	; its a teletransport portal at STAGE DOWN - stop jumping
	ld a, #PLYR_STATUS_STAND
	ld (#_sThePlayer + #03), a  ; &_sThePlayer.status
	ld a, (#_cPlyPortalDestinyX)
	ld (#_sThePlayer), a
	ld a, (#_cPlyPortalDestinyY)
	jr _upd_endShift_vert

_upd_shiftLeft :
	; update player X position
	ld a, #01
  jr _upd_endShift

_upd_shiftRight :
	; update player X position
	ld a, #240 + #3
	jr _upd_endShift

_upd_shiftUp:
	ld a, #23 * #8 - #4
	jr _upd_endShift_vert

_upd_shiftDown :
	ld a, #3 * #8
	jr _upd_endShift_vert

_upd_endShift :
	ld (#_sThePlayer), a
	ret

_upd_endShift_vert :
  ld (#_sThePlayer + #1), a
__endasm;
}  // void update_player_position(}

/*
* Shift screen map left, right, up, down (player reach end of the screen) or teletransport. Adjust Minimap cMapX/cMapY coordinates
* cMap_Data = new map data to be displayed
* cTemp_Map_Data = old map data to be replaced (currently left or right shifts only)
* cScreenShiftDir = 0(right), 1(left), 2(up), 3(down) and 4(portal teletransport)
*/
void shift_screen_map()
{
__asm
	ld a, (#_cScreenShiftDir)
	cp #SCR_SHIFT_LEFT ; 1
	jr z, _shiftLeft
	cp #SCR_SHIFT_RIGHT ; 0
	jp z, _shiftRight
	; NO animation for up and down screen shift
	cp #SCR_SHIFT_UP; 2
	jr z, _shiftUp
	cp #SCR_SHIFT_DOWN ; 3
	jr z, _shiftDown

	; should be SCR_SHIFT_PORTAL
	; cp #SCR_SHIFT_PORTAL; 4
	; update MiniMap sprite position
	ld a, (#_cScreenMap); 0 - 15
	ld b, #0
_find_CMapY :
	cp a, #5
	jr c, _okCMapY
	sub #5
	inc b
	jr _find_CMapY
_okCMapY :
	ld (#_cMapX), a
	ld a, b
	ld (#_cMapY), a
	; mplayer_play_effect_p(SFX_PORTAL, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0009; 00 + SFX_PORTAL
	call	_mplayer_play_effect_p_asm_direct
	jp _draw_map

_shiftUp :
	; update MiniMap sprite position
	ld hl, #_cMapY
	dec(hl)
	jp _draw_map

_shiftDown :
	; start a down shift
	; update MiniMap sprite position
	ld hl, #_cMapY
	inc(hl)
	jp _draw_map

_shiftLeft :
	; start a left shift
	ld a, (#_cGlbGameSceneLight)
	bit 0, a ; A = LIGHT_SCENE_ON_FL_ANY?
	jp z, _shiftLeft_end
	; external loop = 32 times (X)
	ld c, #1
_shfleft_newX :
	call _setVRAM
_shfleft_newY :
	; internal loop = 21 times(Y)
	push bc
	call _rowStep1
	push hl
	ex de, hl
	ld hl, #_cTemp_Map_Data	
	call _rowStep2
	ld hl, #_cMap_Data
	pop de
	call _rowStep3
	pop bc
	inc b
	ld a, b
	cp #21
	jr nz, _shfleft_newY
	inc c
	ld a, c
	halt
	cp #32
	jr nz, _shfleft_newX
_shiftLeft_end :
	;update MiniMap sprite position
	ld hl, #_cMapX
	inc(hl)
	jp _draw_map

_shiftRight :
	; start a right shift
	ld a, (#_cGlbGameSceneLight)
	bit 0, a ; A = LIGHT_SCENE_ON_FL_ANY ?
	jp z, _shiftRight_end
	; external loop = 32 times(X)
	ld c, #31
_shfright_newX :
	call _setVRAM
_shfright_newY :
	; internal loop = 21 times(Y)
	push bc
	call _rowStep1
	push hl
	ex de, hl
	ld hl, #_cMap_Data
	call _rowStep2
	ld hl, #_cTemp_Map_Data
	pop de
	call _rowStep3
	pop bc
	inc b
	ld a, b
	cp #21
	jr nz, _shfright_newY
	halt
	dec c
	jr nz, _shfright_newX
_shiftRight_end :
	; update MiniMap sprite position
	ld hl, #_cMapX
	dec(hl)
	jp _draw_map

_setVRAM :
	ld hl, #UBOX_MSX_NAMTBL_ADDR + #3 * #32 + #0
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)
	ld b, #0
	ret

_rowStep1 :
	ld l, b
	ld h, #00
	rlc l
	rlc l
	rlc l; L = L * 8
	add hl, hl
	add hl, hl; HL = HL * 32
	ret

_rowStep2 :
	add hl, de
	ld d, #00
	ld e, c
	add hl, de
	ld a, #32
	sub e
	ld b, a
	ld c, #0x98
_lpOutiL1 :
	outi; write 1 bytes from(HL) to VRAM and decrement B
	jr nz, _lpOutiL1
	ld b, e
	ret

_rowStep3 :
	add hl, de
_lpOutiL2 :
	outi; write 1 bytes from(HL) to VRAM and decrement B
	jr nz, _lpOutiL2
	ret
__endasm;
}  // void shift_screen_map(}

/*
* Display all animated tiles that are on the queue for this frame
*/
void display_animated_tiles()
{
__asm
  ; if LIGHT_SCENE_OFF_FL_OFF, no need to display animated tiles (no need to update VRAM)
	ld de, #_sAnimTileList ; base animated list item
  ld a, (#_cGlbGameSceneLight)
  cp #LIGHT_SCENE_OFF_FL_OFF
  jr z, _NoMoreTiles

  ld de, (#_pAnimTileList); pointer to last animated list item
	ld bc, #UBOX_MSX_NAMTBL_ADDR; VRAM NAME TABLE
_NextTile :
	ld hl, #_sAnimTileList; base animated list item
	xor a								; clear carry flag
	sbc hl, de					; check if equal
	jr z, _NoMoreTiles	; if _pAnimTileList = _sAnimTileList, no more tile to display	
	dec de
	ld a, (de)					; first word = iPosition
	ld h, a
	dec de
	ld a, (de)
	ld l, a
	add hl, bc
	
	dec de ; previous byte = cTile

	; if LIGHT_SCENE_OFF_FL_ON, need to check if tile at VRAM addreess <> BLACK_TILE before updating
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_ON
	jr nz, _display_anim_tile
	call #0x0050  ; SETRD - Enable VDP to read (HL)
	in a, (#0x98)
	cp #BLACK_TILE
	jr z, _NextTile

_display_anim_tile :
	call #0x0053				; SETWRT - Sets the VRAM pointer (HL)
	ld a, (de)					; A = Tile
	out (#0x98), a			; write to VRAM
	jr _NextTile
_NoMoreTiles :
  ld (#_pAnimTileList), de ; _pAnimTileList = _sAnimTileList
__endasm;
}  // void display_animated_tiles()

/* 
* Find the right special Gate/Wall/Locker/Collectible (2 tiles) / Interactive (1 tile) / Egg (4 tiles) animated tile in the Tile list and activate it
* This function is only being called for an Interactive object (ANIMATE_OBJ_INTER or ANIMATE_OBJ_COLLC) under this specific cases:
*   - shot colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LIGHT_ONOFF AND Tile=GAME_PWR_SWITCH_TL_OFFSET (update_and_display_objects())
*   - shot colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_SWITCH_TL_OFFSET (update_and_display_objects())
*   - player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LIGHT_ONOFF AND Tile=GAME_PWR_SWITCH_TL_OFFSET+1 AND PlayerObjects=HAS_OBJECT_SCREW (is_player_walking_ok())
*   - player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_BUTTON_TL_OFFSET (is_player_walking_ok())
*   - player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY (is_player_walking_ok())
*   - player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_BUTTON_TL_OFFSET (is_player_walking_ok())
*   - player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY (is_player_walking_ok())
*   - player walking colision with Tiletype=TILE_TYPE_COLLECTIBLE (is_player_walking_ok())
* Returns:	true  (1 - tile found and activated)
*						false (0 - tile not found, tile found but could not be activated (no key, not enought shots) or already activated)
*/
bool special_object_animated_ok(uint8_t cEnableType, uint8_t cObjID)
{
__asm
	ld l, #BOOL_FALSE
	ld a, (#_cAnimSpecialTilesQty)
	or a
	ret z ; No special tiles to search for
_StartSearch :
	ld b, a ; B = _cAnimSpecialTilesQty
	ld hl, #2
	add hl, sp
	ld d, (hl); D = cEnableType
	inc hl
	ld c, (hl); C = cObjID
	ld hl, #_sAnimSpecialTiles + #09 ; HL = &sAnimSpecialTiles->cSpObjID
_NextSearch :
	ld a, (hl) ; A = sAnimSpecialTiles->cSpObjID
	cp c
	jp z, _TileFound; if _cObjID = sAnimSpecialTiles->cSpObjID => found!
	ld a, d
	ld de, #10
	add hl, de ; next sAnimSpecialTiles record
	ld d, a
	djnz _NextSearch
_exitFalse :
	ld l, #BOOL_FALSE
	ret ; tile/objectID not found 

_TileFound :
	; check if its a gate, a wall, an egg or an interactive
	ld c, d ; C = cEnableType
	push hl  ; HL = &sAnimSpecialTiles->cSpObjID
	ld b, a ; B = cObjID
	ld de, #07
	xor a
	sbc hl, de
	ld a, (hl); sAnimSpecialTiles->cCycleMode
	cp #ANIM_CYCLE_FACEHUG_EGG
	jr nz, _chkforWall
	; its an Egg - check if cEnableType = ANIMATE_OBJ_EGG
	ld a, c
	cp #ANIMATE_OBJ_EGG
	jr nz, _exit_egg
	; check for egg to be hit (1st shot) or destroyed (5th shot)
	inc hl  ; HL = &sAnimSpecialTiles->cStep
	ld c, (hl)
	ld de, #04
	add hl, de
	dec (hl); sAnimSpecialTiles->cTimeLeft--
	ld a, #ST_EGG_DESTROYED << #4 | #UPD_OBJECT_EGG
	jr z, _anim_egg
	xor a
	or c
	; check for first Egg tile - if cStep = 0 then its the first shot into this egg
	jr nz, _exit_egg
	ld a, #ST_EGG_OPENED << #4 | #UPD_OBJECT_EGG
	jr _anim_egg

_chkforWall :
	cp #ANIM_CYCLE_WALL_BREAK
	jr nz, _chkInteractive
	; its a Wall - check if cEnableType = ANIMATE_OBJ_WALL
	ld a, c
	cp #ANIMATE_OBJ_WALL
	jr nz, _exit_wall
	; check for wall to be broken
	ld de, #05
	add hl, de
	dec (hl) ; sAnimSpecialTiles->cTimeLeft--
	jr z, _anim_wall
_exit_egg :
_exit_wall :
_exit_interactive :
_exit_locker :
	pop hl
	jr _exitFalse

_anim_wall :
  dec hl
	ld a, (hl) ; A = sAnimSpecialTiles->cTimer
	inc hl
	ld (hl), a ; sAnimSpecialTiles->cTimeLeft = sAnimSpecialTiles->cTimer
	; Add sAnimSpecialTiles->cTimer points to the score
	call _add_score_points
	pop hl
	dec hl; HL = &_sAnimSpecialTiles->cSpTileStatus
	jp _noKeyReq

_anim_egg :
	; B = ObjID, A = New_Status
	call _update_screen_object_ex
	ld a, #EGG_SHOTS_TO_DESTROY
	call _add_score_points
	pop hl
	dec hl; HL = &_sAnimSpecialTiles->cSpTileStatus
	push hl
	call _noKeyReq
	pop hl
	ld de, #10 + #10
	add hl, de ; next sAnimSpecialTiles record
	jp _noKeyReq
		
_chkInteractive :
	cp #ANIM_CYCLE_INTERACTIVE
	jr nz, _chkLocker
	; its an Interactive - check if cEnableType = ANIMATE_OBJ_INTER or ANIMATE_OBJ_COLLC
	ld a, c
	cp #ANIMATE_OBJ_COLLC
	jr z, _check_if_interactive_already_enabled
	cp #ANIMATE_OBJ_INTER
	jr nz, _exit_interactive
_check_if_interactive_already_enabled :
	pop hl
	dec hl ; HL = &_sAnimSpecialTiles->cSpTileStatus
	ld a, (hl)
	dec a; if A == 1(ST_ENABLED) then its not necessary to enable twice
	jp z, _exitFalse
	ld (hl), #ST_ENABLED; sAnimSpecialTiles->cSpTileStatus = ST_ENABLED

	; if cEnableType = ANIMATE_OBJ_COLLC, no further checks - just add score points and enable animation
	ld a, c
	cp #ANIMATE_OBJ_COLLC
	jp nz, _continue_interactive_not_collectible
	; Add SCORE_COLLECTBL_POINTS points to the score
	ld a, #SCORE_COLLECTBL_POINTS
	push hl
	call _add_score_points
	pop hl
	jp _noKeyReq_ex

_continue_interactive_not_collectible :
	; if Interactive object = GAME_PWR_LOCK_TL_OFFSET need to decrease access key usage
	dec hl
	dec hl
	dec hl ; HL = &_sAnimSpecialTiles->cTile
	; if (cGlbTile == GAME_TILE_OFFSET + GAME_PWR_LOCK_TL_OFFSET)
	ld a, #TS_SCORE_SIZE + #GAME_PWR_LOCK_TL_OFFSET
	cp (hl)
	jr nz, _end_animate
	ld hl, #_cRemainKey
	dec (hl)
	jr nz, _end_animate
	ld hl, #_cPlyObjects
	res 0, (hl); HAS_OBJECT_KEY
	call _display_objects

_end_animate :
	ld hl, #_cGlbSpecialTilesActive
	inc (hl); _cGlbSpecialTilesActive++
	; Add SCORE_INTERACTV_POINTS points to the score
	ld a, #SCORE_INTERACTV_POINTS
	call _add_score_points
	ld l, #BOOL_TRUE
	ret

_chkLocker :
	cp #ANIM_CYCLE_LOCKER_OPEN
	jr nz, _chkGate
	; its a Locker - check if cEnableType = ANIMATE_OBJ_LOCKER
	ld a, c
	cp #ANIMATE_OBJ_LOCKER
	jp nz, _exit_locker
	pop hl
	dec hl ; HL = &_sAnimSpecialTiles->cSpTileStatus
	jp _noKeyReq

_chkGate :
	pop hl
	; check if gate is ST_DISABLED to proceed. If gate is already ST_ENABLED, no need to process the colision
	dec hl; HL = &_sAnimSpecialTiles->cSpTileStatus
	ld a, (hl)
	dec a; if A == 1 (ST_ENABLED) then its not necessary to enable again
	jp z, _exitFalse

	; check if player has the right key required to open the gate.
	ld a, b; B = cObjID
	
	; A = cObjID(0KKKxxxx)
	rra
	rra
	rra
	rra
	and #0b00000111
	jp z, _noKeyReq
	ld b, a ; B = required key
	ld c, #HAS_OBJECT_KEY

_findkey :
	dec b
	jp z, _keybuilt
	sla c
	jr _findkey
_keybuilt :
	ld a, (#_cPlyObjects) ; A = player objects
	and c ; C = required key mask
	jp z, _exitFalse

	; Key found. Decrease card remaining pts. Reset #_cPlyObjects bit and display objects if ZERO
	ld a, c
	cp #HAS_OBJECT_YELLOW_CARD
	jr nz, _tst_green_card
	ld a, (#_cRemainYellowCard)
	dec a
	ld (#_cRemainYellowCard), a
	jr nz, _noKeyReq
	ld a, (#_cPlyObjects); A = player objects
	res 1, a
	jr _reset_key

_tst_green_card :
	cp #HAS_OBJECT_GREEN_CARD
	jr nz, _tst_red_card
	ld a, (#_cRemainGreenCard)
	dec a
	ld (#_cRemainGreenCard), a
	jr nz, _noKeyReq
	ld a, (#_cPlyObjects); A = player objects
	res 2, a
	jr _reset_key

_tst_red_card :
	cp #HAS_OBJECT_RED_CARD
	jr nz, _noKeyReq
	ld a, (#_cRemainRedCard)
	dec a
	ld (#_cRemainRedCard), a
	jr nz, _noKeyReq
	ld a, (#_cPlyObjects); A = player objects
	res 3, a

_reset_key :
	ld (#_cPlyObjects), a
	push hl
	call _display_objects
	; mplayer_play_effect_p(SFX_TIMEOFF, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0008; 00 + SFX_TIMEOFF
	call	_mplayer_play_effect_p_asm_direct
	pop hl

_noKeyReq :
	ld (hl), #ST_ENABLED; sAnimSpecialTiles->cSpTileStatus = ST_ENABLED
_noKeyReq_ex :
	ld de, #10
	add hl, de ; next sAnimSpecialTiles record
	ld (hl), #ST_ENABLED; sAnimSpecialTiles->cSpTileStatus = ST_ENABLED
	ld hl, #_cGlbSpecialTilesActive
	inc (hl) ; _cGlbSpecialTilesActive++
	inc (hl) ; _cGlbSpecialTilesActive++
	ld l, #BOOL_TRUE
__endasm;
}  // bool special_object_animated_ok()

/*
* Check for player colision with Fatal, Gate closing, Solid colision, Objects, Empty floor and Special floor (belt)
* Returns:	true (1 - no colision with player)
*						false (0 - colision(s) with player)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal *
*														||||||L- Solid * (Fatal + Solid = Colision with solid when a slider pushed it left/right)
*														|||||L-- Gate * (Fatal + Gate = Gate Closing)
*														||||L--- Empty floor *
*														|||L---- Special floor (belt) *
*														||L----- Next map
*														|L------ Object *
*														L------- Interactive
*							iGlbPosition = Tile object position into the screen (0 - 768) when 'Object' colision detected
*							cGlbTile = Tile object index into current tileset when 'Object' colision detected
*							cGlbObjData = Belt cycle direction (4 or 5) when 'Special Floor' detected
*							cGlbObjData = number of empty floor tiles below the player (1 or 2) detected
*/
uint8_t cGlbPlyFlagCache;
bool is_player_ok()
{
__asm
	; execute every even cycle and repeat result from previous cycle if not executed
	ld a, (#_iGameCycles)
	bit 0, a
	jp nz, _goChecking
	ld a, (#_cGlbPlyFlagCache)
	cp #CACHE_INVALID
	jr z, _goChecking
	ld (#_cGlbPlyFlag), a; _cGlbPlyFlag = _cGlbPlyFlagCache
	jp _EndTests1

_goChecking :
	xor a
	ld (#_cGlbPlyFlag), a ; reset _cGlbPlyFlag
	ld a, (#_sThePlayer) ; A = _sThePlayer.x
	; based on X body position, we need to test 1 or 2 tiles from the player to detect colision
	call _chkBodyTileQtty_ex_2	; B = 1 or 2 horizontal tiles to test
	ld c, #0 + #4
	ld d, #0
	call _calcTileXYAddrInt
	push hl
	call _check_fatal_or_gate_obj ; check 2 left tiles
	pop hl
  ; if bit 2 (GATE Flag) is set, adjust player position to the right
	ld a, (#_cGlbPlyFlag)
	bit 2, a 
	jr z, _not_a_gate_step_1
	ld e, #8 - #4
	jr _adjust_player_X

_not_a_gate_step_1 :
	dec b
	jr z, _no_more_horizontal
	inc hl
	call _check_fatal_or_gate_obj ; check 2 right tiles
	; if bit 2 (GATE Flag) is set, adjust player position to the left
	ld a, (#_cGlbPlyFlag)
	bit 2, a
	jr z, _no_more_horizontal
	ld e, #256 - #4
_adjust_player_X :
	ld a, (#_sThePlayer)
	add #4
	and #0b11111000
	add e
	ld (#_sThePlayer), a
	ld a, #CACHE_INVALID
	ld (#_cGlbPlyFlagCache), a  ; invalidate _cGlbPlyFlagCache
	ld (#_bGlbPlyChangedPosition), a
	jp _EndConflicting1

_no_more_horizontal :
	; now lets test for empty floor & special floor(Belt)
	; based on X foot position, we need to test 1 or 2 tiles below the player to detect empty floor
	call _chkFootTileQtty; B = 1 or 2 horizontal tiles to test
	ld c, #0 + #6
	ld d, #16 ; 1 row below the player
	call _calcTileXYAddrInt

	ld a, (hl)
	cp #TILE_TYPE_SPECIAL_BELT
	jr nz, _not_a_belt
_belt_detected :
	; special floor detected (belt). Need to return cGlbObjData
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld a, (hl)
	ld (#_cGlbObjData), a; _cGlbObjData = _cMap_ObjIndex[iGlbPosition]
	ld hl, #_cGlbPlyFlag
	set 4, (hl) ; special floor(belt)
	jp _EndConflicting

_not_a_belt :  
	cp #TILE_TYPE_BLANK
	jr z, _first_empty_floor
	cp #TILE_TYPE_FATAL
	jr nz, _not_empty_floor
_first_empty_floor :
	; empty floor, first tile
	dec b
	jp z, _EmptyFloor	; unique tile is blank - no need to test a second tile
	inc hl
	ld a, (hl)
	cp #TILE_TYPE_BLANK
	jp z, _EmptyFloor	; both tiles are blank
	cp #TILE_TYPE_FATAL
	jp z, _EmptyFloor ; both tiles are blank
_check_for_belt :
	cp #TILE_TYPE_SPECIAL_BELT
	jr z, _belt_detected
	jp _EndTests

_not_empty_floor :
	dec b
	jp z, _EndTests
	inc hl
	ld a, (hl)
	jr _check_for_belt

_check_fatal_or_gate_obj :
	; start testing for solid, gate (only in case a gate closes at the player), fatal and object tiles
	ld c, #2
	ld a, (hl)
	cp #TILE_TYPE_SPECIAL_GATE
	jr nz, _not_a_gate
	ld a, (#_cGlbPlyFlag)
	set 0, a ; FATAL Flag
	set 2, a; GATE Flag
	jr _check_fgo_step_2
_not_a_gate :
	cp #TILE_TYPE_SOLID
	jr nz, _not_a_solid
  ; Solid colision detection.
	; As we already have handled such colision when slider is up or down (_detect_player_colision), it means player was pushed right/left into a wall by a horizontal slider
	; Player should die
	ld a, (#_cGlbPlyFlag)
	set 0, a ; FATAL Flag
	set 1, a ; SOLID Flag
	jr _check_fgo_step_2
_not_a_solid :
	bit 5, a  ; FATAL BIT
	jr z, _not_a_fatal
	ld a, (#_cGlbPlyFlag)
	; fatal was found!
	set 0, a ; FATAL Flag
	jr _check_fgo_step_2
_not_a_fatal :
	cp #TILE_TYPE_OBJECT
	jr nz, _not_an_object
	; object was found! Need to return iGlbPosition and cGlbTile
	push hl
	push hl
	ld de, #_cMap_TileClass - (#03 * #32)
	xor a
	sbc hl, de
	ld (#_iGlbPosition), hl
	pop hl
	ld de, #MAP_BYTES_SIZE * #2
	add hl, de
	ld a, (hl); A = cMap_Data[HL]
	ld(#_cGlbTile), a
	pop hl
	ld a, (#_cGlbPlyFlag)
	set 6, a ; OBJECT Flag
_check_fgo_step_2 :
	ld (#_cGlbPlyFlag), a
_not_an_object :
	dec c
	ret z
	ld de, #32
	add hl, de
	ld a, (hl)
	jr _not_a_gate


	; Input: C = +- X Offset from Player X position
	;        D = +- Y Offset from Player Y position
	;        Player Y position MUST be multiple of 8
	; Output: HL = &cMap_TileClass[X,Y]
	; Changes: A, D, E, H, L
_calcTileXYAddrInt :
	ld a, (#_sThePlayer + #1)
	add a, d
	ld l, a
	ld h, #0; HL = _sThePlayer.y
	add hl, hl
	add hl, hl
	ld de, #32 * #3
	xor a
	sbc hl, de ; HL = (((_sThePlayer.y / 8) - 3) * 32)
_calcTileXAddr :
	ld a, (#_sThePlayer)
_calcTileXAddrEx :
	add a, c ; A = _sThePlayer.x +- Offset
	and #0b11111000
	rrca; rotate right
	rrca
	rrca
	ld e, a
	ld d, #0
	add hl, de
	ld de, #_cMap_TileClass
	add hl, de
	ret

	; Input: C = +-X Offset from Player X position
	;        D = +-Y Offset from Player Y position
	;        Player Y position DONT NEED to be multiple of 8
	; Output: HL = &cMap_TileClass[X, Y]
	; Changes: A, D, E, H, L
_calcTileXYAddr :
	ld a, (#_sThePlayer + #1)
	add a, d
	and #0b11111000
	rrca; rotate right
	rrca
	rrca; A = (Y) / 8
	add a, #256 - #3; A = ((Y) / 8) - 3
	ld l, a
	ld h, #00
	rlc l
	rlc l
	rlc l; L = L * 8
	add hl, hl
	add hl, hl; HL = ((((Y) / 8) - 3) * 32)
	jr _calcTileXAddr

	; Input: A = Generic Y position
	;        C = Generic X position
	;        Y position DONT NEED to be multiple of 8
	; Output: HL = &cMap_TileClass[X, Y]
	; Changes: A, D, E, H, L
_calcTileXYAddrGeneric :
	and #0b11111000
	rrca; rotate right
	rrca
	rrca; A = (Y) / 8
	add a, #256 - #3; A = ((Y) / 8) - 3
	ld l, a
	ld h, #00
	rlc l
	rlc l
	rlc l; L = L * 8
	add hl, hl
	add hl, hl; HL = ((((Y) / 8) - 3) * 32)
	xor a
	jr _calcTileXAddrEx

_EndTests :
	ld a, (#_cGlbPlyFlag)
	ld (#_cGlbPlyFlagCache), a ; _cGlbPlyFlagCache = _cGlbPlyFlag
_EndTests1 :
	or a
	jp nz, _EndConflicting1
	ld l, #BOOL_TRUE; everything ok
	ret

_EmptyFloor :
	ld a, b
	inc a
	ld(_cGlbObjData), a; _cGlbObjData = 1 or 2 empty tiles
	ld hl, #_cGlbPlyFlag
	set 3, (hl)

_EndConflicting :
	ld a, (hl)
	ld (#_cGlbPlyFlagCache), a; _cGlbPlyFlagCache = _cGlbPlyFlag
_EndConflicting1 :
	ld l, #BOOL_FALSE; conflict detected
__endasm;
}  // bool is_player_ok()

/*
* When climbing, check if the player keeps climbing or has stopped climbing (has reached the top)
* Returns:	true (1 - player continue climbing)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal
*														||||||L- Solid
*														|||||L-- Gate
*														||||L--- Empty floor
*														|||L---- Special floor (belt)
*														||L----- Next map *
*														|L------ Object
*														L------- Interactive
*					    cGlbObjData = shift direction + screen destination when Next Map detected
*						false (0 - player is not climbing (was not before or player reach the top))
*							sThePlayer.status = PLYR_STATUS_STAND (if player stopped climbing)
*/
bool is_player_climb_up()
{
__asm
	ld a, (#_sThePlayer + #03); A = _sThePlayer.status
	ld l, #BOOL_FALSE
	cp #PLYR_STATUS_CLIMB
	ret nz; not climbing

	xor a
	ld(#_cGlbPlyFlag), a; reset _cGlbPlyFlag
	inc a
	ld (#_bGlbPlyMoved), a ; player has moved UP

	ld a, (#_sThePlayer + #01) ; A = _sThePlayer.y
	dec a
	ld (#_sThePlayer + #01), a

	; check for next map when climbing
	ld l, #BOOL_TRUE; everything ok
	cp #4 * #8
	jr nc, _not_NextM_3
	cp #3 * #8
	ret nc
	; Next map detected
	ld a, (#_cScreenMap)
	sub #5
	or #SCR_SHIFT_UP << #5
	jp _do_nextm_up
_not_NextM_3 :
	; not Next map - check if player has reached a solid tile
	ld c, #7
	ld d, #0
	call _calcTileXYAddr
	ld a, (hl)
	bit #7, a ; SOLID BIT
	jr z, _upper_tile_not_solid
	bit #6, a ; test if bit 6 (SPECIAL TILE BIT) is set
	jr z, _upper_tile_is_solid_so_dont_climb_up

_upper_tile_not_solid :
	; not solid, so check if player has reached the top floor
	;ld c, #7  ; C=7 already
	ld d, #8
	call _calcTileXYAddr
	ld a, (hl)
	ld l, #BOOL_TRUE; everything ok
	bit #6, a ; test if bit 6 (SPECIAL TILE BIT) is set
	ret nz

	; blank tile found. adjust Y position, set avoid_jump counter and stop climbing
	ld hl, #_sThePlayer + #01 ; HL = &_sThePlayer.y
	ld a, (hl)
	and a, #0b11111000 ; round y to be multiple of 8
	ld (hl), a

	ld a, #ONE_SECOND_TIMER
	ld (#_cGlbPlyJumpTimer), a
	xor a ; A = BOOL_FALSE
	ld (#_bGlbPlyMoved), a   ; player has not moved
	inc a ; A = BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a ; but player has changed position
	jr _cdSolid

_upper_tile_is_solid_so_dont_climb_up :
	ld hl, #_sThePlayer + #01 ; HL = &_sThePlayer.y
	inc (hl) ; rollback y position
	; TODO: include SFX HERE?
	ld l, #BOOL_TRUE; everything ok
__endasm;
}  // bool is_player_climb_up()

/*
* When descending, check if the player continues descending or stopped descending (reached the ground or cable has ended)
* Returns:	true (1 - player continue climbing)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal
*														||||||L- Solid
*														|||||L-- Gate
*														||||L--- Empty floor
*														|||L---- Special floor (belt)
*														||L----- Next map *
*														|L------ Object
*														L------- Interactive
*					    cGlbObjData = shift direction + screen destination when Next Map detected
*						false (0 - player is not climbing (was not before, player reach the floor or cable has ended))
*							sThePlayer.status = PLYR_STATUS_STAND (if player stopped climbing)
*/
bool is_player_climb_down()
{
__asm
	ld a, (#_sThePlayer + #03); A = _sThePlayer.status
	ld l, #BOOL_FALSE
	cp #PLYR_STATUS_CLIMB
	ret nz ; not climbing

	xor a
	ld (#_cGlbPlyFlag), a; reset _cGlbPlyFlag
	inc a
	ld (#_bGlbPlyMoved), a; player has moved DOWN

	ld a, (#_sThePlayer + #01) ; A = _sThePlayer.y
	inc a
	ld (#_sThePlayer + #01), a
		
	; check for next map when climbing
	ld l, #BOOL_TRUE; everything ok
	cp #22 * #8
	jr c, _not_NextM_2
	cp #24 * #8 - #4
	ret c
	; Next map detected
	jp _do_nextm_down
_not_NextM_2 :
	; not Next map - check if player should keep climbing down
  ld c, #7
  ld d, #8
  call _calcTileXYAddr
  ld a, (hl)
  bit #6, a  ; test if bit 6 (SPECIAL TILE BIT) is set
  jr z, _no_cable_so_end_climbing_down

	; now check if player has reached the floor
	;ld c, #7  ; C = 7 already
	ld d, #16
	call _calcTileXYAddr
	ld a, (hl)
	ld l, #BOOL_TRUE; everything ok
	bit #7, a; test if bit 7 (SOLID BIT) is set
	ret z
	bit #6, a; test if bit 6 (SPECIAL TILE BIT) is set
	ret nz

_flSolid_ex :
	xor a
	ld (#_bGlbPlyMoved), a; player has not moved
_flSolid :
	; when the player stop falling, its Y position should be divisible by 8. However there are some rare exceptions (bugs) that can be fixed here (forcing Y to be divisible by 8)
	ld a, (#_sThePlayer + #1); A = _sThePlayer.y
	and #0b11111000
	ld (#_sThePlayer + #1), a
	; TODO: include SFX here? (reach floor)
_no_cable_so_end_climbing_down :
_cdSolid :
	; solid tile found. Stop climbing
	ld hl, #_sThePlayer + #03; HL = &_sThePlayer.status
	ld (hl), #PLYR_STATUS_STAND
	ld l, #BOOL_FALSE
__endasm;
}  // bool is_player_climb_down()

/*
* When command up pressed, check for player colision with Solid and Special tiles (stairs/cables)
* Returns:	true (1 - no colision with player)
*						false (0 - colision with player)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal
*														||||||L- Solid *
*														|||||L-- Gate
*														||||L--- Empty floor
*														|||L---- Special (Stairs) *
*														||L----- Next map
*														|L------ Object
*														L------- TBD
*							cGlbObjData = number of stair tiles above the player (1 or 2) detected
*/
bool is_player_cmd_up_ok()
{
__asm
	xor a
	ld (#_cGlbPlyFlag), a ; reset _cGlbPlyFlag

	ld a, (#_sThePlayer); A = _sThePlayer.x
	call _chkBodyTileQtty_ex_2 ; B = 1 or 2 horizontal tiles to test
	ld c, #4
	ld d, #256 - #8
	call _calcTileXYAddrInt
_chk_head_sld :
	ld a, (hl)
	; lets check the tile above player head for a solid one (exception for Special Solid Tiles)
	bit #7, a; test if bit 7 (SOLID BIT) is set
	jr z, _cont_chk_head
	; Solid tile - check if also Special Solid
	bit #6, a; test if bit 6 (SPECIAL TILE BIT) is set
	jr z, _solid_up; tile is not stairs
_cont_chk_head :
	inc hl
	djnz _chk_head_sld

	; not a solid tile above the head - check for a stair
	ld d, #256 - #8
_tstforStair :
	call _chkFootTileQtty  ; B = 1 or 2 horizontal tiles to test
	ld c, #6
	call _calcTileXYAddrInt
	ld a, (hl)
	bit #6, a; test if bit 6 (SPECIAL TILE BIT) is set
	jr z, _duNotStairs; tile is not stairs
	dec b
	jr z, _stairDetected ; first tile is a stair AND just 1 tile - no need to test a second tile
	inc hl
	ld a, (hl)
	bit #6, a; test if bit 6 (SPECIAL TILE BIT) is set
	jr z, _duNotStairs ; second tile is not stairs
_stairDetected :
	; stairs detected
	ld a, b
	inc a
	ld (#_cGlbObjData), a; _cGlbObjData = 1 or 2 empty tiles
	ld hl, #_cGlbPlyFlag
	set 4, (hl); special floor(stairs)
	jp _dwEndConflicting

_duNotStairs :
	ld l, #BOOL_TRUE; no conflict detected - everything ok
	ret

_solid_up :
	ld hl, #_cGlbPlyFlag
	set 1, (hl) ; Solid
	ld l, #BOOL_FALSE ; conflict detected
__endasm;
}  // bool is_player_cmd_up_ok()

/*
* When command down pressed, check for player colision with Special tiles (gates, stairs/cables)
* Returns:	true (1 - no colision with player)
*						false (0 - colision(s) with player)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal
*														||||||L- Solid
*														|||||L-- Gate *
*														||||L--- Empty floor
*														|||L---- Special floor (stairs, cables) *
*														||L----- Next map
*														|L------ Object
*														L------- TBD
*							cGlbSpObjID = ObjectID when Gate colision detected
*							cGlbObjData = number of stair tiles below the player (1 or 2) detected
*/
bool is_player_cmd_down_ok()
{
__asm
	xor a
	ld(#_cGlbPlyFlag), a; reset _cGlbPlyFlag

	ld c, #7
	ld d, #16
	call _calcTileXYAddrInt
	ld a, (hl)
	; lets check the tile above player foot to check for a gate
	cp #TILE_TYPE_SPECIAL_GATE
	jr nz, _dwNotGate; tile is not a gate
	; gate floor detected. Set _cGlbSpObjID
	call _SetGateFound
	jr _dwEndConflicting

_dwNotGate :
	; Test stairs below player
	ld d, #16
	jp _tstforStair


; Check the horizontal # of tiles to test when detect player foot colision (empty, stair, gate, belt, solid)
; if (X + 6) % 8 < 5 : Test 1 tile -OR- (X + 6) % 8 >= 5 : Test 2 tiles
; Input: None
; Output: B = 1 or 2 tyles to be verified
; Changes: A, B
_chkFootTileQtty :
	ld b, #1
	ld a, (#_sThePlayer)
	add a, #6
	and #0b00000111
	cp #5
	ret c ; just test 1 tile
	inc b ; need to test 2 tiles
	ret

_dwEndConflicting :
	ld l, #BOOL_FALSE; conflict detected
__endasm;
}  // bool is_player_cmd_down_ok()

/*
* When left/right walking, check for player colision with Solid, NextMap/Portal, Interactive, Collectible and Gates. Also check for distance from Eggs at the same level
* Returns:	true (1 - no colision with player)
*						false (0 - colision(s) with player)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal
*														||||||L- Solid *
*														|||||L-- Gate *
*														||||L--- Empty floor
*														|||L---- Special floor (belt)
*														||L----- Next map/Portal *
*														|L------ Collectible *  (Tiletype=TILE_TYPE_COLLECTIBLE)
*														L------- Interactive *
*                                      only if (Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LIGHT_ONOFF AND Tile=GAME_PWR_SWITCH_TL_OFFSET+1 AND PlayerObjects=HAS_OBJECT_SCREW) or
*                                              (Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_BUTTON_TL_OFFSET) or
*                                              (Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY) or
*                                              (Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_BUTTON_TL_OFFSET) or
*                                              (Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY) or
*							cGlbSpObjID = ObjectID when Gate/Interactive/Collectible colision detected
*							cGlbObjData = shift direction + screen destination when Next Map detected
*/
bool is_player_walking_ok(uint8_t cDirection)
{
__asm
	xor a
	ld(#_cGlbPlyFlag), a; reset _cGlbPlyFlag

	; check for Eggs in this screen. If any, check for an egg in the same Y coordinate then calculate player distance for that egg
	ld a, (#_cScreenEggsQtty)
	ld b, a
	or a
	jp z, _no_egg_trigger_ex
	; there are some eggs in this screen - check for same Player and Egg Y coordinate
	push ix
	ld hl, #_sObjScreen - #1
	ld de, #5
_find_next_egg_scr :
	inc hl
	ld a, (hl)
	cp #0xFF ; not found
	jp z, _no_egg_trigger
	push hl
	pop ix
	add hl, de
	ld a, (hl)
	cp #ANIM_CYCLE_FACEHUG_EGG
	jr nz, _find_next_egg_scr
	; found an egg - check for egg status
	ld a, 4 (ix)
	cp #ST_EGG_RELEASED
	jp z, _search_other_egg
	; check Y position
	ld a, (#_sThePlayer + #1)
	cp 3 (ix)
	jp nz, _search_other_egg
	; player and Egg at the same Y coordinate - check the X distance
	ld a, (#_sThePlayer)
	sub 1 (ix)
	;; jp m, _positive_X  ; M/P does not clearly working
	jr nc, _positive_X
	neg
_positive_X :
	ld c, a
	cp #8 * #PLY_DIST_EGG_OPEN
	jr nc, _search_other_egg
	; found an egg (closed or opened) - animate it
	ld a, 4 (ix)
	cp #ST_EGG_CLOSED
	jr nz, _test_release_fh
	;; ld 4 (ix), #ST_EGG_OPENED ; auto-updated at _update_screen_object_ex()
	; animate from egg CLOSED -> OPENED
	push bc
	push hl
	ld c, #ANIMATE_OBJ_EGG
	ld b, 0 (ix) ; B = ObjID
	call _activate_interactive_animation_ex
	ld de, #05
	pop hl
	pop bc
_search_other_egg :
	djnz _find_next_egg_scr
	jr _no_egg_trigger

_test_release_fh :
  ; egg already opened
	ld a, c
	cp #8 * #PLY_DIST_EGG_FH_RELEASE
	jr nc, _search_other_egg
	ld 4 (ix), #ST_EGG_RELEASED
	; find corresponding EnemyID + ScreenID and activate it
	push iy
	ld iy, #_sEnemies
	ld a, (#_cCreatedEnemyQtty)
	; no need for check - assume always > 0
	;; or a
	;; jr z, _no_egg_trigger_ex2
	ld de, #14; sizeof(struct EnemyEntity)
	ld b, a
_try_find_enemy_trigger :
  ld a, (#_cScreenMap)
	cp 9 (iy); screenId
	jr nz, _check_new_enemy_trigger
	ld a, 0 (ix)  ; 0IIIOOOO
	rra
	rra
	rra
	rra
	and #0b00001111
	cp 10 (iy)  ; objId
	jp z, _activate_enemy_trigger  ; enemy found - activate it
_check_new_enemy_trigger :
  add iy, de
	djnz _try_find_enemy_trigger
	; should never happen
	jr _no_egg_trigger_ex2

_activate_enemy_trigger :
  ; iy = corresponding EnemyEntity record
	; ix = Egg entity record
	; now set x, y, hitcounter, pat, frame and delay attributes
	ld b, 1 (ix); cX0
	ld a, 2 (iy); dir
	cp #ENEMY_SPRT_DIR_RIGHT
	jr z, _enemy_right
	ld a, #256 - #10
	jr _cont_activate_enemy
_enemy_right :
  ld a, #6
_cont_activate_enemy :
  add a, b
	ld 0 (iy), a  ; x

	ld a, 3 (ix)  ; cY0
	sub a, #8
	ld 1 (iy), a  ; y

	ld 3 (iy), #ENEMY_STATUS_AWAKING  ; status

	ld 4 (iy), #ENEMY_HIT_COUNT  ; hitcounter

  ; no need to set pattern attribute

	ld 6 (iy), #0  ; frame
	ld 7 (iy), #ENEMY_ANIM_DELAY  ; animation delay

	ld hl, #_cActiveEnemyQtty
	inc (hl)

_no_egg_trigger_ex2 :
	pop iy
_no_egg_trigger :
	pop ix
_no_egg_trigger_ex :
	ld hl, #2
	add hl, sp
	ld a, (hl) ; A = _cDirection
	ld (#_sThePlayer + #02), a ; _sThePlayer.dir = PLYR_SPRT_DIR_RIGHT / PLYR_SPRT_DIR_LEFT
	cp #PLYR_SPRT_DIR_LEFT
	ld a, (#_sThePlayer) ; A = _sThePlayer.x
	jp z, _wlkLeft

	; Walk right
	ld c, #1 + #11; Add 1 to X to move right
	; first check for next map colision
	cp #256 - #4 - #8
	jp c, _wlkCheckSolid
	; need to return cGlbObjData
	ld a, (#_cScreenMap)
	inc a
	or #SCR_SHIFT_LEFT << #5
_wlkNextM :
	ld (#_cGlbObjData), a; (sssDDDDD)
	ld hl, #_cGlbPlyFlag
	set 5, (hl)  ; COLISION_NEXTM
	jp _wlkEndConflicting

_wlkLeft :
	ld c, #255 + #4; Subtract 1 from X to move left
	; first check for next map colision
	or a
	jp nz, _wlkCheckSolid
	; need to return cGlbObjData
	ld a, (#_cScreenMap)
	dec a
	or #SCR_SHIFT_RIGHT << #5
	jr _wlkNextM

_wlkPortalFound :
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld a, (hl) ; screen destination (sss0DDDD)
	or #SCR_SHIFT_PORTAL << #5
	jr _wlkNextM

	; Calculate the next up tile position for solid / belt / gate / portal / interactive / wall / egg
_wlkCheckSolid :
	ld d, #0
	call _calcTileXYAddrInt
	ld b, #02; 2 columns to test
_wlkNextTile :
	ld a, (hl)
	cp #TILE_TYPE_SOLID
	jr z, _wlkSolidFound
	cp #TILE_TYPE_SPECIAL_BELT
	jr z, _wlkSolidFound
	cp #TILE_TYPE_WALL
	jr z, _wlkSolidFound
	cp #TILE_TYPE_EGG
	jr z, _wlkSolidFound
	cp #TILE_TYPE_SPECIAL_GATE
	jr z, _wlkGateFound
	cp #TILE_TYPE_INTERACTIVE
	jr z, _wlkInteractiveFound
	cp #TILE_TYPE_PORTAL
	jr z, _wlkPortalFound
	cp #TILE_TYPE_COLLECTIBLE
	jp z, _wlkCollectibleFound
	ld de, #32
	add hl, de; look next tile
	djnz _wlkNextTile

	; no colision detected. Walking left / right OK
	ld hl, #_sThePlayer
	ld a, (#_sThePlayer + #02)
	cp #PLYR_SPRT_DIR_LEFT
	jp z, _wlkLeftOK
	inc (hl); _sThePlayer.x++
_wlkEnd :
	ld hl, #_sThePlayer + #03
	ld(hl), #PLYR_STATUS_WALKING; _sThePlayer.status = PLYR_STATUS_WALKING
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyMoved), a; player has moved LEFT/RIGHT
	ld l, a ; #BOOL_TRUE everything ok
	ret
_wlkLeftOK :
	dec (hl); _sThePlayer.x--
	jr _wlkEnd

_wlkCollectibleFound :
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld b, (hl) ; B = cObjID(10aaOOOO)
	ld hl, #_cGlbPlyFlag
	set 6, (hl); COLISION_COLLECTIBLE
	jr _execute_mission_complete

_SetGateFound :
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	
	ld a, (hl)
	ld (#_cGlbSpObjID), a; _cGlbSpObjID = _cMap_ObjIndex[iGlbPosition]
	ld hl, #_cGlbPlyFlag
	set 2, (hl) ; COLISION_GATE
	ret

_wlkGateFound :
	call _SetGateFound
_wlkSolidFound :
	ld hl, #_cGlbPlyFlag
	set 1, (hl); COLISION_SOLID
	jp _wlkEndConflicting

_wlkInteractiveFound :
	; only if Tiletype = TILE_TYPE_INTERACTIVE AND Action = INTERACTIVE_ACTION_LIGHT_ONOFF AND Tile = GAME_PWR_SWITCH_TL_OFFSET + 1 AND PlayerObjects = HAS_OBJECT_SCREW
	;         Tiletype = TILE_TYPE_INTERACTIVE AND Action = INTERACTIVE_ACTION_LOCKER_OPEN AND Tile = GAME_PWR_BUTTON_TL_OFFSET
	;         Tiletype = TILE_TYPE_INTERACTIVE AND Action = INTERACTIVE_ACTION_LOCKER_OPEN AND Tile = GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects = HAS_OBJECT_KEY
	;         Tiletype = TILE_TYPE_INTERACTIVE AND Action = INTERACTIVE_ACTION_MISSION_CPLT AND Tile = GAME_PWR_BUTTON_TL_OFFSET
	;         Tiletype = TILE_TYPE_INTERACTIVE AND Action = INTERACTIVE_ACTION_MISSION_CPLT AND Tile = GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects = HAS_OBJECT_KEY

	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld a, (hl) ; A = cObjID(10aaOOOO)
	ld b, a  ; B = cObjID(10aaOOOO)
  and #0b00110000  ; A = 00aa0000
	jr z, _check_for_action_light
	
	ld c, #0
	cp #INTERACTIVE_ACTION_LOCKER_OPEN << #4
	jr z, _check_for_action_locker

	cp #INTERACTIVE_ACTION_MISSION_CPLT << #4
	jr nz, _wlkSolidFound  ; action not INTERACTIVE_ACTION_LIGHT_ONOFF, INTERACTIVE_ACTION_LOCKER_OPEN nor INTERACTIVE_ACTION_MISSION_CPLT

	; action = INTERACTIVE_ACTION_MISSION_CPLT
	inc c
_check_for_action_locker :
	; action = INTERACTIVE_ACTION_LOCKER_OPEN
	ld a, #TS_SCORE_SIZE + #GAME_PWR_BUTTON_TL_OFFSET ; tile to be confirmed
	call _check_for_interactive_tile
	jr z, _found_interactive_tile
	add a, #GAME_PWR_LOCK_TL_OFFSET - #GAME_PWR_BUTTON_TL_OFFSET  ; tile to be confirmed
	cp (hl)
	jr nz, _wlkSolidFound

	; check for key object(HAS_OBJECT_KEY). If yes, enable tile animation
	ld a, (#_cPlyObjects)
	and #HAS_OBJECT_KEY
	jr z, _wlkSolidFound  ; no #HAS_OBJECT_KEY

_found_interactive_tile :
	; check Action to execute corresponding code
	ld a, c
	or a
	jr z, _execute_open_locker

	; execute Mission Complete
_execute_mission_complete :
	push bc  ; save B = cObjID(10aaOOOO)
	ld a, b; A = ObjID(10aaOOOO)
	and #0b00001111; A = Mission #(0000OOOO)
	ld hl, #_cMissionStatus
	dec a
	ld c, a
	ld b, #0
	add hl, bc
	ld a, (hl)
	cp #MISSION_COMPLETE
	jp z, _mission_already_completed
	ld (hl), #MISSION_COMPLETE
	ld hl, #_cRemainMission
	dec (hl)
	; Add SCORE_MISSION_POINTS points to the score
	ld a, #SCORE_MISSION_POINTS
  call _add_score_points
	call _update_mission_status
_mission_already_completed :
	pop af  ; recover A = cObjID(10aaOOOO)
	jr _commit_interactive_found_ex

_add_score_points :
	ld hl, #_cScoretoAdd
	add a, (hl); cScoretoAdd += A
	ld (hl), a
	ret

_execute_open_locker :
	; set Locker state = opened
	push bc  ; save B = cObjID(10aaOOOO)
	ld a, b  ; A = ObjID(10aaOOOO)
	and #0b00001111  ; A = Locker ID(0000OOOO)
	ld hl, #_cLockerOpened
	ld c, a
	ld b, #0
	add hl, bc
	ld a, (hl)
	cp #BOOL_TRUE
	jp z, _locker_already_opened
	ld(hl), #BOOL_TRUE
	ld a, c

	or #0b11000000  ; A = Locker ObjectID(1100OOOO)
	ld b, a
	ld c, #ANIMATE_OBJ_LOCKER
	call _activate_interactive_animation_ex  ; try to enable Locker animation(only works if Locker IS in this current screen)
_locker_already_opened :
	pop af  ; recover A = cObjID(10aaOOOO)
	jr _commit_interactive_found_ex

_check_for_action_light :
  ; action = INTERACTIVE_ACTION_LIGHT_ONOFF
	ld a, #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET + #01 ; tile to be confirmed
	call _check_for_interactive_tile
	jp nz, _wlkSolidFound ; not #GAME_PWR_SWITCH_TL_OFFSET + 1

	; check for screwdriver object(HAS_OBJECT_SCREW). If yes, enable tile animation
	ld a, (#_cPlyObjects)
	and #HAS_OBJECT_SCREW
	jp z, _wlkSolidFound ; no #HAS_OBJECT_SCREW
	ld hl, #_cRemainScrewdriver
	dec (hl)
	jr nz, _commit_interactive_found
	ld hl, #_cPlyObjects
	res 6, (hl) ; HAS_OBJECT_SCREW
	push bc
	call _display_objects
	pop bc

_commit_interactive_found :
	ld a, b  ; A = cObjID(10aaOOOO)
_commit_interactive_found_ex :
	ld (#_cGlbSpObjID), a	; _cGlbSpObjID = _cMap_ObjIndex[iGlbPosition]
	ld hl, #_cGlbPlyFlag
	set 7, (hl); COLISION_INTER

_wlkEndConflicting :
	ld a, #PLYR_STATUS_STAND
	ld(#_sThePlayer + #03), a ; _sThePlayer.status
	ld l, #BOOL_FALSE ; conflict detected
__endasm;
} // bool is_player_walking_ok()

/*
* Faster move the player to the right or to the left because its in a belt.
* cGlbObjData = 4(anti-clockwise/left) or 5(clockwise/right)
*/
void player_moving_at_belt()
{
__asm
	ld a, (#_cGlbObjData)
	cp #ANIM_CYCLE_BELT  ; 4 = anti-clockwise
	jp z, _plyMvLeft
	cp #ANIM_CYCLE_BELT + #1  ; 5 = clockwise
	ret nz
	; Move Right
	ld c, #1 + #11; Add 1 to X to move right
	jr _chkMove
_plyMvLeft :
	ld c, #255 + #4; Subtract 1 from X to move left
_chkMove :
	ld d, #0
	call _calcTileXYAddrInt
	ld a, (hl)
	; Start testing for solid tiles
	ld b, #02; 2 columns to test
_mvNextTile :
	cp #TILE_TYPE_SOLID
	ret z ; Solid found
_mvNotSolid :
	ld de, #32
	add hl, de; look next tile
	djnz _mvNextTile
	; no colision detected. Moving OK
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a; player has moved RIGHT/LEFT
	ld hl, #_sThePlayer
	ld a, (#_cGlbObjData)
	cp #ANIM_CYCLE_BELT  ; 4 = anti - clockwise
	jp z, _mvLeftOK
	inc(hl); _sThePlayer.x++
	ret
_mvLeftOK :
	dec (hl); _sThePlayer.x--
__endasm;
} // void player_moving_at_belt()

/*
* Check player falling status, solid colision (with horizontal forcefield) and update X,Y position
* Returns:	true (1 - player is falling)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal * (colision with horizontal forcefield)
*														||||||L- Solid
*														|||||L-- Gate
*														||||L--- Empty floor
*														|||L---- Special floor (belt)
*														||L----- Next map *
*														|L------ Object
*														L------- Interactive
*					    cGlbObjData = shift direction + screen destination when Next Map detected
*						false (0 - player is not falling)
*							sThePlayer.status = PLYR_STATUS_STAND (if the player stops falling)
*/
bool is_player_falling()
{
__asm
	ld a, (#_sThePlayer + #03) ; A = _sThePlayer.status
	ld l, #BOOL_FALSE
	cp #PLYR_STATUS_FALLING
	ret nz ; not falling

	xor a
	ld (#_cGlbPlyFlag), a; reset _cGlbPlyFlag
	ld hl, #_sThePlayer + #01; HL = &_sThePlayer.y
	;; change here to implement fall LUT
	inc (hl)
	ld a, (hl); A = _sThePlayer.y + 1

	; check for next map when falling
	ld l, #BOOL_TRUE  ; continue falling
	cp #22 * #8
	jr c, _not_NextM
	cp #24 * #8 - #2
	ret c
	; Next map detected
_do_nextm_down :
	ld a, (#_cScreenMap)
	add a, #5
	or #SCR_SHIFT_DOWN << #5
_do_nextm_up :
	ld (_cGlbObjData), a	; (sssDDDDD)
	ld hl, #_cGlbPlyFlag
	set 5, (hl) ; COLISION_NEXTM
	ld l, #BOOL_TRUE ; continue falling
	ret

_check_for_horiz_ff_colision :
  ld a, #BOOL_FALSE
	ld (#_cFFFlagColision), a
	; first lets check if the current player position conflicts with a Horizontal Forcefield
	; 1st check : Player head
	ld c, #0 + #7
	ld d, #0; first vertical player pixel(head)
	call _calcTileXYAddr
	ld a, (hl)
	cp #TILE_TYPE_FATAL_OR_SOLID
	jr z, _horiz_ff_colision_detected
	; 2nd check : Player body
	ld de, #32
	add hl, de
	ld a, (hl)
	cp #TILE_TYPE_FATAL_OR_SOLID
	jr z, _horiz_ff_colision_detected
	; 3rd check(optional) : Player foot (if Player.y % 8 = 0, then no need to test this additional tile)
	ld a, (#_sThePlayer + #01)
	and #0b00000111
	ret z  ; horiz_ff_colision_NOT_detected
	add hl, de
	ld a, (hl)
	cp #TILE_TYPE_FATAL_OR_SOLID
	ret nz ; horiz_ff_colision_NOT_detected

_horiz_ff_colision_detected :
  ld a, #BOOL_TRUE
	ld (#_cFFFlagColision), a
	ret

_not_NextM :
	; not Next map - check for solid colision (horizontal ForceField)
	call _check_for_horiz_ff_colision
	ld a, (#_cFFFlagColision)
	cp #BOOL_FALSE
	jr z, _continue_no_ff_colision
	ld hl, #_cGlbPlyFlag
	set 0, (hl); COLISION_FATAL

_continue_no_ff_colision :
	; check if player has reached the floor
	; based on X foot position, we need to test 1 or 2 tiles below the player to detect empty floor
	call _chkFootTileQtty  ; B = 1 or 2 horizontal tiles to test
	ld c, #0 + #6
	ld d, #16; 1 row below the player
	call _calcTileXYAddr
	ld a, (hl)
	bit #7, a; test if bit 7 (SOLID BIT) is set
	jp nz, _flSolid ; solid detected - stop falling
	; empty floor, first tile
	ex de, hl
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyMoved), a; player has moved DOWN
	ld l, a  ; continue falling

	dec b
	ret z ; unique tile is blank - continue falling, no need to test a second tile
	ex de, hl
	inc hl
	ld a, (hl)
	bit #7, a; test if bit 7 (SOLID BIT) is set
	jp nz, _flSolid_ex ; solid detected - stop falling and reset _bGlbPlyMoved
	; empty floor second tile - continue falling
	ex de, hl ; doing this is = ld l, #BOOL_TRUE - continue falling
__endasm;
}  // bool is_player_falling()

/*
* Check for player jump status, check for player colision Fatal or Next Map/Portal and then update X,Y. Also check for colision with horizontal forcefield
* Returns:	true (1 - player is jumping)
*							cGlbPlyFlag = 76543210
*										        ||||||||
*														|||||||L Fatal * (fatal tile or horizontal forcefield colision)
*														||||||L- Solid
*														|||||L-- Gate
*														||||L--- Empty floor
*														|||L---- Special floor (belt)
*														||L----- Next map/Portal *
*														|L------ Object
*														L------- Interactive
*					    cGlbObjData = shift direction + screen destination when Next Map/Portal detected
*						false (0 - player is not jumping)
*							sThePlayer.status = PLYR_STATUS_STAND (if player stop jumping)
*/
bool is_player_jumping()
{
__asm
	ld a, (#_sThePlayer + #03); A = _sThePlayer.status
	ld l, #BOOL_FALSE ; false - not jumping
	cp #PLYR_STATUS_JUMPING
	ret nz ; not jumping

	call _check_for_horiz_ff_colision

	xor a
	ld (#_cGlbPlyFlag), a; reset _cGlbPlyFlag
	; calculate the new expected X,Y position for the player
	ld hl, #_cPlyNewY
	ld a, (#_sThePlayer + #01) ; Y
	ld (hl), a
	ld a, (#_cGlbPlyJumpStage)
	ld c, a
	cp #PLYR_JUMP_STAGE_UP
	jr z, _stage_up
	;;change here to implement jump LUT
	inc (hl)
	jr _calc_x
_stage_up :
	;; change here to implement jump LUT
	dec (hl)
_calc_x :

	;; change here to implement jump LUT
	; to be implemented - if not moved, no need to check new position (but need to check for fatal)

	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a ; player trying to move DOWN/UP

	ld d, (hl) ; D = _cPlyNewY
	ld a, (#_cGlbPlyJumpDirection)
	ld b, a
	ld hl, #_cPlyNewX
	ld a, (#_sThePlayer) ; X
	ld (hl), a
	ld	a, (#_cCtrlCmd)
	bit 3, a; UBOX_MSX_CTL_RIGHT ?
	jr nz, _dir_right
	bit 2, a; UBOX_MSX_CTL_LEFT ?
	jr nz, _dir_left
	ld e, #PLYR_JUMP_DIR_NONE
	jr _try_move
_dir_right :
	ld a, b
	cp #PLYR_JUMP_DIR_LEFT
	jr z, _try_move
	ld a, (hl) ; A = _sThePlayer.x
	; first check for next map colision
	cp #256 - #4 - #8
	jp z, _do_next_map_right
	; not moving to next map
	inc (hl)
	
	ld a, #PLYR_JUMP_DIR_RIGHT
	ld e, a
	ld (#_cGlbPlyJumpDirection), a
	ld a, #PLYR_SPRT_DIR_RIGHT
	ld (#_sThePlayer + #2), a	; _sThePlayer.dir = PLYR_SPRT_DIR_RIGHT
	jr _try_move
_dir_left :
	ld a, b
	cp #PLYR_JUMP_DIR_RIGHT
	jr z, _try_move
	; first check for next map colision
	ld a, (hl); A = _sThePlayer.x
	or a
	jp z, _do_next_map_left
	; not moving to next map
	dec (hl)

	ld a, #PLYR_JUMP_DIR_LEFT
	ld e, a
	ld (#_cGlbPlyJumpDirection), a
	ld a, #PLYR_SPRT_DIR_LEFT
	ld (#_sThePlayer + #2), a; _sThePlayer.dir = PLYR_SPRT_DIR_LEFT

_try_move :
  ; start trying to move the player - check all possible options
	ld a, e
	ld (#_cGlbPlyJumpDirCmd), a
	; Now we know the new expected X and Y (_cPlyNewX, _cPlyNewY). Check for a valid position and update _cPlyNewX, _cPlyNewY accordly
	call _chkBodyTileQtty ; E = _cPlyNewX, B = 1 or 2 horizontal tiles to test
	push de ; _cPlyNewY / _cPlyNewX
	push bc ; # tiles to test / _cGlbPlyJumpStage
	xor a
  ld (#_cFatalFlag), a
	ld (#_cPortalFlag), a
	call _test_jump_position
	pop bc
	pop de
	or a
	jr nz, _jmp_moved_ok

	; position is not valid. Rollback Y and test again  
	ld a, (#_sThePlayer + #01)
	ld d, a
	push de
	push bc
	xor a
	ld (#_cFatalFlag), a
	ld (#_cPortalFlag), a
	call _test_jump_position
	pop bc
	pop de
	or a
	jr nz, _jmp_moved_ok_step2

	; position still not valid. Rollback X and test again
	ld a, (#_cPlyNewY)
	ld d, a
	ld a, (#_sThePlayer)
	call _chkBodyTileQtty_ex
	push de
	push bc
	xor a
	ld (#_cFatalFlag), a
	ld (#_cPortalFlag), a
	call _test_jump_position
	pop bc
	pop de
	or a
	jr nz, _jmp_moved_ok

	; no positions are valid. Rollback X an Y and proceed
	ld a, (#_sThePlayer + #01)
	ld d, a

_jmp_moved_ok_step2 :
	; if jumping down, solid tile found in the ground. Stop jumping
	ld a, c; A = _cGlbPlyJumpStage
	cp #PLYR_JUMP_STAGE_UP
	jr z, _jmp_moved_ok
	call _set_moved_ok
	ld hl, #_sThePlayer + #03; HL = &_sThePlayer.status
	ld(hl), #PLYR_STATUS_STAND
	ld l, #BOOL_FALSE ; false - not jumping anymore
	ret

_set_moved_ok :
	; DE = valid(Y, X) position
	ld hl, #_sThePlayer
	ld (hl), e ; X
	inc hl
	ld (hl), d ; Y
	ld hl, #_cGlbPlyFlag

	ld a, (#_cFFFlagColision)
	ld b, a
	ld a, (#_cFatalFlag)
	or b
	or a
	jr nz, _set_fatal_found
	ld a, (#_cPortalFlag)
	or a
	ret z
	set 5, (hl)  ; COLISION_NEXTM
	ret
_set_fatal_found :
	; fatal found
	set 0, (hl)  ; COLISION_FATAL
	ret

_jmp_moved_ok :
	call _set_moved_ok
	; update Jump Stage
	ld a, c ; A = _cGlbPlyJumpStage
	cp #PLYR_JUMP_STAGE_DOWN
	jr nz, _dec_up_cycles
	; jumping down - check if player moved down next map
	ld a, d; A = updated _sThePlayer.y
	; check for next map when falling
	cp #22 * #8
	ld l, #BOOL_TRUE; continue jumping
	ret c
	jp _do_nextm_down

_dec_up_cycles :
	ld hl, #_cGlbPlyJumpCycles
	dec (hl)
	jr z, _endUpStage
	ld l, #BOOL_TRUE ; continue jumping
	ret
_endUpStage :
	ld hl, #_cGlbPlyJumpStage
	ld(hl), #PLYR_JUMP_STAGE_DOWN
	ld l, #BOOL_TRUE ; continue jumping
	ret

_do_next_map_left :
	ld a, (#_cScreenMap)
	dec a
	or #SCR_SHIFT_RIGHT << #5
	jr _do_next_map
_do_next_map_right :
	ld a, (#_cScreenMap)
	inc a
	or #SCR_SHIFT_LEFT << #5
_do_next_map :
	; need to return cGlbObjData
	ld (_cGlbObjData), a; (sssDDDDD)
	ld hl, #_cGlbPlyFlag
	set 5, (hl)  ; COLISION_NEXTM
	ld l, #BOOL_TRUE ; continue jumping
	ret

; Check the horizontal # of tiles to test when detect colision in the player body
; if (Player.X + 4) % 8 = 0, then just need to test 1 single tile, otherwise must test 2 horizontal tiles
;	Input: HL = &_cPlyNewX
; Output: E = X, B = 1 or 2 tiles
; Changes: A, B, E
_chkBodyTileQtty :
	ld a, (hl)
;	Input: A = Player X position
_chkBodyTileQtty_ex :
	ld e, a; E = X
_chkBodyTileQtty_ex_2 :
	add a, #04; A = _cPlyNewX + 4
	ld b, #01; 1 Tile to test
	and #0b00000111
	ret z
	inc b; 2 Tiles to test
	ret

; Input: B = # of horizontal tiles to test
;				 C = _cGlbPlyJumpStage (PLYR_JUMP_STAGE_UP / PLYR_JUMP_STAGE_DOWN)
;				 D = tentative Y position
;				 E = tentative X position
; Output: A = BOOL_FALSE (0 - invalid position) / BOOL_TRUE (1 - valid position)
; Changes: A, B, C, D, E, H, L
_test_jump_position :
	; Stage UP or DOWN?
	ld a, c ; C = _cGlbPlyJumpStage
	cp #PLYR_JUMP_STAGE_UP
	ld a, d; A = _sThePlayer.y +- 1
	jp z, _jump_up_validation
	; Start Jump DOWN validation
	add a, #15 ; bottom player pixel

_jump_up_validation :
	; Start Jump UP validation
	push bc
	ld c, e ; C = _sThePlayer.x + / -1
	inc c
	inc c
	inc c
	inc c
	push de	; protect D from _calcTileXYAddrGeneric
	call _calcTileXYAddrGeneric
	pop de
	push hl
_test_solid_up :
	ld a, (hl)
	bit 5, a  ; FATAL BIT
	jp nz, _jmpFoundFatal_01
	cp #TILE_TYPE_PORTAL
	jp z, _jmpFoundPortal_01

	; its not fatal nor portal, so test if Solid...
	; ...but if cFFFlagColision = true, check for a SOLID_COLISION <> TILE_TYPE_FATAL_OR_SOLID. If found then do not move
	bit 7, a ; SOLID BIT
	; no solid colision detected, check next tile
	jr z, _jmpNextSearch_01
	; there is a solid colision, need to check if real or not
	ld a, (#_cFFFlagColision)
	cp #BOOL_TRUE
	jp nz, _up_invalid_01
	ld a, (hl)
	cp #TILE_TYPE_FATAL_OR_SOLID
	; no real solid colision detected, check next tile
	jr z, _jmpNextSearch_01

	; solid colision - cannot move
	jr _up_invalid_01

_jmpFoundPortal_01 :
	; cGlbObjData = shift direction + screen destination
	push hl
	push de
  ; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld a, (hl); screen destination(0000DDDD)
	or #SCR_SHIFT_PORTAL << #5
	ld (#_cPortalFlag), a
	ld (#_cGlbObjData), a; (sss0DDDD)
	pop de
	pop hl
	jr _jmpNextSearch_01

_jmpFoundFatal_01 :
	ld a, #BOOL_TRUE
	ld (#_cFatalFlag), a
_jmpNextSearch_01 :
	inc hl; next tile
	djnz _test_solid_up
	; top or bottom tiles are valid. Now check for the lateral tiles
	pop hl
	pop bc
	ld a, #BOOL_TRUE
	dec b
	ret z ; just 1 horizontal tile, no lateral test necessary

	ld a, (#_cGlbPlyJumpDirCmd)
	ld b, a
	cp #PLYR_JUMP_DIR_NONE
	ld a, #BOOL_TRUE
	ret z	; jumping vertically - no lateral test necessary
	ld a, b
	cp #PLYR_SPRT_DIR_LEFT
	jr z, _test_lat_tiles
	; test for right lateral tiles
	inc hl
_test_lat_tiles :
	; test for lateral tiles
	; if Y % 8 = 0, then just need to test just 1 additional tile, otherwise must test 2 additional vertical tiles
	ld b, #01; 1 Tile to test
	ld a, d
	and #0b00000111
	jr z, _start_vert_validate
	inc b; 2 Tiles to test
_start_vert_validate :
	ld de, #32
	ld a, c; C = _cGlbPlyJumpStage
	cp #PLYR_JUMP_STAGE_UP
	jr z, _dec_hl_row
	xor a
	sbc hl, de
	jr _vert_validate
_dec_hl_row :
	add hl, de
_vert_validate :
	ld a, (hl)
	bit 5, a  ; FATAL BIT
	jp nz, _jmpFoundFatal_02
	cp #TILE_TYPE_PORTAL
	jp z, _jmpFoundPortal_02

	; its not fatal nor portal, so test if Solid...
	; ...but if cFFFlagColision = true, check for a SOLID_COLISION <> TILE_TYPE_FATAL_OR_SOLID.If found then do not move
	bit 7, a; SOLID BIT
	; no solid colision detected, check next tile
	jr z, _jmpNextSearch_02
	; there is a solid colision, need to check if real or not
	ld a, (#_cFFFlagColision)
	cp #BOOL_TRUE
	jr nz, _up_invalid_02
	ld a, (hl)
	cp #TILE_TYPE_FATAL_OR_SOLID
	; no real solid colision detected, check next tile
	jr z, _jmpNextSearch_02

	; solid colision - cannot move
	jr _up_invalid_02

_jmpFoundPortal_02 :
	; cGlbObjData = shift direction + screen destination
	push hl
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld a, (hl); screen destination(0000DDDD)
	or #SCR_SHIFT_PORTAL << #5
	ld (#_cPortalFlag), a
	ld (#_cGlbObjData), a; (sss0DDDD)
	pop hl
	jr _jmpNextSearch_02

_jmpFoundFatal_02 :
	ld a, #BOOL_TRUE
	ld (#_cFatalFlag), a
_jmpNextSearch_02 :
	djnz _start_vert_validate
	ld a, #BOOL_TRUE
	ret

_up_invalid_01 :
	pop hl
	pop bc
_up_invalid_02 :
	xor a ; BOOL_FALSE
__endasm;
}  // bool is_player_jumping()

/*
* Get the ObjectID from 'cGlbTile' and remove it from the map at 'iGlbPosition' VRAM position
*/
void player_get_object()
{
__asm
	; first need to discover which object is this
	ld hl, #_cPlyObjects
	ld d, #SCORE_OBJ_TL_OFFSET ; index for the first object tile in the tileset
	ld a, (#_cGlbTile); object tile on the screen
	sub d
	jp z, _itsaBattery
	dec a
	jp z, _itsaAmno
	dec a
	jr z, _itsaKey
	dec a
	jr z, _itsYCard
	dec a
	jr z, _itsGCard
	dec a
	jr z, _itsRCard
	dec a
	jp z, _itsaTool
	dec a
	jp z, _itsaMap
	dec a
	jp z, _itsaScrew
	dec a
	jp z, _itsaKnife
	dec a
	jp z, _itsaFlashLight
	dec a
	jp z, _itsaGun
	dec a
	jp z, _itsPower
	dec a
	jp z, _itsaShield
	dec a
	jp z, _itsaLife
	jp _clearTile_none ; unknown object

_itsaKey :
	set 0, (hl) ; HAS_OBJECT_KEY
	ld hl, #_cRemainKey
	jp _displayObjs_ex

_itsYCard :
	set 1, (hl) ; HAS_OBJECT_YELLOW_CARD
	call _upd_card_pts
	ld a, (#_cRemainYellowCard)
	add a, #YELLOW_CARD_PTS
	add a, l
	ld (#_cRemainYellowCard), a
	jp _displayObjs

_itsGCard :
	set 2, (hl) ; HAS_OBJECT_GREEN_CARD
	call _upd_card_pts
	ld a, (#_cRemainGreenCard)
	add a, #GREEN_CARD_PTS
	add a, l
	ld (#_cRemainGreenCard), a
	jp _displayObjs

_itsRCard :
	set 3, (hl) ; HAS_OBJECT_RED_CARD
	call _upd_card_pts
	ld a, (#_cRemainRedCard)
	add a, #RED_CARD_PTS
	add a, l
	ld (#_cRemainRedCard), a
	jr _displayObjs
		
_itsaTool :
	set 4, (hl) ; HAS_OBJECT_TOOL
	jr _displayObjs

_itsaMap :
	set 5, (hl) ; HAS_OBJECT_MAP
	call _display_minimap
	jr _displayObjs

_itsaScrew :
	set 6, (hl) ; HAS_OBJECT_SCREW
	ld hl, #_cRemainScrewdriver
	jr _displayObjs_ex

_itsaFlashLight :
	ld hl, #_cPlyAddtObjects
	set 1, (hl)
_itsaBattery :
	ld hl, #_cPlyRemainFlashlight
	ld a, #FLASHLIGHT_BATTR_PTS
	add a, (hl)
	cp #MAX_AMNO_SHIELD
	jr c, _batt_ok
	ld a, #MAX_AMNO_SHIELD
_batt_ok :
	ld (hl), a
	call _display_flashlight
	jr _clearTile

_itsaGun :
	ld hl, #_cPlyAddtObjects
	set 0, (hl)
	; ubox_put_tile(13, 2, SCORE_GUN_TL_OFFSET);
	ld a, #SCORE_GUN_TL_OFFSET
	ld bc, #0x020d
	call _put_tile_asm_direct
	ld a, #GUN_AMNO_PTS
	jr _itsaAmno_ex

_itsaAmno :
	ld a, #AMNO_AMNO_PTS
_itsaAmno_ex :
	ld hl, #_cPlyRemainAmno
	add a, (hl)
	cp #MAX_AMNO_SHIELD
	jr c, _amno_ok
	ld a, #MAX_AMNO_SHIELD
_amno_ok :
	ld(hl), a
	call _display_gun_amno
	jr _clearTile

_itsPower :
	ld	a, #HEALTH_PACK_PTS
	push	af
	inc	sp
	call	_increase_power ; increase_power(HEALTH_PACK_PTS);
	inc	sp
	jr _clearTile

_itsaShield :
	ld hl, #_cPlyRemainShield
	ld a, #SHIELD_PTS
	add a, (hl)
	ld (hl), a
	cp #MAX_AMNO_SHIELD
	jr c, _shield_ok
	ld a, #MAX_AMNO_SHIELD
_shield_ok :
	call _display_shield
	jr _clearTile

_itsaLife :
	ld a, (#_cLives)
	cp #MAX_LIVES
	jr nc, _clearTile
	inc a
	ld (#_cLives), a
	call _display_lives
	jr _clearTile

_itsaKnife :
	set 7, (hl) ; HAS_OBJECT_KNIFE
	ld hl, #_cRemainKnife

_displayObjs_ex :
	inc (hl)
_displayObjs :
	call _display_objects

_clearTile :
	; mplayer_play_effect_p(SFX_GET_OBJECT, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0002; 00 + SFX_GET_OBJECT
	call	_mplayer_play_effect_p_asm_direct
_clearTile_none :

	; remove the Object Tile from the screen
	; if LIGHT_SCENE_OFF_FL_OFF, no need to display animated tiles (no need to update VRAM)
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_OFF
	jr z, _after_clear

	; if LIGHT_SCENE_OFF_FL_ON, need to check if tile at VRAM addreess <> BLACK_TILE before updating
	ld hl, (#_iGlbPosition)
	ld de, #UBOX_MSX_NAMTBL_ADDR
	add hl, de; HL = VRAM_NAME_TBL + cY * 32 + cX
	cp #LIGHT_SCENE_OFF_FL_ON
	jr nz, _do_clear_obj	
	call #0x0050; SETRD - Enable VDP to read(HL)
	in a, (#0x98)
	cp #BLACK_TILE
	jr z, _after_clear

_do_clear_obj :
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)
	xor a
	out (#0x98), a; write to VRAM

_after_clear :
	ld hl, (#_iGlbPosition)
	ld de, #_cMap_Data - (#03 * #32)
	add hl, de
	ld (hl), a; cMap_Data[HL] = BLANK_TILE

	; update cMap_TileClass[]
	ld hl, (#_iGlbPosition)
	ld de, #_cMap_TileClass - (#03 * #32)
	add hl, de
	ld (hl), a ; cMap_TileClass[HL] = TILE_TYPE_BLANK

	; reset _cGlbPlyFlagCache object colision flag to avoid double execution
	ld a, #CACHE_INVALID
	ld (#_cGlbPlyFlagCache), a; invalidate _cGlbPlyFlagCache

	xor a ; Tile = 0
	call _insert_new_obj_history
	ret

_upd_card_pts :
	call _randombyte
	ld a, l
	ld l, #1
	cp #80
	ret c
	inc l
	cp #160
	ret c
	inc l
	cp #210
	ret c
	inc l
	ret
__endasm;
}  // void player_get_object()

/*
* Check for player request to die and arise in a safe place. Set Power = 0 when user confirms
*/
void check_for_player_arise()
{
__asm
	ld	l, #0x07
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_ESC
	ret	nz

	; pressed ESC key - enable Pause
	; print "ARISE?"
	; put_tile_block(16, 0, SCORE_POWER_TILE, 3, 1);
	ld a, #SCORE_ARISE_TL_OFFSET
	call _txt_prt

_wait_for_YN :
	ld	l, #0x05
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_Y
	jr z, _do_arise
	ld	l, #0x04
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_N
	jp nz, _wait_for_YN
	; Pressed 'N'
	; erase "ARISE?"
	call _txt_erase
	ret

_do_arise :
	; erase "ARISE?"
	call _txt_erase
	xor a
	ld (#_cPower), a
	jp _set_player_as_dead
__endasm;
}  // void check_for_player_arise()

/*
* Check for player remaining power and life. Decrease Life when Power = 0
* Set cGameStatus = GM_STATUS_LOOP_CONTINUE (default) or GM_STATUS_MISSION_CPLT, GM_STATUS_PLAYER_WIN or GM_STATUS_GAME_OVER
*/
void update_game_loop_status()
{
__asm
	ld a, (#_cRemainMission)
	or a
	jr nz, _mission_not_completed
	; all missions completed - level UP -OR- game win
	ld a, (#_cLevel)
	cp #3
	jr nz, _do_complete_mission
	; cLevel=3 and cRemainMission=0 - GAME WIN
	ld a, #GM_STATUS_PLAYER_WIN
	jr _do_game_win
_do_complete_mission :
	ld a, #GM_STATUS_MISSION_CPLT
_do_game_win :
	ld (#_cGameStatus), a
	ret

_mission_not_completed :
	ld a, (#_cPlyDeadTimer)
	or a
	jr z, _check_power
	dec a
	ret nz ; there are some cycles for Dead Player animation
	ld (#_cPlyDeadTimer), a
	jr _check_lives

_check_power :
	ld a, (#_cPower)
	or a
	ret nz
_set_player_as_dead :
	; _cPower = 0. Set PLYR_STATUS_DEAD and start dead animation timer
	ld hl, #_cPlyDeadTimer
	ld (hl), #DEAD_ANIM_TIMER
	ld hl, #_sThePlayer + #03  ; status
	ld (hl), #PLYR_STATUS_DEAD
	ld hl, #_sThePlayer + #06 ; frame
	ld (hl), #0
	ld a, (#_sThePlayer + #09) ; grabflag
	cp #BOOL_TRUE
	call z, _set_grabbed_enemy_as_dead

_cont_dead_player :
	; mplayer_play_effect_p(SFX_DEADPLAYER, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x000E; 00 + SFX_DEADPLAYER
	call	_mplayer_play_effect_p_asm_direct
	ret

_set_grabbed_enemy_as_dead :
	push ix
	ld ix, (#_sGrabbedEnemyPtr)
_set_grabbed_enemy_as_dead_ex :
	ld 3 (ix), #ENEMY_STATUS_HURT ; enemy status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY
	pop ix
	ret

_check_lives :
	ld a, (#_cLives)
	dec a
	ld (#_cLives), a
	jr nz, _start_with_new_life
	ld a, #GM_STATUS_GAME_OVER
	ld (#_cGameStatus), a
	ret
	
_start_with_new_life :
	; there are still some remaining lives
	ld a, #MAX_POWER
	ld (#_cPower), a
	call _display_power
	call _display_lives
	; set player status and position
	ld hl, #_cGlbPlyFlagCache
	ld(hl), #CACHE_INVALID
	ld hl, #_sThePlayer
	ld a, (#_cPlySafePlaceX)
	ld (hl), a
	inc hl
	ld a, (#_cPlySafePlaceY)
	ld (hl), a
	inc hl
	ld a, (#_cPlySafePlaceDir)
	ld (hl), a; _sThePlayer.dir = _cPlySafePlaceDir
	inc hl
	ld (hl), #PLYR_STATUS_STAND; _sThePlayer.status = PLYR_STATUS_STAND

	xor a
	ld (#_sThePlayer + #6), a ; frame = 0
	; A already set to 0
	;ld a, #BOOL_FALSE
	ld (#_sThePlayer + #9), a ; grabflag = false
	ld a, #BOOL_TRUE
	ld (#_bGlbPlyChangedPosition), a
__endasm;
}  // void update_game_loop_status()

/*
* Auxiliary routine to update player status and reset some internal flags
*/
void update_player_status(uint8_t cNewStatus)
{
__asm
	ld hl, #2
	add hl, sp
	ld a, (hl) ; A = _cNewStatus
	cp #PLYR_STATUS_FALLING
	jr z, _sttFall
	cp #PLYR_STATUS_CLIMB_DOWN
	jr z, _sttClbDown
	cp #PLYR_STATUS_CLIMB_UP
	jr z, _sttClbUp
	cp #PLYR_STATUS_JUMPING
	jr z, _sttJump
	cp #PLYR_STATUS_DEAD
	jp z, _set_player_as_dead
	jr _setStatus

_sttJump :
	ld hl, #_cGlbPlyJumpCycles
	ld (hl), #PLYR_UP_JUMP_CYCLES
	ld hl, #_cGlbPlyJumpStage
	ld (hl), #PLYR_JUMP_STAGE_UP

	; if Player status = STAND, direction = NONE
	ld hl, #_cGlbPlyJumpDirection
	ld d, a
	ld a, (#_sThePlayer + #03) ; status
	cp #PLYR_STATUS_STAND
	ld a, #PLYR_JUMP_DIR_NONE
	jr z, _set_jmp_none
	ld a, (#_sThePlayer + #02) ; dir
	xor #1
	inc a ; HUGE workaroud to convert player dir => jump dir
_set_jmp_none :
  ld (hl), a
	jr _setStatus2

_sttClbDown :
	ld a, (#_sThePlayer + #01)
	add a, #8
	jr _sttClimb
_sttClbUp :
	ld a, (#_sThePlayer + #01)
	dec a
	dec a
_sttClimb :
	ld(#_sThePlayer + #01), a
	ld d, #PLYR_STATUS_CLIMB
	jr _sttFall2

_sttFall :
	; adjust _sThePlayer.x to the right position when start falling
	ld d,a
_sttFall2 :
	ld a, (#_cGlbObjData) ; _cGlbObjData = 1 or 2 empty tiles
	dec a
	jp nz, _setStatus2 ; 2 - no need to adjust
	ld a, (#_sThePlayer)
	ld b, a
	add a, #6
	and #0b00000111
	ld c, a
	ld a, b
	inc a
	inc a
	sub c
	ld (#_sThePlayer), a
_setStatus2 :
	ld a,d
_setStatus :
	ld hl, #_sThePlayer + #03
	ld (hl),a ; _sThePlayer.status = _cNewStatus
	ld hl, #_sThePlayer + #06
	xor a
	ld(hl), a ; _sThePlayer.frame = 0
	inc hl
	ld(hl), a ; _sThePlayer.delay = 0
	ld a, #CACHE_INVALID
	ld(#_cGlbPlyFlagCache), a ; invalidate _cGlbPlyFlagCache
__endasm;
} // void update_player_status()

/*
* Activate the player sprite based on player status
*/
void display_player()
{
__asm
  ld a, (#_cPlyDeadTimer)
	or a
	jr z, _continue_display_player
	; dead player animation
	dec a
	ld (#_cPlyDeadTimer), a
	; set player pattern when dead
	ld a, (#_sThePlayer + #06)  ; _sThePlayer.frame
	cp #PLYR_DEAD_CYCLE
	jr nz, _set_player_dead_pattern_ini
	xor a
_set_player_dead_pattern_ini :
	ld b, #0
	ld c, a
	ld hl, #_ply_dead_pat_frames
	add hl, bc
	inc a
	ld (#_sThePlayer + #06), a  ; _sThePlayer.frame
	ld a, (hl)
	ld (#_sGlbSpAttr + #02), a  ; _sGlbSpAttr.pattern
	jp _updPlyrAttr

_continue_display_player :
	ld a,(#_sThePlayer + #03) ; A = _sThePlayer.status
	cp #PLYR_STATUS_JUMPING
	jp nz, _chkFall
	ld a, (#_cGlbPlyJumpDirection)
	cp #PLYR_JUMP_DIR_NONE
	jp nz, _patJmpDir
	ld hl, #_PLYR_PAT_FALL_IDX
	ld a, (#_cGlbPlyJumpStage)
	cp #PLYR_JUMP_STAGE_DOWN
	jp nz, _jmpStDown
	xor a
	jp _updtAttr2
_jmpStDown :	
	ld a, #08	; PLYR_JUMP_STAGE_UP
	jp _updtAttr2	
_patJmpDir :
	ld hl, #_PLYR_PAT_JUMP_IDX
	ld a, (#_sThePlayer + #02); A = _sThePlayer.dir
	jp _updtAttr
	
_chkFall :
	cp #PLYR_STATUS_FALLING
	jp nz, _chkClimb
	ld hl, #_sThePlayer + #07; HL = &_sThePlayer.delay
	ld a, (hl)
	inc(hl)
	cp #PLAYER_ANIM_DELAY ;  sThePlayer.delay++ == 3 ?
	jp nz, _patFall
	ld(hl), #00; _sThePlayer.delay = 0
	ld a, (#_sThePlayer + #06); A = _sThePlayer.frame
	inc a
	and #0b00000001
	ld (#_sThePlayer + #06), a
	jr _patFall2
_patFall :
	ld a, (#_sThePlayer + #06); A = _sThePlayer.frame
_patFall2 :
	ld hl, #_PLYR_PAT_FALL_IDX
	jr _updtAttr

_chkClimb :
	cp #PLYR_STATUS_CLIMB
	jp nz, _iamWalking
	; check if player has moved
	ld a, (#_bGlbPlyMoved)
	or a
	jp z, _patClimb; player has not moved
	ld hl, #_sThePlayer + #07; HL = &_sThePlayer.delay
	ld a, (hl)
	inc(hl)
	cp #PLAYER_ANIM_DELAY ; sThePlayer.delay++ == 3 ?
	jp nz, _patClimb
	ld(hl), #00; _sThePlayer.delay = 0
	ld a, (#_sThePlayer + #06); A = _sThePlayer.frame
	inc a
	and #0b00000001
	ld(#_sThePlayer + #06), a
	jr _patClimb2
_patClimb :
	ld a, (#_sThePlayer + #06); A = _sThePlayer.frame
_patClimb2 :
	ld hl, #_PLYR_PAT_CLIMB_IDX
	jr _updtAttr

_iamWalking : ; PLYR_STATUS_STAND or PLYR_STATUS_WALKING
	; check if player has moved
	ld a, (#_bGlbPlyMoved)
	or a
	jp z, _patWalk ; player has not moved
	; update the walking animation
	ld hl, #_sThePlayer + #07 ; HL = &_sThePlayer.delay
	ld a, (hl)
	inc (hl)
	cp #PLAYER_ANIM_DELAY ;  sThePlayer.delay++ == 3 ?
	jp nz, _patWalk
	ld hl, #_sThePlayer + #06 ; HL = &_sThePlayer.frame
	inc (hl)
	ld a, (hl)
	cp #PLYR_WALK_CYCLE
	jp z, _patWalk3
	jr _patWalk2
_patWalk3 :
	ld (hl), #0; _sThePlayer.frame = 0
_patWalk2 :
	inc hl
	ld(hl), #0; _sThePlayer.delay = 0
_patWalk :
	; find which pattern to show
	ld a, (#_sThePlayer + #02); A = _sThePlayer.dir
	ld b, a
	add a, a
	add a, b; A = _sThePlayer.dir * 3
	ld hl, #_sThePlayer + #06; _sThePlayer.frame
	ld c, (hl)
	ld b, #0
	ld hl, #_ply_walk_frames
	add hl, bc; HL = &_walk_frames[sThePlayer.frame]
	add a, (hl); A = (walk_frames[sThePlayer.frame] + sThePlayer.dir * 3)
	ld hl, #_PLYR_PAT_WALK_IDX; _sThePlayer.pat
_updtAttr :
	add a, a
	add a, a
	add a, a; A = (walk_frames[sThePlayer.frame] + sThePlayer.dir * 3) * 8
_updtAttr2 :
	add a, (hl)	; A = sThePlayer.pat + (walk_frames[sThePlayer.frame] + sThePlayer.dir * 3) * 8;
	ld (#_sGlbSpAttr + #02), a; _sGlbSpAttr.pattern

_updPlyrAttr :
	ld de, #_sThePlayer + #01
	ld hl, #_sGlbSpAttr
	push hl ; used at _spman_alloc_fixed_sprite() calls
	ld a, (de)
	dec a  ; y on the screen starts in 255
	ld (hl), a	; _sGlbSpAttr.y
	inc hl
	dec de
	ld a, (de)
	ld (hl), a ; _sGlbSpAttr.x
	; _sGlbSpAttr.pattern already set
	
	ld a, (#_cPlyDeadTimer)
	or a
	jr z, _chk_hit_timer
	ld a, #PLYR_SPRITE_L1_COLOR_DEAD
	jr _player_was_hit

_chk_hit_timer :
	ld a, (#_cPlyHitTimer)
	or a
	jr z, _chk_for_hit
	; player was hit - change player colors
	dec a
	ld (#_cPlyHitTimer), a
	jr nz, _set_hit_color
	; reset hitflag
	xor a
	ld (#_sThePlayer + #4), a; player.hitflag = FALSE
_set_hit_color :
	ld a, #PLYR_SPRITE_L1_COLOR_HIT
	jr _player_was_hit

_chk_for_hit :
  ld a, (#_sThePlayer + #4)  ; A = player.hitflag
	cp #BOOL_TRUE
	jr nz, _player_not_hit
	ld a, #HIT_ANIM_TIMER
	ld (#_cPlyHitTimer), a
	; decrease_power
	ld a, (#_cGlbPlyHitCount)
	ld b, a
	ld a, (#_cPower)
	sub b
	jr nc, _updt_power
	xor a
_updt_power :
	ld (#_cPower), a
	call _display_power
	; mplayer_play_effect_p(SFX_HURT, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0005; 00 + SFX_HURT
	call	_mplayer_play_effect_p_asm_direct
	ld a, #PLYR_SPRITE_L1_COLOR_HIT
	jr _player_was_hit

_player_not_hit :
	; change player color if SceneLight = OFF and FlashLight = OFF
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_OFF
	ld a, #PLYR_SPRITE_L1_COLOR_DARK
	jr z, _do_player_display
	ld a, (#_cLevel)
	cp #1 ; Ash
	jr nz, _player_level_2or3
	ld a, #PLYR_SPRITE_L1_COLOR_NORMAL
	jr _do_player_display
_player_level_2or3 :
	ld a, #PLYR_SPRITE_L2_COLOR_NORMAL

_player_was_hit :
_do_player_display :
	ld (#_cGlbPlyColor), a
	and #0b00001111
	ld (#_sGlbSpAttr + #03), a	; _sGlbSpAttr.attr = PLYR_SPRITE_Ln_COLOR low nibble
	; allocate the player sprites; main sprite fixed so they never flicker
	call	_spman_alloc_fixed_sprite
	; second one is 4 patterns away (16x16 sprites)
	ld a, (#_sGlbSpAttr + #02)
	add a, #04
	ld (#_sGlbSpAttr + #02), a	; _sGlbSpAttr.pattern+=4
	ld a, (#_cGlbPlyColor)
	rra
	rra
	rra
	rra
	and #0b0001111
	ld (#_sGlbSpAttr + #03), a  ; _sGlbSpAttr.attr = PLYR_SPRITE_Ln_COLOR high nibble
	; second player sprite can flicker, thus enabling other sprites to be shown in certain circunstances (2 player + enemy killed + enemy walking + shield)
	call	_spman_alloc_sprite
	pop	af
__endasm;
} // void display_player()


/*
* Move Alien creature right/left (also check for Flashlight effect)
*/
void display_alien_at_screen()
{
__asm
  ld b, #3 ; 3 rows to go
  ld c, #TS_SCORE_SIZE + #GAME_ALIEN_TL_OFFSET - #1 ; first Alien tile
  ld hl, (#_sAlien + #11); iPosition

  ld a, (#_sAlien + #2) ; dir
	cp #ENEMY_SPRT_DIR_LEFT
	jr z, _move_alien_tiles_left
	; move Alien tiles to the right: 3 x (BLANK + 4 x Alien Tiles)
	dec hl
	ld d, #5 ; first tile is blank
_start_alien_move :
	ld (#_iGlbPosition), hl

_move_alien_loop_1 :
	push bc
	ld b, #5 ; 5 columns to go
_move_alien_loop_2 :
	ld a, d
	cp b
	jr nz, _not_blank_tile_right
	; tile is blank
	push bc
	; ld b, #TILE_TYPE_BLANK
	; ld c, #BLANK_TILE
	ld bc, #0x0000
	jr _continue_display_alien_tile
_not_blank_tile_right :
	inc c
	push bc
	ld b, #TILE_TYPE_ALIEN
_continue_display_alien_tile :
	push de ; protect D and E
	call _display_alien_single_tile
	pop de
	ld hl, #_iGlbPosition
	inc (hl)
	pop bc
	djnz _move_alien_loop_2
	ld a, c
	ld bc, #27
	ld hl, (#_iGlbPosition)
	add hl, bc
	ld (#_iGlbPosition), hl
	pop bc
	ld c, a
	djnz _move_alien_loop_1

  ld a, (#_sAlien + #0) ; x
  ld (#_sAlien + #9), a ; last_x
  ret

_move_alien_tiles_left :
	; move Alien tiles to the left : 3 x (4 x Alien Tiles + BLANK)
	ld d, #1 ; last tile is blank
	jr _start_alien_move

; HL = iPosition
; C = Tile
; B = TileType (TILE_TYPE_BLANK / TILE_TYPE_ALIEN)
_display_alien_single_tile :
  ; if LIGHT_SCENE_OFF_FL_OFF, no need to display animated tiles (no need to update VRAM)
  ld a, (#_cGlbGameSceneLight)
  cp #LIGHT_SCENE_OFF_FL_OFF
  jr z, _upd_alien_map_data

  ; if LIGHT_SCENE_OFF_FL_ON, need to check if tile at VRAM addreess <> BLACK_TILE before updating
  ld hl, (#_iGlbPosition)
  ld de, #UBOX_MSX_NAMTBL_ADDR
  add hl, de  ; HL = VRAM_NAME_TBL + cY * 32 + cX
  cp #LIGHT_SCENE_OFF_FL_ON
  jr nz, _do_update_alien_tile
  call #0x0050 ; SETRD - Enable VDP to read (HL)
  in a, (#0x98)
  cp #BLACK_TILE
  jr z, _upd_alien_map_data

_do_update_alien_tile :
  call #0x0053  ; SETWRT - Sets the VRAM pointer (HL)
	ld a, c
  out (#0x98), a  ; write to VRAM

_upd_alien_map_data :
  ld hl, (#_iGlbPosition)
  ld de, #_cMap_Data - (#03 * #32)
  add hl, de
  ld (hl), c  ; cMap_Data[HL] = Tile

  ; update cMap_TileClass[]
  ld hl, (#_iGlbPosition)
  ld de, #_cMap_TileClass - (#03 * #32)
  add hl, de
  ld (hl), b  ; cMap_TileClass[HL] = TILE_TYPE_xxxx
__endasm;
} // void display_alien_at_screen()


/*
* Update and display the active enemy sprites + Alien
*/
void update_and_display_enemies()
{
__asm
	ld a, (#_sAlien + #10)  ; IsActive
	or a
	jp z, _update_facehug

	; update Alien creature
	; check if its time to update Alien position and image (each ALIEN_ANIM_DELAY cycles), unless status = ALIEN_STATUS_ATTACK
	ld a, (#_sAlien + #5) ; delay
	dec a
	jr z, _do_animate_alien
	ld (#_sAlien + #5), a
	ld a, (#_sAlien + #3) ; status
	cp #ALIEN_STATUS_ATTACK
	jp z, _do_alien_attack
	jp _update_facehug
_do_animate_alien :
  ld a, #ALIEN_ANIM_DELAY
	ld (#_sAlien + #5), a

	ld a, (#_sAlien + #3) ; status
	cp #ENEMY_STATUS_WALKING
	jp nz, _try_alien_chase
	; check if need to move Alien position
	ld a, (#_sAlien + #0) ; X
	ld b, a
	ld a, (#_sAlien + #9) ; last_X
	cp b
	call nz, _display_alien_at_screen
	; display Alien at current position, direction and at current frame - then update both
	call _update_alien_tileset

	ld a, (#_sAlien + #4) ; frame
	or a
	; if frame = 0 no need to move Alien at screen
	jr z, _update_alien_frame

	; detect player proximity from Alien
	call _check_player_Y_aligned_with_alien
	ld a, d
	cp #BOOL_TRUE
	jr nz, _not_vertical_aligned
	; change status to ALIEN_STATUS_CHASE
	ld a, #ALIEN_STATUS_CHASE
	ld (#_sAlien + #3), a ; status
	jp _do_alien_chase

_not_vertical_aligned :
	ld a, (#_sAlien + #2) ; dir
	cp #ENEMY_SPRT_DIR_LEFT
	jr z, _move_alien_left
	; move Alien to the right
	ld a, (#_sAlien + #0) ; X
	inc a
	ld b, a
	add a, #3 ; rightmost tile
	ld c, a
	ld a, (#_sAlien + #8) ; max_X
	cp c
	jr c, _change_alien_dir
	ld a, b
	ld (#_sAlien + #0), a
	ld hl, #_sAlien + #11 ; iPosition
	inc (hl)
	jr _update_alien_frame

_move_alien_left :
	; move Alien to the left
	ld a, (#_sAlien + #7) ; min_X
	ld b, a
	ld a, (#_sAlien + #0) ; X
	dec a
	cp b
	jr c, _change_alien_dir
	ld (#_sAlien + #0), a
	ld hl, #_sAlien + #11 ; iPosition
	dec (hl)
	jr _update_alien_frame

_change_alien_dir :
	ld a, (#_sAlien + #2) ; dir
	xor #1
	ld (#_sAlien + #2), a

_update_alien_frame :
	ld a, (#_sAlien + #4)  ; frame
	xor #1
	ld (#_sAlien + #4), a

	jp _update_facehug

_check_player_Y_aligned_with_alien :
	; if (yp >= (Ya + 3) * 8) and (yp + 16 <= (Ya + 3) * 8 + 24) then "Vertical Aligned"
	ld d, #BOOL_FALSE
	ld a, (#_sAlien + #1) ; Ya
	add a, #3
	add a, a
	add a, a
	add a, a
	ld b, a ; B = (Ya + 3) * 8
	ld a, (#_sThePlayer + #1) ; yp
	cp b
	ret c  ; not_vertical_aligned
	add #16
	ld c, a ; C = yp + 16
	ld a, b
	add #24
	cp c
	ret c  ; not_vertical_aligned
	ld d, #BOOL_TRUE
	ret

_try_alien_chase :
	cp #ALIEN_STATUS_CHASE
	jp nz, _try_alien_attack
	; check if player continues to be vertical aligned
	call _check_player_Y_aligned_with_alien
	ld a, d
	cp #BOOL_TRUE
	jr z, _do_alien_chase
	ld a, #ENEMY_STATUS_WALKING
	ld (#_sAlien + #3), a ; status
	jp _update_facehug

_do_alien_chase :
	; check for horizontal player proximity
	; if (Xa*8 + 16 >= xp + 8) then "Player is at left" else "Player is at right"
	ld a, (#_sThePlayer) ; xp
	add a, #8
	ld b, a ; B = Xa * 8 + 16
	ld a, (#_sAlien) ; Xa
	add a, a
	add a, a
	add a, a
	add a, #16
	ld c, a ; C = xp + 8
	cp b
	jr nc, _set_alien_dir_left
	ld a, #ENEMY_SPRT_DIR_RIGHT
	jr _set_new_alien_dir
_set_alien_dir_left :
	ld a, #ENEMY_SPRT_DIR_LEFT
_set_new_alien_dir :
	ld (#_sAlien + #2), a  ; dir
	; calculate distance from player to alien
	ld a, c
	sub b
	jr nc, _positive_distance
	neg
_positive_distance :
	push af
	; check if need to move Alien position
	ld a, (#_sAlien + #0) ; X
	ld b, a
	ld a, (#_sAlien + #9) ; last_X
	cp b
	call nz, _display_alien_at_screen
	; display Alien at current position, direction and at current frame - then update both
	call _update_alien_tileset

	pop af
	; if distance >= 28 then chase the player else
	; if distance >= 20 then attack the player else do nothing
	cp #28
	jr c, _check_alien_attack
	; start chasing the player

	ld a, (#_sAlien + #4) ; frame
	or a
	; if frame = 0 no need to move Alien at screen
	jp z, _update_alien_frame

	ld a, (#_sAlien + #2); dir
	cp #ENEMY_SPRT_DIR_LEFT
	jr z, _chase_alien_left
	; move Alien to the right
	ld a, (#_sAlien + #0) ; X
	inc a
	ld b, a
	add a, #3 ; rightmost tile
	ld c, a
	ld a, (#_sAlien + #8) ; max_X
	cp c
	jp c, _update_alien_frame
	ld a, b
	ld (#_sAlien + #0), a
	ld hl, #_sAlien + #11 ; iPosition
	inc (hl)
	jp _update_alien_frame

_chase_alien_left :
	; move Alien to the left
	ld a, (#_sAlien + #7) ; min_X
	ld b, a
	ld a, (#_sAlien + #0) ; X
	dec a
	cp b
	jp c, _update_alien_frame
	ld (#_sAlien + #0), a
	ld hl, #_sAlien + #11 ; iPosition
	dec (hl)
	jp _update_alien_frame

_check_alien_attack :
	cp #20
	jr c, _do_nothing_alien
	ld a, #ALIEN_STATUS_ATTACK
	ld (#_sAlien + #3), a ; status
	ld a, #1
	ld (#_sAlien + #4), a ; frame
	call _update_alien_tileset
	jr _do_alien_attack

_do_nothing_alien :
	call _update_alien_tileset
	jp _update_facehug

_try_alien_attack :
	cp #ALIEN_STATUS_ATTACK
	jp nz, _update_facehug
	; check if player continues to be vertical aligned
	call _check_player_Y_aligned_with_alien
	ld a, d
	cp #BOOL_TRUE
	jr z, _do_alien_attack_ex
	ld a, #ENEMY_STATUS_WALKING
	jr _end_alien_attack_status

_do_alien_attack_ex :
	; calculate distance from player to alien: (Xa * 8 + 16) - (xp + 8)
	ld a, (#_sThePlayer) ; xp
	ld b, a
	ld a, (#_sAlien) ; Xa
	add a, a
	add a, a
	add a, a
	add a, #8
	sub b
	jr nc, _positive_distance_2
	neg
_positive_distance_2 :
	; if distance >= 28 then chase the player else
	; if distance >= 20 then attack the player else do nothing
	cp #28
	jr c, _check_alien_attack_2
_back_chase_player :
	; back chasing the player
	ld a, #ALIEN_STATUS_CHASE
_end_alien_attack_status :
	ld (#_sAlien + #3), a ; status
	; need to set alien frame back to 1
	ld a, #1
	ld (#_sAlien + #4), a; frame
	jp _update_facehug

_check_alien_attack_2 :
	cp #20
	jr c, _back_chase_player
_do_alien_attack :
	; if frame=0, tongue is hidden (no sprite to display)
	ld a, (#_sAlien + #4) ; frame
	or a
	jr z, _tongue_is_hidden
	ld c, a

	; if LIGHT_SCENE_OFF_FL_OFF, no need to display alien tongle
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_OFF
	jr z, _no_tongue_on_the_dark

	; show alien tongue sprite
	ld hl, #_sGlbSpAttr
	push hl ; used at _spman_alloc_fixed_sprite() calls

	ld a, (#_sAlien + #1) ; Alien Y
	add a, #3
	rlca
	rlca
	rlca ; A = Alien y
	add a, #8 - #1
	;dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y
	
	ld a, (#_sAlien) ; Alien X
	ld d, a
	; pattern = ALIEN_PAT_TONGUE_IDX or ALIEN_PAT_TONGUE_FLIP_IDX
	ld a, (#_sAlien + #2) ; dir
	cp #ENEMY_SPRT_DIR_LEFT
	jr z, _alien_dir_left
	ld a, (#_ALIEN_PAT_TONGUE_IDX)
	ld b, #4 * #8 - #9
	jr _cont_alien_tongue_dir
_alien_dir_left :
	ld a, c
	neg
	ld c, a
	ld a, (#_ALIEN_PAT_TONGUE_FLIP_IDX)
	ld b, #256 - #7
_cont_alien_tongue_dir :
	ld (#_sGlbSpAttr + #02), a  ; _sGlbSpAttr.pattern
	ld a, d
	rlca
	rlca
	rlca ; A = Alien x
	add a, b ; position offset Dir/Left
	add a, c ; frame offset
	ld (#_sGlbSpAttr + #01), a ; _sGlbSpAttr.x

  ld a, #0x0F  ; white
	ld (#_sGlbSpAttr + #03), a  ; _sGlbSpAttr.attr

	call	_spman_alloc_fixed_sprite
	pop af

_no_tongue_on_the_dark :
	; check if alien tongue has hit the player
	; if (Ax2 < Px1) or (Ax1 > Px2) then "NO HORIZONTAL CONFLICT"
	; if (Ay2 < Py1) or (Ay1 > Py2) then "NO VERTICAL CONFLICT"
	; else "COLISION DETECTED"
	; where Ax1=Ax+4, Ax2=Ax+11, Ay1=Ay+8, Ay2=Ay+12
	;       Px1=Px+5, Px2=Px+10, Py1=Py+1, Py2=Py+15
	ld a, (#_sThePlayer)
	add a, #5
	ld b, a ; B=Px1
	add a, #5
	ld c, a ; C=Px2
	ld a, (#_sGlbSpAttr + #1)
	add a, #4 ; A=Ax1

	; check for horizontal colision
	cp c
	jr nc, _no_tongue_hit
	add a, #7 ; A=Ax2
	cp b
	jr c, _no_tongue_hit

	; now check for vertical colision
	ld a, (#_sThePlayer + #1)
	inc a
	ld b, a ; B = Py1
	add a, #14
	ld c, a ; C = Py2
	ld a, (#_sGlbSpAttr)
	add a, #8 + #1 ; A = Ay1

	cp c
	jr nc, _no_tongue_hit
	add a, #4 ; A = Ay2
	cp b
	jr c, _no_tongue_hit

	; colision detected - player was hit
	ld a, #HIT_PTS_TONGUE
	call _player_hit_asm_direct

_no_tongue_hit :
	; when status = ALIEN_STATUS_ATTACK, frame controls the alien tongue { 0 = hiden, 1..5 = intermediary position, 6 = final position }
_tongue_is_hidden :
	; add some delay to update frame - only update at odd cycles
	ld a, (#_sAlien + #5) ; delay
	and #0b00000001
	jr nz, _update_facehug
	ld a, (#_sAlien + #4) ; frame
	inc a
	cp #7
	jr nz, _set_tongue_frame
	; mplayer_play_effect_p(SFX_ALIENATTACK, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x000D; 00 + SFX_ALIENATTACK
	call	_mplayer_play_effect_p_asm_direct
	xor a
_set_tongue_frame :
	ld (#_sAlien + #4), a

_update_facehug :
	ld a, (#_cActiveEnemyQtty)
	or a
	ret z   ; no active enemies to update and display
  ld b, a

	; if sThePlayer.status = PLYR_STATUS_DEAD, bCheckPlayerColision = FALSE
	ld a, (#_sThePlayer + #03) ; status
	cp #PLYR_STATUS_DEAD
	jr nz, _cont_upd_facehug
	ld a, #BOOL_FALSE
	jr _cont_upd_facehug_2

_cont_upd_facehug :
	; if sThePlayer.grabflag=TRUE, bCheckPlayerColision = FALSE
	ld a, (#_sThePlayer + #9) ; grabflag
  xor #1
_cont_upd_facehug_2 :
	ld (#_bCheckPlayerColision), a

	ld a, (#_cShotCount) ; 0 = NO SHOT ACTIVE, 1 = SHOT ACTIVE
  ld (#_bCheckShotColision), a
	ld a, #BOOL_FALSE
	ld (#_bShotColisionWithEnemy), a
	push ix
	ld ix, #_sEnemies
_start_check_enemy :
	ld a, 3 (ix)
	cp #ENEMY_STATUS_KILLED + #1  ; also includes #ENEMY_STATUS_INACTIVE
	jr c, _next_enemy_to_check_ex
	cp #ENEMY_STATUS_GRABBED
	jp z, _anim_enemy_grab     ; always animate a grabbeb FH, even if its in/from a different screen
	cp #ENEMY_STATUS_HURT
	jp z, _anim_enemy_hurt     ; always animate a hurt FH, even if its in/from a different screen
	ld c, a
	ld a, (#_cScreenMap)
  cp 9 (ix) ; screenId
	jr nz, _next_enemy_to_check

	; found an active enemy at this screen
	ld a, c ; status
	cp #ENEMY_STATUS_WALKING
	jp z, _anim_enemy_walk
	cp #ENEMY_STATUS_AWAKING
	jr z, _anim_enemy_awake
	cp #ENEMY_STATUS_JUMPING
	jp z, _anim_enemy_jump
	; should never happen
_next_enemy_to_check_ex :
	inc b
_next_enemy_to_check :
	ld de, #14  ; sizeof(struct EnemyEntity)
	add ix, de
	djnz _start_check_enemy
	pop ix
	ret

_anim_enemy_awake :
	; need to protect B
	ld hl, #_sGlbSpAttr
	push bc
	push hl ; used at _spman_alloc_fixed_sprite() calls

	; check if enemy reach the floor
	inc 1 (ix)
	ld a, 1 (ix)
	cp 13 (ix) ; floor_y
	jr nz, _continue_awake
	ld 3 (ix), #ENEMY_STATUS_WALKING  ; status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY

_continue_awake :
	dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y

	inc hl
	ld a, 0 (ix)
	ld (hl), a  ; _sGlbSpAttr.x

	; pattern = ENEMY_PAT_BASE_IDX + (enemy_awake_frames[Frame] + Dir * 5) * 8
	ld de, #_enemy_awake_frames
	ld hl, #_enemy_awake_frames
	jp _do_display_enemy

_anim_enemy_jump :
	; if sThePlayer.status = PLYR_STATUS_DEAD, need to cancel the jump (cannot grab at the player, return to ENEMY_STATUS_WALKING)
	ld a, (#_sThePlayer + #03) ; status
	cp #PLYR_STATUS_DEAD
	jr nz, _anim_enemy_jump_ex
	ld 3 (ix), #ENEMY_STATUS_WALKING; status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY
  jp _next_enemy_to_check

_anim_enemy_jump_ex :
	; need to protect B
	ld hl, #_sGlbSpAttr
	push bc
	push hl ; used at _spman_alloc_fixed_sprite() calls

	ld a, (#_sThePlayer + #1) ; yp
	ld 1 (ix), a
	dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y

	; need to approximate enemy to the player
	ld a, (#_sThePlayer) ; xp
	ld b, a
	sub 0 (ix) ; xe
	jr nc, _positive_X2
	cp #256 - #4 + #1
	jr nc, _grab_it
	inc a
	inc a
	inc a
	jr _cont_jump_enemy
_positive_X2 :
	cp #4
	jr c, _grab_it
	dec a
	dec a
	dec a
_cont_jump_enemy :
	neg
	add b
	inc hl
	ld 0 (ix), a ; xe
	ld (hl), a ; _sGlbSpAttr.x

	; pattern = ENEMY_PAT_BASE_IDX + (enemy_jump_frames[Frame] + Dir * 5) * 8
	ld de, #_enemy_jump_frames
	ld hl, #_enemy_jump_frames
	jp _do_display_enemy

_grab_it :
	ld 3 (ix), #ENEMY_STATUS_GRABBED  ; status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY

	ld a, #BOOL_TRUE
	ld (#_sThePlayer + #9), a  ; grabflag
	ld (#_sGrabbedEnemyPtr), ix
	jr _anim_enemy_grab_ex

_anim_enemy_grab :
	; need to protect B
	ld hl, #_sGlbSpAttr
	push bc
	push hl ; used at _spman_alloc_fixed_sprite() calls

	ld a, (#_sThePlayer + 1)
	ld 1 (ix), a
	dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y

	; if Shield active, enemy is killed
	ld a, (#_cPlyRemainShield)
	or a
	jp nz, _shot_killed_enemy

_anim_enemy_grab_ex :
	ld a, (#_sThePlayer) ; xp
	ld 0 (ix), a
	inc hl
	ld (hl), a ; _sGlbSpAttr.x

	ld a, (#_sThePlayer + #2) ; dir
	ld 2 (ix), a ; dir

	; pattern = ENEMY_PAT_BASE_IDX + (enemy_grab_frames[Frame] + Dir * 5) * 8
	ld de, #_enemy_grab_frames
	ld hl, #_enemy_grab_frames
	jp _do_display_enemy

_anim_enemy_walk :
	; need to protect B
	ld hl, #_sGlbSpAttr
	push bc
	push hl  ; used at _spman_alloc_fixed_sprite() calls

	ld a, 1 (ix)
	dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y

	; check for player colision (if TRUE then change to ENEMY_STATUS_JUMPING)
	; if _bCheckPlayerColision is FALSE = no colision detection
	; if sThePlayer.grabflag is TRUE = no colision detection (already set at bCheckPlayerColision)
	; if sThePlayer.status = PLYR_STATUS_DEAD no colision detection (already set at bCheckPlayerColision)
	ld a, (#_bCheckPlayerColision)
	cp #BOOL_FALSE
	jr z, _no_enemy_colision

	; if |(ye - yp)| >= 8 then no player colision
	ld a, (#_sThePlayer + #1) ; yp
	ld b, 1 (ix) ; ye
	sub b
	jr nc, _positive_dist_5
	neg
_positive_dist_5 :
	cp #8
	jr nc, _no_enemy_colision

	; if |(xe - xp)| >= 12 then no player colision
	ld a, (#_sThePlayer) ; xp
	ld b, 0 (ix) ; xe
	sub b
	jr nc, _positive_dist_4
	neg
_positive_dist_4 :
  cp #12
	jr nc, _no_enemy_colision

	; enemy colision detected
	; no need to check for the other enemies in this same screen
	ld a, #BOOL_FALSE
	ld (#_bCheckPlayerColision), a

	ld 3 (ix), #ENEMY_STATUS_JUMPING  ; status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY
  jp _do_display_enemy_end


_no_enemy_colision :
	; check for shot colision (then change to ENEMY_STATUS_HURT)
	; if bCheckShotColision is FALSE = no colision detection
	ld a, (#_bCheckShotColision)
	cp #BOOL_FALSE
	jr z, _no_shot_colision

	; if (ys + 8) < (ye + 7) = no colision
	; if (ys + 6) > (ye + 16) = no colision
	ld b, 1 (ix) ; ye
	ld a, #7
	add b
	ld c, a
	ld a, (#_cShotY) ; ys
	add #8
	cp c
	jr c, _no_shot_colision
	dec a
	dec a
	ld c, a
	ld a, #16
	add b
	cp c
	jr c, _no_shot_colision

	; if |(xe - xs)| >= 16 then no shot colision
	ld a, (#_cShotX) ; xs
	ld b, 0 (ix) ; xe
	sub b
	jr nc, _positive_dist_3
	neg
_positive_dist_3 :
	cp #16
	jr nc, _no_shot_colision

	; shot colision detected
	ld a, #BOOL_TRUE
	ld (#_bShotColisionWithEnemy), a
	dec 4 (ix) ; hitcounter
	; TODO: SFX here SFX_HIT
	jr nz, _not_killed_enemy
_shot_killed_enemy :
	; enemy killed
	; TODO: SFX here SFX_HURT
	ld 3 (ix), #ENEMY_STATUS_HURT ; status
	ld 6 (ix), #0
	ld 7 (ix), #ENEMY_ANIM_DELAY
	jr _anim_enemy_hurt_ex

_no_shot_colision :
_not_killed_enemy :
	; update x and dir attributes
	inc hl
	ld a, 0 (ix)
	ld b, a
	ld (hl), a; _sGlbSpAttr.x
	ld a, 2 (ix) ; dir
	ld c, a
	cp #ENEMY_SPRT_DIR_RIGHT ; 0
	jr nz, _check_min_x
	ld a, 12 (ix) ; max_x
	sub #16
	cp b
	jr c, _change_enemy_dir
	jr _continue_enemy_walk

_check_min_x :
	ld a, b
	cp 11 (ix) ; min_x
	jr c, _change_enemy_dir
	jr _continue_enemy_walk

_change_enemy_dir :
	ld a, c
	xor #1
	ld 2 (ix), a ; dir

_continue_enemy_walk :
	ld de, #_enemy_walk_frames
	ld hl, #_enemy_walk_frames

_do_display_enemy :
	ld a, 4 (ix) ; hitcount
	cp #ENEMY_HIT_COUNT
	ld a, #FACEHUG_SPRITE_COLORS >> #4 ; not hurt
	jr z, _do_display_enemy_ex
	ld a, #FACEHUG_SPRITE_COLORS & #0b00001111 ; hurt
_do_display_enemy_ex :
	ld (#_sGlbSpAttr + #03), a ; _sGlbSpAttr.attr

	call _upd_frame_and_display_enemy
_do_display_enemy_end :
	pop	af
	pop bc
	jp _next_enemy_to_check

_anim_enemy_hurt :
  ; need to protect B
	ld hl, #_sGlbSpAttr
	push bc
	push hl ; used at _spman_alloc_fixed_sprite() calls

	ld a, 1 (ix)
	dec a ; y on the screen starts in 255
	ld (hl), a ; _sGlbSpAttr.y

_anim_enemy_hurt_ex :
	ld a, 2 (ix)  ; dir
	cp #ENEMY_SPRT_DIR_RIGHT
	ld a, 0 (ix)
	jr z, _add_2_x
	sub a, #4
_add_2_x :
  add a, #2
	inc hl
	ld (hl), a ; _sGlbSpAttr.x

	; if frame = 8 then stop hurt animation and kill enemy
	ld a, 6 (ix) ; frame
	cp #8
	jr nz, _anim_enemy_hurt_ex_2

	ld 3 (ix), #ENEMY_STATUS_KILLED  ; status
	ld hl, #_cActiveEnemyQtty
	dec (hl)
	ld a, #BOOL_FALSE
	ld (#_sThePlayer + #9), a  ; grabflag
	ld a, #SCORE_ENEMY_HIT_POINTS
	call _add_score_points

_anim_enemy_hurt_ex_2 :
; pattern = ENEMY_PAT_BASE_IDX + (enemy_hurt_frames[Frame] + Dir * 5) * 8
	ld de, #_enemy_hurt_frames
	ld hl, #_enemy_hurt_frames
	ld a, #FACEHUG_SPRITE_COLORS & #0b00001111 ; hurt
	jp _do_display_enemy_ex

_upd_frame_and_display_enemy :
	ld c, 6 (ix) ; frame
	ld b, #0
	add hl, bc
_get_enemy_frame :
	ld a, (hl)
	ld c, a
	cp #SPRITE_ANIM_FRAME_KEEP  ; keep same frame
	jr z, _cont_calc_frame_ex3
	cp #SPRITE_ANIM_FRAME_RESTART  ; reset frame cycle
	jr nz, _cont_calc_frame_ex2
	ld 6 (ix), #0
	ex de, hl
	jr _get_enemy_frame
_cont_calc_frame_ex3 :
	dec 6 (ix)
	dec hl
	jr _get_enemy_frame

_cont_calc_frame:
	dec 7 (ix) ; delay counter
	jr nz, _cont_calc_frame_ex
	ld 7 (ix), #ENEMY_ANIM_DELAY
_cont_calc_frame_ex2 :
	inc 6 (ix) ; frame++
_cont_calc_frame_ex :
	ld a, 2 (ix)  ; dir
	cp #ENEMY_SPRT_DIR_RIGHT ; 0
	jr z, _no_sprite_flip
	ld hl, #_ENEMY_PAT_BASE_FLIP_IDX
	dec 0 (ix)
	jr _no_sprite_flip_ex
_no_sprite_flip :
	ld hl, #_ENEMY_PAT_BASE_IDX
	inc 0 (ix)
_no_sprite_flip_ex :
	; if facehug status = GRABBED then always animate
	ld a, 3 (ix)
	cp #ENEMY_STATUS_GRABBED
  jr nz, _test_scene_dark
	; if LIGHT_SCENE_OFF_FL_OFF, just need to change facehug color (its in the dark)
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_OFF
	jr nz, _do_display_FH_normal
	ld a, #FACEHUG_SPRITE_COLOR_DARK ; Dark
	ld (#_sGlbSpAttr + #03), a ; _sGlbSpAttr.attr
	jr _do_display_FH_normal

_test_scene_dark :
	; if LIGHT_SCENE_OFF_FL_OFF, no need to display facehug
	ld a, (#_cGlbGameSceneLight)
	cp #LIGHT_SCENE_OFF_FL_OFF
	ret z

	; if LIGHT_SCENE_OFF_FL_ON, need to check if facehug is visible by the Flashlight
	cp #LIGHT_SCENE_OFF_FL_ON
	jr nz, _do_display_FH_normal
	; if facehug status = JUMPING then always animate (visible by Flashlight)
	ld a, 3 (ix)
	cp #ENEMY_STATUS_JUMPING
	jr z, _do_display_FH_normal
	; for all other status, need to check facehug position against player

	; if |(ye - yp)| >= 29 then facehug is not visible
	ld a, (#_sThePlayer + #1) ; yp
	ld b, 1 (ix) ; ye
	sub b
	jr nc, _positive_dist_2
	neg
_positive_dist_2 :
	cp #24 + #4 + #1
  ret nc

	; if |(xe - xp)| >= 29 then facehug is not visible
	ld a, (#_sThePlayer) ; xp
	ld b, 0 (ix) ; xe
	sub b
	jr nc, _positive_dist_1
	neg
_positive_dist_1 :
	cp #24 + #4 + #1
	ret nc

_do_display_FH_normal :
	ld a, c  ; enemy_XXX_frames[Frame] + Dir * 5
	add a, a
	add a, a  ; (enemy_XXX_frames[Frame] + Dir * 5) * 4
	add a, (hl)
	ld (#_sGlbSpAttr + #02), a; _sGlbSpAttr.pattern
	jp	_spman_alloc_fixed_sprite
	; no need to pop hl - it will be done after this routine returns
__endasm;
}  // update_and_display_enemies()

/*
* Update player position and player status
*/
void update_player()
{
__asm
  ld a, (#_cGlbPlyJumpTimer)
	or a
	jr z, 00100$
	dec a
	ld (#_cGlbPlyJumpTimer), a

00100$:
	;bGlbPlyMoved = false; 
	ld a, #BOOL_FALSE
	ld (#_bGlbPlyMoved), a

	;if (sThePlayer.grabflag) player_hit(HIT_PTS_FACEHUG);
	ld a, (#_sThePlayer + #9) ; sThePlayer.grabflag
	or a
	jr z, 00101$	
	ld	a, #HIT_PTS_FACEHUG
	call	_player_hit_asm_direct
00101$:
__endasm;

	if (!is_player_falling())
	{
		if (is_player_jumping())
		{
			// check colision with Fatal or horizontal forcefield
			if (cGlbPlyFlag & COLISION_FATAL)
			{
				player_hit(HIT_PTS_SMALL);
			}
			else if (cGlbPlyFlag & COLISION_NEXTM)  // Next map or Portal
			{
				cGameStatus = GM_STATUS_CHANGE_MAP;
				// cGlbObjData contains shift direction + screen destination (sssDDDDD)
				return;
			}
		}
		else
		{
			if (sThePlayer.status != PLYR_STATUS_CLIMB)
			{
				if (!is_player_ok())  // is there any colision with our player?
				{
					if (cGlbPlyFlag & COLISION_EMPTY)
					{
						//cGlbObjData = 1(single empty tile) or 2(2 empty tiles) - adjust Player X position when start to fall (center player at the blank tiles)
						update_player_status(PLYR_STATUS_FALLING);
					}
					else
					{
						if (cGlbPlyFlag & COLISION_OBJCT)
						{
							player_get_object();
							cScoretoAdd += SCORE_OBJECT_POINTS;
						}
						if (cGlbPlyFlag & COLISION_GATE)
						{
							player_hit(HIT_PTS_HIGH);
							return;
						}
						if (cGlbPlyFlag & COLISION_SOLID)
						{
							update_player_status(PLYR_STATUS_DEAD);
							return;
						}
						if (cGlbPlyFlag & COLISION_FATAL)
						{
							player_hit(HIT_PTS_SMALL);
						}
						if (cGlbPlyFlag & COLISION_FLOOR)
						{
							//cGlbObjData = 4(anti-clockwise/left) or 5(clockwise/right)
							player_moving_at_belt();
						}
					}
				}
			}
			if (sThePlayer.status != PLYR_STATUS_FALLING)
			{
				if (cCtrlCmd & UBOX_MSX_CTL_DOWN)
				{
					// if player is already climbing, continue until reach the floor
					if (sThePlayer.status == PLYR_STATUS_CLIMB)
					{
						if (is_player_climb_down())
						{
							if (cGlbPlyFlag & COLISION_NEXTM)  // Next map only (no horizontal portals)
							{
								cGameStatus = GM_STATUS_CHANGE_MAP;
								// cGlbObjData contains shift direction + screen destination (ss0DDDDD)
								return;
							}
						}
					}
					else
					{
						if (!is_player_cmd_down_ok())  // is there any colision trying to go down?
						{
							// check for a gate below the player
							if (cGlbPlyFlag & COLISION_GATE)
							{
								if (special_object_animated_ok(ANIMATE_OBJ_GATE, cGlbSpObjID)) // try to open the gate
								{
									mplayer_play_effect_p(SFX_GATE, SFX_CHAN_NO, 0);
								}
							}
							else if (cGlbPlyFlag & COLISION_FLOOR) // check for a stair below the player
							{
								//cGlbObjData = 1(single stair tile) or 2(2 stair tiles) - adjust Player X position when start to climb (center player at the stair tiles)
								update_player_status(PLYR_STATUS_CLIMB_DOWN);
							}
						}
					}
				}
				else if (cCtrlCmd & UBOX_MSX_CTL_UP)
				{
					// if player is already climbing, continue until reach the flood
					if (sThePlayer.status == PLYR_STATUS_CLIMB)
					{
						if (is_player_climb_up())
						{
							if (cGlbPlyFlag & COLISION_NEXTM)  // Next map only (no horizontal portals)
							{
								cGameStatus = GM_STATUS_CHANGE_MAP;
								// cGlbObjData contains shift direction + screen destination (ss0DDDDD)
								return;
							}
						}
					}
					else
					{
						if (!is_player_cmd_up_ok())  // is there any colision trying to go up?
						{
							// check for a stairs above the player
							if (cGlbPlyFlag & COLISION_FLOOR)
							{
								//cGlbObjData = 1(single stair tile) or 2(2 stair tiles) - adjust Player X position when start to climb (center player at the stair tiles)
								update_player_status(PLYR_STATUS_CLIMB_UP);
							}
						}
						else
						{
							if (!cGlbPlyJumpTimer)
							{
								// start a jump
								update_player_status(PLYR_STATUS_JUMPING);
							}
						}
					}
				}
				if (sThePlayer.status != PLYR_STATUS_CLIMB && sThePlayer.status != PLYR_STATUS_JUMPING)
				{
					if (cCtrlCmd & (UBOX_MSX_CTL_RIGHT | UBOX_MSX_CTL_LEFT))
					{
						cGlbWalkDir = (cCtrlCmd & UBOX_MSX_CTL_RIGHT) ? PLYR_SPRT_DIR_RIGHT : PLYR_SPRT_DIR_LEFT;
						if (!is_player_walking_ok(cGlbWalkDir))  // is there any colision right/left walking?
						{
							if (cGlbPlyFlag & COLISION_GATE)
							{
								if (special_object_animated_ok(ANIMATE_OBJ_GATE, cGlbSpObjID)) // try to open the gate
								{
									mplayer_play_effect_p(SFX_GATE, SFX_CHAN_NO, 0);
								}
							}
							else if (cGlbPlyFlag & COLISION_NEXTM)  // Next Map or Portal
							{
								cGameStatus = GM_STATUS_CHANGE_MAP;
								// cGlbObjData contains shift direction + screen destination (sssDDDDD)
								return;
							}
							else if (cGlbPlyFlag & COLISION_COLLECTIBLE)
							{
								special_object_animated_ok(ANIMATE_OBJ_COLLC, cGlbSpObjID);  // collect Collectible object
							}
							else if (cGlbPlyFlag & COLISION_INTER)
							{
								if (special_object_animated_ok(ANIMATE_OBJ_INTER, cGlbSpObjID)) // change Interactive object
								{
									// only if player walking colision with Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LIGHT_ONOFF AND Tile=GAME_PWR_SWITCH_TL_OFFSET+1 AND PlayerObjects=HAS_OBJECT_SCREW or
									//                                      Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_BUTTON_TL_OFFSET or
									//                                      Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_LOCKER_OPEN AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY or
									//                                      Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_BUTTON_TL_OFFSET or
									//                                      Tiletype=TILE_TYPE_INTERACTIVE AND Action=INTERACTIVE_ACTION_MISSION_CPLT AND Tile=GAME_PWR_LOCK_TL_OFFSET AND PlayerObjects=HAS_OBJECT_KEY
									
									//mplayer_play_effect_p(SFX_GATE, SFX_CHAN_NO, 0);
									mplayer_play_effect_p(SXF_INTERACTIVE, SFX_CHAN_NO, 0);
								}
							}
						}
					}
					if (!bGlbPlyMoved)
					{
						update_player_status(PLYR_STATUS_STAND);
					}
				}
			}
		}
	}
	else
	{
		// check for colision with horizontal forcefield - act as colision with a Fatal
		if (cGlbPlyFlag & COLISION_FATAL)
		{
			player_hit(HIT_PTS_SMALL);
		}
		if (cGlbPlyFlag & COLISION_NEXTM)  // Next map only (no horizontal portals)
		{
			cGameStatus = GM_STATUS_CHANGE_MAP;
			// cGlbObjData contains shift direction + screen destination (ss0DDDDD)
			return;
		}
	}
}  // void update_player()

/*
* Update map, shot and shield sprites
*/
void update_and_display_objects()
{
__asm
	ld hl, #_sGlbSpAttr
	push hl ; used at _spman_alloc_fixed_sprite() call

	;check if MiniMap is enabled
	ld a, (#_bGlbMMEnabled)
	or a
	jp z, _chkforShield

	ld a, (#_cMiniMapY)
	dec a; y on the screen starts in 255
	ld(hl), a; _sGlbSpAttr.y
	inc hl
	ld a, (#_cMiniMapX)
	ld(hl), a; _sGlbSpAttr.x
	inc hl
	ld a, (#_cMiniMapPattern)
	ld(hl), a; _sGlbSpAttr.pattern
	inc hl
	; change color each 8 frames
	ld de, (#_iGameCycles)
	ld a, #0b00000111
	and e
	ld a, (#_cLastMMColor)
	jp nz, _useCacheColor
	; update frame
	ld a, (#_cMiniMapFrame)
	cp #SPRT_MAP_COLOR_CYCLE
	jp nz, _updMapFrame
	xor a
_updMapFrame :
	inc a
	ld (#_cMiniMapFrame), a
	dec a
_useMapFrame :
	call _update_Frame_Color
	ld(#_cLastMMColor), a
_useCacheColor :
	ld (hl), a; _sGlbSpAttr.attr
	; allocate the MiniMap sprites; not fixed so they can flicker
	call	_spman_alloc_sprite

_chkforShield :
	;check if Shield is enabled
	ld a, (#_cPlyRemainShield)
	or a
	jr z, _chkforFlashLight
	ld b, a
	; Control delay for Shield decrement
	ld a, (#_cShieldUpdateTimer)
	inc a
	ld (#_cShieldUpdateTimer), a
	cp #ONE_SECOND_TIMER
	jr nz, _no_decrement
	xor a
	ld (#_cShieldUpdateTimer), a
	ld a, b
	dec a
	ld (#_cPlyRemainShield), a
	call _display_shield
_no_decrement :
	ld hl, #_sGlbSpAttr
	ld a, (#_sThePlayer + #01)
	dec a; y on the screen starts in 255
	ld(hl), a; _sGlbSpAttr.y
	inc hl
	ld a, (#_sThePlayer)
	ld (hl), a; _sGlbSpAttr.x
	inc hl
	ld a, (#_cShieldFrame)
	xor #1
	ld (#_cShieldFrame), a
	ld b, a
	rlc b
	rlc b
	ld a, (#_cShieldPattern)
	add a, b
	ld(hl), a; _sGlbSpAttr.pattern
	inc hl
	; if B=0 then cShieldFrame=0, else cShieldFrame=1
	ld a, b
	or b
	jr z, _color_2
  ld a, #SHIELD_SPRITE_COLORS >> #4
	jr _set_attr
_color_2 :
  ld a, #SHIELD_SPRITE_COLORS & #0b00001111
_set_attr :
	ld(hl), a; _sGlbSpAttr.attr
	; allocate the Shield sprites;  not fixed so they can flicker
	call	_spman_alloc_sprite

_chkforFlashLight :
	; check if Flashlight is enabled
	ld a, (#_cGlbGameSceneLight)
	bit 1, a
	jp z, _chkforShot
	ld a, (#_cPlyRemainFlashlight)
	or a
	jr z, _chkforShot
	ld b, a
	; Control delay for Flashlight decrement
	ld a, (#_cFlashLUpdateTimer)
	inc a
	ld (#_cFlashLUpdateTimer), a
	cp #ONE_SECOND_TIMER + #1
	jr nz, _chkforShot
	xor a
	ld (#_cFlashLUpdateTimer), a
	ld a, b
	dec a
	ld (#_cPlyRemainFlashlight), a
	jr z, _timeout_FL
	jr _timeout_FL_ex
_timeout_FL :
	call _disable_FL_ex
_timeout_FL_ex :
	call _display_flashlight

_chkforShot :
	; check for bShotColisionWithEnemy flag. Kill shot if TRUE
	ld a, (#_bShotColisionWithEnemy)
	cp #BOOL_TRUE
	jr z, _kill_shot
	; check if Shot is enabled
	ld a, (#_cShotCount)
	dec a
	jp nz, _check_explosion
	; shot is active - check for solid colision, enemy colision and end of screen
	ld a, (#_cShotDir) ; PLYR_SPRT_DIR_RIGHT(0) / PLYR_SPRT_DIR_LEFT(1)
	cp #PLYR_SPRT_DIR_LEFT
	ld a, (#_cShotX)
	jr nz, _do_right_shot
	; LEFT shot here
	cp #5 ; if X < 5 disable the shot
	jr c, _kill_shot
	sub #4 ; Shot moves 4 horizontal pixels
	ld c, a ; C = X - 4
	ld b, a; B = X - 4
	ld a, (#_cShotY)
	add a, #7
	call _calcTileXYAddrGeneric
	jr _detect_colision

_check_explosion :
	ld a, (#_cExplosionFrame)
	or a
	jr nz, _anim_explosion
	ld (#_cShotTrigTimer), a ; explosion ended - ok to fire again
	jp _end_updt_obj

_kill_shot :
	xor a
	ld (#_cShotCount), a
	; Start Explosion
	ld (#_cExplosionFrame), a ; reset cExplosionFrame
	ld a, (#_cShotX)
	ld (#_cExplosionX),a
	ld a, (#_cShotY)
	dec a ; y on the screen starts in 255
	ld (#_cExplosionY), a
	; mplayer_play_effect_p(SFX_EXPLODE, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0007; 00 + SFX_EXPLODE
	call	_mplayer_play_effect_p_asm_direct

_anim_explosion:
	ld hl, #_sGlbSpAttr
	ld a, (#_cExplosionY)
	ld(hl), a; _sGlbSpAttr.y
	inc hl
	ld a, (#_cExplosionX)
	ld(hl), a; _sGlbSpAttr.x
	inc hl
	ld a, (#_cShotExplosionPattern)
	ld(hl), a; _sGlbSpAttr.pattern
	inc hl
	; Change explosion colors
	ld a, (#_cExplosionFrame)
	call _update_Frame_Color
	ld(hl), a; _sGlbSpAttr.attr
	ld a, c
	inc a
	and #0b00000011; Range 0 - 3 (SPRT_MAP_COLOR_CYCLE)
	ld(#_cExplosionFrame), a
	; allocate the Explosion sprites; not fixed so they can flicker
	call	_spman_alloc_sprite
	jp _end_updt_obj

_update_Frame_Color :
	ex de, hl
	ld hl, #_color_frames
	ld b, #0
	ld c, a
	add hl, bc
	ld a, (hl)
	ex de, hl
	ret

_do_right_shot :
	; RIGHT shot here
	; A = _cShotX
	cp #256 - #4 - #16; if X >= (252 - 16) disable shot
	jr nc, _kill_shot
	add a, #4 ; Shot moves 4 horizontal pixels
	ld b, a ; B = X + 4
	add #15
	ld c, a ; C = X + 4 + 15
	ld a, (#_cShotY)
	add a, #7
	call _calcTileXYAddrGeneric
_detect_colision :
	ld a, b
	ld (#_cShotX), a
	ld a, (hl)
	; Alien tile is not SOLID, but works as solid for a shot
	cp #TILE_TYPE_ALIEN
	jp z, _kill_shot

	bit 7, a ; SOLID BIT
	jp z, _no_colision

	cp #TILE_TYPE_WALL
	jp z, _break_wall
	
	cp #TILE_TYPE_EGG
	jp z, _shot_egg

	cp #TILE_TYPE_INTERACTIVE ; check if shot colide with interactive object
	jp nz, _kill_shot  ; its SOLID but not WALL or INTERACTIVE - then kill the shot

	; Its an Interactive. Need to find corresponding ObjID
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
	ld de, #MAP_BYTES_SIZE
	add hl, de

	push hl
	ld a, #TS_SCORE_SIZE + #GAME_PWR_SWITCH_TL_OFFSET; tile to be confirmed
	call _check_for_interactive_tile
	pop hl
	jp nz, _kill_shot

	ld a, (hl); A = ObjID(10aaOOOO)
  ld c, a
	and #0b00110000  ; A = 00aa0000
	;cp #INTERACTIVE_ACTION_LIGHT_ONOFF << #4
	jr z, _is_action_light

	cp #INTERACTIVE_ACTION_LOCKER_OPEN << #4
	jr z, _is_action_locker

	cp #INTERACTIVE_ACTION_MISSION_CPLT << #4
	jp nz, _kill_shot
	; tile = GAME_PWR_SWITCH_TL_OFFSET and action is INTERACTIVE_ACTION_MISSION_CPLT

	call _activate_interactive_animation

	; execute Mission Complete
	ld a, b; A = ObjID(10aaOOOO)
	and #0b00001111  ; A = Mission #(0000OOOO)
	ld hl, #_cMissionStatus
	dec a
	ld c, a
	ld b, #0
	add hl, bc
	ld a, (hl)
	cp #MISSION_COMPLETE
	jp z, _kill_shot
	ld (hl), #MISSION_COMPLETE
	ld hl, #_cRemainMission
	dec(hl)

	call _update_mission_status
	; Add SCORE_MISSION_POINTS points to the score
	ld a, #SCORE_MISSION_POINTS
	call _add_score_points
	jp _kill_shot

_is_action_locker :
	; tile = GAME_PWR_SWITCH_TL_OFFSET and action is INTERACTIVE_ACTION_LOCKER_OPEN.
	call _activate_interactive_animation

	; need to use Locker ID to check if this locker is already opened or not
	ld a, b  ; A = B = ObjID(10aaOOOO)
	and #0b00001111  ; A = Locker ID (0000OOOO)

	; set Locker state = opened
	ld hl, #_cLockerOpened
	ld c, a
	ld b, #0
	add hl, bc
	ld a, (hl)
	cp #BOOL_TRUE
	jp z, _kill_shot
	ld (hl), #BOOL_TRUE
	ld a, c
	or #0b11000000  ; A = Locker ObjectID (1100OOOO)
	ld b, a
	ld c, #ANIMATE_OBJ_LOCKER
	call _activate_interactive_animation_ex  ; try to enable Locker animation(only works if Locker IS in this current screen)
  jp _kill_shot

_is_action_light :
	; tile = GAME_PWR_SWITCH_TL_OFFSET and action is INTERACTIVE_ACTION_LIGHT_ONOFF.
	call _activate_interactive_animation
	jp _kill_shot

_check_for_interactive_tile :
	; Move HL from _cMap_ObjIndex[] to _cMap_Data[]
	ld de, #MAP_BYTES_SIZE
	add hl, de
	cp (hl)
	ret

_activate_interactive_animation :
	ld b, c; C = ObjID(10aaOOOO)
	ld c, #ANIMATE_OBJ_INTER
_activate_interactive_animation_ex :
	push bc
	call	_special_object_animated_ok ; enable animation
	pop bc
	ret

_shot_egg :
	; Yes, its an Egg. Need to find corresponding ObjID
	; +decrease the egg resistance until its destroyed
	ld c, #ANIMATE_OBJ_EGG
	jr _shot_egg_ex

_break_wall :
	; Yes, its a wall. Need to find corresponding ObjID
	; + decrease the wall resistance until it breaks
	ld c, #ANIMATE_OBJ_WALL
	; Move HL from _cMap_TileClass[] to _cMap_ObjIndex[]
_shot_egg_ex :
	ld de, #MAP_BYTES_SIZE
	add hl, de
	ld b, (hl) ; B = ObjID
  call _activate_interactive_animation_ex
	jp _kill_shot

_no_colision :
	ld hl, #_sGlbSpAttr
	ld a, (#_cShotY)
	dec a ; Y on the screen starts in 255
	ld(hl), a; _sGlbSpAttr.y
	inc hl
	ld a, b
	ld(hl), a; _sGlbSpAttr.x
	inc hl
	ld a, (#_cShotDir); PLYR_SPRT_DIR_RIGHT(0) / PLYR_SPRT_DIR_LEFT(1)
	rlca
	rlca ; cShotDir * 4
	ld c, a
	ld a, (#_cShotPattern)
	add a, c
	ld (hl), a; _sGlbSpAttr.pattern
	inc hl
	; change shot colors
	ld a, (#_cShotFrame)
	call _update_Frame_Color
	ld (hl), a; _sGlbSpAttr.attr
	ld a, c
	inc a
	and #0b00000011 ; Range 0-3 (SPRT_MAP_COLOR_CYCLE)
	ld (#_cShotFrame), a
	; allocate the Shot sprites; fixed so they never flicker
	; sGlbSpAttr address is already pushed into the stack
	call _spman_alloc_fixed_sprite

_end_updt_obj :
	pop hl
__endasm;
} // void update_and_display_objects()

/*
* Check for 'P' keypress to enable/disable Pause
*/
void check_for_pause()
{
__asm
  ld	l, #0x04
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_P
	ret nz

_force_pause :
	; pressed P key - enable Pause
	; print "PAUSE"
	; put_tile_block(16, 0, SCORE_POWER_TILE, 3, 1);
	ld a, #SCORE_PAUSE_TL_OFFSET
	call _txt_prt

_wait_for_P :
  ld	l, #0x04
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_P
	jp nz, _wait_for_P

	; pressed P key - disable Pause
	; erase "PAUSE"
	; put_tile_block(16, 0, BLANK_TILE, 3, 1);
_txt_erase :
	xor a
	ld bc, #0x0010
	ld de, #0x0301
	call	_fill_block_asm_direct
	; mplayer_init(SONG, SONG_SILENCE / SONG_IN_GAME);
	ld a, (#_cLevel)
	cp #2
	ld a, #SONG_IN_GAME  ; level 1 and 3
	jr nz, _do_sfx
	ld a, #SONG_IN_GAME_2 ; level 2

_do_sfx :
	; mplayer_init(SONG, SONG_SILENCE / SONG_IN_GAME);
	ld	hl, #_SONG
	call _mplayer_init_asm_direct
	; mplayer_play_effect_p(SFX_SELECT, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0001; 00 + SFX_SELECT
	call	_mplayer_play_effect_p_asm_direct
	; wait some cycles before restart reading keyboard
	ld	l, #12
	call _ubox_wait_for
	ret

_txt_prt :
	ld bc, #0x0010
	ld de, #0x0301
	call	_put_tile_block_asm_direct
	; mplayer_init(SONG, SONG_SILENCE / SONG_IN_GAME);
	ld a, #SONG_SILENCE
	call _do_sfx
	ret
__endasm;
} // void check_for_pause()

/*
* Check if Fire triggered
*/
void check_for_fire()
{
__asm
	; check if Fire was triggered - if (cCtrlCmd & UBOX_MSX_CTL_FIRE1)
	ld	a, (#_cCtrlCmd)
	bit	4, a
	ret z; no fire triggered

	; player cant shot if grabbeb by an enemy
	ld a, (#_sThePlayer + #9) ; grabflag
	cp #BOOL_TRUE
	jr nz, _cont_shot_player
	; check for knife to hit the enemy
	ld a, (#_cRemainKnife)
	or a
	ret z ; player dont have a knife to use
	ld b, a
	; check if the player has already hit by a knife
	push ix
	ld ix, (#_sGrabbedEnemyPtr)
	ld a, 3 (ix)
	cp #ENEMY_STATUS_HURT
	jr nz, _do_hurt_enemy_with_knife
	pop ix
	ret
_do_hurt_enemy_with_knife :
	ld a, b
	dec a
	ld (#_cRemainKnife), a
	or a
	jr nz, _still_have_knife
	ld hl, #_cPlyObjects
	res 7, (hl) ; no more HAS_OBJECT_KNIFE
	call _display_objects
_still_have_knife :
  ; kill enemy
	jp _set_grabbed_enemy_as_dead_ex

_cont_shot_player :
	; check for active shot in the screen(only 1 is supported)
	ld a, (#_cShotCount)
	or a
	ret nz ; there is 1+ active shot

	; wait for _cShotTrigTimer = 0 to fire again
	ld a, (#_cShotTrigTimer)
	or a
	ret nz

  ; check for Player status - NO fire starts while climbing, falling or dead
	ld a, (#_sThePlayer + #03); A = _sThePlayer.status
	cp #PLYR_STATUS_CLIMB
	ret z ; climbing
	cp #PLYR_STATUS_FALLING
	ret z ; falling
	;cp #PLYR_STATUS_DEAD  ; not neccessary, already filtered at Run_Game()
	;ret z ; dead

	; check for Player status - NO fire if jumping WITH NO direction (up/down)
	cp #PLYR_STATUS_JUMPING
	jr nz, _test_shot
	ld a, (#_cGlbPlyJumpDirection)
	cp #PLYR_JUMP_DIR_NONE
	ret z ; jumping up/down

_test_shot :
  ld a, (#_cPlyAddtObjects)
	bit 0, a
	ret z  ; player dont have the gun object
	; check if Player have available Amno
	ld a, (#_cPlyRemainAmno)
	or a
	ret z  ; no Amno available
		
	ld a, (#_sThePlayer + #2) ; _sThePlayer.dir = PLYR_SPRT_DIR_RIGHT(0) / PLYR_SPRT_DIR_LEFT(1)
	ld (#_cShotDir), a
	cp #PLYR_SPRT_DIR_LEFT
	ld a, (#_sThePlayer); A = _sThePlayer.x
	jr nz, _shot_right
	; Shot to the LEFT
	cp #4 ; if _sThePlayer.x < 4 then cShotX = 0
	jr c, _zero_X
	; check if firing though a wall (solid tile)	
	ld c, a
	call _detect_solid
	ret nz ; do not fire shot
	sub #4
_set_X :
	ld (#_cShotX), a
	jr _do_shot

_zero_X :
	xor a
	jr _set_X

_shot_right :
	; Shot to the RIGHT
	; A = _sThePlayer.x
	cp #240; if _sThePlayer.x >= 240 then cShotX = 255
	jr nc, _max_X

	; check if firing though a wall (solid tile)
	add #16
	ld c, a
	call _detect_solid
	ret nz ; do not fire shot
	sub #12
	jr _set_X

_detect_solid :
	ld b, a
	ld a, (#_sThePlayer + #01); A = _sThePlayer.y
	ld (#_cShotY), a
	add a, #7
	call _calcTileXYAddrGeneric
	ld a, (hl)
	bit 7, a ; SOLID BIT
	ret nz ; do not fire shot
	ld a, b
	ret

_max_X :
	ld a, #255
	jr _set_X

_do_shot :
	; mplayer_play_effect_p(SFX_SHOOT, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0006; 00 + SFX_SHOOT
	call	_mplayer_play_effect_p_asm_direct
		
	; decrement Amno, set Count, (X, Y and Dir already set) and Frame
	ld a, (#_cPlyRemainAmno)
	dec a
	ld (#_cPlyRemainAmno), a
	ld a, #01
	ld (#_cShotCount), a
	ld (#_cShotTrigTimer), a
	xor a
	ld (#_cShotFrame), a

	; update Score
	call _display_gun_amno
__endasm;
} // void check_for_fire()

/*
* Check for 'F' keypress to enable/disable Flashlight
*/
void check_for_flashlight()
{
__asm
	ld hl, #_cGlbFLDelay
	ld a, (hl)
	or a
	jp z, _checkFL
	dec(hl)
	ret

_checkFL :
	ld	l, #0x03
	call	_ubox_read_keys
	ld	a, l
	cp #UBOX_MSX_KEY_F
	ret nz

	; pressed F key - check for enable/disable Flashlight
	ld a, #KEY_PRESS_DELAY
	ld (#_cGlbFLDelay), a
	ld a, (#_cGlbGameSceneLight)
	bit 1, a
	jp nz, _disable_FL
	ld b, a

	; Before enabling, check for Flashlight object to use
	ld a, (#_cPlyAddtObjects)
	bit 1, a
	ret z ; player dont have the flashlight object
	ld a, (#_cPlyRemainFlashlight)
	or a
	ret z ; player dont have the flashlight battery

	; all OK, enable Flashlight
	ld a, b
	set 1, a
	ld (#_cGlbGameSceneLight), a
	; print Flashlight Icon
	; put_tile(18, 2, GAME_TILE_OFFSET + GAME_FLASHL_TL_OFFSET);
	ld a, #SCORE_FLASHL_TL_OFFSET
	ld bc, #0x0212
	call	_put_tile_asm_direct
	call _display_flashlight

_set_FL_structure :
	; set _sFlashLightStatusData structure data
	push ix
	ld ix, #_sFlashLightStatusData
	ld 0 (ix), #BOOL_TRUE  ; sFlashLightStatusData.bFLightJustEnabled

	call _Calc_Player_FL_Pos
	call _Set_FL_XY_Offs
	pop ix
	ret

_Set_FL_XY_Offs :
	ld 1 (ix), l  ; sFlashLightStatusData.iCurrPlyPositionOffs [absolute offset from 0 - 768]
	ld 2 (ix), h

	ex de, hl ; DE = sFlashLightStatusData.iCurrPlyPositionOffs
	ld bc, #0x0500; C = 0, B = 5 (loop counter)
	or a; clear carry
_div32_loop_2 :
	rr d
	rr e
	rr c
djnz _div32_loop_2
	; E = TileAddr div 32      (tile Y)
	; C = (TleAddr mod 32) * 8 (pixel X)
	ld a, c
	and #0b11111000
	rrca
	rrca
	rrca  ; A = (TleAddr mod 32) (tile X)
	ld 3 (ix), a  ; sFlashLightStatusData.cCurrPlyTileX
	ld 4 (ix), e  ; sFlashLightStatusData.cCurrPlyTileY

	; now check for the X offsets to display FlashLight
	cp #2
	jr nc, _check_offset_right
	ld c, a
	ld a, #2
	sub c
	ld 5 (ix), a  ; sFlashLightStatusData.cOffSetXLeft
	ld 6 (ix), #0 ; sFlashLightStatusData.cOffSetXRight
	jr _check_Y_offset

_check_offset_right :
	ld 5 (ix), #0 ; sFlashLightStatusData.cOffSetXLeft
	ld 6 (ix), #0 ; sFlashLightStatusData.cOffSetXRight
	cp #28 + #01
	jr c, _check_Y_offset
	sub #28
	ld 6 (ix), a ; sFlashLightStatusData.cOffSetXRight

_check_Y_offset :
  ; now check for the Y offsets to display FlashLight
	ld a, e
	cp #5
	jr nc, _check_offset_bottom
	ld c, a
	ld a, #5
	sub c
  ld 7 (ix), a  ; sFlashLightStatusData.cOffSetYTop
	ld 8 (ix), #0 ; sFlashLightStatusData.cOffSetYBottom
	ret

_check_offset_bottom :
	ld 7 (ix), #0 ; sFlashLightStatusData.cOffSetYTop
	ld 8 (ix), #0 ; sFlashLightStatusData.cOffSetYBottom
	cp #20 + #1
	ret c
	sub #20
	ld 8 (ix), a ; sFlashLightStatusData.cOffSetYBottom
  ret

_Calc_Player_FL_Pos :
	ld c, #7
	ld d, c
	call _calcTileXYAddr
	ld de, #_cMap_TileClass - (#03 * #32)
	xor a
	sbc hl, de
	ret

_disable_FL_ex :
	; mplayer_play_effect_p(SFX_TIMEOFF, SFX_CHAN_NO, 0);
	ld bc, #0x0100; SFX_CHAN_NO + Volume(0)
	ld de, #0x0008; 00 + SFX_TIMEOFF
	call _mplayer_play_effect_p_asm_direct
	ld a, (#_cGlbGameSceneLight)
_disable_FL :
	; disable Flashlight
	res 1, a
	ld (#_cGlbGameSceneLight), a	
	bit 0, a
	call z, _do_scenelights_off
	; erase Flashlight Icon
	; put_tile(18, 2, BLANK_TILE);
	xor a
	ld bc, #0x0212
	call	_put_tile_asm_direct
__endasm;
}  // void check_for_flashlight()

/*
* Enable or disable game scene lights based on Power Switch
*/
void display_scene_light()
{
__asm
	ld hl, #_cGlbFlashLightAction
	ld a, (hl)	
	cp #GAME_LIGHTS_ACTION_NONE
	ret z
	ld (hl), #GAME_LIGHTS_ACTION_NONE

	cp #GAME_LIGHTS_ACTION_ON
	jr nz, _try_light_off
	; turn ON scene lights
	ld a, (#_cGlbGameSceneLight)
	set 0, a
	jr _end_lights

_try_light_off :
	cp #GAME_LIGHTS_ACTION_OFF
	ret nz
  ; check if FlashLight is already ON - calculate FL data if YES
	ld a, (#_cGlbGameSceneLight)
	bit 1, a
  call nz, _set_FL_structure 
	ld a, (#_cGlbGameSceneLight)
	res 0, a
_end_lights :
	ld (#_cGlbGameSceneLight), a
	jp _draw_map
__endasm;
}  // void display_scene_light()

/*
* Enable or disable flashlight effect
*/
void display_flashlight_effect()
{
__asm
  ld a, (#_cGlbGameSceneLight)
	bit 0, a
	ret nz ; SceneLight is ON
	bit 1, a
	ret z ; Flashlight is OFF
	; Flashlight is ON and SceneLight is OFF
	ld a, (#_sFlashLightStatusData)  ; sFlashLightStatusData.bFLightJustEnabled
	or a
	jr z, _update_FL_effect
  ; FlashLight just enabled - need a full FL display
	xor a
	ld (#_sFlashLightStatusData), a  ; sFlashLightStatusData.bFLightJustEnabled = FALSE
	; Flashlight effect...
	push ix
	ld ix, #_sFlashLightStatusData

	; calculate flashlight VRAM Address, cMap_Data[] Address, Width and Height
	call _Calc_FL_VRAM_W_H
	; DE = VRAM address
	; HL = _cMap_Data[] address
	; BC = Height / Width

	pop ix

_print_fl_line :
	push bc
	push hl
	push de
	ld b, #0
	call #0x005C  ; LDIRVM - Copia um bloco da RAM para a VRAM / BC = Comprimento, DE = Endereço VRAM, HL = Endereço RAM / Modifica : AF, BC, DE, HL, EI
	ld bc, #32
	pop de
	ex de, hl
	add hl, bc
	ex de, hl
	pop hl
	add hl, bc
	pop bc
	djnz _print_fl_line
	ret

_Calc_FL_VRAM_W_H :
	; calculate flashlight starting X and Y, then convert these coordinates into VRAM Address and _cMap_Data[] Address
	ld a, 4 (ix)  ; sFlashLightStatusData.cCurrPlyTileY
	add a, 7 (ix) ; sFlashLightStatusData.cOffSetYTop
	sub #2
	ld l, a ; start FL Y
	ld h, #0
	rlc l
	rlc l
	rlc l      ; l = Y * 8
	add hl, hl
	add hl, hl ; hl = Y * 32

	ld a, 3 (ix)  ; sFlashLightStatusData.cCurrPlyTileX
	add a, 5 (ix) ; sFlashLightStatusData.cOffSetXLeft
	sub #2
	ld  d, #0
	ld e, a ; start FL X
	add hl, de ; HL = start absolute offset for flashlight (start FL Y * 32 + start FL X)
	
	push hl
	ld bc, #_cMap_Data - (#03 * #32)
	add hl, bc  ; HL = _cMap_Data[] address
	ex de, hl

	pop hl
	ld bc, #UBOX_MSX_NAMTBL_ADDR
	add hl, bc
	ex de, hl  ; DE = VRAM address / HL = _cMap_Data[] address

	ld 9 (ix), e; sFlashLightStatusData.iVRAMAddrStartFL
	ld 10 (ix), d

	; calculate flashlight Width and Height
	ld a, #6
	sub 5 (ix)  ; sFlashLightStatusData.cOffSetXLeft
	sub 6 (ix)  ; sFlashLightStatusData.cOffSetXRight
	ld c, a ; Width
	ld 11 (ix), a  ; sFlashLightStatusData.cWidthFL

	ld a, #6
	sub 7 (ix)  ; sFlashLightStatusData.cOffSetYTop
	sub 8 (ix)  ; sFlashLightStatusData.cOffSetYBottom
	ld b, a ; Height
	ld 12 (ix), a  ; sFlashLightStatusData.cHeightFL
	ret
	
_update_FL_effect :
  ; FlashLight was enabled already - need a differential FL display
	ld a, (#_bGlbPlyChangedPosition)
	or a
	ret z
  ; player has changed position - check if FL update is needed

	call _Calc_Player_FL_Pos
	push hl
	ld de, (#_sFlashLightStatusData + #1)  ; DE = sFlashLightStatusData.iCurrPlyPositionOffs
	sbc hl, de
	pop hl
	ret z ; no FL update is needed
 
 ; player has a new position at screen - calculate new coordinates and FL offsets
	push ix
	ld ix, #_sFlashLightStatusDataAux
	ld 0 (ix), #BOOL_FALSE  ; sFlashLightStatusDataAux.bFLightJustEnabled

	call _Set_FL_XY_Offs
	; calculate new flashlight VRAM Address, cMap_Data[] Address, Width and Height
	call _Calc_FL_VRAM_W_H
	; DE = VRAM address
	; HL = _cMap_Data[] address
	; BC = Height / Width
	push bc
	push hl
	push de

	; Flashlight effect - erase current block and display the new one
	ld ix, #_sFlashLightStatusData
	ld a, #BLACK_TILE
	ld l, 9 (ix); sFlashLightStatusData.iVRAMAddrStartFL
	ld h, 10 (ix)
	ld d, 11 (ix); sFlashLightStatusData.cWidthFL
	ld e, 12 (ix); sFlashLightStatusData.cHeightFL
	halt
	call _fill_block_addr_asm_direct
	pop de
	pop hl
	pop bc
	call _print_fl_line

	pop ix
	ld de, #_sFlashLightStatusData
	ld hl, #_sFlashLightStatusDataAux
	ld bc, #13
	ldir  ; ld (DE), (HL), then increments DE, HL, and decrements BC until BC = 0
__endasm;
}  // void display_flashlight_effect()

/*
* Update score amount and display it
*/
void update_and_display_score()
{
__asm
	; only update score at odd frame (for better animation effect)
	ld a, (#_iGameCycles)
	bit 0, a
	ret z
	; check for Score points to display
	ld a, (#_cScoretoAdd)
	or a
	ret z
	ld hl, (#_iScore)
	ld b, #0
	cp #SCORE_ADD_ANIM
	jr c, _addRemain
	; Add SCORE_ADD_ANIM points to the score
	ld c, #SCORE_ADD_ANIM
	sub c
	jr _updScore
_addRemain :
	; Add remaining score points
	ld c, a
	xor a
_updScore:
	add hl, bc
	ld (#_cScoretoAdd), a
	ld (#_iScore), hl
	jp _display_score
__endasm;
}  // void update_and_display_score()

/*
* Update the status for all animated tiles (both standard and special tiles)
* Fill "pAnimTileList" array with all animated tiles at this cycle
*/
void update_animated_tiles()
{
__asm
	ld a, #BOOL_FALSE
	ld (#_bGlbSpecialProcessing), a
	push iy
	ld iy, (#_pAnimTileList)
	push ix
	ld ix, #_sAnimTiles
	ld a, (#_cAnimTilesQty)
	or a
	jp z, _do_special_tiles
	ld b, a  ; B = _cAnimTilesQty

_tile_loop :
	ld a, (#_bGlbSpecialProcessing)
	cp #BOOL_TRUE
	jp nz, _not_special_tile
	; Special tile processing
	; First check for a Slider object
	ld a, 2 (ix); A = _pCurAnimTile->cCycleMode
	; if _cCycleMode = ANIM_CYCLE_SLIDER_*, custom routine
	cp #ANIM_CYCLE_SLIDER_UP
	jp c, _not_a_slider
	; it a slider - just animate every 2 cycles (too fast if animate at every cycle)
	ld d, a
	ld a, (#_cAnimCycleParityFlag)
	bit 0, a
	jp z, _next_tile
	ld a, 7 (ix); pCurAnimTile->cTimeLeft
	or a
	jr nz, _decrease_timer ; if pCurAnimTile->cTimeLeft<>0, decrease timer and animate
	ld a, d
	cp #ANIM_CYCLE_SLIDER_UP
	jr nz, _not_slider_up
	ld c, #ANIM_CYCLE_SLIDER_DOWN
	jr _slider_proc
_not_slider_up :
	cp #ANIM_CYCLE_SLIDER_DOWN
	jr nz, _not_slider_down
	ld c, #ANIM_CYCLE_SLIDER_UP
	jr _slider_proc
_not_slider_down :
	cp #ANIM_CYCLE_SLIDER_LEFT
	jr nz, _not_slider_left
	ld c, #ANIM_CYCLE_SLIDER_RIGHT
	jr _slider_proc
_not_slider_left :
	ld c, #ANIM_CYCLE_SLIDER_LEFT

_slider_proc :
	; slider reverse state and restart timer
	ld a, 6 (ix)
	ld 7 (ix), a; pCurAnimTile->cTimeLeft = pCurAnimTile->cTimer
	ld 2 (ix), c
	jp _next_tile

_decrease_timer :
	dec 7 (ix)
	; update the screen object once per unique slider
	ld a, 3 (ix); A = pCurAnimTile->cStep
	cp #RIGHT_MOST_TILE
	ld a, d; D = _pCurAnimTile->cCycleMode
	ld c, d
	push bc  ; protects B(counter) and C(cycle mode) from _update_screen_object
	call z, _update_screen_object
	pop bc
	ld a, c; C = _pCurAnimTile->cCycleMode

	cp #ANIM_CYCLE_SLIDER_UP
	jr nz, _not_slider_up_2
	; insert blank tile at current position, them move tile up
	ld c, #BLANK_TILE
	call _do_insert_anim_queue
	ld de, #32
	xor a; A = 0, carry flag = 0
	sbc hl, de
_end_slider_proc :
	ld 0 (ix), l
	ld 1 (ix), h	; updated pCurAnimTile->iPosition (+1, -1, +32, -32)
	ld c, 5 (ix)
	call _do_insert_anim_queue
	jp _next_tile

_not_slider_up_2 :
	cp #ANIM_CYCLE_SLIDER_DOWN
	jr nz, _not_slider_down_2
	ld c, #BLANK_TILE
	call _do_insert_anim_queue
	ld de, #32
	add hl, de
	jr _end_slider_proc

_not_slider_down_2 :
	cp #ANIM_CYCLE_SLIDER_LEFT
	jr nz, _not_slider_left_2
	ld a, 3 (ix) ; A = pCurAnimTile->cStep
	cp #RIGHT_MOST_TILE
	jr nz, _no_extra_blank_tile_L
	ld c, #BLANK_TILE
	call _do_insert_anim_queue
	jr _move_tile_L
_no_extra_blank_tile_L :
	ld l, 0 (ix)
	ld h, 1 (ix); HL = pCurAnimTile->iPosition
_move_tile_L :
	dec hl
	jr _end_slider_proc

_not_slider_left_2 :
	ld a, 3 (ix); A = pCurAnimTile->cStep
	cp #LEFT_MOST_TILE
	jr nz, _no_extra_blank_tile_R
	ld c, #BLANK_TILE
	call _do_insert_anim_queue
	jr _move_tile_R
_no_extra_blank_tile_R :
	ld l, 0 (ix)
	ld h, 1 (ix); HL = pCurAnimTile->iPosition
_move_tile_R :
	inc hl
	jr _end_slider_proc

_not_a_slider :
	; for special tiles, only use active ones
	ld a, 8 (ix) ; pCurAnimTile->cSpTileStatus
	cp #ST_DISABLED
	jp z, _next_tile
	cp #ST_TIMEWAIT
	jr nz, _continue_tile_proc
	dec 7 (ix)  ; --pCurAnimTile->cTimeLeft
	jp nz, _next_tile	; do nothing - gate still have time to wait
	ld 8 (ix), #ST_ENABLED

_continue_tile_proc :
_not_special_tile :
	ld a, 2 (ix)	; A = _pCurAnimTile->cCycleMode
	add a, a
	ld c, a
	add a, a
	add a, a
	add a, c ; A = _pCurAnimTile->cCycleMode * 10
	add a, 3 (ix) ; A = _pCurAnimTile->cCycleMode * 10 + pCurAnimTile->cStep

	ld hl, #_cCycleTable
	ld d, #0
	ld e, a
	add hl, de
	ld a, (hl) ; A = cCycleTable[pCurAnimTile->cCycleMode * 10 + pCurAnimTile->cStep];
	cp 4 (ix)	; pCurAnimTile->cLastFrame
	jp z, _upd_and_next_tile
	ld 4 (ix), a  ; pCurAnimTile->cLastFrame = A
	cp #ANIM_CYCLE_STEP_STOP  ; disable special animated tile
	jp nz, _continue_animation
	; if (cGlbCurFrame == 0xFE) {...} // disable special animated tile
	ld a, 2 (ix)
	cp #ANIM_CYCLE_WALL_BREAK
	jr nz, _test_anim_gate
	; wall break
	ld c, 6 (ix)
	ld 7 (ix), c
_egg_animation :
	inc 3 (ix)
	jr _upd_obj_anim_history

_test_anim_gate :
	cp #ANIM_CYCLE_GATE_OPEN
	jr nz, _test_anim_egg
	ld c, a
	ld a, 6 (ix)  ; pCurAnimTile->cTimer
	or a
	ld a, c
	jr z, _anim_gate_open
	; gate is opening and there is a timer set for closing
	; disable animation and enable timer for this tile
	ld 2 (ix), #ANIM_CYCLE_GATE_CLOSE
	ld c, 6 (ix)
	ld 7 (ix), c
	ld 8 (ix), #ST_TIMEWAIT
	ld a, 3 (ix)
	sub #4
	ld 3 (ix), a
	jr _end_anim_0xFE_2

_test_anim_egg :
	cp #ANIM_CYCLE_FACEHUG_EGG
	jr nz, _test_anim_interactive
	jr _egg_animation
	
_test_anim_interactive :
  cp #ANIM_CYCLE_LOCKER_OPEN
	jr z, _end_anim_0xFE
	cp #ANIM_CYCLE_INTERACTIVE
	jr nz, _anim_gate_open
	ld a, 3 (ix)
	inc a
	; if A = 2, then in this moment the action is ON->OFF
	cp #2
	jr nz, _try_step_4
	
	ld a, 9 (ix)  ; first check for Action type in cSpObjID (10aaOOOO)
	and #0b00110000
	cp #INTERACTIVE_ACTION_LIGHT_ONOFF
	ld a, #2  ; keep animation at Step = 2
	jr nz, _upd_step

	ld (#_cGlbFlashLightAction), a
	jr _upd_step
_try_step_4 :
	; if A = 4, then in this moment the action is OFF->ON
	cp #4
	jr nz, _upd_step

	ld a, 9 (ix)  ; first check for Action type in cSpObjID(10aaOOOO)
	and #0b00110000
	cp #INTERACTIVE_ACTION_LIGHT_ONOFF
	jr nz, _upd_step_ex

	ld a, #GAME_LIGHTS_ACTION_ON
	ld (#_cGlbFlashLightAction), a
_upd_step_ex :
	; reset animation step when >= Step 2
	xor a
_upd_step :
	ld 3 (ix), a
_upd_obj_anim_history :
	; keep interactive/wall state at object history from now on
	; update_wall_history(pCurAnimTile->iPosition, pCurMapData[pCurAnimTile->iPosition - (3 * 32)]);
	ld e, 0 (ix)
	ld d, 1 (ix); DE = pCurAnimTile->iPosition
	ld hl, #_cMap_Data - (#03 * #32)
	add hl, de
	ld a, (hl)
	push bc ; protect counter B from _update_wall_history
	push	af
	inc	sp
	push	de
	call	_update_wall_history
	pop	af
	inc	sp
	pop bc
	jr _end_anim_0xFE

_anim_gate_open :
	ld 2 (ix), #ANIM_CYCLE_GATE_OPEN
	ld a, 3 (ix)  ; pCurAnimTile->cStep
	sub #4
	ld 3 (ix), a
	;if (!pCurAnimTile->cTimer) disable_gate_history(pCurAnimTile->iPosition); 
	ld a, 6 (ix)
	or a
	jr nz, _end_anim_0xFE
	; keep gate open at object history from now on
	ld	e, 0 (ix)
	ld	d, 1 (ix)
	push bc; protect counter B from _disable_gate_history
	push de
	call	_disable_gate_history
	pop	af
	pop bc

_end_anim_0xFE :
	; pCurAnimTile->cSpTileStatus = ST_DISABLED;
	; cGlbSpecialTilesActive--;
	ld 8 (ix), #ST_DISABLED
	ld hl, #_cGlbSpecialTilesActive
	dec(hl)
_end_anim_0xFE_2 :
	ld 4 (ix), #0xAA	; pCurAnimTile->cLastFrame = 0xAA
	jp _next_tile

_do_insert_anim_queue :
	; Input: IX = pCurAnimTile
	;				 IY = pAnimTileList
	;				 C = tile to insert at pAnimTileList
	; Output:
	;				 IY = pAnimTileList++
	;				 HL = pCurAnimTile->iPosition
	; Changes: A, D, E, H, L
	; include this tile to the animation queue
	; pAnimTileList->cTile = pCurMapData[pCurAnimTile->iPosition - (3 * 32)] = cGlbTile
	ld l, 0 (ix)
	ld h, 1 (ix); HL = pCurAnimTile->iPosition
	push hl
	push hl

	ld de, #_cMap_Data - (#03 * #32)
	add hl, de

	ld(hl), c
	ld 0 (iy), c
	; pAnimTileList->iPosition = pCurAnimTile->iPosition;
	; pAnimTileList++;
	pop hl
	ld 1 (iy), l
	ld 2 (iy), h
	inc iy
	inc iy
	inc iy
	ld(#_pAnimTileList), iy

	; update cMap_TileClass[]
	ld de, #_cMap_TileClass - (#03 * #32)
	add hl, de
	ld a, c
	call	_getTileClass
	ld (hl), a
	pop hl
	ret

_continue_animation :
	ld c, #BLANK_TILE
	cp #ANIM_CYCLE_STEP_BLANK  ; blank tile
	jr z, _insert_anim_queue
	add a, 5 (ix)  ; A = pCurAnimTile->cTile + cGlbCurFrame
	ld c, a

_insert_anim_queue :
	call _do_insert_anim_queue

_upd_and_next_tile :
	ld a, 3 (ix)
	inc a
	cp #10 ;cStep >= 10 ?
	jp c, _end_mod_10
	sub #10
_end_mod_10 :
	ld 3 (ix), a	; pCurAnimTile->cStep = (pCurAnimTile->cStep + 1) % 10;
_next_tile :
	ld de, #10 ; sizeof(struct AnimatedTile)
	add ix, de  ;_pCurAnimTile++
	dec b
	jp nz, _tile_loop

	ld a, (#_bGlbSpecialProcessing)
	cp #BOOL_TRUE
	jr z, _finish_tiles

_do_special_tiles :
	ld a, (#_cAnimSpecialTilesQty)
	or a
	jp z, _finish_tiles
	ld b, a; B = _cAnimSpecialTilesQty
	ld a, #BOOL_TRUE
	ld(#_bGlbSpecialProcessing), a
	ld ix, #_sAnimSpecialTiles
	jp _tile_loop

_finish_tiles :
	ld a, (#_cAnimCycleParityFlag)
	xor #1
	ld (#_cAnimCycleParityFlag), a
	pop ix
	pop iy
__endasm;
}  // void update_animated_tiles()


void draw_level_up_message()
{
__asm
	; mplayer_init(SONG, SONG_SILENCE);
	ld	hl, #_SONG
	ld a, #SONG_SILENCE
	call _mplayer_init_asm_direct

	; Fill_Box(6, 6, 20, 11, BLANK_TILE);
	xor a
	ld bc, #0x0606
	ld de, #0x140B
	call _fill_block_asm_direct
	
_encode_lvl_code :
	; step 1: compute iScore[16 bit] + cLives[3 bit] + cLevel[2 bit] + SALT_1[3 bit] + SALT_2[8 bit] + CRC[8bit]
	ld hl, (#_iScore)
	
	ld (#_cBuffer), hl

	ld a, (#_cLevel)
	inc a ; next level required [2 or 3]

	rlca
	rlca
	rlca
	or #CRC8_SALT_1
	ld b, a ; cLevel + SALT_1
	ld a, (#_cLives)

	rrca
	rrca
	rrca
	or b ; cLives + cLevel + SALT_1
	ld (#_cBuffer + #2), a

	ld a, #CRC8_SALT_2
	ld (#_cBuffer + #3), a

	ld hl, #_cBuffer
	ld de, #04
	call _crc8b
	ld (#_cBuffer + #4), a ; CRC8

	; step 2: suffle nibbles[0, 1, 2, 3, 4, 5, *6, *7, 8, 9] to [4, 1, 8, 3, 5, 9, 2, 0] (discard SALT_2)
	; step 3: SUM 'A' to each nibble to generate a new CHAR code
	ld a, (#_cBuffer + #2)
	call _do_rotate_and_add
	ld (#_cBuffer + #10), a ; [4]

	ld a, (#_cBuffer + #0)
	call _do_clean_and_add
	ld (#_cBuffer + #11), a ; [4, 1]

	ld a, (#_cBuffer + #4)
	call _do_rotate_and_add
	ld (#_cBuffer + #12), a ; [4, 1, 8]

	ld a, (#_cBuffer + #1)
	call _do_clean_and_add
	ld (#_cBuffer + #13), a ; [4, 1, 8, 3]

	ld a, (#_cBuffer + #2)
	call _do_clean_and_add
	ld (#_cBuffer + #14), a ; [4, 1, 8, 3, 5]

	ld a, (#_cBuffer + #4)
	call _do_clean_and_add
	ld (#_cBuffer + #15), a ; [4, 1, 8, 3, 5, 9]

	ld a, (#_cBuffer + #1)
	call _do_rotate_and_add
	ld (#_cBuffer + #16 ),a ; [4, 1, 8, 3, 5, 9, 2]

	ld a, (#_cBuffer + #0)
	call _do_rotate_and_add
	ld (#_cBuffer + #17), a ; [4, 1, 8, 3, 5, 9, 2, 0]

	xor a
	ld (#_cBuffer + #18), a ; [4, 1, 8, 3, 5, 9, 2, 0] + '\0'

	; step 4: print it
	;; Display_Text(14, 15, FONT1_TILE_OFFSET, cBuffer + 10);
	ld hl, #_cBuffer + #10
	push hl
	ld a, (#_FONT1_TILE_OFFSET)
	push af
	inc	sp
	ld de, #0x0F0E
	push de
	call _display_text
	pop	af
	inc	sp
	pop af

	ld a, #GAME_TEXT_LEVEL_COMPLETED_ID
	call _search_text_block
	ld bc, #0x0707
	jp _display_msg_and_wait

_do_rotate_and_add :
	rlca
	rlca
	rlca
	rlca
_do_clean_and_add :
	and #0b00001111
	add #'A'
	ret

	; simple CRC - 8 (9bit) routine using the CCITT(Comité Consultatif International Téléphonique et Télégraphique)
	; polynominal x8 + x2 + x + 1. For binary data x = 2, so the polynominal translates to 28 + 22 + 2 + 1 = 256 + 4 + 2 + 1 = 263
	; which in binary is 00000001 00000111. For this implementation the high - order bit(9th bit), which is always 1,
	; is omitted so it becomes 00000111, 7 in decimal or 0x07 in hex
	;; =====================================================================
  ;; input - hl = start of memory to check, de = length of memory to check
	;; returns - a = result crc
	;; 20b
	;; ==================================================================== =
_crc8b :
	xor a ; initial value of crc = 0 so first byte can be XORed in(CCITT)
	ld c, #0x07 ; c = polyonimal used in loop (small speed up)
_byteloop8b :
	xor (hl) ; xor in next byte, for first pass a = (hl)
	inc hl ; next mem
	ld b, #8 ; loop over 8 bits
_rotate8b :
	add a, a ; shift crc left one
	jr nc, _nextbit8b ; only xor polyonimal if msb set(carry = 1)
	xor c ; CRC8_CCITT = 0x07
_nextbit8b :
	djnz _rotate8b
	ld b, a ; preserve a in b
	dec de ; counter - 1
	ld a, d ; check if de = 0
	or e
	ld a, b ; restore a
	jr nz, _byteloop8b
__endasm;
}  // void draw_level_up_message()


void display_meltdown_counter()
{
__asm
	ld a, (#_bFinalMeltdown)
	cp #BOOL_TRUE
	ret nz

	; real timer control
	ld a, (#_cMeltdownTimerCtrl)
	or a
	jr z, _set_timer_and_display_md_timer
	dec a
	ld (#_cMeltdownTimerCtrl), a
	ret

_set_timer_and_display_md_timer :
	ld a, #ONE_THIRD_SECOND_TIMER
	ld (#_cMeltdownTimerCtrl), a

	ld a, (#_cMeltdownSeconds)
	and #0b00000001
	; ubox_put_tile(12, 1, GAME_ALARM_TIMER_TL_OFFSET);
	add a, #TS_SCORE_SIZE + #GAME_ALARM_TIMER_TL_OFFSET
	ld bc, #0x010C
	call _put_tile_asm_direct

	ld a, (#_cMeltdownSeconds)
	and #0b00000001
	; ubox_put_tile(18, 1, GAME_ALARM_TIMER_TL_OFFSET + 2);
	add a, #TS_SCORE_SIZE + #GAME_ALARM_TIMER_TL_OFFSET + #2
	ld bc, #0x0112
	call _put_tile_asm_direct

	; display_number(13, 1, 2, cMeltdownMinutes);
	ld	a, (#_cMeltdownMinutes)
	ld	c, a
	ld	b, #0x00
	push	bc
	ld	de, #0x0201
	push	de
	ld	a, #13
	push	af
	inc	sp
	call	_display_number
	pop	af
	pop	af
	inc	sp
		
	; display_number(16, 1, 2, cMeltdownSeconds);
  ld a, (#_cMeltdownSeconds)
	ld c, a
	ld b, #0x00
	push bc
	ld de, #0x0201
	push de
	ld a, #16
	push af
	inc sp
	call _display_number
	pop	af
	pop	af
	inc	sp

	; calculate new timer
  ld a, (#_cMeltdownSeconds)
	or a
	jr z, _reset_md_seconds
	dec a
	ld (#_cMeltdownSeconds), a
	ret

_reset_md_seconds :
	; ubox_put_tile(15, 1, SCORE_COLON_TL_OFFSET);
	ld a, #SCORE_COLON_TL_OFFSET
	ld bc, #0x010F
	call _put_tile_asm_direct

	ld a, (#_cMeltdownMinutes)
	or a
	jr nz, _decrement_minutes
  ld a, #GM_STATUS_TIME_IS_OVER
  ld (#_cGameStatus), a
	ret
_decrement_minutes :
	dec a
	ld (#_cMeltdownMinutes), a
	ld a, #59
	ld (#_cMeltdownSeconds), a
__endasm;
}  // void display_meltdown_counter()


/*
* Game engine loop
*/
void Run_Game()
{
	do  // loop for each Level
	{
		ubox_disable_screen();
		// clear the screen
		ubox_fill_screen(BLANK_TILE);
		ubox_enable_screen();
		cGameStage = GAMESTAGE_LEVEL;

		// Level 3 TEST
		//cLevel = 3;
		//cMeltdownSeconds = 20;
		//cMeltdownTimerCtrl = 0;
	  //cMeltdownMinutes = 0;
		//bFinalMeltdown = true;

		draw_game_level_info();

		ubox_disable_screen();
		load_gamelevel_data();
		Load_Sprites();
		reset_obj_history();
		reset_locker_and_enemies();

		// global variable initialization - once per level
		cLastPower = 0xFF;  // force update on the first display_power() call
		bGlbMMEnabled = false;
		cGlbGameSceneLight = LIGHT_SCENE_ON_FL_ANY;
		cGlbFlashLightAction = GAME_LIGHTS_ACTION_NONE;
		cPlyObjects = cPlyAddtObjects = HAS_NO_OBJECT;  // Player starts with no objects
		sThePlayer.type = ET_UNUSED;
		cPlyRemainShield = INVULNERABILITY_SHIELD;
		cGameStatus = GM_STATUS_LOOP_CONTINUE;

		cLastMMColor = cLastShieldColor = cLastShotColor = cShieldUpdateTimer = cFlashLUpdateTimer = cGlbFLDelay = cShieldFrame = cMiniMapFrame = cPlyRemainFlashlight = cPlyHitTimer = cPlyDeadTimer = cScreenShiftDir = 0;
		cGlbPlyJumpTimer = cRemainYellowCard = cRemainGreenCard = cRemainRedCard = cRemainKey = cRemainScrewdriver = cRemainKnife = cScoretoAdd = cPlyRemainAmno = 0;

		do  // loop at each screen map
		{
			// Load, uncompress map data and update object history
			load_levelmap_data();
			if (cGameStatus == GM_STATUS_CHANGE_MAP)
			{
				load_entities();
				shift_screen_map();
				update_player_position();

				//update level/screen into score area
				display_level();
				cGameStatus = GM_STATUS_LOOP_CONTINUE;
			}
			else
			{
				// clear the screen
				load_entities();
				ubox_fill_screen(BLANK_TILE);
				Draw_Score_Panel();
				draw_map();
				ubox_enable_screen();
__asm
        //mplayer_init(SONG, SONG_IN_GAME / SONG_IN_GAME_2);
        ld a, (#_cLevel)
				cp #2
				ld a, #SONG_IN_GAME   ; level 1 and 3
				jr nz, 00155$
				ld a, #SONG_IN_GAME_2 ; level 2
00155$:
				ld	hl, #_SONG
				call _mplayer_init_asm_direct
__endasm;
			}
			cMiniMapX = SCORE_MINIMAP_X_POS * 8 + cMapX * 4 + 3;
			cMiniMapY = SCORE_MINIMAP_Y_POS * 8 + cMapY * 3 + 7;

			// reset tile list for the first cycle
			pAnimTileList = sAnimTileList;
			cAnimCycleParityFlag = cGlbPlyFlag = cGlbSpObjID = cShotCount = 0;
			iGameCycles = 0;
			cGlbPlyFlagCache = CACHE_INVALID;
			do  // loop until player is dead (lives=0) or need to change map
			{			
				if (sThePlayer.status != PLYR_STATUS_DEAD)
				{
					check_for_pause();        // scan for 'P' key
					check_for_flashlight();   // scan for 'F' key
					check_for_player_arise(); // scan for 'ESC' key, then Y to confirm
					//check_for_easteregg();  // not implemented
				}
			
				// update the animated tiles each 7 cycles
				if ((iGameCycles & 0b00000111) == 0x07) // 7 cycles
				{
					// process standard & special animated tiles
					// in case of sliderfloor, also update the object coordinates into the screen, detect player colision and update player position if necessary
					update_animated_tiles();
				}

				if (sThePlayer.status != PLYR_STATUS_DEAD)
				{
					// read the selected control
					cCtrlCmd = ubox_read_ctl(cCtrl);

					// check for user action to trigger fire
					check_for_fire();  // scan for 'ESPACE' key

					// update our player position and status
					update_player();
					if (cGameStatus == GM_STATUS_CHANGE_MAP) break;
				}

				bGlbPlyChangedPosition |= bGlbPlyMoved;

				// update and display all the enemies (first so the facehug stays in front of the player sprite) + Alien
				update_and_display_enemies();

				// display updated player sprite
				display_player();

				// update the objects statuses (map, shot, shield) and display sprites
				update_and_display_objects();
				
				// display all sprites on the screen
				spman_update();

				// display & animate Score
				update_and_display_score();

				// display all updated animated tiles on the screen and reset pAnimTileList
				display_animated_tiles();

				// enable or disable game scene lights
				display_scene_light();

				// enable or disable Flashlight effect
				display_flashlight_effect();
				bGlbPlyChangedPosition = false;

				// update and display Meltdown counter
				display_meltdown_counter();

				update_game_loop_status();

				iGameCycles++;

				// ensure we wait to our desired update rate
				ubox_wait();

			} while (cGameStatus == GM_STATUS_LOOP_CONTINUE);

			// hide all the sprites
			spman_hide_all_sprites();

			if (cGameStatus == GM_STATUS_CHANGE_MAP)
			{
				// Set right screen number and shift direction (up, down, right, left, portal) based on cGlbObjData
				cScreenMap = cGlbObjData & 0b00011111;
				cScreenShiftDir = cGlbObjData >> 5;
				if (cScreenShiftDir == SCR_SHIFT_RIGHT || cScreenShiftDir == SCR_SHIFT_LEFT)
				{
__asm
					ld de, #_cTemp_Map_Data
					ld hl, #_cMap_Data
					push bc
					ld bc, #MAP_BYTES_SIZE
					ldir   ; ld (DE), (HL), then increments DE, HL, and decrements BC until BC = 0
					pop bc
__endasm;
				}
			}
			else if (cGameStatus == GM_STATUS_MISSION_CPLT)
			{
				cLevel++;
				iScore += (cScoretoAdd + SCORE_LEVELUP_POINTS);
			}
		} while (cGameStatus == GM_STATUS_CHANGE_MAP);

		// Level Up message
		if (cGameStatus == GM_STATUS_MISSION_CPLT)
		{
		  draw_level_up_message();
		}
	} while (cGameStatus != GM_STATUS_TIME_IS_OVER && cGameStatus != GM_STATUS_GAME_OVER && cGameStatus != GM_STATUS_PLAYER_WIN);
}  // void Run_Game()


void update_alien_tileset()
{
__asm
	; set the correct tile base address : _cAlienTileset + (dir * (12 * 2 * 8)) + (frame * (12 * 8))
	ld a, (#_sAlien + #2) ; dir(0, 1)
	dec a ; (255, 0)
	cpl   ; (0, 255)
	and #TS_ALIEN_SIZE * #8
	ld d, #0
	ld e, a
	ld a, (#_sAlien + #4) ; frame (0, 1)
	dec a ; (255, 0)
	cpl   ; (0, 255)
	and #TS_ALIEN_SIZE * #4
	add a, e
	jr nc, _add_no_carry
	inc d
_add_no_carry :
	ld e, a
	ld hl, #_cAlienTileset
	add hl, de
	ex de, hl

  ld hl, #UBOX_MSX_PATTBL_ADDR + (#TS_SCORE_SIZE + #GAME_ALIEN_TL_OFFSET) * #8
  call #0x0053  ; SETWRT - Sets the VRAM pointer(HL)
	call _set_new_alien_tileset

	ld hl, #UBOX_MSX_PATTBL_ADDR + (#TS_SCORE_SIZE + #GAME_ALIEN_TL_OFFSET + #256) * #8
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)
	call _set_new_alien_tileset

	ld hl, #UBOX_MSX_PATTBL_ADDR + (#TS_SCORE_SIZE + #GAME_ALIEN_TL_OFFSET + #512) * #8
	call #0x0053; SETWRT - Sets the VRAM pointer(HL)

_set_new_alien_tileset :
  ld h, d
	ld l, e
	;ld b, #TS_ALIEN_SIZE * #4
  ;ld c, #0x98
	ld bc, #0x6098
_lpOutiAlien :
  outi  ; write 1 bytes from (HL) to VRAM, decrement B and incremented HL
  jr nz, _lpOutiAlien
__endasm;
}  // void update_alien_tileset()


/*
* Unpack Alien tileset (right orientated) and pre-calculate left oriented tiles
* Plus unpack Game text
*/
void unpack_alien_tileset()
{
__asm
  ; unpack Game Text
  ld hl, #_gametext
  ld de, #_cGameText
  call _zx0_uncompress_asm_direct

	; unpack right oriented tileset (frame 0 & frame 1)
	ld hl, #_alien
	ld de, #_cAlienTileset
	call _zx0_uncompress_asm_direct

	; pre-calculate left oriented tileset (frame 2 & frame 3)
	ld de, #_cAlienTileset
	ld hl, #_cAlienTileset + #TS_ALIEN_SIZE * #8 + #3 * #8

	ld b, #3 * #2
_flip_full_pack :
	push bc
	ld b, #4
_flip_1_row :
	push bc
  ld b, #8
_flip_1_tile :
	push bc
	ld b, #8
	ld a, (de)
_flip_1_byte :
	rra
	rl c
	djnz _flip_1_byte
	ld (hl), c
	inc de
	inc hl
	pop bc
	djnz _flip_1_tile
	ld bc, #16
	xor a
	sbc hl, bc
	pop bc
  djnz _flip_1_row
	ld bc, #64
	add hl, bc
	pop bc
	djnz _flip_full_pack

__endasm;
}  // void unpack_alien_tileset()


void alien_randomize()
{
__asm
	ld b, #MAPS
	ld hl, #_cAlienActiveatScreen
_alien_rand_loop :
	; randomize (0-30: FALSE; 31-255: TRUE)
	ex de, hl
	call _randombyte
	ld a, l
	ex de, hl
	ld c, #BOOL_TRUE
	cp #31
	jr nc, _set_alien_random
	ld c, #BOOL_FALSE
_set_alien_random :
	ld (hl), c
	inc hl
	djnz _alien_rand_loop
__endasm;
}  // void alien_randomize()

/*
* Game over screen
*/
void draw_game_over()
{
__asm
  call _ubox_disable_screen
	ld hl, #_cGameStage
	ld (hl), #GAMESTAGE_GAMEOVER
	call _load_tileset
	ld	l, #BLANK_TILE
	call	_ubox_fill_screen
	call _ubox_enable_screen
	; mplayer_init(SONG, SONG_GAME_OVER);
	ld	hl, #_SONG
	ld a, #SONG_GAME_OVER
	call _mplayer_init_asm_direct
	ld a, #GAME_TEXT_GAME_OVER_ID
	call _search_text_block
	ld bc, #0x0701
_display_msg_and_wait :
	ld de, #0x0008
	call _display_format_text_block
	jp _wait_fire
__endasm;
}  // void draw_game_over()

/*
* Game win screen
* cGameStatus == GM_STATUS_TIME_IS_OVER - game win + player dead
* cGameStatus == GM_STATUS_PLAYER_WIN - game win
*/
void draw_game_win()
{
__asm
  ; ubox_set_colors(uint8_t fg, uint8_t bg, uint8_t border);
	call	_ubox_wait
	ld	de, #0x060D
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	call	_ubox_set_colors
	pop	af
	inc	sp
	call	_ubox_wait
  call _ubox_disable_screen
	ld hl, #_cGameStage
	ld (hl), #GAMESTAGE_FINAL
	call _load_tileset

	ld	l, #BLANK_TILE
	call	_ubox_fill_screen

	ld	de, #0x0101
	push	de
	push	de
	inc sp
	call	_ubox_set_colors
	pop	af
	inc	sp

	call _ubox_enable_screen
	ld	hl, #_SONG
	ld a, #SONG_SILENCE
	call _mplayer_init_asm_direct

	ld a, #GAME_TEXT_GAME_WIN_ID
	call _search_text_block
	ld bc, #0x0E01 ; Y and X
	ld de, #0x0008 ; SFX and Cycles
	call _display_format_text_block

	; rebuild Nostromo ship Tile map
	ld bc, #NOSTROMO_IMG_WIDTH * #NOSTROMO_IMG_HEIGHT
	ld hl, #_cBuffer
_reset_nostromo_map :
	xor a
	ld (hl), a
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, _reset_nostromo_map

  push ix
	ld e, #TS_FONT1_SIZE + #TS_FONT1_SIZE / #2
	ld hl, #_cBuffer
  ld ix, #_cNostromo_img_guide
_built_nostromo_loop :
	ld a, 0 (ix)
	cp #0xFF ; end of processing
	jr z, _end_rebuild_nostromo
	ld c, a
	ld b, #0
	add hl, bc
	inc ix
	ld b, 0 (ix)
_build_nostromo_tiles :
	ld (hl), e
	inc e
	inc hl
	djnz _build_nostromo_tiles
	inc ix
	jr _built_nostromo_loop

_end_rebuild_nostromo :
	pop ix

	ld b, #21 + #6 - #1 ; 21 tiles to move + 6 left blank tiles - 1st tile
	ld de, #UBOX_MSX_NAMTBL_ADDR + #32 ; X = 31, 30, 29, ..., Y = 0
	ld c, #0
_nostromo_animation_loop :
	dec de
	push de
	ld a, c
	cp #NOSTROMO_IMG_WIDTH
	jr nc, _cont_nostromo_loop
	inc c
_cont_nostromo_loop :
	push bc

	call _display_full_nostromo_image

	call _ubox_wait
	call _ubox_wait
	pop bc
	pop de
  djnz _nostromo_animation_loop

  ; TODO: SFX or not???

	; cBuffer contains Nostromo image (20 + 1[blank] x 13) tileset
	; Explosion step 1
	call _explosion_step_1
	call _ubox_wait
	call _ubox_wait
	ld a, #EXPLO_STEP2_TL_OFFSET
	call _explosion_step_2_3
	call _ubox_wait
	call _ubox_wait
	ld a, #EXPLO_STEP3_TL_OFFSET
	call _explosion_step_2_3
	call _ubox_wait
	call _ubox_wait
	ld a, #EXPLO_STEP4_TL_OFFSET
	ld hl, #_cBuffer + #5 * #NOSTROMO_IMG_WIDTH ; 6th line
	call _explosion_step_4
	ld a, #EXPLO_STEP4_TL_OFFSET + #4
	ld hl, #_cBuffer + #7 * #NOSTROMO_IMG_WIDTH ; 8th line
	call _explosion_step_4
	call _ubox_wait
	call _explosion_step_5
	; TODO: END SFX or not? ? ?

	ld a, (#_cGameStatus)
	cp #GM_STATUS_TIME_IS_OVER
	jr z, _rippley_is_dead
	; win message asking for rescue
	ld a, #GAME_TEXT_WIN_RESCUE_ID
	jr _draw_last_message
_rippley_is_dead :
  ; win message but rippley has died
	ld a, #GAME_TEXT_WIN_DEATH_ID
_draw_last_message :
	call _search_text_block
	ld bc, #0x1301 ; YY/XX
	jp _display_msg_and_wait

_explosion_step_1 :
	; ld b, #9
	; ld c, #2
	ld bc, #0x0902
_explosion_step1_loop1 :
  ld hl, #_cBuffer + #6 * #NOSTROMO_IMG_WIDTH ; 7th line
	ld d, #0
	ld e, b
	dec e
	add hl, de
	ld (hl), #EXPLO_STEP1_TL_OFFSET
	inc hl

	push bc
	ld b, c
_explosion_step1_loop2 :
  ld (hl), #EXPLO_STEP1_TL_OFFSET + #1
	inc hl
	djnz _explosion_step1_loop2

	ld (hl), #EXPLO_STEP1_TL_OFFSET + #2
	pop bc
	inc c
	inc c

	call _update_nostromo_explosion
	djnz _explosion_step1_loop1
	ret

_explosion_step_2_3 :
	; Explosion step 2 and step 3
	; ld b, #10
	; ld c, #2
	ld bc, #0x0A02
_explosion_step2_loop1 :
  ld hl, #_cBuffer + #6 * #NOSTROMO_IMG_WIDTH ; 7th line
	ld d, #0
	ld e, b
	dec e
	add hl, de

	push bc
	ld b, c
_explosion_step2_loop2 :
  ld (hl), a
	inc hl
	djnz _explosion_step2_loop2

	pop bc
	inc c
	inc c

	push af
	call _update_nostromo_explosion
	pop af
	djnz _explosion_step2_loop1
	ret

_explosion_step_4 :
	; Explosion step 4
	; ld b, #8
	; ld c, #2
	ld bc, #0x0802
_explosion_step4_loop1 :
	push hl
	push af
	ld d, #0
	ld e, b
	dec e
	add hl, de
	ld (hl), a
	inc hl
	inc a
	ld (hl), a
	inc hl
	inc a

	push bc
	ld b, c
_explosion_step4_loop2 :
  ld (hl), a
	inc hl
	djnz _explosion_step4_loop2

	inc a
	ld (hl), a
	inc hl
	sub a, #3
	ld (hl), a
	pop bc
	inc c
  inc c

	call _update_nostromo_explosion
	pop af
	pop hl
	djnz _explosion_step4_loop1
	ret

_explosion_step_5 :
	; Explosion step 5
  ; sub-step 5.1
	ld a, #EXPLO_STEP5_TL_OFFSET
	ld (#_cPowerTile), a
	inc a
	ld (#_cPowerTile + #1), a
	inc a
	ld (#_cPowerTile + #2), a
	call _explosion_anim

	; sub-step 5.2
  xor a ; BLANK_TILE
	ld (#_cPowerTile), a
	ld (#_cPowerTile + #1), a
	ld (#_cPowerTile + #2), a
	call _explosion_anim
  ret

_explosion_anim :
	ld hl, #_cBuffer + #6 * #NOSTROMO_IMG_WIDTH ; 7th line
	ld a, (#_cPowerTile + #1)
	call _fill_explosion_line

	ld b, #6
	ld de, #0x0000
_explosion_step5_loop :
	push bc
	push de
	push de

	ld hl, #_cBuffer + #5 * #NOSTROMO_IMG_WIDTH ; 6th line (base)
	xor a
	sbc hl, de
	ld a, (#_cPowerTile)
	call _fill_explosion_line

	ld hl, #_cBuffer + #7 * #NOSTROMO_IMG_WIDTH ; 8th line (base)
	pop de
	add hl, de
	ld a, (#_cPowerTile + #2)
	call _fill_explosion_line
 
  pop de
	ld a, #21
	add a, e
	ld e, a
  pop bc
	djnz _explosion_step5_loop
	ret

_fill_explosion_line :
	ld b, #20
_fill_explosion_line_loop :
	ld (hl), a
	inc hl
	djnz _fill_explosion_line_loop
	;ret

_update_nostromo_explosion :
	push bc
	ld de, #UBOX_MSX_NAMTBL_ADDR + #6
	ld c, #NOSTROMO_IMG_WIDTH - #1
	call _display_full_nostromo_image
	call _ubox_wait
	pop bc
	ret

_display_full_nostromo_image :
	ld b, #13
	ld hl, #_cBuffer
_nostromo_display_loop :
	push bc
	push hl
	push de
	ld b, #0
	call #0x005C ; LDIRVM - Block transfer to VRAM from memory
	pop hl
	ld bc, #32
	add hl, bc
	ex de, hl
	pop hl
	ld bc, #NOSTROMO_IMG_WIDTH
	add hl, bc
	pop bc
	djnz _nostromo_display_loop
__endasm;
}  // void draw_game_win()


/*
* main()
*/
void main(void)
{
	//  PAL: 50/2 = 25 FPS
	// NTSC: 60/2 = 30 FPS
	ubox_init_isr(2);
	
	// set screen 2
	ubox_set_mode(2);
	
	// all black
	ubox_set_colors(1, 1, 1);
	
	// reg 1: activate sprites, v-blank int on, 16x16 sprites
	ubox_wvdp(1, 0b11100010); //0xe2

	// init the music/fx player
	mplayer_init(SONG, SONG_SILENCE);
	mplayer_init_effects(EFFECTS);

  // attach the play function to ISR
	ubox_set_user_isr(mplayer_play);

	cCtrl = UBOX_MSX_CTL_NONE;

	// uncompress ALIEN tiles and pre-calculate right/left orientation tiles
	// also uncompress Game texts
	unpack_alien_tileset();

	// fill cTileClassLUT[] array with the correct Tile Class info
	setup_tileclass_LUT();

	while (true) // continuous loop - do not return to BASIC/BIOS
	{
		// global variable initialization - for every game start
		iScore = 0;
		cLives = INITIAL_LIVES;
		cPower = 100;  // starts with full power level
		cLevel = 1;    // at Level 1

		bIntroAnim = true;
		bFinalMeltdown = false;
		cGameStatus = GM_STATUS_LOOP_CONTINUE;

		// intro screen + selection menu (including Level selection)
		draw_intro_screen();
		
		// everytime you start a new game, randomize if Alien creature will be activated or not for each of the 15 'level 3' screens
		alien_randomize();

		// play the game from the selected Level until player WINS OR DIES
		Run_Game();

		if (cGameStatus == GM_STATUS_GAME_OVER)
		{
			draw_game_over();
		}
		else
		{
			// cGameStatus == GM_STATUS_TIME_IS_OVER - game win + player dead
			// cGameStatus == GM_STATUS_PLAYER_WIN   - game win
			draw_game_win();
		}
	}
}  // void main()
