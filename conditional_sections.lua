--[[
  Filter: conditional_sections.lua
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
local function is_truthy(val)
  if val == nil then return false end
  if type(val) == "boolean" then return val end
  if type(val) == "string" then return val ~= "false" and val ~= "" end
  if type(val) == "table" then
    if val.t == "MetaBool" then return val.c end
    if val.t == "MetaInlines" or val.t == "MetaString" then
      local str = pandoc.utils.stringify(val)
      return str ~= "false" and str ~= ""
    end
  end
  return true
end

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
  local q_vars = meta["_quarto-vars"]
  local c_vars = q_vars["course"]

  local apply_sections_filter = false
  local multiple_sections = false

  if c_vars["sections"] ~= nil then
    debug_print("[SECTIONS FILTER] Found sections in `course` variable. Applying filter")
    --debug_print("sections value: " .. c_vars["sections"])
    apply_sections_filter = true
    multiple_sections = #c_vars["sections"] > 1
    debug_print("Set multiple_sections filter value to " .. tostring(multiple_sections))
  elseif q_vars["n_sections"] ~= nil then
    debug_print("[SECTIONS FILTER] Found multiple_sections in general quarto variables. Applying filter")
    apply_sections_filter = true
  elseif meta["n_sections"] ~= nil then
    debug_print("[SECTIONS FILTER] Found multiple_sections in metadata. Applying filter")
    apply_sections_filter = is_truthy(meta_vars["multiple_sections"])
  else
    debug_print("[SECTIONS FILTER] Found no multiple_sections. Skipping filter. Printing metadata before aborting")

    debug_print("\n-----------------------------------------")
    debug_print("----- LUA DEBUG: STARTING META WALK -----")

    if meta and next(meta) ~= nil then
      for key, value in pairs(meta) do
        -- Convert complex Pandoc Meta objects into a clean, readable string
        local plain_text_value = pandoc.utils.stringify(value)

        -- Get the underlying type name for debugging purposes
        local type_name = type(value) == "table" and (value.t or "Table") or type(value)
        debug_print(string.format("Key: %-20s Type: %-12s Value: %s", key, type_name, plain_text_value))
      end
    else
      debug_print("[Warning] No frontmatter or document metadata found.")
    end

    debug_print("\n-----------------------------------------")
    debug_print("-- LUA DEBUG: STARTING QUARTO VARS WALK --")

    local q_vars = meta['_quarto-vars']["course"]

    if q_vars and type(q_vars) == "table" then
      for key, value in pairs(q_vars) do
        -- Flatten the nested value to plain text
        local plain_text = pandoc.utils.stringify(value)
        print(string.format("Key: %-25s Value: %s", key, plain_text))
      end
    else
      print("[Warning] _quarto-vars is missing or not a table.")
    end

    debug_print("\n-----------------------------------------")

  end

  debug_print("\n-----------------------------------------")
  debug_print("--- LUA DEBUG: STARTING DOCUMENT WALK ---")
  debug_print("-----------------------------------------")


  local filter = {
    Div = function(el)
      if not apply_sections_filter then
        debug_print("No filter. Skip")
        return el
      end

      -- Use debug_print instead of print
      debug_print("\n[DIV DETECTED]")

      debug_print("Checking for multiple_sections")

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

      local multiple_sections_attr = el.attributes['multiple_sections']

      if multiple_sections_attr == nil then
        debug_print("No multiple_sections attribute found, keeping block")
        return el
      end

      debug_print("multiple_sections attribute found: " .. tostring(multiple_sections))
      debug_print("Applying multiple_sections attribute")

      if multiple_sections then
      if is_truthy(multiple_sections_attr) then
          debug_print("Attribute value interpreted as true [multiple], keeping block")
        else
          debug_print("Attribute value interpreted as false [single], dropping block")
          return {}
        end
      else
        debug_print("Looking for a single sections")
        if is_truthy(multiple_sections_attr) then
          debug_print("Attribute value interpreted as true [multiple], dropping block")
          return {}
        else
          debug_print("Attribute value interpreted as false [single], dropping block")
        end
      end
    end
  }

  return doc:walk(filter)
end
