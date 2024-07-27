# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name AlchemyMaterial extends Item
# DOCSTRING

# SIGNALS


# ENUMS

# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var mat_type : MATERIAL_TYPE  :
	get:
		return mat_type
	set(value):
		mat_type = value

@export var mat_uses : Array[ITEM_PROPERTY]  :
	get:
		return mat_uses
	set(value):
		mat_uses = value

@export_range(1, 999) var amount_held : int = 1 :
	get:
		return amount_held
	set(value):
		amount_held = value

# PUBLIC VARIABLES


# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func is_same_material(material_to_compare : AlchemyMaterial) -> bool:
	if is_same_item(material_to_compare):
		if mat_type == material_to_compare.mat_type:
			if mat_uses == material_to_compare.mat_uses:
				return true
	return false

func custom_duplicate() -> Item:
	var dupe := AlchemyMaterial.new()
	dupe = set_dupe_props(dupe)
	dupe.mat_type = mat_type
	dupe.mat_uses = mat_uses
	dupe.amount_held = amount_held
	return dupe

func get_actual_value() -> int:
	return super() * amount_held

func randomize_item():
	super()
	amount_held = randi_range(1, 999)
# PRIVATE METHODS


# SUBCLASSES


