extends "res://Modules/BDCCBetterChastity/Items/EstraluxPatch.gd"

func _init():
	id = "BBC_EstraluxAmpoule"

func getVisibleName():
	return "Estralux Estrogen Ampoule"

func getDescription():
	return "A stronger fictional estrogen-themed Better Chastity ampoule. It applies a longer feminizing-shift status and can push compatible body-transformation systems a little further.\n[color=gray]Fantasy gameplay content, not real medication.[/color]"

func getApplicationLabel():
	return "Estralux estrogen ampoule"

func getDoseDuration():
	return 60 * 60 * 10

func getShiftPower():
	return 1.75

func getMaxBreastSize():
	return BreastsSize.H

func getPrice():
	return 38

func getInventoryImage():
	return "res://Images/Items/medical/tfpill.png"
