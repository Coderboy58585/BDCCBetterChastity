extends SceneBase

var uniqueItemID = ""
var resultText = ""

func _init():
	sceneID = "BBC_SterileCalibrationScene"

func _initScene(_args = []):
	if(_args.size() > 0):
		uniqueItemID = _args[0]

func getSceneItem():
	if(GM.pc == null || uniqueItemID == ""):
		return null
	return GM.pc.getInventory().getItemByUniqueID(uniqueItemID)

func playCalibrationAnim():
	playAnimation(StageScene.Grope, "watchstroke" if GM.pc.hasReachablePenis() else "watchrub", {pc = "pc", npc = "pc", onlyPC = true, bodyState = {naked = true, hard = true}})

func _run():
	if(state == ""):
		playCalibrationAnim()
		saynn("You unpack the sterile Better Chastity calibration kit. The risky details stay abstracted into a sealed, fictional routine while the scene uses BDCC's solo animation flow.")

		addButton("Calibrate", "Run the sealed calibration routine.", "calibrate")
		addButton("Cancel", "Put the kit away.", "endthescene")

	if(state == "calibrated"):
		playCalibrationAnim()
		saynn(resultText)
		addButton("Continue", "Done.", "endthescene")

func _react(_action: String, _args):
	if(_action == "endthescene"):
		endScene()
		return

	if(_action == "calibrate"):
		var item = getSceneItem()
		if(item == null || !item.has_method("useInCombat")):
			resultText = "The kit is missing or can't be calibrated."
		else:
			resultText = item.useInCombat(GM.pc, null)
		setState("calibrated")
		return

	setState(_action)

func saveData():
	var data = .saveData()
	data["uniqueItemID"] = uniqueItemID
	data["resultText"] = resultText
	return data

func loadData(data):
	.loadData(data)
	uniqueItemID = SAVE.loadVar(data, "uniqueItemID", "")
	resultText = SAVE.loadVar(data, "resultText", "")
