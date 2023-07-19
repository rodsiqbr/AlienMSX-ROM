#!/usr/bin/env python3
#
# Copyright (C) 2019 by Juan J. Martinez <jjm@usebox.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

from argparse import ArgumentParser
from PIL import Image
from string import digits
from random import sample
from os import path
import os
import subprocess
import sys

__version__ = "1.1"
# Changes by Rodrigo Siqueira - Aug 2021
# ZX0 Compression
# APLIB Compression
# Non-RGB image support

DEF_W = 16
DEF_H = 16

#TRANS = (28, 28, 28)
TRANS = (32, 32, 32)

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

def to_hex_list_str(src):
    out = ""
    for i in range(0, len(src), 8):
        out += ', '.join(["0x%02x" % int(b) for b in src[i:i + 8]]) + ',\n'
    return out


def to_hex_list_str_asm(src):
    out = ""
    for i in range(0, len(src), 8):
        out += '\tdb ' + ', '.join(["#%02x" % b for b in src[i:i + 8]])
        out += '\n'
    return out


def main():

    parser = ArgumentParser(description="PNG to MSX spites",
                            epilog="Copyright (C) 2019 Juan J Martinez <jjm@usebox.net>",
                            )

    parser.add_argument(
        "--version", action="version", version="%(prog)s " + __version__)
    parser.add_argument("-i", "--id", dest="id", default="sprites", type=str,
                        help="variable name (default: sprites)")
    parser.add_argument("-a", "--asm", dest="asm", action="store_true",
                        help="ASM output (default: C header)")
    parser.add_argument("--aplib", dest="aplib", action="store_true",
                        help="APLIB compressed")
    parser.add_argument("--zx0", dest="zx0", action="store_true",
                        help="ZX0 compressed")

    parser.add_argument("image", help="image to convert")

    args = parser.parse_args()

    if args.aplib and args.zx0:
        parser.error("Can't compress same tileset twice. Choose APLIB or ZX0")

    try:
        image = Image.open(args.image)
    except IOError:
        parser.error("failed to open the image")

    if image.mode != "RGB":
        image = image.convert('RGB')
        
    if image.mode != "RGB":
        parser.error("not a RGB image (%s)" % (image.mode))

    (w, h) = image.size

    if w % DEF_W or h % DEF_H:
        parser.error("%s size is not multiple of sprite size (%s, %s)" %
                     (args.image, DEF_W, DEF_H))

    data = image.getdata()

    out = []
    fullsprite = []
    for y in range(0, h, DEF_H):
        for x in range(0, w, DEF_W):
            tile = [data[x + i + ((y + j) * w)]
                    for j in range(DEF_H) for i in range(DEF_W)]
            cols = set([c for c in tile if c != TRANS])

            if not cols:
                continue

            for c in cols:
                frame = []
                for i, j in ((0, 0), (0, 8), (8, 0), (8, 8)):
                    for m in range(8):
                        byte = 0
                        p = 7
                        for k in range(8):
                            b = 1 if tile[i + (j + m) * 16 + k] == c else 0
                            byte |= b << p
                            p -= 1
                        fullsprite.append(byte)
                        frame.append(byte)
                #print (frame)
                out.append(frame)

    #print(fullsprite)

    if args.aplib:
        compressed = []
        compressed.extend(apultra_compress(fullsprite))

    if args.zx0:
        compressed = []
        compressed.extend(zx0_compress(fullsprite))
 
    if args.asm:
        print("%s_LEN = %d" % (args.id.upper(), len(out) * 32))
        print("%s_FRAMES = %d\n" % (args.id.upper(), len(out)))
        print("%s:\n" % args.id)

        for i, frame in enumerate(out):
            print("%s_frame%d:" % (args.id, i))
            print(to_hex_list_str_asm(frame))
    else:
        print("#ifndef _%s_H" % args.id.upper())
        print("#define _%s_H\n" % args.id.upper())
        if args.aplib:
            print("/* APLIB compressed */")
        elif args.zx0:
            print("/* ZX0 compressed */")
        else:
            print("/* RAW - not compressed */")
        print("\n#define %s_LEN %d" % (args.id.upper(), len(out) * 32))
        print("#define %s_FRAMES %d" % (args.id.upper(), len(out)))
        print("#define %s_SIZE 32\n" % args.id.upper())

        data_out = ""
        print("#ifdef LOCAL")

        if args.aplib or args.zx0:
            data_out = to_hex_list_str(compressed)
            print("const unsigned char %s[%d] = {\n%s\n};\n" % (args.id, len(compressed), data_out))
            print("#else\n")
            print("extern const unsigned char %s[%d];" % (args.id, len(compressed)))
        else:
            for i, frame in enumerate(out):
                data_out += '{\n' + to_hex_list_str(frame) + '}'
                if i + 1 < len(out):
                    data_out += ',\n'

            print("const unsigned char %s[%d][%d] = {\n%s\n};\n" % (args.id, len(out), len(out[0]), data_out))

            print("#else\n")
            print("extern const unsigned char %s[%d][%d];" % (args.id, len(out), len(out[0])))


        print("#endif // LOCAL\n")
        print("#endif // _%s_H\n" % args.id.upper())

if __name__ == "__main__":
    main()
