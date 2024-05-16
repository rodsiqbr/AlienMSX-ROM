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
	dw AlienMSXSongfile_Subsong4
	dw AlienMSXSongfile_Subsong5
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
	dw AlienMSXSongfile_Instrument9
	dw AlienMSXSongfile_Instrument10
	dw AlienMSXSongfile_Instrument11
	dw AlienMSXSongfile_Instrument12
	dw AlienMSXSongfile_Instrument13
	dw AlienMSXSongfile_Instrument14
	dw AlienMSXSongfile_Instrument15
	dw AlienMSXSongfile_Instrument16
	dw AlienMSXSongfile_Instrument17
	dw AlienMSXSongfile_Instrument18
	dw AlienMSXSongfile_Instrument19
	dw AlienMSXSongfile_Instrument20
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

AlienMSXSongfile_Instrument9
	db 0	; Speed.

	db 189	; Volume: 15.
	db 49	; Arpeggio: 24.
	db 15	; Noise: 15.

	db 189	; Volume: 15.
	db 25	; Arpeggio: 12.
	db 8	; Noise: 8.

	db 185	; Volume: 14.
	db 17	; Arpeggio: 8.
	db 1	; Noise: 1.

	db 185	; Volume: 14.
	db 10	; Arpeggio: 5.

	db 181	; Volume: 13.
	db 8	; Arpeggio: 4.

	db 181	; Volume: 13.
	db 6	; Arpeggio: 3.

	db 181	; Volume: 13.
	db 4	; Arpeggio: 2.

	db 177	; Volume: 12.
	db 2	; Arpeggio: 1.

	db 113	; Volume: 12.
	dw -3	; Pitch: -3.

	db 113	; Volume: 12.
	dw -2	; Pitch: -2.

	db 109	; Volume: 11.
	dw -1	; Pitch: -1.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 41	; Volume: 10.

AlienMSXSongfile_Instrument9Loop	db 113	; Volume: 12.
	dw -4	; Pitch: -4.

	db 113	; Volume: 12.
	dw -8	; Pitch: -8.

	db 113	; Volume: 12.
	dw -16	; Pitch: -16.

	db 109	; Volume: 11.
	dw -14	; Pitch: -14.

	db 109	; Volume: 11.
	dw -12	; Pitch: -12.

	db 109	; Volume: 11.
	dw -10	; Pitch: -10.

	db 105	; Volume: 10.
	dw -8	; Pitch: -8.

	db 105	; Volume: 10.
	dw -6	; Pitch: -6.

	db 105	; Volume: 10.
	dw -5	; Pitch: -5.

	db 105	; Volume: 10.
	dw -4	; Pitch: -4.

	db 105	; Volume: 10.
	dw -3	; Pitch: -3.

	db 105	; Volume: 10.
	dw -2	; Pitch: -2.

	db 109	; Volume: 11.
	dw -1	; Pitch: -1.

	db 109	; Volume: 11.
	dw -1	; Pitch: -1.

	db 45	; Volume: 11.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart14
	dw AlienMSXSongfile_Instrument9Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd14

AlienMSXSongfile_Instrument10
	db 0	; Speed.

AlienMSXSongfile_Instrument10Loop	db 82
	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart15
	dw AlienMSXSongfile_Instrument10Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd15

AlienMSXSongfile_Instrument11
	db 0	; Speed.

	db 189	; Volume: 15.
	db 49	; Arpeggio: 24.
	db 31	; Noise: 31.

	db 189	; Volume: 15.
	db 25	; Arpeggio: 12.
	db 24	; Noise: 24.

	db 189	; Volume: 15.
	db 19	; Arpeggio: 9.
	db 16	; Noise: 16.

	db 189	; Volume: 15.
	db 15	; Arpeggio: 7.
	db 8	; Noise: 8.

	db 189	; Volume: 15.
	db 13	; Arpeggio: 6.
	db 8	; Noise: 8.

	db 189	; Volume: 15.
	db 11	; Arpeggio: 5.
	db 5	; Noise: 5.

	db 189	; Volume: 15.
	db 9	; Arpeggio: 4.
	db 4	; Noise: 4.

	db 189	; Volume: 15.
	db 7	; Arpeggio: 3.
	db 3	; Noise: 3.

	db 189	; Volume: 15.
	db 5	; Arpeggio: 2.
	db 3	; Noise: 3.

	db 189	; Volume: 15.
	db 3	; Arpeggio: 1.
	db 2	; Noise: 2.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 2	; Noise: 2.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 2	; Noise: 2.

	db 240	; Volume: 14.
	db 1	; Noise.

	db 240	; Volume: 14.
	db 1	; Noise.

	db 240	; Volume: 14.
	db 1	; Noise.

	db 232	; Volume: 13.
	db 1	; Noise.

	db 232	; Volume: 13.
	db 1	; Noise.

	db 232	; Volume: 13.
	db 1	; Noise.

	db 224	; Volume: 12.
	db 1	; Noise.

	db 224	; Volume: 12.
	db 1	; Noise.

	db 224	; Volume: 12.
	db 1	; Noise.

	db 216	; Volume: 11.
	db 1	; Noise.

	db 216	; Volume: 11.
	db 1	; Noise.

	db 216	; Volume: 11.
	db 1	; Noise.

	db 208	; Volume: 10.
	db 1	; Noise.

	db 208	; Volume: 10.
	db 1	; Noise.

	db 208	; Volume: 10.
	db 1	; Noise.

	db 200	; Volume: 9.
	db 1	; Noise.

	db 200	; Volume: 9.
	db 1	; Noise.

	db 200	; Volume: 9.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 184	; Volume: 7.
	db 1	; Noise.

	db 184	; Volume: 7.
	db 1	; Noise.

	db 184	; Volume: 7.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 152	; Volume: 3.
	db 1	; Noise.

	db 152	; Volume: 3.
	db 1	; Noise.

	db 152	; Volume: 3.
	db 1	; Noise.

	db 152	; Volume: 3.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart16
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd16

