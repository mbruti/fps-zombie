global menuItems as string[7] = ["SINGLE PLAYER","CHOOSE WORLD","TRAINING","HOST A GAME", "JOIN A GAME","HI LOCAL","HI GLOBAL","QUIT"]
global menuItemsText as integer[7]
global modeItems as string[1] = ["VS MODE","COOPERATIVE MODE"]
global modeItemsText as integer[1]

global zombieBackgroundSprite as integer

global backgroundTimer as float
global backgroundUV as float

global scaleUV as float

function showGameOver3D()
	camera_z as float
	camera_y as float
	title1ID as integer
	deleteEverythingButTheText()
	SetGlobal3DDepth(0)
	title1ID=LoadObject(OBJECTS_FOLDER+"/gameover.obj",2.5)
	SetObjectColor(title1ID,128,255,0,255)
	SetObjectPosition(title1ID,-12.5,10,0)
	rem CreateLightDirectional(1,1,-1,-1,255,255,255)
	SetObjectLightMode(title1ID,1)
	camera_z=-120
	camera_y=18
	SetCameraRotation(1,0,0,0)
	repeat
		backImageScroll(0.0127)
		SetCameraPosition(1,0,camera_y,camera_z)
		camera_z=camera_z+0.2
		if (camera_y>0) then camera_y=camera_y-0.02
	    sync()
	until (camera_z>-25)
	SetGlobal3DDepth(10000)    
endfunction	

function showChangeLevel3D()
	camera_z as float
	camera_y as float
	angle as float
	changeLevelID as integer
	SetGlobal3DDepth(0)
	changeLevelID=LoadObject(OBJECTS_FOLDER+"/changeworld.obj",3)
	SetObjectColor(changeLevelID,128,255,0,255)
	SetObjectPosition(changeLevelID,0,0,0)
	SetObjectLightMode(changeLevelID,1)
	camera_z=-82
	camera_y=15
	angle=0
	SetCameraRotation(1,0,0,0)
	repeat
		SetCameraPosition(1,0,camera_y*sin(angle),camera_z)
		SetObjectRotation(changeLevelID,0,angle,0)
		camera_z=camera_z+0.2
		if (camera_y>0) then camera_y=camera_y-0.02
		inc angle
		angle=wrapValue(angle)
		backImageScroll(0.0169)
	    sync()
	until (camera_z>-10)    
	pauseTime(5)
	deleteBackImage()
	SetGlobal3DDepth(10000)
endfunction	

function chooseMenuItem(mItems as string[],mItemsText as integer[],unlock as integer )
	i as integer
	xPressed as float
	yPressed as float
	menuChoice as integer
	repeat
		while (GetPointerPressed()=0)
			xPressed=GetPointerX()
			yPressed=GetPointerY()	
			for i=0 to unlock
				if (GetTextHitTest(mItemsText[i],xPressed,yPressed)=1)
					SetTextColor(mItemsText[i],255,255,255,255)
				else
					SetTextColor(mItemsText[i],GetColorRed3D(DARKRED),GetColorGreen3D(DARKRED),GetColorBlue3D(DARKRED),255)
				endif		
			next
			rem print(str(menuChoice))
			backImageScroll(0.003)
			sync()
		endwhile		
		xPressed=GetPointerX()
		yPressed=GetPointerY()
		menuChoice=-1
		for i=0 to unlock
			if (GetTextHitTest(mItemsText[i],xPressed,yPressed)=1)
				menuChoice=i
				exit
			endif
		next
		sync()
	until ((menuChoice>=0) and (menuChoice<=unlock))
	DeleteAllText()
	deleteBackImage()
endfunction	menuChoice

function backImageScroll(speed as float)
	if (GetSpriteExists(zombieBackgroundSprite)=0)
		SetFolder(OBJECTS_FOLDER)
		SetImageWrapU(zombieBackgroundImage,1)
		SetImageWrapV(zombieBackgroundImage,1)
		zombieBackgroundSprite=CreateSprite(zombieBackgroundImage)
		SetSpriteDepth(zombieBackgroundSprite,10000)
		SetSpritePosition(zombieBackgroundSprite,0,0)
		backgroundTimer=timer()
		backgroundUV=0
		scaleUV=1
		SetSpriteUVOffset(zombieBackgroundSprite,backgroundUV,backgroundUV)
		SetSpriteUVScale(zombieBackgroundSprite,scaleUV,scaleUV)
		SetFolder(OBJECTS_FOLDER)
	endif
	if ((timer()-backgroundTimer)>0.03)
		backgroundTimer=timer()
		backgroundUV=backgroundUV+speed
		scaleUV=scaleUV+speed
		if (scaleUV>3) then scaleUV=0
		if (backgroundUV>2) then backgroundUV=0
		SetSpriteUVOffset(zombieBackgroundSprite,backgroundUV,backgroundUV)
		SetSpriteUVScale(zombieBackgroundSprite,scaleUV,scaleUV)
	endif
