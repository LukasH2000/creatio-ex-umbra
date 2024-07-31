# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name GameData extends Resource
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
const MAX_REP := 9
const REP_XP_REQ := 5
# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
#@export var current_scene : PackedScene
@export var player_storage : Inventory
@export var player_gold : int
@export var player_reputation : int
@export var player_rep_xp : int
@export var discovered_forms : Inventory
@export var discovered_materials : Array[AlchemyMaterial]

@export var day : int
@export var current_area_name : String

@export var material_store : Inventory
@export var item_store : Inventory
@export var open_orders : Array[Order]

# PUBLIC VARIABLES
static var save_num = 0


# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
# every day, randomize the shop stores
func pass_day():
	day += 1
	randomize_stores()
	for i in range(0, open_orders.size()):
		if open_orders[i]:
			open_orders[i].days_left -= 1
			open_orders[i].update_tooltip()
			if open_orders[i].days_left == 0:
				open_orders[i] = create_random_order()
		else:
			open_orders[i] = create_random_order()
	# TODO: check orders, if order runs out of time
	# make a new, random order

func remove_order(order: Order):
	var i := open_orders.find(order)
	if open_orders[i]:
		open_orders[i] = null

func create_random_order() -> Order:
	var r_order := Order.new()
	# set random time left
	r_order.days_left = randi_range(2, 5)
	# create random items to add to order, amount, tier and grade based off
	# player rep
	for i in range(1, player_reputation+2):
		var random_tier := randi_range(0+player_reputation, player_reputation+1)
		random_tier = clampi(random_tier, 0+player_reputation, Item.TIER.size())
		var random_grade := randi_range(2+player_reputation, player_reputation+3)
		random_grade = clampi(random_grade, 2+player_reputation, Item.GRADE.size())
		var random_item_base = PersistentData.items_inv.items.pick_random()
		var random_item : Item = Item.create_new_item_to_order(
			random_item_base, random_tier, random_grade
		)
		r_order.ordered_items.append(random_item)
		#floori(
			#remap(random_tier, 0, player_reputation+1, 0, Item.TIER.keys().size())
		#)
	r_order.update_tooltip()
	return r_order

func increase_rep(num : int) -> void:
	if player_reputation < MAX_REP:
		player_rep_xp += num
		if player_rep_xp >= get_required_rep_xp_up():
			player_rep_xp = player_rep_xp - get_required_rep_xp_up()
			player_reputation += 1

func get_required_rep_xp_up():
	return REP_XP_REQ * (player_reputation+1)

func randomize_stores():
	randomize_store_inventory(material_store, PersistentData.materials_inv.items)
	randomize_store_inventory(item_store, PersistentData.items_inv.items)

func randomize_orders():
	# TODO: don't limit to 5 orders, currently only for quick time
	for i in 5:
		open_orders.append(create_random_order())
	#randomize_store_inventory(material_store, PersistentData.materials_inv.items)
	#randomize_store_inventory(item_store, PersistentData.items_inv.items)

func randomize_store_inventory(store : Inventory, data_array : Array[Item]):
	# TODO: make weighted randomization
	# so the chance of a high tier or grade
	# appearing is much lower (depending on rep/location)
	store.clear_inventory()
	var random_amount_of_items := randi_range(store.num_slots / 10, store.num_slots / 2)
	for i in random_amount_of_items:
		var item : Item= data_array.pick_random()
		item = item.custom_duplicate()
		item.randomize_item()
		store.add_item(item, i)

#func update_discovered_form(name : String, form : BitMap) -> void:
	#discovered_forms[name] = form

#func get_discovered_form(name: String) -> BitMap:
	#return discovered_forms[name]
#
#func get_discovered_form_texture(name: String) -> ImageTexture:
	#var img : Image = discovered_forms[name].convert_to_image()
	#var texture := ImageTexture.create_from_image(img)
	#return texture
# PRIVATE METHODS


# SUBCLASSES


