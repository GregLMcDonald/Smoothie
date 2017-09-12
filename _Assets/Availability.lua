local Availability = {}

local ingredients, ingredientKeys = require( '_Culinary.Ingredients' ).getList() --returns the FULL list without regard to availability for a given player

local applianceKeys = {
	'appliance1',
	'appliance2',
	'appliance3',
	'appliance4',
	'appliance5',
}

local isEarned = {}
local isUnlocked = {}
local function setEarnedAndLockedDefaultValues()
	for i=1,#ingredientKeys do
		if i <= 5 then
			isEarned[ ingredientKeys[ i ] ] = true
		else
			isEarned[ ingredientKeys[ i ] ] = false
		end
	end

	
	for i=1, #ingredientKeys do
		if i <= 10 then
			isUnlocked[ ingredientKeys[ i ] ] = true
		else
			isUnlocked[ ingredientKeys[ i ] ] = false
		end
	end

	for i=1, #applianceKeys do
		local key = applianceKeys[ i ]
		if i <= 2 then
			isEarned[ key ] = true
			isUnlocked[ key ] = true
		else
			isEarned[ key ] = true
			isUnlocked[ key ] = false
		end
	end

end
setEarnedAndLockedDefaultValues()

local availabilityLoaded = false


--*************************************
--     DATABASE UTILITY FUNCTIONS
--*************************************

local function tableNameForPlayerID( playerID )
	return 'player_'..tostring( playerID )
end

local sqlite3 = require( "sqlite3" )
local function closeDB( db, caller )
	local verbose = false
	
	if caller == nil then 
		caller = "?" 
	end
	
	local wasSuccessful = false
	if db then
		local resultCode = db:close()
		if resultCode == sqlite3.OK then
			if verbose then print("("..caller..") closeDB OK") end
			wasSuccessful = true
		else
			if verbose then print("("..caller..") closeDB "..resultCode) end
		end

	else
		if verbose then print("("..caller..") db==nil in closeDB") end
	end
	return wasSuccessful
end
local function openDatabaseForTable( tableName )

	local db = nil

	local path = system.pathForFile( "AssetAvailability.db" , system.DocumentsDirectory )
	local db, errCode, errMsg = sqlite3.open(path) --This creates the DB if it doesn't yet exist.

    local function onSystemEvent( event )
        if (event.type == "applicationExit") then
            --db:close()
            closeDB( db, 'onSystemEvent' )
        end
    end

    -- If the DB could not be opened/created, ABORT
    if db == nil then
    	print("Availability: Problem opening database",errCode,errMsg)
    	return nil
    end


    local sql = [=[ SELECT name FROM sqlite_master WHERE type='table' AND name=']=]..tableName..[=['; ]=]

    local tableExists = false
	
	for row in db:nrows(sql) do
		tableExists = true
  		break
	end

	if tableExists then
		return db
	else
		if string.find( tableName, 'player_' ) then
		
			sql = [=[ 
				CREATE TABLE `]=]..tableName..[=[` (
					`key`	TEXT NOT NULL,
					`isUnlocked` INTEGER NOT NULL DEFAULT 0,
					`isEarned`	INTEGER NOT NULL DEFAULT 0
				);
			]=]

			local dbResult = db:exec(sql)

			if dbResult ~= sqlite3.OK then 
				print("Availability: problem creating table.",tableName,db:errmsg() )
				closeDB( db )
				return nil
			else
				print('Availability: table creation successful',tableName)
			end

		else

			closeDB( db )
			return nil

		end
	end
			
	return db
end



function Availability.load( playerID )

	if nil == playerID then
		playerID = 0
	end
	local tableName = tableNameForPlayerID( playerID )
	local availabilityDB = openDatabaseForTable( tableName )
	
	if availabilityDB then
		local sql = "SELECT * FROM "..tableName..";"
		for row in availabilityDB:nrows(sql) do
			
			local isEarnedBoolean = true
			if 0 == row.isEarned then
				isEarnedBoolean = false
			end
			isEarned[ row.key ] = isEarnedBoolean


			local isUnlockedBoolean = true
			if 0 == row.isUnlocked then
				isUnlockedBoolean = false
			end
			isUnlocked[ row.key ] = isUnlockedBoolean

		end

		closeDB( availabilityDB, 'Availability.load' )

		
	end

	availabilityLoaded = true

end

function Availability.getEarnedAvailabilityCopy()

	if availabilityLoaded == false then
		Availability.load()
	end

	local copy = {}
	for k,v in pairs( isEarned ) do
		copy[ k ] = v
	end

	return copy
		
end

function Availability.getUnlockedAvailabilityCopy()

	if availabilityLoaded == false then
		Availability.load()
	end

	local copy = {}
	for k,v in pairs( isUnlocked ) do
		copy[ k ] = v
	end

	return copy
		
end

function Availability.setEarned( key, value )
	isEarned[ key ] = value
end
function Availability.setUnlocked( key, value )
	isUnlocked[ key ] = value
end

function Availability.getEarned( key )
	if availabilityLoaded == false then
		Availability.load()
	end
	return isEarned[ key ]
end
function Availability.getUnlocked( key )
	if availabilityLoaded == false then
		Availability.load()
	end
	return isUnlocked[ key ]
end

function Availability.save( playerID )
	print("Availability.save")
	
	if nil == playerID then
		playerID = 0
	end
	local tableName = tableNameForPlayerID( playerID )
	local availabilityDB = openDatabaseForTable( tableName )
	if availabilityDB then

		local sql = "DELETE FROM "..tableName..";"
		availabilityDB:exec(sql)

		for i=1,#ingredientKeys do
			local key = ingredientKeys[i]
			local isEarnedNumber = 1
			if false == isEarned[ key ] then
				isEarnedNumber = 0
			end
			local isUnlockedNumber = 1
			if false == isUnlocked[ key ] then
				isUnlockedNumber = 0
			end
			sql = "INSERT INTO "..tableName.." (`key`,`isEarned`,`isUnlocked` ) VALUES ('"..key.."',"..isEarnedNumber..","..isUnlockedNumber..");"
			local dbResult = availabilityDB:exec(sql)
			if dbResult ~= sqlite3.OK then
				print(dbResult, availabilityDB:errmsg() )
			end
		end	
		for i=1,#applianceKeys do
			local key = applianceKeys[i]
			local isEarnedNumber = 1
			if false == isEarned[ key ] then
				isEarnedNumber = 0
			end
			local isUnlockedNumber = 1
			if false == isUnlocked[ key ] then
				isUnlockedNumber = 0
			end
			sql = "INSERT INTO "..tableName.." (`key`,`isEarned`,`isUnlocked` ) VALUES ('"..key.."',"..isEarnedNumber..","..isUnlockedNumber..");"
			local dbResult = availabilityDB:exec(sql)
			if dbResult ~= sqlite3.OK then
				print(dbResult, availabilityDB:errmsg() )
			end
		end	

		closeDB( availabilityDB, 'Availability.save' )

	end

end

function Availability.reset()
	print("Availability.reset")
	
	setEarnedAndLockedDefaultValues()

	Availability.save()
	availabilityLoaded = true

end

return Availability