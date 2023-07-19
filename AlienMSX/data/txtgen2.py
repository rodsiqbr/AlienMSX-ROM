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


def apultra_compress(data):
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
        out += ', '.join(["0x%02x" % int(b) for b in src[i:i + 8]]) + ",\n"
    return out

def find_name(data, name):
    for item in data:
        if item.get("name").lower() == name.lower():
            return item
    raise ValueError("%r not found" % name)

def main():

    parser = ArgumentParser(description="JSON Text importer",
                            epilog="Copyright (C) 2023 Rodrigo Siqueira",
                            )

    parser.add_argument(
        "--version", action="version", version="%(prog)s " + __version__)
    parser.add_argument("--aplib", dest="aplib", action="store_true",
                        help="APLIB compressed")
    parser.add_argument("--zx0", dest="zx0", action="store_true",
                        help="ZX0 compressed")
    parser.add_argument("txt_json", help="JSON Text file to import")
    parser.add_argument("id", help="variable name")

    args = parser.parse_args()

    if args.aplib and args.zx0:
        parser.error("Can't compress same text twice. Choose none, APLIB or ZX0")

    with open(args.txt_json, "rt") as fd:
        textfile = json.load(fd)

    objs = textfile[args.id.lower()]
    block = []
    for obj in objs:
        textmsg = obj["text"]
        textstr = str(textmsg)
#        print(textstr)
        for i in range(0, len(textstr)):
            if textstr[i] == '|':
                byte = 0
            else:
                byte = ord(textstr[i])
#                print(textstr[i])
            block.append(byte)
        

##    textmsg = [d["text"] for d in textfile[args.id]]
###    print(textmsg)
##    textstr = str(textmsg)
###    print(textstr)
##    block = []
##    for i in range(2, len(textstr)-2):
##        if textstr[i] == '|':
##            byte = 0
##        else:
##            byte = ord(textstr[i])
##        block.append(byte)
###    print(block)

    out = []
    
    if args.aplib:
        compressed = []
        compressed.extend(apultra_compress(block))
        out = compressed

    if args.zx0:
        compressed = []
        compressed.extend(zx0_compress(block))
        out = compressed

    print("#ifndef _TXT_%s_H" % args.id.upper())
    print("#define _TXT_%s_H\n" % args.id.upper())

    print("#define %s_SIZE %d\n" % (args.id.upper(), len(block)))

    if args.aplib:
        print("/* APLIB compressed */")
    elif args.zx0:
        print("/* ZX0 compressed */")
    else:
        print("/* RAW - not compressed */")
        out = block

    data_out = to_hex_list_str(out)
    print("#ifdef LOCAL")

    print("const unsigned char %s[%d] = {\n%s\n};\n" % (args.id, len(out), data_out))

    print("#else")
    print("extern const unsigned char * const %s[%d];\n" % (args.id, len(out)))

    print("#endif // LOCAL")
    print("#endif // _TXT_%s_H" % args.id.upper())



if __name__ == "__main__":
    try:
        main()
    except Exception as ex:
        print("FATAL: %s\n***" % ex, file=sys.stderr)
        traceback.print_exc(ex)
        sys.exit(1)
