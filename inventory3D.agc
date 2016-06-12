#constant TRAJECTORY_STRAIGHT 0
#constant TRAJECTORY_PARABOLIC 1

#constant CAT_INV_GUN	0
#constant CAT_INV_BOMB	1
#constant CAT_INV_KNIFE	2
#constant CAT_INV_LIFE	3
#constant CAT_INV_MEDIKIT	4
#constant CAT_INV_KEY	5


global inventory as Inventario3D[]
global inventoryAtlasImageID as integer
global inventoryImageID as integer[]

global selected_inventory_index as integer
global life_inventory_index as integer

type Inventario3D
	name as string
	imageID as integer
	atlasImageID as integer
	atlas as string
	seqNum as integer
	spriteID as integer
	w as integer
	h as integer
	available as integer
	ammo as integer
	infoTextID as integer
	range as float
	trajectory as integer
	yStep as float
	category as integer
	speed as float
endtype

function clearInventory3D(ogginv3D ref as Inventario3D)
	ogginv3D.name=""
	ogginv3D.imageID=0
	ogginv3D.atlasImageID=0
	ogginv3D.seqNum=0	
	ogginv3D.spriteID=-1	
	ogginv3D.w=0	
	ogginv3D.h=0	
	ogginv3D.available=0
	ogginv3D.ammo=0
	ogginv3D.infoTextID=0
	ogginv3D.range=0
	ogginv3D.trajectory=0
	ogginv3D.yStep=0
	ogginv3D.category=0
	ogginv3D.speed=0	
endfunction	

function populateInventario3D(ogginv3D ref as Inventario3D,tipo as string, value as string)
	select tipo
		case 'atlas'
			ogginv3D.atlas=value
		endcase	
		case 'seqNum'
			ogginv3D.seqNum=Val(value)
		endcase	
		case 'available'
			ogginv3D.available=Val(value)
		endcase
		case 'ammo'
			ogginv3D.ammo=Val(value)
		endcase
		case 'range'
			ogginv3D.range=ValFloat(value)
		endcase
		case 'yStep'
			ogginv3D.yStep=ValFloat(value)
		endcase
		case 'speed'
			ogginv3D.speed=ValFloat(value)
		endcase
		case 'trajectory'
			select value
				case "straight"
					ogginv3D.trajectory=TRAJECTORY_STRAIGHT
				endcase
				case "parabolic"
					ogginv3D.trajectory=TRAJECTORY_PARABOLIC
				endcase
			endselect
		endcase
		case 'category'
			select value
				case "gun"
					ogginv3D.category=CAT_INV_GUN
				endcase
				case "bomb"
					ogginv3D.category=CAT_INV_BOMB
				endcase
				case "knife"
					ogginv3D.category=CAT_INV_KNIFE
				endcase
				case "life"
					ogginv3D.category=CAT_INV_LIFE
				endcase
				case "medikit"
					ogginv3D.category=CAT_INV_MEDIKIT
				endcase
				case "key"
					ogginv3D.category=CAT_INV_KEY
				endcase
			endselect
		endcase
	endselect	
endfunction		

function parseInventoryJSON(inv3D ref as Inventario3D[], jsonFilePath as string)
	jsonFileID as integer
	line as string
	numTokens as integer
	inObject as integer
	name as string
	value as string
	newObject as Inventario3D
	tipo as string 
	clearInventory3D(newObject)
	SetFolder(INVENTORIES_FOLDER)
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
				newObject.name=GetStringToken(line,chr(34),2)
			endcase
			case 5
				tipo=GetStringToken(line,chr(34),2)
				value=GetStringToken(line,chr(34),4)
				populateInventario3D(newObject,tipo,value)
			endcase		
			case 4
    			tipo=GetStringToken(line,chr(34),2)
				value=GetStringToken(line,chr(34),4)
				populateInventario3D(newObject,tipo,value)
				inv3D.insert(newObject)
				clearInventory3D(newObject)
			endcase
		endselect			
	endwhile	
	CloseFile(jsonFileID)	
endfunction 0

