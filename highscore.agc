#constant HINUMITEMS 10 
#constant LOCALFILENAME "fpszombiehi_local.dat"
global hi_local as hiScoreType[HINUMITEMS]
global hi_global as hiScoreType[HINUMITEMS]

type hiScoreType 
	hiScore as integer
	hiInitials as string
	hiLevel as integer
endtype

function checkNewHiLocal(newScore as integer)
	if (hi_local[HINUMITEMS].hiScore>=newScore)
		exitfunction 0	
	endif 
endfunction	1

function checkNewHiGlobal(newScore as integer)
	internetLastHiString as string
	currentHiString as string
	entryHiString as string
	agkHTTPConnection as integer
	if (GetInternetState()=0) then exitfunction -1
	agkHTTPConnection=CreateHTTPConnection()
	SetHTTPHost(agkHTTPConnection,INTERNET_HOST,0)
	internetLastHiString=SendHTTPRequest(agkHTTPConnection,"fpszombie/fpszombiehi.php?action=last")
	closeHTTPConnection(agkHTTPConnection)     
	if (newScore>val(internetLastHiString)) then exitfunction 1
endfunction	0	

function clearHi(h1 ref as hiScoreType[])
	i as integer
	for i=1 to HINUMITEMS
		h1[i].hiScore=0
	    h1[i].hiInitials="FPS"
	    h1[i].hiLevel=0
	next      
endfunction

function insertNewHiLocal(newScore as integer, initials as string, lv as integer)
	 i as integer
	 tempScore as integer
	 tempInitials as string
	 tempLevel as integer
	 hi_local[HINUMITEMS].hiScore=newScore
	 hi_local[HINUMITEMS].hiInitials=initials
	 hi_local[HINUMITEMS].hiLevel=lv
	 for i=HINUMITEMS-1 to 1 step -1
		 if (hi_local[i].hiScore<hi_local[i+1].hiScore)
			 tempScore=hi_local[i].hiScore
			 tempInitials=hi_local[i].hiInitials
			 tempLevel=hi_local[i].hiLevel
			 hi_local[i].hiScore=hi_local[i+1].hiScore
	         hi_local[i].hiInitials=hi_local[i+1].hiInitials
	         hi_local[i].hiLevel=hi_local[i+1].hiLevel
	         hi_local[i+1].hiScore=tempScore
	         hi_local[i+1].hiInitials=tempInitials
	         hi_local[i+1].hiLevel=tempLevel 
	     endif
	 next        
endfunction	1

function insertNewHiGlobal(newScore as integer, initials as string, lv as integer)
	internetReturnString as string
	currentHiString as string
	entryHiString as string
	agkHTTPConnection as integer
	if (GetInternetState()=0) then exitfunction -1
	agkHTTPConnection=createHTTPConnection()
    setHTTPHost(agkHTTPConnection,INTERNET_HOST,0)
    sendHTTPRequestAsync( agkHTTPConnection, "/fpszombie/fpszombiehi.php?action=insert&scorename="+encodeURL(initials)+"&scorepoints="+str(newScore)+"&level="+str(lv),"pass=bO5SW03D")
    while (GetHTTPResponseReady(agkHTTPConnection)=0)
           print("Updating...")
           sync()
    endwhile
    internetReturnString = GetHTTPResponse(agkHTTPConnection)
    closeHTTPConnection(agkHTTPConnection)      
endfunction	1

