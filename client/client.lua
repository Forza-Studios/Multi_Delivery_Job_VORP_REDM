-- coi_multi_deli | Phase 1: Meet Contractor blip + NPC

local contractorPed = nil
local contractorBlip = nil
local contractPrompt = nil
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local contractsTaken = false

local function BlipForCoords(style, x, y, z)
    if BlipAddForCoords then
        return BlipAddForCoords(style, x, y, z)
    end
    return Citizen.InvokeNative(0x554D9D53F696D002, style, x, y, z)
end

local function SetBlipNameSafe(blip, name)
    if SetBlipName then
        SetBlipName(blip, name)
    else
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, name)
    end
end

local function SetBlipSpriteSafe(blip, sprite)
    if SetBlipSprite then
        SetBlipSprite(blip, sprite, true)
    else
        Citizen.InvokeNative(0x74F74D3207ED525C, blip, sprite, true)
    end
end

local function SetBlipScaleSafe(blip, scale)
    if not blip or blip == 0 then return end
    if not DoesBlipExist(blip) then return end
    if SetBlipScale then
        SetBlipScale(blip, scale)
    else
        Citizen.InvokeNative(0xD387445136465429, blip, scale)
    end
end

local function AddBlipModifierSafe(blip, modifier)
    if not blip or blip == 0 then return end
    if not DoesBlipExist(blip) then return end
    if BlipAddModifier then
        BlipAddModifier(blip, joaat(modifier))
    else
        Citizen.InvokeNative(0x662D364AB9433425, blip, joaat(modifier))
    end
end

local function CreateContractorBlip()
    local b = Config.Blip
    local c = Config.Contractor.coords
    if contractorBlip and DoesBlipExist(contractorBlip) then
        RemoveBlip(contractorBlip)
        contractorBlip = nil
    end
    contractorBlip = BlipForCoords(b.style, c.x, c.y, c.z)
    SetBlipSpriteSafe(contractorBlip, b.sprite)
    SetBlipScaleSafe(contractorBlip, b.scale or 0.6)
    AddBlipModifierSafe(contractorBlip, b.modifier) -- pink
    SetBlipNameSafe(contractorBlip, b.name)
end

local function RegisterContractPrompt()
    contractPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(contractPrompt, Config.Prompt.control) -- L key
    UiPromptSetText(contractPrompt, VarString(10, "LITERAL_STRING", Config.Prompt.text))
    UiPromptSetEnabled(contractPrompt, true)
    UiPromptSetVisible(contractPrompt, true)
    UiPromptSetHoldMode(contractPrompt, Config.Prompt.holdTime) -- 10 sec hold
    UiPromptSetGroup(contractPrompt, promptGroup, 0)
    UiPromptRegisterEnd(contractPrompt)
end

local function SpawnContractor()
    local cfg = Config.Contractor
    local hash = joaat(cfg.model)

    if not IsModelValid(hash) then
        print("[coi_multi_deli] invalid NPC model: " .. tostring(cfg.model))
        return
    end

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local timeout = 0
        while not HasModelLoaded(hash) and timeout < 10000 do
            Wait(50)
            timeout = timeout + 50
        end
    end

    if not HasModelLoaded(hash) then
        print("[coi_multi_deli] NPC model failed to load: " .. tostring(cfg.model))
        return
    end

    local ped = CreatePed(hash, cfg.coords.x, cfg.coords.y, cfg.coords.z, cfg.coords.w, false, false, false, false)
    local timeout = 0
    while (not DoesEntityExist(ped) or ped == 0) and timeout < 5000 do
        Wait(100)
        timeout = timeout + 100
    end
    if not DoesEntityExist(ped) then return end

    contractorPed = ped
    SetRandomOutfitVariation(ped, true)
    SetEntityCanBeDamaged(ped, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- Standing smoking idle.
    TaskStartScenarioInPlace(ped, joaat(cfg.scenario), -1, true, false, false, false)
    Wait(1500)
    FreezeEntityPosition(ped, true)

    SetModelAsNoLongerNeeded(hash)
end

CreateThread(function()
    CreateContractorBlip()
    SpawnContractor()
    RegisterContractPrompt()

    -- Keep contractor alive for the whole session
    while true do
        Wait(30000)
        if not contractorPed or not DoesEntityExist(contractorPed) or IsEntityDead(contractorPed) then
            if contractorPed and DoesEntityExist(contractorPed) then
                DeletePed(contractorPed)
            end
            contractorPed = nil
            SpawnContractor()
        end
        -- Re-create blip if it somehow got removed
        if not contractorBlip or not DoesBlipExist(contractorBlip) then
            CreateContractorBlip()
        end
    end
end)

-- Hold-L prompt loop: shows "Take contracts" near the contractor.
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        if playerPed and playerPed ~= 0 and contractorPed and DoesEntityExist(contractorPed) then
            local playerCoords = GetEntityCoords(playerPed)
            local c = Config.Contractor.coords
            local dist = #(playerCoords - vector3(c.x, c.y, c.z))
            if dist < Config.Prompt.radius and not contractsTaken then
                sleep = 0
                local groupName = VarString(10, "LITERAL_STRING", Config.Prompt.groupName)
                UiPromptSetActiveGroupThisFrame(promptGroup, groupName, 0, 0, 0, 0)
                if UiPromptHasHoldModeCompleted(contractPrompt) then
                    contractsTaken = true
                    TriggerEvent("coi_multi_deli:client:contractsTaken")
                    Wait(1000)
                end
            end
        end
        Wait(sleep)
    end
end)

-- Next phase hooks in here. Placeholder feedback for now.
RegisterNetEvent("coi_multi_deli:client:contractsTaken", function()
    print("[coi_multi_deli] contracts taken")
    if GetResourceState("vorp_core") == "started" then
        pcall(function()
            TriggerEvent("vorp:TipRight", "Contracts taken", 4000)
        end)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if contractorPed and DoesEntityExist(contractorPed) then
        DeletePed(contractorPed)
    end
    if contractorBlip and DoesBlipExist(contractorBlip) then
        RemoveBlip(contractorBlip)
    end
end)
