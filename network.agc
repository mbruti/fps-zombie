global isMultiPlayerLAN as integer
global isHostLAN as integer
global networkID as integer

#constant NET_MSG_VOID -1 
#constant NET_MSG_PING 0
#constant NET_MSG_FPSPOSITION 1
#constant NET_MSG_UPDATESTATUS 2
#constant NET_MSG_ENEMYPOSITION 3
#constant NET_MSG_ENEMYENERGY 4
#constant NET_MSG_WORLD 5
#constant NET_MSG_PLAYERHIT 6
#constant NET_MSG_LIFTPOSITION 7

#constant GAMEMODE_COOP 0
#constant GAMEMODE_VS 1

type MessageFPS
	messageType as integer	
	x as float
	y as float
	z as float
	angle_x as float
	angle_y as float
	angle_z as float
	index as integer
	status as integer
	energy as integer
	energyLost as integer
	world as integer
	gameMode as integer
endtype

 
function hostGameLAN()
	msg as MessageFPS
	otherWorld as integer
	joinFlag as integer
	txtID as integer
	netID as integer
	clientID as integer
	netID=HostNetwork("FPSZOMBIE", "Host", 1234)
	txtId=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-64,"Setting up network...",36,1)
	joinFlag=0
	while (IsNetworkActive(netID)=0)
		backImageScroll(0.005)
		sync()
	endwhile
	DeleteText(txtID)
	txtId=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-64,"Waiting client to join...",36,1)
	clientID=GetNetworkFirstClient(netID)
	repeat
		if (clientID=0)
			clientID=GetNetworkFirstClient(netID)
			joinFlag=0
		elseif (clientID<>GetNetworkMyClientID(netID))
			joinFlag=1
		else
			joinFlag=0
			clientID=GetNetworkNextClient(netID)
		endif
		backImageScroll(0.005)	
		sync()	
	until joinFlag=1
	repeat
		backImageScroll(0.005)
		sync()
	until (GetNetworkNextClient(netID)=0)	
	DeleteText(txtId)
	isMultiPlayerLAN=1
	isHostLAN=1
	SetNetworkLatency(netID,50)
	repeat
		sendNetworkFPSWorld(netID, chosenWorld,VSMode)
		msg=getNetworkFPSMessage(netID)
		if (msg.messageType=NET_MSG_WORLD) then otherWorld=msg.world
		backImageScroll(0.005)	
		sync()
	until (msg.messageType=NET_MSG_WORLD)
	deleteBackImage()
endfunction netID

function joinGameLAN()
	msg as MessageFPS
	txtID as integer
	netID as integer
	clientID as integer
	otherWorld as integer
	netID=JoinNetwork( "FPSZOMBIE", "Client")
	txtId=printText(SCREEN2D_WIDTH/2,SCREEN2D_HEIGHT-64,"Joining the network...",36,1)
	while (GetNetworkNumClients(netID)<2)
		backImageScroll(0.005)
		sync()
	endwhile
	DeleteText(txtID)
	isMultiPlayerLAN=1
	isHostLAN=0
	SetNetworkLatency(netID,50)
	repeat
		sendNetworkFPSWorld(netID,chosenWorld,0)
		msg=getNetworkFPSMessage(netID)
		if (msg.messageType=NET_MSG_WORLD) 
			otherWorld=msg.world
		    VSMode=msg.gameMode
		endif    
		backImageScroll(0.005)
		sync()
	until (msg.messageType=NET_MSG_WORLD)
	chosenWorld=otherWorld
	deleteBackImage()
endfunction	netID

function printNetworkClients(netID as integer)
    Print("Network ID: " + Str(netID))	
	Print("Number of Clients: " + Str(GetNetworkNumClients(netID)))
	Print("isNetworkActive: " +str(IsNetworkActive(netID)))
endfunction	

