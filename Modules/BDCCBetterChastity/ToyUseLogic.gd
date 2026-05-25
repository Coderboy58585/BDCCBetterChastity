extends Reference

const STATUS_SISSY_EUPHORIA = "BBC_SissyEuphoria"
const STATUS_PROSTATE_FOCUS = "BBC_ProstateFocus"

func getModeText(mode, toy_label):
	if(mode == "prostate"):
		return "You use the "+toy_label+" for prostate-focused training, keeping the rhythm slow and controlled until the pressure settles into a warm ache."
	if(mode == "external"):
		return "You use the "+toy_label+" over the cage and surrounding pressure points, turning denial into a deliberate training routine."
	if(mode == "sounding"):
		return "You run the "+toy_label+"'s sterile calibration routine. The kit rewards patience, logs the session, and stops before it becomes reckless."
	return "You use the "+toy_label+" for a careful toy-training session, letting the Better Chastity routine handle the pacing."

func applyModeEffect(wearer, mode, intensity):
	if(wearer == null):
		return
	if(mode == "prostate"):
		wearer.addEffect(STATUS_PROSTATE_FOCUS, [60 * 75, 1.0 + float(intensity) * 0.3])
		wearer.addEffect(STATUS_SISSY_EUPHORIA, [60 * 35, 0.75 + float(intensity) * 0.2])
	elif(mode == "external"):
		wearer.addEffect(STATUS_SISSY_EUPHORIA, [60 * 50, 1.0 + float(intensity) * 0.2])
	elif(mode == "sounding"):
		wearer.addEffect(STATUS_SISSY_EUPHORIA, [60 * 40, 0.75 + float(intensity) * 0.1])
	else:
		wearer.addEffect(STATUS_PROSTATE_FOCUS, [60 * 45, 0.75 + float(intensity) * 0.2])

func perform(item, wearer, toy_label, intensity, mode, extra_text = "", advance_time = true):
	item.use_count += 1
	item.training_score += max(1, intensity)

	var lust_gain = int(7 + intensity * 5 + (item.training_score % 4))
	var stamina_cost = int(4 + intensity * 2)
	var pain_gain = 0
	if(mode == "sounding"):
		pain_gain = int(max(1, intensity - 1))
	elif(intensity >= 3):
		pain_gain = 1

	var text = ""
	if(extra_text != ""):
		text += extra_text+"\n\n"
	text += getModeText(mode, toy_label)

	if(wearer != null):
		wearer.addLust(lust_gain)
		wearer.addStamina(-stamina_cost)
		if(pain_gain > 0):
			wearer.addPain(pain_gain)
		applyModeEffect(wearer, mode, intensity)

	if(advance_time && GM.main != null):
		GM.main.processTime(12 * 60)

	text += "\n[color=gray]Lust +"+str(lust_gain)+", stamina -"+str(stamina_cost)
	if(pain_gain > 0):
		text += ", pain +"+str(pain_gain)
	text += ". Training score: "+str(item.training_score)+".[/color]"

	return text
