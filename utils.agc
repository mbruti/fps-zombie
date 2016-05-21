#constant allSpaces "________________________________________"
#constant allBlanks "                                        "

global aspect# as float
global corniceImg as integer
global logFileID as integer

logFileID=0

function getDistanceVectorX(x1# as float,y1# as float,x2# as float,y2# as float)
   vx# as float
   vectorLength# as float
   vectorLength#=sqrt((x2#-x1#)^2+(y2#-y1#)^2)
   if (vectorLength#=0) then exitfunction 0.0
   vx#=(x2#-x1#)/vectorLength#
endfunction vx#

function getDistanceVectorY(x1# as float,y1# as float,x2# as float,y2# as float)
   vy# as float
   vectorLength# as float
   vectorLength#=sqrt((x2#-x1#)^2+(y2#-y1#)^2)
   if (vectorLength#=0) then exitfunction 0.0
   vy#=(y2#-y1#)/vectorLength#
endfunction vy#

function getDistanceVector(x1# as float,y1# as float,x2# as float,y2# as float)
   vectorLength# as float
   vectorLength#=sqrt((x2#-x1#)^2+(y2#-y1#)^2)
endfunction vectorLength#

function getVelocity(spr as integer)
   v# as float
   v#=sqrt(getSpritePhysicsVelocityX(spr)^2+getSpritePhysicsVelocityY(spr)^2)
endfunction v#

function searchChar(s$ as string, key$ as string, index as integer)
i as integer
a$ as string
for i=index to len(s$)
    a$=mid(s$,i,1)
    if (a$=key$)
       exitfunction i
    endif
next i
endfunction 0

function searchString(s$ as string, key$ as string, index as integer)
i as integer
a$ as string
for i=index to len(s$)
    a$=mid(s$,i,len(key$))
    rem print(a$)
    if (a$=key$)
       exitfunction i
    endif
next i
endfunction 0

function strbegins(s$ as string, key$ as string)
   if (mid(s$,1,len(key$))=key$) then exitfunction 1
endfunction 0

function sign(x#)
   if (x#<0)
      exitfunction -1
   elseif (x#>0)
      exitfunction 1
   endif
endfunction 0

function pauseTime(secs# as float)
   startTime# as float
   startTime#=timer()
   while (timer()<(startTime#+secs#))
      sync()
   endwhile
endfunction

function pauseClickTime(secs# as float)
   startTime# as float
   ps as integer
   startTime#=timer()
   ps=getPointerState()
   while (timer()<(startTime#+secs#)) and (ps=0)
      sync()
      ps=getPointerState()
   endwhile
endfunction ps


function pause()
   while (getPointerState()=0)
      sync()
   endwhile
endfunction

function padZero(numToDisplay,numZeroes)
   #constant scoreZero "0000000000"
   s$ as String
   s$=left(scoreZero, numZeroes-len(str(numToDisplay)))+str(numToDisplay)
endfunction s$

function padSpaceRight(stringToDisplay$,numSpaces)
   s$ as String
   s$=stringToDisplay$+left(allBlanks, numSpaces-len(stringToDisplay$))
endfunction s$

function padSpace(stringToDisplay$,numSpaces)
   s$ as String
   s$=left(allSpaces, numSpaces-len(stringToDisplay$))+stringToDisplay$
endfunction s$

function strTime(floatTime#,zeroPadding)
   td as integer
   retString$ as string
   td=floor((floatTime#-floor(floatTime#))*1000.0)
   retString$=left(multiplyString("0",zeroPadding), zeroPadding-len(str(floor(floatTime#))))+str(floor(floatTime#))+"."+left("000", 3-len(str(td)))+str(td)
endfunction retString$

function multiplyString(s$,n)
   i as integer
   retString$ as string
   retString$=""
   for i=1 to n
    retString$=retString$+s$
   next i
endfunction retString$

function showHelpWindow(editBoxId,ebx,eby,windowText$)
   i as integer
   screenX as integer
   lcdfontImg as integer
   if (getEditBoxExists(editBoxId)=0)
      createEditBox(editBoxId)
      setEditBoxFontImage(editBoxId,lcdfontImg)
      setEditBoxActive(editBoxId,0)
      setEditBoxBorderColor(editBoxId,128,128,128,255)
      setEditBoxBorderSize(editBoxId,4)
      setEditBoxMultiLine(editBoxId,1)
      setEditBoxMaxLines(editBoxId,0)
      setEditBoxMaxChars(editBoxId,0)
      setEditBoxText(editBoxId,windowText$)
      setEditBoxSize(editBoxId,screenX/2,400)
      setEditBoxPosition(editBoxId,ebx,eby)
   endif
endfunction

function deleteHelpWindow(editBoxId)
   if (getEditBoxExists(editBoxId)=1)
      deleteEditBox(editBoxId)
   endif
endfunction

function print_debug(s$)
setprintcolor(255,255,255)
setprintsize(32)
while (getPointerState()=0)
      print("")
      print(s$)
      sync()
endwhile
endfunction

function wrapValue(a as float)
   if (a>360)
      a=fmod(a,360)
   elseif (a<0)
      a=360-fmod(abs(a),360)
   endif
endfunction a

function checkDrag()
   startx as float
   starty as float
   endx as float
   endy as float
   start_time as float
   startx=getPointerX()
   starty=getPointerY()
   endx=startx
   endy=starty
   if (getPointerState()=0) then exitfunction 0
   start_time=timer()
   while (getPointerState()=1) and ((timer()-start_time)<0.5)
      rem print("pointer state "+str(getPointerState()))
      endx=getPointerX()
      endy=getPointerY()
      sync()
   endwhile
endfunction 1

function enterName()
   editBoxId as integer
   enterTextId as integer
   textInput$ as string
   enterTextId=createText("Enter your name (max 16 chars):")
   setTextSize(enterTextId,8)
   setTextAlignment(enterTextId,1)
   setTextPosition(enterTextId,50,20)
   setTextColor(enterTextId,255,128,0,255)
   editBoxId=createEditBox()
   SetEditBoxMaxChars( editBoxId,16 )
   SetEditBoxPosition( editBoxId,15,40 )
   SetEditBoxSize( editBoxId,75,10 )
   remstart
   SetTextInputMaxChars(16)
   startTextInput()
   while (getTextInputCompleted()=0)
      sync()
   endwhile
   textInput$=getTextInput()
   remend
   while (getEditBoxChanged(editBoxId)=0)
   sync()
   endwhile
   textInput$=getEditBoxText(editBoxId)
   deleteEditBox(editBoxId)
   deleteText(enterTextId)
endfunction textInput$

function encodeURL(s$)
   newString$ as string
   c$ as string
   enc_c$ as string
   i as integer
   newString$=""
   for i=1 to len(s$)
      c$=mid(s$,i,1)
      select c$
         case "$"
            enc_c$="%24"
         endcase
         case "&"
            enc_c$="%26"
         endcase
         case "+"
            enc_c$="%2B"
         endcase
         case ","
            enc_c$="%2C"
         endcase
         case "/"
            enc_c$="%2F"
         endcase
         case ":"
            enc_c$="%3A"
         endcase
         case ";"
            enc_c$="%3B"
         endcase
         case "="
            enc_c$="%3D"
         endcase
         case "?"
            enc_c$="%3F"
         endcase
         case "@"
            enc_c$="%40"
         endcase
         case " "
            enc_c$="%20"
         endcase
         case "<"
            enc_c$="%3C"
         endcase
         case ">"
            enc_c$="%3E"
         endcase
         case "#"
            enc_c$="%23"
         endcase
         case "%"
            enc_c$="%25"
         endcase
         case default
            enc_c$=c$
         endcase
      endselect
      if (enc_c$=chr(34)) then enc_c$=""
      newString$=newString$+enc_c$
   next i
endfunction  newString$

function init_aspect()
	w# as float
	h# as float
    w# = getVirtualWidth()
    h# = getVirtualHeight()
    if w#=100.0 and h#=100.0
        aspect# = getDisplayAspect()
    else
        aspect# = 1.0
    endif
endfunction

function spriteToWorldX(spr,x#,y#)
	a# as float
	ox# as float
	dx# as float
	wx# as float
    a# = getSpriteAngle(spr)
    ox# = getSpriteXbyOffset(spr)
    dx# = cos(a#) * x# - sin(a#) * y#
    wx# = ox# + dx#
endfunction wx#

function spriteToWorldY(spr,x#,y#)
	a# as float
	oy# as float
	dy# as float
	wy# as float
    a# = getSpriteAngle(spr)
    oy# = getSpriteYByOffset(spr)
    dy# = sin(a#) * x# + cos(a#) * y#
    wy# = oy# + dy# * aspect#
endfunction wy#

function initWindows()
   corniceImg=loadImage("cornice.png")
   if (corniceImg<1) then corniceImg=0
endfunction

rem menu 3 choices
function menuBox3(menuX# as float, menuY# as float,caption$ as string,choice1$ as String, choice2$ as String,choice3$ as String, textSize as integer)
   retVal as integer
   textOver as integer
   textPressed as integer
   menuBackSpriteId as integer
   captionTextId as integer
   text1Id as integer
   text2Id as integer
   text3Id as integer
   captionId as integer
   textSeparatorId as integer
   TextSeparatorLength# as float
   Text1Length# as float
   Text2Length# as float
    Text3Length# as float
    captionLength# as float
   totalLength# as float
   totalWidth# as float
   totalHeight# as float
   pointerX# as float
   pointerY# as float
   menuBackSpriteId=createSprite(corniceImg)
   text1Id=createText(choice1$)
   text2Id=createText(choice2$)
   text3Id=createText(choice3$)
   captionId=createText(caption$)
   fixSpriteToScreen(menuBackSpriteId,1)
   fixTextToScreen(text1Id,1)
   fixTextToScreen(text2Id,1)
   fixTextToScreen(text3Id,1)
   fixTextToScreen(captionId,1)
   textSeparatorId=createText("  ")
   setTextSize(text1Id,textSize)
   setTextSize(text2Id,textSize)
   setTextSize(text3Id,textSize)
   setTextSize(captionId,textSize)
   setTextSize(textSeparatorId,textSize)
   setTextVisible(textSeparatorId,0)
   setTextColor(text1Id,0,0,255,255)
   setTextColor(text2Id,0,0,255,255)
   setTextColor(text3Id,0,0,255,255)
   setTextColor(captionId,0,128,0,255)
   text1Length#=getTextTotalWidth(text1Id)
   text2Length#=getTextTotalWidth(text2Id)
   text3Length#=getTextTotalWidth(text3Id)
   captionLength#=getTextTotalWidth(captionId)
   textSeparatorLength#=getTextTotalWidth(textSeparatorId)
   totalLength#=max2(text1Length#+text2Length#+text3Length#+textSeparatorLength#*4,captionLength#+textSeparatorLength#*2)
   totalHeight#=max3(getTextTotalHeight(text1Id),getTextTotalHeight(text2Id),getTextTotalHeight(text3Id))
   setSpriteSize(menuBackSpriteId,totalLength#,totalHeight#*3)
   setSpriteOffset(menuBackSpriteId,getSpriteWidth(menuBackSpriteId)/2,getSpriteHeight(menuBackSpriteId)/2)
   setSpritePositionByoffset(menuBackSpriteId,menuX#,menuY#)
   setSpriteDepth(menuBackSpriteId,4)
   setTextDepth(captionId,3)
   setTextAlignment(captionId,1)
   setTextPosition(captionId, menuX#,menuY#-1.5*totalHeight#)
   menuX#=menuX#-totalLength#/2
   menuY#=menuY#-totalHeight#
   setTextPosition(text1Id,menuX#+textSeparatorLength#,menuY#+totalHeight#)
   setTextPosition(text2Id,menuX#+(totalLength#-text2Length#)/2,menuY#+totalHeight#)
   setTextPosition(text3Id,menuX#+totalLength#-text3Length#-textSeparatorLength#,menuY#+totalHeight#)
   setTextDepth(text1Id,3)
   setTextDepth(text2Id,3)
   setTextDepth(text3Id,3)
   textPressed=0
   while (textPressed=0)
        textOver=0
        pointerX#=screentoworldx(getPointerX())
        pointerY#=screentoworldx(getPointerY())
        if (getTextHitTest(text1Id,pointerX#,pointerY#))
           setTextColor(text1Id,255,0,0,255)
           setTextColor(text2Id,0,0,255,255)
           setTextColor(text3Id,0,0,255,255)
           textOver=text1Id
        elseif (getTextHitTest(text2Id,pointerX#,pointerY#))
           setTextColor(text2Id,255,0,0,255)
           setTextColor(text1Id,0,0,255,255)
           setTextColor(text3Id,0,0,255,255)
           textOver=text2Id
        elseif (getTextHitTest(text3Id,pointerX#,pointerY#))
           setTextColor(text3Id,255,0,0,255)
           setTextColor(text1Id,0,0,255,255)
           setTextColor(text2Id,0,0,255,255)
           textOver=text3Id
        else
           setTextColor(text1Id,0,0,255,255)
           setTextColor(text2Id,0,0,255,255)
           setTextColor(text3Id,0,0,255,255)
        endif
        if (textOver<>0) and (getPointerState()) then textPressed=1
        sync()
   endwhile
   if (textOver=text1Id)
         retVal=1
   elseif (textOver=text2Id)
         retVal=2
   else
         retVal=3
   endif
   pauseTime(0.5)
   deleteText(text1Id)
   deleteText(text2Id)
   deleteText(text3Id)
   deleteText(captionId)
   deleteText(textSeparatorId)
   deleteSprite(menuBackSpriteId)
endfunction retVal

rem menu 2 choices
function menuBox2(menuX# as float, menuY# as float,caption$ as string,choice1$ as String, choice2$ as String, textSize as integer)
   retVal as integer
   textOver as integer
   textPressed as integer
   menuBackSpriteId as integer
   captionTextId as integer
   text1Id as integer
   text2Id as integer
   captionId as integer
   textSeparatorId as integer
   TextSeparatorLength# as float
   Text1Length# as float
   Text2Length# as float
    captionLength# as float
   totalLength# as float
   totalWidth# as float
   totalHeight# as float 
   pointerX# as float
   pointerY# as float
   if (getImageExists(corniceImg)=0) then loadImage("cornice.PNG")
   menuBackSpriteId=createSprite(corniceImg)
   text1Id=createText(choice1$)
   text2Id=createText(choice2$)
   captionId=createText(caption$)
   fixSpriteToScreen(menuBackSpriteId,1)
   fixTextToScreen(text1Id,1)
   fixTextToScreen(text2Id,1)
   fixTextToScreen(captionId,1)
   textSeparatorId=createText("  ")
   setTextSize(text1Id,textSize)
   setTextSize(text2Id,textSize)
   setTextSize(captionId,textSize)
   setTextSize(textSeparatorId,textSize)
   setTextVisible(textSeparatorId,0)
   setTextColor(text1Id,0,0,255,255)
   setTextColor(text2Id,0,0,255,255)
   setTextColor(captionId,0,128,0,255)
   text1Length#=getTextTotalWidth(text1Id)
   text2Length#=getTextTotalWidth(text2Id)
   captionLength#=getTextTotalWidth(captionId)
   textSeparatorLength#=getTextTotalWidth(textSeparatorId)
   totalLength#=max2(text1Length#+text2Length#+textSeparatorLength#*3,captionLength#+textSeparatorLength#*2)
   totalHeight#=max2(getTextTotalHeight(text1Id),getTextTotalHeight(text2Id))
   setSpriteSize(menuBackSpriteId,totalLength#,totalHeight#*3)
   setSpriteOffset(menuBackSpriteId,getSpriteWidth(menuBackSpriteId)/2,getSpriteHeight(menuBackSpriteId)/2)
   setSpritePositionByoffset(menuBackSpriteId,menuX#,menuY#)
   setSpriteDepth(menuBackSpriteId,4)
   setTextDepth(captionId,3)
   setTextAlignment(captionId,1)
   setTextPosition(captionId, menuX#,menuY#-1.5*totalHeight#)
   menuX#=menuX#-totalLength#/2
   menuY#=menuY#-totalHeight#
   setTextPosition(text1Id,menuX#+textSeparatorLength#,menuY#+totalHeight#)
   setTextPosition(text2Id,menuX#+totalLength#-text2Length#-textSeparatorLength#,menuY#+totalHeight#)
   setTextDepth(text1Id,3)
   setTextDepth(text2Id,3)
   textPressed=0
   while (textPressed=0)
        textOver=0
        pointerX#=screentoworldx(getPointerX())
        pointerY#=screentoworldx(getPointerY())
        if (getTextHitTest(text1Id,pointerX#,pointerY#))
           setTextColor(text1Id,255,0,0,255)
           setTextColor(text2Id,0,0,255,255)
           textOver=text1Id
        elseif (getTextHitTest(text2Id,pointerX#,pointerY#))
           setTextColor(text2Id,255,0,0,255)
           setTextColor(text1Id,0,0,255,255)
           textOver=text2Id
        else
           setTextColor(text1Id,0,0,255,255)
           setTextColor(text2Id,0,0,255,255)
        endif
        if (textOver<>0) and (getPointerState()) then textPressed=1
        sync()
   endwhile
   if (textOver=text1Id)
         retVal=1
   else
         retVal=2
   endif
   pauseTime(0.5)
   deleteText(text1Id)
   deleteText(text2Id)
   deleteText(captionId)
   deleteText(textSeparatorId)
   deleteSprite(menuBackSpriteId)
endfunction retVal


rem MessageBox
function messageBox(menuX# as float, menuY# as float,caption$ as string, textSize as integer)
   retVal as integer
   textOver as integer
   textPressed as integer
   menuBackSpriteId as integer
   captionTextId as integer
   text1Id as integer
   captionId as integer
   textSeparatorId as integer
   TextSeparatorLength# as float
   Text1Length# as float
   captionLength# as float
   totalLength# as float
   totalWidth# as float
   totalHeight# as float
    pointerX# as float
   pointerY# as float
   menuBackSpriteId=createSprite(0)
   SetSpriteColor(menuBackSpriteId,255,255,255,255)
   fixSpriteToScreen(menuBackSpriteId,1)
   text1Id=createText("OK")
   fixTextToScreen(text1Id,1)
   captionId=createText(caption$)
   fixTextToScreen(captionId,1)
   textSeparatorId=createText("  ")
   setTextSize(text1Id,textSize-1)
   setTextSize(captionId,textSize)
   setTextSize(textSeparatorId,textSize)
   setTextVisible(textSeparatorId,0)
   setTextColor(text1Id,0,0,255,255)
   setTextColor(captionId,0,128,0,255)
   text1Length#=getTextTotalWidth(text1Id)
   captionLength#=getTextTotalWidth(captionId)
   textSeparatorLength#=getTextTotalWidth(textSeparatorId)
   totalLength#=max2(text1Length#+textSeparatorLength#*2,captionLength#+textSeparatorLength#*2)
   totalHeight#=getTextTotalHeight(captionId)
   setSpriteSize(menuBackSpriteId,totalLength#,totalHeight#*2.5)
   setSpriteOffset(menuBackSpriteId,getSpriteWidth(menuBackSpriteId)/2,getSpriteHeight(menuBackSpriteId)/2)
   setSpritePositionByoffset(menuBackSpriteId,menuX#,menuY#)
   setSpriteDepth(menuBackSpriteId,4)
   setTextDepth(captionId,3)
   setTextAlignment(captionId,1)
   setTextAlignment(text1Id,1)
   setTextPosition(captionId, menuX#,menuY#-totalHeight#)
   setTextPosition(text1Id,menuX#,menuY#+0.3*totalHeight#)
   setTextDepth(text1Id,3)
   textPressed=0
   while (textPressed=0)
        textOver=0
        pointerX#=getPointerX()
        pointerY#=getPointerY()
        if (getTextHitTest(text1Id,pointerX#,pointerY#))
           setTextColor(text1Id,255,0,0,255)
           textOver=text1Id
        else
           setTextColor(text1Id,0,0,255,255)
        endif
        if (textOver<>0) and (getPointerState()) then textPressed=1
        sync()
   endwhile
   if (textOver=text1Id)
         retVal=1
   endif
   pauseTime(0.5)
   deleteText(text1Id)
   deleteText(captionId)
   deleteText(textSeparatorId)
   deleteSprite(menuBackSpriteId)
endfunction retVal

function max2(a# as float, b# as float)
   if (a#<b#)
      exitfunction b#
   endif
endfunction a#

function max3(a# as float, b# as float,c# as float)
   if (a#>=b#) and (a#>=c#)
      exitfunction a#
   elseif (b#>=a#) and (b#>=c#)
      exitfunction b#
   endif
endfunction c#

function min2(a# as float, b# as float)
   if (a#<b#)
      exitfunction a#
   endif
endfunction b#

function min3(a# as float, b# as float,c# as float)
   if (a#<=b#) and (a#<=c#)
      exitfunction a#
   elseif (b#<=a#) and (b#<=c#)
      exitfunction b#
   endif
endfunction c#

function pathToAngle(startAngle# as float, finalAngle# as float)
   s# as float
   retVal# as float
   s#=-1
   if (abs(startAngle#-finalAngle#)<180) then s#=1
   if (startAngle#<finalAngle#)
      retVal#=startAngle#+s#
   else
      retVal#=startAngle#-1*s#
   endif
   if (retVal#>360)
      retVal#=retVal#-360
   elseif (retVal#<0)
      retVal#=retVal#+360
   endif
endfunction retVal#

function printText(x# as float,y# as float, s$ as string, size as integer, align as integer)
   newTextId as integer
   newTextId=createText(s$)
   setTextSize(newTextId,size)
   setTextAlignment(newTextId,align)
   setTextPosition(newTextId,x#,y#)
endfunction newTextId

function logwriter(s as string)
	logFileID=OpenToWrite("agklog.txt",1)
	WriteLine(logFileID,s)
	CloseFile(logFileID)
endfunction
