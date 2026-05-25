extends ItemBase

const ToyUseLogic = preload("res://Modules/BDCCBetterChastity/ToyUseLogic.gd")

var use_count = 0
var training_score = 0
var current_mode = 0

func _init():
	id = "BBC_SoftTrainingDildo"

func getVisibleName():
	return "Soft Training Dildo"

func getDescription():
	return "A soft, prison-smuggled toy made for Better Chastity routines. It rotates between external cage pressure and prostate-focused training.\n[color=gray]Next mode: "+getModeLabel()+" | Training score: "+str(training_score)+"[/color]"

func getModeLabel():
	if(current_mode == 1):
		return "prostate focus"
	return "external pressure"

func getModeID():
	if(current_mode == 1):
		return "prostate"
	return "external"

func canUseInCombat():
	return true

func useInCombat(_attacker, _receiver):
	var mode = getModeID()
	var mode_label = getModeLabel()
	current_mode += 1
	if(current_mode > 1):
		current_mode = 0
	return ToyUseLogic.new().perform(self, _attacker, "soft training dildo", 1, mode, "You set the soft training dildo to "+mode_label+".", _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Use toy",
			"scene": "UseItemLikeInCombatScene",
			"description": "Run the next Better Chastity toy routine.",
		},
	]

func getPrice():
	return 12

func canSell():
	return true

func getTags():
	return [ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.SexEngineCanApply]

func getItemCategory():
	return ItemCategory.BDSM

func getInventoryImage():
	return "res://Images/Items/strapons/human.png"

func getSexEngineSubcategory() -> Array:
	return ["Better Chastity toys"]

func getSexEngineInfo(_sexEngine, _domInfo, _subInfo):
	var sub:BaseCharacter = _subInfo.getChar()
	var dom:BaseCharacter = _domInfo.getChar()
	return {
		"name": "Soft training",
		"usedName": "a soft training toy",
		"desc": "Adds Better Chastity toy-training focus and mild arousal.",
		"scoreOnSub": 0.08,
		"scoreOnSelf": 0.05,
		"scoreSubScore": 0.2,
		"canUseOnDom": dom.hasReachableAnus(),
		"canUseOnSub": sub.hasReachableAnus(),
		"maxUsesByNPC": 2,
	}

func useInSex(_receiver):
	_receiver.addLust(6)
	_receiver.addEffect("BBC_ProstateFocus", [60 * 45, 1.0])
	_receiver.addEffect("BBC_SissyEuphoria", [60 * 30, 0.75])
	return {
		text = "{USER.You} {USER.youVerb('settle')} into a slow Better Chastity toy-training rhythm.".replace("USER", _receiver.getID()),
	}

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["training_score"] = training_score
	data["current_mode"] = current_mode
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	training_score = SAVE.loadVar(data, "training_score", 0)
	current_mode = clamp(SAVE.loadVar(data, "current_mode", 0), 0, 1)
