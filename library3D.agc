#constant STATUS_HIDDEN 0
#constant STATUS_IDLE 1
#constant STATUS_ACTIVE 2
#constant STATUS_ENDING 3
#constant STATUS_OBSTACLE 4
#constant STATUS_CHANGEROUTE 5
#constant STATUS_FALLING 6
#constant STATUS_CHANGEAI 7
#constant STATUS_BOMB_EXPLOSION 8
#constant STATUS_CLIMBING 9
#constant STATUS_WEAPON_FIRE 10
#constant STATUS_FPS_DYING 11
#constant STATUS_GAME_OVER 12
#constant STATUS_CHANGE_LEVEL 13
#constant STATUS_FIRING 14
#constant STATUS_OPENING 15
#constant STATUS_CLOSING 16
#constant STATUS_OPEN 17
#constant STATUS_CLOSED 18
#constant STATUS_LOCKED 19
#constant STATUS_TANK_START_FALLING 20
#constant STATUS_TANK_FALLING 21
#constant STATUS_FLYING_FALLING 22
#constant STATUS_BACK_TO_MENU 23

#constant TERRAIN_FLAT 0
#constant TERRAIN_SIN 1
#constant TERRAIN_MAP 2
#constant TERRAIN_AGK 3

#constant AI_CHASE 1
#constant AI_ESCAPE 2
#constant AI_RANDOM 3
#constant AI_AVOID_OBSTACLES 4

#constant CAT_GHOST 1
#constant CAT_FPS 2
#constant CAT_ENEMY 3
#constant CAT_BLOCK 4
#constant CAT_TERRAIN_FLAT 5
#constant CAT_TERRAIN_SIN 6
#constant CAT_TERRAIN_MAP 7
#constant CAT_TERRAIN_AGK 8
#constant CAT_SKY 9
#constant CAT_BULLET 10
#constant CAT_PICKUP 11
#constant CAT_PLAYER 12
#constant CAT_STAIRS 13
#constant CAT_VERTICAL_STAIRS 14
#constant CAT_HAND 15
#constant CAT_VERTICAL_DOORS 16
#constant CAT_LIFT 17
#constant CAT_TANK 18
#constant CAT_FLYING 19

#constant DARKBLUE 0x0000A0
#constant BLUE 0x0000FF
#constant RED 0xFF0000
#constant DARKRED 0xA00000
#constant GREEN 0x00A000
#constant LIGHTGREEN 0x00FF00
#constant WHITE 0xFFFFFF
#constant YELLOW 0xFFFF00
#constant CYAN 0x00FFFF

#constant AGK_NUM_VIRTUAL_BUTTONS 12
#constant AGK_NUM_VIRTUAL_JOYSTICKS 4

global oggetti3D as Oggetto3D[]
global firstCatObjID as integer[]
global firstCatObjFilename as string[]

global WORLD_LIMIT_X as float
global WORLD_LIMIT_Z as float 
global WORLD_LIMIT_Y as float

global TERRAIN_SIZE_X as integer
global TERRAIN_SIZE_Z as integer

global TERRAIN_MAP_SIZE_X as integer
global TERRAIN_MAP_SIZE_Z as integer

global SCREEN2D_WIDTH as float
global SCREEN2D_HEIGHT as float

global hitWallFront as integer
global hitWallFrontLow as integer
global hitWallBack as integer
global hitWallBackLow as integer
global hitFloor as integer
global hitTop as integer


global fps_index as integer
global terrainAGK_index as integer
global bullet_index as integer
global weapon_index as integer
global hand_index as integer

global move_fwd_flag as integer

global angle_y_fire as float

global cam_angle_xy as float

type Oggetto3D
	fps as integer
	name as string
	ID as integer
	animated as integer
	textureID as integer
	detailTextureID as integer
	heightMapFile as string
	x as float
	y as float
	z as float
	height as float
	width as float
	depth as float
	textureFile as String
	detailTextureFile as String
	objectFile as String
	angle_x as float
	angle_y as float
	angle_z as float
	objectType as string
	color as string
	category as integer
	status as integer
	postENDING as integer
	postCHANGEROUTE as integer
	postOBSTACLE as integer
	postFALLING as integer
	postCHANGEAI as integer
	moveStep as float
	rotateStep as float
	collision as integer
	ai as integer
	flip as integer
	collisionFlag as integer
	energy as integer
	energySpriteID as integer
	infoTextID as integer
	infoText as string
	life as integer
	scale as float
	damage as float
	points as integer
	lightID as integer
	light as integer
	lightRadius as float
	lightMode as integer
	isStairs as integer
	onObject as integer
	bullets as integer
	chargeWeapon as string
	newAngleY as float
	turningFlag as integer
	weapon as string
	angle_y_fire as float
	angle_x_fire as float
	inventory as string
	hittingPlayer as integer
	riser as float
	canFire as integer
	weaponBoneName as string
	weaponTextureFile as string
	weaponTextureID as integer
	bodyBoneName as string
	fireObjID as integer
	fireTimer as float
	fireDamage as float
	targetFireID as integer
	fireDuration as float
	base_y as float
	tiled as integer
	tile_x as integer
	tile_y as integer
	openWithKey as string
	lift_minX as float
	lift_maxX as float
	lift_minY as float
	lift_maxY as float
	lift_minZ as float
	lift_maxZ as float
	lift_velX as float
	lift_velY as float
	lift_velZ as float
	hand_offset_x as float
	hand_offset_y as float
	hand_offset_z as float
	maxSlope as float
	fireRate as integer
	explosionObjID as integer
	animFallingStart as integer
	animFallingEnd as integer
	animActiveStart as integer
	animActiveEnd as integer
	shieldID as integer
	altitude as float
endtype

type Vector3D
	x as float
	y as float
	z as float
endtype

function GetColorRed3D(c as integer)
	redComp as integer
	redComp= (c >> 16) && (0x0000FF)
endfunction redComp

function GetColorGreen3D(c as integer)
	redComp as integer
	redComp= (c >> 8) && (0x0000FF)
endfunction redComp

function GetColorBlue3D(c as integer)
	redComp as integer
	redComp= c && (0x0000FF)
endfunction redComp

function initWorld3D(limit_x as float,limit_y as float,limit_z as float)
	WORLD_LIMIT_X=limit_x
	WORLD_LIMIT_Y=limit_y
	WORLD_LIMIT_Z=limit_z
	TERRAIN_SIZE_X=trunc(WORLD_LIMIT_X)*2
	TERRAIN_SIZE_Z=trunc(WORLD_LIMIT_Z)*2
	TERRAIN_MAP_SIZE_X=TERRAIN_SIZE_X/10
	TERRAIN_MAP_SIZE_Z=TERRAIN_SIZE_Z/10
	global dim terrain3D[TERRAIN_SIZE_X,TERRAIN_SIZE_Z] as float
	global dim terrainAGK3D[TERRAIN_SIZE_X,TERRAIN_SIZE_Z] as float
	global dim terrainMap[TERRAIN_MAP_SIZE_X,TERRAIN_MAP_SIZE_Z] as float
	global dim copyTerrainMap[TERRAIN_MAP_SIZE_X,TERRAIN_MAP_SIZE_Z] as float
	global dim altitudeMap[TERRAIN_MAP_SIZE_X,TERRAIN_MAP_SIZE_Z] as float
	SCREEN2D_WIDTH=GetVirtualWidth()
	SCREEN2D_HEIGHT=GetVirtualHeight()
endfunction	

