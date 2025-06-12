script_name('receiver')
script_author('duke')

require('lib.moonloader')

require 'SLNet'

local netHandle = SLNetInit()
netHandle:bind('*', 6780) 
netHandle:setPrefix('SAN_SYNC')

local otherPlayer = nil
local otherPlayerBlip = nil
local isRemotePlayerDead = nil
local otherPlayerCar = nil
otherPlayerCarPlaceHolder = nil

function onReceiveData(packetID, bitStream, addr, port)
    
    if packetID == 1 then
        
        local x = bitStream:read(FLOAT)
        local y = bitStream:read(FLOAT)
        local z = bitStream:read(FLOAT)
        local vx = bitStream:read(FLOAT)
        local vy = bitStream:read(FLOAT)
        local vz = bitStream:read(FLOAT)
        local ha = bitStream:read(FLOAT)
        local qx, qy, qz, qw = bitStream:read(FLOAT), bitStream:read(FLOAT), bitStream:read(FLOAT), bitStream:read(FLOAT)
        local health = bitStream:read(UINT8)
        local isWalk = bitStream:read(BOOL)
        local isJumping = bitStream:read(BOOL)
        local cmi = bitStream:read(UINT8)

        if doesCharExist(otherPlayer) and isCharInAnyCar(otherPlayer) then

            clearCharTasksImmediately(otherPlayer)

        end

        if health == 0 then

            if not isRemotePlayerDead then

                isRemotePlayerDead = true

                if doesCharExist(otherPlayer) then

                    setCharHealth(otherPlayer, 0)

                end

            end

            return

        end

        if isRemotePlayerDead and health > 0 then

            isRemotePlayerDead = false

            if not doesCharExist(otherPlayer) then

                requestModel(106)
                loadAllModelsNow()

                while not hasModelLoaded(106) do wait(0) end

                otherPlayer = createChar(4, 106, x, y, z)
                otherPlayerBlip = addBlipForChar(otherPlayer)
                changeBlipColour(otherPlayerBlip, 2)

            else
                
                setCharCoordinates(otherPlayer, x, y, z)
                setCharHealth(otherPlayer, health)
                clearCharTasksImmediately(otherPlayer)

            end

            return

        end
        
        if not doesCharExist(otherPlayer) and not doesVehicleExist(otherPlayerCar) then

            requestModel(106)
            loadAllModelsNow()
            
            while not hasModelLoaded(106) do wait(0) end
            
            otherPlayer = createChar(4, 106, x, y, z)
            otherPlayerBlip = addBlipForChar(otherPlayer)
            changeBlipColour(otherPlayerBlip, 2)
            
        else
            
            setCharCoordinates(otherPlayer, x, y, z - 1.0)
            setCharVelocity(otherPlayer, vx, vy, vz)
            setCharHeading(otherPlayer, ha)
            setCharQuaternion(otherPlayer, qx, qy, qz, qw)
            setCharHealth(otherPlayer, health)

            if doesVehicleExist(otherPlayerCar) then

            otherPlayerCar = nil

            end

            if isJumping then

                taskPlayAnimNonInterruptable(otherPlayer, "JUMP_GLD", "PED", 4.1, false, true, true, false, 100)

            elseif math.abs(vx) < 0.05 and math.abs(vy) < 0.05 then

                clearCharTasks(otherPlayer)

            else

                if isWalk then

                    taskPlayAnimNonInterruptable(otherPlayer, "WALK_CIVI", "PED", 4.1, false, true, true, false, 100)

                else

                    taskPlayAnimNonInterruptable(otherPlayer, "RUN_CIVI", "PED", 4.1, false, true, true, false, 100)

                end

            end            

        end

    end

    if packetID == 2 then

        local engineOn = bitStream:read(BOOL)
        local cx = bitStream:read(FLOAT)
        local cy = bitStream:read(FLOAT)
        local cz = bitStream:read(FLOAT)
        local chealth = bitStream:read(UINT16)
        local cmodel = bitStream:read(UINT16)
        local cha = bitStream:read(FLOAT)
        local ccolour1 = bitStream:read(UINT8)
        local ccolour2 = bitStream:read(UINT8)
        local cspeed = bitStream:read(FLOAT)

        if not doesVehicleExist(otherPlayerCar) then

            requestModel(cmodel)
            loadAllModelsNow()
            
            while not hasModelLoaded(cmodel) do wait(0) end

            if doesVehicleExist(otherPlayerCarPlaceHolder) then

                otherPlayerCarPlaceHolder = nil

            end

            otherPlayerCar = createCar(cmodel, cx, cy, cz)
            markModelAsNoLongerNeeded(cmodel)
            warpCharIntoCar(otherPlayer, otherPlayerCar)
            changeCarColour(otherPlayerCar, ccolour1, ccolour2)

        else

            local cmlast = cmi
            local clx = cx
            local cly = cy
            local clz = cz

            setCarCoordinates(otherPlayerCar, cx, cy, cz)
            setCarForwardSpeed(otherPlayerCar, cspeed)
            setCarHeading(otherPlayerCar, cha)
            setCarHealth(otherPlayerCar, chealth)

            if not doesVehicleExist(otherPlayerCar) then

                otherPlayerCarPlaceHolder = createCar(cmlast, clx, cly, clz)
                changeCarColour(otherPlayerCarPlaceHolder, ccolour1, ccolour2)

            end

            if engineOn then

                setCarEngineOn(otherPlayerCar, true)

            else

                setCarEngineOn(otherPlayerCar, false)

            end

        end

    end
        
end

netHandle:setHook(onReceiveData)

function main()
    
    while not isOpcodesAvailable() do wait(1) end

    while true do
        
        wait(100)
        netHandle:loop()
        
    end
    
end
