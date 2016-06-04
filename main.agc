
// Project: fps-zombie
// Created: 2015-01-11

// set window properties
#option_explicit
#include "intro.agc"
#include "globals.agc"
#include "utils.agc"
#include "hud.agc"
#include "controls.agc"
#include "library3D.agc"
#include "inventory3D.agc"
#include "managers.agc"
#include "sound.agc"
#include "image.agc"
#include "menu.agc"
#include "network.agc"
#include "misc.agc"
#include "map.agc"
#include "highscore.agc"

devType=GetDeviceType()
isPC=0
if (strbegins(devType,"xp")=1) or (strbegins(devType,"7")=1) or (strbegins(devType,"8")=1) or (strbegins(devType,"10")=1)  then isPC=1
SetSyncRate(60,0)
SetWindowTitle( "fps-zombie" )
SetWindowSize( 640, 480, 0 )
//set display properties
SetVirtualResolution( 1280, 800 )
initWindows()
initWorld3D(200,1000,200)
SetOrientationAllowed( 0, 0, 1, 1 )
initGame()
SetGlobal3DDepth(0)
showIntro()
SetGlobal3DDepth(10000)
loadLocalHi()
mainMenu()
startGame()
createGameControls()
do
	SetControlsVisible(1)
	repeat  
		//print("")
		//print("height "+str(GetObjectHeightMapHeight(oggetti3D[terrainAGK_index].ID,oggetti3D[fps_index].x,oggetti3D[fps_index].z)))
		//print(str(oggetti3D[12].angle_y))
		//print(str(GetObjectNumBones(oggetti3D[6].ID)))
		//print(GetObjectBoneByName(oggetti3D[6].ID,"body"))
		//print("fps x="+str(oggetti3D[fps_index].x)+" z="+str(oggetti3D[fps_index].z)+" y="+str(oggetti3D[fps_index].y))
		//print("tnk x="+str(oggetti3D[12].x)+" z="+str(oggetti3D[12].z)+" y="+str(oggetti3D[12].y))
		//print("zmb x="+str(oggetti3D[9].x)+" z="+str(oggetti3D[9].z)+" y="+str(oggetti3D[9].y))
		//print("zmb x="+str(oggetti3D[10].x)+" z="+str(oggetti3D[10].z)+" y="+str(oggetti3D[10].y))
		//print(GetWritePath())
		remstart
		print("ZOMBIE status "+str(oggetti3D[3].status)) 
		print("ZOMBIE y "+str(oggetti3D[3].y)) 
		print("ZOMBIE checknormal "+str(checkNormal3D(8,5,0))) 
		print(str(chosenWorld))
		print(str(oggetti3D[weapon_index].x)+" "+str(oggetti3D[weapon_index].y)+" "+str(oggetti3D[weapon_index].z))
		print("bullet "+str(oggetti3D[bullet_index].angle_x)+" "+str(oggetti3D[bullet_index].angle_y)+" "+str(oggetti3D[bullet_index].angle_z)) 
		print("fps "+str(oggetti3D[fps_index].angle_x)+" "+str(oggetti3D[fps_index].angle_y)+" "+str(oggetti3D[fps_index].angle_z))
		print("weapon "+str(oggetti3D[weapon_index].angle_x)+" "+str(oggetti3D[weapon_index].angle_y)+" "+str(oggetti3D[weapon_index].angle_z))
		printNetworkClients(networkID)
		sendNetworkFPSPosition(networkID)
		getNetworkFPSPosition(networkID)
		print("status bullet="+str(oggetti3D[bullet_index].status))
		print("status fps="+str(oggetti3D[fps_index].status))
		print("status weapon="+str(oggetti3D[weapon_index].status))
		print("status turning flag="+str(oggetti3D[5].turningFlag))
		Print("")
		print("on object "+str(oggetti3D[fps_index].onObject))
		if (oggetti3D[fps_index].onObject>-1) 
		   print("category on object "+str(oggetti3D[oggetti3D[fps_index].onObject].category))
		endif
		remend
		//print("")
		//print(str(getFloor(oggetti3D[fps_index].x,oggetti3D[fps_index].z)))
		//print(str(terrain3D[round(oggetti3D[fps_index].x)+205,round(oggetti3D[fps_index].z)+205]))
		//print("fallcounter "+str(fallCounter))
		//print("jumping_flag "+str(jumping_flag))
		//print("hit_floor "+str(hitFloor))
		//print("hit_top "+str(hitTop))
		//print("status "+str(oggetti3D[fps_index].status))	
		//print("onobject="+str(oggetti3D[fps_index].onObject))
		//print("x="+str(oggetti3D[hand_index].x)+" z="+str(oggetti3D[hand_index].z)+" y="+str(oggetti3D[hand_index].y))
		//print("x="+str(oggetti3D[weapon_index].x)+" z="+str(oggetti3D[weapon_index].z)+" y="+str(oggetti3D[weapon_index].y))
		if (pauseStatus=0) 
			gameLoop3D()
		else
			checkControls()
		endif	
		sync() 
		rem oggetti3D[fps_index].status=STATUS_GAME_OVER
		rem oggetti3D[fps_index].status=STATUS_CHANGE_LEVEL
	until (oggetti3D[fps_index].status=STATUS_GAME_OVER) or (oggetti3D[fps_index].status=STATUS_BACK_TO_MENU) or (oggetti3D[fps_index].status=STATUS_CHANGE_LEVEL)
	SetControlsVisible(0)
	stopLoopingSounds(0)
	if (oggetti3D[fps_index].status=STATUS_CHANGE_LEVEL)
		deleteEverything()
		endLevel()
		writeScore()
		deleteHUDSprites()
	endif
	if  (oggetti3D[fps_index].status=STATUS_GAME_OVER) or (world=NUM_WORLDS) or (oggetti3D[fps_index].status=STATUS_BACK_TO_MENU)
		deleteHUDSprites()
		if (oggetti3D[fps_index].status<>STATUS_BACK_TO_MENU)
			pausetime(2)
			doUnlockWorld(world)
			showGameOver3D()
			manageNewHi(score,world)
			messageBox(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-172,"Press ok to return to main menu.",32)
		endif	
		deleteEverything()
		deleteHUDSprites()
		mainMenu()
		startGame()
	else
		showChangeLevel3D()
		inc world
		deleteEverything()
		deleteHUDSprites()
		startNewWorld()
	endif		