function getDistanceVector3D(x1 as float,y1 as float,z1 as float, x2 as float,y2 as float,z2 as float)
   vectorLength as float
   vectorLength=sqrt((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)
endfunction vectorLength

function terrain3DGenerator(terrainType as integer,terrainID as integer, param as float)
	select terrainType
		case TERRAIN_FLAT
			terrainFlatGenerator(param)
		endcase	
		case TERRAIN_SIN
			terrainSinGenerator(param)
		endcase	
		case TERRAIN_AGK
			terrainAGKGenerator(terrainID)
		endcase	
	endselect
endfunction		

function terrainFlatGenerator(param as float)
	i as integer
	j as integer
	for i=0 to TERRAIN_SIZE_X
		for j=0 to TERRAIN_SIZE_Z
			terrain3D[i,j]=param
		next j
	next i		
endfunction

function terrainAGKGenerator(terrainID as integer)
	i as integer
	j as integer
	terrainHeight as float
	for i=0 to TERRAIN_SIZE_X
		for j=0 to TERRAIN_SIZE_Z
			terrainHeight=GetObjectHeightMapHeight(terrainID,i,j)
			if (terrainHeight<>0)
				terrainAGK3D[i,j]=terrainHeight+5
			else
				terrainAGK3D[i,j]=5
			endif			
		next j
	next i		
endfunction

function terrainSinGenerator(param as float)
	i as integer
	j as integer
	h as integer
	k as integer
	startAngle as integer
	offsetAngle as integer
	terrainID as integer
	currentTerrainHeight as float
	offsetAngle=0
	for i=0 to TERRAIN_SIZE_X-10 step 10
		startAngle=0
		for j=0 to TERRAIN_SIZE_Z-10 step 10
			currentTerrainHeight=param+param*sin(startAngle+offsetAngle)
			terrainID=CreateObjectPlane(10,10)
			SetObjectColor(terrainID,random(0,255),random(0,255),random(0,255),255)
			SetObjectRotation(terrainID,90,90,0)
			SetObjectPosition(terrainID,i-WORLD_LIMIT_X,currentTerrainHeight,j-WORLD_LIMIT_Z)
			SetObjectCollisionMode(terrainID,0)
			for h=i to (i+10-1)
				for k=j to (j+10-1)
					terrain3D[h,k]=currentTerrainHeight
				next k 
			next h		
			inc startAngle,10
		next j
		inc offsetAngle,10
	next i		
endfunction

function getWorldLimitX()
endfunction WORLD_LIMIT_X

function getWorldLimitY()
endfunction WORLD_LIMIT_Y

function getWorldLimitZ()
endfunction WORLD_LIMIT_Z

function clonePosRot3D(srcObj3D as Oggetto3D, dstObj3D ref as Oggetto3D)
	dstObj3D.x=srcObj3D.x
	dstObj3D.y=srcObj3D.y
	dstObj3D.z=srcObj3D.z
	dstObj3D.angle_x=srcObj3D.angle_x
	dstObj3D.angle_y=srcObj3D.angle_y
	dstObj3D.angle_z=srcObj3D.angle_z		
endfunction

function clonePos3D(srcObj3D as Oggetto3D, dstObj3D ref as Oggetto3D)
	dstObj3D.x=srcObj3D.x
	dstObj3D.y=srcObj3D.y
	dstObj3D.z=srcObj3D.z
endfunction

function cloneRot3D(srcObj3D as Oggetto3D, dstObj3D ref as Oggetto3D)
	dstObj3D.angle_x=srcObj3D.angle_x
	dstObj3D.angle_y=srcObj3D.angle_y
	dstObj3D.angle_z=srcObj3D.angle_z	
endfunction

// update the coordinates stored in obj3D using real 3D values REAL_3D=>obj3D
function updatePosRot3D(obj3D ref as Oggetto3D)
	obj3D.x=GetObjectX(obj3D.ID)
	obj3D.y=GetObjectY(obj3D.ID)
	obj3D.z=GetObjectZ(obj3D.ID)
	obj3D.angle_x=GetObjectAngleX(obj3D.ID)
	obj3D.angle_y=GetObjectAngleY(obj3D.ID)
	obj3D.angle_z=GetObjectAngleZ(obj3D.ID)	
endfunction

function updatePos3D(obj3D ref as Oggetto3D)
	obj3D.x=GetObjectX(obj3D.ID)
	obj3D.y=GetObjectY(obj3D.ID)
	obj3D.z=GetObjectZ(obj3D.ID)
endfunction

function updateRot3D(obj3D ref as Oggetto3D)
	obj3D.angle_x=GetObjectAngleX(obj3D.ID)
	obj3D.angle_y=GetObjectAngleY(obj3D.ID)
	obj3D.angle_z=GetObjectAngleZ(obj3D.ID)	
endfunction

// position the object using the coordinates stored in the obj3D obj3D=>REAL_3D
function positionObject3D(obj3D as Oggetto3D )
	SetObjectPosition(obj3D.ID,obj3D.x,obj3D.y,obj3D.z)
	SetObjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function rotationObject3D(obj3D as Oggetto3D )
	SetObjectPosition(obj3D.ID,obj3D.x,obj3D.y,obj3D.z)
	SetObjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function positionMainCameraBehind3D(obj as Oggetto3D)
	cam_angle_y as float
	if (obj.flip=1) 
	   cam_angle_y=obj.angle_y-180
	else
	   cam_angle_y=obj.angle_y
	endif	
	rem print("cam_angle="+str(cam_angle))
	SetCameraPosition(1,obj.x-sin(cam_angle_y)*obj.height*3,obj.y+obj.height+2,obj.z-cos(cam_angle_y)*obj.height*3)
	SetCameraRotation(1,cam_angle_xy,cam_angle_y,0)
endfunction	

function rotateobject3D(obj3D ref as Oggetto3D, ang_x as float, ang_y as float, ang_z as float)
	obj3D.angle_x=obj3D.angle_x+ang_x
	obj3D.angle_y=obj3D.angle_y+ang_y
	obj3D.angle_z=obj3D.angle_z+ang_z
	SetobjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function rotateXobject3D(obj3D ref as Oggetto3D, ang_x as float)
	obj3D.angle_x=obj3D.angle_x+ang_x
	SetobjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function rotateYobject3D(obj3D ref as Oggetto3D, ang_y as float)
	obj3D.angle_y=obj3D.angle_y+ang_y
	SetobjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function rotateZobject3D(obj3D ref as Oggetto3D, ang_z as float)
	obj3D.angle_z=obj3D.angle_z+ang_z
	SetobjectRotation(obj3D.ID,obj3D.angle_x,obj3D.angle_y,obj3D.angle_z)
endfunction

function moveZObject3D(obj ref as Oggetto3D,amount as float)
	MoveObjectLocalZ(obj.ID,amount)
	updatePosRot3D(obj)
endfunction

function moveYObject3D(obj ref as Oggetto3D,amount as float)
	MoveObjectLocalY(obj.ID,amount)
	updatePosRot3D(obj)
endfunction

function moveXObject3D(obj ref as Oggetto3D,amount as float)
	MoveObjectLocalX(obj.ID,amount)
	updatePosRot3D(obj)
endfunction

function clearOggetto3D(obj3D ref as Oggetto3D)
	        obj3D.x=0
			obj3D.y=0
			obj3D.z=0
			obj3D.height=0
			obj3D.width=0
			obj3D.depth=0
			obj3D.angle_x=0
			obj3D.angle_y=0
			obj3D.angle_z=0
			obj3D.textureFile=""
			obj3D.detailTextureFile=""
			obj3D.objectFile=""
			obj3D.objectType=""
			obj3D.category=0
			obj3D.status=0
			obj3D.moveStep=0
			obj3D.rotateStep=0
			obj3D.postENDING=0
			obj3D.postCHANGEROUTE=0
			obj3D.postFALLING=0
			obj3D.postOBSTACLE=0
			obj3D.postCHANGEAI=0
			obj3D.collision=0
			obj3D.collisionFlag=0
			obj3D.flip=0
			obj3D.ai=0
			obj3D.energy=0			
			obj3D.energySpriteID=0		
			obj3D.infoTextID=0		
			obj3D.infoText=""
			obj3D.life=0
			obj3D.scale=1
			obj3D.damage=1
			obj3D.fireDamage=1
			obj3D.points=0
			obj3D.bullets=0
			obj3D.light=0
			obj3D.lightID=0		
			obj3D.lightRadius=0
			obj3D.lightMode=0
			obj3D.isStairs=0
			obj3D.onObject=-1	
			obj3D.chargeWeapon=""	
			obj3D.turningFlag=0
			obj3D.newAngleY=0
			obj3D.weapon=""	
			obj3D.angle_y_fire=0
			obj3D.angle_x_fire=0
			obj3D.inventory=""
			obj3D.hittingPlayer=0
			obj3D.riser=0
			obj3D.color=""
			obj3D.animated=0
			obj3D.canFire=0
			obj3D.weaponBoneName=""
			obj3D.bodyBoneName=""
			obj3D.textureID=0
			obj3D.detailTextureID=0
			obj3D.weaponTextureFile=""
			obj3D.weaponTextureID=0
			obj3D.fireDuration=0
			obj3D.base_y=0
			obj3D.tiled=0
			obj3D.tile_x=0
			obj3D.tile_y=0
			obj3D.openWithKey=""
			obj3D.lift_minX=0
			obj3D.lift_maxX=0
			obj3D.lift_minY=0
			obj3D.lift_maxY=0
			obj3D.lift_minZ=0
			obj3D.lift_maxZ=0
			obj3D.lift_velX=0
			obj3D.lift_velY=0
			obj3D.lift_velZ=0
			obj3D.hand_offset_x=0
			obj3D.hand_offset_y=0
			obj3D.hand_offset_z=0
			obj3D.heightMapFile=""
			obj3D.maxSlope=-1
			obj3D.fireRate=500
			obj3D.explosionObjID=0
			obj3D.animActiveStart=0
			obj3D.animActiveEnd=40
			obj3D.animFallingStart=40
			obj3D.animFallingEnd=40		
			obj3D.shieldID=0	
			obj3D.altitude=0	
endfunction	
	
function populateOggetto3D(obj3D ref as Oggetto3D,tipo as string, value as string)
	select tipo
		case 'canFire'
			obj3D.canFire=Val(value)
		endcase	
		case 'animated'
			obj3D.animated=Val(value)
		endcase	
		case 'x'
			obj3D.x=ValFloat(value)
		endcase	
		case 'y'
			obj3D.y=ValFloat(value)
		endcase	
		case 'base_y'
			obj3D.base_y=ValFloat(value)
		endcase	
		case 'z'
			obj3D.z=ValFloat(value)
		endcase	
		case 'height'
			obj3D.height=ValFloat(value)
		endcase	
		case 'width'
			obj3D.width=ValFloat(value)
		endcase	
		case 'depth'
			obj3D.depth=ValFloat(value)
		endcase	
		case 'angle_x'
			obj3D.angle_x=ValFloat(value)
		endcase	
		case 'angle_y'
			obj3D.angle_y=ValFloat(value)
		endcase
		case 'angle_x_fire'
			obj3D.angle_x_fire=ValFloat(value)
		endcase	
		case 'angle_y_fire'
			obj3D.angle_y_fire=ValFloat(value)
		endcase	
		case 'angle_z'
			obj3D.angle_z=ValFloat(value)
		endcase
		case 'textureFile'
			obj3D.textureFile=value
		endcase
		case 'detailTextureFile'
			obj3D.detailTextureFile=value
		endcase
		case 'heightMapFile'
			obj3D.heightMapFile=value
		endcase
		case 'altitude'
			obj3D.altitude=ValFloat(value)
		endcase
		case 'objectFile'
			obj3D.objectFile=value
		endcase
		case 'objectType'
			obj3D.objectType=value
		endcase
		case 'color'
			obj3D.color=value
		endcase
		case 'riser'
			obj3D.riser=ValFloat(value)
		endcase		
		case 'weapon'
			obj3D.weapon=value
		endcase
		case 'moveStep'
			obj3D.moveStep=valFloat(value)
		endcase
		case 'rotateStep'
			obj3D.rotateStep=valFloat(value)
		endcase
		case 'postENDING'
		    obj3D.postENDING=mapStatus(value)
		endcase
		case 'postCHANGEROUTE'
		    obj3D.postCHANGEROUTE=mapStatus(value)
		endcase
		case 'postFALLING'
		    obj3D.postFALLING=mapStatus(value)
		endcase
		case 'postCHANGEAI'
		    obj3D.postCHANGEAI=mapStatus(value)
		endcase
		case 'postOBSTACLE'
		    obj3D.postOBSTACLE=mapStatus(value)
		endcase
		case 'status'
		    obj3D.status=mapStatus(value)
		endcase	
		case 'collision'
		    obj3D.collision=val(value)
		endcase
		case 'life'
		    obj3D.life=ValFloat(value)
		endcase
		case 'energy'
		    obj3D.energy=val(value)
		endcase	
		case 'points'
		    obj3D.points=val(value)
		endcase	
		case 'infoText'
		    obj3D.infoText=value
		endcase	
		case 'inventory'
		    obj3D.inventory=value
		endcase	
		case 'light'
		    obj3D.light=val(value)
		endcase	
		case 'lightMode'
		    obj3D.lightMode=val(value)
		endcase	
		case 'isStairs'
		    obj3D.isStairs=val(value)
		endcase		
		case 'lightRadius'
		    obj3D.lightRadius=ValFloat(value)
		endcase	
		case 'bullets'
		    obj3D.bullets=val(value)
		endcase		
		case 'chargeWeapon'
		    obj3D.chargeWeapon=value
		endcase		
		case 'weaponBoneName'
		    obj3D.weaponBoneName=value
		endcase	
		case 'weaponTextureFile'
		    obj3D.weaponTextureFile=value
		endcase	
		case 'weaponTextureD'
		    obj3D.weaponTextureID=val(value)
		endcase	
		case 'tiled'
		    obj3D.tiled=val(value)
		endcase
		case 'tile_x'
		    obj3D.tile_x=val(value)
		endcase
		case 'tile_y'
		    obj3D.tile_y=val(value)
		endcase
		case 'openWithKey'
		    obj3D.openWithKey=value
		endcase
		case 'bodyBoneName'
		    obj3D.bodyBoneName=value
		endcase		
		case 'ai'
		    select value
				case "CHASE"
				   obj3D.ai=AI_CHASE
				endcase
				case "ESCAPE"
				   obj3D.ai=AI_ESCAPE
				endcase
				case "RANDOM"
				   obj3D.ai=AI_RANDOM
				endcase
				case "AVOID"
				   obj3D.ai=AI_AVOID_OBSTACLES
				endcase
			endselect	   
		endcase	
		case 'flip'
		    obj3D.flip=val(value)
		endcase	
		case 'damage'
		    obj3D.damage=ValFloat(value)
		endcase	
		case 'fireDamage'
		    obj3D.fireDamage=ValFloat(value)
		endcase	
		case 'fireDuration'
		    obj3D.fireDuration=ValFloat(value)
		endcase	
		case 'lift_minX'
		    obj3D.lift_minX=ValFloat(value)
		endcase
		case 'lift_maxX'
		    obj3D.lift_maxX=ValFloat(value)
		endcase
		case 'lift_minY'
		    obj3D.lift_minY=ValFloat(value)
		endcase
		case 'lift_maxY'
		    obj3D.lift_maxY=ValFloat(value)
		endcase
		case 'lift_minZ'
		    obj3D.lift_minZ=ValFloat(value)
		endcase
		case 'lift_maxZ'
		    obj3D.lift_maxZ=ValFloat(value)
		endcase
		case 'lift_velX'
		    obj3D.lift_velX=ValFloat(value)
		endcase
		case 'lift_velY'
		    obj3D.lift_velY=ValFloat(value)
		endcase
		case 'lift_velZ'
		    obj3D.lift_velZ=ValFloat(value)
		endcase
		case 'hand_offset_x'
		    obj3D.hand_offset_x=ValFloat(value)
		endcase
		case 'hand_offset_y'
		    obj3D.hand_offset_y=ValFloat(value)
		endcase
		case 'hand_offset_z'
		    obj3D.hand_offset_z=ValFloat(value)
		endcase
		case 'maxSlope'
		    obj3D.maxSlope=ValFloat(value)
		endcase
		case 'fireRate'
		    obj3D.fireRate=val(value)
		endcase
		case 'animFALLING'
			obj3D.animFallingStart= val(GetStringToken(value,",",1))
			obj3D.animFallingEnd= val(GetStringToken(value,",",2))
		endcase
		case 'animACTIVE'
			obj3D.animActiveStart= val(GetStringToken(value,",",1))
			obj3D.animActiveEnd= val(GetStringToken(value,",",2))
		endcase	
		case 'category'
		    select value
				case "GHOST"
				   obj3D.category=CAT_GHOST
				endcase
				case "FPS"
				   obj3D.category=CAT_FPS
				endcase
				case "ENEMY"
				   obj3D.category=CAT_ENEMY
				endcase
				case "TANK"
				   obj3D.category=CAT_TANK
				endcase
				case "FLYING"
				   obj3D.category=CAT_FLYING
				endcase
				case "BLOCK"
				   obj3D.category=CAT_BLOCK
				endcase
				case "TERRAIN_FLAT"
				   obj3D.category=CAT_TERRAIN_FLAT
				endcase
				case "TERRAIN_SIN"
				   obj3D.category=CAT_TERRAIN_SIN
				endcase
				case "TERRAIN_MAP"
				   obj3D.category=CAT_TERRAIN_MAP
				endcase
				case "TERRAIN_AGK"
				   obj3D.category=CAT_TERRAIN_AGK
				endcase
				case "SKY"
				   obj3D.category=CAT_SKY
				endcase
				case "BULLET"
				   obj3D.category=CAT_BULLET
				endcase
				case "PICKUP"
				   obj3D.category=CAT_PICKUP
				endcase
				case "STAIRS"
				   obj3D.category=CAT_STAIRS
				endcase
				case "VERTICAL_STAIRS"
				   obj3D.category=CAT_VERTICAL_STAIRS
				endcase
				case "VERTICAL_DOORS"
				   obj3D.category=CAT_VERTICAL_DOORS
				endcase
				case "PLAYER"
				   obj3D.category=CAT_PLAYER
				endcase
				case "HAND"
				   obj3D.category=CAT_HAND
				endcase
				case "LIFT"
				   obj3D.category=CAT_LIFT
				endcase
			endselect	   
		endcase		
	endselect	
endfunction		

function parse3DJSON(objs3D ref as Oggetto3D[], jsonFilePath as string)
	jsonFileID as integer
	line as string
	numTokens as integer
	inObject as integer
	name as string
	value as string
	newObject as Oggetto3D
	tipo as string 
	clearOggetto3D(newObject)
	if (GetFileExists(jsonFilePath)=0)
		 exitfunction -1
    endif
    jsonFileID=OpenToRead(jsonFilePath)
    levelName=""
    while (FileEOF(jsonFileID)=0)
		line=ReadLine(jsonFileID)
		numTokens=CountStringTokens(line,chr(34))
		select numTokens
			case 1
				rem comments begin with double quote char. Double quote in comments must be unique for each row
			endcase
			// name of the object
			case 3
				newObject.name=GetStringToken(line,chr(34),2)
				rem
			endcase
			// last elem of an object, no ending comma
			case 4
    			tipo=GetStringToken(line,chr(34),2)
				value=GetStringToken(line,chr(34),4)
				populateOggetto3D(newObject,tipo,value)
				objs3D.insert(newObject)
				clearOggetto3D(newObject)
			endcase
			// not terminating element of an object
			case 5
				tipo=GetStringToken(line,chr(34),2)
				value=GetStringToken(line,chr(34),4)
				populateOggetto3D(newObject,tipo,value)
			endcase		
			// level name 
			case 6
				levelName=GetStringToken(line,chr(34),5)
			endcase		
		endselect			
	endwhile	
	CloseFile(jsonFileID)	
	if (levelName="") then levelName=str(world)
endfunction 0

function listObjects(objs3D as Oggetto3D[])
	i as integer
	do
		for i=0 to objs3D.length
			print(str(i)+" "+objs3D[i].name+" "+str(objs3D[i].ID)+" "+objs3D[i].objectFile)
		next i
		sync()
	loop	
endfunction

function applyColor3D(obj as Oggetto3D)
	SetObjectColor(obj.ID, val(GetStringToken(obj.color,",",1)),val(GetStringToken(obj.color,",",2)),val(GetStringToken(obj.color,",",3)),val(GetStringToken(obj.color,",",4)))
endfunction	

function checkExistingObject(objectFileName as string)
	i as integer
	if firstCatObjID.length=0 then exitfunction -1
	for i=1 to firstCatObjID.length
		if (firstCatObjFilename[i]=objectFileName) then exitfunction firstCatObjID[i]
	next i
endfunction -1		

function createOggetto3D(obj ref as Oggetto3D)
	terrainShader as integer
	terrainAGKShader as integer
	objectToCloneID as integer
	SetFolder(OBJECTS_FOLDER)
	select obj.objectType
		case "box"
		   obj.ID=CreateObjectBox(obj.width,obj.height,obj.depth)
	       if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   SetObjectImage(obj.ID,obj.textureID,0)
		   endif	   
	    endcase  
	    case "cylinder"
		   obj.ID=CreateObjectCylinder(obj.width,obj.height,obj.depth)
	       if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   SetObjectImage(obj.ID,obj.textureID,0)
		   endif	   
	    endcase  
	    case "cone"
		   obj.ID=CreateObjectCone(obj.width,obj.height,obj.depth)
	       if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   SetObjectImage(obj.ID,obj.textureID,0)
		   endif	   
	    endcase   
		case "plane"
		   obj.ID=CreateObjectPlane(obj.width,obj.height)
	       if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   SetObjectImage(obj.ID,obj.textureID,0)
		   endif	   
	    endcase
	    case "terrain"
	       select obj.category
			   case CAT_TERRAIN_FLAT 
		          obj.ID=CreateObjectPlane(obj.width,obj.height)
	              SetObjectLightMode(obj.ID,0)
	              if (obj.textureFile<>"") 
			         obj.textureID=LoadImage(obj.textureFile)
			         SetImageWrapU( obj.textureID,1)
					 SetImageWrapV( obj.textureID,1)
			         SetObjectImage(obj.ID,obj.textureID,0)
					 SetObjectShader(obj.ID,createTileShader(20.0,20.0))
			      endif
			      terrain3DGenerator(TERRAIN_FLAT,obj.ID,obj.depth)
			   endcase
			   case CAT_TERRAIN_SIN 
			      terrain3DGenerator(TERRAIN_SIN,obj.ID,obj.depth)
			   endcase  
			   case CAT_TERRAIN_MAP 
			      obj.ID=LoadObject(obj.objectFile,obj.height)
	              if (obj.textureFile<>"") 
					 obj.textureID=LoadImage(obj.textureFile) 
			         SetImageWrapU( obj.textureID,1)
					 SetImageWrapV( obj.textureID,1)
					 SetObjectImage(obj.ID,obj.textureID,0)
			      endif 
			      if (obj.detailTextureFile<>"") 
					 obj.detailTextureID=LoadImage(obj.detailTextureFile) 
			         SetImageWrapU( obj.detailTextureID,1)
					 SetImageWrapV( obj.detailTextureID,1)
					 SetObjectImage(obj.ID,obj.detailTextureID,1)
					 SetObjectShader(obj.ID,createTerrainShader(100,100))
			      endif   
		      endcase      
		      case CAT_TERRAIN_AGK 
				  terrainAGKShader=createTerrainAGKShader()
			      obj.ID=CreateObjectFromHeightMap(obj.heightMapFile,obj.width,obj.height,obj.depth,16,16)
			      if (obj.detailTextureFile<>"") 
						obj.detailTextureID=LoadImage(obj.detailTextureFile)
						SetObjectImage(obj.ID,obj.detailTextureID,0)
				  endif
				  SetObjectShader(obj.ID,terrainAGKShader)
				  terrain3DGenerator(TERRAIN_AGK,obj.ID,0)
		      endcase      
		   endselect	   
	    endcase    
	    case "sphere"
	       obj.ID=CreateObjectSphere(obj.width,obj.height,obj.depth)
	       if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   SetObjectImage(obj.ID,obj.textureID,0)
		   endif
	    endcase
	    case "obj"
	       objectToCloneID=checkExistingObject(obj.objectFile)
	       if (objectToCloneID=-1)
			   if (obj.animated=1)
				   obj.ID=LoadObjectWithChildren(obj.objectFile)
				   rem obj.lightMode=1
			   else	   
				   obj.ID=LoadObject(obj.objectFile,obj.height)
			   endif	   
		   else 
			   obj.ID=CloneObject(objectToCloneID)
		   endif	   
		   if (obj.textureFile<>"") 
			   obj.textureID=LoadImage(obj.textureFile)
			   if (obj.tiled=1)
					SetImageWrapU(obj.textureID,1)
					SetImageWrapV(obj.textureID,1)
					setObjectShader(obj.ID,createTileShader(obj.tile_x,obj.tile_y)) 
				endif	
				if (obj.bodyBoneName<>"")
					SetObjectMeshImage(obj.ID,1,obj.textureID,0)
				else	   
					SetObjectImage(obj.ID,obj.textureID,0)
				endif
			endif   
			if (obj.weaponBoneName<>"") and (obj.weaponTextureFile<>"")
			   obj.weaponTextureID=LoadImage(obj.weaponTextureFile)
			   SetObjectMeshImage(obj.ID,2,obj.weaponTextureID,0)    
			endif
			firstCatObjID.insert(obj.ID)
			firstCatObjFilename.insert(obj.objectFile)
	    endcase   
	endselect   
	if (obj.collision=1)
	   SetObjectCollisionMode(obj.ID,obj.collision)
	else    	
	   SetObjectCollisionMode(obj.ID,0)
	endif
	if (obj.color<>"") 
	   applyColor3D(obj)
    endif	
   	SetObjectVisible(obj.ID,0)
	SetObjectLightMode(obj.ID,obj.lightMode)
	if (obj.light<>0) 
		CreatePointLight(obj.light,obj.x,obj.y,obj.z,obj.lightRadius,255,255,255)
	endif
	if ((obj.objectType<>"terrain") or (obj.category<>CAT_TERRAIN_AGK)) 
		obj.y=obj.y+getFloor(obj.x,obj.z,-1)+obj.altitude
	else
		obj.y=obj.y+5			
	endif	
	positionObject3D(obj)
endfunction	

function createObjects(jsonFile as string)
	i as integer
	numObjs as integer
	advanceBarSpriteID as integer
	advanceBarTextID as integer
	advanceBarUnit as float
	oggetti3D.length=-1
	terrainAGK_index=-1
	fps_index=-1
	SetFolder(WORLDS_FOLDER)
	if (parse3DJSON(oggetti3D,jsonFile)=-1) 
		exitfunction -1
	endif	
	advanceBarTextID=CreateText("Loading world <"+levelName+">")
	SetTextSize(advanceBarTextID,48)
	SetTextPosition(advanceBarTextID,SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2+192)
	SetTextAlignment(advanceBarTextID,1)
	SetTextColor(advanceBarTextID,GetColorRed3D(DARKBLUE),GetColorGreen3D(DARKBLUE),GetColorBlue3D(DARKBLUE),255)
	numObjs=oggetti3D.length
	remstart
	for i=0 to numObjs
		print_debug(str(numObjs)+"<"+oggetti3D[i].name+">")
		pauseTime(0.1)
	next i	
	remend
	advanceBarUnit=800/numObjs
	advanceBarSpriteID=CreateSprite(0)
	SetSpriteColor(advanceBarSpriteID,128,0,0,255)
	SetSpritePosition(advanceBarSpriteID,SCREEN2D_WIDTH/2-400,SCREEN2D_HEIGHT/2+256)
	firstCatObjFilename.length=0
	firstCatObjID.length=0
	for i=0 to numObjs
		backImageScroll(0)
		createOggetto3D(oggetti3D[i])		
		if (oggetti3D[i].category=CAT_GHOST)
			fps_index=i
		elseif (oggetti3D[i].category=CAT_TERRAIN_AGK)
			terrainAGK_index=i
		endif   
		SetSpriteSize(advanceBarSpriteID,(i+1)*advanceBarUnit,64)
		sync()
	next i	
	weapon_index=findObjectByName(oggetti3D,oggetti3D[fps_index].weapon)
	oggetti3D[weapon_index].status=STATUS_IDLE
	hand_index=findObjectByName(oggetti3D,"hand")
	DeleteSprite(advanceBarSpriteID)
	DeleteText(advanceBarTextID)
	deleteBackImage()
	//listObjects(oggetti3D)
endfunction 0

function createTileShader(tile_x as float, tile_y as float)
	tileShader as integer
	tileShader=LoadShader("walls.vs","walls.ps")
	SetShaderConstantByName(tileShader,"repetitions",tile_x,tile_y,1.0,1.0)
endfunction tileShader 

function createTerrainShader(detail_x as float, detail_y as float)
	terrainShader as integer
	terrainShader=LoadShader("vertexDetail.vs","pixelDetail.ps")
	SetShaderConstantByName( terrainShader, "ScaleDetailMap",detail_x ,detail_y,0, 0 )	
endfunction terrainShader 

function createTerrainAGKShader()
	terrainAGKShader as integer
	terrainAGKShader=LoadShader("terrain_agk.vs","terrain_agk.ps")
endfunction terrainAGKShader 

	
function createTerrainMap(terrainMapFile as string, terrainAltitudeFile as string)
	i as integer
	j as integer
	i1 as integer
	j1 as integer
	x as integer
	y as integer
	lenWallX as float
	lenWallY as float
	searchX as integer
	searchY as integer
	saveSearchX as integer
	saveSearchY as integer
	squareFlag as integer
	minLen as float
	maxLen as float
	wallID as integer
	textureID as integer
	textureID1 as integer
	textureID2 as integer
	start_map_height as float
	start_map_altitude as float
	max_terrain_size as float
	wallTextures as integer[]
	textureIndex as integer
	repetitions1 as float
	repetitions2 as float
	wallShader as integer
	advanceBarSpriteID as integer
	advanceBarTextID as integer
	advanceBarUnit as float
	newObject as Oggetto3D
	numObjs as integer
	if (loadGenericMap(terrainMapFile, terrainMap)=-1) 
		exitfunction -1
	endif
	if (loadGenericMap(terrainAltitudeFile, altitudeMap)=-1) 
		exitfunction -1
	endif
	advanceBarTextID=CreateText("Loading Map <"+levelName+">")
	SetTextSize(advanceBarTextID,48)
	SetTextPosition(advanceBarTextID,SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2+192)
	SetTextAlignment(advanceBarTextID,1)
	SetTextColor(advanceBarTextID,GetColorRed3D(DARKBLUE),GetColorGreen3D(DARKBLUE),GetColorBlue3D(DARKBLUE),255)
	numObjs=TERRAIN_MAP_SIZE_Z*TERRAIN_MAP_SIZE_X
	advanceBarUnit=800.0/numObjs
	advanceBarSpriteID=CreateSprite(0)
	SetSpriteColor(advanceBarSpriteID,128,0,0,255)
	SetSpritePosition(advanceBarSpriteID,SCREEN2D_WIDTH/2-400,SCREEN2D_HEIGHT/2+256)
	wallTextures.length=trunc(max2(TERRAIN_MAP_SIZE_X, TERRAIN_MAP_SIZE_Z))+1
	SetFolder(OBJECTS_FOLDER)
	textureID1=LoadImage("brick.png")
	textureID2=LoadImage("brick2.png")
	SetImageWrapU(textureID1,1)
	SetImageWrapV(textureID1,1)
	SetImageWrapU(textureID2,1)
	SetImageWrapV(textureID2,1)
	backImageScroll(0)
	for y=1 to TERRAIN_MAP_SIZE_Z
		for x=1 to TERRAIN_MAP_SIZE_X
			copyTerrainMap[x,y]=terrainMap[x,y]
		next x
	next y		
	for y=1 to TERRAIN_MAP_SIZE_Z
		for x=1 to TERRAIN_MAP_SIZE_X
			if (terrainMap[x,y]>0)
				start_map_height=terrainMap[x,y]
				start_map_altitude=altitudeMap[x,y]
				clearOggetto3D(newObject)
				searchX=x
				searchY=y
				while ((terrainMap[searchX,searchY]=start_map_height) and (altitudeMap[searchX,searchY]=start_map_altitude) and (searchX<TERRAIN_MAP_SIZE_X))
					inc searchX
				endwhile
				if 	(terrainMap[searchX,searchY]<>start_map_height) 
					dec searchX
				endif
				lenWallX=searchX-x+1
				saveSearchX=searchX
				searchX=x
				searchY=y
				while ((terrainMap[searchX,searchY]=start_map_height) and (altitudeMap[searchX,searchY]=start_map_altitude) and (searchY<TERRAIN_MAP_SIZE_Z))
					inc searchY
				endwhile
				if 	(terrainMap[searchX,searchY]<>start_map_height) or (altitudeMap[searchX,searchY]<>start_map_altitude)
					dec searchY
				endif
				lenWallY=searchY-y+1	
				saveSearchY=searchY
				squareFlag=1
				minLen=min2(lenWallX,lenWallY)
				maxLen=max2(lenWallX,lenWallY)
				if (minLen>1)
					for j=y to y+minLen-1
						for i=x to x+minLen-1
							if ((terrainMap[i,j]<>start_map_height) or (altitudeMap[i,j]<>start_map_altitude)) then squareFlag=0
						next i
					next j
					if (squareFlag=1)
						for j=y to y+minLen-1
							for i=x to x+minLen-1
								for j1=(j-1)*10 to (j*10-1)
									for i1=(i-1)*10 to (i*10-1)
										if (start_map_altitude>0)
											terrain3D[i1,j1]=5
										else	
											terrain3D[i1,j1]=start_map_height*5+5
										endif	
									next i1
								next j1		
								terrainMap[i,j]=0
							next i
						next j 
						wallID=CreateObjectBox(minLen*10,start_map_height*5,minLen*10)	
						SetObjectPosition(wallID,(x+minLen/2-TERRAIN_MAP_SIZE_X/2-1)*10-5,(start_map_height*5)/2+5+start_map_altitude*5,(y+minLen/2-TERRAIN_MAP_SIZE_Z/2-1)*10-5)
						lenWallX=minLen
						lenWallY=minLen
					endif
				else
					squareFlag=0
				endif
				if (squareFlag=0)			
					if (lenWallX>=lenWallY)
						for i=x to x+lenWallX-1
							for j1=(y-1)*10 to (y*10-1)
								for i1=(i-1)*10 to (i*10-1)
									if (start_map_altitude>0)
										terrain3D[i1,j1]=5
									else	
										terrain3D[i1,j1]=start_map_height*5+5
									endif	
								next i1
							next j1		
							terrainMap[i,y]=0				
						next i
						wallID=CreateObjectBox(lenWallX*10,start_map_height*5,10)	
						SetObjectPosition(wallID,(x-1+lenWallX/2-TERRAIN_MAP_SIZE_X/2)*10-5,(start_map_height*5)/2+5+start_map_altitude*5,(y-1-TERRAIN_MAP_SIZE_Z/2)*10)
						lenWallY=1
					else
						for j=y to y+lenWallY-1
							for j1=(j-1)*10 to (j*10-1)
								for i1=(x-1)*10 to (x*10-1)
									if (start_map_altitude>0)
										terrain3D[i1,j1]=5
									else	
										terrain3D[i1,j1]=start_map_height*5+5
									endif
								next i1
							next j1		
							terrainMap[x,j]=0
						next j
						wallID=CreateObjectBox(10,start_map_height*5,lenWallY*10)	
						SetObjectPosition(wallID,(x-TERRAIN_MAP_SIZE_X/2-0.5)*10-5,(start_map_height*5)/2+5+start_map_altitude*5,(y-1+lenWallY/2-TERRAIN_MAP_SIZE_Z/2)*10-5)
						lenWallX=1
					endif					
				endif		
				newObject.ID=wallID
				populateOggetto3D(newObject,"name","wall"+str(x)+"_"+str(y))
				populateOggetto3D(newObject,"collision","1")
				populateOggetto3D(newObject,"category","BLOCK")
				populateOggetto3D(newObject,"status","IDLE")
				if ((lenWallX>20) or (lenWallY>20))
					textureID=textureID1
					repetitions1=10.0
					repetitions2=4.0
				else
					textureID=textureID2
					repetitions1=max2(lenWallX,lenWallY)
					repetitions2=(lenWallX+lenWallY)/2
				endif 
				remstart
				textureIndex=texturePlaneWidth
				if (wallTextures[textureIndex]=0)
					wallTextures[textureIndex]=createTextureFromImage(textureID,texturePlaneWidth,trunc(start_map_height/2)+1)
				endif	
				newObject.textureID=wallTextures[textureIndex]
				remend
				SetObjectLightMode(wallID,0)
				//SetObjectImage(newObject.ID,newObject.textureID,0)
				SetObjectImage(newObject.ID,textureID,0)
				SetObjectShader(newObject.ID,createTileShader(repetitions1,repetitions2))
				SetObjectCollisionMode(newObject.ID,1)
				SetObjectVisible(newObject.ID,0)
				oggetti3D.insert(newObject)
				clearOggetto3D(newObject)	
				SetSpriteSize(advanceBarSpriteID,(x+(y-1)*TERRAIN_MAP_SIZE_X)*advanceBarUnit,64)
				sync()
			endif
		next x
	next y		
	DeleteSprite(advanceBarSpriteID)
	DeleteText(advanceBarTextID)	
	deleteBackImage()	
endfunction 0

remstart		
function loadTerrainMap(terrainMapFile as string)
	terrainMapFileID as integer
	mapLine as string
	map_ascii as integer
	map_height as integer
	x as integer
	y as integer = 1
	SetFolder(MAPS_FOLDER)
	if (GetFileExists(terrainMapFile)=0) then exitfunction -1
	terrainMapFileID=OpenToRead(terrainMapFile)
	while ((FileEOF(terrainMapFileID)=0) and (y<=TERRAIN_MAP_SIZE_Z))
		mapLine=ReadLine(terrainMapFileID)
		for x=1 to len(mapLine)
			if (x<=TERRAIN_MAP_SIZE_X)
				map_ascii=asc(mid(mapLine,x,1))
				if (map_ascii>=asc("A")) and (map_ascii<=asc("F"))
					 map_height=10+map_ascii-asc("A")
				elseif (map_ascii>=asc("a")) and (map_ascii<=asc("f"))
					 map_height=10+map_ascii-asc("a")
				elseif (map_ascii>=asc("0")) and (map_ascii<=asc("9"))
					 map_height=map_ascii-asc("0")
				else
					 map_height=0
				endif	
				//print(str(map_height))
				//pauseTime(0.1)
				terrainMap[x,y]=map_height		 
			endif	
		next x
		rem print(str(TERRAIN_MAP_SIZE_X)+" "+str(TERRAIN_MAP_SIZE_Z)+" "+str(x-1)+" "+str(y)+" "+str(terrainMap[x-1,y]))
		rem pausetime(1)	
		y=y+1		
	endwhile	
	CloseFile(terrainMapFileID)
endfunction 0
remend

function loadGenericMap(genericMapFile as string,genericMap ref as float[][] )
	genericMapFileID as integer
	mapLine as string
	map_ascii as integer
	map_height as integer
	x as integer
	y as integer = 1
	SetFolder(MAPS_FOLDER)
	if (GetFileExists(genericMapFile)<>1)  
		exitfunction -1
	endif	
	genericMapFileID=OpenToRead(genericMapFile)
	while ((FileEOF(genericMapFileID)=0) and (y<=TERRAIN_MAP_SIZE_Z))
		mapLine=ReadLine(genericMapFileID)
		for x=1 to len(mapLine)
			if (x<=TERRAIN_MAP_SIZE_X)
				map_ascii=asc(mid(mapLine,x,1))
				if (map_ascii>=asc("A")) and (map_ascii<=asc("F"))
					 map_height=10+map_ascii-asc("A")
				elseif (map_ascii>=asc("a")) and (map_ascii<=asc("f"))
					 map_height=10+map_ascii-asc("a")
				elseif (map_ascii>=asc("0")) and (map_ascii<=asc("9"))
					 map_height=map_ascii-asc("0")
				else
					 map_height=0
				endif	
				//print(str(map_height))
				//pauseTime(0.1)
				genericMap[x,y]=map_height		 
			endif	
		next x
		rem print(str(TERRAIN_MAP_SIZE_X)+" "+str(TERRAIN_MAP_SIZE_Z)+" "+str(x-1)+" "+str(y)+" "+str(terrainMap[x-1,y]))
		rem pausetime(1)	
		y=y+1		
	endwhile	
	CloseFile(genericMapFileID)
endfunction 0		

function showObjects()
	i as integer
	for i=0 to oggetti3D.length
		if (oggetti3D[i].status<>STATUS_HIDDEN) 
			SetObjectVisible(oggetti3D[i].ID,1)
			if (oggetti3D[i].animated=1) 
		       SetObjectAnimationSpeed(oggetti3D[i].ID,oggetti3D[i].moveStep*150)
		       select oggetti3D[i].category
				   case CAT_ENEMY
					   PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),oggetti3D[i].animActiveStart,oggetti3D[i].animActiveEnd,1,0)
				   endcase
				   case default
					   PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),0,-1,1,0)
				   endcase
			  endselect	   	
		    endif   
		else
			if (isMultiPlayerLAN=1) and (oggetti3D[i].category=CAT_PLAYER)
				SetObjectVisible(oggetti3D[i].ID,1)
				oggetti3D[i].status=STATUS_IDLE
			    SetObjectCollisionMode(oggetti3D[i].ID,1)
			   oggetti3D[i].collision=1
			else	
			   SetObjectVisible(oggetti3D[i].ID,0)
			   SetObjectCollisionMode(oggetti3D[i].ID,0)
			   oggetti3D[i].collision=0
			endif   
		endif		
	next i	
	SetSkyBoxSunSize(10,50)
	SetSkyBoxSunColor(255,255,128)
	SetSkyBoxVisible(1)
	SetSkyBoxSunVisible(1)
	SetSunActive(1)
