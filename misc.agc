#constant UNLOCKFILENAME "unlock.txt"
function checkLevels()
	index as integer
	unlockFileID as integer
	worldList as String[]
	nextFile as string
	unlockWorld as string
	SetFolder("")
	if (GetFileExists(UNLOCKFILENAME)=0) 
		unlockFileID=OpenToWrite(UNLOCKFILENAME)
		WriteString(unlockFileID,"1")
		CloseFile(unlockFileID)
		unlockWorld="1"
	else	
		unlockFileID=OpenToRead(UNLOCKFILENAME)
		unlockWorld=ReadString(unlockFileID)
		CloseFile(unlockFileID)
	endif
	SetFolder(WORLDS_FOLDER)
	nextFile=GetFirstFile()	
	while (nextFile<>"")
		if (FindString(nextFile,"world"+str(TRAINING_LEVEL))=0)
			worldList.insert(nextFile)
		endif	
		nextFile=GetNextFile()
	endwhile	
	worldList.insert(unlockWorld)
	worldList.reverse()
endfunction	worldList

function doUnlockWorld(uw as integer)
	index as integer
	unlockFileID as integer
	worldList as String[]
	nextFile as string
	unlockWorld as string
	SetFolder("")
	if (GetFileExists(UNLOCKFILENAME)=1) 
		unlockFileID=OpenToRead(UNLOCKFILENAME)
		unlockWorld=ReadString(unlockFileID)
		CloseFile(unlockFileID)
	endif
	if (val(unlockWorld)<uw)
		unlockFileID=OpenToWrite(UNLOCKFILENAME)
		WriteString(unlockFileID,str(uw))
		CloseFile(unlockFileID)
	endif	
endfunction	
	
	
	
