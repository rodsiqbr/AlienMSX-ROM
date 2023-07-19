; Alien MSX Song file, Song part, encoded in the AKM (minimalist) format V0.


AlienMSXSongfile_Start
AlienMSXSongfile_StartDisarkGenerateExternalLabel

AlienMSXSongfile_DisarkPointerRegionStart0
	dw AlienMSXSongfile_InstrumentIndexes	; Index table for the Instruments.
AlienMSXSongfile_DisarkForceNonReferenceDuring2_1
	dw 0	; Index table for the Arpeggios.
AlienMSXSongfile_DisarkForceNonReferenceDuring2_2
	dw 0	; Index table for the Pitches.

; The subsongs references.
	dw AlienMSXSongfile_Subsong0
	dw AlienMSXSongfile_Subsong1
	dw AlienMSXSongfile_Subsong2
	dw AlienMSXSongfile_Subsong3
AlienMSXSongfile_DisarkPointerRegionEnd0

; The Instrument indexes.
AlienMSXSongfile_InstrumentIndexes
AlienMSXSongfile_DisarkPointerRegionStart3
	dw AlienMSXSongfile_Instrument0
	dw AlienMSXSongfile_Instrument1
	dw AlienMSXSongfile_Instrument2
	dw AlienMSXSongfile_Instrument3
	dw AlienMSXSongfile_Instrument4
	dw AlienMSXSongfile_Instrument5
	dw AlienMSXSongfile_Instrument6
	dw AlienMSXSongfile_Instrument7
	dw AlienMSXSongfile_Instrument8
AlienMSXSongfile_DisarkPointerRegionEnd3

; The Instrument.
AlienMSXSongfile_DisarkByteRegionStart4
AlienMSXSongfile_Instrument0
	db 255	; Speed.

AlienMSXSongfile_Instrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart5
	dw AlienMSXSongfile_Instrument0Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd5

AlienMSXSongfile_Instrument1
	db 0	; Speed.

AlienMSXSongfile_Instrument1Loop	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart6
	dw AlienMSXSongfile_Instrument1Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd6

AlienMSXSongfile_Instrument2
	db 0	; Speed.

AlienMSXSongfile_Instrument2Loop	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart7
	dw AlienMSXSongfile_Instrument2Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd7

AlienMSXSongfile_Instrument3
	db 0	; Speed.

AlienMSXSongfile_Instrument3Loop	db 29	; Volume: 7.

	db 29	; Volume: 7.

	db 29	; Volume: 7.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart8
	dw AlienMSXSongfile_Instrument3Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd8

AlienMSXSongfile_Instrument4
	db 0	; Speed.

AlienMSXSongfile_Instrument4Loop	db 37	; Volume: 9.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart9
	dw AlienMSXSongfile_Instrument4Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd9

AlienMSXSongfile_Instrument5
	db 0	; Speed.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 29	; Volume: 7.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 5	; Volume: 1.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart10
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd10

AlienMSXSongfile_Instrument6
	db 0	; Speed.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart11
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd11

AlienMSXSongfile_Instrument7
	db 0	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart12
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd12

AlienMSXSongfile_Instrument8
	db 4	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart13
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd13

AlienMSXSongfile_DisarkByteRegionEnd4
AlienMSXSongfile_ArpeggioIndexes
AlienMSXSongfile_DisarkPointerRegionStart14
AlienMSXSongfile_DisarkPointerRegionEnd14

AlienMSXSongfile_DisarkByteRegionStart15
AlienMSXSongfile_DisarkByteRegionEnd15

AlienMSXSongfile_PitchIndexes
AlienMSXSongfile_DisarkPointerRegionStart16
AlienMSXSongfile_DisarkPointerRegionEnd16

AlienMSXSongfile_DisarkByteRegionStart17
AlienMSXSongfile_DisarkByteRegionEnd17

; Alien MSX Song file, Subsong 0.
; ----------------------------------

