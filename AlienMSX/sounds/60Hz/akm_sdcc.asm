PLY_AKM_REGISTERS_OFFSETVOLUME = .+1
PLY_AKM_DATA_OFFSETTRANSPOSITION = .+1
PLY_AKM_STOP_SOUNDS = .+1
PLY_AKM_USE_HOOKS = .+1
PLY_AKM_SOUNDEFFECTDATA_OFFSETINVERTEDVOLUME = .+2
PLY_AKM_DATA_OFFSETPTSTARTTRACK = .+2
PLY_AKM_START:
PLY_AKM_DATA_OFFSETWAITEMPTYCELL:
PLY_AKM_OFFSET2B:
PLY_AKM_OFFSET1B: jp PLY_AKM_INIT
PLY_AKM_SOUNDEFFECTDATA_OFFSETSPEED = .+1
PLY_AKM_DATA_OFFSETPTTRACK = .+1
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODLSB = .+2
PLY_AKM_SOUNDEFFECTDATA_OFFSETCURRENTSTEP: jp PLY_AKM_PLAY
PLY_AKM_DATA_OFFSETESCAPENOTE = .+1
PLY_AKM_DATA_OFFSETESCAPEINSTRUMENT = .+2
PLY_AKM_DATA_OFFSETBASENOTE: jp PLY_AKM_INITVARS_END
PLY_AKM_DATA_OFFSETPTINSTRUMENT = .+1
_PLY_AKM_INITSOUNDEFFECTS::
PLY_AKM_INITSOUNDEFFECTS:
PLY_AKM_DATA_OFFSETESCAPEWAIT:
PLY_AKM_DATA_OFFSETSECONDARYINSTRUMENT:
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODMSB: ld (PLY_AKM_PTSOUNDEFFECTTABLE),hl
PLY_AKM_DATA_OFFSETINSTRUMENTCURRENTSTEP: ret 
_PLY_AKM_PLAYSOUNDEFFECT::
PLY_AKM_PLAYSOUNDEFFECT:
PLY_AKM_DATA_OFFSETINSTRUMENTSPEED: dec a
PLY_AKM_DATA_OFFSETISPITCHUPDOWNUSED = .+1
PLY_AKM_DATA_OFFSETTRACKPITCHINTEGER = .+2
PLY_AKM_DATA_OFFSETTRACKINVERTEDVOLUME: ld hl,(PLY_AKM_PTSOUNDEFFECTTABLE)
    ld e,a
PLY_AKM_DATA_OFFSETTRACKPITCHSPEED = .+1
PLY_AKM_DATA_OFFSETTRACKPITCHDECIMAL: ld d,#0x0
    add hl,de
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld a,(de)
    inc de
    ex af,af'
    ld a,b
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    ld b,#0x0
    sla c
    sla c
    sla c
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),a
    inc hl
    ld (hl),#0x0
    inc hl
    ex af,af'
    ld (hl),a
    ret 
_PLY_AKM_STOPSOUNDEFFECTFROMCHANNEL::
PLY_AKM_STOPSOUNDEFFECTFROMCHANNEL: add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0x0
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    add hl,de
    ld (hl),d
    inc hl
    ld (hl),d
    ret 
PLY_AKM_PLAYSOUNDEFFECTSSTREAM: rla 
    rla 
    ld ix,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    ld c,a
    call PLY_AKM_PSES_PLAY
    ld ix,#PLY_AKM_CHANNEL2_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK2_REGISTERS
    srl c
    call PLY_AKM_PSES_PLAY
    ld ix,#PLY_AKM_CHANNEL3_SOUNDEFFECTDATA
    ld iy,#PLY_AKM_TRACK3_REGISTERS
    scf
    rr c
    call PLY_AKM_PSES_PLAY
    ld a,c
    ld (PLY_AKM_MIXERREGISTER),a
    ret 
PLY_AKM_PSES_PLAY: ld l,+0(ix)
    ld h,+1(ix)
    ld a,l
    or h
    ret z
PLY_AKM_PSES_READFIRSTBYTE: ld a,(hl)
    inc hl
    ld b,a
    rra 
    jr c,PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE
    rra 
    rra 
    jr c,PLY_AKM_PSES_S_ENDORLOOP
    call PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
    rl b
    call PLY_AKM_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
    set 2,c
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_S_ENDORLOOP: xor a
    ld +0(ix),a
    ld +1(ix),a
    ret 
PLY_AKM_PSES_SAVEPOINTERANDEXIT: ld a,+3(ix)
    cp +4(ix)
    jr c,PLY_AKM_PSES_NOTREACHED
    ld +3(ix),#0x0
    .db 0xdd
    .db 0x75
    .db 0x0
    .db 0xdd
    .db 0x74
    .db 0x1
    ret 
PLY_AKM_PSES_NOTREACHED:
PLY_AKM_ROM_BUFFERSIZE: inc +3(ix)
    ret 
PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE: rra 
    jr c,PLY_AKM_PSES_SOFTWAREANDHARDWARE
    call PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
    rl b
    call PLY_AKM_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL
    res 2,c
    call PLY_AKM_PSES_READSOFTWAREPERIOD
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SOFTWAREANDHARDWARE: call PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE
    call PLY_AKM_PSES_READSOFTWAREPERIOD
    res 2,c
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE: rra 
    and #0x7
    add a,#0x8
    ld (PLY_AKM_SETREG13),a
    set 5,c
    call PLY_AKM_PSES_READHARDWAREPERIOD
    ld a,#0x10
    jp PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD
PLY_AKM_PSES_READNOISEIFNEEDEDANDOPENORCLOSENOISECHANNEL: jr c,PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE
    set 5,c
    ret 
PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL_OPENNOISE: ld a,(hl)
    ld (PLY_AKM_NOISEREGISTER),a
    inc hl
    res 5,c
    ret 
PLY_AKM_PSES_READHARDWAREPERIOD: ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    ret 
PLY_AKM_PSES_READSOFTWAREPERIOD: ld a,(hl)
    ld +5(iy),a
    inc hl
    ld a,(hl)
    ld +9(iy),a
    inc hl
    ret 
PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS: and #0xf
PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD: sub +2(ix)
    jr nc,PLY_AKM_PSES_MVFA_NOOVERFLOW
    xor a
PLY_AKM_PSES_MVFA_NOOVERFLOW: ld +1(iy),a
    ret 
_PLY_AKM_INIT::
PLY_AKM_INIT: ld de,#PLY_AKM_PTINSTRUMENTS
    ldi
    ldi
    inc hl
    inc hl
    inc hl
    inc hl
    add a,a
    ld e,a
    ld d,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld ix,#PLY_AKM_INITVARS_START
    ld a,#0xd
PLY_AKM_INITVARS_LOOP: ld e,+0(ix)
    ld d,+1(ix)
    inc ix
    inc ix
    ldi
    dec a
    jr nz,PLY_AKM_INITVARS_LOOP
    ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    ex de,hl
    ld hl,#PLY_AKM_PTLINKER
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#PLY_AKM_TRACK1_WAITEMPTYCELL
    ld de,#PLY_AKM_TRACK1_TRANSPOSITION
    ld bc,#0x3e
    ld (hl),a
    ldir
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    ld a,(PLY_AKM_SPEED)
    dec a
    ld (PLY_AKM_TICKCOUNTER),a
    ld hl,(PLY_AKM_PTINSTRUMENTS)
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc de
    ld (PLY_AKM_TRACK1_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK2_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK3_PTINSTRUMENT),de
    ld hl,#0x0
    ld (PLY_AKM_CHANNEL1_SOUNDEFFECTDATA),hl
    ld (PLY_AKM_CHANNEL2_SOUNDEFFECTDATA),hl
    ld (PLY_AKM_CHANNEL3_SOUNDEFFECTDATA),hl
    ld ix,#PLY_AKM_REGISTERSFORROM
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    ld bc,#PLY_AKM_SENDPSGREGISTER
    ld de,#0x4
PLY_AKM_INITROM_LOOP: ld a,+0(ix)
    ld h,a
    inc ix
    and #0x3f
    ld +0(iy),a
    ld +1(iy),#0x0
    ld a,h
    and #0xc0
    jr nz,PLY_AKM_INITROM_SPECIAL
    ld +2(iy),c
    ld +3(iy),b
    add iy,de
    jr PLY_AKM_INITROM_LOOP
PLY_AKM_INITROM_SPECIAL: rl h
    jr c,PLY_AKM_INITROM_WRITEENDCODE
    ld bc,#PLY_AKM_SENDPSGREGISTERR13
    ld +2(iy),c
    ld +3(iy),b
    ld bc,#PLY_AKM_SENDPSGREGISTERAFTERPOP
    ld +4(iy),c
    ld +5(iy),b
    add iy,de
PLY_AKM_INITROM_WRITEENDCODE: ld bc,#PLY_AKM_SENDPSGREGISTEREND
    ld +2(iy),c
    ld +3(iy),b
    ret 
PLY_AKM_REGISTERSFORROM: .db 0x8
    .db 0x0
    .db 0x1
    .db 0x9
    .db 0x2
    .db 0x3
    .db 0xa
    .db 0x4
    .db 0x5
    .db 0x6
    .db 0x7
    .db 0xb
    .db 0x4c
