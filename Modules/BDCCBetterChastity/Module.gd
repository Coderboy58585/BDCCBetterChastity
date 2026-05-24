extends Module

func getFlags():
	return {
		"BBC_ServiceCount": flag(FlagType.Number),
		"BBC_LastDeviceMode": flag(FlagType.Text),
	}

func _init():
	id = "BDCCBetterChastity"
	author = "Coderboy58585"

	items = [
		"res://Modules/BDCCBetterChastity/Items/ErgonomicChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/TamperEvidentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/TimedSmartChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatErgonomicChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatTamperEvidentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatTimedSmartChastityCage.gd",
	]

func resetFlagsOnNewDay():
	pass