AlienMSXSongfile_Subsong0
AlienMSXSongfile_Subsong0DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong0_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong0_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong0DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong0DisarkByteRegionStart1
	db 3	; Initial speed.

	db 8	; Most used instrument.
	db 1	; Second most used instrument.

	db 0	; Most used wait.
	db 3	; Second most used wait.

	db 70	; Default start note in tracks.
	db 6	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong0DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong0DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong0_Loop
	db 186	; State byte.
	db 15	; New height.
	db 129	; New track (0) for channel 1, as a reference (index 1).
	db 12	; New transposition on channel 2.
	db 129	; New track (0) for channel 2, as a reference (index 1).
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 1
	db 132	; State byte.
	db 24	; New transposition on channel 1.
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 2
	db 196	; State byte.
	db 0	; New transposition on channel 1.
	db 3	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 3
	db 132	; State byte.
	db 24	; New transposition on channel 1.
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 4
	db 196	; State byte.
	db 0	; New transposition on channel 1.
	db 5	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 5
	db 132	; State byte.
	db 24	; New transposition on channel 1.
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 6
	db 252	; State byte.
	db 0	; New transposition on channel 1.
	db 133	; New track (1) for channel 1, as a reference (index 5).
	db 2	; New transposition on channel 2.
	db 133	; New track (1) for channel 2, as a reference (index 5).
	db 8	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 7
	db 248	; State byte.
	db 134	; New track (2) for channel 1, as a reference (index 6).
	db 0	; New transposition on channel 2.
	db 134	; New track (2) for channel 2, as a reference (index 6).
	db 0	; New transposition on channel 3.
	db 136	; New track (15) for channel 3, as a reference (index 8).

; Pattern 8
	db 184	; State byte.
	db 132	; New track (3) for channel 1, as a reference (index 4).
	db -12	; New transposition on channel 2.
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 9
	db 168	; State byte.
	db 137	; New track (4) for channel 1, as a reference (index 9).
	db 137	; New track (4) for channel 2, as a reference (index 9).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 10
	db 232	; State byte.
	db 132	; New track (3) for channel 1, as a reference (index 4).
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 3	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 11
	db 168	; State byte.
	db 135	; New track (5) for channel 1, as a reference (index 7).
	db 135	; New track (5) for channel 2, as a reference (index 7).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 12
	db 232	; State byte.
	db 138	; New track (6) for channel 1, as a reference (index 10).
	db 138	; New track (6) for channel 2, as a reference (index 10).
	db 5	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 13
	db 168	; State byte.
	db 139	; New track (7) for channel 1, as a reference (index 11).
	db 139	; New track (7) for channel 2, as a reference (index 11).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 14
	db 248	; State byte.
	db 133	; New track (1) for channel 1, as a reference (index 5).
	db 1	; New transposition on channel 2.
	db 131	; New track (8) for channel 2, as a reference (index 3).
	db 8	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 15
	db 248	; State byte.
	db 134	; New track (2) for channel 1, as a reference (index 6).
	db 0	; New transposition on channel 2.
	db 140	; New track (12) for channel 2, as a reference (index 12).
	db 0	; New transposition on channel 3.
	db 136	; New track (15) for channel 3, as a reference (index 8).

; Pattern 16
	db 184	; State byte.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db -12	; New transposition on channel 2.
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 17
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong0_Track9 - ($ + 2)) & #ff00) / 256	; New track (9) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track9 - ($ + 1)) & 255)
	db 137	; New track (4) for channel 2, as a reference (index 9).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 18
	db 236	; State byte.
	db -1	; New transposition on channel 1.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 3	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 19
	db 172	; State byte.
	db 0	; New transposition on channel 1.
	db ((AlienMSXSongfile_Subsong0_Track10 - ($ + 2)) & #ff00) / 256	; New track (10) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track10 - ($ + 1)) & 255)
	db 135	; New track (5) for channel 2, as a reference (index 7).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 20
	db 232	; State byte.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 138	; New track (6) for channel 2, as a reference (index 10).
	db 5	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 21
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong0_Track11 - ($ + 2)) & #ff00) / 256	; New track (11) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track11 - ($ + 1)) & 255)
	db 139	; New track (7) for channel 2, as a reference (index 11).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 22
	db 252	; State byte.
	db 1	; New transposition on channel 1.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 0	; New transposition on channel 2.
	db 133	; New track (1) for channel 2, as a reference (index 5).
	db 8	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 23
	db 236	; State byte.
	db 0	; New transposition on channel 1.
	db 140	; New track (12) for channel 1, as a reference (index 12).
	db 134	; New track (2) for channel 2, as a reference (index 6).
	db 0	; New transposition on channel 3.
	db 136	; New track (15) for channel 3, as a reference (index 8).