function sendNetworkFPSPosition(netID as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_FPSPOSITION)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].x)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].y)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].z)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].angle_x)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].angle_y)
	AddNetworkMessageFloat(msgID,oggetti3D[fps_index].angle_z)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function sendNetworkEnemyPosition(netID as integer, index as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_ENEMYPOSITION)
	AddNetworkMessageInteger(msgID,index)
	AddNetworkMessageInteger(msgID,oggetti3D[index].status)
	AddNetworkMessageFloat(msgID,oggetti3D[index].x)
	AddNetworkMessageFloat(msgID,oggetti3D[index].y)
	AddNetworkMessageFloat(msgID,oggetti3D[index].z)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_x)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_y)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_z)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function sendNetworkLiftPosition(netID as integer, index as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_LIFTPOSITION)
	AddNetworkMessageInteger(msgID,index)
	AddNetworkMessageInteger(msgID,oggetti3D[index].status)
	AddNetworkMessageFloat(msgID,oggetti3D[index].x)
	AddNetworkMessageFloat(msgID,oggetti3D[index].y)
	AddNetworkMessageFloat(msgID,oggetti3D[index].z)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_x)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_y)
	AddNetworkMessageFloat(msgID,oggetti3D[index].angle_z)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function sendNetworkFPSUpdateStatus(netID as integer,index as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_UPDATESTATUS)
	AddNetworkMessageInteger(msgID,index)
	AddNetworkMessageInteger(msgID,oggetti3D[index].status)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function sendNetworkFPSEnemyEnergy(netID as integer,index as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_ENEMYENERGY)
	AddNetworkMessageInteger(msgID,index)
	AddNetworkMessageInteger(msgID,oggetti3D[index].energy)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function sendNetworkFPSPlayerHit(netID as integer,energyLost as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_PLAYERHIT)
	AddNetworkMessageInteger(msgID,energyLost)
	SendNetworkMessage(netID,0,msgID)
endfunction

function sendNetworkFPSWorld(netID as integer,w as integer,gm as integer)
	msgID as integer
	msgID=CreateNetworkMessage()
	AddNetworkMessageInteger(msgID,NET_MSG_WORLD)
	AddNetworkMessageInteger(msgID,w)
	AddNetworkMessageInteger(msgID,gm)
	SendNetworkMessage(netID,0,msgID)
endfunction	

function getNetworkFPSMessage(netID as integer)
	msgID as integer
	msg as MessageFPS
	msg.messageType=NET_MSG_VOID
	msgID=GetNetworkMessage(netID)
	if (msgID>0)
		msg.messageType=GetNetworkMessageInteger(msgID)
		select msg.messageType
			case NET_MSG_FPSPOSITION
				msg.x=GetNetworkMessageFloat(msgID)
				msg.y=GetNetworkMessageFloat(msgID)
				msg.z=GetNetworkMessageFloat(msgID)
				msg.angle_x=GetNetworkMessageFloat(msgID)
				msg.angle_y=GetNetworkMessageFloat(msgID)
				msg.angle_z=GetNetworkMessageFloat(msgID)
				msg.messageType=NET_MSG_FPSPOSITION
			endcase
			case NET_MSG_ENEMYPOSITION
				msg.index=GetNetworkMessageInteger(msgID)
				msg.status=GetNetworkMessageInteger(msgID)
				msg.x=GetNetworkMessageFloat(msgID)
				msg.y=GetNetworkMessageFloat(msgID)
				msg.z=GetNetworkMessageFloat(msgID)
				msg.angle_x=GetNetworkMessageFloat(msgID)
				msg.angle_y=GetNetworkMessageFloat(msgID)
				msg.angle_z=GetNetworkMessageFloat(msgID)
				msg.messageType=NET_MSG_ENEMYPOSITION
			endcase
			case NET_MSG_LIFTPOSITION
				msg.index=GetNetworkMessageInteger(msgID)
				msg.status=GetNetworkMessageInteger(msgID)
				msg.x=GetNetworkMessageFloat(msgID)
				msg.y=GetNetworkMessageFloat(msgID)
				msg.z=GetNetworkMessageFloat(msgID)
				msg.angle_x=GetNetworkMessageFloat(msgID)
				msg.angle_y=GetNetworkMessageFloat(msgID)
				msg.angle_z=GetNetworkMessageFloat(msgID)
				msg.messageType=NET_MSG_LIFTPOSITION
			endcase
			case NET_MSG_UPDATESTATUS
				msg.index=GetNetworkMessageInteger(msgID)
				msg.status=GetNetworkMessageInteger(msgID)
				msg.messageType=NET_MSG_UPDATESTATUS
			endcase	
			case NET_MSG_ENEMYENERGY
				msg.index=GetNetworkMessageInteger(msgID)
				msg.energy=GetNetworkMessageInteger(msgID)
				msg.messageType=NET_MSG_ENEMYENERGY
			endcase	
			case NET_MSG_WORLD
				msg.world=GetNetworkMessageInteger(msgID)
				msg.gameMode=GetNetworkMessageInteger(msgID)
				msg.messageType=NET_MSG_WORLD
			endcase
			case NET_MSG_PLAYERHIT
				msg.energyLost=GetNetworkMessageInteger(msgID)
				msg.messageType=NET_MSG_PLAYERHIT
			endcase		
			case default
				msg.messageType=NET_MSG_PING
			endcase
		endselect				
		DeleteNetworkMessage(msgID)
	else
		msg.messageType=NET_MSG_VOID
	endif		 
