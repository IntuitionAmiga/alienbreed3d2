

*************************************************************
* SET UP INITIAL POSITION OF PLAYER *************************
*************************************************************

INITPLAYER:
				move.l	LEVELDATA,a1
				add.l	#160*10,a1
				move.w	4(a1),d0
				move.l	ZoneAdds,a0
				move.l	(a0,d0.w*4),d0
				add.l	LEVELDATA,d0
				move.l	d0,Plr1_RoomPtr_l
				move.l	Plr1_RoomPtr_l,a0
				move.l	ZoneT_Floor_l(a0),d0
				sub.l	#playerheight,d0
				move.l	d0,Plr1_SnapYOff_l
				move.l	d0,Plr1_YOff_l
				move.l	d0,Plr1_SnapTYOff_l
				move.l	Plr1_RoomPtr_l,Plr1_OldRoomPtr_l

				move.l	LEVELDATA,a1
				add.l	#160*10,a1
				move.w	10(a1),d0
				move.l	ZoneAdds,a0
				move.l	(a0,d0.w*4),d0
				add.l	LEVELDATA,d0
				move.l	d0,Plr2_RoomPtr_l
				move.l	Plr2_RoomPtr_l,a0
				move.l	ZoneT_Floor_l(a0),d0
				sub.l	#playerheight,d0
				move.l	d0,Plr2_SnapYOff_l
				move.l	d0,Plr2_YOff_l
				move.l	d0,Plr2_SnapTYOff_l
				move.l	d0,Plr2_YOff_l

				move.l	Plr2_RoomPtr_l,Plr2_OldRoomPtr_l


				move.w	(a1),Plr1_SnapXOff_l
				move.w	2(a1),Plr1_SnapZOff_l
				move.w	(a1),Plr1_XOff_l
				move.w	2(a1),Plr1_ZOff_l
				move.w	6(a1),Plr2_SnapXOff_l
				move.w	8(a1),Plr2_SnapZOff_l
				move.w	6(a1),Plr2_XOff_l
				move.w	8(a1),Plr2_ZOff_l
				rts

*************************************************
* Floor lines:                                  *
* A floor line is a line seperating two rooms.  *
* The data for the line is therefore:           *
* x,y,dx,dy,Room1,Room2                         *
* For ease of editing the lines are initially   *
* stored in the form startpt,endpt,Room1,Room2  *
* and the program calculates x,y,dx and dy from *
* this information and stores it in a buffer.   *
*************************************************

PointsToRotatePtr: dc.l	0

***************************************
LEVELDATA:		dc.l	0

***************************************

*************************************************************
* ROOM GRAPHICAL DESCRIPTIONS : WALLS AND FLOORS ************
*************************************************************

ZoneBorderPts:	dc.l	0
CONNECT_TABLE:	dc.l	0
ListOfGraphRooms: dc.l	0
NastyShotData:	dc.l	0
ObjectPoints:	dc.l	0
PlayerShotData:	dc.l	0
ObjectDataPtr_l:		dc.l	0
FloorLines:		dc.l	0
Points:			dc.l	0						; Pointer to array of all 2D points in the world
PLR1_Obj:		dc.l	0
PLR2_Obj:		dc.l	0
PLR3_Obj:		dc.l	0
PLR4_Obj:		dc.l	0
PLR5_Obj:		dc.l	0
PLR6_Obj:		dc.l	0
PLR7_Obj:		dc.l	0
ZoneGraphAdds:	dc.l	0
ZoneAdds:		dc.l	0
NumObjectPoints: dc.w	0
LiftData:		dc.l	0
DoorData:		dc.l	0
SwitchData:		dc.l	0
CPtPos:			dc.l	0
NumCPts:		dc.w	0
OtherNastyData:	ds.l	20
NumLevPts:		dc.w	0

wall			SET		0
seethruwall		SET		13
floor			SET		1
roof			SET		2
setclip			SET		3
object			SET		4
curve			SET		5
light			SET		6
water			SET		7
bumpfloor		SET		8
bumproof		SET		9
smoothfloor		SET		10
smoothroof		SET		11
backdrop		SET		12

GreenStone		SET		0
MetalA			SET		4096
MetalB			SET		4096*2
MetalC			SET		4096*3
Marble			SET		4096*4
BulkHead		SET		4096*5
SpaceWall		SET		4096*6
Sand			SET		0
MarbleFloor		SET		2
RoofLights		SET		256
GreyRoof		SET		258

BackGraph:
				dc.w	-1
				dc.w	backdrop
				dc.l	-1

NullClip:
				dc.l	0

LEVELGRAPHICS:
				dc.l	0

;LEVELGRAPHICSD:
; ds.b 50000

; ds.b 50000
; incbin "tstlev.graph.bin"
LEVELCLIPS:
				dc.l	0

;LEVELCLIPSD:
; ds.b 50000
; ds.b 50000
; incbin "tstlev.clips"

;ControlPts:
; incbin "ab3:includes/newlev.map"
