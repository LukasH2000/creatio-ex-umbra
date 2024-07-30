# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name GameData extends Resource
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
#@export var current_scene : PackedScene
@export var player_storage : Inventory
@export var player_gold : int
@export var player_reputation : int
@export var discovered_forms : Inventory
@export var discovered_materials : Array[AlchemyMaterial]

@export var day : int
@export var current_area_name : String

@export var material_store : Inventory
@export var item_store : Inventory
#@export var open_orders : ???

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

func randomize_stores():
	randomize_store_inventory(material_store, PersistentData.materials_inv.items)
	randomize_store_inventory(item_store, PersistentData.items_inv.items)

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


