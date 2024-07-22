# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node
# DOCSTRING

# SIGNALS
#signal area_changed(next_area : PackedScene)

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
#func _ready():
	#var buttons := get_tree().get_nodes_in_group("area_change_buttons")
	#for button in buttons:
		#button.pressed.connect(emit_area_change.bind(button.next_area))
	#
#func emit_area_change(next_area : PackedScene) -> void:
	#area_changed.emit(next_area)

# PRIVATE METHODS


# SUBCLASSES


