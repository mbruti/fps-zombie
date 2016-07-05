function showLogo3D()
	vy as float
	color as integer
	inc_color as integer
	animLogo3D as integer
	sun3D as integer
	animName as string
	sunScale as float
	inc_scale as float
	animTexture1 as integer
	animTexture2 as integer
	starSprites as integer[100]
	texasoftString as string = "TEXASOFT RELOADED STUDIOS"
	texasoftTextID as integer
 	i as integer
 	j as integer
 	SetGlobal3DDepth(0)
	sun3D=CreateObjectSphere(15,20,20)
	CreatePointLight(2,15,10,10,1000,255,255,0)
	SetObjectPosition(sun3D,30,12,10)
	animLogo3D=LoadObjectWithChildren(OBJECTS_FOLDER+"/animsfera.ms3d")
	SetObjectLightMode(animLogo3D,1)
	SetObjectTransparency(animLogo3D,0)
	animTexture1=LoadImage(OBJECTS_FOLDER+"/texasoft_logo.jpg")
	animTexture2=LoadImage(OBJECTS_FOLDER+"/texasoft_logo_straight.jpg")
	SetObjectImage(animLogo3D,animTexture1,0)
	SetObjectImage(sun3D,animTexture2,0)
	animName=GetObjectAnimationName(animLogo3D,1)
	SetObjectPosition(animLogo3D,-30,-9,0)
	SetObjectScalePermanent(animLogo3D,1.5,1.5,1.5)
	SetCameraPosition(1,-30,0,-20)
	SetCameraLookAt(1,0,0,0,0)
	SetCameraFOV(1,60)
	SetObjectAnimationSpeed(animLogo3D,2)
	PlayObjectAnimation(animLogo3D,animName,0,28,0,0)
	color=64
	inc_color=1
	sunScale=1
	inc_scale=0.001
	SetSunColor(255,255,0)
	SetSunDirection(-1,-1,-1)
	for i=1 to 100
		starSprites[i]=CreateSprite(0)
		SetSpriteSize(starSprites[i],2,2)
		SetSpritePosition(starSprites[i],random2(0,SCREEN2D_WIDTH),random2(0,SCREEN2D_HEIGHT))
		SetSpriteColor(starSprites[i],255,255,0,255)
	next i	
    repeat
		SetObjectColorEmissive(sun3D,color,color,0)
		setobjectscale(sun3D,sunScale,sunScale,sunScale)
		sunScale=sunScale+inc_scale
		inc color, inc_color
		if (color>255) 
			inc_color=-1
			color=255
		elseif (color<64)
			inc_color=1
			color=64
		endif	
		if (sunScale>1.1) 
			inc_scale=-0.001
			sunScale=1.1
		elseif (sunScale<0.9)
			inc_scale=0.001
			sunScale=0.9
		endif		
		for i=1 to 5
			SetSpriteColor(starSprites[random2(1,80)],random2(64,255), random2(64,255),0,255)
		next i	
		SetObjectRotation(sun3D,0,GetObjectAngleY(sun3D)+1,0)
		sync()
	until (GetObjectIsAnimating(animLogo3D)=0)
	texasoftTextID=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT,texasoftString,42,1)
	SetTextColorAlpha(texasoftTextID,0)
	vy=SCREEN2D_HEIGHT
	for i=1 to 255
		vy=vy-(SCREEN2D_HEIGHT/2)/255
		SetTextPosition(texasoftTextID,SCREEN2D_WIDTH/2,vy)
		SetTextColor(texasoftTextID,i,255-i,255-i,i)
		SetObjectRotation(sun3D,0,GetObjectAngleY(sun3D)+1,0)
		for j=1 to 5
			SetSpriteColor(starSprites[random2(1,80)],random2(64,255), random2(64,255),0,255)
		next j
		pausetime(0.01)
	next i	
	pauseClickTime(10)
	DeleteAllObjects()
	DeleteAllText()
	DeleteAllSprites()
	SetCameraFOV(1,70)
endfunction

function showFPSSplashScreen()
	fpsImage as integer
	fpsSprite as integer
	i as integer
	fpsImage=loadImage(IMAGES_FOLDER+"/fpsengine.png")
	fpsSprite=CreateSprite(fpsImage)
	SetSpriteOffset(fpsSprite,GetImageWidth(fpsImage)/2,GetImageHeight(fpsImage)/2)
	SetSpritePositionByOffset(fpsSprite,SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2)
	SetSpriteScaleByOffset(fpsSprite,0,0)
	for i=0 to 255
		SetSpriteColorAlpha(fpsSprite,i)
		SetSpriteScaleByOffset(fpsSprite,i/255.0,i/255.0)
		sync()
	next i	
	pauseClickTime(10)
	DeleteAllSprites()
endfunction	

function showTitle3D()
	camera_z as float
	camera_y as float
	title1ID as integer
	title2ID as integer
	title3ID as integer
	title1ID=LoadObject(OBJECTS_FOLDER+"/title1.obj",2.5)
	title2ID=LoadObject(OBJECTS_FOLDER+"/title2.obj",2)
	title3ID=LoadObject(OBJECTS_FOLDER+"/title3.obj",2.5)
	SetCameraFOV(1,70)
	SetCameraPosition(1, 0,30,-120)
	SetCameraLookAt(1,0,-25,0,0)
	SetObjectColor(title1ID,192,0,0,255)
	SetObjectColor(title2ID,0,128,255,255)
	SetObjectColor(title3ID,0,255,0,255)
	SetObjectPosition(title1ID,-12.5,2,0)
	SetObjectPosition(title2ID,-13,-5,0)
	SetObjectPosition(title3ID,-12.5,-10,0)
	SetObjectLightMode(title1ID,1)
	SetObjectLightMode(title2ID,1)
	SetObjectLightMode(title3ID,1)
	camera_z=-120
	camera_y=18
	repeat
		backImageScroll(0.009)
		SetCameraPosition(1,0,camera_y,camera_z)
		camera_z=camera_z+0.2
		if (camera_y>0) then camera_y=camera_y-0.02
	    sync()
	until (camera_z>-25)    
	pauseTime(1)
	pauseClickTime(20)
	deleteBackImage()
	DeleteObject(title1ID)
	DeleteObject(title2ID)
	DeleteObject(title3ID)	
	rem DeleteLightDirectional(1)
endfunction	

function showIntro()
	showLogo3D()
	showFPSSplashScreen()
	showTitle3D()
endfunction	

