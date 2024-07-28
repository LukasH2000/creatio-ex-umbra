# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name PopupWindow extends Control
# DOCSTRING

# SIGNALS
signal popup_finished

# ENUMS
enum TYPE {SPLIT_STACK, ERR_SLOTS, ERR_GOLD, ERR_ALCH_SELECT, FINISH_ITEM}

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
@onready var button_ok : Button = $PopupWindow/PopupPanel/VBoxContainer/HBoxContainer/Button2
@onready var button_cancel : Button = $PopupWindow/PopupPanel/VBoxContainer/HBoxContainer/Button
@onready var pu_win_container : CenterContainer = $PopupWindow
@onready var pu_win : PanelContainer = $PopupWindow/PopupPanel
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func close_popup(cancel : bool = false):
	if popup_type == TYPE.SPLIT_STACK:
		popup_finished.emit(spinbox.value)
	if popup_type == TYPE.FINISH_ITEM:
		popup_finished.emit(cancel)
	hide()


func show_popup(type : TYPE, alch_mat : AlchemyMaterial = null) -> void:
	popup_type = type
	if type == TYPE.SPLIT_STACK:
		title.text = "Select amount"
		text.hide()
		spinbox.show()
		spinbox.value = 0
		spinbox.max_value = alch_mat.amount_held
		button_ok.text = "Select"
		button_cancel.hide()
		pu_win.custom_minimum_size = Vector2.ZERO
		pu_win.size.x = 93
	else:
		pu_win.custom_minimum_size.x = 93*2
		pu_win.size.x = pu_win.custom_minimum_size.x
	if type == TYPE.ERR_GOLD:
		title.text = "Not enough gold!"
		text.show()
		text.text = "You don't have enough gold to complete the transaction!"
		spinbox.hide()
		button_ok.text = "Close"
		button_cancel.hide()
	if type == TYPE.ERR_SLOTS:
		title.text = "Not enough space!"
		text.show()
		text.text = "You don't have enough inventory space to complete the transaction!"
		spinbox.hide()
		button_ok.text = "Close"
		button_cancel.hide()
	if type == TYPE.ERR_ALCH_SELECT:
		title.text = "Select Form and materials!"
		text.show()
		text.text = "You cannot start transmuting an item without a form and at least 1 material!"
		spinbox.hide()
		button_ok.text = "Close"
		button_cancel.hide()
	if type == TYPE.FINISH_ITEM:
		title.text = "Confirm finish item"
		text.show()
		text.text = "Are you sure you want to finish creating this item?"
		spinbox.hide()
		button_ok.text = "Yes"
		button_cancel.show()
		button_cancel.text = "No"
	show()

# PRIVATE METHODS


# SUBCLASSES





