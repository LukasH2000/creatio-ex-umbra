# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node2D
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
const MAT_SLOT_TEXTURE : Vector2 = Vector2(22, 22)

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var texture : ImageTexture

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var sprite := $Sprite2D

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
#func _init(t : ImageTexture):
	#texture = t

#func _ready():
	#update_sprite()

func update_sprite(t : Image):
	if not texture:
		texture = ImageTexture.create_from_image(t)
		sprite.texture = texture
	else:
		sprite.texture.update(t)
	texture.set_size_override(MAT_SLOT_TEXTURE)
	
# PRIVATE METHODS


# SUBCLASSES