; Pattern 24
	db 184	; State byte.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db -12	; New transposition on channel 2.
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 25
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong0_Track9 - ($ + 2)) & #ff00) / 256	; New track (9) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track9 - ($ + 1)) & 255)
	db 137	; New track (4) for channel 2, as a reference (index 9).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 26
	db 236	; State byte.
	db -1	; New transposition on channel 1.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 132	; New track (3) for channel 2, as a reference (index 4).
	db 3	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 27
	db 172	; State byte.
	db 0	; New transposition on channel 1.
	db ((AlienMSXSongfile_Subsong0_Track10 - ($ + 2)) & #ff00) / 256	; New track (10) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track10 - ($ + 1)) & 255)
	db 135	; New track (5) for channel 2, as a reference (index 7).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 28
	db 232	; State byte.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 138	; New track (6) for channel 2, as a reference (index 10).
	db 5	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 29
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong0_Track11 - ($ + 2)) & #ff00) / 256	; New track (11) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong0_Track11 - ($ + 1)) & 255)
	db 139	; New track (7) for channel 2, as a reference (index 11).
	db 130	; New track (14) for channel 3, as a reference (index 2).

; Pattern 30
	db 252	; State byte.
	db 1	; New transposition on channel 1.
	db 131	; New track (8) for channel 1, as a reference (index 3).
	db 0	; New transposition on channel 2.
	db 133	; New track (1) for channel 2, as a reference (index 5).
	db 8	; New transposition on channel 3.
	db 128	; New track (13) for channel 3, as a reference (index 0).

; Pattern 31
	db 236	; State byte.
	db 0	; New transposition on channel 1.
	db 140	; New track (12) for channel 1, as a reference (index 12).
	db 134	; New track (2) for channel 2, as a reference (index 6).
	db 0	; New transposition on channel 3.
	db 136	; New track (15) for channel 3, as a reference (index 8).

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong0DisarkByteRegionEnd2
AlienMSXSongfile_Subsong0DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong0_Loop

AlienMSXSongfile_Subsong0DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong0_TrackIndexes
AlienMSXSongfile_Subsong0DisarkPointerRegionStart4
	dw AlienMSXSongfile_Subsong0_Track13	; Track 13, index 0.
	dw AlienMSXSongfile_Subsong0_Track0	; Track 0, index 1.
	dw AlienMSXSongfile_Subsong0_Track14	; Track 14, index 2.
	dw AlienMSXSongfile_Subsong0_Track8	; Track 8, index 3.
	dw AlienMSXSongfile_Subsong0_Track3	; Track 3, index 4.
	dw AlienMSXSongfile_Subsong0_Track1	; Track 1, index 5.
	dw AlienMSXSongfile_Subsong0_Track2	; Track 2, index 6.
	dw AlienMSXSongfile_Subsong0_Track5	; Track 5, index 7.
	dw AlienMSXSongfile_Subsong0_Track15	; Track 15, index 8.
	dw AlienMSXSongfile_Subsong0_Track4	; Track 4, index 9.
	dw AlienMSXSongfile_Subsong0_Track6	; Track 6, index 10.
	dw AlienMSXSongfile_Subsong0_Track7	; Track 7, index 11.
	dw AlienMSXSongfile_Subsong0_Track12	; Track 12, index 12.
