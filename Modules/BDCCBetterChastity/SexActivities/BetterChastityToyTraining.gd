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

func startActivity(_args):
	training_mode = _args[0]
	turns_done = 0
	setState("training")

	if(training_mode == "prostate"):
		addText("{dom.You} {dom.youVerb('guide')} {sub.you} into a slow Better Chastity prostate-training rhythm.")
	elif(training_mode == "cage"):
		addText("{dom.You} {dom.youVerb('turn')} {sub.your} cage into the center of a strict denial-training routine.")
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
