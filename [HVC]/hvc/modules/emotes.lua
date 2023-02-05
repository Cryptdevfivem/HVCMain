
-- this module define the emotes menu

local cfg = module("cfg/emotes")
local lang = HVC.lang

local emotes = cfg.emotes

local function ch_emote(player,choice)
  local emote = emotes[choice]
  if emote then
    HVCclient.playAnim(player,{emote[1],emote[2],emote[3]})
  end
end

-- add emotes menu to main men
