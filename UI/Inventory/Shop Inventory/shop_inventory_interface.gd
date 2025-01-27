# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS


# ENUMS
enum TRANSACTION_RESULT {OK, NOT_ENOUGH_SLOTS, NOT_ENOUGH_GOLD}

# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var trade_value = 0
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var label_gold : Label = %LabelGold
@onready var label_trade_val : Label = %LabelTradeValue
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	%BuyInv.inventory_changed.connect(
		update_trade_value
	)
	%SellInv.inventory_changed.connect(
		update_trade_value
	)

func _on_button_end_transaction_pressed():
	var transaction_result := check_transaction()
	if transaction_result == TRANSACTION_RESULT.OK:
		var buyer_inv : Inventory = PersistentData.game_data.player_storage
		var seller_inv: Inventory = %ShopInv.inventory
		%BuyInv.inventory.add_items_to_inv(buyer_inv)
		%SellInv.inventory.add_items_to_inv(seller_inv)
		#for i in %BuyInv.inventory.items:
			#if i:
				#var next_available_slot := buyer_inv.find(null)
				#buyer_inv[next_available_slot] = i
			## TODO: make split materials add to first available stack
			# NOTE: Done i think
		#for i in %SellInv.inventory.items:
			#if i:
				#var next_available_slot := seller_inv.find(null)
				#seller_inv[next_available_slot] = i
		PersistentData.game_data.player_gold += trade_value
		%BuyInv.clear_inventory()
		%SellInv.clear_inventory()
		visible = false
		PersistentData.play_coins_sound()
	elif transaction_result == TRANSACTION_RESULT.NOT_ENOUGH_SLOTS:
		PersistentData.get_popup_window().show_popup(PopupWindow.TYPE.ERR_SLOTS)
	elif transaction_result == TRANSACTION_RESULT.NOT_ENOUGH_GOLD:
		PersistentData.get_popup_window().show_popup(PopupWindow.TYPE.ERR_GOLD)

func check_transaction() -> TRANSACTION_RESULT:
	if trade_value < 0 and PersistentData.game_data.player_gold < -trade_value:
		return TRANSACTION_RESULT.NOT_ENOUGH_GOLD
	var player_storage : Inventory = PersistentData.game_data.player_storage
	var remaining_slots : int = player_storage.num_slots - player_storage.count_items()
	if remaining_slots < %BuyInv.inventory.count_items():
		return TRANSACTION_RESULT.NOT_ENOUGH_SLOTS
	return TRANSACTION_RESULT.OK

func change_seller(seller_inventory : Inventory, seller_title : String) -> void:
	label_gold.text = "gold: %s" % PersistentData.game_data.player_gold
	trade_value = 0
	label_trade_val.text = "trade: +%s" % trade_value
	%PlayerInv.inventory = PersistentData.game_data.player_storage
	%PlayerInv.update_inventory()
	%ShopInv.title = seller_title
	%ShopInv.inventory = seller_inventory
	%ShopInv.update_inventory()

func update_trade_value():
	var buy_val : int = -%BuyInv.inventory.get_total_value(true)
	var sell_val : int = %SellInv.inventory.get_total_value(false)
	#print("val: ", val)
	trade_value = buy_val + sell_val
	var val_sign := "+" if trade_value >=0 else ""
	label_trade_val.text = "trade: %s%s" % [val_sign, trade_value]

# PRIVATE METHODS


# SUBCLASSES




func _on_button_cancel_pressed():
	%BuyInv.inventory.add_items_to_inv(%ShopInv.inventory)
	%SellInv.inventory.add_items_to_inv(PersistentData.game_data.player_storage)
	%BuyInv.inventory.clear_inventory()
	%SellInv.inventory.clear_inventory()
	%BuyInv.update_inventory()
	%SellInv.update_inventory()
	visible = false


func _on_visibility_changed():
	if visible:
		PersistentData.hide_pause_menu_button()
	else:
		PersistentData.show_pause_menu_button()
