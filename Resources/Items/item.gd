# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name Item extends Resource
# DOCSTRING

# SIGNALS


# ENUMS
enum GRADE {F, E, D, C, B, A, S, P}
enum TIER {MORTAL, PEAK_MORTAL, MAGICAL, DRACONIC, DIVINE, IMMORTAL}
enum ITEM_PROPERTY {MATERIAL, EQUIP_HEAD, EQUIP_SHIELD, EQUIP_HILT, EQUIP_GRIP, ACCESSORY_METAL, ACCESSORY_GEM, UTENSIL, ARMOR_PLATE, ARMOR_PADDING, ARMOR_CLOTHING, FURNITURE_WOOD, FURNITURE_METAL, FURNITURE_LEATHER, POTION_INGREDIENT, POTION_BOTTLE, POTION_CORK}
enum MATERIAL_TYPE {WOOD, METAL, LEATHER, STONE, DIRT, BONE, CLOTH, DIAMOND, HERB, FUNGUS, GLASS}
enum ITEM_TYPE {MAIN, ITEM, MATERIAL}
# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var name : String :
	get:
		return name
	set(value):
		name = value
	
@export var tier : TIER :
	get:
		return tier
	set(value):
		tier = value

@export var grade : GRADE :
	get:
		return grade
	set(value):
		grade = value

@export_multiline var description : String :
	get:
		return description
	set(value):
		description = value

@export var gold_value : int :
	get:
		return gold_value
	set(value):
		gold_value = value

@export var image : Image :
	get:
		return image
	set(value):
		image = value

@export var item_components : Array[ITEM_PROPERTY]  :
	get:
		return item_components
	set(value):
		item_components = value

@export var item_type : ITEM_TYPE :
	get:
		return item_type
	set(value):
		item_type = value

@export var transmutable : bool :
	get:
		return transmutable
	set(value):
		transmutable = value

# PUBLIC VARIABLES
var image_texture : ImageTexture
var form : BitMap
var form_texture : ImageTexture
var form_discovered : BitMap

# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
#func _init(p_name = "", p_tier = TIER.MORTAL, p_grade = GRADE.F, p_image = null) -> void:
	#name = p_name
	#tier = p_tier
	#grade = p_grade
	#image = p_image
	#image_texture = ImageTexture.create_from_image(image)
	#form.create_from_image_alpha(image)
	#var form_image := form.convert_to_image()
	#form_texture = ImageTexture.create_from_image(form_image)
func create_image_texture():
	image_texture = ImageTexture.create_from_image(image)

func create_form():
	form = BitMap.new()
	form.create_from_image_alpha(image)
	var form_size := form.get_size()
	for x in range(form_size.x):
		for y in range(form_size.y):
			var inverse := not form.get_bit(x, y)
			form.set_bit(x, y, inverse)

func create_form_texture():
	var form_img := form.convert_to_image()
	form_texture = ImageTexture.create_from_image(form_img)

func create_form_discovered():
	pass

func get_actual_value() -> int:
	var grade_multiplier := grade * 2
	var tier_multiplier := tier * 2
	var actual_value := gold_value
	actual_value += gold_value * tier_multiplier
	actual_value += gold_value * grade_multiplier
	return actual_value

func get_sell_value() -> int:
	return get_actual_value() * (PersistentData.game_data.player_reputation + 1)

func is_same_item(item_to_compare : Item):
	var checks_array := [
		name == item_to_compare.name,
		tier == item_to_compare.tier,
		grade == item_to_compare.grade,
		description == item_to_compare.description,
		gold_value == item_to_compare.gold_value,
		image == item_to_compare.image,
		item_components == item_to_compare.item_components,
		item_type == item_to_compare.item_type,
		transmutable == item_to_compare.transmutable
	]
	return not checks_array.has(false)

# PRIVATE METHODS


# SUBCLASSES