AlienMSXSongfile_Subsong0DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong0DisarkByteRegionStart5
AlienMSXSongfile_Subsong0_Track0
	db 99	; Secondary instrument (1). Note reference (3). Primary wait (0).
	db 115	; New instrument (3). Note reference (3). Primary wait (0).
	db 3	;   Escape instrument value.
	db 99	; Secondary instrument (1). Note reference (3). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 64	; Note reference (0). Primary wait (0).
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 64	; Note reference (0). Primary wait (0).
	db 99	; Secondary instrument (1). Note reference (3). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 99	; Secondary instrument (1). Note reference (3). Primary wait (0).
	db 67	; Note reference (3). Primary wait (0).
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 64	; Note reference (0). Primary wait (0).
	db 96	; Secondary instrument (1). Note reference (0). Primary wait (0).
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track1
	db 243	; New instrument (4). Note reference (3). New wait (127).
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track2
	db 254	; New instrument (4). New escaped note: 38. New wait (127).
	db 38	;   Escape note value.
	db 4	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track3
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 101	; Secondary instrument (1). Note reference (5). Primary wait (0).
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 241	; New instrument (2). Note reference (1). New wait (127).
	db 2	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track4
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 182	; New instrument (5). Note reference (6). Secondary wait (3).
	db 5	;   Escape instrument value.
	db 132	; Note reference (4). Secondary wait (3).
	db 197	; Note reference (5). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track5
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 180	; New instrument (5). Note reference (4). Secondary wait (3).
	db 5	;   Escape instrument value.
	db 134	; Note reference (6). Secondary wait (3).
	db 200	; Note reference (8). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track6
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 101	; Secondary instrument (1). Note reference (5). Primary wait (0).
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 97	; Secondary instrument (1). Note reference (1). Primary wait (0).
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 102	; Secondary instrument (1). Note reference (6). Primary wait (0).
	db 246	; New instrument (2). Note reference (6). New wait (127).
	db 2	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track7
	db 118	; New instrument (3). Note reference (6). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 101	; Secondary instrument (1). Note reference (5). Primary wait (0).
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 100	; Secondary instrument (1). Note reference (4). Primary wait (0).
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track8
	db 176	; New instrument (0). Note reference (0). Secondary wait (3).
	db 0	;   Escape instrument value.
	db 98	; Secondary instrument (1). Note reference (2). Primary wait (0).
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 98	; Secondary instrument (1). Note reference (2). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 114	; New instrument (3). Note reference (2). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 98	; Secondary instrument (1). Note reference (2). Primary wait (0).
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 98	; Secondary instrument (1). Note reference (2). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 114	; New instrument (3). Note reference (2). Primary wait (0).
	db 3	;   Escape instrument value.
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track9
	db 178	; New instrument (5). Note reference (2). Secondary wait (3).
	db 5	;   Escape instrument value.
	db 142	; New escaped note: 68. Secondary wait (3).
	db 68	;   Escape note value.
	db 130	; Note reference (2). Secondary wait (3).
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track10
	db 190	; New instrument (5). New escaped note: 68. Secondary wait (3).
	db 68	;   Escape note value.
	db 5	;   Escape instrument value.
	db 142	; New escaped note: 70. Secondary wait (3).
	db 70	;   Escape note value.
	db 134	; Note reference (6). Secondary wait (3).
	db 200	; Note reference (8). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track11
	db 194	; Note reference (2). New wait (7).
	db 7	;   Escape wait value.
	db 98	; Secondary instrument (1). Note reference (2). Primary wait (0).
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 114	; New instrument (3). Note reference (2). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track12
	db 207	; Same escaped note: 70. New wait (7).
	db 7	;   Escape wait value.
	db 184	; New instrument (5). Note reference (8). Secondary wait (3).
	db 5	;   Escape instrument value.
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track13
	db 135	; Note reference (7). Secondary wait (3).
	db 195	; Note reference (3). New wait (1).
	db 1	;   Escape wait value.
	db 135	; Note reference (7). Secondary wait (3).
	db 7	; Note reference (7). 
	db 195	; Note reference (3). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track14
	db 135	; Note reference (7). Secondary wait (3).
	db 131	; Note reference (3). Secondary wait (3).
	db 135	; Note reference (7). Secondary wait (3).
	db 195	; Note reference (3). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track15
	db 142	; New escaped note: 34. Secondary wait (3).
	db 34	;   Escape note value.
	db 142	; New escaped note: 46. Secondary wait (3).
	db 46	;   Escape note value.
	db 131	; Note reference (3). Secondary wait (3).
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong0_NoteIndexes
AlienMSXSongfile_Subsong0DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong0DisarkByteRegionEnd6

; Alien MSX Song file, Subsong 1.
; ----------------------------------