endfunction		

function deleteBackImage()
	DeleteSprite(zombieBackgroundSprite)
endfunction	
	
function mainMenu()
	i as integer
	menuChoice as integer
	chosenWorldText as integer
	chosenWorld=1
	repeat
		appVersionText=CreateText(APP_VERSION_STRING)
		SetTextSize(appVersionText,32)
		setTextPosition(appVersionText,SCREEN2D_WIDTH/2,0)
		SetTextAlignment(appVersionText,1)
		SetTextColor(appVersionText,255,255,255,255)
		sync()
		for i=0 to menuItems.length
			menuItemsText[i]=CreateText(menuItems[i])
			SetTextSize(menuItemsText[i],72)
			SetTextAlignment(menuItemsText[i],1)
			SetTextPosition(menuItemsText[i],SCREEN2D_WIDTH/2,64+80*i)
			SetTextColor(menuItemsText[i],GetColorRed3D(RED),GetColorGreen3D(RED),GetColorBlue3D(RED),255)
			sync()
		next i
		chosenWorldText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-96, "Current world:"+str(chosenWorld), 72, 1)
		SetTextColor(chosenWorldText,GetColorRed3D(YELLOW),GetColorGreen3D(YELLOW),GetColorBlue3D(YELLOW),255)
		menuChoice=chooseMenuItem(menuItems,menuItemsText,menuItems.length)	
		select menuChoice
			case 0
				isMultiPlayerLAN=0
			endcase
			case 1
				pausetime(0.1)
				chosenWorld=chooseWorld()
				isMultiPlayerLAN=0	
				pauseTime(0.1)
			endcase
			case 2
				isMultiPlayerLAN=0
				chosenWorld=TRAINING_LEVEL
			endcase
			case 3
				chooseMode()
				networkID=hostGameLAN()
			endcase
			case 4
				networkID=joinGameLAN()
			endcase
			case 5
				displayHi(hi_local)
				pauseTime(0.1)		
			endcase
			case 6
				if (loadGlobalHi()=0)
					displayHi(hi_global)
					pauseTime(0.1)
				else
					messageBox(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,"Sorry, no Internet connection...",48)
				endif				
			endcase
			case 7
				end
			endcase	
		endselect
	until (menuChoice<>1) and (menuChoice<>5) and (menuChoice<>6) 			
endfunction

function chooseWorld()
	i as integer
	cw as integer
	unlockWorld as integer
	worldList as string[]
	menuWorldText as integer[]
	worldList=checkLevels()
	unlockWorld=val(worldList[0])
	for i=0 to worldList.length-1
		menuWorldText.insert(createText("WORLD"+str(i+1)))
		SetTextSize(menuWorldText[i],72)
	    SetTextAlignment(menuWorldText[i],0)
	    SetTextPosition(menuWorldText[i],SCREEN2D_WIDTH/6+SCREEN2D_WIDTH/3*(mod(i,2)),100*(i/2))
	    if (i<unlockWorld)
			SetTextColor(menuWorldText[i],GetColorRed3D(RED),GetColorGreen3D(RED),GetColorBlue3D(RED),255)
		else
			SetTextColor(menuWorldText[i],GetColorRed3D(WHITE),GetColorGreen3D(WHITE),GetColorBlue3D(WHITE),128)
		endif
	next i
	worldList.remove(0)
	cw=chooseMenuItem(worldList,menuWorldText,unlockWorld-1)+1
endfunction cw	
	
function chooseMode()
	i as integer
	modeChoice as integer
	chosenWorldText as integer
	repeat
		for i=0 to modeItems.length
			modeItemsText[i]=CreateText(modeItems[i])
			SetTextSize(modeItemsText[i],72)
			SetTextAlignment(modeItemsText[i],1)
			SetTextPosition(modeItemsText[i],SCREEN2D_WIDTH/2,100*(i+1))
			SetTextColor(modeItemsText[i],GetColorRed3D(RED),GetColorGreen3D(RED),GetColorBlue3D(RED),255)
			sync()
		next i
		chosenWorldText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-128, "Current world:"+str(chosenWorld), 72, 1)
		SetTextColor(chosenWorldText,GetColorRed3D(YELLOW),GetColorGreen3D(YELLOW),GetColorBlue3D(YELLOW),255)
		modeChoice=chooseMenuItem(modeItems,modeItemsText,modeItems.length)	
		select modeChoice
			case 0
				VSMode=1
				pauseTime(0.1)
			endcase
			case 1
				VSMode=0
				pauseTime(0.1)
			endcase	
		endselect
	until (modeChoice=0) or (modeChoice=1)			
endfunction	

function printEndLevelScore(elsTxt as integer)
	endLevelScoreString as string
	endLevelScoreString=padSpaceRight("SCORE",6)+padZero(score,8)
	SetTextString(elsTxt,endLevelScoreString)
endfunction

