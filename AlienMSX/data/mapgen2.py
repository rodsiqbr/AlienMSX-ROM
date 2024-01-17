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

__version__ = "2.0"

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

Expected default layers: Map and Entities
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

#            if name == "blocked":
#                if obj["width"] > obj["height"]:
#                    if y == 0:
#                        # up blocked
#                        out[m][1] |= (1 << 4)
#                    else:
#                        # down blocked
#                        out[m][1] |= (1 << 5)
#                else:
#                    if x == 0:
#                        # left blocked
#                        out[m][1] |= (1 << 6)
#                    else:
#                        # right blocked
#                        out[m][1] |= (1 << 7)
#                continue

            t = et_names.index(name)
            # t=1: player
            # t=2: safeplace
            # t=3: enemy
            # t=4: animate
            # t=5: belt
            # t=6: dropper
            # t=7: portal
            # t=8: forcefield
            # t=9: egg
            # t=10: gate
            # t=11: wall
            # t=12: interactive
            # t=13: slider
            # t=14: locker

            t = t << 4
            special = None
            XtraBits = 0

# player: tttt000d|x|y (3 bytes)
#          tttt = type (1)
#          d = direction: look right (0) / look left (1)
#          x = x position (0 - 256)
#          y = y position (0 - 192)
            if name == "player":
                param = int(get_property(obj, "direction", 0))
                if param > 1:
                    param = 1
                t |= param

# safeplace: tttt000d|x|y (3 bytes)
#          tttt = type (2)
#          d = direction: look right (0) / look left (1)
#          x = x position (0 - 256)
#          y = y position (0 - 192)
            if name == "safeplace":
                param = int(get_property(obj, "direction", 0))
                if param > 1:
                    param = 1
                t |= param

# enemy: ttttXXXX|XYYYYYcd|0IIIwwww (3 bytes)
#          tttt = type (3)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          c = enemy Class: facehug (0 - default) /  alien (1) 
#          d = direction: walk right (0) / walk left (1)
#          0III = Enemy ID (0-7)
#          wwww = width / 2 (wwww blocks of 16 pixels wide, 0 - 15)
            if name == "enemy":
                EnClass = int(get_property(obj, "class", 0))
                if EnClass > 1:
                    EnClass = 1
                XtraBits = int(get_property(obj, "direction", 0))
                if XtraBits > 1:
                    XtraBits = 1
                XtraBits |= (EnClass << 1)
                EnemID = int(get_property(obj, "id", 0))
                if EnemID > 7:
                    EnemID = 7
                # TODO: garantir que não tenha 2 Enemies com o mesmo ID na mesma tela
                special = obj["width"] // 16
                if special == 0:
                    special = 1
                if special > 15:
                    special = 15
                special |= (EnemID << 4)               
                
# animate: ttttXXXX|XYYYYYcc|0000ffff (3 bytes)
#          tttt = type (4)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          cc = cycle# (0-3)
#          ffff = frame#
            if name == "animate":
                XtraBits = int(get_property(obj, "cycle", 0))
                if XtraBits > 3:
                    XtraBits = 0 
                special = int(get_property(obj, "frame", 0))

# belt: ttttXXXX|XYYYYY0d|0000wwww (3 bytes)
#          tttt = type (5)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          d = direction: anti-clockwise (0) / clockwise (1)
#          wwww = horizontal width
            if name == "belt":
                XtraBits = int(get_property(obj, "direction", 0))
                if XtraBits > 1:
                    XtraBits = 1
                special = obj["width"] // 8
            
# dropper: ttttXXXX|XYYYYY00|ffffhhhh (3 bytes)
#          tttt = type (6)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          ffff = frame#
#          hhhh = vertical Height
            if name == "dropper":
                special = obj["height"] // 8
                frm = int(get_property(obj, "frame", 0))
                special |= (frm << 4)

# portal: ttttXXXX|XYYYYY0d|0000DDDD  (3 bytes)
#          tttt = type (7)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          d = player direction in the destination portal: left (0) / right (1)
#          DDDD = screen destination (0 - 15, same level)
            if name == "portal":
                XtraBits = int(get_property(obj, "position", 0))
                if XtraBits > 1:
                    XtraBits = 1
                special = int(get_property(obj, "destination", 0))
                if special > 15:
                    special = 15

