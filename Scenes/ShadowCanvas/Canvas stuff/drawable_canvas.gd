# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
extends Node2D
# DOCSTRING

# SIGNALS
signal pixel_drawn

# ENUMS
enum GIZMOS {PENCIL, LINE, RECT, CIRCLE, MOVE, FILL}

# CONSTANTS
# Canvas is 168x168 real pixels
const CANVAS_SIDE_LENGTH : int = 168

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT

# PUBLIC VARIABLES
# For a 64x64 canvas, set this to 2.625
# PIXEL SIZE = 3 	-> 56x56 canvas
# PIXEL SIZE = 4 	-> 42x42 canvas
# PIXEL SIZE = 5.25 -> 32x32 canvas
# PIXEL SIZE = 6 	-> 28x28 canvas
# PIXEL SIZE = 7 	-> 24x24 canvas
# PIXEL SIZE = 8 	-> 21x21 canvas
var pixel_size : float = 4
var canvas_size : Vector2i
var canvas_pixels : BitMap = BitMap.new()
var canvas_preview : BitMap = BitMap.new()
var grid_square_size : Vector2 = Vector2(pixel_size, pixel_size)

var alpha_grid : float = 0.1
var color_grid : Color = Color(0.5, 0.5, 0.5, alpha_grid)
var alpha_pixel : float = 1
var color_pixel : Color = Color(0, 0, 0, alpha_pixel)
var alpha_preview : float = 0.25
var color_preview : Color = Color(0, 0, 0, alpha_preview)

var is_drawing : bool = false
var last_pixel_pos : Vector2i = Vector2i.ZERO
var current_gizmo : GIZMOS = GIZMOS.PENCIL

var remaining_essence : int = 0
# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
# TODO: either remove the Drum or change it, as currently it's not exactly an
# interesting object to draw, nor does the default discovered form make sense
# TODO: try changing pixel size to see if things work better, even though the
# textures would be weirdly sized
# TODO: maybe draw discovered_form as preview, because right now the more you
# have a form unlocked, the less you actually need to draw on it ( if the
# discovered form == form, you won't even need to use mats currently :p )
func _ready():
	canvas_size = Vector2i(CANVAS_SIDE_LENGTH, CANVAS_SIDE_LENGTH)
	canvas_pixels.create(canvas_size / pixel_size)
	canvas_preview.create(canvas_size / pixel_size)

func set_canvas_pixels_to_form(form : BitMap):
	if form.get_size() == canvas_pixels.get_size():
		canvas_pixels = form

func get_drawing() -> BitMap:
	return canvas_pixels

func _process(delta):
	if current_gizmo == GIZMOS.PENCIL:
		pencil_drawing()
	queue_redraw()

func _draw():
	#var rect = Rect2(0,0,168,168)
	#var color = Color(255,0,0)
	#draw_rect(rect, color)
	draw_grid(grid_square_size)
	draw_canvas_pixels()
	draw_preview()
	# TODO: draw_selected_form()? Not needed if canvas_pixels is set to form

func draw_grid(grid_size : Vector2):
	for x in range(1 + canvas_size.x / grid_size.x):
		draw_line(Vector2(x * grid_size.x, 0), Vector2(x * grid_size.x, canvas_size.y), color_grid)
	for y in range(1 + canvas_size.y / grid_size.y):
		draw_line(Vector2(0, y * grid_size.y), Vector2(canvas_size.x, y * grid_size.y), color_grid)

func draw_canvas_pixels() -> void:
	for x in range(CANVAS_SIDE_LENGTH / pixel_size):
		for y in range(CANVAS_SIDE_LENGTH / pixel_size):
			if canvas_pixels.get_bit(x, y):
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), color_pixel)
		#draw_line(Vector2(x * grid_size.x, 0), Vector2(x * grid_size.x, canvas_size.y), color_grid)
	#
		#draw_line(Vector2(0, y * grid_size.y), Vector2(canvas_size.x, y * grid_size.y), color_grid)

func draw_preview() -> void:
	for x in range(CANVAS_SIDE_LENGTH / pixel_size):
		for y in range(CANVAS_SIDE_LENGTH / pixel_size):
			if canvas_preview.get_bit(x, y):
				draw_rect(Rect2(x * pixel_size, y * pixel_size, pixel_size, pixel_size), color_preview)

func set_draw_pixel(coords : Vector2i) -> void:
	if remaining_essence >= pixel_size:
		canvas_pixels.set_bitv(coords, true)
		pixel_drawn.emit(pixel_size)
	else:
		pass # TODO: what happens when player has used all materials

func set_remaining_essence(num_pixels : int):
	remaining_essence = num_pixels

func set_preview_pixel(coords : Vector2i, is_drawn_pixel : bool) -> void:
	if last_pixel_pos != coords and not is_drawn_pixel:
		canvas_preview.set_bitv(coords, true)
		canvas_preview.set_bitv(last_pixel_pos, false)
		last_pixel_pos = coords
	
	if is_drawn_pixel:
		canvas_preview.set_bitv(last_pixel_pos, false)

func local_mouse_pos() -> Vector2:
	return to_local(get_global_mouse_position())
	#print(to_local(get_viewport().get_mouse_position()))

func get_pixel_pos() -> Vector2i:
	return Vector2i(local_mouse_pos()) / pixel_size
	
func _unhandled_input(event) -> void:
	if not is_drawing and Input.is_action_just_pressed("left_click"):
		
		is_drawing = true
		#print("local pos: ", local_mouse_pos(), ", pixel pos: ", get_pixel_pos())
		#check_mouse_pos()
	if is_drawing and Input.is_action_just_released("left_click"):
		is_drawing = false

# TODO: if the player tries to draw without any essence remaining in the slots,
# take the pixels that were drawn first, like a FIFO queue
func pencil_drawing():
	var pixel_pos = get_pixel_pos()
	if is_pos_in_grid_bounds(pixel_pos):
		var is_pixel_drawn := canvas_pixels.get_bitv(pixel_pos)
		var is_preview_drawn := canvas_preview.get_bitv(pixel_pos)
		if is_drawing and not is_pixel_drawn:
			set_draw_pixel(pixel_pos)
		elif not is_drawing and not is_preview_drawn:
			set_preview_pixel(pixel_pos, is_pixel_drawn)

# TODO: most important extra tools to me are line, move and erase
# not sure about adding erase, but you could style it like "if you erase
# a pixel, the essence will be lost"
func line_drawing():
	pass

func rect_drawing():
	pass

func circle_drawing():
	pass

func is_pos_in_grid_bounds(pos : Vector2i) -> bool:
	var in_bounds = pos.x >= 0 and pos.x < CANVAS_SIDE_LENGTH / pixel_size and pos.y >= 0 and pos.y < CANVAS_SIDE_LENGTH / pixel_size
	return in_bounds
# PRIVATE METHODS


# SUBCLASSES


