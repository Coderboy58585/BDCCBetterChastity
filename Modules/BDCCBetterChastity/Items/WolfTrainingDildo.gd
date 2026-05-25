extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_WolfTrainingDildo"

func getToyName():
	return "Knotted Wolf Dildo"

func getToyDescription():
	return "A knotted Better Chastity toy that uses BDCC's canine ride animation states. It has its own fluid storage and stronger plapgasm buildup."

func getToyLabel():
	return "knotted wolf dildo"

func getToyIntensity():
	return 4

func getToyStretchPower():
	return 36

func getToyFluidCapacity():
	return 1750.0

func getPrice():
	return 95

func getItemCategory():
	return ItemCategory.Generic

func getInventoryImage():
	return "res://Images/Items/strapons/canine.png"

func getToyAnimationProfile():
	return "canine"

func getToyStageScene():
	return StageScene.CanineDildoSex

func getToyFastAnim():
	return "knotfast"

func getToyFinishAnim():
	return "knotfast"
