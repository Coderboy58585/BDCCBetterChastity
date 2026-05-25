extends StatusEffectBase

var stacks = 1.0

func _init():
	id = "BBC_NippleFocus"
	isBattleOnly = false
	isSexEngineOnly = false

func initArgs(_args = []):
	turns = int(_args[0]) if _args.size() > 0 else 60 * 70
	stacks = float(_args[1]) if _args.size() > 1 else 1.0
	clampValues()

func processTime(_secondsPassed: int):
	turns -= _secondsPassed
	if(turns <= 0):
		stop()

func getEffectName():
	return "Nipple focus"

func getEffectDesc():
	return "Better Chastity chest stimulation has made nipple-focused teasing more responsive for "+Util.getTimeStringHumanReadable(turns)+"."

func getEffectImage():
	return "res://Images/StatusEffects/lotus.png"

func getIconColor():
	return IconColorCyan

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
		buff(Buff.SensitivityGainBuff, [BodypartSlot.Breasts, 18.0 + stacks * 8.0]),
		buff(Buff.OverstimulationThresholdBuff, [BodypartSlot.Breasts, 10.0 + stacks * 5.0]),
		buff(Buff.BreastsMilkProductionBuff, [5.0 + stacks * 3.0]),
	]

func saveData():
	return {"turns": turns, "stacks": stacks}

func loadData(_data):
	turns = SAVE.loadVar(_data, "turns", 60 * 70)
	stacks = SAVE.loadVar(_data, "stacks", 1.0)
	clampValues()

func clampValues():
	turns = max(1, turns)
	stacks = clamp(stacks, 0.5, 5.0)
