; alien-haze, Song part, encoded in the AKM (minimalist) format V0.


aliensong_Start
aliensong_StartDisarkGenerateExternalLabel

aliensong_DisarkPointerRegionStart0
	dw aliensong_InstrumentIndexes	; Index table for the Instruments.
aliensong_DisarkForceNonReferenceDuring2_1
	dw 0	; Index table for the Arpeggios.
aliensong_DisarkForceNonReferenceDuring2_2
	dw 0	; Index table for the Pitches.

; The subsongs references.
	dw aliensong_Subsong0
aliensong_DisarkPointerRegionEnd0

; The Instrument indexes.
aliensong_InstrumentIndexes
aliensong_DisarkPointerRegionStart3
	dw aliensong_Instrument0
	dw aliensong_Instrument1
	dw aliensong_Instrument2
	dw aliensong_Instrument3
	dw aliensong_Instrument4
	dw aliensong_Instrument5
	dw aliensong_Instrument6
	dw aliensong_Instrument7
	dw aliensong_Instrument8
	dw aliensong_Instrument9
	dw aliensong_Instrument10
aliensong_DisarkPointerRegionEnd3

; The Instrument.
aliensong_DisarkByteRegionStart4
aliensong_Instrument0
	db 255	; Speed.

aliensong_Instrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
aliensong_DisarkPointerRegionStart5
	dw aliensong_Instrument0Loop	; Loops.
aliensong_DisarkPointerRegionEnd5

aliensong_DisarkByteRegionEnd4
aliensong_ArpeggioIndexes
aliensong_DisarkPointerRegionStart6
aliensong_DisarkPointerRegionEnd6

aliensong_DisarkByteRegionStart7
aliensong_DisarkByteRegionEnd7

aliensong_PitchIndexes
aliensong_DisarkPointerRegionStart8
aliensong_DisarkPointerRegionEnd8

aliensong_DisarkByteRegionStart9
aliensong_DisarkByteRegionEnd9

; alien-haze, Subsong 0.
; ----------------------------------

aliensong_Subsong0
aliensong_Subsong0DisarkPointerRegionStart0
	dw aliensong_Subsong0_NoteIndexes	; Index table for the notes.
	dw aliensong_Subsong0_TrackIndexes	; Index table for the Tracks.
aliensong_Subsong0DisarkPointerRegionEnd0

aliensong_Subsong0DisarkByteRegionStart1
	db 6	; Initial speed.

	db 8	; Most used instrument.
	db 5	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 62	; Default start note in tracks.
	db 10	; Default start instrument in tracks.
	db 2	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
aliensong_Subsong0DisarkByteRegionEnd1

