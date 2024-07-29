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
var is_playing : bool

# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var light := $Node2D/PointLight2D
@onready var labels := $MainMenu/VBoxContainer2
@onready var btn_new :=$MainMenu/CenterContainer/VBoxContainer/ButtonNewGame
@onready var btn_save := $MainMenu/CenterContainer/VBoxContainer/ButtonSave
@onready var btn_load := $MainMenu/CenterContainer/VBoxContainer/ButtonLoadGame
#@onready var  := 
# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
# TODO: allow player to open main menu if they're not already in a menu or drawing
# TODO: auto save on scene change except for going to shadow canvas or opening menu
# TODO: settings
# TODO: orders
# TODO: audio
func _ready():
	if is_playing:
		btn_new.hide()
		btn_save.show()
	else:
		btn_new.show()
		btn_save.hide()
	if PersistentData.does_save_exist(0):
		btn_load.disabled = false
	else:
		btn_load.disabled = true

func set_light_freq(freq):
	light.frequency = freq

func _on_button_new_game_pressed():
	PersistentData.new_game()

func _on_button_load_game_pressed():
	# TODO: show save slots
	# TODO: await selection
	# TODO: do PersistentData.load_game(selection) if it wasn't cancelled
	PersistentData.load_autosave()

func _on_button_quit_pressed():
	PersistentData.quit_game()

func _on_button_save_pressed():
	# TODO: show save slots
	# TODO: await selection
	# TODO: do PersistentData.save_game(selection) if it wasn't cancelled
	pass # Replace with function body.

# PRIVATE METHODS


# SUBCLASSES


#func _on_h_slider_value_changed(value):
	#set_light_freq(value)
	#labels.get_child(0).text = "freq: %s" % value
#
#
#func _on_h_slider_2_value_changed(value):
	#light.x = value
	#labels.get_child(1).text = "x: %s" % value
#
#
#func _on_h_slider_3_value_changed(value):
	#light.y = value
	#labels.get_child(2).text = "y: %s" % value
#
#
#func _on_h_slider_4_value_changed(value):
	#light.z = value
	#labels.get_child(3).text = "z: %s" % value


