extends SceneBase

var uniqueItemID = ""
var use_slot = "anus"
var hadContents = false

func _init():
	sceneID = "BBC_AnimatedToyScene"

func _initScene(_args = []):
	if(_args.size() > 0):
		uniqueItemID = _args[0]

func getSceneItem():
	if(GM.pc == null || uniqueItemID == ""):
		return null
	return GM.pc.getInventory().getItemByUniqueID(uniqueItemID)

func callItem(method_name, default_value):
	var item = getSceneItem()
	if(item != null && item.has_method(method_name)):
		return item.call(method_name)
	return default_value

func getToyLabel():
	return str(callItem("getToyLabel", "training toy"))

func getToyName():
	return str(callItem("getToyName", "Better Chastity toy"))

func getToyIntensity():
	return int(callItem("getToyIntensity", 2))

func getToyStretchPower():
	return int(callItem("getToyStretchPower", 22))

func getToyProfile():
	return str(callItem("getToyAnimationProfile", "horse"))

func buildToyAnimArgs(pcCum = false, cum = false):
	var profile = getToyProfile()
	var args = {bodyState = {naked = true, hard = true}}
	if(profile == "prostate"):
		args = {pc = "pc", npc = "pc", bodyState = {naked = true, hard = true}, npcBodyState = {naked = true, hard = true}}
	elif(profile == "tentacle"):
		args = {pc = "pc", plant = true, bodyState = {naked = true, hard = true}}
	if(pcCum):
		args["pcCum"] = true
	if(cum):
		args["cum"] = true
	return args

func playToyAnimation(phase, pcCum = false, cum = false):
	if(use_slot == "external" || use_slot == "cuck"):
		playExternalAnimation(phase, pcCum)
		return

	var scene_id = callItem("getToyStageScene", StageScene.HorsecockDildoSex)
	var anim_id = "sex"
	if(phase == "tease"):
		scene_id = callItem("getToyTeaseScene", scene_id)
		anim_id = callItem("getToyTeaseAnim", "tease")
	elif(phase == "inside"):
		anim_id = callItem("getToyInsideAnim", "inside")
	elif(phase == "rhythm"):
		anim_id = callItem("getToyRhythmAnim", "sex")
	elif(phase == "fast"):
		anim_id = callItem("getToyFastAnim", "fast")
	elif(phase == "finish"):
		anim_id = callItem("getToyFinishAnim", "fast")
	playAnimation(scene_id, anim_id, buildToyAnimArgs(pcCum, cum))

func playExternalAnimation(phase, pcCum = false):
	var anim_id = "watchrub"
	if(GM.pc.hasReachablePenis()):
		anim_id = "watchstroke"
	if(phase == "rhythm"):
		anim_id = "grope"
		if(GM.pc.hasReachablePenis()):
			anim_id = "stroke"
	if(phase == "fast" || phase == "finish"):
		anim_id = "gropefast"
		if(GM.pc.hasReachablePenis()):
			anim_id = "strokefast"
	playAnimation(StageScene.Grope, anim_id, {onlyPC = true, pcCum = pcCum, bodyState = {naked = true, hard = true}})

func describeSlot():
	if(use_slot == "vagina"):
		return "vaginal"
	if(use_slot == "external"):
		return "cage-pressure"
	if(use_slot == "cuck"):
		return "cuck-headspace"
	return "anal"

