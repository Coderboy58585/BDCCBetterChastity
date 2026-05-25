extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var current_color = 0
var protocol_mode = 0
var hours_remaining = 24
var last_timer_second = -1
var timer_unlocked = false
var use_count = 0
var stimulation_style = 0

func _init():
	id = "BBC_TimedSmartChastityCage"

func getVisibleName():
	return "Timed Smart Chastity Cage"

func getDescription():
	syncTimer()
	var mode_name = ["Standard", "Quiet", "Strict"][protocol_mode]
	var lock_text = "locked"
	if(timer_unlocked):
		lock_text = "timer complete"
	return "A smart chastity cage with a timed protocol, visible status light, and configurable behavior. It is not easier to remove, but it is much clearer about what it is doing.\n[color=gray]Mode: "+mode_name+" | Timer: "+str(hours_remaining)+"h | "+lock_text+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [25.0 + float(protocol_mode) * 8.0]),
	]

func getTakeOffScene():
	syncTimer()
	if(timer_unlocked):
		return "TakeAnyItemOffScene"
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 85

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(7)
	restraintData.setProfile("smart")

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" chirped softly as its timer protocol engaged."
	return getAStackNameCapitalize()+" chirped softly as it locked onto {receiver.nameS} body."

func getRiggedParts(_character):
	if(current_color == 1):
		return {
			"chastity_cage": "res://Inventory/RiggedModels/ShockCage/ShockCageLilac.tscn",
		}
	if(current_color == 2):
		return {
			"chastity_cage": "res://Inventory/RiggedModels/ShockCage/ShockCageGeneral.tscn",
		}
	return {
		"chastity_cage": "res://Inventory/RiggedModels/ShockCage/ShockCage.tscn",
	}

func getHidesParts(_character):
	return {
		BodypartSlot.Penis: true,
	}

func shouldBeVisibleOnDoll(_character, _doll):
	if(!_character.isBodypartCovered(BodypartSlot.Penis) || _doll.isForcedExposed(BodypartSlot.Penis)):
		return true
	return false

func isImportant():
	return true

func getInventoryImage():
	if(current_color == 1):
		return "res://Images/Items/bdsm/ShockCagePurple.png"
	if(current_color == 2):
		return "res://Images/Items/bdsm/ShockCageOrange.png"
	return "res://Images/Items/bdsm/ShockCageRed.png"

func useInCombat(_attacker, _receiver):
	syncTimer()
	protocol_mode += 1
	if(protocol_mode >= 3):
		protocol_mode = 0
	current_color += 1
	if(current_color >= 3):
		current_color = 0
	if(hours_remaining > 0):
		hours_remaining = max(0, hours_remaining - 1)
	if(hours_remaining <= 0):
		timer_unlocked = true
	if(isWornByWearer()):
		updateWearerAppearance()
	var extra_text = "You cycle the smart cage protocol to "+["Standard", "Quiet", "Strict"][protocol_mode]+". The status light changes color and the timer now reads "+str(hours_remaining)+"h."
	return ChastityUseLogic.new().perform(self, _attacker, "timed smart cage", 2, extra_text, _receiver == null)

func getCurrentTimerSecond():
	if(GM.main != null):
		return GM.main.getTimeInGlobalSeconds()
	return 0

func syncTimer():
	var now = getCurrentTimerSecond()
	if(last_timer_second < 0):
		last_timer_second = now
		return
	if(now <= last_timer_second):
		return
	var elapsed_hours = int((now - last_timer_second) / (60 * 60))
	if(elapsed_hours <= 0):
		return
	hours_remaining = max(0, hours_remaining - elapsed_hours)
	last_timer_second += elapsed_hours * 60 * 60
	if(hours_remaining <= 0):
		timer_unlocked = true

func getPossibleActions():
	return [
		{
			"name": "Cycle protocol",
			"scene": "UseItemLikeInCombatScene",
			"description": "Rotate the visible color and smart-lock behavior mode.",
		},
	]

func saveData():
	syncTimer()
	var data = .saveData()
	data["current_color"] = current_color
	data["protocol_mode"] = protocol_mode
	data["hours_remaining"] = hours_remaining
	data["last_timer_second"] = last_timer_second
	data["timer_unlocked"] = timer_unlocked
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	return data

func loadData(data):
	.loadData(data)
	current_color = clamp(SAVE.loadVar(data, "current_color", 0), 0, 2)
	protocol_mode = clamp(SAVE.loadVar(data, "protocol_mode", 0), 0, 2)
	hours_remaining = max(0, int(SAVE.loadVar(data, "hours_remaining", 24)))
	last_timer_second = int(SAVE.loadVar(data, "last_timer_second", -1))
	timer_unlocked = SAVE.loadVar(data, "timer_unlocked", false)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)

func getDatapackEditVars():
	syncTimer()
	var result = .getDatapackEditVars()
	result["protocol_mode"] = {
		"name": "Protocol",
		"type": "selector",
		"value": protocol_mode,
		"values": [[0, "Standard"], [1, "Quiet"], [2, "Strict"]],
	}
	result["hours_remaining"] = {
		"name": "Timer hours",
		"type": "number",
		"value": hours_remaining,
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "protocol_mode"):
		protocol_mode = clamp(int(_value), 0, 2)
	if(_id == "hours_remaining"):
		hours_remaining = max(0, int(_value))
		timer_unlocked = hours_remaining <= 0
