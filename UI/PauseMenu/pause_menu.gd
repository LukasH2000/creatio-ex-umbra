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
var gold : int
var rep : int
var rep_xp : int
var max_rep_xp : int
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var lbl_gold := $CenterContainer/PanelContainer/VBoxContainer/LabelGold
@onready var lbl_rep := $CenterContainer/PanelContainer/VBoxContainer/LabelRep
@onready var lbl_rep_xp := $CenterContainer/PanelContainer/VBoxContainer/LabelRepXp

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	lbl_gold.text = "Gold: %s" % gold
	lbl_rep.text = "Reputation: %s" % rep
	lbl_rep_xp.text = "Reputation XP: %s/%s" % [rep_xp, max_rep_xp]

# PRIVATE METHODS


# SUBCLASSES




func _on_visibility_changed():
	if visible:
		PersistentData.hide_pause_menu_button()
	else:
		PersistentData.show_pause_menu_button()
