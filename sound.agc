global gunShotSound as integer
global jumpSound as integer
global jumpDownSound as integer
global footstepsSound as integer
global explosionSound as integer
global clingSound as integer
global fightSceneMusic as integer
global swishingSound as integer
global ak47Sound as integer
global zombieSound as integer
global tankSound as integer
global laserSound as integer


function loadSounds()
	SetFolder(SOUNDS_FOLDER)
	gunShotSound=loadSound("gunshot.wav")
	jumpSound=loadSound("jump.wav")
	jumpDownSound=loadSound("jumpdown.wav")
	jumpDownSound=loadSound("jumpdown.wav")
	footstepsSound=LoadSound("footsteps.wav")
	explosionSound=LoadSound("explosion.wav")
	clingSound=LoadSound("cling.wav")	
	fightSceneMusic=LoadMusic("fightscene.mp3")
	swishingSound=LoadSound("swishing.wav")
	ak47Sound=LoadSound("ak47.wav")	
	zombieSound=LoadSound("zombie.wav")
	tankSound=LoadSound("tank.wav")	
	laserSound=LoadSound("laser.wav")	
endfunction

function stopLoopingSounds()
	if GetSoundsPlaying(ak47Sound)>0 then stopsound(ak47Sound)
	if GetSoundsPlaying(laserSound)>0 then stopsound(laserSound)
	if GetSoundsPlaying(explosionSound)>0 then stopsound(explosionSound)
endfunction
	
function getSound()
	select inventory[selected_inventory_index].category
		case CAT_INV_KNIFE:
			exitfunction swishingSound
		endcase
		case CAT_INV_BOMB:
			exitfunction swishingSound	
		endcase			
		case default:
			exitfunction gunShotSound
		endcase	
	endselect			
endfunction	gunShotSound	

function manageSound(soundID as integer)
	if (GetSoundInstancePlaying(soundID)=0)	
		PlaySound(soundID)
	endif
endfunction		
				
		
