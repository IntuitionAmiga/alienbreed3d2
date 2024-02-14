			section .data,data

; Statically initialised (non-zero) data

VID_CONTRAST_ADJ_STEP 	EQU 8
VID_CONTRAST_ADJ_MIN	EQU 80
VID_CONTRAST_ADJ_MAX	EQU	512
VID_CONTRAST_ADJ_DEF	EQU	$0100

			align 4

; Brightening curves. Each table converts a linear channel value to an increasingly brightened
; version, based on a basic gamma curve approximation.

; TODO - Recalculate 16 bit since we end up calculating a 32-bit pen value for LoadRGB32()

_Vid_GammaIncTables_vb::
Vid_GammaIncTable1_vb: ; x^0.9375
				dc.b 0,1,2,3,5,6,7,8,9,11,12,13,14,15,16,17
				dc.b 19,20,21,22,23,24,25,26,27,28,29,31,32,33,34,35
				dc.b 36,37,38,39,40,41,42,43,44,45,47,48,49,50,51,52
				dc.b 53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68
				dc.b 69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,85
				dc.b 86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101
				dc.b 102,103,104,105,106,107,108,109,109,110,111,112,113,114,115,116
				dc.b 117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132
				dc.b 133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148
				dc.b 149,150,151,152,153,154,155,156,156,157,158,159,160,161,162,163
				dc.b 164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179
				dc.b 180,181,182,183,183,184,185,186,187,188,189,190,191,192,193,194
				dc.b 195,196,197,198,199,200,201,202,203,204,204,205,206,207,208,209
				dc.b 210,211,212,213,214,215,216,217,218,219,220,221,222,222,223,224
				dc.b 225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,239
				dc.b 240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255

Vid_GammaIncTable2_vb: ; x^0.875
				dc.b 0,1,3,5,6,8,9,10,12,13,14,16,17,18,20,21
				dc.b 22,23,25,26,27,28,29,31,32,33,34,35,36,38,39,40
				dc.b 41,42,43,44,45,47,48,49,50,51,52,53,54,55,56,58
				dc.b 59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,75
				dc.b 76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91
				dc.b 92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107
				dc.b 108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123
				dc.b 124,125,126,127,128,128,129,130,131,132,133,134,135,136,137,138
				dc.b 139,140,141,142,143,144,145,146,147,148,149,149,150,151,152,153
				dc.b 154,155,156,157,158,159,160,161,162,163,164,164,165,166,167,168
				dc.b 169,170,171,172,173,174,175,176,176,177,178,179,180,181,182,183
				dc.b 184,185,186,187,188,188,189,190,191,192,193,194,195,196,197,198
				dc.b 198,199,200,201,202,203,204,205,206,207,207,208,209,210,211,212
				dc.b 213,214,215,216,216,217,218,219,220,221,222,223,224,224,225,226
				dc.b 227,228,229,230,231,232,232,233,234,235,236,237,238,239,240,240
				dc.b 241,242,243,244,245,246,247,247,248,249,250,251,252,253,254,255

Vid_GammaIncTable3_vb: ; x^0.8125
				dc.b 0,2,4,6,8,10,12,13,15,16,18,19,21,22,24,25
				dc.b 26,28,29,30,32,33,34,36,37,38,39,41,42,43,44,46
				dc.b 47,48,49,50,51,53,54,55,56,57,58,60,61,62,63,64
				dc.b 65,66,67,68,70,71,72,73,74,75,76,77,78,79,80,81
				dc.b 82,83,85,86,87,88,89,90,91,92,93,94,95,96,97,98
				dc.b 99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114
				dc.b 115,116,117,118,119,120,121,122,123,124,124,125,126,127,128,129
				dc.b 130,131,132,133,134,135,136,137,138,139,140,141,141,142,143,144
				dc.b 145,146,147,148,149,150,151,152,153,153,154,155,156,157,158,159
				dc.b 160,161,162,162,163,164,165,166,167,168,169,170,171,171,172,173
				dc.b 174,175,176,177,178,179,179,180,181,182,183,184,185,186,186,187
				dc.b 188,189,190,191,192,193,193,194,195,196,197,198,199,199,200,201
				dc.b 202,203,204,205,205,206,207,208,209,210,211,211,212,213,214,215
				dc.b 216,216,217,218,219,220,221,221,222,223,224,225,226,227,227,228
				dc.b 229,230,231,232,232,233,234,235,236,236,237,238,239,240,241,241
				dc.b 242,243,244,245,246,246,247,248,249,250,250,251,252,253,254,255

