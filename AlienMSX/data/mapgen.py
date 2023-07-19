#!/usr/bin/env python3

from argparse import ArgumentParser
from collections import defaultdict
from string import digits
from random import sample
from os import path
import json
import os
import subprocess
import struct
import sys
#import tempfile
import traceback

__version__ = "1.1"

DEF_ROOM_WIDTH = 32
DEF_ROOM_HEIGHT = 24
DEF_BITS = 8

DEF_MAP_CONF = "map_conf.json"
DEF_MAP_NAME = "Map"
DEF_TS_NAME = "default"
DEF_ENT_NAME = "Entities"

"""
Format:

            2 bytes: map data length (0 for empty map; no more data included)
            1 byte: entities length (1 is just the terminator 0xff)
            "map length" bytes: map data (n-bit per tile) H x W x n (may be compressed)
            "i" bytes: entity data (0xff for end)

Expected layers: Map and Entities
"""


def apultra_compress(data):
#    with tempfile.NamedTemporaryFile() as fd:
    filename = "".join(sample(digits, 10)) 
    with open(filename, "wb") as fd:
        fd.write(bytearray(data))
        fd.flush()
        fd.close()

    ap_name = filename + ".ap"
    subprocess.call(["apultra", "-v", filename, ap_name], stdout=sys.stderr)

    with open(ap_name, "rb") as fd:
        out = fd.read()

    os.unlink(ap_name)
    os.unlink(filename)

    return [int(byte) for byte in out]

def zx0_compress(data):
#    with tempfile.NamedTemporaryFile() as fd:
    filename = "".join(sample(digits, 10)) 
    with open(filename, "wb") as fd:
        fd.write(bytearray(data))
        fd.flush()
        fd.close()

        zx_name = filename + ".zx0"
        subprocess.call(["zx0", filename, zx_name], stdout=sys.stderr)

    with open(zx_name, "rb") as fd:
        out = fd.read()
        
    os.unlink(zx_name)
    os.unlink(filename)

    return [int(byte) for byte in out]

def find_name(data, name):
    for item in data:
        if item.get("name").lower() == name.lower():
            return item
    raise ValueError("%r not found" % name)


def find_id(data, id):
    for item in data:
        if item.get("id") == id:
            return item
    raise ValueError("id %r not found", id)


def get_property(obj, name, default):
    props = obj.get("properties", {})

    if isinstance(props, dict):
        return props.get(name, default)

    for p in props:
        if p["name"] == name:
            return p["value"]

    return default


