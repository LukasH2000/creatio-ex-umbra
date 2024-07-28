# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal item_finished

# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES


# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS


# PRIVATE METHODS


# SUBCLASSES




#func _on_button_dark_room_mouse_entered():
	#$Labels/LabelDarkRoom.show()
#
#
#func _on_button_dark_room_mouse_exited():
	#$Labels/LabelDarkRoom.hide()


func _on_button_finish_item_pressed():
	var pw := PersistentData.get_popup_window()
	pw.show_popup(PopupWindow.TYPE.FINISH_ITEM)
	var cancelled : bool = await pw.popup_finished
	if not cancelled:
		# TODO: handle item_finished in shadow_canvas.gd
		item_finished.emit()
		# ALERT: comment out later
		#$FinishedItemScreen.show()


# TODO: make a function in finished item screen that receives necessary
# data to show the item and add the finished item to player inv
# Adding can be done in shadow_canvas.gd
func show_finished_item_screen(used_mats : Array[Item], item_to_form : Item) -> void:
	var accuracy : float
	# modify image to match form
	# update form discovered
	var discovered_forms := PersistentData.get_discovered_forms()
	var discovered_form := discovered_forms.get_item_by_name(item_to_form.name)
	item_to_form.update_img_to_form(discovered_form)
	# compare form to image and determine accuracy
	var form_to_compare : Item = PersistentData.items_inv.get_item_by_name(item_to_form.name)
	accuracy = form_to_compare.compare_form_with(item_to_form)
	# TODO: determine wasted essence (erased pixels)?
	
	# get tier from average tier of materials
	item_to_form.tier = get_avg_tier(used_mats, accuracy)
	# decide grade based on accuracy
	item_to_form.grade = determine_grade(used_mats, item_to_form, accuracy)
	# add item to player inv
	var player_inv : Inventory = PersistentData.game_data.player_storage
	player_inv.add_item(item_to_form, player_inv.items.find(null))
	$FinishedItemScreen.set_data(item_to_form, accuracy)
	$FinishedItemScreen.show()

func get_avg_tier(mats : Array[Item], accuracy : float) -> Item.TIER:
	var avg_tier : Item.TIER
	var tier_count := 0
	for i in mats:
		tier_count += i.tier
	var avg := tier_count / mats.size()
	if accuracy > 0.8:
		avg_tier = ceili(avg) as Item.TIER
	else:
		avg_tier = floori(avg) as Item.TIER
	return avg_tier

func determine_grade(
	used_mats : Array[Item],
	item_to_form : Item,
	accuracy : float
) -> Item.GRADE:
	var grade : Item.GRADE
	var remapped_acc := remap(accuracy, 0, 1, 0, Item.GRADE.values().size()-1)
	if accuracy > 0.8:
		grade = ceili(remapped_acc) as Item.GRADE
	else:
		grade = floori(remapped_acc) as Item.GRADE
	return grade
