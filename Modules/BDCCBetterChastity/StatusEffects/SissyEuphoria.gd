extends StatusEffectBase

var stacks = 1.0

func _init():
	id = "BBC_SissyEuphoria"
	isBattleOnly = false
	isSexEngineOnly = false

func initArgs(_args = []):
	if(_args.size() > 0):
		turns = int(_args[0])
	else:
		turns = 60 * 45
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
	return "Sissy euphoria"

func getEffectDesc():
	return "A warm, submissive headspace from Better Chastity training. Denial, praise, and toy routines feel easier to lean into for "+Util.getTimeStringHumanReadable(turns)+"."

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
		buff(Buff.AmbientLustBuff, [8.0 + stacks * 6.0]),
		buff(Buff.SensitivityGainBuff, [12.0 + stacks * 7.0]),
		buff(Buff.FetishGainBuff, [10.0 + stacks * 5.0]),
	]

func saveData():
	return {
		"turns": turns,
		"stacks": stacks,
	}

func loadData(_data):
	turns = SAVE.loadVar(_data, "turns", 60 * 45)
	stacks = SAVE.loadVar(_data, "stacks", 1.0)
	clampValues()

func clampValues():
	turns = max(1, turns)
	stacks = clamp(stacks, 0.5, 5.0)
