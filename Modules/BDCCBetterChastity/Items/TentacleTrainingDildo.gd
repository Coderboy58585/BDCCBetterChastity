extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_TentacleTrainingDildo"

func getToyName():
	return "Tentacle Training Dildo"

func getToyDescription():
	return "A flexible fantasy toy tied into BDCC's tentacle tease and tentacle sex animations. It is suggestive game content and keeps the risky details abstract."

func getToyLabel():
	return "tentacle training dildo"

func getToyIntensity():
	return 3

func getToyStretchPower():
	return 30

func getToyFluidCapacity():
	return 1200.0

func getPrice():
	return 85

func getItemCategory():
	return ItemCategory.Generic

func getInventoryImage():
	return "res://Images/Items/strapons/ovi.png"

func getToyAnimationProfile():
	return "tentacle"

func getToyTeaseScene():
	return StageScene.TentaclesTease

func getToyStageScene():
	return StageScene.TentaclesSex
