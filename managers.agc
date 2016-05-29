global moveAmount as float
global inputString as String
global inputButton as integer
global frameTime as float
global frameCounter as integer
global fps as integer
global angle_hand as integer

global jumping_flag as integer
global start_jump_y as float
global end_jump_y as float
global forward_jump_amount as float
global jump_direction as float

function controlManager()
	i as integer
	targetBullet as Vector3D
	front_hit_index as integer
	move_fwd_flag=0
	if (oggetti3D[fps_index].status=STATUS_FPS_DYING) or  (oggetti3D[weapon_index].angle_x>=1) then exitfunction
	if (isPC=1) 
		inputString=inputKeyboard()
	else
		inputString=inputVirtualJoystick()
	endif	
	inputButton=inputVirtualButton()
	if (jumping_flag=0) then oggetti3D[fps_index].moveStep=0
	select inputString
		case "UP"	
		   move_fwd_flag=1
		   angle_hand=mod(angle_hand+8,360)
		   rem print(oggetti3D[fps_index].ID)
		   if (oggetti3D[fps_index].status=STATUS_CLIMBING)
			   front_hit_index=checkFPSCollision(oggetti3D[fps_index],0,1.5,4)
			   if (front_hit_index<>-1)
			       if (oggetti3D[front_hit_index].category=CAT_VERTICAL_STAIRS)
			          moveYObject3D(oggetti3D[fps_index],moveAmount/2)
			       endif
			   endif      
		   elseif (hitWallFront=0) and (hitWallFrontLow=0)
			    if (oggetti3D[fps_index].moveStep<0) or (oggetti3D[fps_index].moveStep=0)
					moveZObject3D(oggetti3D[fps_index],-moveAmount)
					oggetti3D[fps_index].moveStep=-moveAmount
				endif	
		   endif
		endcase
		case "DOWN"
		     angle_hand=mod(angle_hand+8,360)	
		     if (oggetti3D[fps_index].status=STATUS_CLIMBING)
			    moveYObject3D(oggetti3D[fps_index],-moveAmount/2)
		     elseif (hitWallBack=0) 
				 if (oggetti3D[fps_index].moveStep>0) or (oggetti3D[fps_index].moveStep=0)
					moveZObject3D(oggetti3D[fps_index],moveAmount/4)
					oggetti3D[fps_index].moveStep=moveAmount
				 endif	
			endif		
		endcase
		case "LEFT"	
		   rotateObject3D(oggetti3D[fps_index],0,-moveAmount*2,0)
		   rotateObject3D(oggetti3D[weapon_index],0,-moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,-moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase
		case "RIGHT"	
		   rotateObject3D(oggetti3D[fps_index],0,moveAmount*2,0)
		    rotateObject3D(oggetti3D[weapon_index],0,moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase
		case "UPLEFT"	
		   move_fwd_flag=1
		   if (hitWallFront=0) and (hitWallFrontLow=0)
			   moveZObject3D(oggetti3D[fps_index],-moveAmount)
		   endif
		   rotateObject3D(oggetti3D[fps_index],0,-moveAmount*2,0)
		   rotateObject3D(oggetti3D[weapon_index],0,-moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,-moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase
		case "UPRIGHT"	
		   move_fwd_flag=1
		   if (hitWallFront=0) and (hitWallFrontLow=0)
			   moveZObject3D(oggetti3D[fps_index],-moveAmount)
		   endif	   
		   rotateObject3D(oggetti3D[fps_index],0,moveAmount*2,0)
		   rotateObject3D(oggetti3D[weapon_index],0,moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase
		case "DOWNRIGHT"	
		   if (hitWallBack=0) 
			   moveZObject3D(oggetti3D[fps_index],moveAmount/4)
		   endif	   
		   rotateObject3D(oggetti3D[fps_index],0,moveAmount*2,0)
		   rotateObject3D(oggetti3D[weapon_index],0,moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase	
		case "DOWNLEFT"	
		   if (hitWallBack=0) 
			   moveZObject3D(oggetti3D[fps_index],moveAmount/4)
		   endif	   
		   rotateObject3D(oggetti3D[fps_index],0,-moveAmount*2,0)
		   rotateObject3D(oggetti3D[weapon_index],0,-moveAmount*2,0)
		   //RotateObjectLocalY(oggetti3D[weapon_index].ID,-moveAmount*2)
		   //updatePosRot3D(oggetti3D[weapon_index])
		endcase	
		case "SPACE"	
		   rem print(str(oggetti3D[9].category))
		   oggetti3D[9].lightMode=1-oggetti3D[9].lightMode
		   SetObjectLightMode(oggetti3D[9].ID,oggetti3D[9].lightMode)
		endcase
	endselect	
	if (inputButton=1) and (oggetti3D[fps_index].status=STATUS_IDLE) and (oggetti3D[fps_index].category=STATUS_IDLE)
		if (oggetti3D[bullet_index].status=STATUS_HIDDEN) and (inventory[selected_inventory_index].ammo>0)
			oggetti3D[bullet_index].life=0
			inc numShoots
			oggetti3D[bullet_index].status=STATUS_ACTIVE
			clonePosRot3D(oggetti3D[fps_index],oggetti3D[bullet_index])
			oggetti3D[bullet_index].angle_y=oggetti3D[bullet_index].angle_y-180
			inc oggetti3D[bullet_index].y,2
			positionObject3D(oggetti3D[bullet_index])
			MoveObjectLocalZ(oggetti3D[bullet_index].ID,8)
			updatePosRot3D(oggetti3D[bullet_index])
			startBulletPos.x=oggetti3D[bullet_index].x
			startBulletPos.y=oggetti3D[bullet_index].y
			startBulletPos.z=oggetti3D[bullet_index].z
			if (inventory[selected_inventory_index].category<>CAT_INV_KNIFE)
				dec inventory[selected_inventory_index].ammo
				SetObjectVisible(oggetti3D[bullet_index].ID,1)
			else	
				SetObjectVisible(oggetti3D[bullet_index].ID,0)
			endif	
			oggetti3D[bullet_index].weapon=oggetti3D[fps_index].weapon
			angle_y_fire=oggetti3D[weapon_index].angle_y_fire
			RotateObjectLocalY(oggetti3D[weapon_index].ID,oggetti3D[weapon_index].angle_y_fire)
			RotateObjectLocalX(oggetti3D[weapon_index].ID,oggetti3D[weapon_index].angle_x_fire)
			rem MoveObjectLocalZ(oggetti3D[weapon_index].ID,5)
			updatePosRot3D(oggetti3D[weapon_index])
			oggetti3D[weapon_index].status=STATUS_WEAPON_FIRE
			i=inventory[selected_inventory_index].category
			Playsound(getSound())
		 endif
	elseif (inputButton=2) and (oggetti3D[fps_index].status=STATUS_IDLE) and (jumping_flag=0) and (fallCounter=0)
		jumping_flag=1
		start_jump_y=oggetti3D[fps_index].y	 	
		end_jump_y=start_jump_y+9
		jump_direction=0.3
		PlaySound(getSoundByName("jump"))
	elseif (inputButton=3) and (oggetti3D[fps_index].status=STATUS_IDLE)
		cam_angle_xy=cam_angle_xy-1
		if (cam_angle_xy<-45) then cam_angle_xy=-45
	elseif (inputButton=4) and (oggetti3D[fps_index].status=STATUS_IDLE)
		cam_angle_xy=cam_angle_xy+1
		if (cam_angle_xy>10) then cam_angle_xy=10					
	endif
	if (inputButton=3) or (inputButton=4)
		targetBullet.x=oggetti3D[fps_index].x+100*sin(oggetti3D[fps_index].angle_y)
			targetBullet.y=oggetti3D[fps_index].y+100*tan(cam_angle_xy)
			targetBullet.z=oggetti3D[fps_index].z+100*cos(oggetti3D[fps_index].angle_y)
			//print_debug(str(targetBullet.x)+" "+str(targetBullet.y)+" "+str(targetBullet.z)+" getscreenyfrom3d "+str(GetScreenYFrom3D(targetBullet.x,targetBullet.y,targetBullet.z)))
			if (inventory[selected_inventory_index].category=CAT_INV_GUN) 
				SetSpriteY(mirinoSprite,GetScreenYFrom3D(targetBullet.x,targetBullet.y,targetBullet.z)+GetSpriteHeight(mirinoSprite)/2)
			endif	
	endif
	checkControls()	
endfunction	

function jumpManager()
	currentFloorY as float
	currentFloorY=getFloor(oggetti3D[fps_index].x,oggetti3D[fps_index].z,-1)
	remstart
	print("")
	print("floor "+str(currentFloorY))
	print("jumping_flag "+str(jumping_flag))
	print("fps y "+str(oggetti3D[fps_index].y))
	print("hit_floor "+str(hitFloor))
	print("hit_Top "+str(hitTop))
	remend
	if (jumping_flag=1) 
		if (jump_direction<0)
			inc fallCounter
		endif	
		oggetti3D[fps_index].y=oggetti3D[fps_index].y+jump_direction
		if (jump_direction>0) and (oggetti3D[fps_index].y>=end_jump_y)
			jump_direction=-jump_direction
		elseif (jump_direction<0) and (oggetti3D[fps_index].y<=currentFloorY)
			oggetti3D[fps_index].y=currentFloorY
			jumping_flag=0
			playsound(getSoundByName("jumpDown"))
			checkFallCounter()
		endif	
	elseif (oggetti3D[fps_index].y<currentFloorY) and (hitFloor=0)
		oggetti3D[fps_index].y=currentFloorY
		//playSound(footstepsSound)
		checkFallCounter()	
	endif	
endfunction    

function collisionManager()
	currentFloorFPS as float
	checkObjectsCollision()
	if (hitFloor=1) 
		if (jumping_flag=1) and (jump_direction<0) 
			jumping_flag=0
			playsound(getSoundByName("jumpDown"))
		endif		
		checkFallCounter()
		if (oggetti3D[fps_index].status=STATUS_CLIMBING) then oggetti3D[fps_index].status=STATUS_IDLE
	elseif (hitFloor=0) and (jumping_flag=0)
		currentFloorFPS=getFloor(oggetti3D[fps_index].x,oggetti3D[fps_index].z,-1)
		if (oggetti3D[fps_index].status=STATUS_CLIMBING) 
			if (oggetti3D[fps_index].y<=currentFloorFPS) then oggetti3D[fps_index].status=STATUS_IDLE
		elseif (oggetti3D[fps_index].y>currentFloorFPS) and (oggetti3D[fps_index].onObject=-1)
			oggetti3D[fps_index].y=oggetti3D[fps_index].y-0.3
			inc fallCounter
		    if 	(oggetti3D[fps_index].y<=currentFloorFPS)
			  if (mod(frameCounter,8)=0) then playsound(getSoundByName("footsteps"))
               oggetti3D[fps_index].y=currentFloorFPS
               checkFallCounter()
	    	endif
	    elseif (oggetti3D[fps_index].y<currentFloorFPS) and (oggetti3D[fps_index].onObject=-1)
			if (mod(frameCounter,8)=0) then playsound(getSoundByName("footsteps"))
		 	oggetti3D[fps_index].y=currentFloorFPS
        endif       	
	endif	
	//print("hitWallFront "+str(hitWallFront))
	//print("hitWallBack "+str(hitWallBack))
	//print("hitFloor "+str(hitFloor))
	//print("jumpingFlag "+str(jumping_flag))
endfunction

function positionFPSManager()
	i as integer
	positionObject3D(oggetti3D[fps_index])
	positionObject3D(oggetti3D[weapon_index])
	clonePosRot3D(oggetti3D[weapon_index],oggetti3D[hand_index])
	positionObject3D(oggetti3D[hand_index])
	moveZObject3D(oggetti3D[hand_index],oggetti3D[weapon_index].hand_offset_z)
	moveXObject3D(oggetti3D[hand_index],oggetti3D[weapon_index].hand_offset_x)
	moveYObject3D(oggetti3D[hand_index],oggetti3D[weapon_index].hand_offset_y)
	moveYObject3D(oggetti3D[hand_index],0.5*sin(angle_hand)+1)
	moveYObject3D(oggetti3D[weapon_index],0.5*sin(angle_hand)+2)
	if (oggetti3D[fps_index].status<>STATUS_FPS_DYING) and (oggetti3D[fps_index].status<>STATUS_GAME_OVER) 
	   positionMainCameraBehind3D(oggetti3D[fps_index])
	endif   
	for i=0 to oggetti3D.length
		if (oggetti3D[i].canFire=1) and (oggetti3D[i].targetFireID<>0)
			SetObjectPosition(oggetti3D[i].targetFireID,oggetti3D[fps_index].x,oggetti3D[fps_index].y,oggetti3D[fps_index].z)
		endif	
	next i
	if (shieldPower>0) and (oggetti3D[fps_index].shieldID>0)
		SetObjectPosition(oggetti3D[fps_index].shieldID,oggetti3D[hand_index].x,oggetti3D[hand_index].y,oggetti3D[hand_index].z)
		rem SetObjectRotation(oggetti3D[fps_index].shieldID,oggetti3D[hand_index].angle_x,oggetti3D[hand_index].angle_y+180,oggetti3D[hand_index].angle_z)
	endif	 
endfunction	

function inventoryManager()
	i as integer
	hitSpriteID as integer
	inventory_index as integer
	related3D_index as integer
	if (oggetti3D[bullet_index].status<>STATUS_HIDDEN) then exitfunction
	inventory_index=-1
	if ( GetPointerPressed() = 1 )
        hitSpriteID = GetSpriteHit(getPointerX(),GetPointerY())
        inventory_index=findInventoryBySpriteID(inventory,hitSpriteID)
        //print("hitspriteID "+str(hitSpriteID))
        //print("inventory_index "+str(inventory_index))
    endif
    if (inventory_index=-1) then exitfunction
    if (inventory[inventory_index].category=CAT_INV_LIFE) then exitfunction
    if (inventory[inventory_index].category=CAT_INV_MEDIKIT) 
		inventory[life_inventory_index].ammo=inventory[life_inventory_index].ammo+inventory[inventory_index].ammo
		inventory[inventory_index].ammo=0
		SetSpriteColor(inventory[inventory_index].spriteID,0,0,0,255)
		exitfunction
	endif	
    related3D_index=findObjectByName(oggetti3D,inventory[inventory_index].name)
    if (related3D_index=-1) then exitfunction
    //print("INDEX "+str(inventory_index)+" "+str(related3D_index))
    changeCurrentInventory(weapon_index,related3D_index)
    weapon_index=related3D_index
    selected_inventory_index=inventory_index
    oggetti3D[fps_index].weapon=oggetti3D[weapon_index].name
    for i=0 to inventory.length
		if (GetSpriteExists(inventory[i].spriteID)=0) then continue
		if (i=inventory_index) 
			SetSpriteColor(inventory[i].spriteID,255,255,255,255)
		elseif (inventory[i].category<>CAT_INV_LIFE) and (inventory[i].category<>CAT_INV_MEDIKIT) and (inventory[i].category<>CAT_INV_KEY)
			SetSpriteColor(inventory[i].spriteID,0,0,0,255)
		endif
	next			
endfunction    

function timeManager()
	if (remainingTime=0)
		oggetti3D[fps_index].status=STATUS_GAME_OVER
	endif
endfunction		

function frameManager()
	frameTime=GetFrameTime()
	fps=trunc(ScreenFPS())
	frameCounter=frameCounter+1
	if (frameCounter>=fps) then frameCounter=0
	moveAmount=ceil(frameTime*60)*0.5
endfunction moveAmount

function levelChangeManager()
	numLiveEnemies as integer
	i as integer
	numLiveEnemies=0
	for i=0 to oggetti3D.length
		if ((oggetti3D[i].category=CAT_ENEMY) or (oggetti3D[i].category=CAT_TANK) or (oggetti3D[i].category=CAT_FLYING)) and (oggetti3D[i].status<>STATUS_HIDDEN) 
			inc numLiveEnemies
		endif
	next i
	if 	(numLiveEnemies=0) 
		oggetti3D[fps_index].status=STATUS_CHANGE_LEVEL
	endif
endfunction

function explosionManager()
	i as integer
	for i=0 to oggetti3D.length
		if (oggetti3D[i].explosionObjID<>0)
			if (GetObjectIsAnimating(oggetti3D[i].explosionObjID)=0)
				DeleteObjectWithChildren(oggetti3D[i].explosionObjID)
				oggetti3D[i].explosionObjID=0
			endif
		endif
	next i
endfunction				
		
function gameLoop3D()
	frameManager()
	checkNetworkClientAvailable(networkID)
	controlManager()
	jumpManager()	
	collisionManager()
	objectManager()
	inventoryManager()
	positionFPSManager()
	writeHUD()
	timeManager()
	levelChangeManager()	
	explosionManager()
endfunction    

function checkFallCounter()
	if (fallCounter>90)
		hitPlayer((fallCounter-90))
	endif
	fallCounter=0
endfunction		

		


