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


# PRIVATE METHODS


# SUBCLASSES




func _on_button_workshop_mouse_entered():
	$Labels/LabelWorkshop.show()


func _on_button_workshop_mouse_exited():
	$Labels/LabelWorkshop.hide()


func _on_button_merchant_guild_mouse_entered():
	$Labels/LabelMerchantGuild.show()


func _on_button_merchant_guild_mouse_exited():
	$Labels/LabelMerchantGuild.hide()