endfunction 0

function findObjectByName(objs3D as Oggetto3D[],name as string)
	i as integer
	for i=0 to objs3D.length
		if (objs3D[i].name=name)
			exitfunction i
		endif
	next i
endfunction -1	

function findObjectByID(objs3D as Oggetto3D[],ID as integer)
	i as integer
	for i=0 to objs3D.length
		if (objs3D[i].ID=ID)
			exitfunction i
		endif
	next i
endfunction -1	

function findObjectByCategory(objs3D as Oggetto3D[],category as integer)
	i as integer
	for i=0 to objs3D.length
		if (objs3D[i].category=category)
			exitfunction i
		endif
	next i
endfunction -1		

// Check if the terrain height difference is too big (angle the object i is facing)
function checkTerrainOnPath(objs3D ref as Oggetto3D[], i as integer)
	hitObjID as integer
	hitObjIndex as integer
	localHeight as float
	weaponBoneIndex as integer
	weapon_angle_x as float
	weapon_angle_y as float
	weapon_angle_z as float
	k as float
	h1_x as float
	h1_z as float
	h2_x as float
	h2_z as float
	x1 as float
	x2 as float
	z1 as float
	z2 as float
	slope_x as float
	slope_z as float
	nearHeight as float = 0
	if (objs3D[i].category=CAT_TANK) and (terrainAGK_index<>-1)
		h1_x=GetObjectHeightMapHeight(objs3D[terrainAGK_index].ID,objs3D[i].x-2.5,objs3D[i].z)
		h1_z=GetObjectHeightMapHeight(objs3D[terrainAGK_index].ID,objs3D[i].x,objs3D[i].z-2.5)
		h2_x=GetObjectHeightMapHeight(objs3D[terrainAGK_index].ID,objs3D[i].x+2.5,objs3D[i].z)
		h2_z=GetObjectHeightMapHeight(objs3D[terrainAGK_index].ID,objs3D[i].x,objs3D[i].z+2.5)
		slope_x=atan(-(h2_x-h1_x)/5)
		slope_z=atan(-(h2_z-h1_z)/5)
		//print("")
		//print("h1_x h2_x slope_x "+str(h1_x)+" "+str(h2_x)+" "+str(slope_x))
		//print("h1_z h2_z slope_z "+str(h1_z)+" "+str(h2_z)+" "+str(slope_z))
		SetObjectRotation(objs3D[i].ID,slope_x,objs3D[i].angle_y,slope_z)
		updateRot3D(objs3D[i])
	endif	
	if (terrainAGK_index=-1) or (objs3D[i].maxSlope=-1) then exitfunction 
	localHeight=GetObjectHeightMapHeight(objs3D[terrainAGK_index].id,objs3D[i].x,objs3D[i].z)
	for k=2 to 5
		nearHeight=nearHeight+GetObjectHeightMapHeight(objs3D[terrainAGK_index].id,objs3D[i].x+sin(objs3D[i].angle_y-180)*k,objs3D[i].z+cos(objs3D[i].angle_y-180)*k)
	next k
	nearHeight=nearHeight/4
	if (abs(localHeight-nearHeight)>objs3D[i].maxSlope) 
		objs3D[i].status=STATUS_CHANGEROUTE
	endif
