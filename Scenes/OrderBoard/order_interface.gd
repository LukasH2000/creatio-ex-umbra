# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends VBoxContainer
# DOCSTRING

# SIGNALS
signal order_opened

# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var order : Order
var label_scene := preload("res://UI/Inventory/item_tooltip.tscn")
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var textr_rect := $TextureRect
@onready var btn := $Button
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	if order:
		tooltip_text = order.get_tooltip_text()
	else:
		hide()
	btn.pressed.connect(emit_order)

func emit_order():
	order_opened.emit(order)

func set_order(_o):
	order = _o
	if order:
		tooltip_text = order.get_tooltip_text()
		show()
	else:
		hide()

func _make_custom_tooltip(for_text):
	#var label := RichTextLabel.new()
	var label := label_scene.instantiate()
	#label.bbcode_enabled = true
	#label.visible = true
	#label.add_theme_font_size_override("normal_font_size", 12)
	#label.text = for_text
	label.text = for_text
	#label.fit_content = true
	label.custom_minimum_size = Vector2(128,1)
	#label.mouse_force_pass_scroll_events = false
	return label

# PRIVATE METHODS


# SUBCLASSES


