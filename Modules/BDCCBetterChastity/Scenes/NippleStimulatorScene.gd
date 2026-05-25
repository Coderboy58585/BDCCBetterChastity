extends SceneBase

var uniqueItemID = ""
var temporaryAdded = false
var oldWornItemID = ""
var collectedMilk = 0.0

func _init():
	sceneID = "BBC_NippleStimulatorScene"

func _initScene(_args = []):
	if(_args.size() > 0):
		uniqueItemID = _args[0]

func getSceneItem():
	if(GM.pc == null || uniqueItemID == ""):
		return null
	return GM.pc.getInventory().getItemByUniqueID(uniqueItemID)

func _reactInit():
	if(uniqueItemID == null || uniqueItemID == ""):
		return
	var item: ItemBase = getSceneItem()
	if(item == null):
		return

	if(!item.isWornByWearer()):
		if(GM.pc.hasBlockedHands()):
			setState("blockedhands")
			return
		if(GM.pc.getInventory().hasSlotEquipped(item.getClothingSlot())):
			var alreadyEquipped = GM.pc.getInventory().getEquippedItem(item.getClothingSlot())
			if(alreadyEquipped != item && alreadyEquipped.isRestraint()):
				setState("restraintequipped")
				return
			if(alreadyEquipped != item):
				oldWornItemID = alreadyEquipped.getUniqueID()
				GM.pc.getInventory().unequipItem(alreadyEquipped)

		temporaryAdded = true
		GM.pc.getInventory().removeItem(item)
		GM.pc.getInventory().forceEquipStoreOtherUnlessRestraint(item)

func _run():
	if(state == ""):
		playAnimation(StageScene.BreastGroping, "tease", {pc = "pc", npc = "pc", npcBodyState = {naked = true, hard = true}})
		saynn("You attach the nipple pulse stimulators and let their little control lights sync with Better Chastity. They sit like a wearable chest device, visible through BDCC's breast-pump model instead of acting like a hidden text-only item.")

		saynn("The first pulses are slow and romantic, more about warmth and anticipation than force.")

		addButton("Pulse", "Start the nipple-focus routine.", "pulse")
		addButton("Stop", "Take them off.", "endthescene")

	if(state == "pulse"):
		playAnimation(StageScene.BreastGroping, "grope", {pc = "pc", npc = "pc", npcBodyState = {naked = true, hard = true}})
		saynn("The stimulators settle into a steady rhythm. Every pulse feeds into the nipple-focus status, making chest stimulation more responsive for a while.")

		if(collectedMilk > 0.0):
			saynn("[color=gray]The device collected "+str(Util.roundF(collectedMilk))+" ml through BDCC's fluid system.[/color]")
		else:
			saynn("[color=gray]No milk was collected this time, but the sensitivity routine still completed.[/color]")

		addButton("Nipple peak", "Let the routine push into a soft peak.", "finish")
		addButton("Afterglow", "Wind the pulses down.", "afterglow")

	if(state == "finish"):
		playAnimation(StageScene.BreastGroping, "stroke", {pc = "pc", npc = "pc", npcCum = true, npcBodyState = {naked = true, hard = true}})
		saynn("The rhythm crests. Better Chastity logs the response as nipple-focus training, then leaves your chest warm, sensitive, and tuned for follow-up denial.")

		addButton("Continue", "Recover.", "afterglow")

	if(state == "afterglow"):
		playAnimation(StageScene.BreastGroping, "tease", {pc = "pc", npc = "pc", npcBodyState = {naked = true, hard = true}})
		saynn("The pulses fade out. The device can stay on as wearable gear or be removed from the inventory screen.")

		addButton("Continue", "Done.", "endthescene")

	if(state == "restraintequipped"):
		saynn("A restraint is blocking the chest slot, so you can't attach the stimulators.")
		addButton("Continue", "Okay.", "endthescene")

	if(state == "blockedhands"):
		saynn("Your hands are blocked, so you can't attach the stimulators by yourself.")
		addButton("Continue", "Okay.", "endthescene")

func runPulseEffects(finishing = false):
	var item = getSceneItem()
	if(item != null):
		item.sessions += 1
	GM.pc.addLust(12 if !finishing else 22)
	GM.pc.addStamina(-4 if !finishing else -7)
	GM.pc.addEffect("BBC_NippleFocus", [60 * 75, 1.2 if !finishing else 1.8])
	GM.pc.addEffect("BBC_SissyEuphoria", [60 * 35, 0.8 if !finishing else 1.2])
	increaseModuleFlag("BDCCBetterChastity", "BBC_NippleTrainingCount", 1)
	if(finishing):
		GM.pc.addEffect("BBC_PlapgasmCharge", [60 * 45, 0.9])
		increaseModuleFlag("BDCCBetterChastity", "BBC_PlapgasmCount", 1)
		GM.pc.orgasmFrom("pc")

	if(item != null && item.getFluids() != null && GM.pc.canBeMilked()):
		GM.pc.stimulateLactation()
		var bodypart = GM.pc.getBodypart(BodypartSlot.Breasts)
		if(bodypart != null && bodypart.getFluids() != null):
			collectedMilk += bodypart.getFluids().transferTo(item, 0.35 if !finishing else 0.6)
			item.updatePcIfNeeded(0.0, collectedMilk)

func _react(_action: String, _args):
	if(_action == "endthescene"):
		if(temporaryAdded):
			var item: ItemBase = getSceneItem()
			if(item != null):
				GM.pc.getInventory().unequipItem(item)

			if(oldWornItemID != ""):
				var item2: ItemBase = GM.pc.getInventory().getItemByUniqueID(oldWornItemID)
				if(item2 != null):
					GM.pc.getInventory().equipItem(item2)

		endScene()
		return

	if(_action == "pulse"):
		processTime(8 * 60)
		runPulseEffects(false)
		setState("pulse")
		return

	if(_action == "finish"):
		processTime(5 * 60)
		runPulseEffects(true)
		setState("finish")
		return

	if(_action == "afterglow"):
		processTime(3 * 60)
		setState("afterglow")
		return

	setState(_action)

func saveData():
	var data = .saveData()
	data["uniqueItemID"] = uniqueItemID
	data["temporaryAdded"] = temporaryAdded
	data["oldWornItemID"] = oldWornItemID
	data["collectedMilk"] = collectedMilk
	return data

func loadData(data):
	.loadData(data)
	uniqueItemID = SAVE.loadVar(data, "uniqueItemID", "")
	temporaryAdded = SAVE.loadVar(data, "temporaryAdded", false)
	oldWornItemID = SAVE.loadVar(data, "oldWornItemID", "")
	collectedMilk = SAVE.loadVar(data, "collectedMilk", 0.0)
