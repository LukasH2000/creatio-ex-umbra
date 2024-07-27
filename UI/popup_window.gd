# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name PopupWindow extends Control
# DOCSTRING

# SIGNALS
signal popup_finished

# ENUMS
enum TYPE {SPLIT_STACK, ERR_SLOTS, ERR_GOLD}

# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var popup_type : TYPE

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var title : Label = $PopupWindow/PopupPanel/VBoxContainer/PopupTitle
@onready var text : Label = $PopupWindow/PopupPanel/VBoxContainer/PopupText
@onready var spinbox : SpinBox = $PopupWindow/PopupPanel/VBoxContainer/SpinBox
@onready var button : Button = $PopupWindow/PopupPanel/VBoxContainer/Button
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func close_popup():
	if popup_type == TYPE.SPLIT_STACK:
		popup_finished.emit(spinbox.value)
	hide()


func show_popup(type : TYPE, alch_mat : AlchemyMaterial = null) -> void:
	popup_type = type
	if type == TYPE.SPLIT_STACK:
		title.text = "Select amount"
		text.hide()
		spinbox.show()
		spinbox.value = 0
		spinbox.max_value = alch_mat.amount_held
		button.text = "Select"
	if type == TYPE.ERR_GOLD:
		title.text = "Not enough gold!"
		text.show()
		text.text = "You don't have enough gold to complete the transaction!"
		spinbox.hide()
		button.text = "Close"
	if type == TYPE.ERR_SLOTS:
		title.text = "Not enough space!"
		text.show()
		text.text = "You don't have enough inventory space to complete the transaction!"
		spinbox.hide()
		button.text = "Close"
	show()

# PRIVATE METHODS


# SUBCLASSES





