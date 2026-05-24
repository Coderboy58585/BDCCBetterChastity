extends ItemBase

var service_count = 0
var fit_setting = 1

func _init():
	id = "BBC_ErgonomicChastityCage"

func getVisibleName():
	return "Ergonomic Chastity Cage"

func getDescription():
	var fit_text = ["loose", "balanced", "snug"][fit_setting]
	return "A long-wear chastity cage with rounded edges, breathable spacing, and a "+fit_text+" fit setting. It is still a real restraint, but it is designed to be serviced instead of simply endured.\n[color=gray]Service count: "+str(service_count)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [12.0 + float(fit_setting) * 5.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 35

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(4)
	restraintData.setProfile("comfort")

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" was locked into place with a careful click."
	return getAStackNameCapitalize()+" was locked onto {receiver.nameS} body with a careful click."

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
	service_count += 1
	fit_setting += 1
	if(fit_setting > 2):
		fit_setting = 0
	if(isWornByWearer()):
		updateWearerAppearance()
	return "You service the ergonomic cage, check the edges, and reset the fit to "+["loose", "balanced", "snug"][fit_setting]+"."

func getPossibleActions():
	return [
		{
			"name": "Service fit",
			"scene": "UseItemLikeInCombatScene",
			"description": "Clean the cage and rotate its fit setting.",
		},
	]

func saveData():
	var data = .saveData()
	data["service_count"] = service_count
	data["fit_setting"] = fit_setting
	return data

func loadData(data):
	.loadData(data)
	service_count = SAVE.loadVar(data, "service_count", 0)
	fit_setting = clamp(SAVE.loadVar(data, "fit_setting", 1), 0, 2)

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["fit_setting"] = {
		"name": "Fit setting",
		"type": "selector",
		"value": fit_setting,
		"values": [[0, "Loose"], [1, "Balanced"], [2, "Snug"]],
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "fit_setting"):
		fit_setting = clamp(int(_value), 0, 2)