AlienMSXSongfile_Instrument12
	db 0	; Speed.

	db 169	; Volume: 10.
	db 24	; Arpeggio: 12.

	db 57	; Volume: 14.

	db 49	; Volume: 12.

	db 41	; Volume: 10.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart17
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd17

AlienMSXSongfile_Instrument13
	db 0	; Speed.

	db 177	; Volume: 12.
	db 48	; Arpeggio: 24.

	db 181	; Volume: 13.
	db 38	; Arpeggio: 19.

	db 185	; Volume: 14.
	db 30	; Arpeggio: 15.

	db 185	; Volume: 14.
	db 24	; Arpeggio: 12.

	db 185	; Volume: 14.
	db 14	; Arpeggio: 7.

	db 185	; Volume: 14.
	db 6	; Arpeggio: 3.

	db 57	; Volume: 14.

	db 173	; Volume: 11.
	db 48	; Arpeggio: 24.

	db 173	; Volume: 11.
	db 38	; Arpeggio: 19.

	db 173	; Volume: 11.
	db 30	; Arpeggio: 15.

	db 173	; Volume: 11.
	db 24	; Arpeggio: 12.

	db 173	; Volume: 11.
	db 14	; Arpeggio: 7.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 45	; Volume: 11.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart18
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd18

AlienMSXSongfile_Instrument14
	db 0	; Speed.

	db 49	; Volume: 12.

	db 53	; Volume: 13.

	db 57	; Volume: 14.

	db 185	; Volume: 14.
	db 6	; Arpeggio: 3.

	db 185	; Volume: 14.
	db 14	; Arpeggio: 7.

	db 185	; Volume: 14.
	db 24	; Arpeggio: 12.

	db 185	; Volume: 14.
	db 24	; Arpeggio: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 173	; Volume: 11.
	db 14	; Arpeggio: 7.

AlienMSXSongfile_Instrument14Loop	db 221	; Volume: 7.
	db 24	; Arpeggio: 12.
	dw 1	; Pitch: 1.

	db 221	; Volume: 7.
	db 24	; Arpeggio: 12.
	dw -1	; Pitch: -1.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart19
	dw AlienMSXSongfile_Instrument14Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd19

AlienMSXSongfile_Instrument15
	db 0	; Speed.

	db 49	; Volume: 12.

	db 53	; Volume: 13.

AlienMSXSongfile_Instrument15Loop	db 109	; Volume: 11.
	dw 8	; Pitch: 8.

	db 109	; Volume: 11.
	dw -8	; Pitch: -8.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart20
	dw AlienMSXSongfile_Instrument15Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd20

AlienMSXSongfile_Instrument16
	db 0	; Speed.

	db 177	; Volume: 12.
	db 30	; Arpeggio: 15.

	db 181	; Volume: 13.
	db 24	; Arpeggio: 12.

	db 185	; Volume: 14.
	db 14	; Arpeggio: 7.

	db 189	; Volume: 15.
	db 6	; Arpeggio: 3.

	db 61	; Volume: 15.

	db 61	; Volume: 15.

	db 185	; Volume: 14.
	db 6	; Arpeggio: 3.

	db 185	; Volume: 14.
	db 6	; Arpeggio: 3.

	db 181	; Volume: 13.
	db 14	; Arpeggio: 7.

	db 181	; Volume: 13.
	db 14	; Arpeggio: 7.

	db 49	; Volume: 12.

	db 49	; Volume: 12.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 169	; Volume: 10.
	db 14	; Arpeggio: 7.

	db 169	; Volume: 10.
	db 14	; Arpeggio: 7.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart21
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd21

