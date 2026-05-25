extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var use_count = 0
var stimulation_style = 0
var vow_text = "permanent"

func _init():
	id = "BBC_PermanentChastityCage"

func getVisibleName():
	return "Better Permanent Chastity Cage"

func getDescription():
	return "A permanent chastity cage that cannot be removed through normal restraint struggle. It focuses on long-term denial, use tracking, and clear permanent-lock feedback.\n[color=gray]Lock state: "+vow_text+" | Uses logged: "+str(use_count)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [30.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 70

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
		return getAStackNameCapitalize()+" locked with a permanent seal."
	return getAStackNameCapitalize()+" locked on {receiver.nameS} body with a permanent seal."

func updateDoll(doll: Doll3D):
	doll.setState("cock", "caged")

func isImportant():
	return true

func getInventoryImage():
	return "res://Images/Items/bdsm/chastity_cage.png"

func useInCombat(_attacker, _receiver):
	return ChastityUseLogic.new().perform(self, _attacker, "permanent cage", 3, "You test the permanent seal. It does not give, but the pressure has somewhere to go.", _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Use seal",
			"scene": "UseItemLikeInCombatScene",
			"description": "Use the permanent cage while its seal stays locked.",
		},
	]

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	data["vow_text"] = vow_text
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)
	vow_text = SAVE.loadVar(data, "vow_text", "permanent")