endfunction

// Check if there are obstacles on the current path (angle the object i is facing)
function checkObstacleOnPath(objs3D ref as Oggetto3D[], i as integer, r as float)
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	new_angle_y as float
	current_angle_y as float
	current_angle_y=GetObjectAngleY(objs3D[i].ID)
	startCheckPos=computeFPSRaycastStart2(objs3D[i],0,2+objs3D[i].base_y)
	endCheckPos=computeFPSRaycastTarget(objs3D[i],startCheckPos,0,r,2)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,1)
	if (hitObjID<>0) 
		hitObjIndex=findObjectByID(objs3D,hitObjID)
		if (hitObjIndex<>-1)
			if (objs3D[i].ID=objs3D[hitObjIndex].ID) then exitfunction
			raycast_cat=objs3D[hitObjIndex].category
			if (raycast_cat=CAT_BLOCK) or (raycast_cat=CAT_SKY) or (raycast_cat=CAT_STAIRS) or (raycast_cat=CAT_VERTICAL_STAIRS) or (raycast_cat=CAT_BULLET) or (raycast_cat=CAT_VERTICAL_DOORS) or (raycast_cat=CAT_TANK) or (raycast_cat=CAT_ENEMY)
				rem print_debug("ostacolo path change route "+str(oggetti3D[hitObjIndex].ID))
				objs3D[i].status=STATUS_CHANGEROUTE
			endif		 
			objs3D[i].x=GetObjectRayCastSlideX(0)
			objs3D[i].y=GetObjectRayCastSlideY(0)
			objs3D[i].z=GetObjectRayCastSlideZ(0)
			updatePosRot3D(objs3D[i])
		endif	
	endif
endfunction

// Check if there are obstacles on a candidate direction new_angle_y
function checkObstacleOnDirection(objs3D ref as Oggetto3D[], i as integer, new_angle_y as float, r as float)
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	current_angle_y as float
	angleOffset as float
	angleOffset=180
	current_angle_y=GetObjectAngleY(objs3D[i].ID)
	startCheckPos=computeFPSRaycastStart2(objs3D[i],0,2+objs3D[i].base_y)
	endCheckPos.x=startCheckPos.x+sin(new_angle_y-angleOffset)*r
	endCheckPos.y=objs3D[i].y+2
	endCheckPos.z=startCheckPos.z+cos(new_angle_y-angleOffset)*r
	endCheckPos=computeFPSRaycastTarget(objs3D[i],startCheckPos,0,r,2)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,1)
	if (hitObjID<>0) 
		hitObjIndex=findObjectByID(objs3D,hitObjID)
		if (hitObjIndex<>-1)
			if (objs3D[i].ID=objs3D[hitObjIndex].ID) then exitfunction 0
			raycast_cat=objs3D[hitObjIndex].category
			rem print_debug("ostacolo direzione "+str(oggetti3D[hitObjIndex].ID))
			if (raycast_cat=CAT_BLOCK) or (raycast_cat=CAT_SKY) or (raycast_cat=CAT_STAIRS) or (raycast_cat=CAT_VERTICAL_STAIRS) or (raycast_cat=CAT_BULLET) or (raycast_cat=CAT_VERTICAL_DOORS) or (raycast_cat=CAT_TANK) or (raycast_cat=CAT_ENEMY) 
				exitfunction 1
			endif	
		endif		 
	endif
endfunction 0

function turnObject3D(i as integer)
	current_angle_y as float
	current_angle_y=GetObjectAngleY(oggetti3D[i].ID)
	if (abs(current_angle_y-oggetti3D[i].newAngleY)<3)
		oggetti3D[i].turningFlag=0	
	elseif (current_angle_y<oggetti3D[i].newAngleY)
		RotateObjectLocalY(oggetti3D[i].ID,3)
	elseif	(current_angle_y>oggetti3D[i].newAngleY)
		RotateObjectLocalY(oggetti3D[i].ID,-3)
	endif
	updatePosRot3D(oggetti3D[i])
endfunction

rem retVal=0 if no collision, 1 if left collision, 2 if right collision, 3 if both collision
function checkNormal3D(i as integer, range as float, offset_y as float)
	current_angle_y as float
	startCheckPosRight as Vector3D
	startCheckPosLeft as Vector3D
	endCheckPosRight as Vector3D
	endCheckPosLeft as Vector3D
	retVal as integer
	hitObjID as integer
	angleOffset as float
	angleOffset=180
	retVal=0
	current_angle_y=GetObjectAngleY(oggetti3D[i].ID)
	startCheckPosRight.x=oggetti3D[i].x+sin(oggetti3D[i].angle_y-angleOffset+90)
	startCheckPosRight.y=oggetti3D[i].y+offset_y
	startCheckPosRight.z=oggetti3D[i].z+cos(oggetti3D[i].angle_y-angleOffset+90)
	startCheckPosLeft.x=oggetti3D[i].x+sin(oggetti3D[i].angle_y-angleOffset-90)
	startCheckPosLeft.y=oggetti3D[i].y+offset_y
	startCheckPosLeft.z=oggetti3D[i].z+cos(oggetti3D[i].angle_y-angleOffset-90)
	endCheckPosRight.x=startCheckPosRight.x+sin(oggetti3D[i].angle_y-angleOffset+90)*range
	endCheckPosRight.y=oggetti3D[i].y+offset_y
	endCheckPosRight.z=startCheckPosRight.z+cos(oggetti3D[i].angle_y-angleOffset+90)*range
	endCheckPosLeft.x=startCheckPosLeft.x+sin(oggetti3D[i].angle_y-angleOffset-90)*range
	endCheckPosLeft.y=oggetti3D[i].y+offset_y
	endCheckPosLeft.z=startCheckPosLeft.z+cos(oggetti3D[i].angle_y-angleOffset-90)*range
	hitObjID=checkSphereCollision(0,startCheckPosLeft,endCheckPosLeft,1)
	if 	(hitObjID<>0) then retVal=1
	rem print("hitObjID Left "+str(hitObjID)+" "+str(findObjectByID(oggetti3D,hitObjID)))
	hitObjID=checkSphereCollision(0,startCheckPosRight,endCheckPosRight,1)
	rem print("hitObjID Right "+str(hitObjID)+" "+str(findObjectByID(oggetti3D,hitObjID)))
	if 	(hitObjID<>0) then retVal=retVal+2
endfunction retVal

function checkDown3D(i as integer, range as float, offset_y as float)
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	currentAltitude as float
	nearAltitude as float
	floorCollision as integer
	current_angle_y as float
	currentFloorY as float
	nearFloorY as float
	startCheckPosDown as Vector3D
	endCheckPosDown as Vector3D
	retVal as integer
	hitObjID as integer
	hitNearFloor as integer
	angleOffset as float
	angleOffset=180
	retVal=1
	current_angle_y=GetObjectAngleY(oggetti3D[i].ID)
	startCheckPosDown.x=oggetti3D[i].x
	startCheckPosDown.y=oggetti3D[i].y+offset_y+oggetti3D[i].base_y
	startCheckPosDown.z=oggetti3D[i].z
	endCheckPosDown.x=oggetti3D[i].x+sin(oggetti3D[i].angle_y-angleOffset)*range
	endCheckPosDown.y=startCheckPosDown.y
	endCheckPosDown.z=oggetti3D[i].z+cos(oggetti3D[i].angle_y-angleOffset)*range
	sx=startCheckPosDown.x
	sy=startCheckPosDown.y
	sz=startCheckPosDown.z
	ex=endCheckPosDown.x
	ey=endCheckPosDown.y
	ez=endCheckPosDown.z
	currentFloorY=getFloor(sx,sz,i)
	nearFloorY=getFloor(ex,ez,i)
	hitNearFloor=checkNearFloorCollision(oggetti3D[i],0,2)
	//floorCollision=checkSphereCollision(0,startCheckPosDown,endCheckPosDown,0.5)
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	remstart
	if (i=11) 
		 print("floor collision "+str(floorCollision)+"retval "+str(retVal))
		 print("currentfloor "+str(currentFloorY)+" nearfloor "+str(nearFloorY)+"oggetto y"+str(oggetti3D[i].y))
		 print("currentaltitude "+str(getAltitude(sx,sz))+"oggetto y"+str(oggetti3D[i].y))
	endif
	remend
	if ((currentFloorY>nearFloorY) and (terrainAGK_index=-1)) or ((hitNearFloor=-1) and (oggetti3D[i].onObject<>-1))
		retVal=0	
	elseif(oggetti3D[i].y<(currentFloorY-oggetti3D[i].base_y))
		oggetti3D[i].y=currentFloorY-oggetti3D[i].base_y
	endif	
endfunction retVal

