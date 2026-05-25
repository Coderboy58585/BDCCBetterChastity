extends SceneBase

var uniqueItemID = ""
var resultText = ""

func _init():
	sceneID = "BBC_EstraluxApplicationScene"

func _initScene(_args = []):
	if(_args.size() > 0):
		uniqueItemID = _args[0]

func getSceneItem():
	if(GM.pc == null || uniqueItemID == ""):
		return null
	return GM.pc.getInventory().getItemByUniqueID(uniqueItemID)

func _run():
	if(state == ""):
		playAnimation(StageScene.Grope, "watchrub" if !GM.pc.hasReachablePenis() else "watchstroke", {pc = "pc", npc = "pc", onlyPC = true, bodyState = {naked = false, hard = false}})
		saynn("You prepare the Estralux dose. Better Chastity treats it as a fictional estrogen-themed body-shift item, not real medication.")

		saynn("The dose will apply a feminizing-shift status, nudge compatible body-transformation systems, and play a short application animation.")

		addButton("Apply", "Apply the fictional Estralux dose.", "apply")
		addButton("Cancel", "Put it away.", "endthescene")

	if(state == "absorbing"):
		playAnimation(StageScene.Grope, "tease", {pc = "pc", npc = "pc", bodyState = {naked = false, hard = false}})
		saynn(resultText)

		saynn("A warm afterglow follows as the fantasy hormone program settles into the Better Chastity training loop.")

		addButton("Continue", "Done.", "endthescene")

func _react(_action: String, _args):
	if(_action == "endthescene"):
		endScene()
		return

	if(_action == "apply"):
		var item = getSceneItem()
		if(item == null || !item.has_method("applyEstralux")):
			resultText = "The dose is missing or can't be applied."
		else:
			resultText = item.applyEstralux(GM.pc, true)
			increaseModuleFlag("BDCCBetterChastity", "BBC_FeminizingProgramCount", 1)
		setState("absorbing")
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
