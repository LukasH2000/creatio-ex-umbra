# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node2D
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
const MIN_ZOOM : float = 1.0
const MAX_ZOOM : float = 4.0

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var zoom_level : Vector2

var pan_mouse_start_pos : Vector2 = Vector2.ZERO
var pan_cam_start_pos : Vector2 = Vector2.ZERO
var is_panning : bool = false
# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	zoom_level = $Camera2D.zoom

func _process(delta):
	apply_zoom(delta)
	pan_camera()
	#print($Camera2D.zoom)
	#if Input.is_action_pressed("right_click"):
		## Follow mouse with camera
		#var mouse_pos_camera = get_viewport().get_mouse_position()
		#var mouse_pos_global = mouse_pos_camera/$Camera2D.zoom
		##var mouse_offset = mouse_pos - $Camera2D.position
		##var mouse_offset = mouse_pos - $Camera2D.position
		##print(mouse_pos_camera, " / ", mouse_pos_global)
		#$Camera2D.position += mouse_pos_global - last_pos # lerp(PersistentData.window_size_base / 2.0, mouse_offset, 0.5)
		#$Camera2D.position.x = clamp($Camera2D.position.x, $Camera2D.limit_top, $Camera2D.limit_bottom)
		#$Camera2D.position.y = clamp($Camera2D.position.y, $Camera2D.limit_left, $Camera2D.limit_right)
		#print("Cam pos: ", $Camera2D.position, " Mouse pos: ", mouse_pos_global, " Last pos: ", last_pos)
		#last_pos = mouse_pos_global
	#
	#if Input.is_action_just_released("right_click"):
		#last_pos = Vector2.ZERO

func _input(event):
	scroll_zoom_input()

func scroll_zoom_input():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_DOWN):
		#print("Mouse wheel down")
		zoom_level *= 0.9
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_WHEEL_UP):
		#print("Mouse wheel up")
		zoom_level *= 1.1
	zoom_level.x = clamp(zoom_level.x, MIN_ZOOM, MAX_ZOOM)
	zoom_level.y = clamp(zoom_level.y, MIN_ZOOM, MAX_ZOOM)

func apply_zoom(delta : float):
	$Camera2D.zoom = $Camera2D.zoom.slerp(zoom_level, 10 * delta)
	
	$Camera2D.zoom.x = clamp($Camera2D.zoom.x, MIN_ZOOM, MAX_ZOOM)
	$Camera2D.zoom.y = clamp($Camera2D.zoom.y, MIN_ZOOM, MAX_ZOOM)

func pan_camera():
	var mouse_pos_camera = get_viewport().get_mouse_position()
	if not is_panning and Input.is_action_just_pressed("right_click"):
		pan_mouse_start_pos = mouse_pos_camera#/$Camera2D.zoom
		pan_cam_start_pos = $Camera2D.position
		is_panning = true
	
	if is_panning and Input.is_action_just_released("right_click"):
		is_panning = false
	
	if is_panning:
		var move_vector = mouse_pos_camera - pan_mouse_start_pos
		$Camera2D.position = pan_cam_start_pos - (move_vector / $Camera2D.zoom.x)
		var clamp_offset := Vector2((PersistentData.window_size_base.x/2)/$Camera2D.zoom.x, (PersistentData.window_size_base.y/2)/$Camera2D.zoom.y)
		$Camera2D.position.y = clamp($Camera2D.position.y, $Camera2D.limit_top + clamp_offset.y, $Camera2D.limit_bottom - clamp_offset.y)
		$Camera2D.position.x = clamp($Camera2D.position.x, $Camera2D.limit_left + clamp_offset.x, $Camera2D.limit_right - clamp_offset.x)
		print($Camera2D.position)
# PRIVATE METHODS


# SUBCLASSES


