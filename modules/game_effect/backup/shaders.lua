MAP_SHADERS = {
   { name = 'Cave', frag ='/shaders/cave.frag' },
   { name = 'Desert', frag ='/shaders/desert.frag' },
   { name = 'Dream', frag ='/shaders/dream.frag' },
   { name = 'Fire', frag ='/shaders/fire.frag' },
   { name = 'Fog', frag ='/shaders/fog.frag' },
   { name = 'Grayscale', frag ='/shaders/grayscale.frag' },
   { name = 'Heat', frag ='/shaders/heat.frag' },
   { name = 'Jungle', frag ='/shaders/jungle.frag' },
   { name = 'Noise', frag ='/shaders/noise.frag' },
   { name = 'OldTV', frag ='/shaders/oldtV.frag' },
   { name = 'Party', frag ='/shaders/party.frag' },
   { name = 'Pulse', frag ='/shaders/pulse.frag' },
   { name = 'Pyramid', frag ='/shaders/pyramid.frag' },
   { name = 'Radialblur', frag ='/shaders/radialblur.frag' },
   { name = 'Rain', frag ='/shaders/rain.frag' },
   { name = 'Sepia', frag ='/shaders/sepia.frag' },
   { name = 'Sky', frag ='/shaders/sky.frag' },
   { name = 'Snow', frag ='/shaders/snow.frag' },
   { name = 'Soil', frag ='/shaders/soil.frag' },
   { name = 'Storm', frag ='/shaders/storm.frag' },
   { name = 'Underwater', frag ='/shaders/underwater.frag' },
   { name = 'Wind', frag ='/shaders/wind.frag' },
   { name = 'Zomg', frag ='/shaders/zomg.frag' },
}

local lastShader
local areas = {
{from = {x = 979, y = 1022, z = 7}, to = {x = 1011, y = 1064, z = 7}, name = 'Desert'},
}

function isInRange(position, fromPosition, toPosition)
    return (position.x >= fromPosition.x and position.y >= fromPosition.y and position.z >= fromPosition.z and position.x <= toPosition.x and position.y <= toPosition.y and position.z <= toPosition.z)
end

function init()
   if not g_graphics.canUseShaders() then return end
   for _i,opts in pairs(MAP_SHADERS) do
     local shader = g_shaders.createFragmentShader(opts.name, opts.frag)

     if opts.tex1 then
       shader:addMultiTexture(opts.tex1)
     end
     if opts.tex2 then
       shader:addMultiTexture(opts.tex2)
     end
   end

   connect(LocalPlayer, {
     onPositionChange = updatePosition
   })
  
   local map = modules.game_interface.getMapPanel()
   map:setMapShader(g_shaders.getShader('Default'))
end

function terminate()

end

function updatePosition()
  local player = g_game.getLocalPlayer()
  if not player then return end
  local pos = player:getPosition()
  if not pos then return end
  
  local name = 'Default'  
  
  for _, TABLE in ipairs(areas) do
      if isInRange(pos, TABLE.from, TABLE.to) then
         name = TABLE.name
      end
  end
  if lastShader and lastShader == name then return true end
  
  lastShader = name
  local map = modules.game_interface.getMapPanel()
  map:setMapShader(g_shaders.getShader(name))
end       