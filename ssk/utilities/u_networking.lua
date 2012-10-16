-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Networking Utilities - NOT READY FOR USE (EFM)
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSK library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSK or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSK and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Last Modified: 11 OCT 2012
-- =============================================================
local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print


--EFM remove game specific code from this
---------------------------------------------------------------------------------
--
-- u_networking:lua
--
---------------------------------------------------------------------------------
--module(..., package.seeall)

local networking = {}

----------------------------------------------------------------------
--						REQUIRES									--
----------------------------------------------------------------------
local storyboard = require( "storyboard" )
local json = require "json"
local gem     =  ssk.gem
local clientClass		= require( "ssk.external.mydevelopergames.Client" )		-- Client (External: http://www.mydevelopersgames.com/AutoLAN/)
local serverClass		= require( "ssk.external.mydevelopergames.Server" )		-- Server (External: http://www.mydevelopersgames.com/AutoLAN/)

----------------------------------------------------------------------
--						LOCALS										--
----------------------------------------------------------------------
-- Variables
networking.connectedToServer = false
networking.clients = {} 
networking.numClients = 0

networking.serverRunning = false
networking.clientRunning = false

-- Callbacks/Functions
-- COMMON
local dataReceived 

-- SERVER
local host_handleDataReceived
local server_PlayerJoined
local server_PlayerDropped

-- CLIENT
local client_handleDataReceived
local client_DoneScanning
local client_ServerFound
local client_ConnectedToServer
local client_Disconnected
local client_ConnectionFailed


----------------------------------------------------------------------
--						GLOBAL FUNCTIONS							--
----------------------------------------------------------------------
function networking:msgServer( msg ) 
	clientClass:send( msg )
end

function networking:msgClient( aClient, msg  )
	aClient:send( msg )
end

function networking:msgClients( msg )
	for key,aClient in pairs(networking.clients) do
		aClient:send( msg )
	end
end

function networking:getNumClients(  )
	return networking.numClients
end

function networking:getClientsTable(  )
	return networking.clients
end

function networking:setClientPlayerName( aClient, name  )
	aClient.playerName = name
end

function networking:getClientPlayerName( aClient  )
	return aClient.playerName
end
function networking:getClientPlayerNames( aClient  )
	local tmpTable =  {}
	for key,aClient in pairs(networking.clients) do
		tmpTable[#tmpTable+1] = aClient.playerName
	end
	return tmpTable
end

function networking:setClientPlayerScore( aClient, score  )
	aClient.playerScore = score
end

function networking:getClientPlayerScore( aClient  )
	return aClient.playerScore
end

function networking:getClientPlayerScores( aClient  ) -- EFM THIS IS WRONG
	local tmpTable =  {}
	for key,aClient in pairs(networking.clients) do
		tmpTable[#tmpTable+1] = { aClient.playerName, aClient.playerScore }
		--tmpTable[aClient.playerScore] =  aClient.playerName
	end
	return tmpTable
end

local serverGameOver = false
function networking:clearClientPlayerScores( aClient  )
	for key,aClient in pairs(networking.clients) do
		aClient.playerScore = 0
		aClient.gameOver = false
	end
	serverGameOver = false
end

function networking:startServer( )
	if( self.serverRunning ) then
		return
	end

	serverClass:start() 
	self.serverRunning = true
end

function networking:startClient( )
	if( self.clientRunning ) then
		return
	end

	clientClass:start() 
	self.clientRunning = true
end


function networking:scanServers( durationMS )
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:scanServers( durationMS )
end

function networking:stopScanning( )
	if( not self.clientRunning ) then
		return
	end
	clientClass:stopScanning( )
end


function networking:setClientApplicationName( newName )
	clientClass:setOptions({applicationName = newName})
end

function networking:setServerApplicationName( newName )
	serverClass:setOptions({applicationName = newName})
	serverClass:setCustomBroadcast()
end

function networking:setCustomBroadcast( newBroadcast )
	serverClass:setOptions({customBroadcast = newBroadcast})
	serverClass:setCustomBroadcast()
end

function networking:autoconnectToHost( )
	dprint(1,"autoconnectToHost()")
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:autoConnect( )
end

function networking:connectToSpecificHost( hostIP )
	dprint(1,"connectToSpecificHost( " .. hostIP .. " )")
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:connect(hostIP)
end


function networking:stop()
	dprint(1,"stopNetworking()")
	if( networking.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(networking.clients) do 
			local client = networking.clients[k]
			clients[k] = nil
			networking.numClients = networking.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		networking.numClients = 0
	end

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	serverClass:stop()
	clientClass:stop()

	self.serverRunning = false
	self.clientRunning = false

	gem:post("CLIENT_STOPPED")
	gem:post("SERVER_STOPPED")
end

function networking:stopClient()
	dprint(1,"stopClient()")

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	clientClass:stop()
	self.clientRunning = false
	gem:post("CLIENT_STOPPED")
end

function networking:stopServer()
	dprint(1,"stopServer()")
	if( networking.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(networking.clients) do 
			local client = networking.clients[k]
			clients[k] = nil
			networking.numClients = networking.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		networking.numClients = 0
	end

	serverClass:stop()
	self.serverRunning = false

	gem:post("SERVER_STOPPED")
end





function networking:getClientByKey( key )
	return networking.clients[key]
end

function networking:setClient( client )
	networking.clients[client] = client
end

function networking:getClientsTable()
	return networking.clients
end

function networking:getNumClients()
	return networking.numClients
end

function networking:isConnectedToServer()
	return (self.connectedToServer == true)
end

--- Networking: Check Util
function networking:isConnectedToWWW( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
                
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
		hostFound = false
		dprint(1, "URL Not Found: " .. url )
	else
		dprint(1, "URL Found: " .. url )
	end

	return hostFound
end


function networking:registerCallbacks()
	dprint(1,"ssk.networking - registerCallbacks()")

	-- SERVER
	Runtime:addEventListener("autolanPlayerJoined", server_PlayerJoined)
	Runtime:addEventListener("autolanPlayerDropped", server_PlayerDropped)

	-- CLIENT
	
	Runtime:addEventListener("autolanDoneScanning", client_DoneScanning)
	Runtime:addEventListener("autolanServerFound", client_ServerFound)
	Runtime:addEventListener("autolanConnected", client_ConnectedToServer)
	Runtime:addEventListener("autolanDisconnected", client_Disconnected)
	Runtime:addEventListener("autolanConnectionFailed", client_ConnectionFailed)


	-- BOTH
	Runtime:addEventListener("autolanReceived", dataReceived)

end


----------------------------------------------------------------------
--						CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
---- COMMON
dataReceived = function (event)	
	dprint(2,"Received message")

	if(networking.connectedToServer) then   --- I AM A CLIENT
		client_handleDataReceived(event)	

	else                         --- I AM THE SERVER		
		host_handleDataReceived(event)
	end

	return false -- Let others catch this too
end

---- SERVER
host_handleDataReceived = function (event)
	dprint(2,"host_handleDataReceived()")

	local client = event.client
	local msg = str.tokenize( event.message )
	gem:post("MSG_FROM_CLIENT", { clientID = client, msgTable = msg } )

	return true -- Do not let others catch this too
end

server_PlayerJoined = function (event)
	dprint(1,"server_PlayerJoined()" )

	local client = event.client
	networking.clients[client] = client
	networking.numClients = networking.numClients + 1
	client.myJoinTime = system.getTimer() 
	gem:post("CLIENT_JOINED", { clientID = client } )

	return true -- Do not let others catch this too
end

server_PlayerDropped = function (event)
	dprint(1,"server_PlayerDropped()")

	local client = event.client

	dprint(2,"HOST - server_PlayerDropped() - " .. 
	" Dropped b/c " .. event.message .. 
	" connection was active for " .. system.getTimer() - networking.clients[client].myJoinTime .. " ms" )

	-- Take player out of game and remove their name
	client.myName = nil
	client.inGame = nil
	networking.clients[client] = nil --clear references to prevent memory leaks
	networking.numClients = networking.numClients - 1	

	gem:post("CLIENT_DROPPED", { clientID = client, dropReason = event.message } )

	return true -- Do not let others catch this too
end

------ CLIENT
client_handleDataReceived = function (event)
	dprint(1,"client_handleDataReceived() " .. event.message)

	local theServer = event.client
	local msg = str.tokenize( event.message )
	gem:post("MSG_FROM_SERVER", { clientID = client,msgTable = msg } )

	return true -- Do not let others catch this too
end

client_DoneScanning = function (event)
	dprint(1,"client_DoneScanning()" )

	local myEvent = event
	gem:post("DONE_SCANNING_FOR_SERVERS", myEvent )

	return true -- Do not let others catch this too
end


client_ServerFound = function (event)
	dprint(1,"client_ServerFound()")
	dprint(2,"JOIN - client_ServerFound() - event.serverName == " .. event.serverName )
	dprint(2,"                            - event.serverIP   == " .. event.serverIP )

	local myEvent = event
	gem:post("SERVER_FOUND", myEvent )

	return true -- Do not let others catch this too
end

client_ConnectedToServer = function (event)
	dprint(1,"client_ConnectedToServer()")
	dprint(2,"JOIN - client_ConnectedToServer() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = true
	local myEvent = event
	gem:post( "CONNECTED_TO_SERVER",  myEvent )

	return true -- Do not let others catch this too
end

client_Disconnected = function (event)
	dprint(1,"client_Disconnected()")
	dprint(2,"JOIN - client_Disconnected() - event.message  == " .. event.message )
	dprint(2,"                             - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Disconnected"
	gem:post( "SERVER_DROPPED",  myEvent )

	return true -- Do not let others catch this too
end

client_ConnectionFailed = function (event)
	dprint(1,"client_ConnectionFailed()")
	dprint(2,"JOIN - client_ConnectionFailed() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Dropped"
	gem:post("SERVER_DROPPED" ,  myEvent )

	return true -- Do not let others catch this too
end

return networking