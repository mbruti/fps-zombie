global scoreText as integer
global worldText as integer
global timerText as integer
global multiVSText as integer

global soundSpriteSheet as integer
global soundOnImage as integer
global soundOffImage as integer
global soundStatus as integer
global soundStatusSprite as integer

global pauseSpriteSheet as integer
global pauseImage as integer
global playImage as integer
global fforwardImage as integer
global backImage as integer
global pauseStatusSprite as integer
global backSprite as integer
global pauseStatus as integer
global controlsBackgroundSprite as integer

global pauseTimer as float

function setControlsVisible(flag as integer)
	if (flag=1)
		SetSpriteVisible(soundStatusSprite,1)
		SetSpriteVisible(pauseStatusSprite,1)
		SetSpriteVisible(backSprite,1)
		SetSpriteVisible(controlsBackgroundSprite,1)
	else
		SetSpriteVisible(soundStatusSprite,0)
		SetSpriteVisible(pauseStatusSprite,0)
		SetSpriteVisible(backSprite,0)
		SetSpriteVisible(controlsBackgroundSprite,0)
	endif
endfunction	
			
function checkControls()
	if (GetPointerPressed()=1)
		if (GetSpriteHitTest(soundStatusSprite,GetPointerX(),GetPointerY())=1)	
			select soundStatus
				case 0
					soundStatus=1
					SetSpriteImage(soundStatusSprite,soundOnImage)
					SetSoundSystemVolume(100)
					SetMusicSystemVolume(100)
				endcase
				case 1
					soundStatus=0
					SetSpriteImage(soundStatusSprite,soundOffImage)
					SetSoundSystemVolume(0)
					SetMusicSystemVolume(0)
				endcase
			endselect
		elseif 	(GetSpriteHitTest(pauseStatusSprite,GetPointerX(),GetPointerY())=1)		
			select pauseStatus
				case 0
					pauseStatus=1
					SetSpriteImage(pauseStatusSprite,playImage)
					pauseTimer=timer()
				endcase
				case 1
					pauseStatus=0
					SetSpriteImage(pauseStatusSprite,pauseImage)
					startGameTimer=startGameTimer+(timer()-pauseTimer)
				endcase
			endselect		
		elseif 	(GetSpriteHitTest(backSprite,GetPointerX(),GetPointerY())=1)
			pauseTimer=timer()
			if (menuBox2(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,"Are you sure?","<Cancel>","<Back to Menu>",48)=2)
				oggetti3D[fps_index].status=STATUS_BACK_TO_MENU
				pauseStatus=0
				SetSpriteImage(pauseStatusSprite,pauseImage)
			endif		
			startGameTimer=startGameTimer+(timer()-pauseTimer)
		endif	
	endif				
endfunction				

function createGameControls()
	controlsBackgroundSprite=CreateSprite(0)
	SetSpriteSize(controlsBackgroundSprite,240,64)
	SetSpritePosition(controlsBackgroundSprite,SCREEN2D_WIDTH-488,0)
	SetSpriteColor(controlsBackgroundSprite,128,255,255,128)
    soundStatusSprite=createSprite(soundOnImage)
    SetSpritePosition(soundStatusSprite,SCREEN2D_WIDTH-320,0)
    soundStatus=1
    pauseStatusSprite=createSprite(pauseImage)
    SetSpritePosition(pauseStatusSprite,SCREEN2D_WIDTH-400,0)
    pauseStatus=0
    backSprite=createSprite(backImage)
    SetSpritePosition(backSprite,SCREEN2D_WIDTH-480,0)
    setControlsVisible(0)
endfunction    
	

function writeScore()
	if (GetTextExists(scoreText)=0) 
		scoreText=printText(0,0,"SCORE:"+padZero(score,8),36,0)
		SetTextColor(scoreText,GetColorRed3D(WHITE),GetColorGreen3D(WHITE),GetColorBlue3D(WHITE),255)
	else
		SetTextString(scoreText,"SCORE:"+padZero(score,8))	
	endif
endfunction	

function writeWorld()
	if (GetTextExists(worldText)=0) 
		worldText=printText(SCREEN2D_WIDTH/3.5,0,"WORLD:"+padZero(world,2),36,0)
		SetTextColor(worldText,GetColorRed3D(RED),GetColorGreen3D(RED),GetColorBlue3D(RED),255)
	else
		SetTextString(worldText,"WORLD:"+padZero(world,2))	
	endif
endfunction	

function writeHUD()
	writeScore()
	writeWorld()
	if (isMultiPlayerLAN=1)
	   if (GetTextExists(multiVSText)=0) 
		   if (VSMode=1) 
		      multiVSText=printText(SCREEN2D_WIDTH/1.5,64,"VS MODE",36,0)
           else
			  multiVSText=printText(SCREEN2D_WIDTH/1.5,64,"COOP MODE",36,0)
           endif   		
		   SetTextColor(multiVSText,GetColorRed3D(CYAN),GetColorGreen3D(CYAN),GetColorBlue3D(CYAN),255)	   
		else
			if (VSMode=1) 
				SetTextString(multiVSText,"VS MODE")	
			else
				SetTextString(multiVSText,"COOP MODE")	
			endif
		endif	
	endif
	remainingTime=computeRemainingTime()
	if (remainingTime<0) then remainingTime=0
	if (GetTextExists(timerText)=0) 
		timerText=printText(SCREEN2D_WIDTH/2.2,0,"TIME:"+padZero(remainingTime,3),36,0)
		SetTextColor(timerText,GetColorRed3D(BLUE),GetColorGreen3D(BLUE),GetColorBlue3D(BLUE),255)
	else
		SetTextString(timerText,"TIME:"+padZero(remainingTime,3))
	endif
	displayInfo3D()
	displayInventory3D()
	displayMap()
endfunction		

function deleteHUDSprites()
	i as integer
	if (GetSpriteExists(hitScreenSprite)=1) 
		 DeleteSprite(hitScreenSprite)
	endif	 
	if (GetSpriteExists(arrowSprite)=1) 
		DeleteSprite(arrowSprite)
	endif 
	if (GetSpriteExists(mirinoSprite)=1) 
		DeleteSprite(mirinoSprite)
	endif
	for i=0 to inventory.length
		if (getSpriteExists(inventory[i].spriteID)=1) then DeleteSprite(inventory[i].spriteID)
		if (getTextExists(inventory[i].infoTextID)=1) then DeleteText(inventory[i].infoTextID)	
	next i
	for i=0 to oggetti3D.length
		deleteObjectInfo(oggetti3D[i])
		//if (getSpriteExists(oggetti3D[i].energySpriteID)=1) then DeleteSprite(oggetti3D[i].energySpriteID)
		//if (getTextExists(oggetti3D[i].infoTextID)=1) then DeleteText(oggetti3D[i].infoTextID)	
	next i
endfunction	

function computeRemainingTime()
	rt as integer
	rt=trunc(totalTimeAvailable-(timer()-startGameTimer))
endfunction rt	
	
	