loop
end

function initGame()
	i as integer
	loadSounds()
	loadImages()
	VSMode=0
endfunction

function resetGlobals()
	frameCounter=0
	numHitTargets=0
    numShoots=0
    jumping_flag=0
    hitWallFront=0
    hitWallBack=0
    hitFloor=0
    totalTimeAvailable=300
    angle_hand=0
    cam_angle_xy=0
    shieldPower=0
endfunction	

function startGame()
	flag as integer
	score=0
	resetGlobals()
    world=chosenWorld
    loadWorld(world)
    startGameTimer=Timer()
	showScreen()
endfunction	

function startNewWorld()
	flag as integer
	resetGlobals()
    loadWorld(world)
    startGameTimer=Timer()
	showScreen()
endfunction	

function loadWorld(w as integer)
	createInventory("inventory_world"+str(w)+".json","inventory.png",128,64)
	createObjects("media3D_world"+str(w)+".json")
	createTerrainMap("map_world"+str(w)+".map","altitude_world"+str(w)+".map" )
	bullet_index=findObjectByCategory(oggetti3D,CAT_BULLET)
    life_inventory_index=findInventoryByName(inventory,"life")
endfunction	

function showScreen()
	showObjects()
	positionMainCameraBehind3D(oggetti3D[fps_index])
    createVirtualJoystick(1,64,736)
    createVirtualButton(2,1216,736,128,"JUMP")
    createVirtualButton(1,1088,736,128,"FIRE")
    createVirtualButton(3,240,736,128,"UP")
    createVirtualButton(4,380,736,128,"DOWN")
    mirinoSprite=CreateSprite(mirinoImage)
    SetSpriteOffset(mirinoSprite,GetImageWidth(mirinoImage)/2,GetImageHeight(mirinoImage)/2)
    SetSpritePositionByOffset(mirinoSprite,GetScreenXFrom3D(oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z-60),
	GetScreenYFrom3D(oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z-60))
	arrowSprite=createSprite(arrowImage)
	SetSpriteOffset(arrowSprite,GetImageWidth(arrowImage)/2,GetImageHeight(arrowImage)/2)
    SetSpritePositionByOffset(arrowSprite,TERRAIN_SIZE_X/2+GetImageWidth(arrowImage),TERRAIN_SIZE_Z/4+32)
    displayMap()
endfunction		
