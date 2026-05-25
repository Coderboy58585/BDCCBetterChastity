extends StatusEffectBase

var stacks = 1.0

func _init():
	id = "BBC_ProstateFocus"
	isBattleOnly = false
	isSexEngineOnly = false

func initArgs(_args = []):
	if(_args.size() > 0):
		turns = int(_args[0])
	else:
		turns = 60 * 60
	if(_args.size() > 1):
		stacks = float(_args[1])
	else:
		stacks = 1.0
	clampValues()

func processTime(_secondsPassed: int):
	turns -= _secondsPassed
	if(turns <= 0):
		stop()

func getEffectName():
	return "Prostate focus"

func getEffectDesc():
	return "Better Chastity toy training has left your body tuned for slow, indirect pleasure for "+Util.getTimeStringHumanReadable(turns)+"."

func getEffectImage():
	return "res://Images/StatusEffects/lotus.png"

func getIconColor():
	return IconColorPurple

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
		buff(Buff.SensitivityGainBuff, [18.0 + stacks * 8.0]),
		buff(Buff.GenitalElasticityBuff, [8.0 + stacks * 6.0]),
		buff(Buff.OverstimulationThresholdBuff, [10.0 + stacks * 6.0]),
		buff(Buff.StaminaRecoverAfterSexBuff, [4.0 + stacks * 2.0]),
	]

func saveData():
	return {
		"turns": turns,
		"stacks": stacks,
	}

func loadData(_data):
	turns = SAVE.loadVar(_data, "turns", 60 * 60)
	stacks = SAVE.loadVar(_data, "stacks", 1.0)
	clampValues()

func clampValues():
	turns = max(1, turns)
	stacks = clamp(stacks, 0.5, 5.0)
