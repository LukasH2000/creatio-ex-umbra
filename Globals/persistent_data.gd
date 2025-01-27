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
var pause_btn : Node = null
var fade : Node
var pause_menu : Node
	
var game_data : Resource = load("res://Resources/game_data_default.tres")
var is_new_game := false
var fade_scene : PackedScene = preload("res://UI/fade.tscn")
var pause_scene : PackedScene = preload("res://UI/PauseMenu/pause_menu.tscn")

var window_size_base : Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

var good_jingle := preload("res://Globals/Audio/jingles-retro_11.ogg")
var bad_jingle := preload("res://Globals/Audio/jingles-retro_16.ogg")
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var footsteps := $Footsteps
@onready var sleep := $Sleeping
@onready var menu_msc := $"Menu music"
@onready var gen_msc := $"General music"
@onready var canv_msc := $"Canvas music"
@onready var finish_item_jingle := $"Finish item jingle"
@onready var click := $Click
@onready var book_flip := $BookFlip
@onready var coins := $Coins
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
	game_data.randomize_orders()
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

func get_pause_btn() -> Node:
	if pause_btn == null:
		var root := get_tree().root
		# The last child of root will be Main, while we need to change a scene in
		# the World node, which is the first child of Main
		var last_child := root.get_child(root.get_child_count() - 1)
		if last_child.is_in_group("main"):
			pause_btn = last_child.get_child(2)
	return pause_btn

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
	
	var faded : bool = await fade_screen(4.0)
	
	call_deferred("_deferred_goto_scene", path_name, data)


func _deferred_goto_scene(path_name, data = null):
	if not (
	current_scene.name == "MainMenu"
	or current_scene.name == "ShadowCanvas"
	or path_name == "Shadow Canvas"
	):
		for i in 3:
			footsteps.play()
			var fin = await footsteps.finished
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
	var show_pause_btn := true
	
	game_data.current_area_name = path_name
	if path_name != "Shadow Canvas":
		if is_new_game:
			current_scene.open_book()
			is_new_game = false
			show_pause_btn = false
		canv_msc.stop()
		menu_msc.stop()
		if not gen_msc.playing:
			gen_msc.play()
		save_game(0)
	elif path_name == "Main menu":
		show_pause_btn = false
		canv_msc.stop()
		menu_msc.play()
		gen_msc.stop()
	else:
		show_pause_btn = false
		canv_msc.play()
		menu_msc.stop()
		gen_msc.stop()
	
	unfade_screen(show_pause_btn)
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
	var faded : bool = await fade_screen(2.0)
	sleep.play()
	game_data.pass_day()
	save_game(0)
	unfade_screen(true)

func fade_screen(anim_spd : float):
	hide_pause_menu_button()
	fade = fade_scene.instantiate()
	fade.anim_speed = anim_spd
	get_parent().add_child(fade)
	await fade.fade_halfway
	return true

func unfade_screen(show_pause_btn : bool):
	fade.unfade()
	await fade.fade_done
	get_parent().remove_child(fade)
	fade.queue_free()
	if show_pause_btn:
		show_pause_menu_button()

func new_game():
	is_new_game = true
	goto_scene("Workshop")

func save_autosave():
	save_game(0)

func load_autosave():
	load_game(0)

func quit_game():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func check_recipes_for_correct(recipe : Array[Item]) -> Item:
	for i in items_inv.items:
		if i.is_recipe_correct(recipe):
			return i
	return null

func play_finish_item_jingle(accuracy : float):
	if accuracy > 0.3:
		finish_item_jingle.stream = good_jingle
	else:
		finish_item_jingle.stream = bad_jingle
	finish_item_jingle.play()

func play_book_flip():
	book_flip.play()

func play_click():
	click.play()

func play_coins_sound():
	coins.play()
	await coins.finished
	#print(coins.playing)
	coins.play()

func show_pause_menu():
	hide_pause_menu_button()
	pause_menu = pause_scene.instantiate()
	pause_menu.gold = game_data.player_gold
	pause_menu.rep = game_data.player_reputation
	pause_menu.rep_xp = game_data.player_rep_xp
	pause_menu.max_rep_xp = game_data.get_required_rep_xp_up()
	get_parent().add_child(pause_menu)

func delete_pause_menu():
	get_parent().remove_child(pause_menu)
	pause_menu.queue_free()
	show_pause_menu_button()

func show_pause_menu_button():
	get_pause_btn().show()

func hide_pause_menu_button():
	get_pause_btn().hide()
#func 
#func create_new_game():
	#game_data = GameData.new()
	#game_data.player_storage
	#save_game()
# PRIVATE METHODS


# SUBCLASSES


