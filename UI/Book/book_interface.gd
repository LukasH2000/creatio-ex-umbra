# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Control
# DOCSTRING

# SIGNALS
signal book_closed

# ENUMS


# CONSTANTS
const MIN_PAGE_NUM := 0


# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var prev_page_num := 0
var curr_page_num := 0
var max_page_num : int
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var left_page := $CenterContainer/TextureRect/PagesControl/LeftPage
@onready var right_page := $CenterContainer/TextureRect/PagesControl/RightPage
@onready var prev_button := $HBoxContainer/ButtonPrev
@onready var next_button := $HBoxContainer/ButtonNext

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	max_page_num = left_page.get_child_count() - 1

func _on_button_close_pressed():
	hide()


func _on_button_prev_pressed():
	if curr_page_num > MIN_PAGE_NUM:
		prev_page_num = curr_page_num
		curr_page_num -= 1
	change_page()


func _on_button_next_pressed():
	if curr_page_num < max_page_num:
		prev_page_num = curr_page_num
		curr_page_num += 1
	change_page()

func change_page():
	left_page.get_child(curr_page_num).show()
	right_page.get_child(curr_page_num).show()
	left_page.get_child(prev_page_num).hide()
	right_page.get_child(prev_page_num).hide()
	if curr_page_num == max_page_num:
		next_button.disabled = true
	elif next_button.disabled:
		next_button.disabled = false
	if curr_page_num == MIN_PAGE_NUM:
		prev_button.disabled = true
	elif prev_button.disabled:
		prev_button.disabled = false
	PersistentData.play_book_flip()
	
# PRIVATE METHODS


# SUBCLASSES



func _on_visibility_changed():
	if visible:
		PersistentData.hide_pause_menu_button()
	else:
		PersistentData.show_pause_menu_button()