function endLevel()
	endLevelScoreText as integer
	redcircleImageID as integer
	redcircleSpriteID as integer
	i as integer
	bonus as integer
	bonusString as string
	endLevelTitleText as integer
	bonusText as integer
	alpha_text as integer
	accuracyStat as integer
	accuracyStatText as integer
	remainingTimeText as integer
	remainingTimeString as string
	remainingLifeText as integer
	remainingLife as integer
	remainingLifeString as string
	accuracyStatString as string
	radius as float
	endLevelTitleText=printText(SCREEN2D_WIDTH/2,8,"WORLD <"+levelName+"> COMPLETED!",48,1)
	SetTextColor(endLevelTitleText,64,0,255,255)
	endLevelScoreText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2-250,"",48,1)
	remainingLife=inventory[life_inventory_index].ammo
	remainingLifeText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2-150,"",48,1)
	alpha_text=150
	SetTextColor(remainingLifeText,0,192,192,255)
	PlayMusic(getMusicByName("fightscene"),1)
	radius=min2(SCREEN2D_WIDTH/2, SCREEN2D_HEIGHT/2)-64
	now as float
	for i=1 to radius
		DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,i,i,MakeColor(255,0,0),MakeColor(0,0,0),1)
		sync()
	next i	
	DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,radius,radius,MakeColor(255,0,0),MakeColor(0,0,0),1)
	render()
	redcircleImageID=GetImage(SCREEN2D_WIDTH/2-radius,SCREEN2D_HEIGHT/2-radius,2*radius,2*radius)
	ClearScreen()
	redcircleSpriteID=CreateSprite(redcircleImageID)
	SetSpriteSize(redcircleSpriteID,2*radius,2*radius)
	SetSpritePosition(redcircleSpriteID,SCREEN2D_WIDTH/2-radius,SCREEN2D_HEIGHT/2-radius)
	for i=remainingLife to 0 step -1
		//DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,radius,radius,MakeColor(255,0,0),MakeColor(0,0,0),1)
		remainingLifeString=padSpaceRight("ENERGY",8)+padZero(i,5)
		score=score+10
		printEndLevelScore(endLevelScoreText)
		SetTextString(remainingLifeText, remainingLifeString)
		SetTextColorAlpha(remainingLifeText,alpha_text)
		inc alpha_text,5
		if (alpha_text>250) then alpha_text=150
		if (mod(i,10)=0) then PlaySound(getSoundByName("cling"))
		sync()
	next i	
	alpha_text=150
	remainingTimeText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2-50,"",48,1)
	SetTextColor(remainingTimeText,0,255,64,255)
	for i=remainingTime to 0 step -1
		//DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,radius,radius,MakeColor(255,0,0),MakeColor(0,0,0),1)
		remainingTimeString=padSpaceRight("TIME",8)+padZero(i,5)
		score=score+10
		printEndLevelScore(endLevelScoreText)
		SetTextString(remainingTimeText, remainingTimeString)
		SetTextColorAlpha(remainingTimeText,alpha_text)
		inc alpha_text,5
		if (alpha_text>250) then alpha_text=150
		if (mod(i,10)=0) then PlaySound(getSoundByName("cling"))
		sync()
	next i
	if (numShoots=0) then numShoots=1000000
	accuracyStat=trunc(100.0*numHitTargets/numShoots)
	alpha_text=150
	accuracyStatText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2+50,"",48,1)
	SetTextColor(accuracyStatText,255,0,64,255)
	for i=0 to accuracyStat
		//DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,radius,radius,MakeColor(255,0,0),MakeColor(0,0,0),1)
		accuracyStatString=padSpaceRight("ACCURACY",9)+padZero(i,3)+"%"
		SetTextString(accuracyStatText, accuracyStatString)
		SetTextColorAlpha(accuracyStatText,alpha_text)
		inc alpha_text,5
		if (alpha_text>250) then alpha_text=150
		if (mod(i,10)=0) then PlaySound(getSoundByName("cling"))
		sync()
	next i
	if (accuracyStat>=90) 
		bonus=3000
	elseif (accuracyStat>=70)
		bonus=2000
	elseif (accuracyStat>=50)
		bonus=1000
	else
		bonus=0
	endif
	if (bonus>0)
		bonusString="BONUS "+str(bonus)+" !"
		score=score+bonus
		printEndLevelScore(endLevelScoreText)
	else
		bonusString="SORRY NO BONUS"
	endif		
	bonusText=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2+150,bonusString,48,1)	
	SetTextColor(bonusText,0,128,255,255)
	now=Timer()
	repeat
		//DrawEllipse(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,radius,radius,MakeColor(255,0,0),MakeColor(0,0,0),1)
		sync()
	until ((Timer()-now)>5)			
	stopLoopingSounds(1)
	loadSounds()
	DeleteAllText()
	DeleteSprite(redcircleSpriteID)
	//DeleteImage(redcircleImageID)
endfunction   		
	

	
