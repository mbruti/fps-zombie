#constant KEY_LEFT	37
#constant KEY_UP	38
#constant KEY_RIGHT	39
#constant KEY_DOWN	40
#constant KEY_SPACE	32
#constant NUM_VIRTUAL_BTNS 12

function inputKeyboard()
	retString as String = "" 
	if (GetRawKeyState(KEY_UP)) 
		retString="UP"
	elseif (GetRawKeyState(KEY_DOWN)) 
		retString="DOWN"
	elseif (GetRawKeyState(KEY_RIGHT)) 
		retString="RIGHT"
	elseif (GetRawKeyState(KEY_LEFT)) 
		retString="LEFT"
    elseif (GetRawKeyState(KEY_SPACE)) 
		retString="SPACE"
    endif
endfunction retString	

function inputVirtualJoystick()
	retString as String = "" 
	if (GetVirtualJoystickY(1)<-0.5) 
		retString=retString+"UP"
	endif
	if (GetVirtualJoystickY(1)>0.5) 
		retString="DOWN"
	endif
	if (GetVirtualJoystickX(1)<-0.5) 
		retString=retString+"LEFT"
	endif
	if (GetVirtualJoystickX(1)>0.5) 
		retString=retString+"RIGHT"
	endif
endfunction retString	

function inputVirtualButton()
	i as integer
	for i=1 to NUM_VIRTUAL_BTNS
	   if (GetVirtualButtonExists(i))
		   if (GetVirtualButtonState(i))
			   exitfunction i
		   endif
	   endif
	next    	   	   
endfunction 0	

function createVirtualJoystick(id as integer, x as float, y as float)
	AddVirtualJoystick( id, x, y, 128 )
endfunction	

function createVirtualButton(id as integer, x as float, y as float,w as float,caption as string)
	AddVirtualButton(id,x,y,w)
    SetVirtualButtonText(id,caption)
endfunction	


	
