extends SexActivityBase

var training_mode = "prostate"
var turns_done = 0

func _init():
	id = "BBC_BetterChastityToyTraining"
	startedByDom = true
	startedBySub = true

	activityName = "Better Chastity toy training"
	activityDesc = "Run a Better Chastity toy-training routine."
	activityCategory = ["Better Chastity", "Toys"]

func getSupportedSexTypes():
	return {
		SexType.DefaultSex: true,
		SexType.StocksSex: true,
		SexType.BitchsuitSex: true,
	}

func getActivityBaseScore(_sexEngine: SexEngine, _domInfo: SexDomInfo, _subInfo: SexSubInfo):
	return 0.02 + _domInfo.fetishScore({Fetish.Rigging: 0.08}) + _subInfo.fetishScore({Fetish.Bondage: 0.08, Fetish.AnalSexReceiving: 0.06})

func getStartActions(_sexEngine: SexEngine, _domInfo: SexDomInfo, _subInfo: SexSubInfo):
	var sub:BaseCharacter = _subInfo.getChar()
	var base_score:float = getActivityScore(_sexEngine, _domInfo, _subInfo)

	if(sub.hasReachableAnus()):
		addStartAction(["prostate"], "Prostate toy training", "Use a Better Chastity toy routine focused on indirect pleasure and denial.", base_score + 0.05, {A_CATEGORY: getCategory()+["Prostate focus"]})

	if(sub.hasPenis()):
		addStartAction(["cage"], "Cage pressure training", "Use the cage itself as the focus of a Better Chastity denial routine.", base_score + 0.03, {A_CATEGORY: getCategory()+["Cage pressure"]})

	addStartAction(["praise"], "Sissy euphoria training", "Lean into praise, compliance, and Better Chastity headspace.", base_score + 0.02, {A_CATEGORY: getCategory()+["Headspace"]})
	addStartAction(["plap"], "Plapgasm training", "Build a delayed Better Chastity pressure peak.", base_score + 0.04, {A_CATEGORY: getCategory()+["Plapgasm"]})
	addStartAction(["cuck"], "Cuck heat training", "Use jealousy, praise, and denial as a focused Better Chastity headspace.", base_score + 0.03, {A_CATEGORY: getCategory()+["Headspace"]})
	addStartAction(["nipple"], "Nipple focus training", "Use chest stimulation and Better Chastity sensitivity training.", base_score + 0.03, {A_CATEGORY: getCategory()+["Nipple focus"]})

func startActivity(_args):
	training_mode = _args[0]
	turns_done = 0
	setState("training")

	if(training_mode == "prostate"):
		addText("{dom.You} {dom.youVerb('guide')} {sub.you} into a slow Better Chastity prostate-training rhythm.")
	elif(training_mode == "cage"):
		addText("{dom.You} {dom.youVerb('turn')} {sub.your} cage into the center of a strict denial-training routine.")
	elif(training_mode == "plap"):
		addText("{dom.You} {dom.youVerb('set')} a strict Better Chastity plapgasm rhythm, building pressure without giving {sub.you} direct freedom.")
	elif(training_mode == "cuck"):
		addText("{dom.You} {dom.youVerb('shape')} the scene around cuck heat, praise, jealousy, and denial.")
	elif(training_mode == "nipple"):
		addText("{dom.You} {dom.youVerb('focus')} the training on {sub.your} chest, coaxing nipple sensitivity into the denial loop.")
	else:
		addText("{dom.You} {dom.youVerb('shape')} the moment into soft praise, obedience, and Better Chastity euphoria.")

func processTurn():
	if(getState() != "training"):
		return

	turns_done += 1
	if(training_mode == "prostate"):
		getSubInfo().addLust(12.0)
		getSubInfo().addArousal(0.25)
		stimulate(DOM_0, S_HANDS, SUB_0, S_ANUS, I_LOW, Fetish.AnalSexGiving, SPEED_SLOW)
		getSub().addEffect("BBC_ProstateFocus", [60 * 75, 1.5])
		getSub().addEffect("BBC_SissyEuphoria", [60 * 40, 1.0])
		addText("{sub.You} {sub.youVerb('shake')} through a controlled wave of indirect pleasure while the cage keeps everything locked into denial.")
	elif(training_mode == "cage"):
		getSubInfo().addLust(10.0)
		getSubInfo().addArousal(0.18)
		if(getSub().hasPenis()):
			stimulate(DOM_0, S_HANDS, SUB_0, S_PENIS, I_TEASE, Fetish.SeedMilking, SPEED_SLOW)
		getSub().addEffect("BBC_SissyEuphoria", [60 * 45, 1.25])
		addText("The cage turns every careful touch into pressure, denial, and a needy Better Chastity training loop for {sub.you}.")
	elif(training_mode == "plap"):
		getSubInfo().addLust(14.0)
		getSubInfo().addArousal(0.28)
		stimulate(DOM_0, S_HANDS, SUB_0, S_ANUS, I_MEDIUM, Fetish.AnalSexGiving, SPEED_MEDIUM)
		getSub().addEffect("BBC_PlapgasmCharge", [60 * 65, 1.6])
		getSub().addEffect("BBC_ProstateFocus", [60 * 60, 1.4])
		addText("{sub.You} {sub.youVerb('learn')} the plapgasm rhythm: pressure, pause, pressure again, until denial starts feeling like its own kind of peak.")
	elif(training_mode == "cuck"):
		getSubInfo().addLust(11.0)
		getSubInfo().addArousal(0.22)
		getSub().addEffect("BBC_CuckHeat", [60 * 80, 1.4])
		getSub().addEffect("BBC_SissyEuphoria", [60 * 45, 1.0])
		addText("Cuck heat settles over {sub.you}; jealousy, praise, and denial sharpen into a trained Better Chastity headspace.")
	elif(training_mode == "nipple"):
		getSubInfo().addLust(10.0)
		getSubInfo().addArousal(0.22)
		stimulate(DOM_0, S_HANDS, SUB_0, S_BREASTS, I_LOW, Fetish.Lactation, SPEED_SLOW)
		getSub().addEffect("BBC_NippleFocus", [60 * 75, 1.4])
		if(getSub().has_method("stimulateLactation")):
			getSub().stimulateLactation()
		addText("{sub.Your} chest becomes the center of the routine, each pulse teaching {sub.your} body to answer nipple stimulation more readily.")
	else:
		getSubInfo().addLust(8.0)
		getSubInfo().addArousal(0.15)
		getSub().addEffect("BBC_SissyEuphoria", [60 * 60, 1.5])
		addText("{sub.You} {sub.youVerb('melt')} into the praise and the locked-in headspace, softer and more suggestible for a while.")

	if(turns_done >= 1):
		endActivity()

func saveData():
	var data = .saveData()
	data["training_mode"] = training_mode
	data["turns_done"] = turns_done
	return data

func loadData(data):
	.loadData(data)
	training_mode = SAVE.loadVar(data, "training_mode", "prostate")
	turns_done = SAVE.loadVar(data, "turns_done", 0)
