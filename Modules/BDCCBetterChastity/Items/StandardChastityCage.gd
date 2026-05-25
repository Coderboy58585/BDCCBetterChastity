extends ItemBase

const ChastityUseLogic = preload("res://Modules/BDCCBetterChastity/ChastityUseLogic.gd")

var use_count = 0
var stimulation_style = 0

func _init():
	id = "BBC_StandardChastityCage"

func getVisibleName():
	return "Better Standard Chastity Cage"

func getDescription():
	return "A standard chastity cage with improved restraint feedback and use tracking. It keeps the simple silhouette of the prison-issued cage while adding clearer status text.\n[color=gray]Uses logged: "+str(use_count)+"[/color]"

func getClothingSlot():
	return InventorySlot.Penis

func getRequiredBodypart():
	return BodypartSlot.Penis

func getBuffs():
	return [
		buff(Buff.ChastityPenisBuff),
		buff(Buff.SensitivityGainBuff, [22.0]),
	]

func getTakeOffScene():
	return "RestraintTakeOffNopeScene"

func getPrice():
	return 25

func canSell():
	return true

func getTags():
	return [ItemTag.BDSMRestraint, ItemTag.ChastityCage, ItemTag.SoldByTheAnnouncer, ItemTag.CanBeForcedByGuards, ItemTag.CanBeForcedInStocks]

func isRestraint():
	return true

func generateRestraintData():
	restraintData = preload("res://Modules/BDCCBetterChastity/Restraints/BetterChastityRestraint.gd").new()
	restraintData.setLevel(4)
	restraintData.setProfile("standard")

func getForcedOnMessage(isPlayer = true):
	if(isPlayer):
		return getAStackNameCapitalize()+" locked shut with a familiar correctional click."
	return getAStackNameCapitalize()+" locked shut around {receiver.nameS} body with a familiar correctional click."

func updateDoll(doll: Doll3D):
	doll.setState("cock", "caged")

func isImportant():
	return true

func getInventoryImage():
	return "res://Images/Items/bdsm/chastity_cage.png"

func useInCombat(_attacker, _receiver):
	return ChastityUseLogic.new().perform(self, _attacker, "standard cage", 1, "You check the standard cage and settle its lock housing.", _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Use cage",
			"scene": "UseItemLikeInCombatScene",
			"description": "Use the standard cage for controlled indirect stimulation.",
		},
	]

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["stimulation_style"] = stimulation_style
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	stimulation_style = clamp(SAVE.loadVar(data, "stimulation_style", 0), 0, 2)