PLY_AKM_INITVARS_START: .dw PLY_AKM_NOTEINDEXTABLE
    .dw PLY_AKM_NOTEINDEXTABLE+1
    .dw PLY_AKM_TRACKINDEX
    .dw PLY_AKM_TRACKINDEX+1
    .dw PLY_AKM_SPEED
    .dw PLY_AKM_PRIMARYINSTRUMENT
    .dw PLY_AKM_SECONDARYINSTRUMENT
    .dw PLY_AKM_PRIMARYWAIT
    .dw PLY_AKM_SECONDARYWAIT
    .dw PLY_AKM_DEFAULTSTARTNOTEINTRACKS
    .dw PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS
    .dw PLY_AKM_DEFAULTSTARTWAITINTRACKS
    .dw PLY_AKM_FLAGNOTEANDEFFECTINCELL
PLY_AKM_INITVARS_END:
_PLY_AKM_STOP::
PLY_AKM_STOP: ld (PLY_AKM_SAVESP),sp
    xor a
    ld (PLY_AKM_TRACK1_VOLUME),a
    ld (PLY_AKM_TRACK2_VOLUME),a
    ld (PLY_AKM_TRACK3_VOLUME),a
    ld a,#0xbf
    ld (PLY_AKM_MIXERREGISTER),a
    jp PLY_AKM_SENDPSG
_PLY_AKM_PLAY::
PLY_AKM_PLAY: ld (PLY_AKM_SAVESP),sp
    ld a,(PLY_AKM_SPEED)
    ld b,a
    ld a,(PLY_AKM_TICKCOUNTER)
    inc a
    cp b
    jp nz,PLY_AKM_TICKCOUNTERMANAGED
    ld a,(PLY_AKM_PATTERNREMAININGHEIGHT)
    sub #0x1
    jr c,PLY_AKM_LINKER
    ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    jr PLY_AKM_READLINE
PLY_AKM_LINKER: ld de,(PLY_AKM_TRACKINDEX)
    exx
    ld hl,(PLY_AKM_PTLINKER)
PLY_AKM_LINKERPOSTPT: xor a
    ld (PLY_AKM_TRACK1_WAITEMPTYCELL),a
    ld (PLY_AKM_TRACK2_WAITEMPTYCELL),a
    ld (PLY_AKM_TRACK3_WAITEMPTYCELL),a
    ld a,(PLY_AKM_DEFAULTSTARTNOTEINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPENOTE),a
    ld (PLY_AKM_TRACK2_ESCAPENOTE),a
    ld (PLY_AKM_TRACK3_ESCAPENOTE),a
    ld a,(PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK2_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK3_ESCAPEINSTRUMENT),a
    ld a,(PLY_AKM_DEFAULTSTARTWAITINTRACKS)
    ld (PLY_AKM_TRACK1_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK2_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK3_ESCAPEWAIT),a
    ld b,(hl)
    inc hl
    rr b
    jr nc,PLY_AKM_LINKERAFTERSPEEDCHANGE
    ld a,(hl)
    inc hl
    or a
    jr nz,PLY_AKM_LINKERSPEEDCHANGE
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jr PLY_AKM_LINKERPOSTPT
PLY_AKM_LINKERSPEEDCHANGE: ld (PLY_AKM_SPEED),a
PLY_AKM_LINKERAFTERSPEEDCHANGE: rr b
    jr nc,PLY_AKM_LINKERUSEPREVIOUSHEIGHT
    ld a,(hl)
    inc hl
    ld (PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT),a
    jr PLY_AKM_LINKERSETREMAININGHEIGHT
PLY_AKM_LINKERUSEPREVIOUSHEIGHT: ld a,(PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT)
PLY_AKM_LINKERSETREMAININGHEIGHT: ld (PLY_AKM_PATTERNREMAININGHEIGHT),a
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld (PLY_AKM_PTLINKER),hl
PLY_AKM_READLINE: ld de,(PLY_AKM_PTINSTRUMENTS)
    ld bc,(PLY_AKM_NOTEINDEXTABLE)
    exx
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_READTRACK
    xor a
PLY_AKM_TICKCOUNTERMANAGED: ld (PLY_AKM_TICKCOUNTER),a
    ld de,#PLY_AKM_PERIODTABLE
    exx
    ld c,#0xe0
    ld ix,#PLY_AKM_TRACK1_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK1_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    srl c
    ld ix,#PLY_AKM_TRACK2_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK2_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    scf
    rr c
    ld ix,#PLY_AKM_TRACK3_WAITEMPTYCELL
    call PLY_AKM_MANAGEEFFECTS
    ld iy,#PLY_AKM_TRACK3_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    ld a,c
    call PLY_AKM_PLAYSOUNDEFFECTSSTREAM
PLY_AKM_SENDPSG: ld sp,#PLY_AKM_TRACK1_REGISTERS
PLY_AKM_SENDPSGREGISTER: pop hl
PLY_AKM_SENDPSGREGISTERAFTERPOP: ld a,l
    out (0xa0),a
    ld a,h
    out (0xa1),a
    ret 
PLY_AKM_SENDPSGREGISTERR13: ld a,(PLY_AKM_SETREG13OLD)
    ld b,a
    ld a,(PLY_AKM_SETREG13)
    cp b
    jr z,PLY_AKM_SENDPSGREGISTEREND
    ld (PLY_AKM_SETREG13OLD),a
    ld h,a
    ld l,#0xd
    ret 
PLY_AKM_SENDPSGREGISTEREND: ld sp,(PLY_AKM_SAVESP)
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK: rr b
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_AFTERTRANSPOSITION
    ld a,(hl)
    ld +1(ix),a
    inc hl
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_AFTERTRANSPOSITION: rr b
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK
    ld a,(hl)
    inc hl
    sla a
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET
    exx
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    ld +2(ix),a
    ld +4(ix),a
    inc hl
    ld a,(hl)
    ld +3(ix),a
    ld +5(ix),a
    exx
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET: rra 
    ld d,a
    ld e,(hl)
    inc hl
    ld c,l
    ld a,h
    add hl,de
    .db 0xdd
    .db 0x75
    .db 0x2
    .db 0xdd
    .db 0x74
    .db 0x3
    .db 0xdd
    .db 0x75
    .db 0x4
    .db 0xdd
    .db 0x74
    .db 0x5
    ld l,c
    ld h,a
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK: ld a,+2(ix)
    ld +4(ix),a
    ld a,+3(ix)
    ld +5(ix),a
    ret 
PLY_AKM_READTRACK: ld a,+0(ix)
    sub #0x1
    jr c,PLY_AKM_RT_NOEMPTYCELL
    ld +0(ix),a
    ret 
PLY_AKM_RT_NOEMPTYCELL: ld l,+4(ix)
    ld h,+5(ix)
PLY_AKM_RT_GETDATABYTE: ld b,(hl)
    inc hl
    ld a,(PLY_AKM_FLAGNOTEANDEFFECTINCELL)
    ld c,a
    ld a,b
    and #0xf
    cp c
    jr c,PLY_AKM_RT_NOTEREFERENCE
    sub #0xc
    jr z,PLY_AKM_RT_NOTEANDEFFECTS
    dec a
    jr z,PLY_AKM_RT_NONOTEMAYBEEFFECTS
    dec a
    jr z,PLY_AKM_RT_NEWESCAPENOTE
    ld a,+7(ix)
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NEWESCAPENOTE: ld a,(hl)
    ld +7(ix),a
    inc hl
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NOTEANDEFFECTS: dec a
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    jr PLY_AKM_RT_GETDATABYTE
PLY_AKM_RT_NONOTEMAYBEEFFECTS: bit 4,b
    jr z,PLY_AKM_RT_READWAITFLAGS
    ld a,b
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
    jr PLY_AKM_RT_READWAITFLAGS
PLY_AKM_RT_NOTEREFERENCE: exx
    ld l,a
    ld h,#0x0
    add hl,bc
    ld a,(hl)
    exx
PLY_AKM_RT_AFTERNOTEREAD: add a,+1(ix)
    ld +6(ix),a
    ld a,b
    and #0x30
    jr z,PLY_AKM_RT_SAMEESCAPEINSTRUMENT
    cp #0x10
    jr z,PLY_AKM_RT_PRIMARYINSTRUMENT
    cp #0x20
    jr z,PLY_AKM_RT_SECONDARYINSTRUMENT
    ld a,(hl)
    inc hl
    ld +8(ix),a
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SAMEESCAPEINSTRUMENT: ld a,+8(ix)
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SECONDARYINSTRUMENT: ld a,(PLY_AKM_SECONDARYINSTRUMENT)
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_PRIMARYINSTRUMENT: ld a,(PLY_AKM_PRIMARYINSTRUMENT)
PLY_AKM_RT_STORECURRENTINSTRUMENT: exx
    add a,a
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld +13(ix),a
    .db 0xdd
    .db 0x75
    .db 0xa
    .db 0xdd
    .db 0x74
    .db 0xb
    exx
    xor a
    ld +12(ix),a
    ld +15(ix),a
    ld +16(ix),a
    ld +17(ix),a
PLY_AKM_RT_READWAITFLAGS: ld a,b
    and #0xc0
    jr z,PLY_AKM_RT_SAMEESCAPEWAIT
    cp #0x40
    jr z,PLY_AKM_RT_PRIMARYWAIT
    cp #0x80
    jr z,PLY_AKM_RT_SECONDARYWAIT
    ld a,(hl)
    inc hl
    ld +9(ix),a
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SAMEESCAPEWAIT: ld a,+9(ix)
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_PRIMARYWAIT: ld a,(PLY_AKM_PRIMARYWAIT)
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SECONDARYWAIT: ld a,(PLY_AKM_SECONDARYWAIT)
PLY_AKM_RT_STORECURRENTWAIT: ld +0(ix),a
    ld a,(PLY_AKM_RT_READEFFECTSFLAG)
    or a
    jr nz,PLY_AKM_RT_READEFFECTS