func _run():
	if(state == ""):
		use_slot = "anus"
		playToyAnimation("tease")
		saynn("You set up the "+getToyLabel()+" and let the Better Chastity routine sync with it. This one is wired into the game's actual toy animation flow, so the scene can move through setup, rhythm, peak, and afterglow instead of only printing a combat-use line.")

		saynn("Choose how you want to run the session.")

		addButtonWithChecks("Anal routine", "Use the animated routine with anal/prostate focus.", "choose_anus", [], [ButtonChecks.HasReachableAnus])
		addButtonWithChecks("Vaginal routine", "Use the animated routine with vaginal focus.", "choose_vagina", [], [ButtonChecks.HasReachableVagina])
		addButton("Cage pressure", "Keep the toy external and build denial pressure around the cage.", "choose_external")
		addButton("Cuck headspace", "Turn the session toward jealousy, praise, and denial heat.", "choose_cuck")
		addButton("Cancel", "Put the toy away.", "endthescene")

	if(state == "settle"):
		playToyAnimation("inside")
		saynn("The "+getToyLabel()+" settles into a slow "+describeSlot()+" routine. Better Chastity keeps the rhythm deliberate: pressure, pause, breath, then pressure again.")

		saynn("A little counter in the toy profile ticks upward as your body learns the pacing.")

		addButton("Build rhythm", "Let the routine get more intense.", "rhythm")
		addButton("Stop", "End the session here.", "afterglow")

	if(state == "rhythm"):
		playToyAnimation("rhythm")
		saynn("The rhythm gets steadier. Each impact adds plapgasm charge, a Better Chastity mechanic that turns repeated pressure into a delayed, indirect peak.")

		if(use_slot == "anus"):
			saynn("The prostate-focus program keeps everything centered on indirect pleasure while the cage makes the denial feel sharper.")
		elif(use_slot == "external"):
			saynn("The cage pressure stays external, but the toy keeps the timing strict enough that the denial still builds.")
		elif(use_slot == "cuck"):
			saynn("The cuck-headspace program folds jealousy, praise, and surrender into the same mounting rhythm.")
		else:
			saynn("The routine stays smooth and controlled, letting the toy's shape and the denial program do the work.")

		addButton("Plapgasm", "Ride the built-up charge to a peak.", "finish")
		addButton("Cuck heat", "Lean into the cuck-headspace mechanic.", "cuck_heat")
		addButton("Afterglow", "Back off and recover.", "afterglow")

	if(state == "cuck_heat"):
		playToyAnimation("rhythm")
		saynn("You let the cuck-headspace program take over. The toy keeps moving, but the bigger pressure is emotional: wanting, being denied, and being told that the wanting is the point.")

		saynn("Better Chastity logs the session as cuck heat and makes later denial routines easier to sink into.")

		addButton("Channel it", "Turn the cuck heat into a plapgasm peak.", "finish")
		addButton("Afterglow", "Back off and recover.", "afterglow")

	if(state == "finish"):
		playToyAnimation("finish", true, true)
		saynn("The plapgasm charge finally tips over. Your body locks into the trained rhythm, chasing release through pressure and denial instead of direct freedom.")

		if(hadContents):
			saynn("[color=gray]The toy's stored fluids were transferred through BDCC's fluid system during the peak.[/color]")

		saynn("The toy profile saves the session and the aftereffects settle in.")

		addButton("Continue", "Ride out the afterglow.", "afterglow")

	if(state == "afterglow"):
		playToyAnimation("inside")
		saynn("The routine winds down. Your body is left sensitive, suggestible, and tuned for Better Chastity denial for a while.")

		addButton("Continue", "Put the toy away.", "endthescene")

