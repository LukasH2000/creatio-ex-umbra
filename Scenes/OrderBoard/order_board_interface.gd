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
@onready var orders := [
	$Orders/Order1,
	$Orders/Order2,
	$Orders/Order3,
	$Orders/Order4,
	$Orders/Order5
]
@onready var turn_in_interface := $OrderTurnInInterface
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	for i in range(0, orders.size()):
		orders[i].set_order(PersistentData.game_data.open_orders[i])
		orders[i].order_opened.connect(_on_order_open_pressed)

func on_order_completed(order):
	for i in range(0, orders.size()):
		if orders[i].order == order:
			orders[i].hide()

func _on_order_open_pressed(order):
	turn_in_interface.set_order(order)
	turn_in_interface.show()
# PRIVATE METHODS


# SUBCLASSES




#func _on_button_merchant_guild_mouse_entered():
	#$Labels/LabelMerchantGuild.show()
#
#
#func _on_button_merchant_guild_mouse_exited():
	#$Labels/LabelMerchantGuild.hide()
