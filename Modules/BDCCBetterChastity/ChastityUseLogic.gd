extends Reference

const STATUS_SISSY_EUPHORIA = "BBC_SissyEuphoria"
const STATUS_PROSTATE_FOCUS = "BBC_ProstateFocus"

func getTechniqueText(style, device_label):
	if(style == 1):
		return "You work with controlled external impact against the "+device_label+", letting the lock and plate turn blocked movement into pressure."
	if(style == 2):
		return "You shift into prostate-focused pressure, using the restraint's forced stillness to build slow, indirect stimulation."
	return "You test the "+device_label+" with careful cage pressure, keeping everything controlled while the restraint does most of the work."

func applyTechniqueEffect(wearer, style, intensity):
	if(wearer == null):
		return
	if(style == 1):
		wearer.addEffect(STATUS_SISSY_EUPHORIA, [60 * 45, 1.0 + float(intensity) * 0.25])
	elif(style == 2):
		wearer.addEffect(STATUS_PROSTATE_FOCUS, [60 * 60, 1.0 + float(intensity) * 0.35])
	else:
		wearer.addEffect(STATUS_SISSY_EUPHORIA, [60 * 30, 0.75 + float(intensity) * 0.15])

func perform(item, wearer, device_label, intensity, extra_text = "", advance_time = true):
	item.use_count += 1
	item.stimulation_style += 1
	if(item.stimulation_style >= 3):
		item.stimulation_style = 0

	var lust_gain = int(6 + intensity * 5 + (item.use_count % 4))
	var pain_gain = int(max(0, intensity - 1))
	var stamina_cost = int(5 + intensity * 2)
	var text = ""

	if(extra_text != ""):
		text += extra_text+"\n\n"

	text += getTechniqueText(item.stimulation_style, device_label)

	if(wearer != null):
		wearer.addLust(lust_gain)
		wearer.addStamina(-stamina_cost)
		if(pain_gain > 0):
			wearer.addPain(pain_gain)
		applyTechniqueEffect(wearer, item.stimulation_style, intensity)

	if(advance_time && GM.main != null):
		GM.main.processTime(10 * 60)

	text += "\n[color=gray]Lust +"+str(lust_gain)+", stamina -"+str(stamina_cost)
	if(pain_gain > 0):
		text += ", pain +"+str(pain_gain)
	text += ". Uses logged: "+str(item.use_count)+". Better Chastity training effect applied.[/color]"

	return text
