local QBCore=exports['qb-core']:GetCoreObject()

local paEnabled=false
local paVolume=1.0

local paSound="policepa"
local activePA=false
local paSubmix=-1



CreateThread(function()

 paSubmix=CreateAudioSubmix(
  "PolicePA"
 )

 SetAudioSubmixEffectRadioFx(
  paSubmix,
 0
 )

 SetAudioSubmixEffectParamInt(
  paSubmix,
 0,
 `default`,
 1
 )

 AddAudioSubmixOutput(
  paSubmix,
 0
 )

end)



local function Notify(msg,typ)
 TriggerEvent(
  'QBCore:Notify',
  msg,
  typ or 'primary'
 )
end



function IsAuthorizedPoliceVehicle()

 local ped=PlayerPedId()

 if not IsPedInAnyVehicle(
  ped,false
 ) then
  return false
 end

 local veh=GetVehiclePedIsIn(
  ped,false
 )

 if GetPedInVehicleSeat(
  veh,-1
 )~=ped then
  return false
 end

 local model=GetEntityModel(
  veh
 )

 local heliAllow={
  [`polmav`]=true,
  [`buzzard`]=true,
  [`buzzard2`]=true,
  [`as350`]=true,
  [`swift`]=true,
  [`swift2`]=true,
  [`frogger`]=true,
  [`frogger2`]=true,
  [`supervolito`]=true,
  [`annihilator`]=true
 }

 if GetVehicleClass(
  veh
 )==18 then
  return true,veh
 end

 if heliAllow[model] then
  return true,veh
 end

 return false

end



local function EnablePAEffects()

 exports['pma-voice']:overrideProximityRange(
 120.0,
 true
 )

 -- radio distortion
 MumbleSetSubmixForServerId(
  GetPlayerServerId(
   PlayerId()
  ),
  paSubmix
 )

 NetworkSetTalkerProximity(
 120.0
 )

 -- self hear sidetone attempt
 MumbleSetAudioInputDistance(
 0.0
 )

 MumbleSetAudioOutputDistance(
 120.0
 )

 MumbleSetVolumeOverrideByServerId(
  GetPlayerServerId(
   PlayerId()
  ),
 1.0
 )

 TriggerEvent(
  "pma-voice:toggleSelfListen",
  true
 )

end



local function DisablePAEffects()

 exports['pma-voice']:clearProximityOverride()

 MumbleSetSubmixForServerId(
  GetPlayerServerId(
   PlayerId()
  ),
 -1
 )

 MumbleSetVolumeOverrideByServerId(
  GetPlayerServerId(
   PlayerId()
  ),
 -1.0
 )

 TriggerEvent(
  "pma-voice:toggleSelfListen",
  false
 )

end



RegisterCommand(
'pa',
function()

 local ok=
  IsAuthorizedPoliceVehicle()

 if not ok then
  Notify(
   'Must be in police vehicle',
   'error'
  )
 return
 end

 paEnabled=not paEnabled

 if paEnabled then

  EnablePAEffects()

  Notify(
   'PA MIC ENABLED',
   'success'
  )

 else

  DisablePAEffects()

  Notify(
   'PA MIC DISABLED',
   'error'
  )

 end

end,
false
)



RegisterCommand(
'paurl',
function(source,args)

 local ok,veh=
  IsAuthorizedPoliceVehicle()

 if not ok then
  Notify(
   'Must be in police vehicle',
   'error'
  )
 return
 end

 if not args[1] then
  Notify(
   '/paurl <stream>',
   'error'
  )
 return
 end

 local url=
  table.concat(
   args,
   ' '
  )

 TriggerServerEvent(
  'policepa:server:broadcastAudio',
  url,
  GetEntityCoords(
   veh
  )
 )

 Notify(
  'PA Broadcast Started',
  'success'
 )

end
)



RegisterCommand(
'paevac',
function()

 local ok,veh=
 IsAuthorizedPoliceVehicle()

 if not ok then
 return
 end

 TriggerServerEvent(
  'policepa:server:broadcastAudio',
  'https://www.youtube.com/watch?v=0hv1aauZqBs',
  GetEntityCoords(
   veh
  )
 )

 Notify(
  'Evac Tone Broadcast',
  'success'
 )

end
)



RegisterCommand(
'pastop',
function()

 activePA=false

 TriggerServerEvent(
  'policepa:server:stopAudio'
 )

 if exports["xsound"]:soundExists(
  paSound
 ) then
  exports["xsound"]:Destroy(
   paSound
  )
 end

 DisablePAEffects()
 paEnabled=false

 Notify(
  'PA stopped',
  'error'
 )

end
)



RegisterCommand(
'pavol',
function(source,args)

 local vol=
 tonumber(
  args[1]
 )

 if not vol then
 return
 end

 if vol<0.1 then vol=.1 end
 if vol>1.0 then vol=1 end

 paVolume=vol

 if exports["xsound"]:soundExists(
  paSound
 ) then

  exports["xsound"]:setVolumeMax(
   paSound,
   paVolume
  )

 end

 Notify(
 'PA volume '..vol,
 'success'
 )

end
)



RegisterNetEvent(
'policepa:client:receiveAudio',
function(url,coords)

 activePA=true

 if exports["xsound"]:soundExists(
  paSound
 ) then
  exports["xsound"]:Destroy(
   paSound
  )
 end

 exports["xsound"]:PlayUrlPos(
  paSound,
  url,
  .7,
  coords,
  false
 )

 exports["xsound"]:Distance(
  paSound,
 120.0
 )

 exports["xsound"]:setVolumeMax(
  paSound,
  paVolume
 )

end
)



RegisterNetEvent(
'policepa:client:stopAudio',
function()

 activePA=false

 if exports["xsound"]:soundExists(
  paSound
 ) then

  exports["xsound"]:Destroy(
   paSound
  )

 end

end
)



CreateThread(function()

 while true do
 Wait(250)

 if activePA then

  local ok,veh=
   IsAuthorizedPoliceVehicle()

  if ok and veh then

   exports["xsound"]:Position(
    paSound,
    GetEntityCoords(
     veh
    )
   )

  end

 end

 end

end)



-------------------------------------------------
-- AUTO DISABLE / VEHICLE DELETE FAILSAFE
-------------------------------------------------

CreateThread(function()

 while true do
 Wait(500)

 local ok,veh=
  IsAuthorizedPoliceVehicle()

 -- player left vehicle while PA active
 if paEnabled and not ok then

  paEnabled=false

  DisablePAEffects()

  TriggerServerEvent(
   'policepa:server:stopAudio'
  )

  if exports["xsound"]:soundExists(
   paSound
  ) then

   exports["xsound"]:Destroy(
    paSound
   )

  end

  activePA=false

  Notify(
   'PA disabled (left vehicle)',
   'error'
  )

 end


 -- vehicle deleted / exploded / dead
 if activePA then

  if not veh
   or veh==0
   or not DoesEntityExist(
      veh
     )
   or IsEntityDead(
      veh
     )
  then

   TriggerServerEvent(
    'policepa:server:stopAudio'
   )

   if exports["xsound"]:soundExists(
    paSound
   ) then

    exports["xsound"]:Destroy(
     paSound
    )

   end

   activePA=false
   paEnabled=false

   DisablePAEffects()

   Notify(
    'PA stopped (vehicle removed)',
    'error'
   )

  end

 end

 end

end)