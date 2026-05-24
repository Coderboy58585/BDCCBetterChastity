extends ItemBase

var seal_integrity = 100
var plate_number = 417

func _init():
	id = "BBC_FlatTamperEvidentChastityCage"

func getVisibleName():
	return "Flat Tamper-Evident Chastity Cage"

func getDescription():
	return "A flat chastity cage with a recessed tamper seal and engraved inspection number. The broad front plate makes the seal easy to read and awkward to pick at.\n[color=gray]Seal integrity: "+str(seal_integrity)+"% | Plate: "+str(plate_number)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [28.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 60

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards, ItemTag.CanBeForcedInStocks]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(6)
	restraintData.setProfile("flat_strict")
	restraintData.setSealIntegrity(seal_integrity)

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" locked flat against you as its tamper seal clicked shut."
	return getAStackNameCapitalize()+" locked flat against {receiver.nameS} body as its tamper seal clicked shut."

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
	seal_integrity = max(0, seal_integrity - RNG.randi_range(2, 6))
	if(restraintData != null && restraintData.has_method("setSealIntegrity")):
		restraintData.setSealIntegrity(seal_integrity)
	return "You inspect the recessed seal and plate number. The seal is now at "+str(seal_integrity)+"% integrity."

func getPossibleActions():
	return [
		{
			"name": "Inspect plate",
			"scene": "UseItemLikeInCombatScene",
			"description": "Read the plate number and inspect the recessed tamper seal.",
		},
	]

func saveData():
	var data = .saveData()
	data["seal_integrity"] = seal_integrity
	data["plate_number"] = plate_number
	return data

func loadData(data):
	.loadData(data)
	seal_integrity = clamp(SAVE.loadVar(data, "seal_integrity", 100), 0, 100)
	plate_number = int(SAVE.loadVar(data, "plate_number", 417))

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["seal_integrity"] = {
		"name": "Seal integrity",
		"type": "number",
		"value": seal_integrity,
	}
	result["plate_number"] = {
		"name": "Plate number",
		"type": "number",
		"value": plate_number,
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "seal_integrity"):
		seal_integrity = clamp(int(_value), 0, 100)
	if(_id == "plate_number"):
		plate_number = int(_value)
