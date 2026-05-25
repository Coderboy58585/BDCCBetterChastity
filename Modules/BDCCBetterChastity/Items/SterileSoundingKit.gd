extends ItemBase

const ToyUseLogic = preload("res://Modules/BDCCBetterChastity/ToyUseLogic.gd")

var use_count = 0
var training_score = 0
var calibration = 0

func _init():
	id = "BBC_SterileSoundingKit"

func getVisibleName():
	return "Sterile Sounding Kit"

func getDescription():
	return "A sealed, fictional Better Chastity urethral-training kit. It abstracts the risky parts into a sterile calibration routine and never provides real-world procedure instructions.\n[color=gray]Calibration: "+str(calibration)+" | Training score: "+str(training_score)+"[/color]"

func canUseInCombat():
	return true

func useInCombat(_attacker, _receiver):
	calibration += 1
	var intensity = clamp(1 + int(calibration / 3), 1, 3)
	var extra_text = "You run calibration step "+str(calibration)+". The kit keeps the routine conservative and stops at its safety limit."
	return ToyUseLogic.new().perform(self, _attacker, "sterile sounding kit", intensity, "sounding", extra_text, _receiver == null)

func getPossibleActions():
	return [
		{
			"name": "Calibrate kit",
			"scene": "BBC_SterileCalibrationScene",
			"description": "Run a sealed Better Chastity sounding calibration routine.",
			"onlyWhenCalm": true,
		},
	]

func getPrice():
	return 28

func canSell():
	return true

func getTags():
	return [ItemTag.Illegal, ItemTag.SoldByMedicalVendomat, ItemTag.SexEngineCanApply]

func getItemCategory():
	return ItemCategory.Medical

func getInventoryImage():
	return "res://Images/Items/medical/lubricant.png"

func getSexEngineSubcategory() -> Array:
	return ["Better Chastity toys"]

func getSexEngineInfo(_sexEngine, _domInfo, _subInfo):
	var sub:BaseCharacter = _subInfo.getChar()
	var dom:BaseCharacter = _domInfo.getChar()
	return {
		"name": "Sterile calibration",
		"usedName": "a sterile calibration kit",
		"desc": "Adds a conservative Better Chastity calibration effect. No real procedure details.",
		"scoreOnSub": 0.04,
		"scoreOnSelf": 0.02,
		"scoreSubScore": 0.1,
		"canUseOnDom": dom.hasPenis(),
		"canUseOnSub": sub.hasPenis(),
		"maxUsesByNPC": 1,
	}

func useInSex(_receiver):
	_receiver.addLust(5)
	_receiver.addPain(1)
	_receiver.addEffect("BBC_SissyEuphoria", [60 * 30, 0.75])
	return {
		text = "{USER.You} {USER.youVerb('endure')} a sterile Better Chastity calibration routine.".replace("USER", _receiver.getID()),
	}

func saveData():
	var data = .saveData()
	data["use_count"] = use_count
	data["training_score"] = training_score
	data["calibration"] = calibration
	return data

func loadData(data):
	.loadData(data)
	use_count = SAVE.loadVar(data, "use_count", 0)
	training_score = SAVE.loadVar(data, "training_score", 0)
	calibration = SAVE.loadVar(data, "calibration", 0)