function objectManager()
	i as integer
	x as float
	y as float
	z as float
	boneX as float
	boneY as float
	boneZ as float
	boneAngleX as float
	boneAngleY as float
	boneAngleZ as float
	bone_angleX as float
	bone_angleY as float
	bone_angleZ as float
	boneIndex as integer
	normalFlag as integer
	msg as MessageFPS
	index as integer
	status as integer
	forwardStep as float
	weapon_radius as float
	current_angle_y as float
	updateObjFlag as integer
	new_angle_y as float
	dvx as float
	dvz as float
	scale_fire as float
	bulletLifeIncrement as float
	ufoLaserLength as float
	targetFlyingAltitude as float
	for i=0 to oggetti3D.length
		remstart
		if (oggetti3D[i].canFire=1) and (oggetti3D[i].status<>STATUS_ACTIVE)
			print_debug("status "+str(oggetti3D[i].status))
		endif	
		print("ID "+str(oggetti3D[i].ID)+" name "+oggetti3D[i].name)
		remend
		updateObjFlag=0
		if (i=weapon_index) 
		   if (oggetti3D[i].status<>STATUS_WEAPON_FIRE)
	          oggetti3D[i].y=oggetti3D[fps_index].y+1	
	          oggetti3D[i].z=oggetti3D[fps_index].z+3*sin(oggetti3D[fps_index].angle_y)
	          oggetti3D[i].x=oggetti3D[fps_index].x-3*cos(oggetti3D[fps_index].angle_y)
	       endif
	    endif   
		select oggetti3D[i].status
			case STATUS_OPENING
				oggetti3D[i].angle_y=oggetti3D[i].angle_y+1
				positionObject3D(oggetti3D[i])
				//print("")
				//print("angolo "+str(oggetti3D[i].angle_y))
				if (oggetti3D[i].angle_y>=90) 
					oggetti3D[i].status=STATUS_OPEN
				endif
			endcase	
			case STATUS_CLOSING
				oggetti3D[i].angle_y=oggetti3D[i].angle_y-1
				positionObject3D(oggetti3D[i])
				//print("")
				//print("angolo "+str(oggetti3D[i].angle_y))
				if (oggetti3D[i].angle_y<=0) 
					oggetti3D[i].status=STATUS_CLOSED
				endif
			endcase	
			case STATUS_FPS_DYING
				if (i=fps_index)
					if (abs(oggetti3D[i].angle_z)<90)
					   oggetti3D[i].angle_z=oggetti3D[i].angle_z+1
					   oggetti3D[weapon_index].angle_z=oggetti3D[weapon_index].angle_z+1 
					   RotateCameraLocalZ(1,-1)  
					else
						oggetti3D[i].status=STATUS_GAME_OVER
						stopLoopingSounds(0)
						if (isMultiPlayerLAN=1)
							isMultiPlayerLAN=0
							CloseNetwork(networkID)
						endif	
					endif	   
				endif		
			endcase	
			case STATUS_ACTIVE
				if (isMultiPlayerLAN=0) or (isHostLAN=1) or ((oggetti3D[i].category<>CAT_ENEMY) and (oggetti3D[i].category<>CAT_TANK) and (oggetti3D[i].category<>CAT_FLYING))  
						if (abs(oggetti3D[i].moveStep)>0.001) and (oggetti3D[i].turningFlag=0)
							if (oggetti3D[i].flip=1) 
								forwardStep=-oggetti3D[i].moveStep
							else
								forwardStep=oggetti3D[i].moveStep		
							endif	
						else
								forwardStep=0
						endif		
						if (abs(oggetti3D[i].rotateStep)>0.001) and (oggetti3D[i].turningFlag=0)
							rotateObject3D(oggetti3D[i],0,oggetti3D[i].rotateStep,0)
						endif		
					select oggetti3D[i].category
						case CAT_BULLET
							bulletLifeIncrement=oggetti3D[i].moveStep*inventory[selected_inventory_index].speed
							oggetti3D[i].life=oggetti3D[i].life+bulletLifeIncrement
							forwardStep=forwardStep*inventory[selected_inventory_index].speed
							if (inventory[selected_inventory_index].range<>0)
								if (inventory[selected_inventory_index].trajectory=TRAJECTORY_PARABOLIC)
									if (oggetti3D[i].life<=(inventory[selected_inventory_index].range/2))
										moveYObject3D(oggetti3D[i], inventory[selected_inventory_index].yStep)
									else	
										moveYObject3D(oggetti3D[i], -inventory[selected_inventory_index].yStep)
									endif
								else
									moveYObject3D(oggetti3D[i], inventory[selected_inventory_index].range*tan(-cam_angle_xy)*(bulletLifeIncrement/inventory[selected_inventory_index].range))
									remstart
									print("")
									print("life "+str(oggetti3D[i].life))
									print("range "+str(inventory[selected_inventory_index].range))
									print("cam_angle_xy "+str(cam_angle_xy))
									print("tan_angle_xy "+str(tan(cam_angle_xy)))
									print("Bullet "+str(oggetti3D[i].y))
									remend
								endif
							endif			
							if (inventory[selected_inventory_index].range<>0) and (abs(oggetti3D[i].life)>=inventory[selected_inventory_index].range)
								if (inventory[selected_inventory_index].category=CAT_INV_BOMB) 
									oggetti3D[i].status=STATUS_BOMB_EXPLOSION
									PlaySound(getSoundByName("explosion"))
								else
									oggetti3D[i].status=STATUS_ENDING
								endif		
							endif
						endcase
						case CAT_LIFT
							if (isMultiPlayerLAN=0) or (isHostLAN=1)
								//print("lift_velY "+str(oggetti3D[i].lift_velY))
								//print("lift_minY "+str(oggetti3D[i].lift_minY))
								//print("lift_maxY "+str(oggetti3D[i].lift_maxY))
								//print("fps y "+str(oggetti3D[fps_index].y))
								//print("i"+str(i))
								oggetti3D[i].x=oggetti3D[i].x+oggetti3D[i].lift_velX
								oggetti3D[i].y=oggetti3D[i].y+oggetti3D[i].lift_velY
								oggetti3D[i].z=oggetti3D[i].z+oggetti3D[i].lift_velZ	
								if (oggetti3D[i].x>oggetti3D[i].lift_maxX)
									oggetti3D[i].lift_velX=-abs(oggetti3D[i].lift_velX)
								elseif  (oggetti3D[i].x<oggetti3D[i].lift_minX)
									oggetti3D[i].lift_velX=abs(oggetti3D[i].lift_velX)
								endif	
								if (oggetti3D[i].y>oggetti3D[i].lift_maxY)
									oggetti3D[i].lift_velY=-abs(oggetti3D[i].lift_velY)
								elseif  (oggetti3D[i].y<oggetti3D[i].lift_minY)
									oggetti3D[i].lift_velY=abs(oggetti3D[i].lift_velY)
								endif
								if (oggetti3D[i].z>oggetti3D[i].lift_maxZ)
									oggetti3D[i].lift_velZ=-abs(oggetti3D[i].lift_velZ)
								elseif  (oggetti3D[i].z<oggetti3D[i].lift_minZ)
									oggetti3D[i].lift_velZ=abs(oggetti3D[i].lift_velZ)
								endif
								if (oggetti3D[fps_index].onObject=i)
									//print("salgo "+str(oggetti3D[fps_index].onObject))
									oggetti3D[fps_index].x=oggetti3D[fps_index].x+oggetti3D[i].lift_velX
									oggetti3D[fps_index].y=oggetti3D[fps_index].y+oggetti3D[i].lift_velY
									oggetti3D[fps_index].z=oggetti3D[fps_index].z+oggetti3D[i].lift_velZ
								endif
							endif
							positionObject3D(oggetti3D[i])
							//positionObject3D(oggetti3D[fps_index])
						endcase	
						case CAT_FLYING	
							targetFlyingAltitude=getFloor(oggetti3D[i].x,oggetti3D[i].z,-1)+oggetti3D[i].altitude-oggetti3D[i].base_y
							if (targetFlyingAltitude<oggetti3D[i].y)
								oggetti3D[i].y=oggetti3D[i].y-0.1
							elseif	(targetFlyingAltitude>oggetti3D[i].y)
								oggetti3D[i].y=oggetti3D[i].y+0.1
							endif	
							//oggetti3D[i].y=getFloor(oggetti3D[i].x,oggetti3D[i].z)+oggetti3D[i].altitude-oggetti3D[i].base_y
							positionObject3D(oggetti3D[i])
							//print("")
							//print("altitudine "+str(oggetti3D[i].altitude))
							//print("y "+str(oggetti3D[i].y))
						endcase	
						case default
							
							if (oggetti3D[i].onObject=-1)
								oggetti3D[i].y=getFloor(oggetti3D[i].x,oggetti3D[i].z,i)-oggetti3D[i].base_y
								positionObject3D(oggetti3D[i])
							endif	
						endcase  	  
					endselect
					if ((oggetti3D[i].category<>CAT_ENEMY) and (oggetti3D[i].category<>CAT_TANK) and (oggetti3D[i].category<>CAT_FLYING)) or (((oggetti3D[i].category=CAT_ENEMY) or (oggetti3D[i].category=CAT_TANK) or (oggetti3D[i].category=CAT_FLYING)) and (oggetti3D[i].hittingPlayer=0))
						moveZObject3D(oggetti3D[i],forwardStep)
					endif				
					if (oggetti3D[i].ai>0) and (oggetti3D[i].hittingPlayer=0)
						rem print("new_angle_y "+str(oggetti3D[i].newAngleY))
						select oggetti3D[i].ai
							case AI_AVOID_OBSTACLES
								if (oggetti3D[i].category<>CAT_FLYING) then checkTerrainOnPath(oggetti3D,i)
								if (oggetti3D[i].turningFlag=0)
									if (random2(1,100)<=1)
										dvx=getDistanceVectorX(oggetti3D[fps_index].x,oggetti3D[fps_index].z,oggetti3D[i].x,oggetti3D[i].z)
										dvz=-getDistanceVectorY(oggetti3D[fps_index].x,oggetti3D[fps_index].z,oggetti3D[i].x,oggetti3D[i].z)
										if (dvx>=0) and (dvz>=0) 
											new_angle_y=acos(dvx)+90
										elseif (dvx>=0) and (dvz<0) 
											new_angle_y=90-acos(dvx)
										elseif (dvx<0) and (dvz>=0) 	
											new_angle_y=acos(dvx)+90	
										else	
											new_angle_y=360-(acos(dvx)-90)
										endif
										remstart
										print("new_angle_y "+str(new_angle_y))
										print("dvx "+str(dvx))
										print("dvz "+str(dvz))
										print("acos dvx "+str(acos(dvx)))
										print("asin dvz "+str(asin(dvz)))
										if (new_angle_y>360) then new_angle_y=new_angle_y-360
										remend
										if (checkObstacleOnDirection(oggetti3D,i,new_angle_y,10)=0)
											oggetti3D[i].newAngleY=new_angle_y
											oggetti3D[i].turningFlag=1
										endif	
									else    
										checkObstacleOnPath(oggetti3D,i,5)
									endif
								else
									turnObject3D(i)	
								endif	
							endcase
							case AI_CHASE
								if (oggetti3D[i].turningFlag=0)
									if (random2(1,100)=1)
										SetObjectLookAt(oggetti3D[i].ID,oggetti3D[fps_index].x,oggetti3D[i].y,oggetti3D[fps_index].z,0)
										if (oggetti3D[i].flip=1) then RotateObjectLocalY(oggetti3D[i].ID,180)
										updatePosRot3D(oggetti3D[i])
									endif
								endif			
							endcase
							case AI_ESCAPE
								if (oggetti3D[i].turningFlag=0)
									SetObjectLookAt(oggetti3D[i].ID,oggetti3D[fps_index].x,oggetti3D[i].y,oggetti3D[fps_index].z,0)
									if (oggetti3D[i].flip=0) then RotateObjectLocalY(oggetti3D[i].ID,180)
									updatePosRot3D(oggetti3D[i])
								endif		
							endcase
							case AI_RANDOM
								current_angle_y=GetObjectAngleY(oggetti3D[i].ID)
								if (oggetti3D[i].turningFlag=0) and (random2(1,500)=1)
									oggetti3D[i].newAngleY=current_angle_y+RandomSign(random2(0,90))
									if (oggetti3D[i].newAngleY<0) 
										 oggetti3D[i].newAngleY=oggetti3D[i].newAngleY+360
									else
										oggetti3D[i].newAngleY=mod(oggetti3D[i].newAngleY,360)
									endif		 
									oggetti3D[i].turningFlag=1
									if (oggetti3D[i].flip=1) then RotateObjectLocalY(oggetti3D[i].ID,180)
								elseif (oggetti3D[i].turningFlag=1)
									turnObject3D(i)	
									checkObstacleOnPath(oggetti3D,i,5)
								endif	
							endcase
						endselect
						rem print("new Angle "+str(oggetti3D[i].newAngleY))
						rem print("turningFlag "+str(oggetti3D[i].turningFlag))
					endif
					oggetti3D[i].hittingPlayer=0			
				endif	
				if ((oggetti3D[i].category=CAT_ENEMY) or (oggetti3D[i].category=CAT_TANK) or (oggetti3D[i].category=CAT_FLYING))  and (oggetti3D[i].canFire=1) and (oggetti3D[i].fireObjID=0) and (random2(1,oggetti3D[i].fireRate)=1)
					oggetti3D[i].fireObjID=0
					oggetti3D[i].targetFireID=0
					oggetti3D[i].status=STATUS_FIRING
					if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
				endif	
			endcase
			case STATUS_FIRING
				if (oggetti3D[i].fireObjID=0)
					select oggetti3D[i].category
						case CAT_ENEMY
							oggetti3D[i].fireTimer=timer()
							oggetti3D[i].fireObjID=CreateObjectCapsule(1,3,2)
							boneX=getWeaponBoneWorldCoordinate(oggetti3D[i],0)
							boneY=getWeaponBoneWorldCoordinate(oggetti3D[i],1)
							boneZ=getWeaponBoneWorldCoordinate(oggetti3D[i],2)
							SetObjectPosition(oggetti3D[i].fireObjID,boneX+sin(oggetti3D[i].angle_y+oggetti3D[i].flip*180)*3,boneY,boneZ+cos(oggetti3D[i].angle_y+oggetti3D[i].flip*180)*3)
							SetObjectColor(oggetti3D[i].fireObjID,255,0,0,128)
							if (oggetti3D[i].targetFireID=0)
								oggetti3D[i].targetFireID=CreateObjectSphere(2,5,5)
								SetObjectPosition(oggetti3D[i].targetFireID,oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z)
								SetObjectCollisionMode(oggetti3D[i].targetFireID,1)
								SetObjectVisible(oggetti3D[i].targetFireID,0)
								playsound(getSoundByName("ak47"),100,1)
							endif	
						endcase
						case CAT_TANK
							oggetti3D[i].fireTimer=timer()
							oggetti3D[i].fireObjID=CreateObjectCapsule(5,8,0)
							boneX=GetObjectWorldX(oggetti3D[i].ID)
							boneY=GetObjectWorldY(oggetti3D[i].ID)+5
							boneZ=GetObjectWorldZ(oggetti3D[i].ID)
							if (oggetti3D[i].animated=1)
								boneAngleY=getWeaponBoneWorldAngle(oggetti3D[i],1)
								SetObjectPosition(oggetti3D[i].fireObjID,boneX-16*cos(boneAngleY+180*oggetti3D[i].flip),boneY+2.5,boneZ+16*sin(boneAngleY+180*oggetti3D[i].flip))
							else
								boneAngleY=oggetti3D[i].angle_y+90
								SetObjectPosition(oggetti3D[i].fireObjID,boneX-cos(boneAngleY+oggetti3D[i].flip*180)*(32+scale_fire),boneY+2.5,boneZ+sin(boneAngleY+oggetti3D[i].flip*180)*(32+scale_fire))
							endif		
							rem SetObjectRotation(oggetti3D[i].fireObjID,boneAngleX,boneAngleY,boneAngleZ)
							SetObjectColor(oggetti3D[i].fireObjID,255,0,0,128)
							if (oggetti3D[i].targetFireID=0)
								oggetti3D[i].targetFireID=CreateObjectSphere(4,5,5)
								SetObjectPosition(oggetti3D[i].targetFireID,oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z)
								SetObjectCollisionMode(oggetti3D[i].targetFireID,1)
								SetObjectVisible(oggetti3D[i].targetFireID,0)
								playsound(getSoundByName("tank"),100,0)
							endif
						endcase	
						case CAT_FLYING
							oggetti3D[i].fireTimer=timer()
							ufoLaserLength=oggetti3D[i].y-getFloor(oggetti3D[i].x,oggetti3D[i].z,-1)
							oggetti3D[i].fireObjID=CreateObjectCylinder(ufoLaserLength,10,12)
							SetObjectCollisionMode(oggetti3D[i].fireObjID,0)
							SetObjectPosition(oggetti3D[i].fireObjID,oggetti3D[i].x,oggetti3D[i].y-ufoLaserLength/2,oggetti3D[i].z)
							SetObjectColorEmissive(oggetti3D[i].fireObjID,255,255,0)
							if (oggetti3D[i].targetFireID=0)
								oggetti3D[i].targetFireID=CreateObjectSphere(2,5,5)
								SetObjectPosition(oggetti3D[i].targetFireID,oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z)
								SetObjectCollisionMode(oggetti3D[i].targetFireID,1)
								SetObjectVisible(oggetti3D[i].targetFireID,0)
								playsound(getSoundByName("laser"),100,1)
							endif	
						endcase
					endselect		
					if (oggetti3D[i].animated=1)
						SetObjectAnimationSpeed(oggetti3D[i].ID,0)
						//SetObjectAnimationFrame(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),0,0)
					endif
				endif	
				if (oggetti3D[i].category=CAT_TANK)
					remstart
					print("")
					print("boneindex "+str(GetObjectBoneByName(oggetti3D[i].ID,oggetti3D[i].weaponBoneName)))
					print("boneX "+str(GetObjectWorldX(oggetti3D[i].ID)))
					print("boneY "+str(GetObjectWorldY(oggetti3D[i].ID)))
					print("boneZ "+str(GetObjectWorldZ(oggetti3D[i].ID)))
					print("angleboneX "+str(getWeaponBoneWorldAngle(oggetti3D[i],0)))
					print("angleboneY "+str(getWeaponBoneWorldAngle(oggetti3D[i],1)))
					print("angleboneZ "+str(getWeaponBoneWorldAngle(oggetti3D[i],2)))
					remend
					scale_fire=Random2(1,10)/10.0
					SetObjectScale(oggetti3D[i].fireObjID,scale_fire,scale_fire,scale_fire)
					boneX=GetObjectWorldX(oggetti3D[i].ID)
					boneY=GetObjectWorldY(oggetti3D[i].ID)+5
					boneZ=GetObjectWorldZ(oggetti3D[i].ID)
					if (oggetti3D[i].animated=1)
						boneAngleY=getWeaponBoneWorldAngle(oggetti3D[i],1)
						SetObjectPosition(oggetti3D[i].fireObjID,boneX-cos(boneAngleY+oggetti3D[i].flip*180)*(16+scale_fire),boneY+2.5,boneZ+sin(boneAngleY+oggetti3D[i].flip*180)*(16+scale_fire))
					else
						boneAngleY=oggetti3D[i].angle_y+90
						boneAngleX=oggetti3D[i].angle_x
						boneAngleZ=oggetti3D[i].angle_z
						SetObjectPosition(oggetti3D[i].fireObjID,boneX-cos(boneAngleY+oggetti3D[i].flip*180)*(32+scale_fire),boneY+2.5,boneZ+sin(boneAngleY+oggetti3D[i].flip*180)*(32+scale_fire))
					endif
					if (randomsign(1)=-1)
						SetObjectColor(oggetti3D[i].fireObjID,255,255,random2(128,255),random2(0,64))
					else
						SetObjectColor(oggetti3D[i].fireObjID,255,random2(0,128),random2(0,128),random2(0,64))	
					endif	
					checkBoneFireCollision(oggetti3D[i])
					if (timer()>(oggetti3D[i].fireTimer+oggetti3D[i].fireDuration))
						oggetti3D[i].status=STATUS_ACTIVE
						DeleteObject(oggetti3D[i].targetFireID)
						oggetti3D[i].targetFireID=0
						DeleteObject(oggetti3D[i].fireObjID)
						oggetti3D[i].fireObjID=0
						if (oggetti3D[i].animated=1) then SetObjectAnimationSpeed(oggetti3D[i].ID,oggetti3D[i].moveStep*150)
					endif	
				endif	
				if (oggetti3D[i].category=CAT_ENEMY)
					scale_fire=Random2(0,10)/10.0
					SetObjectScale(oggetti3D[i].fireObjID,scale_fire,scale_fire,scale_fire)
					boneX=getWeaponBoneWorldCoordinate(oggetti3D[i],0)
					boneY=getWeaponBoneWorldCoordinate(oggetti3D[i],1)
					boneZ=getWeaponBoneWorldCoordinate(oggetti3D[i],2)
					SetObjectPosition(oggetti3D[i].fireObjID,boneX+sin(oggetti3D[i].angle_y+oggetti3D[i].flip*180)*(3+scale_fire),boneY,boneZ+cos(oggetti3D[i].angle_y+oggetti3D[i].flip*180)*(3+scale_fire))
					if (randomsign(1)=-1)
						SetObjectColor(oggetti3D[i].fireObjID,255,255,random2(128,255),random2(0,64))
					else
						SetObjectColor(oggetti3D[i].fireObjID,255,random2(0,128),random2(0,128),random2(0,64))	
					endif	
					checkEnemyFireCollision(oggetti3D[i])
					if (timer()>(oggetti3D[i].fireTimer+oggetti3D[i].fireDuration))
						oggetti3D[i].status=STATUS_ACTIVE
						DeleteObject(oggetti3D[i].targetFireID)
						oggetti3D[i].targetFireID=0
						DeleteObject(oggetti3D[i].fireObjID)
						oggetti3D[i].fireObjID=0
						if (oggetti3D[i].animated=1) then SetObjectAnimationSpeed(oggetti3D[i].ID,oggetti3D[i].moveStep*150)
						StopSound(getSoundByName("ak47"))
						// PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),0,-1,1,0)
					endif	
				endif	
				if (oggetti3D[i].category=CAT_FLYING)
					checkEnemyVerticalFireCollision(oggetti3D[i])
					SetObjectColorEmissive(oggetti3D[i].fireObjID,255,255,random(0,255))
					if (timer()>(oggetti3D[i].fireTimer+oggetti3D[i].fireDuration))
						oggetti3D[i].status=STATUS_ACTIVE
						DeleteObject(oggetti3D[i].targetFireID)
						oggetti3D[i].targetFireID=0
						DeleteObject(oggetti3D[i].fireObjID)
						oggetti3D[i].fireObjID=0
						StopSound(getSoundByName("laser"))
						// PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),0,-1,1,0)
					endif	
				endif	
			endcase	
			case STATUS_FALLING
				if (isMultiPlayerLAN=0) or (isHostLAN=1) or ((oggetti3D[i].category<>CAT_ENEMY) and (oggetti3D[i].category<>CAT_TANK)) 
					if (oggetti3D[i].animFallingStart=oggetti3D[i].animFallingEnd)
						RotateObjectLocalX(oggetti3D[i].ID,-1)
						oggetti3D[i].angle_x=GetObjectAngleX(oggetti3D[i].ID)
						oggetti3D[i].angle_y=GetObjectAngleY(oggetti3D[i].ID)
						oggetti3D[i].angle_z=GetObjectAngleZ(oggetti3D[i].ID)
						if (abs(oggetti3D[i].angle_x)>88)
							oggetti3D[i].status=STATUS_ENDING
							if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
						endif
					else
						oggetti3D[i].y=oggetti3D[i].y-0.05
						positionObject3D(oggetti3D[i])
						if (GetObjectIsAnimating(oggetti3D[i].ID)=0)
							oggetti3D[i].status=STATUS_ENDING
							if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
						endif
					endif
				endif		
			endcase
			case STATUS_TANK_START_FALLING
				if (GetSoundsPlaying(getSoundByName("explosion"))=0)
					PlaySound(getSoundByName("explosion"),100,1)
				endif	
				if (isMultiPlayerLAN=0) or (isHostLAN=1)
					DeleteObjectWithChildren(oggetti3D[i].ID)
					oggetti3D[i].ID=LoadObjectWithChildren("tankexplode.ms3d")
					oggetti3D[i].y=oggetti3D[i].y+23
					positionObject3D(oggetti3D[i])
					PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),0,-1,0,0)
					SetObjectAnimationSpeed(oggetti3D[i].ID,16)
				endif		
				if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)	
				oggetti3D[i].status=STATUS_TANK_FALLING
			endcase
			case STATUS_TANK_FALLING
				if (isMultiPlayerLAN=0) or (isHostLAN=1)
					if (GetObjectIsAnimating(oggetti3D[i].ID)=0)
						oggetti3D[i].status=STATUS_ENDING
					endif	
				endif		
				if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
			endcase
			case STATUS_FLYING_FALLING
				if (GetSoundsPlaying(getSoundByName("explosion"))=0)
					PlaySound(getSoundByName("explosion"),100,1)
				endif	
				if (isMultiPlayerLAN=0) or (isHostLAN=1)
					if (oggetti3D[i].fireObjID=0)
						oggetti3D[i].fireObjID=CreateObjectSphere(20,12,12)
					endif
					SetObjectPosition(oggetti3D[i].fireObjID,oggetti3D[i].x+random(0,20)-10,oggetti3D[i].y+random(0,10)-5,oggetti3D[i].z+random(0,20)-10)
					SetObjectColorEmissive(oggetti3D[i].fireObjID,random(0,255),0,0)
					SetObjectColorEmissive(oggetti3D[i].ID,random(0,255),0,0)
					oggetti3D[i].y=oggetti3D[i].y-0.1
					rotateobject3D(oggetti3D[i],1,1,1)
					positionObject3D(oggetti3D[i])
					if (oggetti3D[i].y<=GetFloor(oggetti3D[i].x,oggetti3D[i].z,-1))
						DeleteObject(oggetti3D[i].fireObjID)
						stopLoopingSounds(0)
						oggetti3D[i].status=STATUS_ENDING
					endif	 
				endif	
				if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
			endcase
			case STATUS_ENDING
				deleteObjectInfo(oggetti3D[i])
				select oggetti3D[i].postENDING
				   case STATUS_HIDDEN
				      SetObjectVisible(oggetti3D[i].ID,0)
				      SetObjectCollisionMode(oggetti3D[i].ID,0)
				      //if (oggetti3D[i].animated=1) then DeleteObjectWithChildren(oggetti3D[i].ID)
				      oggetti3D[i].status=STATUS_HIDDEN
				      if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,i)
				   endcase
				endselect	  
			endcase 
			case STATUS_CHANGEROUTE
				if (isMultiPlayerLAN=0) or (isHostLAN=1) or (oggetti3D[i].category<>CAT_ENEMY)
					if (oggetti3D[i].turningFlag=0)
						normalFlag=checkNormal3D(i,5,2)
						select normalFlag
							case 0
								oggetti3D[i].newAngleY=wrapValue(oggetti3D[i].angle_y+RandomSign(random(30,60)))
								oggetti3D[i].turningFlag=1	
							endcase
							case 1
								oggetti3D[i].newAngleY=wrapValue(oggetti3D[i].angle_y+random(30,60))
								oggetti3D[i].turningFlag=1	
							endcase	
							case 2
								oggetti3D[i].newAngleY=wrapValue(oggetti3D[i].angle_y-random(30,60))
								oggetti3D[i].turningFlag=1	
							endcase	
							case 3
								oggetti3D[i].newAngleY=wrapValue(oggetti3D[i].angle_y+randomsign(random(60,120)))
								oggetti3D[i].turningFlag=1	
							endcase	
						endselect	
					endif	
					select oggetti3D[i].postCHANGEROUTE
					   case STATUS_ACTIVE
							oggetti3D[i].status=STATUS_ACTIVE
					   endcase
					endselect   			 
				endif   
			endcase 
			case STATUS_OBSTACLE
				if (isMultiPlayerLAN=0) or (isHostLAN=1) or (oggetti3D[i].category<>CAT_ENEMY)
			      select oggetti3D[i].postOBSTACLE
					   case STATUS_CHANGEROUTE
						  oggetti3D[i].status=STATUS_CHANGEROUTE	 
					   endcase     
					   case STATUS_ENDING
						  oggetti3D[i].status=STATUS_ENDING	 
					   endcase     
					   case default
						  oggetti3D[i].status=STATUS_IDLE
					   endcase	  	
				   endselect	  
				else
					oggetti3D[i].status=STATUS_ACTIVE
				endif	   
			endcase 
			case STATUS_IDLE
				select oggetti3D[i].category
					case CAT_PICKUP
						rotateObject3D(oggetti3D[i],0,1,0)
					endcase
					case CAT_PLAYER
						if (isMultiPlayerLAN=1) and (mod(frameCounter,3)=0)
						   processNetworkFPSMessage(networkID, i)	   
						endif   
					endcase	
				endselect		
			endcase 
			case STATUS_WEAPON_FIRE
				if (i=weapon_index)
					if (oggetti3D[i].angle_x<1)
						oggetti3D[i].angle_x=0
						rem positionObject3D(oggetti3D[i])
					else
						RotateObjectLocalX(oggetti3D[i].ID,-3)
					endif		
					updatePosRot3D(oggetti3D[i])
					oggetti3D[weapon_index].y=oggetti3D[fps_index].y+1	
	                weapon_radius=3-3*(oggetti3D[weapon_index].angle_x/oggetti3D[weapon_index].angle_x_fire)
	                rem print("weapon_radius "+str(weapon_radius))
	                oggetti3D[weapon_index].z=oggetti3D[fps_index].z+weapon_radius*sin(oggetti3D[fps_index].angle_y)
	                oggetti3D[weapon_index].x=oggetti3D[fps_index].x-weapon_radius*cos(oggetti3D[fps_index].angle_y)
	                if ((sign(angle_y_fire)>0) and (angle_y_fire>0)) or ((sign(angle_y_fire)<0) and (angle_y_fire<0))
						oggetti3D[weapon_index].angle_y=oggetti3D[weapon_index].angle_y-sign(oggetti3D[weapon_index].angle_y_fire)
						angle_y_fire=angle_y_fire-sign(oggetti3D[weapon_index].angle_y_fire)
					else
						angle_y_fire=0
					endif	
					if weapon_radius>=3 
						oggetti3D[weapon_index].status=STATUS_IDLE
					endif	
				endif		
			endcase  	
		endselect
		if (isMultiPlayerLAN=0) or (isHostLAN=1) or ((oggetti3D[i].category<>CAT_ENEMY) and (oggetti3D[i].category<>CAT_TANK) and (oggetti3D[i].category<>CAT_FLYING)) 
			x=GetObjectX(oggetti3D[i].ID)
			y=GetObjectY(oggetti3D[i].ID)
			z=GetObjectZ(oggetti3D[i].ID)
			if (x>WORLD_LIMIT_X)
				updateObjFlag=1
				x=WORLD_LIMIT_X-abs(oggetti3D[i].moveStep)*3
				oggetti3D[i].turningFlag=0
			elseif (x<-WORLD_LIMIT_X)
				updateObjFlag=1
				x=-WORLD_LIMIT_X+abs(oggetti3D[i].moveStep)*3
				oggetti3D[i].turningFlag=0
			endif 
			if (y>WORLD_LIMIT_Y)
				updateObjFlag=1
				y=WORLD_LIMIT_Y-abs(oggetti3D[i].moveStep)*3
			elseif (y<-WORLD_LIMIT_Y)
				updateObjFlag=1
				y=-WORLD_LIMIT_Y+abs(oggetti3D[i].moveStep)*3
			endif
			if (z>WORLD_LIMIT_Z)
				updateObjFlag=1
				z=WORLD_LIMIT_Z-abs(oggetti3D[i].moveStep)*3
				oggetti3D[i].turningFlag=0
			elseif (z<-WORLD_LIMIT_Z)
				updateObjFlag=1
				z=-WORLD_LIMIT_Z+abs(oggetti3D[i].moveStep)*3
				oggetti3D[i].turningFlag=0
			endif
			if (updateObjFlag=1) 
				SetObjectPosition(oggetti3D[i].ID,x,y,z)
				updatePosRot3D(oggetti3D[i])
				oggetti3D[i].status=STATUS_OBSTACLE
			endif	
		endif	
	next
	if (isMultiPlayerLAN=1) and (isHostLAN=1) and (mod(frameCounter,3)=0) 
		for i=0 to oggetti3D.length
			if (oggetti3D[i].category=CAT_ENEMY) or (oggetti3D[i].category=CAT_TANK) or (oggetti3D[i].category=CAT_FLYING) then sendNetworkEnemyPosition(networkID,i)
			if (oggetti3D[i].category=CAT_LIFT) then sendNetworkLiftPosition(networkID,i)
		next i
	endif	
