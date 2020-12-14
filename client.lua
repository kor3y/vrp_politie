vRPpolitieC = {}
Tunnel.bindInterface("vrp_politie",vRPpolitieC)
Proxy.addInterface("vrp_politie",vRPpolitieC)
vRPpolitieS = Tunnel.getInterface("vrp_politie","vrp_politie")
vRP = Proxy.getInterface("vRP")

---[[Variabile]]---
local pos = {440.92849731445,-981.8310546875,30.689588546753}

rgbaMainMenu = {170,215,230,200}
rgbar = {255,255,255}
rgbas = {255,255,255}
rgbdm = {255,255,255}
rgbexitcolor = {255,255,255}

deschis = false
inTest = false
isNear = false
isNear1 = false

Citizen.CreateThread(function()
    while true do
        local pedCoords = GetEntityCoords(GetPlayerPed(-1))
        isNear = (Vdist(pedCoords,pos[1],pos[2],pos[3]) < 15.0)
        isNear1 =(Vdist(pedCoords,pos[1],pos[2],pos[3]) < 1.0)

        isCursorOnPermisPortArma = isCursorInPosition(0.3,0.63, 0.14,0.07)
        isCursorOnAsigurare = isCursorInPosition(0.5,0.63, 0.14,0.07)
        isCursorOnDmv = isCursorInPosition(0.7,0.63, 0.14,0.07)
        isCursorOnExit = isCursorInPosition(0.5,0.795, 0.03,0.03)
        Wait(100)
    end
end)


---[[Functii]]---
local function blockControls()
    local ped = GetPlayerPed(-1)
    DisableControlAction(0,   1,true) --- [Mouse Right] Look Left-Right
    DisableControlAction(0,   2,true) --- [Mouse Down] Look Up-Down
    DisableControlAction(0,  22,true) --- [Spacebar] Jump
    DisableControlAction(0,  24,true) --- [Mouse Left] Attack
    DisableControlAction(0,  58,true) --- [G] Throw Grenade
    DisableControlAction(0, 140,true) --- [R] Melle Attack Light
    DisableControlAction(0, 141,true) --- [Q] Melle Attack Heavy
    DisableControlAction(0, 142,true) --- [Mouse Left Click] Melle Attack Altrtnate
    DisableControlAction(0, 143,true) --- [Spacebar] Melle Block
    DisableControlAction(0, 257,true) --- [Mouse Left] Attack 2
    DisableControlAction(0, 263,true) --- [R] Melee Attack 1
    DisableControlAction(0, 264,true) --- [Q] Melle Attack 2
    FreezeEntityPosition(ped,   true) --- Freeze Ped
    DisablePlayerFiring(ped,    true) --- Disable weapon firing
end

local function exit()
    drawScreenText(1.0, 1.55, 0.4, "EXIT", rgbexitcolor[1],rgbexitcolor[2],rgbexitcolor[3], 255, 10)
    DrawRect(0.5,0.795, 0.03,0.03, rgbexitcolor[1],rgbexitcolor[2],rgbexitcolor[3],180)
    if isCursorOnExit then 
        rgbexitcolor = {200,0,0}
        SetMouseCursorSprite(5)
        if IsDisabledControlJustPressed(0, 24) then
            deschis = false
            FreezeEntityPosition(GetPlayerPed(-1), false)
            Wait(1)
            AnimpostfxStop("MenuMGHeistIn")
        end
    else
        rgbexitcolor = {255,255,255}
    end
end

local function permisPortArma()
    DrawRect(0.3,0.63, 0.14,0.07, rgbar[1],rgbar[2],rgbar[3],180)
    if isCursorOnPermisPortArma then
        rgbar = {80,220,100}
        SetMouseCursorSprite(5)
        if IsDisabledControlJustPressed(0, 24) then
            vRPpolitieS.cumparaPermisPortArma({})
        end
    else
        rgbar = {255,255,255}
    end
end

local function asigurare()
    DrawRect(0.5,0.63, 0.14,0.07, rgbas[1],rgbas[2],rgbas[3],180)
    if isCursorOnAsigurare then
        rgbas = {80,220,100}
        SetMouseCursorSprite(5)
        if IsDisabledControlJustPressed(0, 24) then
            vRPpolitieS.cumparaAsigurare({})
        end
    else
        rgbas = {255,255,255}
    end
end

local function dosarDMV()
    DrawRect(0.7,0.63, 0.14,0.07, rgbdm[1],rgbdm[2],rgbdm[3],180)
    if isCursorOnDmv then
        rgbdm = {80,220,100}
        SetMouseCursorSprite(5)
        if IsDisabledControlJustPressed(0, 24) then
            vRPpolitieS.cumparaDosarDMV({})
        end
    else
        rgbdm = {255,255,255}
    end
