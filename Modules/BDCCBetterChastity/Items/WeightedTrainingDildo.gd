extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_WeightedTrainingDildo"
	clothesColor = Color(0.1, 0.1, 0.13)

func getToyName():
	return "Weighted Training Strapon"

func getToyDescription():
	return "A heavier wearable Better Chastity toy with a stricter pace. It uses BDCC's strapon gear behavior and has an animated solo-training action."

func getToyLabel():
	return "weighted training strapon"

func getToyIntensity():
	return 3

func getToyStretchPower():
	return 28

func getToyFluidCapacity():
	return 900.0

func getToyAnimationProfile():
	return "canine"

func getToyStageScene():
	return StageScene.CanineDildoSex

func getToyFastAnim():
	return "knotfast"

func getToyFinishAnim():
	return "knotfast"

func getClothingSlot():
	return InventorySlot.Strapon

func getTags():
	return [ItemTag.Strapon, ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.SexEngineCanApply]

func getRiggedParts(_character):
	if(itemState.isRemoved()):
		return null
	return {
		"strapon": "res://Inventory/RiggedModels/Strapons/CaninecockStrapon.tscn",
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
	doll.setPenisScale(1.08)
	doll.setBallsScale(1.0)

func getStraponLength():
	return 24.0

func getStraponPleasureForDom():
	return 0.25

func getPutOnScene():
	return "StraponPutOnScene"

func getCasualName():
	return "weighted training strapon"

func getLewdStraponName() -> String:
	return "weighted training strapon"

func getInventoryImage():
	return "res://Images/Items/strapons/canine.png"

func alwaysRecoveredAfterSex():
	return true

func canDye():
	return true

func getStraponTraits() -> Dictionary:
	return {
		PartTrait.PenisKnot: true,
	}
