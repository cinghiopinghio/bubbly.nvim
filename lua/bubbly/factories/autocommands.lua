-- ===================
-- AUTOCOMMAND FACTORY
-- ===================
-- Created by datwaft <github.com/datwaft>

-- ====================
-- Auxiliars definition
-- ====================
   local function processEvents(events)
      local result = ''
      for i, e in ipairs(events) do
         result = result..e
         if i + 1 ~= #events then
            result = result..','
         end
      end
      return result
   end
   local function processVariable(variable)
      local result
      if variable.type == 'buffer' then
         result = 'b:'
      elseif variable.type == 'window' then
         result = 'w:'
      elseif variable.type == 'global' then
         result = 'g:'
      else
         result = 'g:'
      end
      result = result..variable.name
      return result
   end
   local function generateRandomVariableName()
      math.randomseed(os.clock()^5)
      local result = 'bubbly_command_'
      for _ = 0, 16 do
         result = result .. string.char(math.random(97, 122))
      end
      return result
   end
   local function autocmd(autocommand)
      local id = generateRandomVariableName()
      _G[id] = autocommand.command
      vim.cmd('autocmd '..processEvents(autocommand.events)..' * let '..processVariable(autocommand.variable)..' = v:lua.'..id..'()')
      print('autocmd '..processEvents(autocommand.events)..' * let '..processVariable(autocommand.variable)..' = v:lua.'..id..'()')
   end
-- ==================
-- Factory definition
-- ==================
   return function(list)
      for _, e in ipairs(list) do
         local type = type(e)
         if type == 'string' then
            local autocommand = require'bubbly_utils'.prerequire('bubbly.autocommands.'..e:lower())
            if autocommand then
               autocmd(autocommand)
            end
         end
      end
   end
