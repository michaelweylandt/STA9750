--[[
  Filter: meta_filter.lua
  Author: Michael Weylandt w/Gemini (AI Assistant)
  Description: Selectively hides or shows content blocks (Divs)
               based on Quarto metadata values.
               This is used to selectively control minor
               'inserts' into slides, allowing things like
               music and life tips to be organized centrally.

  Usage in Markdown:

  ::: {when-meta="session:1"}

  This content only appears if 'session: 1' is in the YAML.

  :::
]]

-- TOGGLE THIS TO TRUE TO SEE TERMINAL LOGS
local DEBUG = false

-- Helper function to handle conditional printing
local function debug_print(...)
  if DEBUG then
    print(...)
  end
end

function Pandoc(doc)
  local meta = doc.meta

  debug_print("\n----------------------------------------")
  debug_print("--- LUA DEBUG: STARTING DOCUMENT WALK ---")
  debug_print("----------------------------------------")

  local filter = {
    Div = function(el)
      -- Use debug_print instead of print
      debug_print("\n[DIV DETECTED]")

      local has_attributes = false
      for k, v in pairs(el.attributes) do
        if not has_attributes then
          debug_print("  Attributes:")
          has_attributes = true
        end
        debug_print("    - " .. k .. " = " .. v)
      end

      if not has_attributes then
        debug_print("  Attributes: (none)")
      end

      local when_meta = el.attributes['when-meta']

      if when_meta then
        local key, val = when_meta:match("([^:]+):(.+)")
        debug_print("--- DEBUG: Found a conditional Div ---")
        debug_print("Target Key: " .. tostring(key))
        debug_print("Target Value: " .. tostring(val))

        if key and meta[key] then
          local actual_val = pandoc.utils.stringify(meta[key])
          local test_val = pandoc.utils.stringify(val)

          debug_print("Actual val: " .. actual_val)
          debug_print("Test val: " .. test_val)

          if actual_val ~= test_val then
            debug_print("RESULT: Mismatch. Hiding block.")
            return {}
          end
          debug_print("RESULT: Match. Keeping block.")
        end
      end

      return el
    end
  }

  return doc:walk(filter)
end
