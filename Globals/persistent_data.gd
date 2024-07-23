# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var area_scene_paths : Dictionary = {
	"Dark Room" : "res://Scenes/DarkRoom/dark_room.tscn",
	"Merchant Guild" : "res://Scenes/MerchantGuild/merchant_guild.tscn",
	"Order Board" : "res://Scenes/OrderBoard/order_board.tscn",
	"Shadow Canvas" : "res://Scenes/ShadowCanvas/shadow_canvas.tscn",
	"Thoroughfare" : "res://Scenes/Thoroughfare/thoroughfare.tscn",
	"Workshop" : "res://Scenes/Workshop/workshop.tscn",
}
var current_scene : Node = null
var world : Node = null
var game_data : GameData = null

var window_size_base : Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	var root = get_tree().root
	# The last child of root will be Main, while we need to change a scene in
	# the World node, which is the first child of Main
	var last_child = root.get_child(root.get_child_count() - 1)
	if last_child.is_in_group("main"):
		world = last_child.get_child(0)
		# The current (area) scene will be the first child of world
		current_scene = world.get_child(0)

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	world.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	#get_tree().current_scene = current_scene

# PRIVATE METHODS


# SUBCLASSES


