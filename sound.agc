#constant SOUND_TYPE_NULL 0
#constant SOUND_TYPE_SOUND 1
#constant SOUND_TYPE_MUSIC 2
#constant SOUND_TYPE_NAME_SOUND "sound"
#constant SOUND_TYPE_NAME_MUSIC "music"

#constant SOUND_JSON_FILE_NAME "soundlist.json"

type soundStruct
	soundID as integer
	soundType as integer
	soundName as string
	soundFileName as string
endtype	

global sounds as soundStruct[]

function loadSounds()
	i as integer
	parseSoundJSON(SOUND_JSON_FILE_NAME)
	for i=0 to sounds.length
		select sounds[i].soundType
			case SOUND_TYPE_SOUND
				sounds[i].soundID=LoadSound(sounds[i].soundFileName)
			endcase
			case SOUND_TYPE_MUSIC
				sounds[i].soundID=LoadMusic(sounds[i].soundFileName)
			endcase
		endselect
	next i		
	//listSounds()	
endfunction

function getSoundByName(soundName as string)
	i as integer
	for i=0 to sounds.length
		if (sounds[i].soundType<>SOUND_TYPE_SOUND) then continue
		if (sounds[i].soundName=soundName)
			exitfunction sounds[i].soundID
		endif
	next i
endfunction 0			

function getMusicByName(musicName as string)
	i as integer
	for i=0 to sounds.length
		if (sounds[i].soundType<>SOUND_TYPE_MUSIC) then continue
		if (sounds[i].soundName=musicName)
			exitfunction sounds[i].soundID
		endif
	next i
endfunction 0			

	
function stopLoopingSounds(deleteFlag as integer)
	i as integer
	StopMusic()
	for i=0 to sounds.length
		select sounds[i].soundType
			case SOUND_TYPE_SOUND
				if (GetSoundsPlaying(sounds[i].soundID)>0) 
					 StopSound(sounds[i].soundID)
					 if (deleteFlag=1) then	deleteSound(sounds[i].soundID)
				endif		 
			endcase	
			case SOUND_TYPE_MUSIC
				if (deleteFlag=1) then	DeleteMusic(sounds[i].soundID)
			endcase
		endselect
	next i			
	if (deleteFlag=1) then sounds.length=-1	
endfunction
	
function getSound()
	retVal as integer
	select inventory[selected_inventory_index].category
		case CAT_INV_KNIFE:
			exitfunction getSoundByName("swishing")
		endcase
		case CAT_INV_BOMB:
			exitfunction getSoundByName("swishing")
		endcase			
		case default:
			exitfunction getSoundByName("gunShot")
		endcase	
	endselect		
	retVal=getSoundByName("gunShot")
endfunction	retVal	

function manageSound(soundID as integer)
	if (GetSoundsPlaying(soundID)=0)	
		PlaySound(soundID)
	endif
endfunction		
				
function parseSoundJSON(jsonFilePath as string)
	soundClassName as string
	soundClass as integer
	jsonFileID as integer
	line as string
	numTokens as integer
	inObject as integer
	name as string
	value as string
	newSound as soundStruct
	tipo as string 
	SetFolder(SOUNDS_FOLDER)
	//print_debug("ciao"+jsonFilePath+SOUNDS_FOLDER)
	if (GetFileExists(jsonFilePath)=0)
		 exitfunction -1
    endif
    jsonFileID=OpenToRead(jsonFilePath)
    while (FileEOF(jsonFileID)=0)
		line=ReadLine(jsonFileID)
		numTokens=CountStringTokens(line,chr(34))
		select numTokens
			case 1
			endcase
			case 3
				soundClassName=getStringToken(line,chr(34),2)
				select soundClassName
					case SOUND_TYPE_NAME_SOUND
						soundClass=SOUND_TYPE_SOUND
					endcase
					case SOUND_TYPE_NAME_MUSIC
						soundClass=SOUND_TYPE_MUSIC
					endcase
					case default
						soundClass=SOUND_TYPE_NULL
					endcase
				endselect
			endcase
			case 4,5
				newSound.soundID=0
				newSound.soundName=GetStringToken(line,chr(34),2)
				newSound.soundFileName=GetStringToken(line,chr(34),4)
				newSound.soundType=soundClass
				sounds.insert(newSound)
				clearSound(newSound)
			endcase		
		endselect			
	endwhile	
	CloseFile(jsonFileID)	
endfunction 0
		
function clearSound(newSound ref as soundStruct)
	newSound.soundID=0
	newSound.soundName=""
	newSound.soundFileName=""
	newSound.soundType=SOUND_TYPE_NULL
endfunction		

function listSounds()
	i as integer
	do
		print(str(sounds.length))
		for i=0 to sounds.length
			print(str(i)+" <"+sounds[i].soundName+"> "+str(sounds[i].soundID)+" "+sounds[i].soundFileName+" "+str(sounds[i].soundType))
		next i
		sync()
	loop	
endfunction
