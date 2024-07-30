# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal alch_interface_changed
# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var alch_select_interface_scene := preload("res://UI/AlchemySelection/alchemy_selection_interface.tscn")

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var alch_select_interface := $AlchemySelectionInterface

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
#func _on_button_workshop_mouse_entered():
	#$Labels/LabelWorkshop.show()
#
#
#func _on_button_workshop_mouse_exited():
	#$Labels/LabelWorkshop.hide()

# PRIVATE METHODS


# SUBCLASSES




#func _on_button_shadow_canvas_mouse_entered():
	#$Labels/LabelShadowCanvas.show()
#
#
#func _on_button_shadow_canvas_mouse_exited():
	#$Labels/LabelShadowCanvas.hide()

func show_alch_select_interface():
	alch_select_interface.show()
	alch_interface_changed.emit()
	

func _on_alchemy_selection_interface_selection_cancelled():
	alch_select_interface.hide()
	call_deferred("reset_alch_select_interface")
	

func reset_alch_select_interface():
	new_alch_interface()
	alch_select_interface.hide()
	alch_interface_changed.emit()

func new_alch_interface():
	var new := alch_select_interface_scene.instantiate()
	remove_child(alch_select_interface)
	alch_select_interface.free()
	alch_select_interface = new
	add_child(new)
	alch_select_interface.selection_cancelled.connect(
		_on_alchemy_selection_interface_selection_cancelled
	)
	alch_select_interface.selection_cleared.connect(
		_on_alchemy_selection_interface_selection_cleared
	)

func _on_alchemy_selection_interface_selection_cleared():
	call_deferred("new_alch_interface")
