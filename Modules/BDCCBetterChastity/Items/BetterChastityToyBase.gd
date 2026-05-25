extends ItemBase

const ToyUseLogic = preload("res://Modules/BDCCBetterChastity/ToyUseLogic.gd")

var use_count = 0
var training_score = 0
var current_mode = 0

func getToyName():
	return "Better Chastity Toy"

func getToyDescription():
	return "A Better Chastity toy with a saved training routine."

func getToyLabel():
	return getToyName().to_lower()

func getToyModes():
	return [
		{id = "prostate", label = "prostate focus"},
		{id = "external", label = "cage pressure"},
	]

func getModeData():
	var modes = getToyModes()
	if(modes.empty()):
		return {id = "prostate", label = "prostate focus"}
	var safe_index = int(clamp(current_mode, 0, modes.size() - 1))
	return modes[safe_index]

func getModeID():
	return getModeData()["id"]

func getModeLabel():
	return getModeData()["label"]

func advanceMode():
	var modes = getToyModes()
	if(modes.empty()):
		current_mode = 0
		return
	current_mode += 1
	if(current_mode >= modes.size()):
		current_mode = 0

func getVisibleName():
	return getToyName()

func getDescription():
	return getToyDescription()+"\n[color=gray]Next mode: "+getModeLabel()+" | Training score: "+str(training_score)+"[/color]"

func canUseInCombat():
	return true

func useInCombat(_attacker, _receiver):
	var mode = getModeID()
	var mode_label = getModeLabel()
	advanceMode()
	return ToyUseLogic.new().perform(self, _attacker, getToyLabel(), getToyIntensity(), mode, "You set the "+getToyLabel()+" to "+mode_label+".", _receiver == null)

func getPossibleActions():
	var result = []
	if(getToyFluidCapacity() > 0.0):
		result.append({
			"name": "Transfer fluids",
			"scene": "FluidTransferScene",
			"description": "Transfer fluids between containers.",
		})
	result.append({
		"name": getToyActionName(),
		"scene": "BBC_AnimatedToyScene",
		"description": getToyActionDescription(),
		"onlyWhenCalm": true,
	})
	return result

func getToyActionName():
	return "Train with it"

func getToyActionDescription():
	return "Run a Better Chastity animated toy-training scene."

func getToyIntensity():
	return 2

func getToyStretchPower():
	return 22

func getToyFluidCapacity():
	return 0.0

func generateFluids():
	var capacity = getToyFluidCapacity()
	if(capacity <= 0.0):
		return
	fluids = Fluids.new()
	fluids.setCapacity(capacity)

func getPrice():
	return 25

func canSell():
	return true

func getTags():
	return [ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.SexEngineCanApply]

func getItemCategory():
	return ItemCategory.BDSM

func getInventoryImage():
	return "res://Images/Items/strapons/human.png"

func getToyAnimationProfile():
	return "horse"

func getToyTeaseScene():
	if(getToyAnimationProfile() == "tentacle"):
		return StageScene.TentaclesTease
	return getToyStageScene()

func getToyStageScene():
	return StageScene.HorsecockDildoSex

func getToyTeaseAnim():
	return "tease"

func getToyInsideAnim():
	if(getToyAnimationProfile() == "prostate"):
		return "milk"
	return "inside"

func getToyRhythmAnim():
	if(getToyAnimationProfile() == "prostate"):
		return "milk"
	return "sex"

func getToyFastAnim():
	return "fast"

func getToyFinishAnim():
	return getToyFastAnim()

func getSexEngineSubcategory() -> Array:
	return ["Better Chastity toys"]

func getSexEngineInfo(_sexEngine, _domInfo, _subInfo):
	var sub:BaseCharacter = _subInfo.getChar()
	var dom:BaseCharacter = _domInfo.getChar()
	return {
		"name": getToyName(),
		"usedName": "a "+getToyLabel(),
		"desc": "Applies Better Chastity toy-training focus with actual toy state.",
		"scoreOnSub": 0.08 + float(getToyIntensity()) * 0.025,
		"scoreOnSelf": 0.05,
		"scoreSubScore": 0.18,
		"canUseOnDom": dom.hasReachableAnus(),
		"canUseOnSub": sub.hasReachableAnus(),
		"maxUsesByNPC": 2,
	}

func useInSex(_receiver):
	var intensity = getToyIntensity()
	_receiver.addLust(5 + intensity * 3)
	_receiver.addStamina(-2 - intensity)
	_receiver.addEffect("BBC_ProstateFocus", [60 * (45 + intensity * 10), 0.8 + float(intensity) * 0.3])
	_receiver.addEffect("BBC_SissyEuphoria", [60 * (30 + intensity * 8), 0.7 + float(intensity) * 0.2])
	return {
		text = "{USER.You} {USER.youVerb('settle')} into a Better Chastity toy rhythm.".replace("USER", _receiver.getID()),
	}

func recordToyUse(intensity = -1):
	var amount = getToyIntensity()
	if(intensity >= 0):
		amount = intensity
	use_count += 1
	training_score += max(1, int(amount))

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
	current_mode = int(clamp(SAVE.loadVar(data, "current_mode", SAVE.loadVar(data, "pulse_setting", 0)), 0, max(0, getToyModes().size() - 1)))
