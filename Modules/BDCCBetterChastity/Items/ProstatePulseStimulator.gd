extends ItemBase

const ToyUseLogic = preload("res://Modules/BDCCBetterChastity/ToyUseLogic.gd")

var use_count = 0
var training_score = 0
var pulse_setting = 1

func _init():
	id = "BBC_ProstatePulseStimulator"

func getVisibleName():
	return "Prostate Pulse Stimulator"

func getDescription():
	var pulse_text = ["low", "steady", "deep"][pulse_setting]
	return "A compact Better Chastity stimulator that focuses on hands-free, prostate-centered denial training.\n[color=gray]Pulse: "+pulse_text+" | Training score: "+str(training_score)+"[/color]"

func canUseInCombat():
	return true

func useInCombat(_attacker, _receiver):
	pulse_setting += 1
	if(pulse_setting > 2):
		pulse_setting = 0
	var extra_text = "You tune the stimulator to "+["low", "steady", "deep"][pulse_setting]+" pulses."
	return ToyUseLogic.new().perform(self, _attacker, "prostate pulse stimulator", 2 + pulse_setting, "prostate", extra_text, _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Pulse train",
			"scene": "UseItemLikeInCombatScene",
			"description": "Run a prostate-focused Better Chastity pulse routine.",
		},
	]

func getPrice():
	return 32

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
		"name": "Prostate pulse",
		"usedName": "a prostate pulse stimulator",
		"desc": "Applies Better Chastity prostate focus during sex activities.",
		"scoreOnSub": 0.14,
		"scoreOnSelf": 0.06,
		"scoreSubScore": 0.25,
		"canUseOnDom": dom.hasReachableAnus(),
		"canUseOnSub": sub.hasReachableAnus(),
		"maxUsesByNPC": 2,
	}

func useInSex(_receiver):
	_receiver.addLust(10)
	_receiver.addStamina(-3)
	_receiver.addEffect("BBC_ProstateFocus", [60 * 80, 1.75])
	return {
		text = "{USER.You} {USER.youVerb('shiver')} as Better Chastity prostate focus takes over the rhythm.".replace("USER", _receiver.getID()),
	}

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["training_score"] = training_score
	data["pulse_setting"] = pulse_setting
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	training_score = SAVE.loadVar(data, "training_score", 0)
	pulse_setting = clamp(SAVE.loadVar(data, "pulse_setting", 1), 0, 2)