Vid_GammaIncTable4_vb: ; x^0.75
				dc.b 0,3,6,9,11,13,15,17,19,20,22,24,25,27,28,30
				dc.b 31,33,34,36,37,39,40,41,43,44,46,47,48,49,51,52
				dc.b 53,55,56,57,58,59,61,62,63,64,65,67,68,69,70,71
				dc.b 72,74,75,76,77,78,79,80,81,82,83,85,86,87,88,89
				dc.b 90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105
				dc.b 106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121
				dc.b 122,123,124,125,126,127,128,129,130,131,132,132,133,134,135,136
				dc.b 137,138,139,140,141,142,143,143,144,145,146,147,148,149,150,151
				dc.b 152,152,153,154,155,156,157,158,159,160,160,161,162,163,164,165
				dc.b 166,166,167,168,169,170,171,172,172,173,174,175,176,177,178,178
				dc.b 179,180,181,182,183,183,184,185,186,187,188,188,189,190,191,192
				dc.b 193,193,194,195,196,197,198,198,199,200,201,202,202,203,204,205
				dc.b 206,206,207,208,209,210,210,211,212,213,214,214,215,216,217,218
				dc.b 218,219,220,221,222,222,223,224,225,225,226,227,228,229,229,230
				dc.b 231,232,232,233,234,235,236,236,237,238,239,239,240,241,242,242
				dc.b 243,244,245,245,246,247,248,248,249,250,251,251,252,253,254,255

Vid_GammaIncTable5_vb: ; x^0.6875
				dc.b 0,5,9,12,14,17,19,21,23,25,27,29,31,32,34,36
				dc.b 38,39,41,42,44,45,47,48,50,51,53,54,55,57,58,59
				dc.b 61,62,63,65,66,67,68,70,71,72,73,74,76,77,78,79
				dc.b 80,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97
				dc.b 98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113
				dc.b 114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129
				dc.b 130,131,132,133,133,134,135,136,137,138,139,140,141,142,143,143
				dc.b 144,145,146,147,148,149,150,151,151,152,153,154,155,156,157,157
				dc.b 158,159,160,161,162,163,163,164,165,166,167,168,168,169,170,171
				dc.b 172,172,173,174,175,176,177,177,178,179,180,181,181,182,183,184
				dc.b 185,185,186,187,188,189,189,190,191,192,192,193,194,195,196,196
				dc.b 197,198,199,199,200,201,202,202,203,204,205,206,206,207,208,209
				dc.b 209,210,211,212,212,213,214,215,215,216,217,217,218,219,220,220
				dc.b 221,222,223,223,224,225,226,226,227,228,228,229,230,231,231,232
				dc.b 233,233,234,235,236,236,237,238,238,239,240,241,241,242,243,243
				dc.b 244,245,245,246,247,248,248,249,250,250,251,252,252,253,254,255

Vid_GammaIncTable6_vb: ; x^0.625
				dc.b 0,7,12,15,18,21,24,26,29,31,33,35,37,39,41,43
				dc.b 45,46,48,50,51,53,55,56,58,59,61,62,64,65,66,68
				dc.b 69,71,72,73,75,76,77,78,80,81,82,83,85,86,87,88
				dc.b 89,90,92,93,94,95,96,97,98,99,101,102,103,104,105,106
				dc.b 107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122
				dc.b 123,124,125,126,127,128,129,130,131,132,133,133,134,135,136,137
				dc.b 138,139,140,141,142,142,143,144,145,146,147,148,149,149,150,151
				dc.b 152,153,154,155,155,156,157,158,159,160,160,161,162,163,164,164
				dc.b 165,166,167,168,168,169,170,171,172,172,173,174,175,176,176,177
				dc.b 178,179,179,180,181,182,183,183,184,185,186,186,187,188,189,189
				dc.b 190,191,192,192,193,194,194,195,196,197,197,198,199,200,200,201
				dc.b 202,202,203,204,205,205,206,207,207,208,209,210,210,211,212,212
				dc.b 213,214,214,215,216,217,217,218,219,219,220,221,221,222,223,223
				dc.b 224,225,225,226,227,227,228,229,229,230,231,231,232,233,233,234
				dc.b 235,235,236,237,237,238,239,239,240,241,241,242,242,243,244,244
				dc.b 245,246,246,247,248,248,249,249,250,251,251,252,253,253,254,255

