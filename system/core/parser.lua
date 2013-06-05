-- ProbablyEngine v0.0.1
-- Ben Phelps (c) 2013

-- Credits to iLulz (JPS) for the idea
-- of a spell table.  It works great.

ProbablyEngine.parser = {
  lastCast = ''
}

local function castable(spell, unit)
  -- Credits to iLulz (JPS) for this function
  if spell == nil then return false end
  if unit == nil then unit = "target" end
  local skillType, spellId = GetSpellBookItemInfo(spell)
  local isUsable, notEnoughMana = IsUsableSpell(spell)
  local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange = GetSpellInfo(spellId)
  if not isUsable then return false end
  if notEnoughMana then return false end
  if not UnitExists(unit) then return false end
  if not UnitIsVisible(unit) then return false end
  if UnitIsDeadOrGhost(unit) then return false end
  if SpellHasRange(spell) == 1 and IsSpellInRange(spell, unit) == 0 then return false end
  if select(2, GetSpellCooldown(spell)) ~= 0 then return false end
  if ProbablyEngine.module.player.casting == true then return false end
  if select(1, UnitChannelInfo("player")) == ProbablyEngine.parser.lastCast then return false end
  return true
end

ProbablyEngine.parser.table = function(spellTable)

  for _, arguments in pairs(spellTable) do

    local eventType = type(arguments[1])
    local spell = arguments[1]
    local evaluation = arguments[2]
    local target = arguments[3]

    if eventType == "table" then
      ProbablyEngine.debug("Table Parse: Table")
    end

    if evaluation == nil then
      evaluation = true
    else
      evaluation = evaluation()
    end

    if target == nil then
      target = "target"
    end

    if castable(spell, target) and evaluation then
      ProbablyEngine.debug("Table Parse: Cast Spell - " .. spell)
      ProbablyEngine.parser.lastCast = spell
      return spell, target
    end

  end

  spellTable = nil

end