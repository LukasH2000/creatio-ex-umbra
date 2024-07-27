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
enum ITEM_TYPE {MAIN, ITEM, MATERIAL, FORM}
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

@export var default_discovered_form_image : Image :
	get:
		return default_discovered_form_image
	set(value):
		default_discovered_form_image = value

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
var form_img : Image
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
	form = invert_bitmap(form)

func get_form():
	if not form:
		create_form()
	return form

func invert_bitmap(bitmap : BitMap) -> BitMap:
	var bitmap_size := bitmap.get_size()
	var inverted := bitmap
	for x in range(bitmap_size.x):
		for y in range(bitmap_size.y):
			var inverse := not bitmap.get_bit(x, y)
			inverted.set_bit(x, y, inverse)
	return inverted

func get_form_image():
	if not form_img:
		form_img = get_form().convert_to_image()
	return form_img

func create_form_texture():
	form_texture = ImageTexture.create_from_image(get_form_image())

func create_form_discovered():
	if default_discovered_form_image:
		form_discovered = BitMap.new()
		form_discovered.create_from_image_alpha(default_discovered_form_image)
		form_discovered = invert_bitmap(form_discovered)

func get_form_discovered_texture():
	var discovered_img := form_discovered.convert_to_image()
	if not form_texture:
		form_texture = ImageTexture.create_from_image(discovered_img)
	else:
		form_texture.update(discovered_img)
	return form_texture

func update_form_discovered(updated_form : BitMap):
	form_discovered = updated_form
	create_form_texture()

func get_actual_value() -> int:
	var tier_multiplier := (tier+1) ** 2 # if tier > 0 else 0
	var grade_multiplier := (grade+1) * tier_multiplier
	var actual_value := gold_value * grade_multiplier
	#actual_value += gold_value * tier_multiplier
	#actual_value += gold_value * grade_multiplier
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
		default_discovered_form_image == item_to_compare.default_discovered_form_image,
		item_components == item_to_compare.item_components,
		item_type == item_to_compare.item_type,
		transmutable == item_to_compare.transmutable
	]
	return not checks_array.has(false)

func custom_duplicate() -> Item:
	var dupe := Item.new()
	return set_dupe_props(dupe)

func set_dupe_props(dupe : Item):
	dupe.name = name
	dupe.tier = tier
	dupe.grade = grade
	dupe.description = description
	dupe.gold_value = gold_value
	dupe.image = image
	dupe.default_discovered_form_image = default_discovered_form_image
	dupe.item_components = item_components
	dupe.item_type = item_type
	dupe.transmutable = transmutable
	dupe.image_texture = image_texture
	dupe.form = form
	dupe.form_texture = form_texture
	dupe.form_discovered = form_discovered
	return dupe

func randomize_item():
	#print(TIER[TIER.keys().pick_random()])
	tier = TIER[TIER.keys().pick_random()]
	grade = GRADE[GRADE.keys().pick_random()]

# PRIVATE METHODS


# SUBCLASSES


