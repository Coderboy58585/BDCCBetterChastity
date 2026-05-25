extends ItemBase

var doses_used = 0

func _init():
	id = "BBC_EstraluxPatch"

func getVisibleName():
	return "Estralux Patch"

func getDescription():
	return "A fictional estrogen-themed Better Chastity patch. It applies a temporary feminizing-shift status and can nudge compatible body-transformation systems.\n[color=gray]This is fantasy gameplay content, not real medication.[/color]"

func canUseInCombat():
	return true

func useInCombat(_attacker, _receiver):
	doses_used += 1
	if(_attacker != null):
		_attacker.addEffect("BBC_FeminizingShift", [60 * 60 * 6, 1.0])
		_attacker.addLust(4)
		_attacker.addStamina(-2)
	var body_text = applyBodyNudge(_attacker)
	removeXOrDestroy(1)
	if(GM.main != null && _receiver == null):
		GM.main.processTime(5 * 60)
	return "{attacker.name} applies an Estralux patch. The fantasy hormone program warms under the skin and syncs with Better Chastity training."+body_text

func applyBodyNudge(wearer):
	if(wearer == null):
		return ""
	var text_parts = []
	if(wearer.hasBodypart(BodypartSlot.Breasts)):
		var breasts = wearer.getBodypart(BodypartSlot.Breasts)
		if(breasts != null && breasts.has_method("setBreastSizeSafe") && breasts.has_method("getSize")):
			var old_size = breasts.getSize()
			var new_size = min(BreastsSize.DD, old_size + 1)
			if(new_size > old_size):
				breasts.setBreastSizeSafe(new_size)
				text_parts.append("breast tissue softens slightly")
		if(breasts != null && breasts.has_method("induceLactation") && doses_used >= 2):
			breasts.induceLactation()
			text_parts.append("lactation systems wake up")
	if(wearer.has_method("updateAppearance")):
		wearer.updateAppearance()
	if(text_parts.size() <= 0):
		return ""
	return "\n[color=gray]Body shift: "+Util.join(text_parts, ", ")+".[/color]"

func getPossibleActions():
	return [
		{
			"name": "Apply patch",
			"scene": "UseItemLikeInCombatScene",
			"description": "Apply the fictional feminizing Better Chastity patch.",
		},
	]

func getPrice():
	return 18

func canSell():
	return true

func canCombine():
	return true

func getTags():
	return [ItemTag.SoldByMedicalVendomat, ItemTag.SoldByTheAnnouncer, ItemTag.SexEngineDrug, ItemTag.SexEngineCanApply, ItemTag.TFItem]

func getBuyAmount():
	return 1

func getItemCategory():
	return ItemCategory.Medical

func getInventoryImage():
	return "res://Images/Items/medical/tfpill.png"

func getSexEngineSubcategory() -> Array:
	return ["Better Chastity body"]

func getSexEngineInfo(_sexEngine, _domInfo, _subInfo):
	return {
		"name": "Estralux patch",
		"usedName": "an Estralux patch",
		"desc": "Applies a fictional feminizing-shift status and may nudge compatible body-transformation systems.",
		"scoreOnSub": 0.1,
		"scoreOnSelf": 0.05,
		"scoreSubScore": 0.2,
		"canUseOnDom": true,
		"canUseOnSub": true,
		"maxUsesByNPC": 1,
	}

func useInSex(_receiver):
	_receiver.addEffect("BBC_FeminizingShift", [60 * 60 * 6, 1.0])
	var body_text = applyBodyNudge(_receiver)
	return {
		text = "{USER.You} {USER.youVerb('feel')} a fictional Better Chastity feminizing program settle in.".replace("USER", _receiver.getID())+body_text,
	}

func saveData():
	var data = .saveData()
	data["doses_used"] = doses_used
	return data

func loadData(data):
	.loadData(data)
	doses_used = SAVE.loadVar(data, "doses_used", 0)
