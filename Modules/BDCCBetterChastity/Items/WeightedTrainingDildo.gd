extends ItemBase

const ToyUseLogic = preload("res://Modules/BDCCBetterChastity/ToyUseLogic.gd")

var use_count = 0
var training_score = 0
var current_mode = 0

func _init():
	id = "BBC_WeightedTrainingDildo"

func getVisibleName():
	return "Weighted Training Dildo"

func getDescription():
	return "A heavier Better Chastity toy with a dense core and slower, stricter pacing. It alternates between external pressure training and prostate focus.\n[color=gray]Next mode: "+getModeLabel()+" | Training score: "+str(training_score)+"[/color]"

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
	return ToyUseLogic.new().perform(self, _attacker, "weighted training dildo", 3, mode, "You brace yourself and set the weighted toy to "+mode_label+".", _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Use weighted toy",
			"scene": "UseItemLikeInCombatScene",
			"description": "Run a stricter Better Chastity toy routine.",
		},
	]

func getPrice():
	return 24

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
		"name": "Weighted training",
		"usedName": "a weighted training toy",
		"desc": "Adds stronger Better Chastity toy-training focus and pressure.",
		"scoreOnSub": 0.12,
		"scoreOnSelf": 0.06,
		"scoreSubScore": 0.2,
		"canUseOnDom": dom.hasReachableAnus(),
		"canUseOnSub": sub.hasReachableAnus(),
		"maxUsesByNPC": 1,
	}

func useInSex(_receiver):
	_receiver.addLust(9)
	_receiver.addStamina(-4)
	_receiver.addEffect("BBC_ProstateFocus", [60 * 60, 1.5])
	_receiver.addEffect("BBC_SissyEuphoria", [60 * 35, 1.0])
	return {
		text = "{USER.You} {USER.youVerb('sink')} into a heavier Better Chastity training rhythm.".replace("USER", _receiver.getID()),
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