; The Linker.
aliensong_Subsong0DisarkByteRegionStart2
; Pattern 0
	db 171	; State byte.
	db 4	; New speed (>0).
	db 63	; New height.
	db ((aliensong_Subsong0_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track0 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track1 - ($ + 2)) & #ff00) / 256	; New track (1) for channel 2, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track1 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track2 - ($ + 1)) & 255)

; Pattern 1
	db 168	; State byte.
	db ((aliensong_Subsong0_Track3 - ($ + 2)) & #ff00) / 256	; New track (3) for channel 1, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track3 - ($ + 1)) & 255)
	db 131	; New track (4) for channel 2, as a reference (index 3).
	db 132	; New track (5) for channel 3, as a reference (index 4).

; Pattern 2
	db 8	; State byte.
	db 130	; New track (6) for channel 1, as a reference (index 2).

; Pattern 3
	db 0	; State byte.

; Pattern 4
	db 160	; State byte.
	db ((aliensong_Subsong0_Track7 - ($ + 2)) & #ff00) / 256	; New track (7) for channel 2, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track7 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track8 - ($ + 2)) & #ff00) / 256	; New track (8) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track8 - ($ + 1)) & 255)

; Pattern 5
	db 32	; State byte.
	db 133	; New track (9) for channel 2, as a reference (index 5).

; Pattern 6
	db 168	; State byte.
	db ((aliensong_Subsong0_Track10 - ($ + 2)) & #ff00) / 256	; New track (10) for channel 1, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track10 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track11 - ($ + 2)) & #ff00) / 256	; New track (11) for channel 2, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track11 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track12 - ($ + 2)) & #ff00) / 256	; New track (12) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track12 - ($ + 1)) & 255)

; Pattern 7
aliensong_Subsong0_Loop
	db 168	; State byte.
	db ((aliensong_Subsong0_Track13 - ($ + 2)) & #ff00) / 256	; New track (13) for channel 1, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track13 - ($ + 1)) & 255)
	db 133	; New track (9) for channel 2, as a reference (index 5).
	db ((aliensong_Subsong0_Track14 - ($ + 2)) & #ff00) / 256	; New track (14) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track14 - ($ + 1)) & 255)

; Pattern 8
	db 0	; State byte.

; Pattern 9
	db 168	; State byte.
	db 129	; New track (15) for channel 1, as a reference (index 1).
	db ((aliensong_Subsong0_Track16 - ($ + 2)) & #ff00) / 256	; New track (16) for channel 2, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track16 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track17 - ($ + 2)) & #ff00) / 256	; New track (17) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track17 - ($ + 1)) & 255)

; Pattern 10
	db 160	; State byte.
	db 128	; New track (18) for channel 2, as a reference (index 0).
	db ((aliensong_Subsong0_Track19 - ($ + 2)) & #ff00) / 256	; New track (19) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track19 - ($ + 1)) & 255)

; Pattern 11
	db 128	; State byte.
	db ((aliensong_Subsong0_Track20 - ($ + 2)) & #ff00) / 256	; New track (20) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track20 - ($ + 1)) & 255)

; Pattern 12
	db 128	; State byte.
	db ((aliensong_Subsong0_Track21 - ($ + 2)) & #ff00) / 256	; New track (21) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track21 - ($ + 1)) & 255)

; Pattern 13
	db 168	; State byte.
	db ((aliensong_Subsong0_Track22 - ($ + 2)) & #ff00) / 256	; New track (22) for channel 1, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track22 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track23 - ($ + 2)) & #ff00) / 256	; New track (23) for channel 2, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track23 - ($ + 1)) & 255)
	db ((aliensong_Subsong0_Track24 - ($ + 2)) & #ff00) / 256	; New track (24) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track24 - ($ + 1)) & 255)

; Pattern 14
	db 168	; State byte.
	db 134	; New track (25) for channel 1, as a reference (index 6).
	db 128	; New track (18) for channel 2, as a reference (index 0).
	db 135	; New track (26) for channel 3, as a reference (index 7).

; Pattern 15
	db 0	; State byte.

; Pattern 16
	db 0	; State byte.

; Pattern 17
	db 136	; State byte.
	db 129	; New track (15) for channel 1, as a reference (index 1).
	db ((aliensong_Subsong0_Track21 - ($ + 2)) & #ff00) / 256	; New track (21) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track21 - ($ + 1)) & 255)

; Pattern 18
	db 128	; State byte.
	db ((aliensong_Subsong0_Track27 - ($ + 2)) & #ff00) / 256	; New track (27) for channel 3, as an offset. Offset MSB, then LSB.
	db ((aliensong_Subsong0_Track27 - ($ + 1)) & 255)

; Pattern 19
	db 0	; State byte.

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
aliensong_Subsong0DisarkByteRegionEnd2
aliensong_Subsong0DisarkPointerRegionStart3
	dw aliensong_Subsong0_Loop

aliensong_Subsong0DisarkPointerRegionEnd3
; The indexes of the tracks.
aliensong_Subsong0_TrackIndexes
aliensong_Subsong0DisarkPointerRegionStart4
	dw aliensong_Subsong0_Track18	; Track 18, index 0.
	dw aliensong_Subsong0_Track15	; Track 15, index 1.
	dw aliensong_Subsong0_Track6	; Track 6, index 2.
	dw aliensong_Subsong0_Track4	; Track 4, index 3.
	dw aliensong_Subsong0_Track5	; Track 5, index 4.
	dw aliensong_Subsong0_Track9	; Track 9, index 5.
	dw aliensong_Subsong0_Track25	; Track 25, index 6.
	dw aliensong_Subsong0_Track26	; Track 26, index 7.
aliensong_Subsong0DisarkPointerRegionEnd4

aliensong_Subsong0DisarkByteRegionStart5
aliensong_Subsong0_Track0
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 242	;    Volume effect, with inverted volume: 15.

aliensong_Subsong0_Track1
	db 12	; Note with effects flag.
	db 209	; Primary instrument (8). Note reference (1). New wait (7).
	db 7	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 17	; Primary instrument (8). Note reference (1). 
	db 17	; Primary instrument (8). Note reference (1). 
	db 17	; Primary instrument (8). Note reference (1). 
	db 17	; Primary instrument (8). Note reference (1). 
	db 17	; Primary instrument (8). Note reference (1). 
	db 17	; Primary instrument (8). Note reference (1). 
	db 209	; Primary instrument (8). Note reference (1). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track2
	db 12	; Note with effects flag.
	db 249	; New instrument (4). Note reference (9). New wait (19).
	db 4	;   Escape instrument value.
	db 19	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 201	; Note reference (9). New wait (7).
	db 7	;   Escape wait value.
	db 201	; Note reference (9). New wait (19).
	db 19	;   Escape wait value.
	db 199	; Note reference (7). New wait (7).
	db 7	;   Escape wait value.
	db 199	; Note reference (7). New wait (3).
	db 3	;   Escape wait value.
	db 199	; Note reference (7). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track3
	db 141	; Secondary wait (1).
	db 157	; Effect only. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 157	; Effect only. Secondary wait (1).
	db 34	;    Volume effect, with inverted volume: 2.
	db 157	; Effect only. Secondary wait (1).
	db 82	;    Volume effect, with inverted volume: 5.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 242	;    Volume effect, with inverted volume: 15.

aliensong_Subsong0_Track4
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 89. Primary wait (0).
	db 89	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 88. Primary wait (0).
	db 88	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 82	; Primary instrument (8). Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 89	; Primary instrument (8). Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 219	; Primary instrument (8). Note reference (11). New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track5
	db 12	; Note with effects flag.
	db 249	; New instrument (4). Note reference (9). New wait (7).
	db 4	;   Escape instrument value.
	db 7	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 243	; New instrument (3). Note reference (3). New wait (3).
	db 3	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 201	; Note reference (9). New wait (7).
	db 7	;   Escape wait value.
	db 249	; New instrument (4). Note reference (9). New wait (5).
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 179	; New instrument (3). Note reference (3). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 249	; New instrument (4). Note reference (9). New wait (3).
	db 4	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 249	; New instrument (3). Note reference (9). New wait (5).
	db 3	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 198	; Note reference (6). New wait (3).
	db 3	;   Escape wait value.
	db 10	; Note reference (10). 
	db 139	; Note reference (11). Secondary wait (1).
	db 247	; New instrument (4). Note reference (7). New wait (5).
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 178	; New instrument (3). Note reference (2). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 180	; New instrument (3). Note reference (4). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 247	; New instrument (4). Note reference (7). New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

aliensong_Subsong0_Track6
	db 12	; Note with effects flag.
	db 191	; New instrument (7). Same escaped note: 62. Secondary wait (1).
	db 7	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 62. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 62. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 142	; New escaped note: 60. Secondary wait (1).
	db 60	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 142	; New escaped note: 62. Secondary wait (1).
	db 62	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 62. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 62. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 60. Primary wait (0).
	db 60	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 60. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 50	;    Volume effect, with inverted volume: 3.

aliensong_Subsong0_Track7
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 89. Primary wait (0).
	db 89	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 88. Primary wait (0).
	db 88	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 82	; Primary instrument (8). Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 89	; Primary instrument (8). Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 219	; Primary instrument (8). Note reference (11). New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track8
	db 12	; Note with effects flag.
	db 249	; New instrument (4). Note reference (9). New wait (3).
	db 4	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 137	; Note reference (9). Secondary wait (1).
	db 135	; Note reference (7). Secondary wait (1).
	db 51	; New instrument (3). Note reference (3). 
	db 3	;   Escape instrument value.
	db 9	; Note reference (9). 
	db 52	; New instrument (4). Note reference (4). 
	db 4	;   Escape instrument value.
	db 137	; Note reference (9). Secondary wait (1).
	db 131	; Note reference (3). Secondary wait (1).
	db 131	; Note reference (3). Secondary wait (1).
	db 179	; New instrument (3). Note reference (3). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 57	; New instrument (4). Note reference (9). 
	db 4	;   Escape instrument value.
	db 185	; New instrument (3). Note reference (9). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 54	; New instrument (3). Note reference (6). 
	db 3	;   Escape instrument value.
	db 138	; Note reference (10). Secondary wait (1).
	db 180	; New instrument (4). Note reference (4). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 187	; New instrument (3). Note reference (11). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 55	; New instrument (4). Note reference (7). 
	db 4	;   Escape instrument value.
	db 131	; Note reference (3). Secondary wait (1).
	db 178	; New instrument (3). Note reference (2). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 180	; New instrument (3). Note reference (4). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 247	; New instrument (4). Note reference (7). New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

aliensong_Subsong0_Track9
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 89. Primary wait (0).
	db 89	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 88. Primary wait (0).
	db 88	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 82	; Primary instrument (8). Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 89	; Primary instrument (8). Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 219	; Primary instrument (8). Note reference (11). New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track10
	db 12	; Note with effects flag.
	db 176	; New instrument (7). Note reference (0). Secondary wait (1).
	db 7	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 138	; Note reference (10). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 138	; Note reference (10). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 138	; Note reference (10). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 138	; Note reference (10). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 157	; Effect only. Secondary wait (1).
	db 82	;    Volume effect, with inverted volume: 5.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 50	;    Volume effect, with inverted volume: 3.

aliensong_Subsong0_Track11
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 95. Primary wait (0).
	db 95	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 95. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 91. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 89. Primary wait (0).
	db 89	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 89. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 88. Primary wait (0).
	db 88	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 88. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 83	; Primary instrument (8). Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 90	; Primary instrument (8). Note reference (10). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 64	; Note reference (0). Primary wait (0).
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 91	; Primary instrument (8). Note reference (11). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 219	; Primary instrument (8). Note reference (11). New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track12
	db 12	; Note with effects flag.
	db 240	; New instrument (4). Note reference (0). New wait (7).
	db 4	;   Escape instrument value.
	db 7	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 250	; New instrument (3). Note reference (10). New wait (3).
	db 3	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 192	; Note reference (0). New wait (7).
	db 7	;   Escape wait value.
	db 240	; New instrument (4). Note reference (0). New wait (5).
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 186	; New instrument (3). Note reference (10). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 240	; New instrument (4). Note reference (0). New wait (3).
	db 4	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 240	; New instrument (3). Note reference (0). New wait (5).
	db 3	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 206	; New escaped note: 89. New wait (3).
	db 89	;   Escape note value.
	db 3	;   Escape wait value.
	db 14	; New escaped note: 87. 
	db 87	;   Escape note value.
	db 134	; Note reference (6). Secondary wait (1).
	db 248	; New instrument (4). Note reference (8). New wait (5).
	db 4	;   Escape instrument value.
	db 5	;   Escape wait value.
	db 190	; New instrument (3). New escaped note: 82. Secondary wait (1).
	db 82	;   Escape note value.
	db 3	;   Escape instrument value.
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 181	; New instrument (3). Note reference (5). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 248	; New instrument (4). Note reference (8). New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

aliensong_Subsong0_Track13
	db 12	; Note with effects flag.
	db 180	; New instrument (7). Note reference (4). Secondary wait (1).
	db 7	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 134	; Note reference (6). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 134	; Note reference (6). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 128	; Note reference (0). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 60. Primary wait (0).
	db 60	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 134	; Note reference (6). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 134	; Note reference (6). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 50	;    Volume effect, with inverted volume: 3.

aliensong_Subsong0_Track14
	db 12	; Note with effects flag.
	db 115	; New instrument (6). Note reference (3). Primary wait (0).
	db 6	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 121	; New instrument (7). Note reference (9). Primary wait (0).
	db 7	;   Escape instrument value.
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 127	; New instrument (9). Same escaped note: 62. Primary wait (0).
	db 9	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 113	; New instrument (7). Note reference (1). Primary wait (0).
	db 7	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 65	; Note reference (1). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 70	; Note reference (6). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 207	; Same escaped note: 62. New wait (127).
	db 127	;   Escape wait value.
	db 50	;    Volume effect, with inverted volume: 3.

aliensong_Subsong0_Track15
	db 12	; Note with effects flag.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 178	; New instrument (4). Note reference (2). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 135	; Note reference (7). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 178	; New instrument (4). Note reference (2). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 181	; New instrument (4). Note reference (5). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 190	; New instrument (3). New escaped note: 65. Secondary wait (1).
	db 65	;   Escape note value.
	db 3	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 65. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 133	; Note reference (5). Secondary wait (1).
	db 191	; New instrument (3). Same escaped note: 65. Secondary wait (1).
	db 3	;   Escape instrument value.
	db 181	; New instrument (4). Note reference (5). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 143	; Same escaped note: 65. Secondary wait (1).
	db 191	; New instrument (3). Same escaped note: 65. Secondary wait (1).
	db 3	;   Escape instrument value.
	db 133	; Note reference (5). Secondary wait (1).
	db 136	; Note reference (8). Secondary wait (1).
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 82. Secondary wait (1).
	db 82	;   Escape note value.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 137	; Note reference (9). Secondary wait (1).
	db 179	; New instrument (4). Note reference (3). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 179	; New instrument (3). Note reference (3). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 201	; Note reference (9). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track16
	db 205	; New wait (3).
	db 3	;   Escape wait value.
	db 12	; Note with effects flag.
	db 210	; Primary instrument (8). Note reference (2). New wait (7).
	db 7	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 18	; Primary instrument (8). Note reference (2). 
	db 18	; Primary instrument (8). Note reference (2). 
	db 18	; Primary instrument (8). Note reference (2). 
	db 18	; Primary instrument (8). Note reference (2). 
	db 18	; Primary instrument (8). Note reference (2). 
	db 18	; Primary instrument (8). Note reference (2). 
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track17
	db 12	; Note with effects flag.
	db 66	; Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 197	; Note reference (5). New wait (3).
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 64	; Note reference (0). Primary wait (0).
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 65. Primary wait (0).
	db 65	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 65. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 65. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 65. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 65. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track18
	db 12	; Note with effects flag.
	db 240	; New instrument (1). Note reference (0). New wait (3).
	db 1	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 176	; New instrument (1). Note reference (0). Secondary wait (1).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 176	; New instrument (1). Note reference (0). Secondary wait (1).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track19
	db 12	; Note with effects flag.
	db 135	; Note reference (7). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 221	; Effect only. New wait (7).
	db 7	;   Escape wait value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 221	; Effect only. New wait (5).
	db 5	;   Escape wait value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 221	; Effect only. New wait (3).
	db 3	;   Escape wait value.
	db 66	;    Volume effect, with inverted volume: 4.
	db 29	; Effect only. 
	db 82	;    Volume effect, with inverted volume: 5.
	db 221	; Effect only. New wait (7).
	db 7	;   Escape wait value.
	db 146	;    Volume effect, with inverted volume: 9.
	db 12	; Note with effects flag.
	db 245	; New instrument (6). Note reference (5). New wait (15).
	db 6	;   Escape instrument value.
	db 15	;   Escape wait value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 200	; Note reference (8). New wait (7).
	db 7	;   Escape wait value.
	db 201	; Note reference (9). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track20
	db 12	; Note with effects flag.
	db 66	; Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 197	; Note reference (5). New wait (3).
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 64	; Note reference (0). Primary wait (0).
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 68	; Note reference (4). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 64	; Note reference (0). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 72	; Note reference (8). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 73	; Note reference (9). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 65. Primary wait (0).
	db 65	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 69	; Note reference (5). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 66	; Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 157	; Effect only. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 65. Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 71	; Note reference (7). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 69	; Note reference (5). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 82. Primary wait (0).
	db 82	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 66	; Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 69	; Note reference (5). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 66	; Note reference (2). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 69	; Note reference (5). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 93	; Effect only. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 67	; Note reference (3). Primary wait (0).
	db 2	;    Volume effect, with inverted volume: 0.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 82	;    Volume effect, with inverted volume: 5.

aliensong_Subsong0_Track21
	db 12	; Note with effects flag.
	db 135	; Note reference (7). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 178	;    Volume effect, with inverted volume: 11.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 91. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 91. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 66	;    Volume effect, with inverted volume: 4.

aliensong_Subsong0_Track22
	db 12	; Note with effects flag.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 178	; New instrument (4). Note reference (2). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 135	; Note reference (7). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 183	; New instrument (4). Note reference (7). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 178	; New instrument (4). Note reference (2). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 183	; New instrument (3). Note reference (7). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 130	; Note reference (2). Secondary wait (1).
	db 181	; New instrument (4). Note reference (5). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 190	; New instrument (3). New escaped note: 65. Secondary wait (1).
	db 65	;   Escape note value.
	db 3	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 65. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 133	; Note reference (5). Secondary wait (1).
	db 191	; New instrument (3). Same escaped note: 65. Secondary wait (1).
	db 3	;   Escape instrument value.
	db 181	; New instrument (4). Note reference (5). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 143	; Same escaped note: 65. Secondary wait (1).
	db 191	; New instrument (3). Same escaped note: 65. Secondary wait (1).
	db 3	;   Escape instrument value.
	db 133	; Note reference (5). Secondary wait (1).
	db 136	; Note reference (8). Secondary wait (1).
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 82. Secondary wait (1).
	db 82	;   Escape note value.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 176	; New instrument (4). Note reference (0). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 128	; Note reference (0). Secondary wait (1).
	db 138	; Note reference (10). Secondary wait (1).
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track23
	db 12	; Note with effects flag.
	db 240	; New instrument (1). Note reference (0). New wait (3).
	db 1	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 176	; New instrument (1). Note reference (0). Secondary wait (1).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 176	; New instrument (1). Note reference (0). Secondary wait (1).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 48	; New instrument (2). Note reference (0). 
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 48	; New instrument (1). Note reference (0). 
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 176	; New instrument (1). Note reference (0). Secondary wait (1).
	db 1	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 176	; New instrument (2). Note reference (0). Secondary wait (1).
	db 2	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 133	; Note reference (5). Secondary wait (1).
	db 197	; Note reference (5). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track24
	db 12	; Note with effects flag.
	db 135	; Note reference (7). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 178	;    Volume effect, with inverted volume: 11.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 91. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 91. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 184	; New instrument (6). Note reference (8). Secondary wait (1).
	db 6	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 82. Primary wait (0).
	db 82	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 175	; Secondary instrument (5). Same escaped note: 82. Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 106	; Secondary instrument (5). Note reference (10). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 106	; Secondary instrument (5). Note reference (10). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 166	; Secondary instrument (5). Note reference (6). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 89. Primary wait (0).
	db 89	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 66	;    Volume effect, with inverted volume: 4.

aliensong_Subsong0_Track25
	db 12	; Note with effects flag.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 82. Secondary wait (1).
	db 82	;   Escape note value.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 82. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 136	; Note reference (8). Secondary wait (1).
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 184	; New instrument (4). Note reference (8). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 143	; Same escaped note: 82. Secondary wait (1).
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 82. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 184	; New instrument (3). Note reference (8). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 143	; Same escaped note: 82. Secondary wait (1).
	db 190	; New instrument (4). New escaped note: 80. Secondary wait (1).
	db 80	;   Escape note value.
	db 4	;   Escape instrument value.
	db 190	; New instrument (3). New escaped note: 68. Secondary wait (1).
	db 68	;   Escape note value.
	db 3	;   Escape instrument value.
	db 191	; New instrument (4). Same escaped note: 68. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 80. Secondary wait (1).
	db 80	;   Escape note value.
	db 190	; New instrument (3). New escaped note: 68. Secondary wait (1).
	db 68	;   Escape note value.
	db 3	;   Escape instrument value.
	db 190	; New instrument (4). New escaped note: 80. Secondary wait (1).
	db 80	;   Escape note value.
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 68. Secondary wait (1).
	db 68	;   Escape note value.
	db 191	; New instrument (3). Same escaped note: 68. Secondary wait (1).
	db 3	;   Escape instrument value.
	db 142	; New escaped note: 80. Secondary wait (1).
	db 80	;   Escape note value.
	db 142	; New escaped note: 73. Secondary wait (1).
	db 73	;   Escape note value.
	db 191	; New instrument (4). Same escaped note: 73. Secondary wait (1).
	db 4	;   Escape instrument value.
	db 142	; New escaped note: 85. Secondary wait (1).
	db 85	;   Escape note value.
	db 190	; New instrument (3). New escaped note: 73. Secondary wait (1).
	db 73	;   Escape note value.
	db 3	;   Escape instrument value.
	db 128	; Note reference (0). Secondary wait (1).
	db 186	; New instrument (4). Note reference (10). Secondary wait (1).
	db 4	;   Escape instrument value.
	db 186	; New instrument (3). Note reference (10). Secondary wait (1).
	db 3	;   Escape instrument value.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

aliensong_Subsong0_Track26
	db 12	; Note with effects flag.
	db 126	; New instrument (6). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 6	;   Escape instrument value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 82. Primary wait (0).
	db 82	;   Escape note value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 80. Primary wait (0).
	db 80	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 82. Primary wait (0).
	db 82	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 80. Primary wait (0).
	db 80	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 75. Primary wait (0).
	db 75	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 104	; Secondary instrument (5). Note reference (8). Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 75. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 80. Primary wait (0).
	db 80	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (5). Same escaped note: 80. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 82. Primary wait (0).
	db 82	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 111	; Secondary instrument (5). Same escaped note: 82. Primary wait (0).
	db 12	; Note with effects flag.
	db 239	; Secondary instrument (5). Same escaped note: 82. New wait (127).
	db 127	;   Escape wait value.
	db 66	;    Volume effect, with inverted volume: 4.

aliensong_Subsong0_Track27
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (5). New escaped note: 91. Primary wait (0).
	db 91	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 242	;    Volume effect, with inverted volume: 15.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 194	;    Volume effect, with inverted volume: 12.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 178	;    Volume effect, with inverted volume: 11.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 130	; Note reference (2). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 132	; Note reference (4). Secondary wait (1).
	db 130	; Note reference (2). Secondary wait (1).
	db 132	; Note reference (4). Secondary wait (1).
	db 128	; Note reference (0). Secondary wait (1).
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 132	; Note reference (4). Secondary wait (1).
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (5). Note reference (6). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 98	; Secondary instrument (5). Note reference (2). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 101	; Secondary instrument (5). Note reference (5). Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 162	; Secondary instrument (5). Note reference (2). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 93	; Effect only. Primary wait (0).
	db 34	;    Volume effect, with inverted volume: 2.
	db 221	; Effect only. New wait (127).
	db 127	;   Escape wait value.
	db 66	;    Volume effect, with inverted volume: 4.

aliensong_Subsong0DisarkByteRegionEnd5
; The note indexes.
aliensong_Subsong0_NoteIndexes
aliensong_Subsong0DisarkByteRegionStart6
	db 72	; Note for index 0.
	db 93	; Note for index 1.
	db 79	; Note for index 2.
	db 81	; Note for index 3.
	db 74	; Note for index 4.
	db 77	; Note for index 5.
	db 86	; Note for index 6.
	db 67	; Note for index 7.
	db 70	; Note for index 8.
	db 69	; Note for index 9.
	db 84	; Note for index 10.
	db 83	; Note for index 11.
aliensong_Subsong0DisarkByteRegionEnd6

