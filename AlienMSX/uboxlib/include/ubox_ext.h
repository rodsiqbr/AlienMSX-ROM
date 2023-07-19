/*
 * ubox MSX lib extension
 * Copyright (C) 2021 by Rodrigo Siqueira
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

 /* EXTENSION FUNCTIONS - Rodrigo Siqueira May 2021 */

#ifndef _UBOX_EXT_MSX_H
#define _UBOX_EXT_MSX_H

// @Screen and VDP functions
//
// These functions are not necessarily MSX 1 specific, but only MSX 1
// functionality is documented.
//
// Both the tiles and sprite functions target Screen 2 (256x192 pixels graphics
// mode).
//
// The VRAM layout for Screen 2 is as follows:
//
// | Address range          | Desctiption         |
// | ---                    | ---                 |
// | <tt>0x0000-0x17ff</tt> | Background tiles    | Pattern Table - 6144 bytes (3 x 2048 bytes)
// | <tt>0x1800-0x1aff</tt> | Background tile map | Name Table - 768 bytes (256 x 192 bytes)
// | <tt>0x1b00-0x1b7f</tt> | Sprite attributes   |
// | <tt>0x2000-0x37ff</tt> | Background colors   | Color Table - 6144 bytes (3 x 2048 bytes)
// | <tt>0x3800-0x3fff</tt> | Sprite patterns     |
//

#define UBOX_MSX_PATTBL_ADDR 0x0000
#define UBOX_MSX_NAMTBL_ADDR 0x1800
#define UBOX_MSX_COLTBL_ADDR 0x2000

/**
 * Uncompress the data pointed by `src` into the memory pointed by `dst`.
 *
 * The compressed data is expected to be in ZX0 raw format.
 */
void zx0_uncompress(const uint8_t* dst, const uint8_t* src) __naked;

/**
 * Generates a 16bit pseudo-random number.
 * If seed=0 then the algorithm will use an auto-generated seed from last routine execution.
 * If seed!=0 then this seed value is used.
uint16_t msx_random(const uint8_t seed) __naked;
*/

uint8_t randombyte(void) __naked;

/**
 * Puts a tile block from (width x lenght) size from current tile set on the screen.
 * The innitial tile is identified by index `start_tile` and placed on position (`x`,`y`).
 * Tiles in the range [start_tile -> start_tile + (width * height) - 1] need to be in the sequence in TileSet
 * `x` and `y` units are tiles, and both are 0 based.
 */
void put_tile_block(uint8_t x, uint8_t y, uint8_t start_tile, uint8_t width, uint8_t height);

#endif // _UBOX_EXT_MSX_H