AlienMSXSongfile_Instrument17
	db 0	; Speed.

	db 177	; Volume: 12.
	db 31	; Arpeggio: 15.
	db 8	; Noise: 8.

	db 181	; Volume: 13.
	db 25	; Arpeggio: 12.
	db 7	; Noise: 7.

	db 185	; Volume: 14.
	db 15	; Arpeggio: 7.
	db 6	; Noise: 6.

	db 189	; Volume: 15.
	db 7	; Arpeggio: 3.
	db 5	; Noise: 5.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 4	; Noise: 4.

	db 189	; Volume: 15.
	db 1	; Arpeggio: 0.
	db 3	; Noise: 3.

	db 185	; Volume: 14.
	db 7	; Arpeggio: 3.
	db 2	; Noise: 2.

	db 185	; Volume: 14.
	db 7	; Arpeggio: 3.
	db 1	; Noise: 1.

	db 181	; Volume: 13.
	db 14	; Arpeggio: 7.

	db 181	; Volume: 13.
	db 14	; Arpeggio: 7.

	db 49	; Volume: 12.

	db 49	; Volume: 12.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 173	; Volume: 11.
	db 6	; Arpeggio: 3.

	db 169	; Volume: 10.
	db 14	; Arpeggio: 7.

	db 169	; Volume: 10.
	db 14	; Arpeggio: 7.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart22
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd22

AlienMSXSongfile_Instrument18
	db 0	; Speed.

	db 169	; Volume: 10.
	db 25	; Arpeggio: 12.
	db 5	; Noise: 5.

	db 185	; Volume: 14.
	db 1	; Arpeggio: 0.
	db 4	; Noise: 4.

	db 177	; Volume: 12.
	db 1	; Arpeggio: 0.
	db 3	; Noise: 3.

	db 169	; Volume: 10.
	db 1	; Arpeggio: 0.
	db 2	; Noise: 2.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart23
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd23

AlienMSXSongfile_Instrument19
	db 0	; Speed.

	db 165	; Volume: 9.
	db 24	; Arpeggio: 12.

	db 169	; Volume: 10.
	db 6	; Arpeggio: 3.

	db 173	; Volume: 11.
	db 4	; Arpeggio: 2.

	db 177	; Volume: 12.
	db 24	; Arpeggio: 12.

	db 177	; Volume: 12.
	db 2	; Arpeggio: 1.

	db 177	; Volume: 12.
	db 2	; Arpeggio: 1.

	db 173	; Volume: 11.
	db 24	; Arpeggio: 12.

	db 41	; Volume: 10.

AlienMSXSongfile_Instrument19Loop	db 37	; Volume: 9.

	db 161	; Volume: 8.
	db 24	; Arpeggio: 12.

	db 93	; Volume: 7.
	dw -1	; Pitch: -1.

	db 93	; Volume: 7.
	dw -1	; Pitch: -1.

	db 161	; Volume: 8.
	db 24	; Arpeggio: 12.

	db 33	; Volume: 8.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart24
	dw AlienMSXSongfile_Instrument19Loop	; Loops.
AlienMSXSongfile_DisarkPointerRegionEnd24

AlienMSXSongfile_Instrument20
	db 0	; Speed.

	db 189	; Volume: 15.
	db 49	; Arpeggio: 24.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 25	; Arpeggio: 12.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 19	; Arpeggio: 9.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 17	; Arpeggio: 8.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 15	; Arpeggio: 7.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 13	; Arpeggio: 6.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 11	; Arpeggio: 5.
	db 1	; Noise: 1.

	db 189	; Volume: 15.
	db 9	; Arpeggio: 4.
	db 1	; Noise: 1.

	db 185	; Volume: 14.
	db 7	; Arpeggio: 3.
	db 1	; Noise: 1.

	db 181	; Volume: 13.
	db 5	; Arpeggio: 2.
	db 1	; Noise: 1.

	db 177	; Volume: 12.
	db 3	; Arpeggio: 1.
	db 1	; Noise: 1.

	db 173	; Volume: 11.
	db 1	; Arpeggio: 0.
	db 1	; Noise: 1.

	db 208	; Volume: 10.
	db 1	; Noise.

	db 200	; Volume: 9.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 184	; Volume: 7.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 152	; Volume: 3.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 4	; End the instrument.
AlienMSXSongfile_DisarkPointerRegionStart25
	dw AlienMSXSongfile_Instrument0Loop	; Loop to silence.
AlienMSXSongfile_DisarkPointerRegionEnd25

AlienMSXSongfile_DisarkByteRegionEnd4
AlienMSXSongfile_ArpeggioIndexes
AlienMSXSongfile_DisarkPointerRegionStart26
AlienMSXSongfile_DisarkPointerRegionEnd26