function displayHi(h1 as hiScoreType[])
	i as integer
	cw as integer
	unlockWorld as integer
	hiText as integer[]
	backImageScroll(0)
	for i=0 to h1.length
		if (i=0)
			hiText.insert(createText("NUM      INI        SCORE       LEV"))
			SetTextColor(hiText[i],GetColorRed3D(DARKBLUE),GetColorGreen3D(DARKBLUE),GetColorBlue3D(DARKBLUE),255)
		else	
			hiText.insert(createText("#"+padZero(i,2)+" ---- "+padSpace(h1[i].hiInitials,3)+" ---- "+padZero(h1[i].hiScore,8)+" ---- "+padZero(h1[i].hiLevel,3)))
			SetTextColor(hiText[i],GetColorRed3D(WHITE),GetColorGreen3D(WHITE),GetColorBlue3D(WHITE),255)
		endif	
		SetTextSize(hiText[i],48)
		SetTextAlignment(hiText[i],0)
	    SetTextPosition(hiText[i],100,i*50)
	next i
	messageBox(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-172,"Press ok to exit...",48)
	deleteEverything()
endfunction	

function loadLocalHi()
	fileID as integer
	i as integer
	j as integer
	hiString as string
	SetFolder("")
	if (not GetFileExists(LOCALFILENAME)=1)
		fileID=OpenToWrite(LOCALFILENAME)
		for i=1 to HINUMITEMS
			WriteLine(fileID,"FPS,0,0")
		next i
		closeFile(fileID)
	endif
	fileID=OpenToRead(LOCALFILENAME)
	for i=1 to HINUMITEMS
		hiString=ReadLine(fileID)
		for j=1 to CountStringTokens(hiString,",")
			select j
				case 1
					hi_local[i].hiInitials=GetStringToken(hiString,",",j)
				endcase
				case 2
					hi_local[i].hiScore=val(GetStringToken(hiString,",",j))
				endcase
				case 3
					hi_local[i].hiLevel=val(GetStringToken(hiString,",",j))
				endcase	
			endselect
		next j
	next i	
	closeFile(fileID)
endfunction		

function saveLocalHi()
	fileID as integer
	i as integer
	j as integer
	hiString as string
	SetFolder("")
	if (not GetFileExists(LOCALFILENAME)=1)
		fileID=OpenToWrite(LOCALFILENAME,0)
		for i=1 to HINUMITEMS
			WriteLine(fileID,"FPS,0,0")
		next i
		closeFile(fileID)
	endif
	fileID=OpenToWrite(LOCALFILENAME,0)
	for i=1 to HINUMITEMS
		WriteLine(fileID,hi_local[i].hiInitials+","+str(hi_local[i].hiScore)+","+str(hi_local[i].hiLevel))
	next i	
	closeFile(fileID)
endfunction		


function loadGlobalHi()
	i as integer
	internetHiString as string
	currentHiString as string
	entryHiString as string
	agkHTTPConnection as integer
	if (GetInternetState()=0) then exitfunction -1
	agkHTTPConnection=CreateHTTPConnection()
	SetHTTPHost(agkHTTPConnection,INTERNET_HOST,0)
	internetHiString=SendHTTPRequest(agkHTTPConnection,"fpszombie/fpszombiehi.php?action=list")
	closeHTTPConnection(agkHTTPConnection)     
	if len(internetHiString)<=0 then exitfunction -1
	if (left(internetHiString,1)<>"/") then exitfunction -1
	currentHiString=internetHiString
	for i=1 to HINUMITEMS
		entryHiString=GetStringToken(currentHiString,"/",1)
		hi_global[i].hiInitials=GetStringToken(entryHiString,"@",1)
		hi_global[i].hiScore=val(GetStringToken(entryHiString,"@",2))
		hi_global[i].hiLevel=val(GetStringToken(entryHiString,"@",3))
		currentHiString=right(currentHiString,len(currentHiString)-len(entryHiString)-2)
	next i
	remstart	
	do
	   	print("iniziali "+hi_global[2].hiInitials+" "+str(hi_global[2].hiScore))
	   	print(currentHiString)		
	   print(internetHiString)
	   sync()
	loop   
	remend
endfunction 0			

