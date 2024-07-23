# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node2D
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
# Canvas is 168x168 real pixels
# For a 64x64 canvas, set this to 2.625
# PIXEL SIZE = 3 	-> 56x56 canvas
# PIXEL SIZE = 4 	-> 42x42 canvas
# PIXEL SIZE = 5.25 -> 32x32 canvas
# PIXEL SIZE = 6 	-> 28x28 canvas
# PIXEL SIZE = 7 	-> 24x24 canvas
# PIXEL SIZE = 8 	-> 21x21 canvas
const PIXEL_SIZE : float = 4
const CANVAS_SIDE_LENGTH : int = 168
# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT


# PUBLIC VARIABLES
var canvas_size : Vector2i
var canvas_pixels : BitMap = BitMap.new()
var grid_square_size : Vector2 = Vector2(PIXEL_SIZE, PIXEL_SIZE)

var color_grid : Color
var color_pixel : Color
var alpha_grid : float = 0.5
var alpha_pixel : float = 1

var is_drawing : bool = false
# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	canvas_size = Vector2i(CANVAS_SIDE_LENGTH, CANVAS_SIDE_LENGTH)
	canvas_pixels.create(canvas_size / PIXEL_SIZE)
	color_grid = Color(0.5, 0.5, 0.5, alpha_grid)
	color_pixel = Color(0, 0, 0, alpha_pixel)

func _process(delta):
	pencil_drawing()
	queue_redraw()

func _draw():
	#var rect = Rect2(0,0,168,168)
	#var color = Color(255,0,0)
	#draw_rect(rect, color)
	draw_grid(grid_square_size)
	draw_canvas_pixels()

func draw_grid(grid_size : Vector2):
	for x in range(1 + canvas_size.x / grid_size.x):
		draw_line(Vector2(x * grid_size.x, 0), Vector2(x * grid_size.x, canvas_size.y), color_grid)
	for y in range(1 + canvas_size.y / grid_size.y):
		draw_line(Vector2(0, y * grid_size.y), Vector2(canvas_size.x, y * grid_size.y), color_grid)

func draw_canvas_pixels() -> void:
	for x in range(CANVAS_SIDE_LENGTH / PIXEL_SIZE):
		for y in range(CANVAS_SIDE_LENGTH / PIXEL_SIZE):
			if canvas_pixels.get_bit(x, y):
				draw_rect(Rect2(x * PIXEL_SIZE, y * PIXEL_SIZE, PIXEL_SIZE, PIXEL_SIZE), color_pixel)
		#draw_line(Vector2(x * grid_size.x, 0), Vector2(x * grid_size.x, canvas_size.y), color_grid)
	#
		#draw_line(Vector2(0, y * grid_size.y), Vector2(canvas_size.x, y * grid_size.y), color_grid)

func set_pixel(coords : Vector2i) -> void:
	canvas_pixels.set_bitv(coords, true)

func local_mouse_pos() -> Vector2:
	return to_local(get_global_mouse_position())
	#print(to_local(get_viewport().get_mouse_position()))

func get_pixel_pos() -> Vector2i:
	return Vector2i(local_mouse_pos()) / PIXEL_SIZE
	
func _unhandled_input(event) -> void:
	if not is_drawing and Input.is_action_just_pressed("left_click"):
		
		is_drawing = true
		#print("local pos: ", local_mouse_pos(), ", pixel pos: ", get_pixel_pos())
		#check_mouse_pos()
	if is_drawing and Input.is_action_just_released("left_click"):
		is_drawing = false

func pencil_drawing():
	if is_drawing:
		var pixel_pos = get_pixel_pos()
		if is_pos_in_grid_bounds(pixel_pos) and not canvas_pixels.get_bitv(pixel_pos):
			set_pixel(pixel_pos)

func line_drawing():
	pass

func rect_drawing():
	pass

func circle_drawing():
	pass

func is_pos_in_grid_bounds(pos : Vector2i) -> bool:
	var in_bounds = pos.x >= 0 and pos.x < CANVAS_SIDE_LENGTH / PIXEL_SIZE and pos.y >= 0 and pos.y < CANVAS_SIDE_LENGTH / PIXEL_SIZE
	return in_bounds
# PRIVATE METHODS


# SUBCLASSES


