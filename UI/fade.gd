# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal fade_done
signal fade_halfway

# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var anim_speed : float
#var is_halfway : bool = false

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var anim_player := $AnimationPlayer

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS

func _ready():
	anim_player.speed_scale = anim_speed

func unfade():
	anim_player.play("unfade_screen")
# PRIVATE METHODS


# SUBCLASSES




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_screen":
		fade_halfway.emit()
		#is_halfway = true
	else:
		fade_done.emit()
