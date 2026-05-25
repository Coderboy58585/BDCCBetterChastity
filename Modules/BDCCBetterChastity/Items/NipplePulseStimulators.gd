extends ItemBase

var sessions = 0

func _init():
	id = "BBC_NipplePulseStimulators"

func getVisibleName():
	return "Nipple Pulse Stimulators"

func getDescription():
	return "A pair of wearable Better Chastity chest stimulators. They use BDCC's breast-pump clothing slot/model, can collect milk from lactating characters, and launch an animated nipple-focus routine."

func getClothingSlot():
	return InventorySlot.UnderwearTop

func getPrice():
	return 55

func canSell():
	return true

func getMilkSpeedPerMinuteMin():
	return 20.0

func getMilkSpeedPerMinuteMax():
	return 85.0

func getBuffs():
	return [
		buff(Buff.SensitivityGainBuff, [BodypartSlot.Breasts, 18.0]),
		buff(Buff.OverstimulationThresholdBuff, [BodypartSlot.Breasts, 10.0]),
	]

func getTags():
	return [ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.BreastPump, ItemTag.BreastPumpUsableByNPC, ItemTag.SexEngineCanApply]

func getUnriggedParts(_character):
	var howFilled = 0.0
	if(fluids != null && fluids.getCapacity() > 0.0):
		howFilled = fluids.getFluidAmount()/fluids.getCapacity()
	if(howFilled < 0.5):
		return {
			"breastpump": ["res://Inventory/UnriggedModels/BreastPump/BreastPumpAdvEmpty.tscn"],
		}
	return {
		"breastpump": ["res://Inventory/UnriggedModels/BreastPump/BreastPumpAdvHalf.tscn"],
	}

func generateFluids():
	fluids = Fluids.new()
	fluids.setCapacity(1200.0)
	var _ok = fluids.connect("contentsChanged", self, "updatePcIfNeeded")

func updatePcIfNeeded(_oldFluidAmount, _newFluidAmount):
	if(!isWornByWearer()):
		return
	updateWearerAppearance()

func getPossibleActions():
	return [
		{
			"name": "Attach stimulators",
			"scene": "BBC_NippleStimulatorScene",
			"description": "Use the wearable Better Chastity nipple stimulators.",
			"onlyWhenCalm": true,
		},
		{
			"name": "Transfer fluids",
			"scene": "FluidTransferScene",
			"description": "Transfer fluids between containers.",
		},
		{
			"name": "Drink from",
			"scene": "DrinkFromScene",
			"description": "Drink the contents of this item.",
		},
	]

func getInventoryImage():
	if(fluids == null || fluids.getCapacity() <= 0.0 || fluids.getFluidAmount() <= 0.0):
		return "res://Images/Items/breastpump/pumpAdvEmpty.png"
	return "res://Images/Items/breastpump/pumpAdvLittle.png"

func alwaysRecoveredAfterSex():
	return true

func getSexEngineSubcategory() -> Array:
	return ["Better Chastity body"]

func getSexEngineInfo(_sexEngine, _domInfo, _subInfo):
	return {
		"name": "Nipple pulse",
		"usedName": "nipple pulse stimulators",
		"desc": "Applies Better Chastity nipple focus and can behave like a light breast-pump item.",
		"scoreOnSub": 0.11,
		"scoreOnSelf": 0.05,
		"scoreSubScore": 0.2,
		"canUseOnDom": true,
		"canUseOnSub": true,
		"maxUsesByNPC": 2,
	}

func useInSex(_receiver):
	_receiver.addLust(8)
	_receiver.addEffect("BBC_NippleFocus", [60 * 70, 1.2])
	_receiver.addEffect("BBC_SissyEuphoria", [60 * 35, 0.8])
	return {
		text = "{USER.You} {USER.youVerb('shiver')} as the Better Chastity chest stimulators find a steady rhythm.".replace("USER", _receiver.getID()),
	}

func saveData():
	var data = .saveData()
	data["sessions"] = sessions
	return data

func loadData(data):
	.loadData(data)
	sessions = SAVE.loadVar(data, "sessions", 0)
