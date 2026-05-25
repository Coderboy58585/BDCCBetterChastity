extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var seal_integrity = 100
var seal_color = 0
var use_count = 0
var stimulation_style = 0

func _init():
	id = "BBC_TamperEvidentChastityCage"

func getVisibleName():
	return "Tamper-Evident Chastity Cage"

func getDescription():
	return "A reinforced chastity cage with a visible numbered seal. It is built to show whether anyone has been trying to interfere with the lock.\n[color=gray]Seal integrity: "+str(seal_integrity)+"%[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [35.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 55

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards, ItemTag.CanBeForcedInStocks]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(6)
	restraintData.setProfile("strict")
	restraintData.setSealIntegrity(seal_integrity)

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" was secured and its tamper seal was snapped shut."
	return getAStackNameCapitalize()+" was secured on {receiver.nameS} body and its tamper seal was snapped shut."

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
	seal_integrity = max(0, seal_integrity - RNG.randi_range(3, 8))
	if(restraintData != null && restraintData.has_method("setSealIntegrity")):
		restraintData.setSealIntegrity(seal_integrity)
	var extra_text = "You inspect the tamper seal. It is still readable, but the check leaves the seal at "+str(seal_integrity)+"% integrity."
	return ChastityUseLogic.new().perform(self, _attacker, "tamper-evident cage", 2, extra_text, _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Inspect seal",
			"scene": "UseItemLikeInCombatScene",
			"description": "Check the tamper-evident seal and its current integrity.",
		},
	]

func saveData():
	var data = .saveData()
	data["seal_integrity"] = seal_integrity
	data["seal_color"] = seal_color
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	return data

func loadData(data):
	.loadData(data)
	seal_integrity = clamp(SAVE.loadVar(data, "seal_integrity", 100), 0, 100)
	seal_color = clamp(SAVE.loadVar(data, "seal_color", 0), 0, 2)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["seal_integrity"] = {
		"name": "Seal integrity",
		"type": "number",
		"value": seal_integrity,
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "seal_integrity"):
		seal_integrity = clamp(int(_value), 0, 100)