end

local positions = {{0.7,0.5},{0.5,0.5},{0.3,0.5}}
local photos = {{"dosardmv",0.7,0.45,0.15,0.25},{"permarma",0.3,0.45,0.15,0.20},{"asiguauto",0.5,0.43,0.13,0.25}}
local mainText = {{1.4,1.19,0.8, "Dosar DMV"},{1.0,1.19,0.8, "Asigurare"},{0.6,1.20,0.6, "Permis Port Arma"}  }
local secText = {{1.4,"500"},{1.0,"2.500"},{0.6,"10.000"}}

Citizen.CreateThread(function()
    while true do
        Wait(2)
        if isNear and deschis == false and inTest == false then
            DrawMarker(22, pos[1],pos[2],pos[3]-0.3, 0, 0, 0, 0, 0, 0, 0.6,0.1,0.6, rgbaMainMenu[1],rgbaMainMenu[2],rgbaMainMenu[3], 235, 0, 1, 0, 0, 0, 0, 0) 
            if isNear1 then
                drawScreenText(1.0, 1.7, 0.5, "~w~Apasa ~s~E ~w~ca sa vezi optiunile", rgbaMainMenu[1],rgbaMainMenu[2],rgbaMainMenu[3], 255, 10)
                if IsControlJustPressed(0, 38) then
                    deschis = true
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    CreateRuntimeTextureFromImage(CreateRuntimeTxd("dosardmv"), "dosardmv", "img/dosardmv.png")
    CreateRuntimeTextureFromImage(CreateRuntimeTxd("permarma"), "permarma", "img/permarma.png")
    CreateRuntimeTextureFromImage(CreateRuntimeTxd("asiguauto"), "asiguauto", "img/asiguauto.png")
    while true do
        Wait(1)
        if deschis then
            AnimpostfxPlay("MenuMGHeistIn",1,1)
            blockControls()
            if not inTest then
                SetMouseCursorActiveThisFrame()
                SetMouseCursorSprite(1)

                DrawRect(0.5,0.5, 10.0,10.0, rgbaMainMenu[1],rgbaMainMenu[2],rgbaMainMenu[3],25)

                for _, pos in pairs(positions) do DrawRect(pos[1],pos[2], 0.18,0.5, rgbaMainMenu[1],rgbaMainMenu[2],rgbaMainMenu[3],rgbaMainMenu[4]) end
                for _, maint in pairs(mainText) do drawScreenText(maint[1], maint[2], maint[3], maint[4], 255, 255, 255, 255, 10) end
                for _, sect in pairs(secText) do drawScreenText(sect[1], 1.33, 0.5, "~b~Pret: ~w~"..sect[2].." RON", 170,215,230,255, 10) end
                for _, photo in pairs(photos) do DrawSprite(photo[1],photo[1],photo[2],photo[3],photo[4],photo[5],0.0,255,255,255,255) end

                permisPortArma()
                asigurare()
                dosarDMV()
                exit()
            elseif inTest then
                if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                    SendNUIMessage({type = "click"})
                end
            end
        end
    end
end)

--=====================================================================================================================================--

--=====================================================================================================================================--

function vRPpolitieC.openGui()
    inTest = true
    SetNuiFocus(true)
    SendNUIMessage({openQuestion = true})
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
  vRPpolitieS.primesteDosarDMV({})
  vRP.notify({"~g~Ai trecut testul, te poti adresa la un politisti sa dai testul practic"})	
  inTest = false
end)

RegisterNUICallback('kick', function(data, cb)
  closeGui()
  cb('ok')
  vRP.notify({"~r~Ai picat testul, incearca din nou ziua urmatoare"})
  inTest = false
end)

--=====================================================================================================================================--

--=====================================================================================================================================--

function isCursorInPosition(x,y,width,height)
	local sx, sy = GetActiveScreenResolution()
    local cx, cy = GetNuiCursorPosition()
    local cx, cy = (cx / sx), (cy / sy)
	local width = width / 2
	local height = height / 2
  
    if (cx >= (x - width) and cx <= (x + width)) and (cy >= (y - height) and cy <= (y + height)) then
        return true
    else
        return false
    end
end

local fontId

RegisterFontFile('averta')
fontId = RegisterFontId('Averta')

function drawScreenText(x,y ,scale, text, r,g,b,a, font)
    if font == 10 then
        SetTextFont(fontId)
    else
        SetTextFont(font)
    end
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
	SetTextCentre(1)
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x/2, y/2 + 0.005)
end