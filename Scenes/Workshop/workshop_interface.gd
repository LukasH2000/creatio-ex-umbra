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


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
# TODO: disable all buttons except the book button on a new game until the player
# has opened the book
func _on_button_storage_pressed():
	$WorkshopInventory.visible = not $WorkshopInventory.visible
	$WorkshopInventory.set_inventory()

# PRIVATE METHODS


# SUBCLASSES




#func _on_button_book_mouse_entered():
	#$Labels/LabelBook.show()
#
#
#func _on_button_book_mouse_exited():
	#$Labels/LabelBook.hide()
#
#
#func _on_button_storage_room_mouse_entered():
	#$Labels/LabelStorageRoom.show()
#
#
#func _on_button_storage_room_mouse_exited():
	#$Labels/LabelStorageRoom.hide()
#
#
#func _on_button_shadow_canvas_mouse_entered():
	#$Labels/LabelShadowCanvas.show()
#
#
#func _on_button_shadow_canvas_mouse_exited():
	#$Labels/LabelShadowCanvas.hide()
#
#
#func _on_button_outside_mouse_entered():
	#$Labels/LabelOutside.show()
#
#
#func _on_button_outside_mouse_exited():
	#$Labels/LabelOutside.hide()