endfunction		

// axis=0 (X), 1 (Y), 2 (Z)
function getWeaponBoneWorldCoordinate(obj3D as Oggetto3D, axis as integer)
	boneIndex as integer
	boneCoordinate as float
	if (obj3D.animated=0)
		select axis
			case 0
				boneCoordinate=GetObjectWorldX(obj3D.ID)
			endcase
			case 1
				boneCoordinate=GetObjectWorldY(obj3D.ID)
			endcase
			case 2
				boneCoordinate=GetObjectWorldZ(obj3D.ID)
			endcase	
		endselect
		exitfunction boneCoordinate
	endif	
	boneIndex=GetObjectBoneByName(obj3D.ID,obj3D.weaponBoneName)
	select axis
		case 0
			boneCoordinate=GetObjectBoneWorldX(obj3D.ID,boneIndex)
		endcase
		case 1
			boneCoordinate=GetObjectBoneWorldY(obj3D.ID,boneIndex)
		endcase
		case 2
			boneCoordinate=GetObjectBoneWorldZ(obj3D.ID,boneIndex)
		endcase	
	endselect
endfunction boneCoordinate	

// angle=0 (X), 1 (Y), 2 (Z)
function getWeaponBoneWorldAngle(obj3D as Oggetto3D, ang as integer)
	boneIndex as integer
	boneAngle as float
	if (obj3D.animated=0)
		boneAngle=obj3D.angle_y
		exitfunction boneAngle
	endif	
	boneIndex=GetObjectBoneByName(obj3D.ID,obj3D.weaponBoneName)
	select ang
		case 0
			boneAngle=GetObjectBoneWorldAngleX(obj3D.ID,boneIndex)
		endcase
		case 1
			boneAngle=GetObjectBoneWorldAngleY(obj3D.ID,boneIndex)
		endcase
		case 2
			boneAngle=GetObjectBoneWorldAngleZ(obj3D.ID,boneIndex)
		endcase	
	endselect
endfunction boneAngle	

function checkRayCollision(objID as integer, fromPos as Vector3D,toPos as Vector3D)
	hitObjID as integer
	hitObjID=ObjectRayCast(objID,fromPos.x, fromPos.y,fromPos.z, toPos.x,toPos.y,toPos.z)
endfunction hitObjID	

function checkSphereCollision(objID as integer, fromPos as Vector3D,toPos as Vector3D, ray as Float)
	hitObjID as integer
	hitObjID=ObjectSphereCast(objID,fromPos.x, fromPos.y,fromPos.z, toPos.x,toPos.y,toPos.z,ray)
endfunction hitObjID

function checkSlideCollision(objID as integer, fromPos as Vector3D,toPos as Vector3D, ray as Float)
	hitObjID as integer
	hitObjID=ObjectSphereSlide(objID,fromPos.x, fromPos.y,fromPos.z, toPos.x,toPos.y,toPos.z,ray)
endfunction hitObjID	

function getAltitude(x as float, z as float)
	altitude as float
	index_x as float
	index_z as float
	idx_x as integer
	idx_z as integer
	index_x=x+WORLD_LIMIT_X
	index_z=z+WORLD_LIMIT_Z
	if (index_x<0) 
		index_x=0
	elseif (index_x>(TERRAIN_SIZE_X-5))
		index_x=TERRAIN_SIZE_X-5
	endif	
	if (index_z<0) 
		index_z=0
	elseif (index_z>(TERRAIN_SIZE_Z-5))
		index_z=TERRAIN_SIZE_Z-5
	endif	
	if (terrainAGK_index=-1)
		idx_x=trunc(index_x/10.0+0.5)+1
		idx_z=trunc(index_z/10.0+0.5)+1
		altitude=altitudeMap[idx_x,idx_z]*5
		//print("x "+str(x)+" z "+str(z))
		//print("index x "+str(index_x)+" index_z "+str(index_z))
		
		//print("idx x "+str(idx_x)+" idx_z "+str(idx_z))
		//print("terrain map "+str(copyTerrainMap[idx_x,idx_z]))
		if (altitude>0) then altitude=altitude+5+copyTerrainMap[idx_x,idx_z]*5
	else	
		altitude=0
	endif	
endfunction altitude	

function getFloor(x as float, z as float, i as integer)
	floorY as float
	index_x as integer
	index_z as integer
	altitude as float
	index_x=x+WORLD_LIMIT_X
	index_z=z+WORLD_LIMIT_Z
	if (index_x<0) 
		index_x=0
	elseif (index_x>(TERRAIN_SIZE_X-5))
		index_x=TERRAIN_SIZE_X-5
	endif	
	if (index_z<0) 
		index_z=0
	elseif (index_z>(TERRAIN_SIZE_Z-5))
		index_z=TERRAIN_SIZE_Z-5
	endif	
	if (i>=0) and (terrainAGK_index=-1)
		altitude=getAltitude(x,z)
		if (oggetti3D[i].y>=altitude) and (altitude>0)
			exitfunction altitude
		endif
	endif		 
	if (terrainAGK_index=-1)
		floorY=terrain3D[index_x+5,index_z+5]
	else	
		floorY=max2(terrain3D[index_x+5,index_z+5],GetObjectHeightMapHeight(oggetti3D[terrainAGK_index].ID,x,z))
	endif	
endfunction floorY	

function checkObjectsCollision()
	i as integer
	alpha as integer
	forward_hit_index as integer
	back_hit_index as integer
	back_low_hit_index as integer
	floor_hit_index as integer
	forward_short_hit_index as integer
	forward_low_hit_index as integer
	top_hit_index as integer
	for i=1 to oggetti3D.length
		if (oggetti3D[i].status=STATUS_BOMB_EXPLOSION) or (oggetti3D[i].status=STATUS_ACTIVE) or (oggetti3D[i].status=STATUS_IDLE) or (oggetti3D[i].status=STATUS_OBSTACLE) or (oggetti3D[i].status=STATUS_CLIMBING)
			select oggetti3D[i].category
				case CAT_ENEMY, CAT_TANK, CAT_FLYING	
					remstart
					if (terrainAGK_index<>-1)
						oggetti3D[i].y=getfloor(oggetti3D[i].x,oggetti3D[i].z)-oggetti3D[i].base_y+oggetti3D[i].altitude
						positionObject3D(oggetti3D[i])
					endif	
					remend
					floor_hit_index=checkFloorCollision(oggetti3D[i],0)	
					oggetti3D[i].onObject=floor_hit_index	
					remstart
					if (i=8) 
						print("onobject "+str(oggetti3D[i].onObject))
						print("near_floor_hit_index "+str(near_floor_hit_index))
					endif	
					remend
					checkEnemyCollision(oggetti3D[i])
					if (oggetti3D[i].category<>CAT_FLYING) and (checkDown3D(i,2,0)=0) and (oggetti3D[i].turningFlag=0)
						oggetti3D[i].newAngleY=wrapValue(oggetti3D[i].angle_y+180)
						oggetti3D[i].turningFlag=1
					endif	
				endcase
				case CAT_BULLET
					if (inventory[selected_inventory_index].category=CAT_INV_BOMB)
						checkBombCollision(oggetti3D[i])
					else	
						checkBulletCollision(oggetti3D[i])
					endif	
				endcase
				case CAT_GHOST
					forward_hit_index=checkFPSCollision(oggetti3D[i],0,1.5,4)
					forward_low_hit_index=checkFPSCollision(oggetti3D[i],0,1.5,1)
					back_hit_index=checkFPSCollision(oggetti3D[i],1,2,4)
					back_low_hit_index=checkFPSCollision(oggetti3D[i],1,2,1)
					floor_hit_index=checkFloorCollision(oggetti3D[i],0)	
					top_hit_index=checkFloorCollision(oggetti3D[i],1)
					if (floor_hit_index>=0)		
					    hitFloor=1
					    oggetti3D[i].onObject=floor_hit_index	
					else
					   hitFloor=0
					endif
					if (top_hit_index>=0)		
					    hitTop=1
					else
					   hitTop=0
					endif
					if (forward_low_hit_index>=0) 
						hitWallFrontLow=1
					else
						hitWallFrontLow=0
					endif		
					if (forward_hit_index>=0)
						hitWallFront=1
						hitWallBack=0
						manageFPSCollision(oggetti3D[forward_hit_index])
						if (oggetti3D[forward_hit_index].category=CAT_VERTICAL_STAIRS) and (oggetti3D[i].status=STATUS_IDLE)
							oggetti3D[i].status=STATUS_CLIMBING
							oggetti3D[i].y=oggetti3D[i].y+0.1
							fallCounter=0
						endif	  			
					elseif (back_hit_index>=0)
						hitWallBack=1
						hitWallFront=0
						manageFPSCollision(oggetti3D[back_hit_index])	  	
					else
						hitWallFront=0
						hitWallBack=0
						if (oggetti3D[i].status=STATUS_CLIMBING)
							oggetti3D[i].status=STATUS_IDLE
							oggetti3D[i].y=oggetti3D[i].y+oggetti3D[i].height
							positionObject3D(oggetti3D[i])
							moveZObject3D(oggetti3D[i],1)
							hitFloor=0
	                 	endif	
					endif		
					//print("")
					//print("hitWallFront "+str(hitWallFront)+" hitWallBack "+str(hitWallBack))
					//print("hitwallfrontlow "+str(hitWallFrontLow))
					//print("floor_hit_index "+str(floor_hit_index))
					//print("top_hit_index "+str(top_hit_index))				 
					if  (hitWallFrontLow=1) and  (move_fwd_flag=1) and (oggetti3D[i].onObject<>-1)
						if (oggetti3D[oggetti3D[i].onObject].category=CAT_STAIRS)
							oggetti3D[i].y=oggetti3D[i].y+oggetti3D[oggetti3D[i].onObject].riser
							positionObject3D(oggetti3D[i])
						endif
					elseif (hitWallFront=0) and (hitWallFrontLow=1) and (move_fwd_flag=1) and (oggetti3D[i].onObject=-1)
						if (oggetti3D[forward_low_hit_index].category=CAT_STAIRS) 
							oggetti3D[i].y=oggetti3D[i].y+oggetti3D[forward_low_hit_index].riser
							positionObject3D(oggetti3D[i])
						endif	
					endif	
					if (hitFloor=0) and (oggetti3D[i].onObject<>-1)
						oggetti3D[i].onObject=-1
					endif		
					if (GetSpriteExists(hitScreenSprite)=1) 
		               alpha=GetSpriteColorAlpha(hitScreenSprite)
		               if (alpha>0) 
			              dec alpha
		                  SetSpriteColorAlpha(hitScreenSprite,alpha)
		               else
			              deleteSprite(hitScreenSprite)
		               endif
	                endif		
				endcase
			endselect
		endif	
    next
endfunction