endfunction	msg

function checkNetworkClientAvailable(netID as integer)
	rem print("isHostLAN "+str(isHostLAN))
	rem print("ismultiplayerLAN "+str(isMultiPlayerLAN))
	if (isMultiPlayerLAN=1)
	   if (GetNetworkNumClients(netID)<2)
		    isMultiPlayerLAN=0
   	   endif
   	endif
endfunction   	   	

function processNetworkFPSMessage(netID as integer, i as integer)
						msg as MessageFPS
						index as integer
						status as integer
						sendNetworkFPSPosition(netID)
						repeat 
							   msg=getNetworkFPSMessage(netID)
							   select msg.messageType
								   case NET_MSG_FPSPOSITION
									  oggetti3D[i].x=msg.x
									  oggetti3D[i].y=msg.y+oggetti3D[i].height/2
									  oggetti3D[i].z=msg.z
									  oggetti3D[i].angle_x=msg.angle_x
									  oggetti3D[i].angle_y=msg.angle_y
									  oggetti3D[i].angle_z=msg.angle_z
									  positionObject3D(oggetti3D[i])
								   endcase   
									case NET_MSG_ENEMYPOSITION 
									  if (isHostLAN=0)
										 index=msg.index
										 status=msg.status
										 oggetti3D[index].x=msg.x
										 oggetti3D[index].y=msg.y
										 oggetti3D[index].z=msg.z
										 oggetti3D[index].angle_x=msg.angle_x
										 oggetti3D[index].angle_y=msg.angle_y
										 oggetti3D[index].angle_z=msg.angle_z
										 positionObject3D(oggetti3D[index])
									  endif   
								   endcase 
								   case NET_MSG_LIFTPOSITION 
									  if (isHostLAN=0)
										 index=msg.index
										 status=msg.status
										 oggetti3D[index].x=msg.x
										 oggetti3D[index].y=msg.y
										 oggetti3D[index].z=msg.z
										 oggetti3D[index].angle_x=msg.angle_x
										 oggetti3D[index].angle_y=msg.angle_y
										 oggetti3D[index].angle_z=msg.angle_z
										 positionObject3D(oggetti3D[index])
									  endif   
								   endcase  
								   case NET_MSG_UPDATESTATUS
									   index=msg.index
									   status=msg.status
									   if (oggetti3D[index].status<>status)
										  oggetti3D[index].status=status
										  select oggetti3D[index].status
											  case STATUS_HIDDEN
												 oggetti3D[index].collision=0
												 SetObjectCollisionMode(oggetti3D[index].ID,0)
												 SetObjectVisible(oggetti3D[index].ID,0)
											  endcase	 
											  case STATUS_FALLING
												 if ( oggetti3D[index].animated=1)
													 SetObjectAnimationSpeed(oggetti3D[index].ID,0)
												 endif
											  endcase	  	 
										 endselect		 
									   endif
								   endcase	 
								   case NET_MSG_ENEMYENERGY
									   index=msg.index
									   oggetti3D[index].energy=msg.energy
									   hitEnemy(index)
								   endcase	
								   case NET_MSG_PLAYERHIT
									   hitPlayer(msg.energyLost)
								  endcase	       
							   endselect   	
						   until (msg.messageType=NET_MSG_VOID)	   		
endfunction
