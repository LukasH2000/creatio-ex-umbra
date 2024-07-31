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

@export var recipe_items : Array[Item]  :
	get:
		return recipe_items
	set(value):
		recipe_items = value
		#for i in recipe_items:
			#if not i.name in recipe_names:
				#recipe_names.append(i.name)

# PUBLIC VARIABLES
var image_texture : ImageTexture
var form : BitMap
var form_img : Image
var form_texture : ImageTexture
var form_discovered_texture : ImageTexture
var form_discovered : BitMap
#var recipe_names : Array[String]

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
static func create_new_item_to_order(item, tier, grade):
	var new : Item= item.custom_duplicate()
	new.tier = tier as Item.TIER
	new.grade = grade as Item.GRADE
	return new

func create_image_texture():
	image_texture = ImageTexture.create_from_image(image)

func get_image_texture():
	if not image_texture:
		create_image_texture()
	return image_texture

func create_form():
	form = BitMap.new()
	form.create_from_image_alpha(image)
	form = invert_bitmap(form)

func get_form():
	if not form:
		create_form()
	return form

static func invert_bitmap(bitmap : BitMap) -> BitMap:
	var bitmap_size := bitmap.get_size()
	# ALERT: since this is a reference (I think), it also changes the original
	# INFO: use duplicate to prevent this (I think)
	var inverted := bitmap.duplicate()
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

func get_form_texture():
	if not form_texture:
		create_form_texture()
	return form_texture

# TEST
func get_updated_form_texture():
	form_img = get_form().convert_to_image()
	form_texture = ImageTexture.create_from_image(get_form_image())
	return form_texture

func create_form_discovered():
	if default_discovered_form_image:
		form_discovered = BitMap.new()
		form_discovered.create_from_image_alpha(default_discovered_form_image)
		form_discovered = invert_bitmap(form_discovered)
		#print_form(form_discovered)

#func print_form(form):
	#var bool_arr := []
	#for y in range(form.get_size().y):
		#for x in range(form.get_size().x):
			#bool_arr.append(form.get_bit(x, y))
		#print(bool_arr)
		#bool_arr.clear()
			

func get_form_discovered():
	if not form_discovered:
		create_form_discovered()
	return form_discovered

func get_form_discovered_inverted():
	if not form_discovered:
		create_form_discovered()
	return invert_bitmap(form_discovered) # inverts form_discovered permanently

func get_form_discovered_texture():
	var discovered_img : Image = get_form_discovered().convert_to_image()
	if not form_discovered_texture:
		form_discovered_texture = ImageTexture.create_from_image(discovered_img)
	else:
		form_discovered_texture.update(discovered_img)
	return form_discovered_texture

func reduce_form_by(pixel_num : int) -> void:
	if form:
		var rect := Rect2i(Vector2.ZERO, form.get_size())
		#form.grow_mask(pixel_num/pixel_num, rect)
		# since material bitmaps are inverted to create a black texture with a
		# white background (for some reason convert_to_image make true bits
		# white and false bits black), we need to flip the false bits to true 
		# to erase pixels from the material
		bitmap_remove_px(form, pixel_num, false)
		#print(form.get_size())
		form_img = form.convert_to_image()

func bitmap_remove_px(bm: BitMap, pixel_num : int, bool_to_flip : bool) -> void:
	var size := form.get_size()
	var changed_count := 0
	for x in range(0, size.x):
		for y in range(0, size.y):
			if bm.get_bit(x, y) == bool_to_flip:
				bm.set_bit(x, y, not bool_to_flip)
				changed_count += 1
				if changed_count == pixel_num:
					return

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
	var rep : int = PersistentData.game_data.player_reputation + 1
	var val : float = (get_actual_value() * rep) / PersistentData.REP_THRESHOLD 
	return ceili(val)

