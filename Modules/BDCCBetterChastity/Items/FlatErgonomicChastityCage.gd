extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var service_count = 0
var pressure_setting = 1
var use_count = 0
var stimulation_style = 0

func _init():
	id = "BBC_FlatErgonomicChastityCage"

func getVisibleName():
	return "Flat Ergonomic Chastity Cage"

func getDescription():
	var pressure_text = ["relaxed", "close", "flush"][pressure_setting]
	return "A low-profile flat chastity cage with a "+pressure_text+" pressure setting. It uses a broad, smooth front plate that is easier to keep clean and harder to get leverage on.\n[color=gray]Service count: "+str(service_count)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [10.0 + float(pressure_setting) * 4.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 40

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(4)
	restraintData.setProfile("flat_comfort")

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" settled into place with a low-profile click."
	return getAStackNameCapitalize()+" settled onto {receiver.nameS} body with a low-profile click."

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
	pressure_setting += 1
	if(pressure_setting > 2):
		pressure_setting = 0
	if(isWornByWearer()):
		updateWearerAppearance()
	var extra_text = "You service the flat ergonomic cage and set the pressure to "+["relaxed", "close", "flush"][pressure_setting]+"."
	return ChastityUseLogic.new().perform(self, _attacker, "flat ergonomic cage", 1, extra_text, _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Service plate",
			"scene": "UseItemLikeInCombatScene",
			"description": "Clean the flat cage and rotate its pressure setting.",
		},
	]

func saveData():
	var data = .saveData()
	data["service_count"] = service_count
	data["pressure_setting"] = pressure_setting
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	return data

func loadData(data):
	.loadData(data)
	service_count = SAVE.loadVar(data, "service_count", 0)
	pressure_setting = clamp(SAVE.loadVar(data, "pressure_setting", 1), 0, 2)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)

func getDatapackEditVars():
	var result = .getDatapackEditVars()
	result["pressure_setting"] = {
		"name": "Pressure setting",
		"type": "selector",
		"value": pressure_setting,
		"values": [[0, "Relaxed"], [1, "Close"], [2, "Flush"]],
	}
	return result

func applyDatapackEditVar(_id, _value):
	.applyDatapackEditVar(_id, _value)
	if(_id == "pressure_setting"):
		pressure_setting = clamp(int(_value), 0, 2)