def main():

    parser = ArgumentParser(description="Map importer",
                            epilog="Copyright (C) 2020 Juan J Martinez <jjm@usebox.net>",
                            )

    parser.add_argument(
        "--version", action="version", version="%(prog)s " + __version__)
    parser.add_argument(
        "--room-width", dest="rw", default=DEF_ROOM_WIDTH, type=int,
        help="room width (default: %s)" % DEF_ROOM_WIDTH)
    parser.add_argument(
        "--room-height", dest="rh", default=DEF_ROOM_HEIGHT, type=int,
        help="room height (default: %s)" % DEF_ROOM_HEIGHT)
    parser.add_argument("--max-ents", dest="max_ents", default=0, type=int,
                        help="max entities per room (default: unlimited)")
    parser.add_argument("--max-bytes", dest="max_bytes", default=0, type=int,
                        help="max bytes per room (default: unlimited)")
    parser.add_argument("-b", dest="bin", action="store_true",
                        help="output binary data (default: C code)")
    parser.add_argument("-d", dest="dir", default=".", type=str,
                        help="directory to generate the bin files (default: .)")
    parser.add_argument("-c", dest="conf", default=DEF_MAP_CONF, type=str,
                        help="JSON configuration file (default: %s)" % DEF_MAP_CONF)
    parser.add_argument("-m", dest="map_name", default=DEF_MAP_NAME, type=str,
                        help="Map layer name attribute (default: %s)" % DEF_MAP_NAME)
    parser.add_argument("-t", dest="ts_name", default=DEF_TS_NAME, type=str,
                        help="Tileset layer name attribute (default: %s)" % DEF_TS_NAME)
    parser.add_argument("-e", dest="ent_name", default=DEF_ENT_NAME, type=str,
                        help="Entity layer name attribute (default: %s)" % DEF_ENT_NAME)
    parser.add_argument("--aplib", dest="aplib", action="store_true",
                        help="APLIB compressed")
    parser.add_argument("--zx0", dest="zx0", action="store_true",
                        help="ZX0 compressed")
    parser.add_argument("-r", dest="reverse", action="store_true",
                        help="Reverse map order")
    parser.add_argument("-q", dest="quiet", action="store_true",
                        help="Don't output stats on stderr")
    parser.add_argument("map_json", help="JSON Map file to import")
    parser.add_argument("id", help="variable name")

    args = parser.parse_args()

    if args.aplib and args.zx0:
        parser.error("Can't compress same map twice. Choose none, APLIB or ZX0")

    with open(args.conf, "rt") as fd:
        conf = json.load(fd)

    et_names = [d["name"] for d in conf["entities"]]
    et_weigths = dict((d["name"], d["w"]) for d in conf["entities"])
    et_bytes = dict((d["name"], d["bytes"]) for d in conf["entities"])

    with open(args.map_json, "rt") as fd:
        data = json.load(fd)

    mh = data.get("height", 0)
    mw = data.get("width", 0)

    if mh < args.rh or mh % args.rh:
        parser.error("Map size height not multiple of the room size")
    if mw < args.rw or mw % args.rw:
        parser.error("Map size witdh not multiple of the room size")

    tilewidth = data["tilewidth"]
    tileheight = data["tileheight"]

    tile_layer = find_name(data["layers"], args.map_name)["data"]

    def_tileset = find_name(data["tilesets"], args.ts_name)
    firstgid = def_tileset.get("firstgid")

    out = []
    for y in range(0, mh, args.rh):
        for x in range(0, mw, args.rw):
            block = []
            for j in range(args.rh):
                for i in range(args.rw):
                    block.append(tile_layer[x + i + (y + j) * mw] - firstgid)

            # pack
            current = []
            for i in range(0, args.rh * args.rw, 8 // DEF_BITS):
                tiles = []
                for k in range(8 // DEF_BITS):
                    tiles.append(block[i + k])

                b = 0
                pos = 8
                for k in range(8 // DEF_BITS):
                    pos -= DEF_BITS
                    b |= (tiles[k] & ((2**DEF_BITS) - 1)) << pos

                current.append(b)

            out.append(current)

    # track empty maps
    empty = []
    for i, block in enumerate(out):
        if all([byte == 0xff for byte in block]):
            empty.append(i)

    # add the map header
    #for i in range(len(out)):
    #    if out[i] is None:
    #        continue
    #    size = len(out[i])
    #
    #    # ents size placeholder 0
    #    out[i] = [size & 0xff, size >> 8, 0] + out[i]

#start processing the entities

    entities_layer = find_name(data["layers"], args.ent_name)
    if len(entities_layer):
        map_ents = defaultdict(list)
        map_ents_w = defaultdict(int)
        map_ents_bytes = defaultdict(int)
        map_ents_names = set()

        def check_bytes(name):
            if name not in map_ents_names:
                # update the entity size in bytes count per map
                try:
                    map_ents_bytes[m] += et_bytes[name]
                    map_ents_names.add(name)
                except KeyError:
                    parser.error("max_bytes: no 'bytes' found for %r" % name)

        try:
            objs = entities_layer["objects"]
            objs.sort(key=lambda o: o["y"])
            objs.sort(key=lambda o: o["x"])
            objs.sort(key=lambda o: et_names.index(o["name"].lower()))
        except ValueError:
            parser.error("map has an unnamed object at '%s'" % args.conf)

        for obj in objs:
            name = obj["name"].lower()
            m = ((obj["x"] // tilewidth) // args.rw) \
                + (((obj["y"] // tileheight) // args.rh) * (mw // args.rw))
            x = obj["x"] % (args.rw * tilewidth)
            y = obj["y"] % (args.rh * tileheight)

            if name == "blocked":
                if obj["width"] > obj["height"]:
                    if y == 0:
                        # up blocked
                        out[m][1] |= (1 << 4)
                    else:
                        # down blocked
                        out[m][1] |= (1 << 5)
                else:
                    if x == 0:
                        # left blocked
                        out[m][1] |= (1 << 6)
                    else:
                        # right blocked
                        out[m][1] |= (1 << 7)
                continue

            t = et_names.index(name)
            # t=1: player
            # t=2: egg
            # t=3: animate
            # t=4: belt
            # t=5: dropper
            # t=6: gate
            # t=7: portal
            # t=8: wall
            # t=9: interactive
            # t=10: safeplace
            # t=11: forcefield
            # t=12: slider
            # t=13: locker

            special = None

# player: dd..tttt|x|y (3 bytes)
#          dd = direction: look right (0) / look left (1)
#          tttt = type (1)
#          x = x position (0 - 256)
#          y = y position (0 - 192)
            if name == "player":
                param = int(get_property(obj, "direction", 0))
                t |= (param << 6)

# egg: ....tttt|X|Y|....0100 (4 bytes)
#          tttt = type (2)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          0100 = width (4)
            if name == "egg":
                special = 0B00000100

# animate: cc..tttt|X|Y|ffff0001 (4 bytes)
#          cc = cycle#
#          tttt = type (3)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          ffff = frame#
#          0001 = width 1
            if name == "animate":
                cycle = int(get_property(obj, "cycle", 0))
                if cycle > 3:
                    cycle = 0
                frm = int(get_property(obj, "frame", 0))
                special = (frm << 4)
                special &= 0B11110000
                special |= 0B00000001
                t |= (cycle << 6)

# belt: dd..tttt|X|Y|....wwww (4 bytes)
#          dd = direction: anti-clockwise (0) / clockwise (1)
#          tttt = type (4)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          wwww = horizontal width
            if name == "belt":
                special = obj["width"] // 8
                dir = int(get_property(obj, "direction", 0))
                t |= (dir << 6)
            
# dropper: cc..tttt|X|Y|ffffhhhh (4 bytes)
#          cc = cycle (3)
#          tttt = type (5)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          ffff = frame#
#          hhhh = vertical Height
            if name == "dropper":
                special = obj["height"] // 8
                frm = int(get_property(obj, "frame", 0))
                special |= (frm << 4)
                cycle = int(get_property(obj, "cycle", 0))
                t |= (cycle << 6)

# gate: dKKKtttt|X|Y|TTTTwwww (4 bytes)
#          d = direction: vertical (0) / horizontal (1)
#          KKK = Key [0-6] (0=none, 1=key, 2=yellow cart, 3=green card, 4=red card, 5=tool, 6=??)
#          tttt = type (6)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          TTTT = time in seconds to close gate
#          wwww = horizontal/vertical width
            if name == "gate":
                key = int(get_property(obj, "key", 0))
                if key > 5:
                    key = 5
                t |= (key << 4)
                dir = int(get_property(obj, "direction", 0))
                t |= (dir << 7)
                special = 2
                timer = int(get_property(obj, "timer", 0))
                if timer > 15:
                    timer = 15
                special |= (timer << 4)

# portal: d...tttt|X|Y|DDDD0011 (4 bytes)
#          d = player direction in the destination portal: left (0) / right (1)
#          tttt = type (7)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          DDDD = screen destination (0 - 15, same level)
#          0011 = vertical width is always 3
            if name == "portal":
                special = 3
                position = int(get_property(obj, "position", 0))
                t |= (position << 7)
                dest = int(get_property(obj, "destination", 0))
                special |= (dest << 4)

# wall: ....tttt|X|Y|HHHH0010 (4 bytes)
#          tttt = type (8)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          HHHH = hardness: # of shots to break the wall
#          0010 = vertical width is always 2
            if name == "wall":
                hard = int(get_property(obj, "hard", 0))
                if hard > 15:
                    hard = 15
                special = 2
                special |= (hard << 4)

# interactive: aa..tttt|X|Y|eeee0001 (4 bytes)
#          aa = action (0=lights on/off, 1=locker open, 2=mission complete)
#          tttt = type (9)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          eeee = extra data [Locker ID, Mission #]
#          0001 =  width is always 1
            if name == "interactive":
                action = int(get_property(obj, "action", 0))
                t |= (action << 6)
                extra = int(get_property(obj, "extra", 0))
                if action == 2:
                    if extra > 4:
                        extra = 4
                if action == 1:
                    if extra > 15:
                        extra = 15
                special = 1
                special |= (extra << 4)

# safeplace: dd..tttt|x|y (3 bytes)
#          dd = direction: look right (0) / look left (1)
#          tttt = type (10)
#          x = x position (0 - 256)
#          y = y position (0 - 192)
            if name == "safeplace":
                param = int(get_property(obj, "direction", 0))
                t |= (param << 6)

# forcefield: 10..tttt|X|Y|....hhhh (4 bytes)
#          10 = cycle# always 2
#          tttt = type (11)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          hhhh = vertical Height (max 7)
            if name == "forcefield":
                special = obj["height"] // 8
                if special > 7:
                    special = 7
                t |= 0b10000000

# slider: dd..tttt|X|Y|llllwwww (4 bytes)
#          dd = direction: UP(0) / DOWN(1) / RIGHT(2) / LEFT(3)
#          tttt = type (12)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          llll = movement distance/lenght
#          wwww = horizontal width
            if name == "slider":
                special = obj["width"] // 8
                dist = int(get_property(obj, "lenght", 0))
                special |= (dist << 4)
                dir = int(get_property(obj, "direction", 0))
                t |= (dir << 6)

# locker: ....tttt|X|Y|IIII0010 (4 bytes)
#          tttt = type (8)
#          X = tile X (0-31)
#          Y = tile Y (0-23)
#          IIII = locker ID (0 - 15)
#          0010 = vertical width is always 2
            if name == "locker":
                LID = int(get_property(obj, "id", 0))
                if LID > 15:
                    LID = 15
                # TODO: garantir que não tenha 2 Lockers com o mesmo ID
                special = 2
                special |= (LID << 4)
            

            if args.max_ents:
                # update the entity count per map
                try:
                    map_ents_w[m] += et_weigths[name]
                except KeyError:
                    parser.error("max_ents: no 'w' found for %r" % name)

            if args.max_bytes:
                check_bytes(name)

            if name == "player" or name == "safeplace":
                map_ents[m].extend([t, x, y])
            else:
                XTile = x // 8
                YTile = y // 8
                map_ents[m].extend([t, XTile, YTile])

            if special is not None:
                if isinstance(special, (tuple, list)):
                    map_ents[m].extend(special)
                else:
                    map_ents[m].append(special)

        if args.max_ents:
            for i, weight in map_ents_w.items():
                if weight > args.max_ents:
                    parser.error("map %i has %d entities, max is %d" %
                                 (i, weight, args.max_ents))

        if args.max_bytes:
            for i, byts in map_ents_bytes.items():
                if byts > args.max_bytes:
                    parser.error("map %i entities are %d bytes, max is %d" %
                                 (i, byts, args.max_bytes))

        # append the entities to the map data
        for i in range(len(out)):
            if not out[i]:
                continue
            elif map_ents[i]:
                out[i].extend(map_ents[i])
                #out[i][2] += len(map_ents[i])
            # terminator
            out[i].append(0xff)
            #out[i][2] += 1

        if args.aplib:
            compressed = []
            for i, block in enumerate(out):
                if i in empty:
                    compressed.append(None)
                    continue
                compressed.append(apultra_compress(block))
            out = compressed

        if args.zx0:
            compressed = []
            for i, block in enumerate(out):
                if i in empty:
                    compressed.append(None)
                    continue
                compressed.append(zx0_compress(block))
            out = compressed

    if args.reverse:
        out.reverse()

    if args.bin:
        for i, block in enumerate(out):
            filename = path.join(args.dir, "%s%02d.bin" % (args.id, i))
            with open(filename, "wb") as fd:
                if i in empty:
                    fd.write(struct.pack("<B", 0))
                else:
                    fd.write(bytearray(block))

        if not args.quiet:
            screen_with_data = len(out) - len(empty)
            total_bytes = sum(len(b) if b else 0 for b in out)
            print("%s: %s (%d screens, %d bytes, %.2f bytes avg)" % (
                path.basename(sys.argv[0]), args.id,
                screen_with_data, total_bytes, total_bytes / screen_with_data),
                file=sys.stderr)
        return

    print("#ifndef _%s_H" % args.id.upper())
    print("#define _%s_H" % args.id.upper())
    if args.aplib:
        print("/* APLIB compressed */")
    elif args.zx0:
        print("/* ZX0 compressed */")
    else:
        print("/* RAW - not compressed */")
    print("#define WMAPS %d\n" % (mw // args.rw))
    print("#define MAPS %d\n" % len(out))

    print("#ifdef LOCAL")

    # includes a map table for fast access
    data_out = ""
    for i, block in enumerate(out):
        if not isinstance(block, list):
            continue
        data_out_part = ""
        for part in range(0, len(block), args.rw // 2):
            if data_out_part:
                data_out_part += ",\n"
            data_out_part += ', '.join(
                ["0x%02x" % byte for byte in block[part: part + args.rw // 2]])
        data_out += "const unsigned char %s_%d[%d] = {\n" % (
            args.id, i, len(block))
        data_out += data_out_part + "\n};\n"

    data_out += "const unsigned char * const %s[%d] = { " % (args.id, len(out))
    data_out += ', '.join(
        ["%s_%d" % (args.id,
                    i) if i not in empty else "(unsigned char *)0" for i in range(len(out))])
    data_out += " };\n"
    print(data_out)

    print("#else")
    print("extern const unsigned char * const %s[%d];\n" % (args.id, len(out)))

    print("#endif // LOCAL")
    print("#endif // _%s_H" % args.id.upper())

    if not args.quiet:
        screen_with_data = len(out) - len(empty)
        total_bytes = sum(len(b) if b else 0 for b in out)
        print("%s: %s (%d screens, %d bytes, %.2f bytes avg)" % (
            path.basename(sys.argv[0]), args.id,
            screen_with_data, total_bytes, total_bytes / screen_with_data),
            file=sys.stderr)


if __name__ == "__main__":
    try:
        main()
    except Exception as ex:
        print("FATAL: %s\n***" % ex, file=sys.stderr)
        traceback.print_exc(ex)
        sys.exit(1)