func is_same_item(item_to_compare : Item) -> bool:
	var checks_array := [
		name == item_to_compare.name,
		tier == item_to_compare.tier,
		grade == item_to_compare.grade,
		description == item_to_compare.description,
		gold_value == item_to_compare.gold_value,
		#image == item_to_compare.image,
		#default_discovered_form_image == item_to_compare.default_discovered_form_image,
		item_components == item_to_compare.item_components,
		item_type == item_to_compare.item_type,
		transmutable == item_to_compare.transmutable,
		recipe_items == item_to_compare.recipe_items
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
	dupe.image = image.duplicate(true)
	dupe.default_discovered_form_image = default_discovered_form_image
	dupe.item_components = item_components
	dupe.item_type = item_type
	dupe.transmutable = transmutable
	dupe.recipe_items = recipe_items.duplicate(true)
	#dupe.recipe_names = recipe_names.duplicate(true)
	if image_texture:
		dupe.image_texture = image_texture.duplicate(true)
	if form:
		dupe.form = form.duplicate(true)
	if form_texture:
		dupe.form_texture = form_texture.duplicate(true)
	if form_discovered:
		dupe.form_discovered = form_discovered.duplicate(true)
	return dupe

func randomize_item():
	#print(TIER[TIER.keys().pick_random()])
	tier = TIER[TIER.keys().pick_random()]
	grade = GRADE[GRADE.keys().pick_random()]

# ALERT: always returns 100% or 0% accuracy for some reason
# NOTE: it works now after using total_item_bits instead of total_bits
# and adding bit_to_compare == false to if statement
# ALERT: doesnt fully work actually, you get accuracy once and then it seems to stay the same
# NOTE: it was borked because I treated it as if I called this on the player-
# created item with the correct form is the var in some areas, but I do
# form_to_compare.compare_form_with(item_to_form) instead
# Should probably change that around so it's the same as update_img_to_form
# where the persistend item get passed as a var to the func
# TODO: make this return a Vector2 with the accuracy (pixels correctly inside
# form and wasted essence (pixels outside actual form)
func compare_form_with(item : Item) -> float:
	var accuracy := 0.0
	var form_size := form.get_size()
	var form_to_compare : BitMap= item.get_form_discovered()
	var total_bits : float = form_size.x * form_size.y
	var total_item_bits : float = total_bits - form.get_true_bit_count()
	var correct_bits := 0.0
	for x in range(form_size.x):
		for y in range(form_size.y):
			var bit := form.get_bit(x, y)
			var bit_to_compare := form_to_compare.get_bit(x, y)
			if bit == false and bit == bit_to_compare:
				correct_bits += 1
				#print(Vector2(x, y))
	accuracy = correct_bits / total_item_bits
	return accuracy

# ALERT: doesn't work currently
# NOTE:  it works now after using the correct form and setting it with
# canvas.get_drawing()
func update_img_to_form(game_data_form : Item):
	var form_size := form_discovered.get_size()
	var form_discovered_gd : BitMap = game_data_form.get_form_discovered()
	#form_discovered = invert_bitmap(form_discovered)
	for x in range(form_size.x):
		for y in range(form_size.y):
			var bit := form_discovered.get_bit(x, y)
			var bit_to_compare := game_data_form.get_form().get_bit(x, y)
			if bit == bit_to_compare and bit == false:
				form_discovered_gd.set_bit(x, y, bit)
			if bit != bit_to_compare:
				image.set_pixel(x, y, Color(Color.TRANSPARENT))
			# see if it's correct to game data form
			# if yes, set 

func is_recipe_correct(recipe : Array[Item]):
	var len := recipe.size()
	var correct := false
	if recipe_items.size() == len:
		correct = true
		for i in range(0, len):
			if recipe[i].name != recipe_items[i].name:
				correct = false
	return correct

func qualifies_as(ordered_item : Item):
	if name == ordered_item.name:
		if tier >= ordered_item.tier:
			if grade >= ordered_item.grade:
				return true
	return false
# PRIVATE METHODS


# SUBCLASSES


