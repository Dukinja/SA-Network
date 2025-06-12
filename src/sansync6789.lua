script_name('sender')
script_author('duke')

require('lib.moonloader')

local SLNet = require('SLNet')
local memory = require('memory')

local netHandle = SLNetInit()
netHandle:connect('26.174.80.45', 6789)
netHandle:setPrefix('SAN_SYNC')

function sendOnFoot()

    if isCharInAnyCar(PLAYER_PED) then return end
    
    local x, y, z = getCharCoordinates(PLAYER_PED)
    local vx, vy,vz = getCharVelocity(PLAYER_PED)
    local ha = getCharHeading(PLAYER_PED)
    local qx, qy, qz, qw = getCharQuaternion(PLAYER_PED)
    local ch = getCharHealth(PLAYER_PED)
    local isWalk = isKeyDown(0xA4)
    local isJumping = isKeyDown(0xA0)
    local skin = getCharModel(PLAYER_PED)

    local bs = BitStream:new()
    bs:write(FLOAT, x)
    bs:write(FLOAT, y)
    bs:write(FLOAT, z)
    bs:write(FLOAT, vx)
    bs:write(FLOAT, vy)
    bs:write(FLOAT, vz)
    bs:write(FLOAT, ha)
    bs:write(FLOAT, qx);
    bs:write(FLOAT, qy);
    bs:write(FLOAT, qz);
    bs:write(FLOAT, qw); 
    bs:write(UINT8, ch);
    bs:write(BOOL, isWalk)
    bs:write(BOOL, isJumping)
    bs:write(UINT8, skin)

    SLNetSend(netHandle, 1, bs, 1)
    
end

function sendInCar()

    if not isCharInAnyCar(PLAYER_PED) then return end

    local playerCar = storeCarCharIsInNoSave(PLAYER_PED)

    local engState = isCarEngineOn(playerCar)
    local carx, cary, carz = getCarCoordinates(playerCar)
    local carhealth = getCarHealth(playerCar)
    local carmodel = getCarModel(playerCar)
    local carha = getCarHeading(playerCar)
    local carcolour1, carcolour2 = getCarColours(playerCar)
    local carspeed = getCarSpeed(playerCar)

    local bs = BitStream:new()

    bs:write(BOOL, engState)
    bs:write(FLOAT, carx)
    bs:write(FLOAT, cary)
    bs:write(FLOAT, carz)
    bs:write(UINT16, carhealth)
    bs:write(UINT16, carmodel)
    bs:write(FLOAT, carha)
    bs:write(UINT8, carcolour1)
    bs:write(UINT8, carcolour2)
    bs:write(FLOAT, carspeed)

    SLNetSend(netHandle, 2, bs, 1)

end

function main()
    
    while not isOpcodesAvailable() do wait(1) end

    while true do
        
        wait(100)
        netHandle:loop()
        sendOnFoot()
        sendInCar()
        
    end
    
end
