# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS


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
@onready var texture_rect := $CenterContainer/HBoxContainer/ItemImageContainer/TextureRect
@onready var name_lbl := $CenterContainer/HBoxContainer/PanelItemStats/VBoxContainer/LabelItem
@onready var acc_lbl := $CenterContainer/HBoxContainer/PanelItemStats/VBoxContainer/LabelAccuracy
@onready var tier_lbl := $CenterContainer/HBoxContainer/PanelItemStats/VBoxContainer/LabelTier
@onready var grade_lbl := $CenterContainer/HBoxContainer/PanelItemStats/VBoxContainer/LabelGrade
@onready var debug_rect := $CenterContainer/HBoxContainer/ItemImageContainer2/DebugRect
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
# TODO: infuse leftover shadow essence into item, making it higher grade,
# though too much will instead lower the grade.
# NOTE: maybe only infuse partially used items? If an item has lost essence, it
# gets removed from the player inv anyways, so it's either wasted or infused
# 
# TODO: figure out other things that can influence the grade
# TODO: in the future you could determine what the item is through comparing the
# drawn item to all item forms and selecting the item with the highest accuracy,
# maybe only if it also fully contains the default discovered form?
func set_data(item : Item, acc : float):
	texture_rect.texture = item.get_image_texture() # item.get_form_texture()# 
	name_lbl.text = item.name
	acc_lbl.text = "%.2f%%" % (acc*100)
	tier_lbl.text = "[center]" + InventoryItem.ITEM_TIERS[item.tier] + "[/center]"
	grade_lbl.text = InventoryItem.ITEM_GRADES[item.grade]
	#debug_rect.texture = item.get_form_discovered_texture()
# PRIVATE METHODS


# SUBCLASSES


