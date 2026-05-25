extends "res://Modules/BDCCBetterChastity/Items/BetterChastityToyBase.gd"

func _init():
	id = "BBC_ProstatePulseStimulator"

func getToyName():
	return "Prostate Pulse Stimulator"

func getToyDescription():
	return "A compact Better Chastity stimulator for hands-free, prostate-centered denial training. Its inventory action now uses BDCC's milking-machine animation instead of plain text."

func getToyLabel():
	return "prostate pulse stimulator"

func getToyModes():
	return [
		{id = "prostate", label = "low pulse"},
		{id = "prostate", label = "steady pulse"},
		{id = "prostate", label = "deep pulse"},
	]

func getToyIntensity():
	return 2 + current_mode

func getToyStretchPower():
	return 14 + current_mode * 4

func getToyAnimationProfile():
	return "prostate"

func getToyStageScene():
	return StageScene.MilkingProstate

func getInventoryImage():
	return "res://Images/Items/medical/lubricant.png"
