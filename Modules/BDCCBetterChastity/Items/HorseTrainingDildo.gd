extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_HorseTrainingDildo"

func getToyName():
	return "Better Horse Dildo"

func getToyDescription():
	return "A heavy suction-base toy tuned for Better Chastity routines. It uses BDCC's horse-dildo ride animation and can be filled through the fluid system."

func getToyLabel():
	return "horse training dildo"

func getToyIntensity():
	return 4

func getToyStretchPower():
	return 44

func getToyFluidCapacity():
	return 5000.0

func getPrice():
	return 110

func getItemCategory():
	return ItemCategory.Generic

func getInventoryImage():
	return "res://Images/Items/toys/horsecockdildo.png"

func getToyAnimationProfile():
	return "horse"

func getToyStageScene():
	return StageScene.HorsecockDildoSex
