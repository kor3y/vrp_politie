local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPpolitieS = {}
Tunnel.bindInterface("vrp_politie",vRPpolitieS)
Proxy.addInterface("vrp_politie",vRPpolitieS)
vRPpolitieC = Tunnel.getInterface("vrp_politie","vrp_politie")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_politie")

function vRPpolitieS.cumparaPermisPortArma()
    local user_id = vRP.getUserId({source})
    if user_id then
        if tonumber(vRP.getInventoryItemAmount({user_id,"portarma"})) == 0 then
            if vRP.tryFullPayment({user_id, 10000}) then
                vRP.giveInventoryItem({user_id,"portarma",1,true})
            else
                vRPclient.notify(source,{"~r~Nu ai destui bani"})
            end
        else
            vRPclient.notify(source,{"~r~Ai deja permis port arma"})
        end
    end
end

function vRPpolitieS.cumparaAsigurare()
    local user_id = vRP.getUserId({source})
    if user_id then
        if tonumber(vRP.getInventoryItemAmount({user_id,"asigurare"})) == 0 then
            if vRP.tryFullPayment({user_id, 2500}) then
                vRP.giveInventoryItem({user_id,"asigurare",1,true})
            else
                vRPclient.notify(source,{"~r~Nu ai destui bani"})
            end
        else
            vRPclient.notify(source,{"~r~Ai deja asigurare"})
        end
    end
end

function vRPpolitieS.cumparaDosarDMV()
    local user_id = vRP.getUserId({source})
    if user_id then
        if tonumber(vRP.getInventoryItemAmount({user_id,"permis"})) == 0 then
            if tonumber(vRP.getInventoryItemAmount({user_id,"dosardmv"})) == 0 then
                if vRP.tryFullPayment({user_id, 500}) then
                    vRPpolitieC.openGui(source,{})
                else
                    vRPclient.notify(source,{"~r~Nu ai destui bani"})
                end
            else
                vRPclient.notify(source,{"~r~Ai deja un dosar dmv"})
            end
        else
            vRPclient.notify(source,{"~r~Detii deja un permis auto nu ai nevoie de un dosar dmv"})
        end
    end
end

function vRPpolitieS.primesteDosarDMV()
    local user_id = vRP.getUserId({source})
    if user_id then
        if tonumber(vRP.getInventoryItemAmount({user_id,"dosardmv"})) == 0 then
            vRP.giveInventoryItem({user_id,"dosardmv",1,true})
        end
    end
end

--[[Politie]]--
local ch_cereasigu = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(tplayer)
    local tuser_id = vRP.getUserId({tplayer})
    if tuser_id then
      vRPclient.notify(player,{"Ceri asigurarea..."})
      vRP.request({tplayer,"Vrei sa îi arati Asigurarea?",30,function(tplayer,ok)
        if ok then
          local numar = vRP.getInventoryItemAmount({tuser_id,"asigurare"})
          if numar > 0 then
            vRPclient.notify(player,{"Asigurare: ~g~Da"})
          else
            vRPclient.notify(player,{"Asigurare: ~r~Nu"})
          end
        else
          vRPclient.notify(player,{"~g~"..GetPlayerName(tplayer).." ~w~a refuzat cererea"})
        end
      end})
    else
      vRPclient.notify(player,{"~r~Nici un jucator in preajma"})
    end
  end)
end, "Cere asigurarea celui mai apropriat jucator."}

local ch_cereportarma = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(tplayer)
    local tuser_id = vRP.getUserId({tplayer})
    if tuser_id then
      vRPclient.notify(player,{"Ceri Permisul Port Arma..."})
      vRP.request({tplayer,"Vrei sa îi arati Permisul Port Arma?",30,function(tplayer,ok)
        if ok then
          local numar = vRP.getInventoryItemAmount({tuser_id,"portarma"})
          if numar > 0 then
            vRPclient.notify(player,{"Permisul Port Arma: ~g~Da"})
          else
            vRPclient.notify(player,{"Permisul Port Arma: ~r~Nu"})
          end
        else
          vRPclient.notify(player,{"~g~"..GetPlayerName(tplayer).." ~w~a refuzat cererea"})
        end
      end})
    else
      vRPclient.notify(player,{"~r~Nici un jucator in preajma"})
    end
  end)
