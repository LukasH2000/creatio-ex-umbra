# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
const SAVE_DATA_PATH : String = "user://Saves/"
const THEME_PATH : String = "res://UI/game_theme.tres"

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var materials_inv : Inventory
@export var items_inv : Inventory

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
var popup_window : Node = null

var game_data : Resource = load("res://Resources/game_data_default.tres")

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
	get_curr_scene()
	create_default_discovered_forms()
	game_data.randomize_stores()
	#print(game_data.discovered_forms)
	#create_new_game()

func get_curr_scene() -> Node:
	if current_scene == null:
		var root := get_tree().root
		# The last child of root will be Main, while we need to change a scene in
		# the World node, which is the first child of Main
		var last_child := root.get_child(root.get_child_count() - 1)
		if last_child.is_in_group("main"):
			world = last_child.get_child(0)
			# The current (area) scene will be the first child of world
			current_scene = world.get_child(0)
	return current_scene

func get_popup_window() -> Node:
	if popup_window == null:
		var root := get_tree().root
		# The last child of root will be Main, while we need to change a scene in
		# the World node, which is the first child of Main
		var last_child := root.get_child(root.get_child_count() - 1)
		if last_child.is_in_group("main"):
			popup_window = last_child.get_child(1)
	return popup_window

func get_discovered_forms() -> Dictionary:
	return game_data.discovered_forms

func create_default_discovered_forms() -> void:
	for i in items_inv.items:
		if not game_data.discovered_forms.has(i.name):
			if i.form_discovered == null:
				i.create_form_discovered()
			game_data.discovered_forms[i.name] = i.form_discovered

func goto_scene(path : String, data : Inventory = null):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, data)


func _deferred_goto_scene(path, data = null):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()
	
	if data:
		current_scene.set_scene_data(data)
	
	# Add it to the active scene, as child of root.
	world.add_child(current_scene)
	

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	#get_tree().current_scene = current_scene

func check_save_path() -> Error:
	if not DirAccess.dir_exists_absolute(SAVE_DATA_PATH):
		return DirAccess.make_dir_absolute(SAVE_DATA_PATH)
	return OK

func save_game(save_num : int = -1) -> void:
	if check_save_path() == OK:
		if save_num == -1:
			save_num = GameData.save_num
			GameData.save_num += 1
		var save_file_path := SAVE_DATA_PATH + "save_%s.tres" % save_num
		ResourceSaver.save(game_data, save_file_path)
	else:
		printerr("Could not create save data folder")

func load_game(save_num : int) -> Resource:
	if ResourceLoader.exists(SAVE_DATA_PATH):
		return ResourceLoader.load(SAVE_DATA_PATH + "save_%s.tres" % save_num)
	return null


#func create_new_game():
	#game_data = GameData.new()
	#game_data.player_storage
	#save_game()
# PRIVATE METHODS


# SUBCLASSES