function createInventory(jsonFile as string, atlasFile as string, imgWidth as integer, imgHeight as integer)
	i as integer
	numImages as integer
	atlasImgWidth as integer
	atlasImgHeight as integer
	deleteInventory3D(1)
	SetFolder(INVENTORIES_FOLDER)
	if (GetImageExists(inventoryAtlasImageID)=0) then inventoryAtlasImageID=LoadImage(atlasFile)
	atlasImgWidth=GetImageWidth(inventoryAtlasImageID)
	atlasImgHeight=GetImageHeight(inventoryAtlasImageID)
	numImages=(atlasImgWidth/imgWidth)*(atlasImgHeight/imgHeight)
	for i=0 to numImages-1
		inventoryImageID.insert(LoadSubImage(inventoryAtlasImageID,"obj"+str(i)))
	next i
	if (parseInventoryJSON(inventory,jsonFile)=-1) 
		end
		exitfunction -1
	endif	
	for i=0 to inventory.length
		inventory[i].atlasImageID=inventoryAtlasImageID
		inventory[i].imageID=inventoryImageID[inventory[i].seqNum]
		inventory[i].w=imgWidth
		inventory[i].h=imgHeight
		if (inventory[i].category<>CAT_INV_KEY) and(inventory[i].category<>CAT_INV_LIFE) and (inventory[i].category<>CAT_INV_MEDIKIT) and (inventory[i].available=1)
			selected_inventory_index=i
		endif	
	next i	
endfunction 0

function findInventoryBySpriteID(inv3D as Inventario3D[],spriteID as integer)
	i as integer
	for i=0 to inv3D.length
		if (inv3D[i].spriteID=spriteID)
			exitfunction i
		endif
	next i
endfunction -1	

function findInventoryByName(inv3D as Inventario3D[],name as string)
	i as integer
	for i=0 to inv3D.length
		if (inv3D[i].name=name)
			exitfunction i
		endif
	next i
endfunction -1

function displayInventory3D()
	i as integer
	yPos as integer
	yPos=0
	for i=0 to inventory.length
		if (inventory[i].available=1) 
			if not getSpriteExists(inventory[i].spriteID)
				inventory[i].spriteID=createSprite(inventory[i].imageID)
				SetSpritePosition(inventory[i].spriteID,SCREEN2D_WIDTH-inventory[i].w,yPos)
				if (i=selected_inventory_index)
					SetSpriteColor(inventory[i].spriteID,255,255,255,255)
				elseif (inventory[i].category=CAT_INV_LIFE)	
					SetSpriteColor(inventory[i].spriteID,0,255,0,255)
				elseif (inventory[i].category=CAT_INV_KEY)	
					SetSpriteColor(inventory[i].spriteID,128,255,0,255)	
				elseif (inventory[i].category=CAT_INV_MEDIKIT) and 	(inventory[i].ammo>0)
					SetSpriteColor(inventory[i].spriteID,255,0,0,255)
				else	
					SetSpriteColor(inventory[i].spriteID,0,0,0,255)
				endif		
			endif
			if (GetTextExists(inventory[i].infoTextID)=0)
				inventory[i].infoTextID=CreateText(str(inventory[i].ammo))
				SetTextSize(inventory[i].infoTextID,32)
				SetTextAlignment(inventory[i].infoTextID,2)
				SetTextPosition(inventory[i].infoTextID,SCREEN2D_WIDTH-inventory[i].w,yPos)
			else
				SetTextString(inventory[i].infoTextID,str(inventory[i].ammo))
				if (inventory[i].ammo<=1000) and (inventory[i].ammo>=0) and (inventory[i].category=CAT_INV_LIFE)
					SetSpriteColor(inventory[i].spriteID,255-(inventory[i].ammo/4),inventory[i].ammo/4,0,255) 
				endif	
			endif	
			yPos=yPos+inventory[i].h
		endif
	next
endfunction		

function deleteInventory3D(clearAllFlag as integer)
	i as integer
	for i=0 to inventory.length
		if (GetSpriteExists(inventory[i].spriteID)=1) then DeleteSprite(inventory[i].spriteID)
		if (GetTextExists(inventory[i].infoTextID)=1) then DeleteText(inventory[i].infoTextID)
	next i
	if (clearAllFlag=1)
		inventory.length=-1
		inventoryImageID.length=-1
		//if (GetImageExists(inventoryAtlasImageID)=1) then DeleteImage(inventoryAtlasImageID)
	endif	
endfunction		

function changeCurrentInventory(old_index as integer,new_index as integer)
	clonePosRot3D(oggetti3D[old_index],oggetti3D[new_index])
	oggetti3D[old_index].status=STATUS_HIDDEN
    SetObjectVisible(oggetti3D[old_index].ID,0)
    oggetti3D[new_index].status=STATUS_IDLE
    SetObjectVisible(oggetti3D[new_index].ID,1)
endfunction		
		
