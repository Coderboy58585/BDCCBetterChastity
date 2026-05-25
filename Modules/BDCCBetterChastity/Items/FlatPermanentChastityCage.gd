extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var use_count = 0
var stimulation_style = 0
var plate_condition = 100

func _init():
	id = "BBC_FlatPermanentChastityCage"

func getVisibleName():
	return "Flat Permanent Chastity Cage"

func getDescription():
	return "A permanent flat chastity cage with a broad sealed plate and no normal removal path. The plate spreads pressure evenly while making the lock face obvious.\n[color=gray]Plate condition: "+str(plate_condition)+"% | Uses logged: "+str(use_count)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [32.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 80

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = RestraintUnremovable.new()
	restraintData.setLevel(calculateBestRestraintLevel())

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" pressed flat and locked with a permanent seal."
	return getAStackNameCapitalize()+" pressed flat against {receiver.nameS} body and locked with a permanent seal."

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
	plate_condition = max(0, plate_condition - RNG.randi_range(1, 4))
	var extra_text = "You check the flat permanent plate. The plate condition is now "+str(plate_condition)+"%."
	return ChastityUseLogic.new().perform(self, _attacker, "flat permanent cage", 3, extra_text, _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Use plate",
			"scene": "UseItemLikeInCombatScene",
			"description": "Use the permanent flat plate and check its condition.",
		},
	]

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	data["plate_condition"] = plate_condition
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)
	plate_condition = clamp(SAVE.loadVar(data, "plate_condition", 100), 0, 100)

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["plate_condition"] = {
		"name": "Plate condition",
		"type": "number",
		"value": plate_condition,
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "plate_condition"):
		plate_condition = clamp(int(_value), 0, 100)