AlienMSXSongfile_DisarkByteRegionStart27
AlienMSXSongfile_DisarkByteRegionEnd27

AlienMSXSongfile_PitchIndexes
AlienMSXSongfile_DisarkPointerRegionStart28
AlienMSXSongfile_DisarkPointerRegionEnd28

AlienMSXSongfile_DisarkByteRegionStart29
AlienMSXSongfile_DisarkByteRegionEnd29

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
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

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
	db 115	; New instrument (1). Note reference (3). Primary wait (0).
	db 1	;   Escape instrument value.
	db 115	; New instrument (3). Note reference (3). Primary wait (0).
	db 3	;   Escape instrument value.
	db 115	; New instrument (1). Note reference (3). Primary wait (0).
	db 1	;   Escape instrument value.
	db 115	; New instrument (3). Note reference (3). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 112	; New instrument (3). Note reference (0). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 112	; New instrument (3). Note reference (0). Primary wait (0).
	db 3	;   Escape instrument value.
	db 115	; New instrument (1). Note reference (3). Primary wait (0).
	db 1	;   Escape instrument value.
	db 115	; New instrument (3). Note reference (3). Primary wait (0).
	db 3	;   Escape instrument value.
	db 115	; New instrument (1). Note reference (3). Primary wait (0).
	db 1	;   Escape instrument value.
	db 115	; New instrument (3). Note reference (3). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 112	; New instrument (3). Note reference (0). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (1). Note reference (0). Primary wait (0).
	db 1	;   Escape instrument value.
	db 240	; New instrument (3). Note reference (0). New wait (127).
	db 3	;   Escape instrument value.
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
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 117	; New instrument (1). Note reference (5). Primary wait (0).
	db 1	;   Escape instrument value.
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (1). Note reference (4). Primary wait (0).
	db 1	;   Escape instrument value.
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 241	; New instrument (2). Note reference (1). New wait (127).
	db 2	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track4
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 246	; New instrument (5). Note reference (6). New wait (3).
	db 5	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 4	; Note reference (4). 
	db 197	; Note reference (5). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track5
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 244	; New instrument (5). Note reference (4). New wait (3).
	db 5	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 6	; Note reference (6). 
	db 200	; Note reference (8). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track6
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 113	; New instrument (3). Note reference (1). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 117	; New instrument (1). Note reference (5). Primary wait (0).
	db 1	;   Escape instrument value.
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 113	; New instrument (1). Note reference (1). Primary wait (0).
	db 1	;   Escape instrument value.
	db 113	; New instrument (2). Note reference (1). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (1). Note reference (4). Primary wait (0).
	db 1	;   Escape instrument value.
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 118	; New instrument (1). Note reference (6). Primary wait (0).
	db 1	;   Escape instrument value.
	db 246	; New instrument (2). Note reference (6). New wait (127).
	db 2	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track7
	db 118	; New instrument (3). Note reference (6). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 116	; New instrument (1). Note reference (4). Primary wait (0).
	db 1	;   Escape instrument value.
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 117	; New instrument (1). Note reference (5). Primary wait (0).
	db 1	;   Escape instrument value.
	db 117	; New instrument (2). Note reference (5). Primary wait (0).
	db 2	;   Escape instrument value.
	db 117	; New instrument (3). Note reference (5). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 116	; New instrument (1). Note reference (4). Primary wait (0).
	db 1	;   Escape instrument value.
	db 116	; New instrument (2). Note reference (4). Primary wait (0).
	db 2	;   Escape instrument value.
	db 116	; New instrument (3). Note reference (4). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 192	; Note reference (0). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track8
	db 240	; New instrument (0). Note reference (0). New wait (3).
	db 0	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 114	; New instrument (1). Note reference (2). Primary wait (0).
	db 1	;   Escape instrument value.
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 114	; New instrument (1). Note reference (2). Primary wait (0).
	db 1	;   Escape instrument value.
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 114	; New instrument (3). Note reference (2). Primary wait (0).
	db 3	;   Escape instrument value.
	db 112	; New instrument (0). Note reference (0). Primary wait (0).
	db 0	;   Escape instrument value.
	db 114	; New instrument (1). Note reference (2). Primary wait (0).
	db 1	;   Escape instrument value.
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 114	; New instrument (1). Note reference (2). Primary wait (0).
	db 1	;   Escape instrument value.
	db 114	; New instrument (2). Note reference (2). Primary wait (0).
	db 2	;   Escape instrument value.
	db 114	; New instrument (3). Note reference (2). Primary wait (0).
	db 3	;   Escape instrument value.
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track9
	db 242	; New instrument (5). Note reference (2). New wait (3).
	db 5	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 14	; New escaped note: 68. 
	db 68	;   Escape note value.
	db 2	; Note reference (2). 
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track10
	db 254	; New instrument (5). New escaped note: 68. New wait (3).
	db 68	;   Escape note value.
	db 5	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 14	; New escaped note: 70. 
	db 70	;   Escape note value.
	db 6	; Note reference (6). 
	db 200	; Note reference (8). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track11
	db 194	; Note reference (2). New wait (7).
	db 7	;   Escape wait value.
	db 114	; New instrument (1). Note reference (2). Primary wait (0).
	db 1	;   Escape instrument value.
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
	db 248	; New instrument (5). Note reference (8). New wait (3).
	db 5	;   Escape instrument value.
	db 3	;   Escape wait value.
	db 240	; New instrument (0). Note reference (0). New wait (127).
	db 0	;   Escape instrument value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track13
	db 199	; Note reference (7). New wait (3).
	db 3	;   Escape wait value.
	db 131	; Note reference (3). Secondary wait (1).
	db 7	; Note reference (7). 
	db 135	; Note reference (7). Secondary wait (1).
	db 195	; Note reference (3). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track14
	db 199	; Note reference (7). New wait (3).
	db 3	;   Escape wait value.
	db 3	; Note reference (3). 
	db 7	; Note reference (7). 
	db 195	; Note reference (3). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong0_Track15
	db 206	; New escaped note: 34. New wait (3).
	db 34	;   Escape note value.
	db 3	;   Escape wait value.
	db 14	; New escaped note: 46. 
	db 46	;   Escape note value.
	db 3	; Note reference (3). 
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
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

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
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

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
	db 8	; New speed (>0).
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
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 66. Secondary wait (1).
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 66. Secondary wait (1).
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 81	; Primary instrument (8). Note reference (1). Primary wait (0).
	db 158	; Primary instrument (8). New escaped note: 66. Secondary wait (1).
	db 66	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 158	; Primary instrument (8). New escaped note: 64. Secondary wait (1).
	db 64	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 56. Primary wait (0).
	db 56	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 61. Primary wait (0).
	db 61	;   Escape note value.
	db 149	; Primary instrument (8). Note reference (5). Secondary wait (1).
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
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 70	; Default start note in tracks.
	db 7	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong3DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong3DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong3_Loop
	db 170	; State byte.
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
	db 142	; New escaped note: 62. Secondary wait (1).
	db 62	;   Escape note value.
	db 78	; New escaped note: 70. Primary wait (0).
	db 70	;   Escape note value.
	db 70	; Note reference (6). Primary wait (0).
	db 206	; New escaped note: 62. New wait (127).
	db 62	;   Escape note value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong3_Track2
	db 66	; Note reference (2). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 129	; Note reference (1). Secondary wait (1).
	db 66	; Note reference (2). Primary wait (0).
	db 68	; Note reference (4). Primary wait (0).
	db 193	; Note reference (1). New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong3_Track3
	db 72	; Note reference (8). Primary wait (0).
	db 70	; Note reference (6). Primary wait (0).
	db 133	; Note reference (5). Secondary wait (1).
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