AlienMSXSongfile_Subsong1
AlienMSXSongfile_Subsong1DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong1_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong1_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong1DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong1DisarkByteRegionStart1
	db 6	; Initial speed.

	db 8	; Most used instrument.
	db 1	; Second most used instrument.

	db 0	; Most used wait.
	db 3	; Second most used wait.

	db 0	; Default start note in tracks.
	db 0	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong1DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong1DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong1_Loop
	db 170	; State byte.
	db 7	; New height.
	db 128	; New track (0) for channel 1, as a reference (index 0).
	db 128	; New track (0) for channel 2, as a reference (index 0).
	db 128	; New track (0) for channel 3, as a reference (index 0).

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong1DisarkByteRegionEnd2
AlienMSXSongfile_Subsong1DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong1_Loop

AlienMSXSongfile_Subsong1DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong1_TrackIndexes
AlienMSXSongfile_Subsong1DisarkPointerRegionStart4
	dw AlienMSXSongfile_Subsong1_Track0	; Track 0, index 0.
AlienMSXSongfile_Subsong1DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong1DisarkByteRegionStart5
AlienMSXSongfile_Subsong1_Track0
	db 205	; New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong1DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong1_NoteIndexes
AlienMSXSongfile_Subsong1DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong1DisarkByteRegionEnd6

; Alien MSX Song file, Subsong 2.
; ----------------------------------