PLY_AKM_RT_AFTEREFFECTS: .db 0xdd
    .db 0x75
    .db 0x4
    .db 0xdd
    .db 0x74
    .db 0x5
    ret 
PLY_AKM_RT_READEFFECTS: xor a
    ld (PLY_AKM_RT_READEFFECTSFLAG),a
PLY_AKM_RT_READEFFECT: ld iy,#PLY_AKM_EFFECTTABLE
    ld b,(hl)
    ld a,b
    inc hl
    and #0xe
    ld e,a
    ld d,#0x0
    add iy,de
    ld a,b
    rra 
    rra 
    rra 
    rra 
    and #0xf
    jp (iy)
PLY_AKM_RT_READEFFECT_RETURN: bit 0,b
    jr nz,PLY_AKM_RT_READEFFECT
    jr PLY_AKM_RT_AFTEREFFECTS
PLY_AKM_RT_WAITLONG: ld a,(hl)
    inc hl
    ld +0(ix),a
    jr PLY_AKM_RT_CELLREAD
PLY_AKM_RT_WAITSHORT: ld a,b
    rlca 
    rlca 
    and #0x3
    ld +0(ix),a
PLY_AKM_RT_CELLREAD: .db 0xdd
    .db 0x75
    .db 0x4
    .db 0xdd
    .db 0x74
    .db 0x5
    ret 
PLY_AKM_MANAGEEFFECTS: ld a,+15(ix)
    or a
    jr z,PLY_AKM_ME_PITCHUPDOWNFINISHED
    ld l,+18(ix)
    ld h,+16(ix)
    ld e,+19(ix)
    ld d,+20(ix)
    ld a,+17(ix)
    bit 7,d
    jr nz,PLY_AKM_ME_PITCHUPDOWN_NEGATIVESPEED
PLY_AKM_ME_PITCHUPDOWN_POSITIVESPEED: add hl,de
    adc a,#0x0
    jr PLY_AKM_ME_PITCHUPDOWN_SAVE
PLY_AKM_ME_PITCHUPDOWN_NEGATIVESPEED: res 7,d
    or a
    sbc hl,de
    sbc a,#0x0
PLY_AKM_ME_PITCHUPDOWN_SAVE: ld +17(ix),a
    .db 0xdd
    .db 0x75
    .db 0x12
    .db 0xdd
    .db 0x74
    .db 0x10
PLY_AKM_ME_PITCHUPDOWNFINISHED: ret 
PLY_AKM_PLAYSOUNDSTREAM: ld l,+10(ix)
    ld h,+11(ix)
PLY_AKM_PSS_READFIRSTBYTE: ld a,(hl)
    ld b,a
    inc hl
    rra 
    jr c,PLY_AKM_PSS_SOFTORSOFTANDHARD
    rra 
    jr c,PLY_AKM_PSS_SOFTWARETOHARDWARE
    rra 
    jr nc,PLY_AKM_PSS_NSNH_NOTENDOFSOUND
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    .db 0xdd
    .db 0x75
    .db 0xa
    .db 0xdd
    .db 0x74
    .db 0xb
    jr PLY_AKM_PSS_READFIRSTBYTE
PLY_AKM_PSS_NSNH_NOTENDOFSOUND: set 2,c
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld +1(iy),a
    rl b
    call c,PLY_AKM_PSS_READNOISE
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTORSOFTANDHARD: rra 
    jr c,PLY_AKM_PSS_SOFTANDHARD
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld +1(iy),a
    ld d,#0x0
    rl b
    jr nc,PLY_AKM_PSS_S_AFTERARPANDORNOISE
    ld a,(hl)
    inc hl
    sra a
    ld d,a
    call c,PLY_AKM_PSS_READNOISE
PLY_AKM_PSS_S_AFTERARPANDORNOISE: ld a,d
    call PLY_AKM_CALCULATEPERIODFORBASENOTE
    rl b
    call c,PLY_AKM_READPITCHANDADDTOPERIOD
    exx
    ld +5(iy),l
    ld +9(iy),h
    exx
PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER: ld a,+12(ix)
    cp +13(ix)
    jr nc,PLY_AKM_PSS_S_SPEEDREACHED
    inc +12(ix)
    ret 
PLY_AKM_PSS_S_SPEEDREACHED: .db 0xdd
    .db 0x75
    .db 0xa
    .db 0xdd
    .db 0x74
    .db 0xb
    ld +12(ix),#0x0
    ret 
PLY_AKM_PSS_SOFTANDHARD: call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTWARETOHARDWARE: call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,b
    rlca 
    rlca 
    rlca 
    rlca 
    and #0x7
    exx
    jr z,PLY_AKM_PSS_STH_RATIOEND
PLY_AKM_PSS_STH_RATIOLOOP: srl h
    rr l
    dec a
    jr nz,PLY_AKM_PSS_STH_RATIOLOOP
    jr nc,PLY_AKM_PSS_STH_RATIOEND
    inc hl
PLY_AKM_PSS_STH_RATIOEND: ld a,l
    ld (PLY_AKM_REG11),a
    ld a,h
    ld (PLY_AKM_REG12),a
    exx
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV: and #0x2
    add a,#0x8
    ld (PLY_AKM_SETREG13),a
    ld +1(iy),#0x10
    xor a
    call PLY_AKM_CALCULATEPERIODFORBASENOTE
    exx
    ld +5(iy),l
    ld +9(iy),h
    exx
    ret 
PLY_AKM_PSS_SHARED_ADJUSTVOLUME: and #0xf
    sub +14(ix)
    ret nc
    xor a
    ret 
PLY_AKM_PSS_READNOISE: ld a,(hl)
    inc hl
    ld (PLY_AKM_NOISEREGISTER),a
    res 5,c
    ret 
PLY_AKM_CALCULATEPERIODFORBASENOTE: exx
    ld h,#0x0
    add a,+6(ix)
    ld bc,#0xff0c
PLY_AKM_FINDOCTAVE_LOOP: inc b
    sub c
    jr nc,PLY_AKM_FINDOCTAVE_LOOP
    add a,c
    add a,a
    ld l,a
    ld h,#0x0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,b
    or a
    jr z,PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP: srl h
    rr l
    djnz PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED: jr nc,PLY_AKM_FINDOCTAVE_FINISHED
    inc hl
PLY_AKM_FINDOCTAVE_FINISHED: ld c,+16(ix)
    ld b,+17(ix)
    add hl,bc
    exx
    ret 
PLY_AKM_READPITCHANDADDTOPERIOD: ld a,(hl)
    inc hl
    exx
    ld c,a
    exx
    ld a,(hl)
    inc hl
    exx
    ld b,a
    add hl,bc
    exx
    ret 
