# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends InventoryInterface
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
var inv_slot_script_path := "res://UI/Inventory/inventory_slot.gd"
var mat_slot_size := Vector2i(16,16)
var form_slot_size := Vector2i(101,101)
var slot_positions := [
	Vector2(-7, -104.5),
	Vector2(57, -77.5),
	Vector2(84, -12.5),
	Vector2(57, 50.5),
	Vector2(-7, 77.5),
	Vector2(-72, 51),
	Vector2(-99, -12.5),
	Vector2(-72, -77.5),
	Vector2(-50, -55.5)
]
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var title_label := $VBoxContainer/TitleLabel
#@onready var mat_slots : Array[Node] = [
	#$Control/MatSlot1,
	#$Control/MatSlot2,
	#$Control/MatSlot3,
	#$Control/MatSlot4,
	#$Control/MatSlot5,
	#$Control/MatSlot6,
	#$Control/MatSlot7,
	#$Control/MatSlot8
#]
#@onready var form_slot : Node = $Control/FormSlot
@onready var slots : Node = $Slots

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	#custom_minimum_size = grid_size
	#$InventoryScroll.custom_minimum_size.y = grid_size.y/2
	#%InventoryGrid.custom_minimum_size = grid_size
	#if inv_source == INV_SOURCE.CANVAS_FORMS:
		#
	#or inv_source == INV_SOURCE.CANVAS_MATERIALS \
	#or inv_source == INV_SOURCE.CANVAS:
		#
	if inventory:
		update_inventory()

func update_inventory() -> void:
	for child in slots.get_children():
		slots.remove_child(child)
		child.queue_free()
	if inventory:
		for i in range(0, 9):
			var slot_size : Vector2i
			var src := INV_SOURCE.CANVAS_MATERIALS
			if i < 8:
				slot_size = mat_slot_size
				#slots_type = Item.ITEM_TYPE.MATERIAL
			else:
				slot_size = form_slot_size
				src = INV_SOURCE.CANVAS
				
			var slot := InventorySlot.new(slot_size, slots_type, stylebox, src)
			slot.set_anchors_and_offsets_preset(Control.PRESET_CENTER) 
			#slot.anchors_preset
			#var ref_rect := ReferenceRect.new()
			#ref_rect.editor_only = false
			#slot.add_child(ref_rect)
			var item := inventory.items[i]
			if item:
				slot.add_child(InventoryItem.new(item, src))
			if i < 8:
				slot.add_theme_stylebox_override("panel", load("res://UI/AlchemySelection/mat_selection_style.tres"))
			else:
				slot.add_theme_stylebox_override("panel", load("res://UI/AlchemySelection/form_selection_style.tres"))
			slots.add_child(slot)
			slot.position = slot_positions[i]
			slot.slot_changed.connect(slot_changed)
		#for n in mat_slots:
			#n.set_script(load(inv_slot_script_path))
			#n.slot_source_type = inv_source
			#n.slot_item_type = slots_type
		#form_slot.set_script(load(inv_slot_script_path))
		#form_slot.slot_source_type = inv_source
		#form_slot.slot_item_type = slots_type
		##inventory.sort_inventory(inventory.sort_by_tier)
		#for i in range(inventory.num_slots):
			#var slot := InventorySlot.new(SLOT_SIZE, Item.ITEM_TYPE.MAIN, stylebox, inv_source)
			##var ref_rect := ReferenceRect.new()
			##ref_rect.editor_only = false
			##slot.add_child(ref_rect)
			#var item := inventory.items[i]
			#if item:
				#slot.add_child(InventoryItem.new(item))
			#%InventoryGrid.add_child(slot)
			#slot.slot_changed.connect(slot_changed)
		#for i in inventory.items:
		
			#var ref_rect := ReferenceRect.new()
			#ref_rect.editor_only = false
			#item.add_child(ref_rect)
			#%InventoryGrid.get_child(i)
		#%InventoryScroll.custom_minimum_size.y = %InventoryScroll/MarginContainer.size.y
	if title != null and title != "":
		title_label.text = title
	else: 
		title_label.text = ""

func slot_changed(item: Item, slot: InventorySlot):
	#print("from ", old_slot, " to ", new_slot)
	if item:
		inventory.add_item(item, slot.get_index())
	else:
		inventory.remove_item_at(slot.get_index())
		#var inv_item : Node = slot.get
	#inventory.sort_inventory(inventory.sort_by_tier)
	inventory_changed.emit()

func add_items_to_inv(inv : Inventory):
	# Don't add the item that represents the form
	for i in range(0, inventory.items.size() - 1):
		if inventory.items[i]:
			var added := false
			for j in inv.items:
				if j:
					if inventory.items[i].is_same_item(j):
						j.amount_held += inventory.items[i].amount_held
						added = true
						break
			if not added:
				inv.add_item(inventory.items[i], inv.items.find(null))

func clear_inventory():
	add_items_to_inv(PersistentData.game_data.player_storage)
	inventory.clear_inventory()
	update_inventory()

func _on_button_start_alchemy_pressed():
	var path = PersistentData.area_scene_paths["Shadow Canvas"]
	if inventory.count_items() >= 2 and inventory.items[-1] != null:
		PersistentData.goto_scene(path, inventory)
	else:
		PersistentData.get_popup_window().show_popup(PopupWindow.TYPE.ERR_ALCH_SELECT)
# PRIVATE METHODS


# SUBCLASSES





