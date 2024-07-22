# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node2D
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
#@export var areas : Array[PackedScene] = []
#@export var previous_area_instance : Node
#@export var current_area : PackedScene
# PUBLIC VARIABLES


# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
#func change_area(next_area : PackedScene) -> void:
	#var current_area_instance := get_child(0)
	#var next_area_instance : Node
	##var prev_area_exists : bool = previous_area_instance != null
	##if prev_area_exists and is_instance_of(previous_area_instance, next_area):
		##next_area_instance = previous_area_instance
	##else:
		##if prev_area_exists: previous_area_instance.queue_free()
	#next_area_instance = next_area.instantiate()
	##previous_area_instance = current_area_instance
	##current_area := next_area
	#remove_child(current_area_instance)
	#current_area_instance.area_changed.disconnect(change_area)
	#add_child(next_area_instance)
	#next_area_instance.area_changed.connect(change_area)
	

# PRIVATE METHODS


# SUBCLASSES