AlienMSXSongfile_Subsong2
AlienMSXSongfile_Subsong2DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong2_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong2_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong2DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong2DisarkByteRegionStart1
	db 6	; Initial speed.

	db 8	; Most used instrument.
	db 1	; Second most used instrument.

	db 0	; Most used wait.
	db 3	; Second most used wait.

	db 56	; Default start note in tracks.
	db 0	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong2DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong2DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong2_Loop
	db 171	; State byte.
	db 9	; New speed (>0).
	db 63	; New height.
	db ((AlienMSXSongfile_Subsong2_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong2_Track0 - ($ + 1)) & 255)
	db ((AlienMSXSongfile_Subsong2_Track1 - ($ + 2)) & #ff00) / 256	; New track (1) for channel 2, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong2_Track1 - ($ + 1)) & 255)
	db ((AlienMSXSongfile_Subsong2_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong2_Track2 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong2DisarkByteRegionEnd2
AlienMSXSongfile_Subsong2DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong2_Loop

AlienMSXSongfile_Subsong2DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong2_TrackIndexes
AlienMSXSongfile_Subsong2DisarkPointerRegionStart4
AlienMSXSongfile_Subsong2DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong2DisarkByteRegionStart5
AlienMSXSongfile_Subsong2_Track0
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 56. Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 222	; Primary instrument (8). New escaped note: 64. New wait (1).
	db 64	;   Escape note value.
	db 1	;   Escape wait value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 66. 
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 66. 
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 30	; Primary instrument (8). New escaped note: 66. 
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 64. 
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 21	; Primary instrument (8). Note reference (5). 
	db 94	; Primary instrument (8). New escaped note: 54. Primary wait (0).
	db 54	;   Escape note value.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 213	; Primary instrument (8). Note reference (5). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong2_Track1
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 49. New wait (15).
	db 49	;   Escape note value.
	db 15	;   Escape wait value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 30	; Primary instrument (8). New escaped note: 47. 
	db 47	;   Escape note value.
	db 222	; Primary instrument (8). New escaped note: 45. New wait (7).
	db 45	;   Escape note value.
	db 7	;   Escape wait value.
	db 30	; Primary instrument (8). New escaped note: 42. 
	db 42	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 44. 
	db 44	;   Escape note value.
	db 223	; Primary instrument (8). Same escaped note: 44. New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong2_Track2
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 37. New wait (15).
	db 37	;   Escape note value.
	db 15	;   Escape wait value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 30	; Primary instrument (8). New escaped note: 35. 
	db 35	;   Escape note value.
	db 222	; Primary instrument (8). New escaped note: 33. New wait (7).
	db 33	;   Escape note value.
	db 7	;   Escape wait value.
	db 30	; Primary instrument (8). New escaped note: 30. 
	db 30	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 32. 
	db 32	;   Escape note value.
	db 223	; Primary instrument (8). Same escaped note: 32. New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong2DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong2_NoteIndexes
AlienMSXSongfile_Subsong2DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong2DisarkByteRegionEnd6

; Alien MSX Song file, Subsong 3.
; ----------------------------------

AlienMSXSongfile_Subsong3
AlienMSXSongfile_Subsong3DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong3_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong3_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong3DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong3DisarkByteRegionStart1
	db 6	; Initial speed.

	db 8	; Most used instrument.
	db 1	; Second most used instrument.

	db 0	; Most used wait.
	db 3	; Second most used wait.

	db 70	; Default start note in tracks.
	db 7	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong3DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong3DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong3_Loop
	db 171	; State byte.
	db 7	; New speed (>0).
	db 7	; New height.
	db 129	; New track (1) for channel 1, as a reference (index 1).
	db 128	; New track (0) for channel 2, as a reference (index 0).
	db 128	; New track (0) for channel 3, as a reference (index 0).

; Pattern 1
	db 0	; State byte.

; Pattern 2
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong3_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong3_Track2 - ($ + 1)) & 255)
	db 130	; New track (4) for channel 2, as a reference (index 2).
	db 130	; New track (4) for channel 3, as a reference (index 2).

; Pattern 3
	db 0	; State byte.

; Pattern 4
	db 168	; State byte.
	db 129	; New track (1) for channel 1, as a reference (index 1).
	db 128	; New track (0) for channel 2, as a reference (index 0).
	db 128	; New track (0) for channel 3, as a reference (index 0).

; Pattern 5
	db 0	; State byte.

; Pattern 6
	db 168	; State byte.
	db ((AlienMSXSongfile_Subsong3_Track3 - ($ + 2)) & #ff00) / 256	; New track (3) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong3_Track3 - ($ + 1)) & 255)
	db 131	; New track (5) for channel 2, as a reference (index 3).
	db 131	; New track (5) for channel 3, as a reference (index 3).

; Pattern 7
	db 0	; State byte.

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong3DisarkByteRegionEnd2
AlienMSXSongfile_Subsong3DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong3_Loop

AlienMSXSongfile_Subsong3DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong3_TrackIndexes
AlienMSXSongfile_Subsong3DisarkPointerRegionStart4
	dw AlienMSXSongfile_Subsong3_Track0	; Track 0, index 0.
	dw AlienMSXSongfile_Subsong3_Track1	; Track 1, index 1.
	dw AlienMSXSongfile_Subsong3_Track4	; Track 4, index 2.
	dw AlienMSXSongfile_Subsong3_Track5	; Track 5, index 3.
AlienMSXSongfile_Subsong3DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong3DisarkByteRegionStart5
AlienMSXSongfile_Subsong3_Track0
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 46. New wait (127).
	db 46	;   Escape note value.
	db 127	;   Escape wait value.
	db 130	;    Volume effect, with inverted volume: 8.

AlienMSXSongfile_Subsong3_Track1
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 70. Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 70	; Note reference (6). Primary wait (0).
	db 206	; New escaped note: 62. New wait (1).
	db 62	;   Escape note value.
	db 1	;   Escape wait value.
	db 78	; New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 70	; Note reference (6). Primary wait (0).
	db 206	; New escaped note: 62. New wait (127).
	db 62	;   Escape note value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong3_Track2
	db 66	; Note reference (2). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 193	; Note reference (1). New wait (1).
	db 1	;   Escape wait value.
	db 66	; Note reference (2). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 193	; Note reference (1). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong3_Track3
	db 72	; Note reference (8). Primary wait (0).
	db 70	; Note reference (6). Primary wait (0).
	db 197	; Note reference (5). New wait (1).
	db 1	;   Escape wait value.
	db 72	; Note reference (8). Primary wait (0).
	db 70	; Note reference (6). Primary wait (0).
	db 197	; Note reference (5). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong3_Track4
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 45. New wait (127).
	db 45	;   Escape note value.
	db 127	;   Escape wait value.
	db 130	;    Volume effect, with inverted volume: 8.

AlienMSXSongfile_Subsong3_Track5
	db 12	; Note with effects flag.
	db 208	; Primary instrument (8). Note reference (0). New wait (127).
	db 127	;   Escape wait value.
	db 130	;    Volume effect, with inverted volume: 8.

AlienMSXSongfile_Subsong3DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong3_NoteIndexes
AlienMSXSongfile_Subsong3DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong3DisarkByteRegionEnd6

