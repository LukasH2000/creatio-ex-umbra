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
func _ready():
	$Buttons/ButtonItemShop.pressed.connect(
		open_shop.bind(PersistentData.game_data.item_store, "Item shop")
	)
	$Buttons/ButtonMaterialShop.pressed.connect(
		open_shop.bind(PersistentData.game_data.material_store, "Material shop")
	)

func open_shop(seller_inv : Inventory, seller_title : String) -> void:
	$ShopInventory.change_seller(seller_inv, seller_title)
	$ShopInventory.show()

# PRIVATE METHODS


# SUBCLASSES




#func _on_button_outside_mouse_entered():
	#$Labels/LabelOutside.show()
#
#
#func _on_button_outside_mouse_exited():
	#$Labels/LabelOutside.hide()
#
#
#func _on_button_order_board_mouse_entered():
	#$Labels/LabelOrderBoard.show()
#
#
#func _on_button_order_board_mouse_exited():
	#$Labels/LabelOrderBoard.hide()
