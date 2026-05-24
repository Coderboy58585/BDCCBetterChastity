extends ItemBase

var current_color = 0
var protocol_mode = 0
var hours_remaining = 24

func _init():
	id = "BBC_TimedSmartChastityCage"

func getVisibleName():
	return "Timed Smart Chastity Cage"

func getDescription():
	var mode_name = ["Standard", "Quiet", "Strict"][protocol_mode]
	return "A smart chastity cage with a timed protocol, visible status light, and configurable behavior. It is not easier to remove, but it is much clearer about what it is doing.\n[color=gray]Mode: "+mode_name+" | Timer: "+str(hours_remaining)+"h[/color]"

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
	protocol_mode += 1
	if(protocol_mode >= 3):
		protocol_mode = 0
	current_color += 1
	if(current_color >= 3):
		current_color = 0
	hours_remaining = max(1, hours_remaining - 1)
	if(isWornByWearer()):
		updateWearerAppearance()
	return "You cycle the smart cage protocol to "+["Standard", "Quiet", "Strict"][protocol_mode]+". The status light changes color and the timer now reads "+str(hours_remaining)+"h."

func getPossibleActions():
	return [
		{
			"name": "Cycle protocol",
			"scene": "UseItemLikeInCombatScene",
			"description": "Rotate the visible color and smart-lock behavior mode.",
		},
	]

func saveData():
	var data = .saveData()
	data["current_color"] = current_color
	data["protocol_mode"] = protocol_mode
	data["hours_remaining"] = hours_remaining
	return data

func loadData(data):
	.loadData(data)
	current_color = clamp(SAVE.loadVar(data, "current_color", 0), 0, 2)
	protocol_mode = clamp(SAVE.loadVar(data, "protocol_mode", 0), 0, 2)
	hours_remaining = max(1, int(SAVE.loadVar(data, "hours_remaining", 24)))

func getDatapackEditVars():
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
		hours_remaining = max(1, int(_value))