function inputNewInitials()
	i as integer
	hit as integer
	color as integer
	counter as integer
	titleText as integer
	particleID as integer
	dim initialsInput[3] as string = ["A","A","A"]
	dim initialsCursor[3] as integer = [1,1,1]
	retString as string
	randomAngle as float
	initialsText as integer[3]
	alphabet as string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_ "
	for i=0 to 2 
		initialsText[i]=CreateText(initialsInput[i])
		SetTextSize(initialsText[i],128)
		SetTextColor(initialsText[i],0,128,64,255)
		SetTextAlignment(initialsText[i],1)
		SetTextPosition(initialsText[i],SCREEN2D_WIDTH/2+(i-1)*100,SCREEN2D_HEIGHT/2-100)
		SetTextDepth( initialsText[i], 0 ) 
	next i
	AddVirtualButton(1, SCREEN2D_WIDTH/2, SCREEN2D_HEIGHT/2+256,96)
	SetVirtualButtonText(1,"OK")
	SetVirtualButtonSize(1,128)
	color=MakeColor(255,128,128)	
	titleText=printText(SCREEN2D_WIDTH/2,50,"Insert your initials...",64,1)
	particleID=CreateParticles(SCREEN2D_WIDTH/2,0)
	SetParticlesSize(particleID,10.0)
	SetParticlesLife(particleID,10.0)
	SetParticlesFrequency(particleID,10)
	SetParticlesDirection(particleID,0,10)
	SetParticlesAngle(particleID,120)
	SetParticlesVelocityRange(particleID,20,40)
	SetParticlesRotationRange(particleID,0,360)
	SetParticlesImage(particleID,starImage)
	randomAngle=30
	while (GetVirtualButtonState(1)=0)		
		DrawBox(SCREEN2D_WIDTH/2-136, SCREEN2D_HEIGHT/2-100,SCREEN2D_WIDTH/2+136, SCREEN2D_HEIGHT/2+16,0x00FFFF,0xFF8040,0x0000FF,0x808000,0)
		if (GetPointerPressed()=1)
			for i=0 to 2
				hit=GetTextHitTest(initialsText[i],GetPointerX(),GetPointerY())
				if (hit=1)
					inc initialsCursor[i]
					if  (initialsCursor[i]>len(alphabet)) then initialsCursor[i]=1
					initialsInput[i]=mid(alphabet,initialsCursor[i],1)
					SetTextString(initialsText[i],initialsInput[i])
				endif	
			next i		
		endif	
		randomAngle=random(30,150)
		DrawLine(SCREEN2D_WIDTH/2,0,SCREEN2D_WIDTH/2+SCREEN2D_HEIGHT/tan(randomAngle),SCREEN2D_HEIGHT,random(0,255),random(0,255),random(0,255))
		backImageScroll(0.005)	
		sync()
	endwhile
	DeleteVirtualButton(1)
	DeleteParticles(particleID)
	DeleteAllText()	
	deleteBackImage()
	retString=initialsInput[0]+initialsInput[1]+initialsInput[2]
endfunction retString

function manageNewHi(newScore as integer, newWorld as integer)
	isNewLocalHiFlag as integer
	isNewGlobalHiFlag as integer
	newInitials as string
	isNewLocalHiFlag=checkNewHiLocal(newScore)
	isNewGlobalHiFlag=checkNewHiGlobal(newScore)
	if (isNewLocalHiFlag=1) 
		messageBox(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,"Congrats! New local high score!",48)
	endif
	if (isNewGlobalHiFlag=1) 
		messageBox(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT/2,"Congrats! New Internet high score!",48)
	endif
	if (isNewLocalHiFlag=1) or (isNewGlobalHiFlag=1) 
		deleteEverything()
		newInitials=inputNewInitials()
	endif	
	if (isNewLocalHiFlag=1) 
		insertNewHiLocal(newScore,newInitials,newWorld)
		saveLocalHi()
	endif
	if (isNewGlobalHiFlag=1) 
		insertNewHiGlobal(newScore,newInitials,newWorld)
	endif
endfunction