# forcefield: ttttXXXX|XYYYYY0d|0000hhhh  (3 bytes)
#          tttt = type (8)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          d = direction: vertical (0 - default) / horizontal (1)
#          hhhh = vertical Height (max 7) / horizontal Height
            if name == "forcefield":
                XtraBits = int(get_property(obj, "direction", 0))
                if XtraBits > 1:
                    XtraBits = 1
                if XtraBits == 1:
                    special = obj["width"] // 8
                else:
                    special = obj["height"] // 8
                    if special > 7:
                        special = 7

# egg: ttttXXXX|XYYYYY00|00000III (3 bytes)
#          tttt = type (9)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          0III = egg ID (0-7) 
            if name == "egg":
                special = int(get_property(obj, "id", 0))
                if special > 7:
                    special = 7

# gate: ttttXXXX|XYYYYY0d|0KKKTTTT (3 bytes)
#          tttt = type (10)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          d = direction: vertical (0) / horizontal (1)
#          KKK = Key [0-6] (0=none, 1=key, 2=yellow cart, 3=green card, 4=red card, 5=tool)
#          TTTT = time in seconds to close gate
            if name == "gate":
                XtraBits = int(get_property(obj, "direction", 0))
                if XtraBits > 1:
                    XtraBits = 1
                key = int(get_property(obj, "key", 0))
                if key > 5:
                    key = 5
                special = int(get_property(obj, "timer", 0))
                if special > 15:
                    special = 15
                special |= (key << 4)

# wall: ttttXXXX|XYYYYY00|0000HHHH (3 bytes)
#          tttt = type (11)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          HHHH = hardness: # of shots to break the wall
            if name == "wall":
                special = int(get_property(obj, "hard", 0))
                if special > 15:
                    special = 15

# interactive: ttttXXXX|XYYYYYaa|0000eeee (3 bytes)
#          tttt = type (12)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          aa = action (0=lights on/off, 1=locker open, 2=mission complete, 3=collect & complete mission)
#          eeee = extra data [Locker ID(0-15), Mission #(0-4)]
            if name == "interactive":
                XtraBits = int(get_property(obj, "action", 0))
                if XtraBits > 3:
                    XtraBits = 3
                special = int(get_property(obj, "extra", 0))
                if XtraBits == 3:
                    if special > 4:
                        special = 4
                if XtraBits == 2:
                    if special > 4:
                        special = 4
                if XtraBits == 1:
                    if special > 15:
                        special = 15

# slider: ttttXXXX|XYYYYYdd|llllwwww (3 bytes)
#          tttt = type (13)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          dd = direction: UP(0) / DOWN(1) / RIGHT(2) / LEFT(3)
#          llll = movement distance/lenght
#          wwww = horizontal width
            if name == "slider":
                XtraBits = int(get_property(obj, "direction", 0))
                if XtraBits > 3:
                    XtraBits = 3
                special = obj["width"] // 8
                dist = int(get_property(obj, "lenght", 0))
                special |= (dist << 4)

# locker: ttttXXXX|XYYYYY00|0000IIII (3 bytes)
#          tttt = type (14)
#          XXXXX = tile X (0-31)
#          YYYYY = tile Y (0-23)
#          IIII = locker ID (0 - 15)
            if name == "locker":
                special = int(get_property(obj, "id", 0))
                if special > 15:
                    special = 15
                # TODO: garantir que não tenha 2 Lockers com o mesmo ID
            

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
                t |= ((x // 8) >> 1)
                if t == 255:
                    parser.error("Entity 1st byte cant be 0xFF. Check entity type %r" % name)
                t2 = (((x // 8) & 0B0000001) << 7) | (((y // 8) & 0B00011111) << 2) | XtraBits
                #print (t2)
                map_ents[m].extend([t, t2, special])

#            if special is not None:
#                if isinstance(special, (tuple, list)):
#                    map_ents[m].extend(special)
#                else:
#                    map_ents[m].append(special)

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
