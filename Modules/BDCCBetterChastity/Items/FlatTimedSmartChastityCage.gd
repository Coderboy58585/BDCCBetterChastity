extends ItemBase

var current_color = 0
var protocol_mode = 0
var hours_remaining = 12
var silent_status = false

func _init():
	id = "BBC_FlatTimedSmartChastityCage"

func getVisibleName():
	return "Flat Timed Smart Chastity Cage"

func getDescription():
	var mode_name = ["Standard", "Silent", "Strict"][protocol_mode]
	var status_text = "audible"
	if(silent_status):
		status_text = "silent"
	return "A flat smart chastity cage with a timer, flush status light, and recessed lock face. Its broad plate keeps the electronics protected and easy to inspect.\n[color=gray]Mode: "+mode_name+" | Timer: "+str(hours_remaining)+"h | Status: "+status_text+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [18.0 + float(protocol_mode) * 7.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 90

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(7)
	restraintData.setProfile("flat_smart")

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" sealed flat as its timer light blinked once."
	return getAStackNameCapitalize()+" sealed flat against {receiver.nameS} body as its timer light blinked once."

func getRiggedParts(_character):
	return {
		"chastity_cage": "res://Inventory/RiggedModels/FlatCage/FlatCage.tscn",
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
	return "res://Images/Items/bdsm/flatcage.png"

func useInCombat(_attacker, _receiver):
	protocol_mode += 1
	if(protocol_mode >= 3):
		protocol_mode = 0
	current_color += 1
	if(current_color >= 3):
		current_color = 0
	hours_remaining = max(1, hours_remaining - 1)
	silent_status = !silent_status
	if(isWornByWearer()):
		updateWearerAppearance()
	return "You cycle the flat smart cage to "+["Standard", "Silent", "Strict"][protocol_mode]+". The timer now reads "+str(hours_remaining)+"h."

func getPossibleActions():
	return [
		{
			"name": "Cycle flat protocol",
			"scene": "UseItemLikeInCombatScene",
			"description": "Rotate the flat smart cage protocol and status mode.",
		},
	]

func saveData():
	var data = .saveData()
	data["current_color"] = current_color
	data["protocol_mode"] = protocol_mode
	data["hours_remaining"] = hours_remaining
	data["silent_status"] = silent_status
	return data

func loadData(data):
	.loadData(data)
	current_color = clamp(SAVE.loadVar(data, "current_color", 0), 0, 2)
	protocol_mode = clamp(SAVE.loadVar(data, "protocol_mode", 0), 0, 2)
	hours_remaining = max(1, int(SAVE.loadVar(data, "hours_remaining", 12)))
	silent_status = SAVE.loadVar(data, "silent_status", false)

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["protocol_mode"] = {
		"name": "Protocol",
		"type": "selector",
		"value": protocol_mode,
		"values": [[0, "Standard"], [1, "Silent"], [2, "Strict"]],
	}
	result["hours_remaining"] = {
		"name": "Timer hours",
		"type": "number",
		"value": hours_remaining,
	}
	result["silent_status"] = {
		"name": "Silent status",
		"type": "checkbox",
		"value": silent_status,
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "protocol_mode"):
		protocol_mode = clamp(int(_value), 0, 2)
	if(_id == "hours_remaining"):
		hours_remaining = max(1, int(_value))
	if(_id == "silent_status"):
		silent_status = _value
