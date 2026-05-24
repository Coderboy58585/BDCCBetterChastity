extends RestraintChastityCage

var profile = "balanced"
var seal_integrity = 100

func setProfile(new_profile):
	profile = str(new_profile)

func setSealIntegrity(new_value):
	seal_integrity = clamp(int(new_value), 0, 100)

func getProfileName():
	if(profile == "comfort"):
		return "comfort-fit"
	if(profile == "strict"):
		return "strict-fit"
	if(profile == "smart"):
		return "smart-lock"
	return "balanced-fit"

func doStruggle(_pc, _minigame:MinigameResult):
	var hands_free = !_pc.hasBlockedHands()
	var arms_free = !_pc.hasBoundArms()
	var can_work_properly = hands_free && arms_free

	var text = "{user.name} tests the "+getProfileName()+" chastity restraint, feeling for give around the lock housing."
	var lust = 0
	var pain = 0
	var damage = 0
	var stamina = 0

	if(profile == "comfort"):
		if(can_work_properly):
			text = "{user.name} carefully checks the ergonomic cage, but the rounded fit leaves very little to grip."
			damage = calcDamage(_pc, _minigame, 0.55)
			stamina = 6
		else:
			text = "{user.name} shifts against the ergonomic cage. It stays secure without biting in too harshly."
			damage = calcDamage(_pc, _minigame, 0.15)
			stamina = 3
	elif(profile == "strict"):
		if(failChanceLowScore(_pc, 20, _minigame)):
			text = "{user.name} pulls at the tamper-evident seal. The seal tightens down with a sharp warning click."
			damage = -0.75
			pain = scaleDamage(4)
		elif(can_work_properly):
			text = "{user.name} works at the tamper-evident cage. The seal gives a fraction, but every movement risks leaving evidence."
			damage = calcDamage(_pc, _minigame, 0.8)
			stamina = 12
		else:
			text = "{user.name} tries to worry at the tamper-evident cage, but the reinforced seal barely moves."
			damage = calcDamage(_pc, _minigame, 0.08)
			stamina = 5
	else:
		if(failChanceLowScore(_pc, 18, _minigame)):
			text = "{user.name} disturbs the smart lock and it responds with a warning pulse."
			damage = -0.5
			pain = scaleDamage(3)
		elif(can_work_properly):
			text = "{user.name} studies the smart cage's lock cycle, waiting for the tiny delay between status pulses."
			damage = calcDamage(_pc, _minigame, 0.65)
			stamina = 10
		else:
			text = "{user.name} shifts and tests the smart cage, but the device simply logs the attempt."
			damage = calcDamage(_pc, _minigame, 0.1)
			stamina = 4

	if(failChance(_pc, 15)):
		text += " The pressure is distracting enough to make focusing difficult."
		lust = scaleDamage(3)

	return {"text": text, "damage": damage, "lust": lust, "pain": pain, "stamina": stamina}

func saveData():
	var data = .saveData()
	data["profile"] = profile
	data["seal_integrity"] = seal_integrity
	return data

func loadData(data):
	.loadData(data)
	profile = SAVE.loadVar(data, "profile", "balanced")
	seal_integrity = SAVE.loadVar(data, "seal_integrity", 100)
