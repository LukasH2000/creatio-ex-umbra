# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name InventoryInterface extends Control
# DOCSTRING

# SIGNALS
signal inventory_changed

# ENUMS
enum INV_SOURCE {PLAYER, SHOP_SELLER, SHOP_BUY, SHOP_SELL}

# CONSTANTS
const SLOT_SIZE := Vector2(22+6, 22+6)

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var inventory : Inventory:
	get:
		return inventory
	set(value):
		inventory = value
		#update_inventory()

@export var title : String

@export var inv_source : INV_SOURCE

# PUBLIC VARIABLES
#var items_to_load := [
	#"res://Resources/Items/Weapons/Longsword.tres",
	#"res://Resources/Items/Materials/wood_log.tres"
#]
var grid_size : Vector2 = SLOT_SIZE*10
var stylebox : StyleBoxTexture = load("res://UI/panel_style_slot.tres")
# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	#custom_minimum_size = grid_size
	#$InventoryScroll.custom_minimum_size.y = grid_size.y/2
	#%InventoryGrid.custom_minimum_size = grid_size
	if inventory:
		update_inventory()

func update_inventory() -> void:
	for child in %InventoryGrid.get_children():
		%InventoryGrid.remove_child(child)
		child.queue_free()
	
	if inventory:
		inventory.sort_inventory(inventory.sort_by_tier)
		for i in range(inventory.num_slots):
			var slot := InventorySlot.new(SLOT_SIZE, Item.ITEM_TYPE.MAIN, stylebox, inv_source)
			#var ref_rect := ReferenceRect.new()
			#ref_rect.editor_only = false
			#slot.add_child(ref_rect)
			var item := inventory.items[i]
			if item:
				slot.add_child(InventoryItem.new(item))
			%InventoryGrid.add_child(slot)
			slot.slot_changed.connect(slot_changed)
		#for i in inventory.items:
		
			#var ref_rect := ReferenceRect.new()
			#ref_rect.editor_only = false
			#item.add_child(ref_rect)
			#%InventoryGrid.get_child(i)
		#%InventoryScroll.custom_minimum_size.y = %InventoryScroll/MarginContainer.size.y
	%TitleLabel.text = title
	

func slot_changed(item: Item, slot: InventorySlot):
	#print("from ", old_slot, " to ", new_slot)
	if item:
		inventory.add_item(item, slot.get_index())
	else:
		inventory.remove_item_at(slot.get_index())
		#var inv_item : Node = slot.get
	#inventory.sort_inventory(inventory.sort_by_tier)
	inventory_changed.emit()

func clear_inventory():
	inventory.clear_inventory()
	update_inventory()

# PRIVATE METHODS


# SUBCLASSES


