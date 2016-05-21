global mirinoImage as integer
global arrowImage as integer
global hitScreenImage as integer
global hitShieldScreenImage as integer
global shieldImage as integer
global starImage as integer
global zombieBackgroundImage as integer

function LoadImages()
	zombieBackgroundImage=LoadImage(IMAGES_FOLDER+"/zombie_back.png")
	starImage=LoadImage(IMAGES_FOLDER+"/star.png")
	arrowImage=LoadImage(IMAGES_FOLDER+"/green_arrow.png")
    mirinoImage=LoadImage(IMAGES_FOLDER+"/mirino.png")
    hitScreenImage=LoadImage(IMAGES_FOLDER+"/hitscreen.png")
    hitShieldScreenImage=LoadImage(IMAGES_FOLDER+"/hitshieldscreen.png") 
    shieldImage=LoadImage(IMAGES_FOLDER+"/flames.png")
    arrowImage=LoadImage(IMAGES_FOLDER+"/green_arrow.png")
    soundSpriteSheet=LoadImage(IMAGES_FOLDER+"/soundspritesheet.png")
	soundOffImage=LoadSubImage(soundSpriteSheet,"soundoff.png")
    soundOnImage=LoadSubImage(soundSpriteSheet,"soundon.png")
    pauseSpriteSheet=LoadImage(IMAGES_FOLDER+"/pausespritesheet.png")
	pauseImage=LoadSubImage(pauseSpriteSheet,"pause.png")
    playImage=LoadSubImage(pauseSpriteSheet,"play.png")
    backImage=LoadSubImage(pauseSpriteSheet,"back.png")
endfunction    
