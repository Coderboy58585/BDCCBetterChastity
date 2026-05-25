extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_SoftTrainingDildo"
	clothesColor = Color(0.19, 0.19, 0.19)

func getToyName():
	return "Soft Training Strapon"

func getToyDescription():
	return "A soft, wearable Better Chastity training toy. It uses BDCC's strapon slot, can be filled with fluids, and also launches an animated solo-training routine."

func getToyLabel():
	return "soft training strapon"

func getToyIntensity():
	return 1

func getToyStretchPower():
	return 18

func getToyFluidCapacity():
	return 500.0

func getToyAnimationProfile():
	return "horse"

func getClothingSlot():
	return InventorySlot.Strapon

func getTags():
	return [ItemTag.Strapon, ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.SexEngineCanApply]

func getRiggedParts(_character):
	if(itemState.isRemoved()):
		return null
	return {
		"strapon": "res://Inventory/RiggedModels/Strapons/HumancockStrapon.tscn",
	}

func getHidesParts(_character):
	return {
		BodypartSlot.Penis: true,
		"chastity_cage": true,
	}

func shouldBeVisibleOnDoll(_character, _doll):
	if(!_character.isBodypartCovered(BodypartSlot.Penis) || _doll.isForcedExposed(BodypartSlot.Penis)):
		return true
	return false

func updateDoll(doll: Doll3D):
	doll.setPenisScale(1.0)
	doll.setBallsScale(1.0)

func getStraponLength():
	return 18.0

func getStraponPleasureForDom():
	return 0.2

func getPutOnScene():
	return "StraponPutOnScene"

func getCasualName():
	return "soft training strapon"

func getLewdStraponName() -> String:
	return "soft training strapon"

func getInventoryImage():
	return "res://Images/Items/strapons/human.png"

func alwaysRecoveredAfterSex():
	return true

func canDye():
	return true

func getStraponTraits() -> Dictionary:
	return {}
