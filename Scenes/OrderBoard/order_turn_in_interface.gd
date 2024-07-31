# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal order_completed

# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var order : Order

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var player_inv := $MarginContainer/HBoxContainer/InventoryInterface
@onready var label := $MarginContainer/HBoxContainer/VBoxContainer/RichTextLabel
@onready var turn_in_inv := $MarginContainer/HBoxContainer/InventoryInterface2
@onready var btn_turn_in := $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ButtonTurnIn
@onready var btn_cancel := $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ButtonCancel
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	player_inv.inventory = PersistentData.game_data.player_storage
	player_inv.update_inventory()

func set_order(ord : Order):
	order = ord
	update_label()
	turn_in_inv.clear_inventory()
	#turn_in_inv.update_inventory()

func update_label():
	#label.text = "[center]Items to turn in:\n"
	#label.text += order.get_ordered_items_text()
	#label.text += "[/center]"
	label.text = "[center]"
	label.text += order.tooltip_text
	label.text += "[/center]"

func _on_inventory_interface_2_inventory_changed():
	var selected_items : Array[Item] = turn_in_inv.inventory.get_items_no_nulls()
	if order.check_items(selected_items):
		btn_turn_in.disabled = false
		btn_turn_in.tooltip_text = ""
	else:
		btn_turn_in.disabled = true
		btn_turn_in.tooltip_text = "Selected items do not qualify!"
	player_inv.update_inventory()
# PRIVATE METHODS


# SUBCLASSES

func _on_button_turn_in_pressed():
	#print("before turn in")
	#print("gold: ", PersistentData.game_data.player_gold)
	#print("rep xp: ", PersistentData.game_data.player_rep_xp)
	#print("rep: ", PersistentData.game_data.player_reputation)
	var selected_items : Array[Item] = turn_in_inv.inventory.get_items_no_nulls()
	PersistentData.game_data.player_gold += order.get_payment(selected_items)
	PersistentData.game_data.increase_rep(order.get_rep_xp())
	#print("after turn in")
	#print("gold: ", PersistentData.game_data.player_gold)
	#print("rep xp: ", PersistentData.game_data.player_rep_xp)
	#print("rep: ", PersistentData.game_data.player_reputation)
	#turn_in_inv.inventory.add_items_to_inv(player_inv)
	turn_in_inv.clear_inventory()
	visible = false
	PersistentData.play_coins_sound()
	PersistentData.game_data.remove_order(order)
	order_completed.emit(order)


func _on_button_cancel_pressed():
	turn_in_inv.inventory.add_items_to_inv(PersistentData.game_data.player_storage)
	turn_in_inv.clear_inventory()
	#turn_in_inv.update_inventory()
	player_inv.update_inventory()
	visible = false


func _on_visibility_changed():
	if visible:
		PersistentData.hide_pause_menu_button()
	else:
		PersistentData.show_pause_menu_button()