; Alien MSX Song file, Subsong 4.
; ----------------------------------

AlienMSXSongfile_Subsong4
AlienMSXSongfile_Subsong4DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong4_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong4_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong4DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong4DisarkByteRegionStart1
	db 9	; Initial speed.

	db 8	; Most used instrument.
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 14	; Default start note in tracks.
	db 10	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong4DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong4DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong4_Loop
	db 171	; State byte.
	db 8	; New speed (>0).
	db 63	; New height.
	db 128	; New track (0) for channel 1, as a reference (index 0).
	db ((AlienMSXSongfile_Subsong4_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 2, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong4_Track2 - ($ + 1)) & 255)
	db 129	; New track (1) for channel 3, as a reference (index 1).

; Pattern 1
	db 32	; State byte.
	db ((AlienMSXSongfile_Subsong4_Track3 - ($ + 2)) & #ff00) / 256	; New track (3) for channel 2, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong4_Track3 - ($ + 1)) & 255)

; Pattern 2
	db 32	; State byte.
	db ((AlienMSXSongfile_Subsong4_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 2, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong4_Track2 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong4DisarkByteRegionEnd2
AlienMSXSongfile_Subsong4DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong4_Loop

AlienMSXSongfile_Subsong4DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong4_TrackIndexes
AlienMSXSongfile_Subsong4DisarkPointerRegionStart4
	dw AlienMSXSongfile_Subsong4_Track0	; Track 0, index 0.
	dw AlienMSXSongfile_Subsong4_Track1	; Track 1, index 1.
AlienMSXSongfile_Subsong4DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong4DisarkByteRegionStart5
AlienMSXSongfile_Subsong4_Track0
	db 12	; Note with effects flag.
	db 126	; New instrument (17). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 17	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 126	; New instrument (12). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 12	;   Escape instrument value.
	db 110	; Secondary instrument (18). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 12	; Note with effects flag.
	db 126	; New instrument (17). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 127	; New instrument (16). Same escaped note: 62. Primary wait (0).
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (18). Note reference (6). Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (18). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 64. Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (18). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 126	; New instrument (12). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 12	;   Escape instrument value.
	db 110	; Secondary instrument (18). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 12	; Note with effects flag.
	db 126	; New instrument (17). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 127	; New instrument (16). Same escaped note: 62. Primary wait (0).
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 102	; Secondary instrument (18). Note reference (6). Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 100	; Secondary instrument (18). Note reference (4). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (18). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 64. Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 126	; New instrument (16). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (12). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 12	;   Escape instrument value.
	db 130	;    Volume effect, with inverted volume: 8.
	db 12	; Note with effects flag.
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (17). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 127	; New instrument (12). Same escaped note: 62. Primary wait (0).
	db 12	;   Escape instrument value.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 114	;    Volume effect, with inverted volume: 7.
	db 127	; New instrument (12). Same escaped note: 62. Primary wait (0).
	db 12	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 127	; New instrument (16). Same escaped note: 62. Primary wait (0).
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 146	;    Volume effect, with inverted volume: 9.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 98	;    Volume effect, with inverted volume: 6.
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 97	; Secondary instrument (18). Note reference (1). Primary wait (0).
	db 79	; Same escaped note: 62. Primary wait (0).
	db 127	; New instrument (12). Same escaped note: 62. Primary wait (0).
	db 12	;   Escape instrument value.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 127	; New instrument (12). Same escaped note: 62. Primary wait (0).
	db 12	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 127	; New instrument (16). Same escaped note: 62. Primary wait (0).
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 130	;    Volume effect, with inverted volume: 8.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 127	; New instrument (17). Same escaped note: 62. Primary wait (0).
	db 17	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 146	;    Volume effect, with inverted volume: 9.
	db 111	; Secondary instrument (18). Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 126	; New instrument (16). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 16	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 111	; Secondary instrument (18). Same escaped note: 57. Primary wait (0).
	db 111	; Secondary instrument (18). Same escaped note: 57. Primary wait (0).
	db 12	; Note with effects flag.
	db 255	; New instrument (17). Same escaped note: 57. New wait (127).
	db 17	;   Escape instrument value.
	db 127	;   Escape wait value.
	db 162	;    Volume effect, with inverted volume: 10.

AlienMSXSongfile_Subsong4_Track1
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 93	; Effect only. Primary wait (0).
	db 244	;    Pitch down: 2304.
	db 0	;    Pitch, LSB.
	db 9	;    Pitch, MSB.
	db 12	; Note with effects flag.
	db 114	; New instrument (19). Note reference (2). Primary wait (0).
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 66	; Note reference (2). Primary wait (0).
	db 70	; Note reference (6). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 19	;   Escape instrument value.
	db 146	;    Volume effect, with inverted volume: 9.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 143	; Same escaped note: 26. Secondary wait (1).
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 78	; New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 68	; Note reference (4). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 93	; Effect only. Primary wait (0).
	db 244	;    Pitch down: 2304.
	db 0	;    Pitch, LSB.
	db 9	;    Pitch, MSB.
	db 12	; Note with effects flag.
	db 114	; New instrument (19). Note reference (2). Primary wait (0).
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 66	; Note reference (2). Primary wait (0).
	db 70	; Note reference (6). Primary wait (0).
	db 66	; Note reference (2). Primary wait (0).
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 19	;   Escape instrument value.
	db 146	;    Volume effect, with inverted volume: 9.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 143	; Same escaped note: 26. Secondary wait (1).
	db 206	; New escaped note: 21. New wait (3).
	db 21	;   Escape note value.
	db 3	;   Escape wait value.
	db 78	; New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 93	; Effect only. Primary wait (0).
	db 244	;    Pitch down: 2304.
	db 0	;    Pitch, LSB.
	db 9	;    Pitch, MSB.
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 79	; Same escaped note: 57. Primary wait (0).
	db 65	; Note reference (1). Primary wait (0).
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 19	;   Escape instrument value.
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 143	; Same escaped note: 26. Secondary wait (1).
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 79	; Same escaped note: 57. Primary wait (0).
	db 65	; Note reference (1). Primary wait (0).
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 93	; Effect only. Primary wait (0).
	db 244	;    Pitch down: 2304.
	db 0	;    Pitch, LSB.
	db 9	;    Pitch, MSB.
	db 12	; Note with effects flag.
	db 126	; New instrument (19). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 19	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 79	; Same escaped note: 57. Primary wait (0).
	db 65	; Note reference (1). Primary wait (0).
	db 78	; New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 79	; Same escaped note: 62. Primary wait (0).
	db 12	; Note with effects flag.
	db 126	; New instrument (9). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 9	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 110	; Secondary instrument (18). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 146	;    Volume effect, with inverted volume: 9.
	db 12	; Note with effects flag.
	db 78	; New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 143	; Same escaped note: 26. Secondary wait (1).
	db 206	; New escaped note: 21. New wait (127).
	db 21	;   Escape note value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong4_Track2
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 14. Secondary wait (1).
	db 82	;    Volume effect, with inverted volume: 5.
	db 190	; New instrument (14). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 126	; New instrument (15). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 15	;   Escape instrument value.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 191	; New instrument (14). Same escaped note: 38. Secondary wait (1).
	db 14	;   Escape instrument value.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 190	; New instrument (14). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 126	; New instrument (15). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 15	;   Escape instrument value.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 191	; New instrument (14). Same escaped note: 38. Secondary wait (1).
	db 14	;   Escape instrument value.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (11). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 45. Primary wait (0).
	db 45	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (11). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 254	; New instrument (13). New escaped note: 45. New wait (127).
	db 45	;   Escape note value.
	db 13	;   Escape instrument value.
	db 127	;   Escape wait value.
	db 162	;    Volume effect, with inverted volume: 10.

AlienMSXSongfile_Subsong4_Track3
	db 12	; Note with effects flag.
	db 143	; Same escaped note: 14. Secondary wait (1).
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 190	; New instrument (14). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 126	; New instrument (15). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 15	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 191	; New instrument (14). Same escaped note: 38. Secondary wait (1).
	db 14	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 190	; New instrument (14). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 126	; New instrument (15). New escaped note: 26. Primary wait (0).
	db 26	;   Escape note value.
	db 15	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (14). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 14	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 191	; New instrument (11). Same escaped note: 38. Secondary wait (1).
	db 11	;   Escape instrument value.
	db 191	; New instrument (14). Same escaped note: 38. Secondary wait (1).
	db 14	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (11). New escaped note: 38. Secondary wait (1).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 190	; New instrument (13). New escaped note: 50. Secondary wait (1).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 162	;    Volume effect, with inverted volume: 10.
	db 126	; New instrument (11). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 11	;   Escape instrument value.
	db 12	; Note with effects flag.
	db 126	; New instrument (10). New escaped note: 14. Primary wait (0).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 50. Primary wait (0).
	db 50	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 190	; New instrument (10). New escaped note: 14. Secondary wait (1).
	db 14	;   Escape note value.
	db 10	;   Escape instrument value.
	db 114	;    Volume effect, with inverted volume: 7.
	db 12	; Note with effects flag.
	db 126	; New instrument (13). New escaped note: 45. Primary wait (0).
	db 45	;   Escape note value.
	db 13	;   Escape instrument value.
	db 98	;    Volume effect, with inverted volume: 6.
	db 12	; Note with effects flag.
	db 126	; New instrument (20). New escaped note: 38. Primary wait (0).
	db 38	;   Escape note value.
	db 20	;   Escape instrument value.
	db 82	;    Volume effect, with inverted volume: 5.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 38. Primary wait (0).
	db 66	;    Volume effect, with inverted volume: 4.
	db 12	; Note with effects flag.
	db 79	; Same escaped note: 38. Primary wait (0).
	db 50	;    Volume effect, with inverted volume: 3.
	db 12	; Note with effects flag.
	db 207	; Same escaped note: 38. New wait (127).
	db 127	;   Escape wait value.
	db 34	;    Volume effect, with inverted volume: 2.

AlienMSXSongfile_Subsong4DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong4_NoteIndexes
AlienMSXSongfile_Subsong4DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong4DisarkByteRegionEnd6

; Alien MSX Song file, Subsong 5.
; ----------------------------------

AlienMSXSongfile_Subsong5
AlienMSXSongfile_Subsong5DisarkPointerRegionStart0
	dw AlienMSXSongfile_Subsong5_NoteIndexes	; Index table for the notes.
	dw AlienMSXSongfile_Subsong5_TrackIndexes	; Index table for the Tracks.
AlienMSXSongfile_Subsong5DisarkPointerRegionEnd0

AlienMSXSongfile_Subsong5DisarkByteRegionStart1
	db 7	; Initial speed.

	db 8	; Most used instrument.
	db 18	; Second most used instrument.

	db 0	; Most used wait.
	db 1	; Second most used wait.

	db 62	; Default start note in tracks.
	db 0	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
AlienMSXSongfile_Subsong5DisarkByteRegionEnd1

; The Linker.
AlienMSXSongfile_Subsong5DisarkByteRegionStart2
; Pattern 0
AlienMSXSongfile_Subsong5_Loop
	db 170	; State byte.
	db 35	; New height.
	db ((AlienMSXSongfile_Subsong5_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong5_Track0 - ($ + 1)) & 255)
	db ((AlienMSXSongfile_Subsong5_Track1 - ($ + 2)) & #ff00) / 256	; New track (1) for channel 2, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong5_Track1 - ($ + 1)) & 255)
	db ((AlienMSXSongfile_Subsong5_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((AlienMSXSongfile_Subsong5_Track2 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
AlienMSXSongfile_Subsong5DisarkByteRegionEnd2
AlienMSXSongfile_Subsong5DisarkPointerRegionStart3
	dw AlienMSXSongfile_Subsong5_Loop

AlienMSXSongfile_Subsong5DisarkPointerRegionEnd3
; The indexes of the tracks.
AlienMSXSongfile_Subsong5_TrackIndexes
AlienMSXSongfile_Subsong5DisarkPointerRegionStart4
AlienMSXSongfile_Subsong5DisarkPointerRegionEnd4

AlienMSXSongfile_Subsong5DisarkByteRegionStart5
AlienMSXSongfile_Subsong5_Track0
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 62. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 94	; Primary instrument (8). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 84	; Primary instrument (8). Note reference (4). Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 95	; Primary instrument (8). Same escaped note: 62. Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 64. Primary wait (0).
	db 64	;   Escape note value.
	db 84	; Primary instrument (8). Note reference (4). Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 95	; Primary instrument (8). Same escaped note: 62. Primary wait (0).
	db 84	; Primary instrument (8). Note reference (4). Primary wait (0).
	db 82	; Primary instrument (8). Note reference (2). Primary wait (0).
	db 84	; Primary instrument (8). Note reference (4). Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 59. Primary wait (0).
	db 59	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 62. Primary wait (0).
	db 62	;   Escape note value.
	db 86	; Primary instrument (8). Note reference (6). Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 71. Primary wait (0).
	db 71	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 55. Primary wait (0).
	db 55	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 12	; Note with effects flag.
	db 95	; Primary instrument (8). Same escaped note: 55. Primary wait (0).
	db 18	;    Volume effect, with inverted volume: 1.
	db 94	; Primary instrument (8). New escaped note: 51. Primary wait (0).
	db 51	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 55. Primary wait (0).
	db 55	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 53. Primary wait (0).
	db 53	;   Escape note value.
	db 95	; Primary instrument (8). Same escaped note: 53. Primary wait (0).
	db 94	; Primary instrument (8). New escaped note: 57. Primary wait (0).
	db 57	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 53. Primary wait (0).
	db 53	;   Escape note value.
	db 94	; Primary instrument (8). New escaped note: 59. Primary wait (0).
	db 59	;   Escape note value.
	db 12	; Note with effects flag.
	db 94	; Primary instrument (8). New escaped note: 51. Primary wait (0).
	db 51	;   Escape note value.
	db 34	;    Volume effect, with inverted volume: 2.
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 55. New wait (127).
	db 55	;   Escape note value.
	db 127	;   Escape wait value.
	db 18	;    Volume effect, with inverted volume: 1.

AlienMSXSongfile_Subsong5_Track1
	db 12	; Note with effects flag.
	db 222	; Primary instrument (8). New escaped note: 50. New wait (3).
	db 50	;   Escape note value.
	db 3	;   Escape wait value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 30	; Primary instrument (8). New escaped note: 46. 
	db 46	;   Escape note value.
	db 12	; Note with effects flag.
	db 30	; Primary instrument (8). New escaped note: 45. 
	db 45	;   Escape note value.
	db 18	;    Volume effect, with inverted volume: 1.
	db 12	; Note with effects flag.
	db 30	; Primary instrument (8). New escaped note: 55. 
	db 55	;   Escape note value.
	db 2	;    Volume effect, with inverted volume: 0.
	db 30	; Primary instrument (8). New escaped note: 39. 
	db 39	;   Escape note value.
	db 30	; Primary instrument (8). New escaped note: 41. 
	db 41	;   Escape note value.
	db 222	; Primary instrument (8). New escaped note: 43. New wait (127).
	db 43	;   Escape note value.
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong5_Track2
	db 205	; New wait (127).
	db 127	;   Escape wait value.

AlienMSXSongfile_Subsong5DisarkByteRegionEnd5
; The note indexes.
AlienMSXSongfile_Subsong5_NoteIndexes
AlienMSXSongfile_Subsong5DisarkByteRegionStart6
	db 48	; Note for index 0.
	db 60	; Note for index 1.
	db 69	; Note for index 2.
	db 36	; Note for index 3.
	db 65	; Note for index 4.
	db 63	; Note for index 5.
	db 67	; Note for index 6.
	db 24	; Note for index 7.
	db 72	; Note for index 8.
AlienMSXSongfile_Subsong5DisarkByteRegionEnd6