PLY_AKM_EFFECTVOLUME: ld +14(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTTABLE: jr PLY_AKM_EFFECTTABLE
    jr PLY_AKM_EFFECTVOLUME
    jr PLY_AKM_EFFECTPITCHUPDOWN
    jr PLY_AKM_EFFECTTABLE+6
    jr PLY_AKM_EFFECTPITCHUPDOWN-6
    jr PLY_AKM_EFFECTPITCHUPDOWN-4
    jr PLY_AKM_EFFECTPITCHUPDOWN-2
PLY_AKM_EFFECTPITCHUPDOWN: rra 
    jr nc,PLY_AKM_EFFECTPITCHUPDOWN_DEACTIVATED
    ld +15(ix),#0xff
    ld a,(hl)
    inc hl
    ld +19(ix),a
    ld a,(hl)
    inc hl
    ld +20(ix),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTPITCHUPDOWN_DEACTIVATED: ld +15(ix),#0x0
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTREADIFESCAPE: cp #0xf
    ret c
    ld a,(hl)
    inc hl
    ret 
PLY_AKM_PERIODTABLE: .dw 0x1a7a
    .dw 0x18fe
    .dw 0x1797
    .dw 0x1644
    .dw 0x1504
    .dw 0x13d6
    .dw 0x12b9
    .dw 0x11ac
    .dw 0x10ae
    .dw 0xfbe
    .dw 0xedc
    .dw 0xe07
PLY_AKM_END:
_PLY_AKM_ISSOUNDEFFECTON::
PLY_AKM_ISSOUNDEFFECTON: ld a,l
    add a,a
    add a,a
    add a,a
    ld c,a
    ld b,#0x0
    ld hl,#PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    add hl,bc
    ld a,(hl)
    inc hl
    or (hl)
    ld l,a
    ret 
_SONG::
ALIENMSXSONGFILE_START:
_ALIENMSXSONGFILE_START:: .dw ALIENMSXSONGFILE_INSTRUMENTINDEXES
    .dw 0x0
    .dw 0x0
    .dw ALIENMSXSONGFILE_ARPEGGIOINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG1
    .dw ALIENMSXSONGFILE_SUBSONG2
    .dw ALIENMSXSONGFILE_SUBSONG3
    .dw ALIENMSXSONGFILE_SUBSONG4
    .dw ALIENMSXSONGFILE_SUBSONG5
ALIENMSXSONGFILE_INSTRUMENTINDEXES: .dw ALIENMSXSONGFILE_INSTRUMENT0
    .dw ALIENMSXSONGFILE_INSTRUMENT1
    .dw ALIENMSXSONGFILE_INSTRUMENT2
    .dw ALIENMSXSONGFILE_INSTRUMENT3
    .dw ALIENMSXSONGFILE_INSTRUMENT4
    .dw ALIENMSXSONGFILE_INSTRUMENT5
    .dw ALIENMSXSONGFILE_INSTRUMENT6
    .dw ALIENMSXSONGFILE_INSTRUMENT7
    .dw ALIENMSXSONGFILE_INSTRUMENT8
    .dw ALIENMSXSONGFILE_INSTRUMENT9
    .dw ALIENMSXSONGFILE_INSTRUMENT10
    .dw ALIENMSXSONGFILE_INSTRUMENT11
    .dw ALIENMSXSONGFILE_INSTRUMENT12
    .dw ALIENMSXSONGFILE_INSTRUMENT13
    .dw ALIENMSXSONGFILE_INSTRUMENT14
    .dw ALIENMSXSONGFILE_INSTRUMENT15
    .dw ALIENMSXSONGFILE_INSTRUMENT16
    .dw ALIENMSXSONGFILE_INSTRUMENT17
    .dw ALIENMSXSONGFILE_INSTRUMENT18
    .dw ALIENMSXSONGFILE_INSTRUMENT19
    .dw ALIENMSXSONGFILE_INSTRUMENT20
ALIENMSXSONGFILE_INSTRUMENT0: .db 0xff
ALIENMSXSONGFILE_INSTRUMENT0LOOP: .db 0x0
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT1: .db 0x0
ALIENMSXSONGFILE_INSTRUMENT1LOOP: .db 0x29
    .db 0x29
    .db 0x29
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT1LOOP
ALIENMSXSONGFILE_INSTRUMENT2: .db 0x0
ALIENMSXSONGFILE_INSTRUMENT2LOOP: .db 0x25
    .db 0x25
    .db 0x25
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT2LOOP
ALIENMSXSONGFILE_INSTRUMENT3: .db 0x0
ALIENMSXSONGFILE_INSTRUMENT3LOOP: .db 0x1d
    .db 0x1d
    .db 0x1d
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT3LOOP
ALIENMSXSONGFILE_INSTRUMENT4: .db 0x0
ALIENMSXSONGFILE_INSTRUMENT4LOOP: .db 0x25
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT4LOOP
ALIENMSXSONGFILE_INSTRUMENT5: .db 0x0
    .db 0x29
    .db 0x29
    .db 0x25
    .db 0x25
    .db 0x25
    .db 0x21
    .db 0x21
    .db 0x21
    .db 0x21
    .db 0x1d
    .db 0x1d
    .db 0x1d
    .db 0x19
    .db 0x19
    .db 0x15
    .db 0x15
    .db 0x11
    .db 0xd
    .db 0xd
    .db 0x9
    .db 0x5
    .db 0x5
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT6: .db 0x0
    .db 0x29
    .db 0x29
    .db 0x29
    .db 0x29
    .db 0x25
    .db 0x25
    .db 0x25
    .db 0x25
    .db 0x21
    .db 0x21
    .db 0x21
    .db 0x1d
    .db 0x1d
    .db 0x19
    .db 0x19
    .db 0x15
    .db 0x15
    .db 0x11
    .db 0xd
    .db 0xd
    .db 0x9
    .db 0x5
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT7: .db 0x0
    .db 0x3d
    .db 0x39
    .db 0x35
    .db 0x31
    .db 0x2d
    .db 0x29
    .db 0x25
    .db 0x21
    .db 0x1d
    .db 0x19
    .db 0x15
    .db 0x11
    .db 0xd
    .db 0x9
    .db 0x5
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT8: .db 0x4
    .db 0x3d
    .db 0x39
    .db 0x35
    .db 0x31
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x2d
    .db 0x25
    .db 0x21
    .db 0x1d
    .db 0x19
    .db 0x15
    .db 0x11
    .db 0xd
    .db 0x9
    .db 0x5
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT9: .db 0x0
    .db 0xbd
    .db 0x31
    .db 0xf
    .db 0xbd
    .db 0x19
    .db 0x8
    .db 0xb9
    .db 0x11
    .db 0x1
    .db 0xb9
    .db 0xa
    .db 0xb5
    .db 0x8
    .db 0xb5
    .db 0x6
    .db 0xb5
    .db 0x4
    .db 0xb1
    .db 0x2
    .db 0x71
    .db 0xfd
    .db 0xff
    .db 0x71
    .db 0xfe
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x2d
    .db 0x2d
    .db 0x29
    .db 0x29
ALIENMSXSONGFILE_INSTRUMENT9LOOP: .db 0x71
    .db 0xfc
    .db 0xff
    .db 0x71
    .db 0xf8
    .db 0xff
    .db 0x71
    .db 0xf0
    .db 0xff
    .db 0x6d
    .db 0xf2
    .db 0xff
    .db 0x6d
    .db 0xf4
    .db 0xff
    .db 0x6d
    .db 0xf6
    .db 0xff
    .db 0x69
    .db 0xf8
    .db 0xff
    .db 0x69
    .db 0xfa
    .db 0xff
    .db 0x69
    .db 0xfb
    .db 0xff
    .db 0x69
    .db 0xfc
    .db 0xff
    .db 0x69
    .db 0xfd
    .db 0xff
    .db 0x69
    .db 0xfe
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x6d
    .db 0xff
    .db 0xff
    .db 0x2d
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT9LOOP
ALIENMSXSONGFILE_INSTRUMENT10: .db 0x0
ALIENMSXSONGFILE_INSTRUMENT10LOOP: .db 0x52
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT10LOOP
ALIENMSXSONGFILE_INSTRUMENT11: .db 0x0
    .db 0xbd
    .db 0x31
    .db 0x1f
    .db 0xbd
    .db 0x19
    .db 0x18
    .db 0xbd
    .db 0x13
    .db 0x10
    .db 0xbd
    .db 0xf
    .db 0x8
    .db 0xbd
    .db 0xd
    .db 0x8
    .db 0xbd
    .db 0xb
    .db 0x5
    .db 0xbd
    .db 0x9
    .db 0x4
    .db 0xbd
    .db 0x7
    .db 0x3
    .db 0xbd
    .db 0x5
    .db 0x3
    .db 0xbd
    .db 0x3
    .db 0x2
    .db 0xbd
    .db 0x1
    .db 0x2
    .db 0xbd
    .db 0x1
    .db 0x2
    .db 0xf0
    .db 0x1
    .db 0xf0
    .db 0x1
    .db 0xf0
    .db 0x1
    .db 0xe8
    .db 0x1
    .db 0xe8
    .db 0x1
    .db 0xe8
    .db 0x1
    .db 0xe0
    .db 0x1
    .db 0xe0
    .db 0x1
    .db 0xe0
    .db 0x1
    .db 0xd8
    .db 0x1
    .db 0xd8
    .db 0x1
    .db 0xd8
    .db 0x1
    .db 0xd0
    .db 0x1
    .db 0xd0
    .db 0x1
    .db 0xd0
    .db 0x1
    .db 0xc8
    .db 0x1
    .db 0xc8
    .db 0x1
    .db 0xc8
    .db 0x1
    .db 0xc0
    .db 0x1
    .db 0xc0
    .db 0x1
    .db 0xc0
    .db 0x1
    .db 0xb8
    .db 0x1
    .db 0xb8
    .db 0x1
    .db 0xb8
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT12: .db 0x0
    .db 0xa9
    .db 0x18
    .db 0x39
    .db 0x31
    .db 0x29
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT13: .db 0x0
    .db 0xb1
    .db 0x30
    .db 0xb5
    .db 0x26
    .db 0xb9
    .db 0x1e
    .db 0xb9
    .db 0x18
    .db 0xb9
    .db 0xe
    .db 0xb9
    .db 0x6
    .db 0x39
    .db 0xad
    .db 0x30
    .db 0xad
    .db 0x26
    .db 0xad
    .db 0x1e
    .db 0xad
    .db 0x18
    .db 0xad
    .db 0xe
    .db 0xad
    .db 0x6
    .db 0x2d
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT14: .db 0x0
    .db 0x31
    .db 0x35
    .db 0x39
    .db 0xb9
    .db 0x6
    .db 0xb9
    .db 0xe
    .db 0xb9
    .db 0x18
    .db 0xb9
    .db 0x18
    .db 0x2d
    .db 0x2d
    .db 0xad
    .db 0x6
    .db 0xad
    .db 0xe
ALIENMSXSONGFILE_INSTRUMENT14LOOP: .db 0xdd
    .db 0x18
    .db 0x1
    .db 0x0
    .db 0xdd
    .db 0x18
    .db 0xff
    .db 0xff
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT14LOOP
ALIENMSXSONGFILE_INSTRUMENT15: .db 0x0
    .db 0x31
    .db 0x35
ALIENMSXSONGFILE_INSTRUMENT15LOOP: .db 0x6d
    .db 0x8
    .db 0x0
    .db 0x6d
    .db 0xf8
    .db 0xff
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT15LOOP
ALIENMSXSONGFILE_INSTRUMENT16: .db 0x0
    .db 0xb1
    .db 0x1e
    .db 0xb5
    .db 0x18
    .db 0xb9
    .db 0xe
    .db 0xbd
    .db 0x6
    .db 0x3d
    .db 0x3d
    .db 0xb9
    .db 0x6
    .db 0xb9
    .db 0x6
    .db 0xb5
    .db 0xe
    .db 0xb5
    .db 0xe
    .db 0x31
    .db 0x31
    .db 0xad
    .db 0x6
    .db 0xad
    .db 0x6
    .db 0xa9
    .db 0xe
    .db 0xa9
    .db 0xe
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT17: .db 0x0
    .db 0xb1
    .db 0x1f
    .db 0x8
    .db 0xb5
    .db 0x19
    .db 0x7
    .db 0xb9
    .db 0xf
    .db 0x6
    .db 0xbd
    .db 0x7
    .db 0x5
    .db 0xbd
    .db 0x1
    .db 0x4
    .db 0xbd
    .db 0x1
    .db 0x3
    .db 0xb9
    .db 0x7
    .db 0x2
    .db 0xb9
    .db 0x7
    .db 0x1
    .db 0xb5
    .db 0xe
    .db 0xb5
    .db 0xe
    .db 0x31
    .db 0x31
    .db 0xad
    .db 0x6
    .db 0xad
    .db 0x6
    .db 0xa9
    .db 0xe
    .db 0xa9
    .db 0xe
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT18: .db 0x0
    .db 0xa9
    .db 0x19
    .db 0x5
    .db 0xb9
    .db 0x1
    .db 0x4
    .db 0xb1
    .db 0x1
    .db 0x3
    .db 0xa9
    .db 0x1
    .db 0x2
    .db 0x0
    .db 0x0
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_INSTRUMENT19: .db 0x0
    .db 0xa5
    .db 0x18
    .db 0xa9
    .db 0x6
    .db 0xad
    .db 0x4
    .db 0xb1
    .db 0x18
    .db 0xb1
    .db 0x2
    .db 0xb1
    .db 0x2
    .db 0xad
    .db 0x18
    .db 0x29
ALIENMSXSONGFILE_INSTRUMENT19LOOP: .db 0x25
    .db 0xa1
    .db 0x18
    .db 0x5d
    .db 0xff
    .db 0xff
    .db 0x5d
    .db 0xff
    .db 0xff
    .db 0xa1
    .db 0x18
    .db 0x21
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT19LOOP
ALIENMSXSONGFILE_INSTRUMENT20: .db 0x0
    .db 0xbd
    .db 0x31
    .db 0x1
    .db 0xbd
    .db 0x19
    .db 0x1
    .db 0xbd
    .db 0x13
    .db 0x1
    .db 0xbd
    .db 0x11
    .db 0x1
    .db 0xbd
    .db 0xf
    .db 0x1
    .db 0xbd
    .db 0xd
    .db 0x1
    .db 0xbd
    .db 0xb
    .db 0x1
    .db 0xbd
    .db 0x9
    .db 0x1
    .db 0xb9
    .db 0x7
    .db 0x1
    .db 0xb5
    .db 0x5
    .db 0x1
    .db 0xb1
    .db 0x3
    .db 0x1
    .db 0xad
    .db 0x1
    .db 0x1
    .db 0xd0
    .db 0x1
    .db 0xc8
    .db 0x1
    .db 0xc0
    .db 0x1
    .db 0xb8
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x4
    .dw ALIENMSXSONGFILE_INSTRUMENT0LOOP
ALIENMSXSONGFILE_ARPEGGIOINDEXES:
ALIENMSXSONGFILE_PITCHINDEXES:
ALIENMSXSONGFILE_SUBSONG0: .dw ALIENMSXSONGFILE_SUBSONG0_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACKINDEXES
    .db 0x3
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0x46
    .db 0x6
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG0_LOOP: .db 0xba
    .db 0xf
    .db 0x81
    .db 0xc
    .db 0x81
    .db 0x80
    .db 0x84
    .db 0x18
    .db 0x82
    .db 0xc4
    .db 0x0
    .db 0x3
    .db 0x80
    .db 0x84
    .db 0x18
    .db 0x82
    .db 0xc4
    .db 0x0
    .db 0x5
    .db 0x80
    .db 0x84
    .db 0x18
    .db 0x82
    .db 0xfc
    .db 0x0
    .db 0x85
    .db 0x2
    .db 0x85
    .db 0x8
    .db 0x80
    .db 0xf8
    .db 0x86
    .db 0x0
    .db 0x86
    .db 0x0
    .db 0x88
    .db 0xb8
    .db 0x84
    .db 0xf4
    .db 0x84
    .db 0x80
    .db 0xa8
    .db 0x89
    .db 0x89
    .db 0x82
    .db 0xe8
    .db 0x84
    .db 0x84
    .db 0x3
    .db 0x80
    .db 0xa8
    .db 0x87
    .db 0x87
    .db 0x82
    .db 0xe8
    .db 0x8a
    .db 0x8a
    .db 0x5
    .db 0x80
    .db 0xa8
    .db 0x8b
    .db 0x8b
    .db 0x82
    .db 0xf8
    .db 0x85
    .db 0x1
    .db 0x83
    .db 0x8
    .db 0x80
    .db 0xf8
    .db 0x86
    .db 0x0
    .db 0x8c
    .db 0x0
    .db 0x88
    .db 0xb8
    .db 0x83
    .db 0xf4
    .db 0x84
    .db 0x80
    .db 0xa8
    .db 0x1
    .db 0x30
    .db 0x89
    .db 0x82
    .db 0xec
    .db 0xff
    .db 0x83
    .db 0x84
    .db 0x3
    .db 0x80
    .db 0xac
    .db 0x0
    .db 0x1
    .db 0x2d
    .db 0x87
    .db 0x82
    .db 0xe8
    .db 0x83
    .db 0x8a
    .db 0x5
    .db 0x80
    .db 0xa8
    .db 0x1
    .db 0x2c
    .db 0x8b
    .db 0x82
    .db 0xfc
    .db 0x1
    .db 0x83
    .db 0x0
    .db 0x85
    .db 0x8
    .db 0x80
    .db 0xec
    .db 0x0
    .db 0x8c
    .db 0x86
    .db 0x0
    .db 0x88
    .db 0xb8
    .db 0x83
    .db 0xf4
    .db 0x84
    .db 0x80
    .db 0xa8
    .db 0x1
    .db 0x3
    .db 0x89
    .db 0x82
    .db 0xec
    .db 0xff
    .db 0x83
    .db 0x84
    .db 0x3
    .db 0x80
    .db 0xac
    .db 0x0
    .db 0x1
    .db 0x0
    .db 0x87
    .db 0x82
    .db 0xe8
    .db 0x83
    .db 0x8a
    .db 0x5
    .db 0x80
    .db 0xa8
    .db 0x0
    .db 0xff
    .db 0x8b
    .db 0x82
    .db 0xfc
    .db 0x1
    .db 0x83
    .db 0x0
    .db 0x85
    .db 0x8
    .db 0x80
    .db 0xec
    .db 0x0
    .db 0x8c
    .db 0x86
    .db 0x0
    .db 0x88
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG0_LOOP
ALIENMSXSONGFILE_SUBSONG0_TRACKINDEXES: .dw ALIENMSXSONGFILE_SUBSONG0_TRACK13
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK0
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK14
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK8
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK3
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK1
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK2
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK5
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK15
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK4
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK6
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK7
    .dw ALIENMSXSONGFILE_SUBSONG0_TRACK12
ALIENMSXSONGFILE_SUBSONG0_TRACK0: .db 0x73
    .db 0x1
    .db 0x73
    .db 0x3
    .db 0x73
    .db 0x1
    .db 0x73
    .db 0x3
    .db 0x70
    .db 0x1
    .db 0x70
    .db 0x3
    .db 0x70
    .db 0x1
    .db 0x70
    .db 0x3
    .db 0x73
    .db 0x1
    .db 0x73
    .db 0x3
    .db 0x73
    .db 0x1
    .db 0x73
    .db 0x3
    .db 0x70
    .db 0x1
    .db 0x70
    .db 0x3
    .db 0x70
    .db 0x1
    .db 0xf0
    .db 0x3
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK1: .db 0xf3
    .db 0x4
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK2: .db 0xfe
    .db 0x26
    .db 0x4
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK3: .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0x71
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x75
    .db 0x2
    .db 0x75
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0x74
    .db 0x1
    .db 0x74
    .db 0x2
    .db 0x74
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0xf1
    .db 0x2
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK4: .db 0x71
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0xf6
    .db 0x5
    .db 0x3
    .db 0x4
    .db 0xc5
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK5: .db 0x71
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0xf4
    .db 0x5
    .db 0x3
    .db 0x6
    .db 0xc8
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK6: .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0x71
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x75
    .db 0x2
    .db 0x75
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x71
    .db 0x1
    .db 0x71
    .db 0x2
    .db 0x74
    .db 0x1
    .db 0x74
    .db 0x2
    .db 0x74
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x76
    .db 0x1
    .db 0xf6
    .db 0x2
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK7: .db 0x76
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x74
    .db 0x1
    .db 0x74
    .db 0x2
    .db 0x74
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x75
    .db 0x1
    .db 0x75
    .db 0x2
    .db 0x75
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x74
    .db 0x1
    .db 0x74
    .db 0x2
    .db 0x74
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0xc0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK8: .db 0xf0
    .db 0x0
    .db 0x3
    .db 0x72
    .db 0x1
    .db 0x72
    .db 0x2
    .db 0x72
    .db 0x1
    .db 0x72
    .db 0x2
    .db 0x72
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0x72
    .db 0x1
    .db 0x72
    .db 0x2
    .db 0x72
    .db 0x1
    .db 0x72
    .db 0x2
    .db 0x72
    .db 0x3
    .db 0xf0
    .db 0x0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK9: .db 0xf2
    .db 0x5
    .db 0x3
    .db 0xe
    .db 0x44
    .db 0x2
    .db 0xf0
    .db 0x0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK10: .db 0xfe
    .db 0x44
    .db 0x5
    .db 0x3
    .db 0xe
    .db 0x46
    .db 0x6
    .db 0xc8
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK11: .db 0xc2
    .db 0x7
    .db 0x72
    .db 0x1
    .db 0x72
    .db 0x2
    .db 0x72
    .db 0x3
    .db 0x70
    .db 0x0
    .db 0xc0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK12: .db 0xcf
    .db 0x7
    .db 0xf8
    .db 0x5
    .db 0x3
    .db 0xf0
    .db 0x0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK13: .db 0xc7
    .db 0x3
    .db 0x83
    .db 0x7
    .db 0x87
    .db 0xc3
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK14: .db 0xc7
    .db 0x3
    .db 0x3
    .db 0x7
    .db 0xc3
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_TRACK15: .db 0xce
    .db 0x22
    .db 0x3
    .db 0xe
    .db 0x2e
    .db 0x3
    .db 0xc0
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG0_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
ALIENMSXSONGFILE_SUBSONG1: .dw ALIENMSXSONGFILE_SUBSONG1_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG1_TRACKINDEXES
    .db 0x6
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0x0
    .db 0x0
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG1_LOOP: .db 0xaa
    .db 0x7
    .db 0x80
    .db 0x80
    .db 0x80
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG1_LOOP
ALIENMSXSONGFILE_SUBSONG1_TRACKINDEXES: .dw ALIENMSXSONGFILE_SUBSONG1_TRACK0
ALIENMSXSONGFILE_SUBSONG1_TRACK0: .db 0xcd
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG1_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
ALIENMSXSONGFILE_SUBSONG2: .dw ALIENMSXSONGFILE_SUBSONG2_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG2_TRACKINDEXES
    .db 0x6
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0x38
    .db 0x0
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG2_LOOP: .db 0xab
    .db 0x9
    .db 0x3f
    .db 0x0
    .db 0x8
    .db 0x0
    .db 0x64
    .db 0x0
    .db 0x72
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG2_LOOP
ALIENMSXSONGFILE_SUBSONG2_TRACKINDEXES:
ALIENMSXSONGFILE_SUBSONG2_TRACK0: .db 0xc
    .db 0x5f
    .db 0x62
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x39
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x39
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x39
    .db 0x5e
    .db 0x3e
    .db 0x9e
    .db 0x42
    .db 0x5e
    .db 0x39
    .db 0x5e
    .db 0x3e
    .db 0x9e
    .db 0x42
    .db 0x5e
    .db 0x38
    .db 0x51
    .db 0x9e
    .db 0x42
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x9e
    .db 0x40
    .db 0x5e
    .db 0x38
    .db 0x5e
    .db 0x3d
    .db 0x95
    .db 0x5e
    .db 0x36
    .db 0x51
    .db 0xd5
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG2_TRACK1: .db 0xc
    .db 0xde
    .db 0x31
    .db 0xf
    .db 0x62
    .db 0x1e
    .db 0x2f
    .db 0xde
    .db 0x2d
    .db 0x7
    .db 0x1e
    .db 0x2a
    .db 0x1e
    .db 0x2c
    .db 0xdf
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG2_TRACK2: .db 0xc
    .db 0xde
    .db 0x25
    .db 0xf
    .db 0x62
    .db 0x1e
    .db 0x23
    .db 0xde
    .db 0x21
    .db 0x7
    .db 0x1e
    .db 0x1e
    .db 0x1e
    .db 0x20
    .db 0xdf
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG2_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
ALIENMSXSONGFILE_SUBSONG3: .dw ALIENMSXSONGFILE_SUBSONG3_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG3_TRACKINDEXES
    .db 0x6
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0x46
    .db 0x7
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG3_LOOP: .db 0xab
    .db 0x7
    .db 0x7
    .db 0x81
    .db 0x80
    .db 0x80
    .db 0x0
    .db 0xa8
    .db 0x0
    .db 0x2b
    .db 0x82
    .db 0x82
    .db 0x0
    .db 0xa8
    .db 0x81
    .db 0x80
    .db 0x80
    .db 0x0
    .db 0xa8
    .db 0x0
    .db 0x27
    .db 0x83
    .db 0x83
    .db 0x0
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG3_LOOP
ALIENMSXSONGFILE_SUBSONG3_TRACKINDEXES: .dw ALIENMSXSONGFILE_SUBSONG3_TRACK0
    .dw ALIENMSXSONGFILE_SUBSONG3_TRACK1
    .dw ALIENMSXSONGFILE_SUBSONG3_TRACK4
    .dw ALIENMSXSONGFILE_SUBSONG3_TRACK5
ALIENMSXSONGFILE_SUBSONG3_TRACK0: .db 0xc
    .db 0xde
    .db 0x2e
    .db 0x7f
    .db 0x82
ALIENMSXSONGFILE_SUBSONG3_TRACK1: .db 0xc
    .db 0x4f
    .db 0x62
    .db 0x46
    .db 0x8e
    .db 0x3e
    .db 0x4e
    .db 0x46
    .db 0x46
    .db 0xce
    .db 0x3e
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG3_TRACK2: .db 0x42
    .db 0x44
    .db 0x81
    .db 0x42
    .db 0x44
    .db 0xc1
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG3_TRACK3: .db 0x48
    .db 0x46
    .db 0x85
    .db 0x48
    .db 0x46
    .db 0xc5
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG3_TRACK4: .db 0xc
    .db 0xde
    .db 0x2d
    .db 0x7f
    .db 0x82
ALIENMSXSONGFILE_SUBSONG3_TRACK5: .db 0xc
    .db 0xd0
    .db 0x7f
    .db 0x82
ALIENMSXSONGFILE_SUBSONG3_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
ALIENMSXSONGFILE_SUBSONG4: .dw ALIENMSXSONGFILE_SUBSONG4_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG4_TRACKINDEXES
    .db 0x9
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0xe
    .db 0xa
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG4_LOOP: .db 0xaa
    .db 0x3f
    .db 0x80
    .db 0x1
    .db 0x6e
    .db 0x81
    .db 0x20
    .db 0x2
    .db 0x9
    .db 0x20
    .db 0x1
    .db 0x67
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG4_LOOP
ALIENMSXSONGFILE_SUBSONG4_TRACKINDEXES: .dw ALIENMSXSONGFILE_SUBSONG4_TRACK0
    .dw ALIENMSXSONGFILE_SUBSONG4_TRACK1
ALIENMSXSONGFILE_SUBSONG4_TRACK0: .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x11
    .db 0x62
    .db 0x7e
    .db 0x39
    .db 0xc
    .db 0x6e
    .db 0x40
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x64
    .db 0x62
    .db 0xc
    .db 0x64
    .db 0x82
    .db 0xc
    .db 0x7f
    .db 0x10
    .db 0x62
    .db 0xc
    .db 0x66
    .db 0x82
    .db 0xc
    .db 0x64
    .db 0x62
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x6e
    .db 0x40
    .db 0x62
    .db 0xc
    .db 0x6f
    .db 0x82
    .db 0xc
    .db 0x6e
    .db 0x3e
    .db 0x62
    .db 0xc
    .db 0x6f
    .db 0x82
    .db 0xc
    .db 0x61
    .db 0x62
    .db 0xc
    .db 0x61
    .db 0x82
    .db 0xc
    .db 0x4f
    .db 0x62
    .db 0x7e
    .db 0x39
    .db 0xc
    .db 0x6e
    .db 0x40
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x64
    .db 0x62
    .db 0xc
    .db 0x64
    .db 0x82
    .db 0xc
    .db 0x7f
    .db 0x10
    .db 0x62
    .db 0xc
    .db 0x66
    .db 0x82
    .db 0xc
    .db 0x64
    .db 0x62
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x6e
    .db 0x40
    .db 0x62
    .db 0xc
    .db 0x6f
    .db 0x82
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x10
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0xc
    .db 0x82
    .db 0xc
    .db 0x61
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x4e
    .db 0x3e
    .db 0x62
    .db 0x7f
    .db 0xc
    .db 0x6f
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x6f
    .db 0x72
    .db 0x7f
    .db 0xc
    .db 0xc
    .db 0x7f
    .db 0x10
    .db 0x62
    .db 0xc
    .db 0x6f
    .db 0x82
    .db 0x6f
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x6f
    .db 0x92
    .db 0x6f
    .db 0xc
    .db 0x6f
    .db 0xa2
    .db 0xc
    .db 0x61
    .db 0x62
    .db 0x61
    .db 0x61
    .db 0x4f
    .db 0x7f
    .db 0xc
    .db 0x6f
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x7f
    .db 0xc
    .db 0x72
    .db 0x6f
    .db 0xc
    .db 0x7f
    .db 0x10
    .db 0x62
    .db 0xc
    .db 0x6f
    .db 0x82
    .db 0x6f
    .db 0xc
    .db 0x7f
    .db 0x11
    .db 0xa2
    .db 0xc
    .db 0x6f
    .db 0x92
    .db 0x6f
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x10
    .db 0x62
    .db 0x6f
    .db 0x6f
    .db 0xc
    .db 0xff
    .db 0x11
    .db 0x7f
    .db 0xa2
ALIENMSXSONGFILE_SUBSONG4_TRACK1: .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x5d
    .db 0xf4
    .db 0x0
    .db 0x9
    .db 0xc
    .db 0x72
    .db 0x13
    .db 0x72
    .db 0x42
    .db 0x46
    .db 0x42
    .db 0x4e
    .db 0x3e
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x13
    .db 0x92
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x8f
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x13
    .db 0x72
    .db 0x4e
    .db 0x40
    .db 0x44
    .db 0x42
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x5d
    .db 0xf4
    .db 0x0
    .db 0x9
    .db 0xc
    .db 0x72
    .db 0x13
    .db 0x72
    .db 0x42
    .db 0x46
    .db 0x42
    .db 0x4e
    .db 0x3e
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x13
    .db 0x92
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x8f
    .db 0xce
    .db 0x15
    .db 0x3
    .db 0x4e
    .db 0x1a
    .db 0x5d
    .db 0xf4
    .db 0x0
    .db 0x9
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x13
    .db 0x72
    .db 0x4f
    .db 0x41
    .db 0x4e
    .db 0x3e
    .db 0x4f
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x3e
    .db 0x13
    .db 0x42
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x8f
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x13
    .db 0x72
    .db 0x4f
    .db 0x41
    .db 0x4e
    .db 0x3e
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0x5d
    .db 0xf4
    .db 0x0
    .db 0x9
    .db 0xc
    .db 0x7e
    .db 0x39
    .db 0x13
    .db 0x72
    .db 0x4f
    .db 0x41
    .db 0x4e
    .db 0x3e
    .db 0x4f
    .db 0xc
    .db 0x7e
    .db 0x1a
    .db 0x9
    .db 0x52
    .db 0xc
    .db 0x6e
    .db 0x3e
    .db 0x92
    .db 0xc
    .db 0x4e
    .db 0x1a
    .db 0x52
    .db 0x8f
    .db 0xce
    .db 0x15
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG4_TRACK2: .db 0xc
    .db 0x8f
    .db 0x52
    .db 0xbe
    .db 0x26
    .db 0xe
    .db 0xbf
    .db 0xb
    .db 0x7e
    .db 0x1a
    .db 0xf
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0xbf
    .db 0xb
    .db 0xbf
    .db 0xe
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0xbe
    .db 0x26
    .db 0xe
    .db 0xbf
    .db 0xb
    .db 0x7e
    .db 0x1a
    .db 0xf
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0xbf
    .db 0xb
    .db 0xbf
    .db 0xe
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x52
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x2d
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0xfe
    .db 0x2d
    .db 0xd
    .db 0x7f
    .db 0xa2
ALIENMSXSONGFILE_SUBSONG4_TRACK3: .db 0xc
    .db 0x8f
    .db 0x72
    .db 0xc
    .db 0xbe
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xbf
    .db 0xb
    .db 0x7e
    .db 0x1a
    .db 0xf
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xbf
    .db 0xb
    .db 0xbf
    .db 0xe
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0xbe
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xbf
    .db 0xb
    .db 0x7e
    .db 0x1a
    .db 0xf
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xe
    .db 0x52
    .db 0xbf
    .db 0xb
    .db 0xbf
    .db 0xe
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0xbe
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0x52
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0xa2
    .db 0x7e
    .db 0x26
    .db 0xb
    .db 0xc
    .db 0x7e
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x32
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0xbe
    .db 0xe
    .db 0xa
    .db 0x72
    .db 0xc
    .db 0x7e
    .db 0x2d
    .db 0xd
    .db 0x62
    .db 0xc
    .db 0x7e
    .db 0x26
    .db 0x14
    .db 0x52
    .db 0xc
    .db 0x4f
    .db 0x42
    .db 0xc
    .db 0x4f
    .db 0x32
    .db 0xc
    .db 0xcf
    .db 0x7f
    .db 0x22
ALIENMSXSONGFILE_SUBSONG4_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
ALIENMSXSONGFILE_SUBSONG5: .dw ALIENMSXSONGFILE_SUBSONG5_NOTEINDEXES
    .dw ALIENMSXSONGFILE_SUBSONG5_TRACKINDEXES
    .db 0x8
    .db 0x8
    .db 0x12
    .db 0x0
    .db 0x1
    .db 0x3e
    .db 0x0
    .db 0x0
    .db 0xc
ALIENMSXSONGFILE_SUBSONG5_LOOP: .db 0xaa
    .db 0x23
    .db 0x0
    .db 0x8
    .db 0x0
    .db 0x3c
    .db 0x0
    .db 0x50
    .db 0x1
    .db 0x0
    .dw ALIENMSXSONGFILE_SUBSONG5_LOOP
ALIENMSXSONGFILE_SUBSONG5_TRACKINDEXES:
ALIENMSXSONGFILE_SUBSONG5_TRACK0: .db 0xc
    .db 0x5f
    .db 0x12
    .db 0x5e
    .db 0x40
    .db 0x54
    .db 0x5e
    .db 0x3e
    .db 0x5f
    .db 0x5e
    .db 0x40
    .db 0x54
    .db 0x5e
    .db 0x3e
    .db 0x5f
    .db 0x54
    .db 0x52
    .db 0x54
    .db 0x5e
    .db 0x3b
    .db 0x5e
    .db 0x3e
    .db 0x56
    .db 0x5e
    .db 0x47
    .db 0xc
    .db 0x5e
    .db 0x37
    .db 0x2
    .db 0xc
    .db 0x5f
    .db 0x12
    .db 0x5e
    .db 0x33
    .db 0x5e
    .db 0x37
    .db 0x5e
    .db 0x35
    .db 0x5f
    .db 0x5e
    .db 0x39
    .db 0x5e
    .db 0x35
    .db 0x5e
    .db 0x3b
    .db 0xc
    .db 0x5e
    .db 0x33
    .db 0x22
    .db 0xc
    .db 0xde
    .db 0x37
    .db 0x7f
    .db 0x12
ALIENMSXSONGFILE_SUBSONG5_TRACK1: .db 0xc
    .db 0xde
    .db 0x32
    .db 0x3
    .db 0x2
    .db 0x1e
    .db 0x2e
    .db 0xc
    .db 0x1e
    .db 0x2d
    .db 0x12
    .db 0xc
    .db 0x1e
    .db 0x37
    .db 0x2
    .db 0x1e
    .db 0x27
    .db 0x1e
    .db 0x29
    .db 0xde
    .db 0x2b
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG5_TRACK2: .db 0xcd
    .db 0x7f
ALIENMSXSONGFILE_SUBSONG5_NOTEINDEXES: .db 0x30
    .db 0x3c
    .db 0x45
    .db 0x24
    .db 0x41
    .db 0x3f
    .db 0x43
    .db 0x18
    .db 0x48
_EFFECTS::
ALIENMSXSFX_SOUNDEFFECTS:
_ALIENMSXSFX_SOUNDEFFECTS:: .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND1
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND2
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND3
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND4
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND5
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND6
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND7
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND8
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND9
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND10
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND11
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND12
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND13
    .dw ALIENMSXSFX_SOUNDEFFECTS_SOUND14
ALIENMSXSFX_SOUNDEFFECTS_SOUND1: .db 0x0
ALIENMSXSFX_SOUNDEFFECTS_SOUND1_LOOP: .db 0x39
    .db 0x60
    .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x35
    .db 0x80
    .db 0x0
    .db 0x35
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x0
    .db 0x1
    .db 0x29
    .db 0x0
    .db 0x1
    .db 0x25
    .db 0x80
    .db 0x0
    .db 0x25
    .db 0x80
    .db 0x0
    .db 0x1d
    .db 0x80
    .db 0x0
    .db 0x1d
    .db 0x80
    .db 0x0
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND2: .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x39
    .db 0x60
    .db 0x0
    .db 0x35
    .db 0x70
    .db 0x0
    .db 0x35
    .db 0x70
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x29
    .db 0x80
    .db 0x0
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x21
    .db 0x60
    .db 0x0
    .db 0x21
    .db 0x60
    .db 0x0
ALIENMSXSFX_SOUNDEFFECTS_SOUND2_LOOP: .db 0x1
    .db 0x60
    .db 0x0
    .db 0x1
    .db 0x60
    .db 0x0
    .db 0x19
    .db 0x80
    .db 0x0
    .db 0x19
    .db 0x80
    .db 0x0
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND3: .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0xb1
    .db 0x1
    .db 0x80
    .db 0x0
    .db 0x31
    .db 0x80
    .db 0x0
    .db 0x31
    .db 0x60
    .db 0x0
    .db 0x31
    .db 0x60
    .db 0x0
    .db 0x31
    .db 0x0
    .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND3_LOOP: .db 0x31
    .db 0x0
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND4: .db 0x0
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x1
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x1
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x2
    .db 0xb9
    .db 0x1
    .db 0x0
    .db 0x2
    .db 0x35
    .db 0x80
    .db 0x2
    .db 0x35
    .db 0x80
    .db 0x2
    .db 0x2d
    .db 0x60
    .db 0x2
    .db 0x2d
    .db 0x60
    .db 0x2
    .db 0x29
    .db 0x0
    .db 0x3
    .db 0x29
    .db 0x0
    .db 0x3
    .db 0x21
    .db 0x0
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND4_LOOP: .db 0x21
    .db 0x0
    .db 0x4
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND5: .db 0x0
    .db 0x39
    .db 0x0
    .db 0x2
    .db 0x39
    .db 0x0
    .db 0x2
    .db 0x39
    .db 0x60
    .db 0x2
    .db 0x39
    .db 0x60
    .db 0x2
    .db 0x39
    .db 0x20
    .db 0x3
    .db 0x39
    .db 0x20
    .db 0x3
    .db 0x35
    .db 0x0
    .db 0x3
    .db 0x35
    .db 0x0
    .db 0x4
    .db 0x2d
    .db 0x0
    .db 0x5
    .db 0x2d
    .db 0x0
    .db 0x6
    .db 0x29
    .db 0x0
    .db 0x8
    .db 0x29
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x21
    .db 0x0
    .db 0x8
    .db 0x19
    .db 0x0
    .db 0x8
ALIENMSXSFX_SOUNDEFFECTS_SOUND5_LOOP: .db 0x19
    .db 0x0
    .db 0x8
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND6: .db 0x0
ALIENMSXSFX_SOUNDEFFECTS_SOUND6_LOOP: .db 0xbd
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xbd
    .db 0x1
    .db 0xac
    .db 0x1
    .db 0xb1
    .db 0x1
    .db 0xaf
    .db 0x1
    .db 0xad
    .db 0x1
    .db 0xb3
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND7: .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND7_LOOP: .db 0xbd
    .db 0x1
    .db 0x2c
    .db 0x4
    .db 0xbd
    .db 0x8
    .db 0x6b
    .db 0x4
    .db 0xb9
    .db 0x2
    .db 0x91
    .db 0x5
    .db 0xb5
    .db 0x10
    .db 0xf3
    .db 0x2
    .db 0xb1
    .db 0x2
    .db 0x20
    .db 0x3
    .db 0xad
    .db 0x2
    .db 0x4f
    .db 0x3
    .db 0xa5
    .db 0x10
    .db 0xf6
    .db 0x4
    .db 0x9d
    .db 0x1f
    .db 0xa8
    .db 0x1
    .db 0x99
    .db 0x7
    .db 0x1b
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND8: .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND8_LOOP: .db 0xbd
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0x3d
    .db 0xc8
    .db 0x0
    .db 0xbd
    .db 0x1
    .db 0x79
    .db 0x1
    .db 0x3d
    .db 0xbd
    .db 0x0
    .db 0x3d
    .db 0x64
    .db 0x1
    .db 0x3d
    .db 0xb2
    .db 0x0
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND9: .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND9_LOOP: .db 0x3
    .db 0x3
    .db 0x0
    .db 0x2f
    .db 0x0
    .db 0x3
    .db 0x5
    .db 0x0
    .db 0x54
    .db 0x0
    .db 0x3
    .db 0x3
    .db 0x0
    .db 0x35
    .db 0x0
    .db 0x3
    .db 0x8
    .db 0x0
    .db 0x85
    .db 0x0
    .db 0x3
    .db 0x5
    .db 0x0
    .db 0x54
    .db 0x0
    .db 0x3
    .db 0xd
    .db 0x0
    .db 0xd4
    .db 0x0
    .db 0x3
    .db 0x8
    .db 0x0
    .db 0x85
    .db 0x0
    .db 0x3
    .db 0x15
    .db 0x0
    .db 0x50
    .db 0x1
    .db 0x3
    .db 0xd
    .db 0x0
    .db 0xd4
    .db 0x0
    .db 0x3
    .db 0x21
    .db 0x0
    .db 0x16
    .db 0x2
    .db 0x3
    .db 0x15
    .db 0x0
    .db 0x50
    .db 0x1
    .db 0x3
    .db 0x3b
    .db 0x0
    .db 0xb7
    .db 0x3
    .db 0x3
    .db 0x59
    .db 0x0
    .db 0x91
    .db 0x5
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND10: .db 0x0
ALIENMSXSFX_SOUNDEFFECTS_SOUND10_LOOP: .db 0xc8
    .db 0x1
    .db 0xb8
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND11: .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND11_LOOP: .db 0x29
    .db 0xa8
    .db 0x1
    .db 0x29
    .db 0xd4
    .db 0x0
    .db 0x29
    .db 0x6a
    .db 0x0
    .db 0x29
    .db 0x35
    .db 0x0
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND12: .db 0x1
    .db 0x31
    .db 0xd4
    .db 0x0
    .db 0x29
    .db 0xb
    .db 0x1
    .db 0x2d
    .db 0x3d
    .db 0x1
    .db 0x25
    .db 0xa8
    .db 0x1
    .db 0x29
    .db 0xa8
    .db 0x1
    .db 0x29
    .db 0xa8
    .db 0x1
    .db 0x21
    .db 0xd5
    .db 0x0
    .db 0x25
    .db 0xc
    .db 0x1
    .db 0x1d
    .db 0x51
    .db 0x1
    .db 0x21
    .db 0xa9
    .db 0x1
    .db 0x21
    .db 0xa9
    .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND12_LOOP: .db 0x19
    .db 0xa9
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND13: .db 0x0
ALIENMSXSFX_SOUNDEFFECTS_SOUND13_LOOP: .db 0xf8
    .db 0x2
    .db 0x39
    .db 0xa8
    .db 0x1
    .db 0xb5
    .db 0x1
    .db 0x78
    .db 0x2
    .db 0xad
    .db 0x1
    .db 0x38
    .db 0x3
    .db 0xd8
    .db 0x1
    .db 0xd8
    .db 0x3
    .db 0xd0
    .db 0x4
    .db 0xc8
    .db 0x1
    .db 0x4
ALIENMSXSFX_SOUNDEFFECTS_SOUND14: .db 0x1
ALIENMSXSFX_SOUNDEFFECTS_SOUND14_LOOP: .db 0xbd
    .db 0x1f
    .db 0xd4
    .db 0x0
    .db 0xb9
    .db 0x1c
    .db 0xe0
    .db 0x0
    .db 0xb5
    .db 0x19
    .db 0xee
    .db 0x0
    .db 0xb1
    .db 0x16
    .db 0xfc
    .db 0x0
    .db 0xb1
    .db 0x13
    .db 0xb
    .db 0x1
    .db 0xad
    .db 0x11
    .db 0x1b
    .db 0x1
    .db 0xad
    .db 0xf
    .db 0x2c
    .db 0x1
    .db 0xa9
    .db 0xd
    .db 0x3d
    .db 0x1
    .db 0xa9
    .db 0xc
    .db 0x50
    .db 0x1
    .db 0xd0
    .db 0xb
    .db 0xc8
    .db 0xa
    .db 0xc8
    .db 0x9
    .db 0xc8
    .db 0x8
    .db 0xc0
    .db 0x7
    .db 0xc0
    .db 0x6
    .db 0xc0
    .db 0x5
    .db 0xb8
    .db 0x4
    .db 0xb8
    .db 0x3
    .db 0xb8
    .db 0x2
    .db 0xb8
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xb0
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa8
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0xa0
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x98
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x90
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x88
    .db 0x1
    .db 0x4
PLY_AKM_CHANNEL1_SOUNDEFFECTDATA = 0xc057
PLY_AKM_CHANNEL2_SOUNDEFFECTDATA = 0xc05f
PLY_AKM_CHANNEL3_SOUNDEFFECTDATA = 0xc067
PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS = 0xc00f
PLY_AKM_DEFAULTSTARTNOTEINTRACKS = 0xc00e
PLY_AKM_DEFAULTSTARTWAITINTRACKS = 0xc010
PLY_AKM_FLAGNOTEANDEFFECTINCELL = 0xc015
PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT = 0xc017
PLY_AKM_MIXERREGISTER = 0xc046
PLY_AKM_NOISEREGISTER = 0xc042
PLY_AKM_NOTEINDEXTABLE = 0xc008
PLY_AKM_PATTERNREMAININGHEIGHT = 0xc016
PLY_AKM_PRIMARYINSTRUMENT = 0xc011
PLY_AKM_PRIMARYWAIT = 0xc013
PLY_AKM_PTINSTRUMENTS = 0xc000
PLY_AKM_PTLINKER = 0xc006
PLY_AKM_PTSOUNDEFFECTTABLE = 0xc055
PLY_AKM_REG11 = 0xc04a
PLY_AKM_REG12 = 0xc04e
PLY_AKM_RT_READEFFECTSFLAG = 0xc01c
PLY_AKM_SAVESP = 0xc00c
PLY_AKM_SECONDARYINSTRUMENT = 0xc012
PLY_AKM_SECONDARYWAIT = 0xc014
PLY_AKM_SETREG13 = 0xc01b
PLY_AKM_SETREG13OLD = 0xc01a
PLY_AKM_SPEED = 0xc018
PLY_AKM_TICKCOUNTER = 0xc019
PLY_AKM_TRACK1_ESCAPEINSTRUMENT = 0xc074
PLY_AKM_TRACK1_ESCAPENOTE = 0xc073
PLY_AKM_TRACK1_ESCAPEWAIT = 0xc075
PLY_AKM_TRACK1_PTINSTRUMENT = 0xc076
PLY_AKM_TRACK1_REGISTERS = 0xc01d
PLY_AKM_TRACK1_TRANSPOSITION = 0xc06d
PLY_AKM_TRACK1_VOLUME = 0xc01e
PLY_AKM_TRACK1_WAITEMPTYCELL = 0xc06c
PLY_AKM_TRACK2_ESCAPEINSTRUMENT = 0xc089
PLY_AKM_TRACK2_ESCAPENOTE = 0xc088
PLY_AKM_TRACK2_ESCAPEWAIT = 0xc08a
PLY_AKM_TRACK2_PTINSTRUMENT = 0xc08b
PLY_AKM_TRACK2_REGISTERS = 0xc029
PLY_AKM_TRACK2_VOLUME = 0xc02a
PLY_AKM_TRACK2_WAITEMPTYCELL = 0xc081
PLY_AKM_TRACK3_ESCAPEINSTRUMENT = 0xc09e
PLY_AKM_TRACK3_ESCAPENOTE = 0xc09d
PLY_AKM_TRACK3_ESCAPEWAIT = 0xc09f
PLY_AKM_TRACK3_PTINSTRUMENT = 0xc0a0
PLY_AKM_TRACK3_REGISTERS = 0xc035
PLY_AKM_TRACK3_VOLUME = 0xc036
PLY_AKM_TRACK3_WAITEMPTYCELL = 0xc096
PLY_AKM_TRACKINDEX = 0xc00a