function hitPlayer(energyLost as integer)
   if (shieldPower>0)
	   dec shieldPower
	   SetObjectColor(oggetti3D[fps_index].shieldID,255,255,0,shieldPower)
	   if (shieldPower<=0)
		   DeleteObject(oggetti3D[fps_index].shieldID)
		   oggetti3D[fps_index].shieldID=0
		   if (GetSpriteExists(hitScreenSprite)=1) then SetSpriteImage(hitScreenSprite,hitScreenImage)
	   endif	   
   else	   
       inventory[life_inventory_index].ammo=inventory[life_inventory_index].ammo-energyLost
   endif    
   if (inventory[life_inventory_index].ammo<=0)
	   inventory[life_inventory_index].ammo=0
	   oggetti3D[fps_index].status=STATUS_FPS_DYING	
   elseif (GetSpriteExists(hitScreenSprite)=0)
	   if (shieldPower>0)
			hitScreenSprite=CreateSprite(hitShieldScreenImage)
	   else		
		    hitScreenSprite=CreateSprite(hitScreenImage)
	   endif 	    
  	   SetSpritePosition(hitScreenSprite,0,0)
   else
	   SetSpriteColorAlpha(hitScreenSprite,128)
   endif	
endfunction	

function manageFPSCollision(hitObj ref as Oggetto3D)
	alpha as integer
	hitObjIndex as integer
	weapon_inventory_index as integer
	medikit_inventory_index as integer
	key_inventory_index as integer
	hitObjIndex=findObjectByID(oggetti3D,hitObj.ID)
	select hitObj.category
		case CAT_VERTICAL_DOORS
			if (hitObj.status=STATUS_CLOSED)
				hitObj.status=STATUS_OPENING
			elseif (hitObj.status=STATUS_OPEN)
				hitObj.status=STATUS_CLOSING
			elseif (hitObj.status=STATUS_LOCKED)
				key_inventory_index=findInventoryByName(inventory,hitObj.openWithKey)
				if (key_inventory_index<>-1)
					if (inventory[key_inventory_index].ammo>0) and (inventory[key_inventory_index].available=1) 
						hitObj.status=STATUS_OPENING
					endif	
				endif
			endif	
			if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)		
		endcase		
		case CAT_ENEMY
			if (hitObj.status=STATUS_ACTIVE) or (hitObj.status=STATUS_FIRING)
				hitPlayer(hitObj.damage)
				oggetti3D[hitObjIndex].hittingPlayer=1
				manageSound(getSoundByName("zombie"))
			endif	
		endcase
		case CAT_TANK
			if (hitObj.status=STATUS_ACTIVE) or (hitObj.status=STATUS_FIRING)
				hitPlayer(hitObj.damage)
				oggetti3D[hitObjIndex].hittingPlayer=1
			endif	
		endcase
		case CAT_PICKUP
			if (hitObj.inventory<>"")
				if (hitObj.inventory="shield")
					shieldPower=hitObj.energy
					oggetti3D[fps_index].shieldID=CreateObjectSphere(10,20,20)
					SetObjectPosition(oggetti3D[fps_index].shieldID,oggetti3D[hand_index].x,oggetti3D[hand_index].y,oggetti3D[hand_index].z)
					SetObjectColor(oggetti3D[fps_index].shieldID,255,255,0,shieldPower)
					SetObjectTransparency(oggetti3D[fps_index].shieldID,1)
					SetObjectCollisionMode(oggetti3D[fps_index].shieldID,0)
					rem SetObjectImage(oggetti3D[fps_index].shieldID,shieldImage,0)
					hitObj.status=STATUS_ENDING	
					if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
				elseif (hitObj.inventory="medikit")
					if (hitObj.energy<>0)
						medikit_inventory_index=findInventoryByName(inventory,hitObj.inventory)
						if (medikit_inventory_index<>-1)
							inventory[medikit_inventory_index].ammo=inventory[medikit_inventory_index].ammo+hitObj.energy
							setSpriteColor(inventory[medikit_inventory_index].spriteID,255,0,0,255)
							hitObj.status=STATUS_ENDING
							if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
						endif	
					endif
				elseif (left(hitObj.inventory,3)="key")
					key_inventory_index=findInventoryByName(inventory,hitObj.inventory)
					if (key_inventory_index<>-1)
						if (inventory[key_inventory_index].available=0)
							inventory[key_inventory_index].ammo=1
							inventory[key_inventory_index].available=1
							if (GetSpriteExists(inventory[key_inventory_index].spriteID)=1)
								setSpriteColor(inventory[key_inventory_index].spriteID,255,255,0,255)
							endif	
							hitObj.status=STATUS_ENDING	
							if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
						endif
					endif	
				else	
					weapon_inventory_index=findInventoryByName(inventory,hitObj.inventory)
					if (weapon_inventory_index<>-1)
						if (inventory[weapon_inventory_index].available=0)
							inventory[weapon_inventory_index].available=1
							deleteInventory3D(0)
							hitObj.status=STATUS_ENDING
							if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
							if (hitObj.energy<>0)
								inventory[weapon_inventory_index].ammo=inventory[weapon_inventory_index].ammo+hitObj.energy
							endif
						endif	
					endif	
				endif
			else		
				if (hitObj.points<>0) then	score=score+hitObj.points
				if 	(hitObj.bullets<>0) and (hitObj.chargeWeapon<>"")
					weapon_inventory_index=findInventoryByName(inventory,hitObj.chargeWeapon)
					if (weapon_inventory_index<>-1) 
						inventory[weapon_inventory_index].ammo=inventory[weapon_inventory_index].ammo+hitObj.bullets
					endif
				endif   	   
				hitObj.status=STATUS_ENDING
				if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
			endif	
		endcase	
		case CAT_BLOCK,CAT_STAIRS,CAT_VERTICAL_STAIRS, CAT_LIFT
			jumping_flag=0
		endcase
	endselect    
	oggetti3D[fps_index].x=GetObjectRayCastSlideX(0)
	oggetti3D[fps_index].y=GetObjectRayCastSlideY(0)
	oggetti3D[fps_index].z=GetObjectRayCastSlideZ(0)
	updatePosRot3D(oggetti3D[fps_index])
endfunction

function checkEnemyCollision(enemyObj ref as Oggetto3D)
	i as integer
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	angleOffset as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	angleOffset=0
	if (enemyObj.flip=1) then angleOffset=180 
	//startCheckPos.y=getFloor(enemyObj.x,enemyObj.z)+1
	startCheckPos.z=enemyObj.z+cos(enemyObj.angle_y-angleOffset)*2
	startCheckPos.y=enemyObj.y+2
	endCheckPos.x=startCheckPos.x+sin(enemyObj.angle_y-angleOffset)*5
	//endCheckPos.y=enemyObj.y
	//endCheckPos.y=1
	endCheckPos.z=startCheckPos.z+cos(enemyObj.angle_y-angleOffset)*5
	endCheckPos.y=startCheckPos.y
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,1)
	if (hitObjID<>0) 
		hitObjIndex=findObjectByID(oggetti3D,hitObjID)
		if (hitObjIndex<>-1) and (enemyObj.collisionFlag=0)
			raycast_cat=oggetti3D[hitObjIndex].category
			if (enemyObj.ID=oggetti3D[hitObjIndex].ID) then exitfunction 0
			if (raycast_cat=CAT_BLOCK) or (raycast_cat=CAT_SKY) or (raycast_cat=CAT_STAIRS) or (raycast_cat=CAT_VERTICAL_STAIRS) or (raycast_cat=CAT_BULLET) or (raycast_cat=CAT_TANK) or (raycast_cat=CAT_ENEMY)
				// print_debug("enemy "+str(sy)+" "+str(enemyobj.ID)+"coll hitID "+str(hitObjID))
				enemyObj.collisionFlag=hitObjID
				enemyObj.status=STATUS_OBSTACLE
				enemyObj.x=GetObjectRayCastSlideX(0)
				enemyObj.y=GetObjectRayCastSlideY(0)
				enemyObj.z=GetObjectRayCastSlideZ(0)
				updatePosRot3D(enemyObj)
				exitfunction 1
			endif	
		endif	
	else
		enemyObj.collisionFlag=0
	endif				
endfunction	0

function checkEnemyVerticalFireCollision(enemyObj ref as Oggetto3D)
	i as integer
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	targetID as integer
	angleOffset as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	angleOffset=0
	if (enemyObj.flip=1) then angleOffset=180 
	startCheckPos.x=enemyObj.x
	startCheckPos.y=enemyObj.y-enemyObj.height
	startCheckPos.z=enemyObj.z
	endCheckPos.x=startCheckPos.x
	endCheckPos.y=getFloor(enemyObj.x,enemyObj.z,-1)
	endCheckPos.z=startCheckPos.z
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	rem DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,10)
	remstart
	print("")
	print("checkenemyfirecollision hitObjID "+str(hitObjID))
	print("targetFireID "+str(enemyObj.targetFireID))
	remend
	if (hitObjID<>0)
		if (hitObjID=enemyObj.targetFireID)
			print("hitplayer")
			hitPlayer(enemyObj.fireDamage)
		else	
			hitObjIndex=findObjectByID(oggetti3D,hitObjID)
			if (hitObjIndex<>-1)
				raycast_cat=oggetti3D[hitObjIndex].category
				if (raycast_cat=CAT_PLAYER) and (isMultiPlayerLAN=1)
					updateHitMultiPlayer(hitObjIndex,enemyObj.fireDamage)
				endif	
			endif	
		endif	
	else
		enemyObj.collisionFlag=0
	endif				
endfunction	0

function checkEnemyFireCollision(enemyObj ref as Oggetto3D)
	i as integer
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	targetID as integer
	angleOffset as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	angleOffset=0
	if (enemyObj.flip=1) then angleOffset=180 
	startCheckPos.x=getWeaponBoneWorldCoordinate(enemyObj,0)
	startCheckPos.y=oggetti3D[fps_index].y
	startCheckPos.z=getWeaponBoneWorldCoordinate(enemyObj,2)
	endCheckPos.x=startCheckPos.x+sin(enemyObj.angle_y-angleOffset)*100
	endCheckPos.y=startCheckPos.y
	endCheckPos.z=startCheckPos.z+cos(enemyObj.angle_y-angleOffset)*100
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,2)
	remstart
	print("")
	print("checkenemyfirecollision hitObjID "+str(hitObjID))
	print("targetFireID "+str(enemyObj.targetFireID))
	remend
	if (hitObjID<>0)
		if (hitObjID=enemyObj.targetFireID)
			//print("hitplayer")
			hitPlayer(enemyObj.fireDamage)
		else	
			hitObjIndex=findObjectByID(oggetti3D,hitObjID)
			if (hitObjIndex<>-1)
				raycast_cat=oggetti3D[hitObjIndex].category
				if (raycast_cat=CAT_PLAYER) and (isMultiPlayerLAN=1)
					updateHitMultiPlayer(hitObjIndex,enemyObj.fireDamage)
				endif	
			endif	
		endif	
	else
		enemyObj.collisionFlag=0
	endif				
endfunction	0

function checkBoneFireCollision(parentObj ref as Oggetto3D)
	i as integer
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	boneAngleY as float
	boneIndex as integer
	targetID as integer
	angleOffset as float
	angleBoneCorrection as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	raycast_cat as integer
	angleOffset=0
	angleBoneCorrection=0
	if (parentObj.flip=1) then angleOffset=180 
	boneAngleY=getWeaponBoneWorldAngle(parentObj,1)
	if (parentObj.animated=1) then angleBoneCorrection=-90
	startCheckPos.x=GetObjectWorldX(parentObj.ID)+sin(boneAngleY-angleOffset+angleBoneCorrection)*20
	startCheckPos.y=oggetti3D[fps_index].y
	startCheckPos.z=GetObjectWorldZ(parentObj.ID)+cos(boneAngleY-angleOffset+angleBoneCorrection)*20
	endCheckPos.x=startCheckPos.x+sin(boneAngleY-angleOffset+angleBoneCorrection)*150
	endCheckPos.y=startCheckPos.y
	endCheckPos.z=startCheckPos.z+cos(boneAngleY-angleOffset+angleBoneCorrection)*150
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,5)
	//print_debug("")
	//print_debug("checkenemyfirecollision hitObjID "+str(hitObjID))
	//print_debug("targetFireID "+str(parentObj.targetFireID))
	//print_debug("s "+str(sx)+" "+str(sz)+" e "+str(ex)+" "+str(ez)+" "+str(boneAngleY-angleOffset+angleBoneCorrection)+" "+str(sin(boneAngleY-angleOffset+angleBoneCorrection)))
	if (hitObjID<>0)
		if (hitObjID=parentObj.targetFireID)
			//print("hitplayer")
			hitPlayer(parentObj.fireDamage)
		else	
			hitObjIndex=findObjectByID(oggetti3D,hitObjID)
			if (hitObjIndex<>-1)
				raycast_cat=oggetti3D[hitObjIndex].category
				if (raycast_cat=CAT_PLAYER) and (isMultiPlayerLAN=1)
					updateHitMultiPlayer(hitObjIndex,parentObj.fireDamage)
				endif	
			endif	
		endif	
	else
		parentObj.collisionFlag=0
	endif				
endfunction	0



function hitMultiPlayer(hitObjIndex as integer)
	rx as integer
	ry as integer
	SetRenderToImage(oggetti3D[hitObjIndex].textureID,0)
	rx=random(32,64)
	ry=random(32,64)
	DrawEllipse(Random(rx/2,2048-rx/2),Random(ry/2,1024-ry/2),rx,ry,MakeColor(random(0,128),0,0),MakeColor(random(128,255),0,0),1)
	SetRenderToScreen()
endfunction
	
function hitEnemy(hitObjIndex as integer)
	rx as integer
	ry as integer
	select oggetti3D[hitObjIndex].category
		case CAT_ENEMY
			SetRenderToImage(oggetti3D[hitObjIndex].textureID,0)
			rx=random(128,256)
			ry=random(128,256)
			DrawEllipse(Random(rx/2,2048-rx/2),Random(ry/2,1024-ry/2),rx,ry,MakeColor(random(0,128),0,0),MakeColor(random(128,255),0,0),1)
			SetRenderToScreen()
		endcase
		case CAT_TANK
		endcase
		case CAT_FLYING
		endcase
	endselect	
	if (GetSpriteExists(oggetti3D[hitObjIndex].energySpriteID)=1) 
		SetSpriteSize(oggetti3D[hitObjIndex].energySpriteID,oggetti3D[hitObjIndex].energy,16)
	endif
	if (oggetti3D[hitObjIndex].energy<=0) then deleteObjectInfo(oggetti3D[hitObjIndex])		
endfunction

function updateHitEnemy(hitObjIndex as integer, energyLost as integer) 
	if (oggetti3D[hitObjIndex].energy<0) then exitfunction
	oggetti3D[hitObjIndex].energy=oggetti3D[hitObjIndex].energy-energyLost
	if (isMultiPlayerLAN=1) then sendNetworkFPSEnemyEnergy(networkID,hitObjIndex)
	if (oggetti3D[hitObjIndex].energy>0) 
		score=score+100
	else
		oggetti3D[hitObjIndex].energy=0	
		if (oggetti3D[hitObjIndex].category=CAT_ENEMY)
			oggetti3D[hitObjIndex].status=STATUS_FALLING
			manageSound(getSoundByName("zombie"))
			score=score+100	
			//oggetti3D[hitObjIndex].y=getFloor(oggetti3D[hitObjIndex].x,oggetti3D[hitObjIndex].z)
			//positionObject3D(oggetti3D[hitObjIndex])
			if (oggetti3D[hitObjIndex].animated=1) 
				if (oggetti3D[hitObjIndex].animFallingStart<>oggetti3D[hitObjIndex].animFallingEnd)
					SetObjectAnimationSpeed(oggetti3D[hitObjIndex].ID,20)
					PlayObjectAnimation(oggetti3D[hitObjIndex].ID,GetObjectAnimationName(oggetti3D[hitObjIndex].ID,1),oggetti3D[hitObjIndex].animFallingStart,oggetti3D[hitObjIndex].animFallingEnd,0,0)
				else
					SetObjectAnimationSpeed(oggetti3D[hitObjIndex].ID,0)
				endif	
			endif
		elseif 	(oggetti3D[hitObjIndex].category=CAT_TANK)
			oggetti3D[hitObjIndex].status=STATUS_TANK_START_FALLING
		elseif 	(oggetti3D[hitObjIndex].category=CAT_FLYING)
			oggetti3D[hitObjIndex].status=STATUS_FLYING_FALLING
		endif
		if (isMultiPlayerLAN=1) then sendNetworkFPSUpdateStatus(networkID,hitObjIndex)
	endif    
	hitEnemy(hitObjIndex)
endfunction	

function updateHitMultiPlayer(hitObjIndex as integer,energyLost as integer)
    if (isMultiPlayerLAN=1) 
    	sendNetworkFPSPlayerHit(networkID,energyLost)
		hitMultiPlayer(hitObjIndex)
		score=score+10
	endif	
endfunction	

function createExplosion(hitObjIndex as integer)
	if (oggetti3D[hitObjIndex].explosionObjID<>0)
		DeleteObjectWithChildren(oggetti3D[hitObjIndex].explosionObjID)
	endif	
	SetFolder(OBJECTS_FOLDER)
	oggetti3D[hitObjIndex].explosionObjID=LoadObjectWithChildren("explosion.ms3d")
	SetObjectColor(oggetti3D[hitObjIndex].explosionObjID,255,0,0,255)
	SetObjectColorEmissive(oggetti3D[hitObjIndex].explosionObjID,128,128,0)
	SetObjectPosition(oggetti3D[hitObjIndex].explosionObjID,oggetti3D[hitObjIndex].x,oggetti3D[hitObjIndex].y+5,oggetti3D[hitObjIndex].z)
	SetObjectAnimationSpeed(oggetti3D[hitObjIndex].explosionObjID,30)
	PlayObjectAnimation(oggetti3D[hitObjIndex].explosionObjID,GetObjectAnimationName(oggetti3D[hitObjIndex].explosionObjID,1),0,-1,0,0)		
