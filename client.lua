local Config = {
    key                = 'G',    -- default key. Players can rebind it in Settings > Key Bindings > FiveM
    radius             = 20.0,   -- how far away IDs are shown
    showSelf           = true,   -- show your own ID too
    requireLineOfSight = true,   -- hide IDs of players behind walls
    hideInvisible      = true,   -- hide IDs of invisible players (e.g. staff in noclip)
    talkingColor       = { 59, 214, 118 }, -- ID turns this colour while that player is talking
    refreshMs          = 200,    -- how often the nearby-player list is rebuilt
}

local HEAD_BONE = 31086
local showing = false
local nearby = {}

local function drawText3D(x, y, z, text, r, g, b, scale)
    local onScreen, sx, sy = GetScreenCoordFromWorldCoord(x, y, z)
    if not onScreen then return end
    SetTextScale(0.0, scale)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(r, g, b, 225)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(sx, sy)
end

local function refresh()
    local me = PlayerPedId()
    local myPos = GetEntityCoords(me)
    local myPlayer = PlayerId()
    local list = {}

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= myPlayer then
            local ped = GetPlayerPed(player)
            if ped ~= 0 and DoesEntityExist(ped)
                and #(myPos - GetEntityCoords(ped)) <= Config.radius
                and (not Config.hideInvisible or IsEntityVisible(ped))
                and (not Config.requireLineOfSight or HasEntityClearLosToEntity(me, ped, 17))
            then
                list[#list + 1] = { ped = ped, player = player, id = GetPlayerServerId(player) }
            end
        end
    end

    nearby = list
end

local function drawFor(ped, player, id, myPos)
    local head = GetPedBoneCoords(ped, HEAD_BONE, 0.0, 0.0, 0.0)
    local dist = #(myPos - head)
    local scale = math.max(0.28, 0.42 - dist * 0.007)

    local r, g, b = 255, 255, 255
    if NetworkIsPlayerTalking(player) then
        r, g, b = Config.talkingColor[1], Config.talkingColor[2], Config.talkingColor[3]
    end

    drawText3D(head.x, head.y, head.z + 0.35, tostring(id), r, g, b, scale)
end

RegisterCommand('+showids', function()
    if showing then return end
    showing = true
    refresh()

    CreateThread(function()
        local nextRefresh = GetGameTimer() + Config.refreshMs
        while showing do
            local now = GetGameTimer()
            if now >= nextRefresh then
                refresh()
                nextRefresh = now + Config.refreshMs
            end

            local me = PlayerPedId()
            local myPos = GetEntityCoords(me)

            if Config.showSelf then
                drawFor(me, PlayerId(), GetPlayerServerId(PlayerId()), myPos)
            end

            for i = 1, #nearby do
                local p = nearby[i]
                if DoesEntityExist(p.ped) then
                    drawFor(p.ped, p.player, p.id, myPos)
                end
            end

            Wait(0)
        end
        nearby = {}
    end)
end, false)

RegisterCommand('-showids', function()
    showing = false
end, false)

RegisterKeyMapping('+showids', 'Show player IDs (hold)', 'keyboard', Config.key)
