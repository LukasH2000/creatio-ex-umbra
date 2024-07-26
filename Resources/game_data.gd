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
@export var discovered_forms : Array[Form]
@export var discovered_materials : Array[AlchemyMaterial]

@export var day : int

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


# PRIVATE METHODS


# SUBCLASSES


