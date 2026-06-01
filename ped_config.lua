local PED_MODEL_NAME = "ped_name"
local PED_MODEL_HASH = GetHashKey(PED_MODEL_NAME)

local CAM_SETTINGS_PED = {
    distance = 2.5,
    close = 1.5,
    height = -0.1,
    close_height = -0.1,
    fov = 70.0
}

local CAM_SETTINGS_VEHICLE = {
    distance = 4.5,
    close = 2.5,
    height = 1.0,
    close_height = 0.8
}

local cam = nil
local camActive = false

local function isTargetPed()
    return GetEntityModel(PlayerPedId()) == PED_MODEL_HASH
end

local function ensureCam()
    if not cam or not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, true)
    end
end

local function setRenderScriptCams(state)
    if state == camActive then
        return
    end
    RenderScriptCams(state, false, 0, true, true)
    camActive = state
end

local function destroyCam()
    setRenderScriptCams(false)
    if cam and DoesCamExist(cam) then
        DestroyCam(cam, false)
        cam = nil
    end
end

local function calcCamCoord(pos, rot, distance, height)
    local pitch = math.rad(rot.x)
    local yaw = math.rad(rot.z)
    local forward = distance * math.cos(pitch)
    local vertical = distance * math.sin(pitch)

    local offsetX = forward * math.sin(yaw)
    local offsetY = -forward * math.cos(yaw)

    return pos.x + offsetX, pos.y + offsetY, pos.z + height - vertical
end

local function updateCam(pos, rot, distance, height, fov)
    if not DoesCamExist(cam) then
        return
    end
    local cx, cy, cz = calcCamCoord(pos, rot, distance, height)
    SetCamCoord(cam, cx, cy, cz)
    SetCamRot(cam, rot.x, rot.y, rot.z, 2)
    SetCamFov(cam, fov)
end

local function handleOnFoot()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, true)
    local rot = GetGameplayCamRot(2)
    local viewMode = GetFollowPedCamViewMode()

    if viewMode == 0 then
        SetFollowPedCamViewMode(1)
        viewMode = 1
    end

    if viewMode == 4 then
        setRenderScriptCams(false)
    else
        ensureCam()
        setRenderScriptCams(true)
        local distance = (viewMode == 1) and CAM_SETTINGS_PED.close or CAM_SETTINGS_PED.distance
        local height = (viewMode == 1) and CAM_SETTINGS_PED.close_height or CAM_SETTINGS_PED.height
        updateCam(pos, rot, distance, height, CAM_SETTINGS_PED.fov)
    end
end

local function handleInVehicle(vehicle)
    local pos = GetEntityCoords(vehicle, true)
    local rot = GetGameplayCamRot(2)
    local viewMode = GetFollowVehicleCamViewMode()

    if viewMode == 0 then
        SetFollowVehicleCamViewMode(1)
        viewMode = 1
    end

    if viewMode == 4 then
        setRenderScriptCams(false)
    else
        ensureCam()
        setRenderScriptCams(true)
        local distance = (viewMode == 1) and CAM_SETTINGS_VEHICLE.close or CAM_SETTINGS_VEHICLE.distance
        local height = (viewMode == 1) and CAM_SETTINGS_VEHICLE.close_height or CAM_SETTINGS_VEHICLE.height
        updateCam(pos, rot, distance, height, GetGameplayCamFov())
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if not isTargetPed() then
            if cam then
                destroyCam()
            end
        else
            local player = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(player, false)
            if vehicle ~= 0 then
                handleInVehicle(vehicle)
            else
                handleOnFoot()
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        destroyCam()
    end
end)