end, "Cere permisul port arma celui mai apropriat jucator."}

local ch_verificadmv = {function(player,choice)
    vRPclient.getNearestPlayer(player,{10},function(tplayer)
    local tuser_id = vRP.getUserId({tplayer})
    if tuser_id then
        vRPclient.notify(player,{"Verifici dosarul DMV..."})
            local numar = vRP.getInventoryItemAmount({tuser_id,"dosardmv"})
            if numar > 0 then
                vRPclient.notify(player,{"Dosar DMV: ~g~Da"})
            else
                vRPclient.notify(player,{"Dosar DMV: ~r~Nu"})
            end
        else
            vRPclient.notify(player,{"~r~Nici un jucator in preajma"})
        end
    end)
end, "Cere permisul port arma celui mai apropriat jucator."}


local ch_confiscaasigu = {function(player, choice)
  local user_id = vRP.getUserId({player})
  local name = GetPlayerName(player)
  vRPclient.getNearestPlayer(player,{10},function(tplayer)
    local tuser_id = vRP.getUserId({tplayer})
    if tuser_id then
    local tname = GetPlayerName(tplayer)
      local numar = vRP.getInventoryItemAmount({tuser_id,"portarma"})
      if numar > 0 then
        vRPclient.notify(player,{"~g~I-ai confiscat asigurarea lui: ~g~"..tname.."~w~[~g~"..tuser_id.."~w~]!"})
        vRPclient.notify(tplayer,{"~g~"..name.."~w~[~g~"..user_id.."~w~] ~r~ti-a confiscat asigurarea!"})
        vRP.tryGetInventoryItem({tuser_id,"asigurare",1,false})
        TriggerClientEvent('portarma', tplayer, 1)
      else
        vRPclient.notify(player,{"~r~Jucatorul nu detine un permis port arma!"})
      end
    else
      vRPclient.notify(player,{"~r~Nici un jucator in preajma"})
    end
  end)
end, "Confisca permis-ul unui jucator"}

local ch_confiscaportarma = {function(player, choice)
  local user_id = vRP.getUserId({player})
  local name = GetPlayerName(player)
  vRPclient.getNearestPlayer(player,{10},function(tplayer)
    local tuser_id = vRP.getUserId({tplayer})
    if tuser_id then
    local tname = GetPlayerName(tplayer)
      local numar = vRP.getInventoryItemAmount({tuser_id,"asigurare"})
      if numar > 0 then
        vRPclient.notify(player,{"~g~I-ai confiscat permisul port arma lui: ~g~"..tname.."~w~[~g~"..tuser_id.."~w~]!"})
        vRPclient.notify(tplayer,{"~g~"..name.."~w~[~g~"..user_id.."~w~] ~r~ti-a confiscat permisul port arma!"})
        vRP.tryGetInventoryItem({tuser_id,"asigurare",1,false})
        TriggerClientEvent('asigurare', tplayer, 1)
      else
        vRPclient.notify(player,{"~r~Jucatorul nu detine o asigurare!"})
      end
    else
      vRPclient.notify(player,{"~r~Nici un jucator in preajma"})
    end
  end)
end, "Confisca permis-ul unui jucator"}

vRP.registerMenuBuilder({"police", function(add, data)
  local player = data.player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    local choices = {}
    if vRP.hasPermission({user_id,"politie.cere.asigurare"}) then
       choices["Cere asigurare"] = ch_cereasigu
    end
    if vRP.hasPermission({user_id,"politie.confisca.asigurare"}) then
       choices["Confisca asigurare"] = ch_confiscaasigu
    end
    if vRP.hasPermission({user_id,"politie.cere.portarma"}) then
       choices["Cere permis port arma"] = ch_cereportarma
    end
    if vRP.hasPermission({user_id,"politie.confisca.portarma"}) then
       choices["Confisca permis port arma"] = ch_confiscaportarma
    end

    if vRP.hasPermission({user_id,"politie.ofera.permis"}) then
        choices["Verifica Dosar DMV"] = ch_verificadmv
    end
	
    add(choices)
  end
end})