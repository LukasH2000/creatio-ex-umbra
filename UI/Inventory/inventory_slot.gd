# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name InventorySlot extends PanelContainer
# DOCSTRING

# SIGNALS
signal slot_changed(item: Item, slot: InventorySlot)

# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var slot_item_type : Item.ITEM_TYPE
@export var slot_source_type : InventoryInterface.INV_SOURCE
# PUBLIC VARIABLES

# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _init(cms : Vector2, type : Item.ITEM_TYPE, stylebox : StyleBox, inv_src : InventoryInterface.INV_SOURCE) -> void:
	custom_minimum_size = cms
	slot_item_type = type
	slot_source_type = inv_src
	theme = load(PersistentData.THEME_PATH)
	add_theme_stylebox_override("panel", stylebox)

func _can_drop_data(at_position : Vector2, data : Variant) -> bool:
	if data is InventoryItem:
		var data_parent : Variant = data.get_parent()
		if compatible_inv(data_parent.slot_source_type):
			if slot_item_type == Item.ITEM_TYPE.MAIN:
				# TODO: allow dropping onto item stack if it's the same item
				if get_child_count() > 0:
					pass
					# ALERT: ALL SLOTS HAVE SLOT_ITEM_TYPE = MAIN, ALWAYS FALSE
					#if slot_item_type != data_parent.slot_item_type:
					#return get_child(0).item.item_type == data.item.item_type
				else: 
					return true
			else:
				# ALERT: ALL SLOTS HAVE SLOT_ITEM_TYPE = MAIN, BE CAREFUL
				return data.item.item_type == slot_item_type
	return false

func compatible_inv(data_src : InventoryInterface.INV_SOURCE) -> bool:
	var sources = InventoryInterface.INV_SOURCE
	if slot_source_type == data_src and data_src == sources.PLAYER:
		return true
	if slot_source_type != data_src:
		if slot_source_type == sources.PLAYER and data_src == sources.SHOP_SELL:
			return true
		if slot_source_type == sources.SHOP_SELL and data_src == sources.PLAYER:
			return true
		if slot_source_type == sources.SHOP_SELLER and data_src == sources.SHOP_BUY:
			return true
		if slot_source_type == sources.SHOP_BUY and data_src == sources.SHOP_SELLER:
			return true
	return false

func _drop_data(at_position, data):
	var data_slot : Node = data.get_parent()
	var data_slot_changed := false
	var is_not_zero := true
	if data_slot.slot_source_type != slot_source_type:
		if data.item.item_type == Item.ITEM_TYPE.MATERIAL:
			var popup_window : Node = PersistentData.get_popup_window()
			popup_window.show_popup(PopupWindow.TYPE.SPLIT_STACK, data.item)
			var selected_value : int = await popup_window.popup_finished
			if selected_value > 0 :
				if selected_value < data.item.amount_held:
					# ALERT: duplicate does not dupe script or properties
					# var data_duplicate : Node = data.duplicate()
					var old_item : Item = data.item
					var new_item : Item = old_item.custom_duplicate()
					var data_duplicate : Node = InventoryItem.new(new_item)
					
					data_duplicate.item.amount_held = data.item.amount_held - selected_value
					data.item.amount_held = selected_value
					data_duplicate.update_tooltip_and_label()
					data.update_tooltip_and_label()
					data_slot.add_child(data_duplicate)
					data_slot.slot_changed.emit(data_duplicate.item, data_slot)
					data_slot_changed = true
			else:
				is_not_zero = false
	# TODO: allow dropping onto item stack if it's the same item
	if is_not_zero:
		if get_child_count() > 0:
			var inv_item := get_child(0)
			if inv_item == data:
				return
			inv_item.reparent(data_slot)
			data_slot.slot_changed.emit(inv_item.item, data_slot)
			data_slot_changed = true
		elif not data_slot_changed:
			data_slot.slot_changed.emit(null, data_slot)
			data_slot_changed = true
		data.reparent(self)
		slot_changed.emit(data.item, self)
# PRIVATE METHODS


# SUBCLASSES
