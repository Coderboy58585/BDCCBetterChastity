extends StatusEffectBase

var stacks = 1.0

func _init():
	id = "BBC_PlapgasmCharge"
	isBattleOnly = false
	isSexEngineOnly = false

func initArgs(_args = []):
	turns = int(_args[0]) if _args.size() > 0 else 60 * 45
	stacks = float(_args[1]) if _args.size() > 1 else 1.0
	clampValues()

func processTime(_secondsPassed: int):
	turns -= _secondsPassed
	if(turns <= 0):
		stop()

func getEffectName():
	return "Plapgasm charge"

func getEffectDesc():
	return "Repeated Better Chastity toy rhythm has primed your body for indirect, pressure-based peaks for "+Util.getTimeStringHumanReadable(turns)+"."

func getEffectImage():
	return "res://Images/StatusEffects/heartburn.png"

func getIconColor():
	return IconColorBrightPurple

func combine(_args = []):
	if(_args.size() > 0):
		turns = max(turns, int(_args[0]))
	if(_args.size() > 1):
		stacks += float(_args[1])
	else:
		stacks += 0.5
	clampValues()

func getBuffs():
	return [
		buff(Buff.SensitivityGainBuff, [BodypartSlot.Anus, 16.0 + stacks * 7.0]),
		buff(Buff.SensitivityGainBuff, [BodypartSlot.Penis, 10.0 + stacks * 4.0]),
		buff(Buff.OverstimulationThresholdBuff, [BodypartSlot.Anus, 8.0 + stacks * 5.0]),
		buff(Buff.FetishGainBuff, [8.0 + stacks * 4.0]),
	]

func saveData():
	return {"turns": turns, "stacks": stacks}

func loadData(_data):
	turns = SAVE.loadVar(_data, "turns", 60 * 45)
	stacks = SAVE.loadVar(_data, "stacks", 1.0)
	clampValues()

func clampValues():
	turns = max(1, turns)
	stacks = clamp(stacks, 0.5, 5.0)
