extends Module

func getFlags():
	return {
		"BBC_ServiceCount": flag(FlagType.Number),
		"BBC_LastDeviceMode": flag(FlagType.Text),
		"BBC_ToyTrainingScore": flag(FlagType.Number),
		"BBC_FeminizingProgramCount": flag(FlagType.Number),
		"BBC_PlapgasmCount": flag(FlagType.Number),
		"BBC_CuckHeatCount": flag(FlagType.Number),
		"BBC_NippleTrainingCount": flag(FlagType.Number),
	}

func _init():
	id = "BDCCBetterChastity"
	author = "Coderboy58585"

	items = [
		"res://Modules/BDCCBetterChastity/Items/StandardChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/ErgonomicChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/TamperEvidentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/TimedSmartChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatErgonomicChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatTamperEvidentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatTimedSmartChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/PermanentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/FlatPermanentChastityCage.gd",
		"res://Modules/BDCCBetterChastity/Items/SoftTrainingDildo.gd",
		"res://Modules/BDCCBetterChastity/Items/WeightedTrainingDildo.gd",
		"res://Modules/BDCCBetterChastity/Items/ProstatePulseStimulator.gd",
		"res://Modules/BDCCBetterChastity/Items/HorseTrainingDildo.gd",
		"res://Modules/BDCCBetterChastity/Items/WolfTrainingDildo.gd",
		"res://Modules/BDCCBetterChastity/Items/TentacleTrainingDildo.gd",
		"res://Modules/BDCCBetterChastity/Items/NipplePulseStimulators.gd",
		"res://Modules/BDCCBetterChastity/Items/SterileSoundingKit.gd",
		"res://Modules/BDCCBetterChastity/Items/EstraluxPatch.gd",
		"res://Modules/BDCCBetterChastity/Items/EstraluxAmpoule.gd",
	]

	scenes = [
		"res://Modules/BDCCBetterChastity/Scenes/AnimatedToyScene.gd",
		"res://Modules/BDCCBetterChastity/Scenes/NippleStimulatorScene.gd",
		"res://Modules/BDCCBetterChastity/Scenes/EstraluxApplicationScene.gd",
		"res://Modules/BDCCBetterChastity/Scenes/SterileCalibrationScene.gd",
	]

	statusEffects = [
		"res://Modules/BDCCBetterChastity/StatusEffects/SissyEuphoria.gd",
		"res://Modules/BDCCBetterChastity/StatusEffects/ProstateFocus.gd",
		"res://Modules/BDCCBetterChastity/StatusEffects/FeminizingShift.gd",
		"res://Modules/BDCCBetterChastity/StatusEffects/PlapgasmCharge.gd",
		"res://Modules/BDCCBetterChastity/StatusEffects/CuckHeat.gd",
		"res://Modules/BDCCBetterChastity/StatusEffects/NippleFocus.gd",
	]

	sexActivities = [
		"res://Modules/BDCCBetterChastity/SexActivities/BetterChastityToyTraining.gd",
	]

func resetFlagsOnNewDay():
	pass
