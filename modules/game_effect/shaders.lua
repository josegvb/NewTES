MAP_SHADERS = {
  { name = 'Default', frag = '/data/shaders/default.frag' },
{ name = 'Bloom', frag = '/data/shaders/bloom.frag'},
  { name = 'Sepia', frag ='/data/shaders/sepia.frag' },
  { name = 'Grayscale', frag ='/data/shaders/grayscale.frag' },
{ name = 'Pulse', frag = '/data/shaders/pulse.frag' },
  { name = 'Old Tv', frag = '/data/shaders/oldtv.frag' },
  { name = 'Fog', frag = '/data/shaders/fog.frag', tex1 = '/data/shaders/clouds.png' },
  { name = 'Fog1', frag = '/data/shaders/fog1.frag', tex1 = '/data/shaders/clouds1.png' },
  { name = 'Fog2', frag = '/data/shaders/fog2.frag', tex1 = '/data/shaders/clouds2.png' },
  { name = 'Fog3', frag = '/data/shaders/fog.frag', tex1 = '/data/shaders/clouds2.png' },
  { name = 'Party', frag = '/data/shaders/party.frag' },
  { name = 'Radial Blur', frag ='/data/shaders/radialblur.frag' },
 { name = 'Heat', frag ='/data/shaders/heat.frag' },
{ name = 'Heat1', frag ='/data/shaders/heat1.frag' },
 { name = 'Noise', frag ='/data/shaders/noise.frag' },
  { name = 'Zomg', frag ='/data/shaders/zomg.frag' },
}



local areas = {
{from = {x = 726, y = 1188, z = 13}, to = {x = 847, y = 1200, z = 13}, name = 'Fog'},
{from = {x = 853, y = 1194, z = 13}, to = {x = 872, y = 1204, z = 13}, name = 'Fog2'},
{from = {x = 782, y = 1104, z = 14}, to = {x = 958, y = 1208, z = 14}, name = 'Fog3'},
-- {from = {x = 1024, y = 1037, z = 7}, to = {x = 1032, y = 1042, z = 7}, name = 'Fog1'},
-- {from = {x = 1176, y = 1220, z = 7}, to = {x = 1185, y = 1238, z = 7}, name = 'Bloom'},
-- {from = {x = 1176, y = 1220, z = 7}, to = {x = 1185, y = 1233, z = 7}, name = 'Sepia'},
-- {from = {x = 1024, y = 1037, z = 7}, to = {x = 1032, y = 1042, z = 7}, name = 'Fog3'},
-- {from = {x = 1177, y = 1198, z = 7}, to = {x = 1182, y = 1201, z = 7}, name = 'Radial Blur'},
-- {from = {x = 1177, y = 1187, z = 7}, to = {x = 1182, y = 1190, z = 7}, name = 'Zomg'},
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