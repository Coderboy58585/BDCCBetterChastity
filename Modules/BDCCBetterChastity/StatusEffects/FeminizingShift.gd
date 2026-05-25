extends StatusEffectBase

var stacks = 1.0

func _init():
	id = "BBC_FeminizingShift"
	isBattleOnly = false
	isSexEngineOnly = false

func initArgs(_args = []):
	if(_args.size() > 0):
		turns = int(_args[0])
	else:
		turns = 60 * 60 * 6
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
	return "Feminizing shift"

func getEffectDesc():
	return "A fictional Better Chastity hormone program is nudging body-transformation systems and softening your denial headspace for "+Util.getTimeStringHumanReadable(turns)+"."

func getEffectImage():
	return "res://Images/StatusEffects/overdose.png"

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
		buff(Buff.TransformationSpeedBuff, [18.0 + stacks * 7.0]),
		buff(Buff.SensitivityGainBuff, [10.0 + stacks * 5.0]),
		buff(Buff.BreastsMilkProductionBuff, [8.0 + stacks * 4.0]),
		buff(Buff.FetishGainBuff, [6.0 + stacks * 4.0]),
	]

func saveData():
	return {
		"turns": turns,
		"stacks": stacks,
	}

func loadData(_data):
	turns = SAVE.loadVar(_data, "turns", 60 * 60 * 6)
	stacks = SAVE.loadVar(_data, "stacks", 1.0)
	clampValues()

func clampValues():
	turns = max(1, turns)
	stacks = clamp(stacks, 0.5, 5.0)
