# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal selection_cancelled

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
@onready var forms_inv := $"CenterContainer/HBoxContainer/TabContainer/Select Form/Select Form/FormsInventory"
@onready var mats_inv := $"CenterContainer/HBoxContainer/TabContainer/Select Materials/Select Materials/MatsInv"
@onready var mini_canvas := $CenterContainer/HBoxContainer/MiniShadowCanvas
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	if mini_canvas.inventory.count_items() > 0:
		mini_canvas.clear_inventory()
	forms_inv.inventory = PersistentData.game_data.discovered_forms
	forms_inv.update_inventory()
	mats_inv.inventory = PersistentData.game_data.player_storage
	mats_inv.update_inventory()
	

# PRIVATE METHODS


# SUBCLASSES




func _on_button_cancel_pressed():
	#hide()
	#if mini_canvas.inventory.count_items() > 0:
		#mini_canvas.clear_inventory()
	selection_cancelled.emit()
	
