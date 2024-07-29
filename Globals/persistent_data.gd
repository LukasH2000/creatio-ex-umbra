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
const REP_THRESHOLD : int = 3

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
var fade : Node
	
var game_data : Resource = load("res://Resources/game_data_default.tres")
var is_new_game := false
var fade_scene : PackedScene = preload("res://UI/fade.tscn")

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
	#create_save_path()
	get_curr_scene()
	create_default_forms()
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

func get_discovered_forms() -> Inventory:
	if not game_data.discovered_forms:
		game_data.discovered_forms = Inventory.new()
		game_data.discovered_forms.num_slots = items_inv.num_slots
		game_data.discovered_forms.resize_inventory()
	return game_data.discovered_forms

func create_default_discovered_forms() -> void:
	var disc_forms := get_discovered_forms()
	for i in range(0 , items_inv.items.size()):
		if items_inv.items[i].form_discovered == null:
			items_inv.items[i].create_form_discovered()
		disc_forms.add_item(items_inv.items[i].custom_duplicate(),i)

func create_default_forms() -> void:
	for i in items_inv.items:
		if i.form == null:
			i.create_form()

func goto_scene(path_name : String, data : Inventory = null):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	var faded : bool = await fade_screen(3.0)
	call_deferred("_deferred_goto_scene", path_name, data)


func _deferred_goto_scene(path_name, data = null):
	# It is now safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(area_scene_paths[path_name])
	
	# Instance the new scene.
	current_scene = s.instantiate()
	
	if data:
		current_scene.set_scene_data(data)
	
	# Add it to the active scene, as child of root.
	world.add_child(current_scene)
	if is_new_game:
		current_scene.open_book()
		is_new_game = false
	
	game_data.current_area_name = path_name
	if path_name != "Shadow Canvas":
		save_game(0)
	
	unfade_screen()
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	#get_tree().current_scene = current_scene

func check_save_path() -> Error:
	var dir_access := DirAccess.open("user://")
	#print(dir_access.dir_exists(SAVE_DATA_PATH))
	#print(DirAccess.dir_exists_absolute(SAVE_DATA_PATH))
	#print(dir_access.get_directories())
	if not dir_access.dir_exists(SAVE_DATA_PATH):
		return dir_access.make_dir(SAVE_DATA_PATH)
	return OK

# TODO ALERT: doesn't save inv game_data properly? inv wasn't restored after loading
# the area name was properly saved and loaded tho
func save_game(save_num : int = -1) -> void:
	if check_save_path() == OK:
		if save_num == -1:
			save_num = GameData.save_num
			GameData.save_num += 1
		var save_file_path := SAVE_DATA_PATH + "save_%s.tres" % save_num
		ResourceSaver.save(game_data, save_file_path)
	else:
		printerr("Could not create save data folder")

func does_save_exist(save_num : int) -> bool:
	return ResourceLoader.exists(SAVE_DATA_PATH + "save_%s.tres" % save_num)

func load_game(save_num : int) -> void:
	var save_path := SAVE_DATA_PATH + "save_%s.tres" % save_num
	if ResourceLoader.exists(save_path):
		game_data = ResourceLoader.load(save_path)
		if game_data:
			goto_scene(game_data.current_area_name)
	#return null

func pass_day():
	var faded : bool = await fade_screen(1.0)
	game_data.pass_day()
	unfade_screen()

func fade_screen(anim_spd : float):
	fade = fade_scene.instantiate()
	fade.anim_speed = anim_spd
	get_parent().add_child(fade)
	await fade.fade_halfway
	return true

func unfade_screen():
	fade.unfade()
	await fade.fade_done
	get_parent().remove_child(fade)
	fade.queue_free()

func new_game():
	is_new_game = true
	goto_scene("Workshop")

func load_autosave():
	load_game(0)

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
#func create_new_game():
	#game_data = GameData.new()
	#game_data.player_storage
	#save_game()
# PRIVATE METHODS


# SUBCLASSES