endfunction

function checkBulletCollision(bulletObj ref as Oggetto3D)
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float 
	hitObjID as integer
	hitObjIndex as integer
	endBulletPos as Vector3D
	rem if (bulletObj.status<>STATUS_ACTIVE) or (bulletObj.y>oggetti3D[fps_index].y) then exitfunction
	if (bulletObj.status<>STATUS_ACTIVE) then exitfunction
	endBulletPos.y=bulletObj.y
	endBulletPos.x=bulletObj.x
	endBulletPos.z=bulletObj.z
	sx=startBulletPos.x
	sy=startBulletPos.y
	sz=startBulletPos.z
	ex=endBulletPos.x
	ey=endBulletPos.y
	ez=endBulletPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkSphereCollision(0,startBulletPos,endBulletPos,0.2)
	//print("")
	//print("weapon bullet"+bulletObj.weapon)
	//print("weapon fps "+oggetti3D[fps_index].weapon)
	//print("BULLET sy "+str(sy)+"BULLET ey "+str(ey)
	//print("BULLET sx "+str(sx)+"BULLET ex "+str(ex))
	//print("BULLET sz "+str(sz)+"BULLET ez "+str(ez))
	//print("hitObjID "+str(hitObjID))
	if (hitObjID<>0) 
		hitObjIndex=findObjectByID(oggetti3D,hitObjID)
		if (hitObjIndex=-1)
			exitfunction
		endif
		if (oggetti3D[hitObjIndex].category=CAT_ENEMY) and (oggetti3D[hitObjIndex].status=STATUS_ACTIVE)
			if (bulletObj.weapon="bazooka")
				updateHitEnemy(hitObjIndex,oggetti3D[hitObjIndex].energy)
			else	
				updateHitEnemy(hitObjIndex,10)
			endif	
			bulletObj.status=STATUS_ENDING
			inc numHitTargets  
		elseif (oggetti3D[hitObjIndex].category=CAT_TANK) and (oggetti3D[hitObjIndex].status=STATUS_ACTIVE)
			if (bulletObj.weapon="bazooka")
				PlaySound(getSoundByName("explosion"))
				createExplosion(hitObjIndex)
				updateHitEnemy(hitObjIndex,10)
			else				
				updateHitEnemy(hitObjIndex,1)
			endif	
			bulletObj.status=STATUS_ENDING
			inc numHitTargets  	 
		elseif (oggetti3D[hitObjIndex].category=CAT_FLYING) and (oggetti3D[hitObjIndex].status=STATUS_ACTIVE)
			if (bulletObj.weapon="bazooka")
				PlaySound(getSoundByName("explosion"))
				createExplosion(hitObjIndex)
				updateHitEnemy(hitObjIndex,10)
			else				
				updateHitEnemy(hitObjIndex,1)
			endif	
			bulletObj.status=STATUS_ENDING
			inc numHitTargets  	 	
		elseif (isMultiPlayerLAN=1) and (oggetti3D[hitObjIndex].category=CAT_PLAYER) and (oggetti3D[hitObjIndex].status=STATUS_IDLE) and (VSMode=1)
			updateHitMultiPlayer(hitObjIndex,10)
			bulletObj.status=STATUS_ENDING
			inc numHitTargets
		else
			bulletObj.status=STATUS_ENDING
		endif		   
	endif	
	rem print("raycast "+str(hitObjID))
endfunction	

function deleteObjectInfo(obj3D as Oggetto3D)
	if (GetSpriteExists(obj3D.energySpriteID)=1)
		deleteSprite(obj3D.energySpriteID)
	endif
	if (GetTextExists(obj3D.infoTextID)=1)
		deleteText(obj3D.infoTextID)
	endif	
	obj3D.energySpriteID=0
	obj3D.infoTextID=0
endfunction	

function checkBombCollision(bulletObj ref as Oggetto3D)
	i as integer
	dist as float
	if (bulletObj.status=STATUS_BOMB_EXPLOSION) 
		bulletObj.scale=bulletObj.scale+0.2
		if (bulletObj.scale>=15) 
			 bulletObj.status=STATUS_ENDING
			 SetObjectScale(bulletObj.ID,1,1,1)
			 bulletObj.scale=1
			 if (bulletObj.color<>"") then applyColor3D(bulletObj)
    	else
			SetObjectScale(bulletObj.ID,bulletObj.scale,bulletObj.scale,bulletObj.scale)
			SetObjectColor(bulletObj.ID,Random2(0,255),Random2(0,255),Random2(0,255),Random2(0,255))
		endif	
		for i=0 to oggetti3D.length
			if (oggetti3D[i].category=CAT_ENEMY) and (oggetti3D[i].status=STATUS_ACTIVE)
				dist=getDistanceVector3D(bulletObj.x,bulletObj.y,bulletObj.z,oggetti3D[i].x,oggetti3D[i].y,oggetti3D[i].z)
				if (dist<=(bulletObj.scale*bulletObj.width/2))
					oggetti3D[i].status=STATUS_FALLING
					score=score+1000
					deleteObjectInfo(oggetti3D[i])
					if (oggetti3D[i].animated=1) 
						if (oggetti3D[i].animFallingStart<>oggetti3D[i].animFallingEnd)
							PlayObjectAnimation(oggetti3D[i].ID,GetObjectAnimationName(oggetti3D[i].ID,1),oggetti3D[i].animFallingStart,oggetti3D[i].animFallingEnd,0,0)
						else
							SetObjectAnimationSpeed(oggetti3D[i].ID,0)
						endif
					endif		
				endif
			elseif (oggetti3D[i].category=CAT_TANK) and (oggetti3D[i].status=STATUS_ACTIVE) and (oggetti3D[i].explosionObjID=0)
				dist=getDistanceVector3D(bulletObj.x,bulletObj.y,bulletObj.z,oggetti3D[i].x,oggetti3D[i].y,oggetti3D[i].z)
				if (dist<=20)
					print("Hit")
					updateHitEnemy(i,10)
					inc numHitTargets
					createExplosion(i)
				endif
			elseif (isMultiPlayerLAN=1) and (oggetti3D[i].category=CAT_PLAYER) and (oggetti3D[i].status=STATUS_IDLE) and (VSMode=1)
				dist=getDistanceVector3D(bulletObj.x,bulletObj.y,bulletObj.z,oggetti3D[i].x,oggetti3D[i].y,oggetti3D[i].z)
				if (dist<=(bulletObj.scale*bulletObj.width/2))
			        updateHitMultiPlayer(i,5)
				endif
			endif	 
		next		
	endif	
endfunction	

function computeFPSRaycastTarget(fpsObj as Oggetto3D, startCheckPos as Vector3D, backFlag as integer,range as float,offset_y as float)
	endCheckPos as Vector3D
	angleOffset as float
	angleOffset=180
	if (backFlag=1) 
		angleOffset=0
	endif	
	endCheckPos.x=startCheckPos.x+sin(fpsObj.angle_y-angleOffset)*range
	endCheckPos.y=fpsObj.y+offset_y
	endCheckPos.z=startCheckPos.z+cos(fpsObj.angle_y-angleOffset)*range
endfunction endCheckPos	


function computeFPSRaycastStart(fpsObj as Oggetto3D,offset_y as float)
	startCheckPos as Vector3D
	startCheckPos.x=fpsObj.x
	startCheckPos.y=fpsObj.y+offset_y
	startCheckPos.z=fpsObj.z
endfunction startCheckPos

function computeFPSRaycastStart2(fpsObj as Oggetto3D, backFlag as integer, offset_y as float)
	startCheckPos as Vector3D
	angleOffset as float
	angleOffset=180
	if (backFlag=1) 
		angleOffset=0
	endif	
	startCheckPos.x=fpsObj.x+sin(fpsObj.angle_y-180)*0.5
	startCheckPos.y=fpsObj.y+offset_y
	startCheckPos.z=fpsObj.z+cos(fpsObj.angle_y-180)*0.5
endfunction startCheckPos

	
function checkFPSCollision(fpsObj ref as Oggetto3D, backFlag as integer,range as float, height as float)
	remstart
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	remend
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	startCheckPos=computeFPSRaycastStart(fpsObj,height)
	endCheckPos=computeFPSRaycastTarget(fpsObj,startCheckPos,backFlag,range,height)
	remstart
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	remend
	hitObjID=checkSlideCollision(0,startCheckPos,endCheckPos,1)
	if (hitObjID<>0) 
		//print("hitObjID "+str(hitObjID))
		hitObjIndex=findObjectByID(oggetti3D,hitObjID)
		if (hitObjIndex<>-1)
			exitfunction hitObjIndex
		endif	
	endif	
endfunction	-1	

function checkNearFloorCollision(obj3D ref as Oggetto3D,topFlag as integer,range as float)
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	floorOffset as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	angleOffset as float
	floorOffset=1
	angleOffset=180
	startCheckPos.x=obj3D.x+sin(obj3D.angle_y-angleOffset)*range
	startCheckPos.y=obj3D.y
	startCheckPos.z=obj3D.z+cos(obj3D.angle_y-angleOffset)*range
	if (topFlag=1) 
		floorOffset=-1
	endif	
	endCheckPos.x=startCheckPos.x
	endCheckPos.y=obj3D.y-floorOffset
	endCheckPos.z=startCheckPos.z
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkRayCollision(0,startCheckPos,endCheckPos)
	if (hitObjID<>0) 
		//print("hitObjID "+str(hitObjID))
		hitObjIndex=findObjectByID(oggetti3D,hitObjID)
		if (hitObjIndex<>-1)
			exitfunction hitObjIndex
		endif	
	endif	
endfunction	-1	


function checkFloorCollision(fpsObj ref as Oggetto3D,topFlag as integer)
	sx as float
	sy as float
	sz as float
	ex as float
	ey as float
	ez as float
	floorOffset as float
	hitObjID as integer
	hitObjIndex as integer
	startCheckPos as Vector3D
	endCheckPos as Vector3D
	floorOffset=1
	startCheckPos.x=fpsObj.x
	startCheckPos.y=fpsObj.y
	startCheckPos.z=fpsObj.z
	if (topFlag=1) 
		floorOffset=-1
	endif	
	endCheckPos.x=startCheckPos.x
	endCheckPos.y=fpsObj.y-floorOffset
	endCheckPos.z=startCheckPos.z
	sx=startCheckPos.x
	sy=startCheckPos.y
	sz=startCheckPos.z
	ex=endCheckPos.x
	ey=endCheckPos.y
	ez=endCheckPos.z
	//DrawLine(GetScreenXFrom3D(sx,sy,sz),GetScreenYFrom3D(sx,sy,sz),GetScreenXFrom3D(ex,ey,ez),GetScreenYFrom3D(ex,ey,ez),255,0,0)
	hitObjID=checkRayCollision(0,startCheckPos,endCheckPos)
	if (hitObjID<>0) 
		//print("hitObjID "+str(hitObjID))
		hitObjIndex=findObjectByID(oggetti3D,hitObjID)
		if (hitObjIndex<>-1)
			exitfunction hitObjIndex
		endif	
	endif	
endfunction	-1	

function mapStatus(statusString as string)
	status as integer
	select statusString
				case "HIDDEN"
				   status=STATUS_HIDDEN
				endcase
				case "IDLE"
				   status=STATUS_IDLE
				endcase   
				case "ACTIVE"
				   status=STATUS_ACTIVE
				endcase
				case "ENDING"
				   status=STATUS_ENDING
				endcase
				case "OBSTACLE"
				   status=STATUS_OBSTACLE
				endcase
				case "CHANGEROUTE"
				   status=STATUS_CHANGEROUTE
				endcase
				case "FALLING"
				   status=STATUS_FALLING
				endcase
				case "CHANGEAI"
				   status=STATUS_CHANGEAI
				endcase
				case "OPEN"
				   status=STATUS_OPEN
				endcase
				case "CLOSED"
				   status=STATUS_CLOSED
				endcase
				case "LOCKED"
				   status=STATUS_LOCKED
				endcase
	endselect
endfunction  status 

function displayInfo3D()
	i as integer
	bar_x as float
	bar_y as float
	for i=1 to oggetti3D.length
	   select oggetti3D[i].category
			case CAT_ENEMY, CAT_TANK, CAT_FLYING, CAT_PICKUP
				//print("displayinfo3d "+str(oggetti3D[i].status))
				//print("displayinfo3d "+str(oggetti3D[i].category))
				bar_x=GetScreenXFrom3D(oggetti3D[i].x,oggetti3D[i].y+oggetti3D[i].height+1,oggetti3D[i].z)
				bar_y=GetScreenYFrom3D(oggetti3D[i].x,oggetti3D[i].y+oggetti3D[i].height+1,oggetti3D[i].z)
				if (oggetti3D[i].status=STATUS_ACTIVE) or (oggetti3D[i].status=STATUS_IDLE) 
					if (GetSpriteExists(oggetti3D[i].energySpriteID)=0) and (oggetti3D[i].energy>=0)
						oggetti3D[i].energySpriteID=createSprite(0)
						SetSpriteColor(oggetti3D[i].energySpriteID,255,0,0,255)
						SetSpriteSize(oggetti3D[i].energySpriteID,oggetti3D[i].energy,16)
						setSpriteOffset(oggetti3D[i].energySpriteID,oggetti3D[i].energy/2,8)
					endif	
					rem print("OBJECT ON SCREEN "+str(GetObjectInScreen(oggetti3D[i].ID)))
					if (GetSpriteExists(oggetti3D[i].energySpriteID)=1)
						SetSpritePosition(oggetti3D[i].energySpriteID,bar_x,bar_y)
					endif	
					if (GetTextExists(oggetti3D[i].infoTextID)=0) 
						oggetti3D[i].infoTextID=createText(oggetti3D[i].infoText)
						SetTextColor(oggetti3D[i].infoTextID,255,0,0,255)
						SetTextSize(oggetti3D[i].infoTextID,24)
						SetTextAlignment(oggetti3D[i].infoTextID,0)
					endif	
					if (GetTextExists(oggetti3D[i].infoTextID)=1) 	
						SetTextPosition(oggetti3D[i].infoTextID,bar_x,bar_y-24)
					endif	
				endif	
			endcase
		endselect
	next
endfunction	

function deleteEverything()
	i as integer
	flag as integer
	deleteHUDSprites()
	deleteMapSprites()
	DeleteAllObjects()
	DeleteAllText()
	//DeleteAllImages()
	for i=1 to AGK_NUM_VIRTUAL_BUTTONS
		if (GetVirtualButtonExists(i)) then DeleteVirtualButton(i)
	next i
	for i=1 to AGK_NUM_VIRTUAL_JOYSTICKS
		if (GetVirtualJoystickExists(i)) then DeleteVirtualJoystick(i)
	next i	
	SetSkyBoxVisible(0)
	SetSkyBoxSunVisible(0)
endfunction	

function deleteEverythingButTheText()
	i as integer
	flag as integer
	deleteHUDSprites()
	deleteMapSprites()
	DeleteAllObjects()
	for i=1 to AGK_NUM_VIRTUAL_BUTTONS
		if (GetVirtualButtonExists(i)) then DeleteVirtualButton(i)
	next i
	for i=1 to AGK_NUM_VIRTUAL_JOYSTICKS
		if (GetVirtualJoystickExists(i)) then DeleteVirtualJoystick(i)
	next i	
	SetSkyBoxVisible(0)
	SetSkyBoxSunVisible(0)
endfunction	

function createTextureFromImage(imgFromID as integer,sizeX,sizeY)
	imageFromWidth as integer
	imageFromHeight as integer
	imageToWidth as integer
	imageToHeight as integer
	mBlockImageFrom as integer
	mBlockImageTo as integer
	createdTextureID as integer
	i as integer
	j as integer
	rem i1 as integer
	j1 as integer
	remstart
	w as integer
	h as integer
	a as integer
	w0 as integer
	h0 as integer
	a0 as integer
	remend
	srcFrom as integer
	srcTo as integer 
	numBytes as integer
	offset as integer
	imageFromWidth=GetImageWidth(imgFromID)
	imageFromHeight=GetImageHeight(imgFromID)
	imageToWidth=imageFromWidth*sizeX
	imageToHeight=imageFromHeight*sizeY
	mBlockImageFrom=CreateMemblockFromImage(imgFromID)
	mBlockImageTo=CreateMemblock(12+4*imageFromHeight*imageFromWidth*sizeX*sizeY)
	SetMemblockInt(mBlockImageTo,0,imageToWidth)
	SetMemblockInt(mBlockImageTo,4,imageToHeight)
	SetMemblockInt(mBlockImageTo,8,32)
	remstart
	w0=GetMemblockInt(mBlockImageFrom,0)
	h0=GetMemblockInt(mBlockImageFrom,4)
	a0=GetMemblockInt(mBlockImageFrom,8)
	w=GetMemblockInt(mBlockImageTo,0)
	h=GetMemblockInt(mBlockImageTo,4)
	a=GetMemblockInt(mBlockImageTo,8) 
	remend
	for j=1 to sizeY
		for i=1 to sizeX
			offset=(j-1)*imageToWidth*imageFromHeight*4+(i-1)*imageFromWidth*4
			for j1=1 to imageFromHeight
				srcFrom=12+imageFromWidth*(j1-1)*4
				srcTo=12+offset+(j1-1)*imageToWidth*4
				numBytes=imageFromWidth*4
				copyMemblock(mBlockImageFrom,mBlockImageTo,srcFrom,srcTo,numBytes)
			next j1
		next i
	next j		
	createdTextureID=CreateImageFromMemblock(mBlockImageTo)
	DeleteMemblock(mBlockImageFrom)
	DeleteMemblock(mBlockImageTo)
endfunction createdTextureID
