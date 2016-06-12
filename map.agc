type mapTargetType
	ID as integer
	index as integer
endtype 	
global mapTarget as mapTargetType[]
function clearMap()
	mapTarget.length=-1
endfunction	
function displayMap()
	i as integer
	angle_y as float
	newMapTarget as mapTargetType
	remstart
	print("arrow image "+str(GetImageExists(arrowImage)))
	print("arrow Sprite "+str(GetSpriteExists(arrowSprite)))
	print("arrow sprite x "+str(GetSpriteXByOffset(arrowSprite)))
	print("arrow sprite y "+str(GetSpriteYByOffset(arrowSprite)))
	print("arrow sprite image "+str(GetSpriteImageID(arrowSprite)))
	print("arrow image id "+str(arrowImage))
	print("mirino sprite image "+str(GetSpriteImageID(mirinoSprite)))
	print("mirino id "+str(mirinoImage))
	print("GetSpriteExists(mapSprite) "+str(GetSpriteExists(mapSprite)))
	remend
	if (GetSpriteExists(mapSprite)=0) 
		clearMap()
		mapSprite=createSprite(0)
		SetSpriteColor(mapSprite,255,128,0,128)
		SetSpriteSize(mapSprite,TERRAIN_SIZE_X/2,TERRAIN_SIZE_Z/2)
		SetSpritePosition(mapSprite,0,32)
		for i=0 to oggetti3D.length
			if (oggetti3D[i].category=CAT_ENEMY) or (oggetti3D[i].category=CAT_TANK) or (oggetti3D[i].category=CAT_FLYING) or ((oggetti3D[i].category=CAT_PLAYER) and (isMultiPlayerLAN=1)) or (oggetti3D[i].category=CAT_GHOST) 
				newMapTarget.index=i
				newMapTarget.ID=createSprite(0)
				setSpriteSize(newMapTarget.ID,8,8)
				SetSpriteOffset(newMapTarget.ID,4,4)
				select oggetti3D[i].category
					case CAT_ENEMY
						SetSpriteColor(newMapTarget.ID,255,0,0,255)
					endcase
					case CAT_TANK
						SetSpriteColor(newMapTarget.ID,128,128,0,255)
					endcase
					case CAT_FLYING
						SetSpriteColor(newMapTarget.ID,0,128,255,255)
					endcase
					case CAT_GHOST
						SetSpriteColor(newMapTarget.ID,0,255,0,255)
					endcase	
					case CAT_PLAYER
						SetSpriteColor(newMapTarget.ID,0,0,255,255)
					endcase	
				endselect
				mapTarget.insert(newMapTarget)
			endif		
		next i
	else
		for i=0 to 	mapTarget.length
			if (GetSpriteExists(mapTarget[i].ID)=1)
				if (oggetti3D[mapTarget[i].index].status=STATUS_HIDDEN)
					DeleteSprite(mapTarget[i].ID)
				else	
					SetSpritePositionByOffset(mapTarget[i].ID, (TERRAIN_SIZE_X/2-oggetti3D[mapTarget[i].index].x)/2,(oggetti3D[mapTarget[i].index].z+TERRAIN_SIZE_Z/2)/2+32)
				endif	
			rem print("posizione x "+str(oggetti3D[mapTarget[i].index].x))
			endif
		next i
		angle_y=oggetti3D[fps_index].angle_y
		rem print("angolo oggetto "+str(angle_y))
		SetSpriteAngle(arrowSprite,angle_y)
		rem print("angolo freccia "+str(angle_y))
	endif	 
endfunction	

function deleteMapSprites()
	i as integer
	if (GetSpriteExists(mapSprite)=1) 
		DeleteSprite(mapSprite)
	endif
	for i=0 to 	mapTarget.length
		if (GetSpriteExists(mapTarget[i].ID)=1)
			DeleteSprite(mapTarget[i].ID)
		endif
	next i
endfunction	
	