Vid_GammaIncTable7_vb: ; x^0.5625
				dc.b 0,11,16,20,24,27,30,33,36,38,41,43,45,47,49,51
				dc.b 53,55,57,59,60,62,64,65,67,69,70,72,73,75,76,77
				dc.b 79,80,82,83,84,86,87,88,89,91,92,93,94,96,97,98
				dc.b 99,100,101,103,104,105,106,107,108,109,110,111,112,114,115,116
				dc.b 117,118,119,120,121,122,123,124,125,126,127,128,129,130,130,131
				dc.b 132,133,134,135,136,137,138,139,140,141,141,142,143,144,145,146
				dc.b 147,148,148,149,150,151,152,153,153,154,155,156,157,158,158,159
				dc.b 160,161,162,162,163,164,165,166,166,167,168,169,169,170,171,172
				dc.b 173,173,174,175,176,176,177,178,179,179,180,181,181,182,183,184
				dc.b 184,185,186,187,187,188,189,189,190,191,192,192,193,194,194,195
				dc.b 196,196,197,198,198,199,200,200,201,202,202,203,204,205,205,206
				dc.b 206,207,208,208,209,210,210,211,212,212,213,214,214,215,216,216
				dc.b 217,218,218,219,219,220,221,221,222,223,223,224,224,225,226,226
				dc.b 227,228,228,229,229,230,231,231,232,232,233,234,234,235,235,236
				dc.b 237,237,238,238,239,240,240,241,241,242,242,243,244,244,245,245
				dc.b 246,247,247,248,248,249,249,250,251,251,252,252,253,253,254,255

Vid_GammaIncTable8_vb: ; x^0.5
				dc.b 0,15,22,27,31,35,39,42,45,47,50,52,55,57,59,61
				dc.b 63,65,67,69,71,73,74,76,78,79,81,82,84,85,87,88
				dc.b 90,91,93,94,95,97,98,99,100,102,103,104,105,107,108,109
				dc.b 110,111,112,114,115,116,117,118,119,120,121,122,123,124,125,126
				dc.b 127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,141
				dc.b 142,143,144,145,146,147,148,148,149,150,151,152,153,153,154,155
				dc.b 156,157,158,158,159,160,161,162,162,163,164,165,165,166,167,168
				dc.b 168,169,170,171,171,172,173,174,174,175,176,177,177,178,179,179
				dc.b 180,181,182,182,183,184,184,185,186,186,187,188,188,189,190,190
				dc.b 191,192,192,193,194,194,195,196,196,197,198,198,199,200,200,201
				dc.b 201,202,203,203,204,205,205,206,206,207,208,208,209,210,210,211
				dc.b 211,212,213,213,214,214,215,216,216,217,217,218,218,219,220,220
				dc.b 221,221,222,222,223,224,224,225,225,226,226,227,228,228,229,229
				dc.b 230,230,231,231,232,233,233,234,234,235,235,236,236,237,237,238
				dc.b 238,239,240,240,241,241,242,242,243,243,244,244,245,245,246,246
				dc.b 247,247,248,248,249,249,250,250,251,251,252,252,253,253,254,255

	DECLC	Vid_ContrastAdjust_w
			dc.w	VID_CONTRAST_ADJ_DEF

	DECLC	Vid_BrightnessOffset_w
			dc.w	0

	DECLC	Vid_GammaLevel_b
			dc.b	0

	DECLC	Vid_UpdatePalette_b
			dc.b	0


