--
-- Abstract: Composer Sample
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates use of the Composer API (scene events, transitioning, etc.)
--
-- Supports Graphics 2.0
------------------------------------------------------------

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- require controller module
local composer = require "composer"

local widget = require "widget"

local gameNetwork = require( "gameNetwork" )
local playerName

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   saveSettings()  --save player data locally using your own "saveSettings()" function
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   else
      gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
   end
end

local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      gameNetworkSetup()  --login to the network here
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )

-- load first scene
options = {
	effect = 'fade',
	time = 400,
	params = 
	{

	}
}
composer.gotoScene( "menu", options )

--
-- Display objects added below will not respond to composer transitions
--

-- table to setup tabBar buttons