func applyTrainingEffects(multiplier = 1.0, finishing = false):
	var intensity = max(1, getToyIntensity())
	var lust_gain = int((8 + intensity * 5) * multiplier)
	var stamina_cost = int((3 + intensity * 2) * multiplier)
	GM.pc.addLust(lust_gain)
	GM.pc.addStamina(-stamina_cost)
	if(intensity >= 4 && finishing):
		GM.pc.addPain(1)

	if(use_slot == "anus"):
		GM.pc.addEffect("BBC_ProstateFocus", [60 * (60 + intensity * 8), 1.0 + float(intensity) * 0.25])
		GM.pc.gotOrificeStretchedWith(BodypartSlot.Anus, getToyStretchPower())
	elif(use_slot == "vagina"):
		GM.pc.addEffect("BBC_SissyEuphoria", [60 * (45 + intensity * 8), 0.8 + float(intensity) * 0.2])
		GM.pc.gotOrificeStretchedWith(BodypartSlot.Vagina, getToyStretchPower())
	elif(use_slot == "cuck"):
		GM.pc.addEffect("BBC_CuckHeat", [60 * (75 + intensity * 10), 1.0 + float(intensity) * 0.2])
	else:
		GM.pc.addEffect("BBC_SissyEuphoria", [60 * (50 + intensity * 8), 0.9 + float(intensity) * 0.2])

	if(finishing):
		GM.pc.addEffect("BBC_PlapgasmCharge", [60 * (50 + intensity * 8), 1.0 + float(intensity) * 0.25])
		GM.pc.addEffect("BBC_SissyEuphoria", [60 * (45 + intensity * 8), 1.0 + float(intensity) * 0.2])

func recordToyUse():
	var item = getSceneItem()
	if(item != null && item.has_method("recordToyUse")):
		item.recordToyUse(getToyIntensity())

func transferToyFluids():
	var item = getSceneItem()
	if(item == null || item.getFluids() == null || item.getFluids().isEmpty()):
		return
	if(use_slot == "vagina" && GM.pc.hasBodypart(BodypartSlot.Vagina)):
		hadContents = true
		item.getFluids().transferTo(GM.pc.getBodypart(BodypartSlot.Vagina), 1.0)
	elif(use_slot == "anus" && GM.pc.hasBodypart(BodypartSlot.Anus)):
		hadContents = true
		item.getFluids().transferTo(GM.pc.getBodypart(BodypartSlot.Anus), 1.0)

func _react(_action: String, _args):
	if(_action == "endthescene"):
		endScene()
		return

	if(_action == "choose_anus"):
		use_slot = "anus"
		processTime(2 * 60)
		applyTrainingEffects(0.55)
		recordToyUse()
		setState("settle")
		return

	if(_action == "choose_vagina"):
		use_slot = "vagina"
		processTime(2 * 60)
		applyTrainingEffects(0.55)
		recordToyUse()
		setState("settle")
		return

	if(_action == "choose_external"):
		use_slot = "external"
		processTime(2 * 60)
		applyTrainingEffects(0.5)
		recordToyUse()
		setState("settle")
		return

	if(_action == "choose_cuck"):
		use_slot = "cuck"
		processTime(2 * 60)
		applyTrainingEffects(0.5)
		recordToyUse()
		setState("cuck_heat")
		return

	if(_action == "rhythm"):
		processTime(8 * 60)
		applyTrainingEffects(1.0)
		setState("rhythm")
		return

	if(_action == "cuck_heat"):
		use_slot = "cuck"
		processTime(5 * 60)
		applyTrainingEffects(0.85)
		setState("cuck_heat")
		return

	if(_action == "finish"):
		processTime(5 * 60)
		applyTrainingEffects(1.25, true)
		transferToyFluids()
		increaseModuleFlag("BDCCBetterChastity", "BBC_PlapgasmCount", 1)
		if(use_slot == "cuck"):
			increaseModuleFlag("BDCCBetterChastity", "BBC_CuckHeatCount", 1)
		GM.pc.orgasmFrom("pc")
		setState("finish")
		return

	if(_action == "afterglow"):
		processTime(4 * 60)
		setState("afterglow")
		return

	setState(_action)

func saveData():
	var data = .saveData()
	data["uniqueItemID"] = uniqueItemID
	data["use_slot"] = use_slot
	data["hadContents"] = hadContents
	return data

func loadData(data):
	.loadData(data)
	uniqueItemID = SAVE.loadVar(data, "uniqueItemID", "")
	use_slot = SAVE.loadVar(data, "use_slot", "anus")
	hadContents = SAVE.loadVar(data, "hadContents", false)
