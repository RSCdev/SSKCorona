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
-- Last Modified: 29 AUG 2012
-- =============================================================


--EFM remove game specific code from this
---------------------------------------------------------------------------------
--
-- u_networking.lua
--
---------------------------------------------------------------------------------
module(..., package.seeall)

----------------------------------------------------------------------
--						REQUIRES									--
----------------------------------------------------------------------
local storyboard = require( "storyboard" )
local json = require "json"

client	= require( "ssk.external.mydevelopergames.Client")    -- Client (External: http://www.mydevelopersgames.com/AutoLAN/)
server	= require( "ssk.external.mydevelopergames.Server")    -- Server (External: http://www.mydevelopersgames.com/AutoLAN/)

local gem =  require( "ssk.classes.c_gem")

local debugOn = false

----------------------------------------------------------------------
--						LOCALS										--
----------------------------------------------------------------------
-- Variables
local connectedToServer
local clients = {} 
local numClients = 0

-- Callbacks/Functions
-- COMMON
local dataReceived 
-- SERVER
local host_handleDataReceived
local host_PlayerJoined
local host_PlayerDropped
-- CLIENT
local client_handleDataReceived
local client_DoneScanning
local client_ServerFound
local client_ConnectedToServer
local client_Disconnected
local client_ConnectionFailed

-- Game Specific Functions
--allGamesOver
--getFinalScores

----------------------------------------------------------------------
--						GLOBAL FUNCTIONS							--
----------------------------------------------------------------------
function msgServer( msg ) 
	client:send( msg )
end

function msgClient( aClient, msg  )
	aClient:send( msg )
end

function msgClients( msg )
	for key,aClient in pairs(clients) do
		aClient:send( msg )
	end
end

function getClientsTable(  )
	return clients
end

function setClientPlayerName( aClient, name  )
	aClient.playerName = name
end

function getClientPlayerName( aClient  )
	return aClient.playerName
end
function getClientPlayerNames( aClient  )
	local tmpTable =  {}
	for key,aClient in pairs(clients) do
		tmpTable[#tmpTable+1] = aClient.playerName
	end
	return tmpTable
end

function setClientPlayerScore( aClient, score  )
	aClient.playerScore = score
end

function getClientPlayerScore( aClient  )
	return aClient.playerScore
end

function getClientPlayerScores( aClient  ) -- EFM THIS IS WRONG
	local tmpTable =  {}
	for key,aClient in pairs(clients) do
		tmpTable[#tmpTable+1] = { aClient.playerName, aClient.playerScore }
		--tmpTable[aClient.playerScore] =  aClient.playerName
	end
	return tmpTable
end

local serverGameOver = false
function clearClientPlayerScores( aClient  )
	for key,aClient in pairs(clients) do
		aClient.playerScore = 0
		aClient.gameOver = false
	end
	serverGameOver = false
end

function scanServers( durationMS )
	client:start() 
	client:scanServers( durationMS )
end

function setCustomBroadcast( broadcast )
	server:setCustomBroadcast(broadcast)
end

function startHosting()
	server:start()	
end

function autoconnectToHost( )
	client:start()
	client:autoConnect( )
end

function connectToSpecificHost( hostIP )
	client:start()
	client:connect(hostIP)
end


function stopNetworking()
	if(debugOn) then 
		print("stopNetworking()")
	end
	if( numClients > 0) then
		server:disconnect()
		for k,v in pairs(clients) do 
			local theClient = clients[k]
			clients[k] = nil
			numClients = numClients - 1	
			theClient:removeSelf()
		end
		numClients = 0
	end

	if( connectedToServer == true) then
		client:disconnect()
		connectedToServer = false
	end

	server:stop()
	client:stop()

	gem:post("NETWORKING_STOPPED")
end

function getClientByKey( key )
	return clients[key]
end

function setClient( client )
	clients[client] = client
end

function getClientsTable()
	return clients
end

function getNumClients()
	return numClients
end

function isConnectedToServer()
	return (connectedToServer == true)
end

--- Networking: Check Util
function isConnectedToWWW( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
                
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
		hostFound = false
		print( "URL Not Found: " .. url )
	else
		print( "URL Found: " .. url )
	end

	return hostFound
end


function registerCallbacks()
	-- SERVER
	Runtime:addEventListener("autolanPlayerJoined", host_PlayerJoined)
	Runtime:addEventListener("autolanPlayerDropped", host_PlayerDropped)
	Runtime:addEventListener("autolanReceived", dataReceived)

	-- CLIENT
	
	Runtime:addEventListener("autolanDoneScanning", client_DoneScanning)
	Runtime:addEventListener("autolanServerFound", client_ServerFound)
	Runtime:addEventListener("autolanConnected", client_ConnectedToServer)
	Runtime:addEventListener("autolanDisconnected", client_Disconnected)
	Runtime:addEventListener("autolanConnectionFailed", client_ConnectionFailed)
end


----------------------------------------------------------------------
--						CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
---- COMMON
dataReceived = function (event)	
	if(debugOn) then 
		print("Received message")
	end
	if(connectedToServer) then   --- I AM A CLIENT
		client_handleDataReceived(event)	
	else                         --- I AM THE SERVER		
		host_handleDataReceived(event)
	end
	return false -- Let others catch this too
end

---- SERVER
host_handleDataReceived = function (event)
	if(debugOn) then 
		print("host_handleDataReceived()")
	end
	local client = event.client
	local msg = str.tokenize( event.message )
	gem:post("MSG_FROM_CLIENT", { clientID = client, msgTable = msg } )
end

host_PlayerJoined = function (event)
	if(debugOn) then 
		print("host_PlayerJoined()" )
	end
	local client = event.client
	clients[client] = client
	numClients = numClients + 1
	client.myJoinTime = system.getTimer() 
	gem:post("CLIENT_JOINED", { clientID = client } )
end

host_PlayerDropped = function (event)
	if(debugOn) then 
		print("host_PlayerDropped()")
	end
	local client = event.client
	if(debugOn) then 
		print("HOST - host_PlayerDropped() - " .. 
		" Dropped b/c " .. event.message .. 
		" connection was active for " .. system.getTimer() - clients[client].myJoinTime .. " ms" )
	end

	-- Take player out of game and remove their name
	client.myName = nil
	client.inGame = nil
	clients[client] = nil --clear references to prevent memory leaks
	numClients = numClients - 1	

	gem:post("CLIENT_DROPPED", { clientID = client, dropReason = event.message } )

end

------ CLIENT
client_handleDataReceived = function (event)
	if(debugOn) then 
		print("client_handleDataReceived() " .. event.message)
	end
	local theServer = event.client
	local msg = str.tokenize( event.message )
	gem:post("MSG_FROM_SERVER", { clientID = client,msgTable = msg } )
end

client_DoneScanning = function (event)
	if(debugOn) then 
		print("client_ServerFound()")
		print("JOIN - client_DoneScanning()" )
	end

	local myEvent = event
	gem:post("DONE_SCANNING_FOR_SERVERS", myEvent )
end


client_ServerFound = function (event)
	if(debugOn) then 
		print("client_ServerFound()")
		print("JOIN - client_ServerFound() - event.serverName == " .. event.serverName )
		print("                            - event.serverIP   == " .. event.serverIP )
	end
	local myEvent = event
	gem:post("SERVER_FOUND", myEvent )
end

client_ConnectedToServer = function (event)
	if(debugOn) then 
		print("client_ConnectedToServer()")
		print("JOIN - client_ConnectedToServer() - event.serverIP == " .. event.serverIP )
	end
	connectedToServer = true
	local myEvent = event
	gem:post( "CONNECTED_TO_SERVER",  myEvent )
end

client_Disconnected = function (event)
	if(debugOn) then 
		print("client_Disconnected()")
		print("JOIN - client_Disconnected() - event.message  == " .. event.message )
		print("                             - event.serverIP == " .. event.serverIP )
	end
	connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Disconnected"
	gem:post( "SERVER_DROPPED",  myEvent )
end

client_ConnectionFailed = function (event)
	if(debugOn) then 
		print("client_ConnectionFailed()")
		print("JOIN - client_ConnectionFailed() - event.serverIP == " .. event.serverIP )
	end
	connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Dropped"
	gem:post("SERVER_DROPPED" ,  myEvent )
end


-- ==================================
-- Game Specific Code Below
-- ==================================
-- ==
--    SERVER
-- ==

local sendOutScoreUpdates
local theServer_HandleClientMessages
local aClient_HandleServerMessages
local setServerGameOver

setServerGameOver = function()
	--print("received game over message from server!")
	serverGameOver = true
end

theServer_HandleClientMessages = function ( event )
	local msgTable = event.msgTable
	local clientID = event.clientID

	local msgType = msgTable[1]

	if( msgType == "setPlayerScore" ) then
		local score = msgTable[2]
		networking.setClientPlayerScore( clientID, score )
		gem:post("SEND_OUT_SCORE_UPDATES")

	elseif( msgType == "setGameOver" ) then
		--print("received game over message from client!")
		clientID.gameOver = true

	elseif( msgType == "raceGameComplete" ) then
		msgClients("raceGameComplete")
		gem:post("raceGameComplete")

	elseif( msgType == "checkAllGamesOver" ) then
		--print("CLIENT Query: " .. " are all games over?" )
		local gamesOver = allGamesOver()

		if( gamesOver == true ) then
			local finalScores = getFinalScores()
			msgClient( clientID, "allGamesOver")
			msgClient( clientID, "showFinalScores " .. json.encode(finalScores) )
		end
	
	end
end

sendOutScoreUpdates = function ()
	local clientScoresTable = networking.getClientPlayerScores()
	local myScore = currentPlayer:get("score")
	--clientScoresTable[myScore] = currentPlayer:get("name")
	clientScoresTable[#clientScoresTable+1] = {currentPlayer:get("name"), myScore }
	--for k,v in pairs(clientScoresTable) do print(v[1] .. " == " .. v[2]) end
	networking.msgClients( "updateScoreHeaders " .. json.encode(clientScoresTable) )

	gem:post("UPDATE_SCORE_HEADERS", {clientScoresTable = clientScoresTable})
	--updateScoreHeaders( clientScoresTable )
end

aClient_HandleServerMessages = function ( event )
	local msgTable = event.msgTable
	local paramsFromServer = ""

	local msgType = msgTable[1]

	--print(" aClient_HandleServerMessages msgType == " .. msgType )


	if( msgType == "updateScoreHeaders" ) then

		local clientScoresTable = ""
		for i=2, #msgTable do
			clientScoresTable = clientScoresTable .. msgTable[i]
		end

		clientScoresTable = json.decode( clientScoresTable )
		gem:post("UPDATE_SCORE_HEADERS", {clientScoresTable = clientScoresTable})
		--updateScoreHeaders(clientScoresTable)

	elseif( msgType == "allGamesOver" ) then
		gem:post("allGamesOver")

	elseif( msgType == "raceGameComplete" ) then
		gem:post("raceGameComplete")
	
	elseif( msgType == "showFinalScores" ) then

		local clientScoresTable = ""
		for i=2, #msgTable do
			clientScoresTable = clientScoresTable .. msgTable[i]
		end

		clientScoresTable = json.decode( clientScoresTable )
		gem:post("showFinalScores", {finalScores = clientScoresTable} )
	end
end

gem:add( "SEND_OUT_SCORE_UPDATES", sendOutScoreUpdates )
gem:add( "MSG_FROM_CLIENT", theServer_HandleClientMessages )
gem:add( "MSG_FROM_SERVER", aClient_HandleServerMessages )
gem:add( "SERVER_GAME_OVER", setServerGameOver )

function allGamesOver( )
	local allDone = true
	for key,aClient in pairs(clients) do
		if(aClient.gameOver == false) then allDone = false end
	end
	if(serverGameOver == false) then allDone = false end

	--print("Checking allDone == " .. tostring(allDone))
	return allDone
end


function getFinalScores()
	local clientScoresTable = networking.getClientPlayerScores()
	local myScore = currentPlayer:get("score")
	clientScoresTable[#clientScoresTable+1] = {currentPlayer:get("name"), myScore }
	
	--for k,v in pairs(clientScoresTable) do print(v[1] .. " == " .. v[2]) end
	
	return clientScoresTable
end

function raceGameComplete()
	if(connectedToServer) then   --- I AM A CLIENT
		msgServer("raceGameComplete")
	else                         --- I AM THE SERVER		
		msgClients("raceGameComplete")
		gem:post("raceGameComplete")
	end
end



