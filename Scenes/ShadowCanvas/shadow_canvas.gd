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
var passed_inv : Inventory = null
var passed_item_to_form : Item
var passed_materials : Array[Item]
var used_materials : Array[Item]
var mat_slot_scene : PackedScene = preload("res://Scenes/ShadowCanvas/Canvas stuff/material_slot.tscn")
var mat_slots : Array[Node]
var material_form_size_px : int
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var slot_markers := $ShadowCanvasArea/MatSlotMarkers
@onready var canvas := $ShadowCanvasArea/DrawableCanvas
@onready var interface := $ShadowCanvasInterface

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	passed_materials = passed_inv.items.slice(0, -1, 1, true)
	passed_item_to_form = passed_inv.items[passed_inv.items.size()-1].custom_duplicate()
	for i in range(0, passed_materials.size()):
		if passed_materials[i]:
			var mat_slot := mat_slot_scene.instantiate()
			
			mat_slots.append(mat_slot)
			slot_markers.get_child(i).add_child(mat_slot)
			mat_slot.update_sprite(passed_materials[i].get_form_image())
			used_materials.append(passed_materials[i])
		else:
			mat_slots.append(null)
	#canvas.set_canvas_pixels_to_form(
		#passed_item_to_form.get_form_discovered_inverted()
	#)
	canvas.set_canvas_form_disc_to_form(
		passed_item_to_form.get_form_discovered_inverted()
	)
	var mat_form_size : Vector2i = \
	passed_materials[get_first_material_index()].get_form().get_size()
	material_form_size_px = mat_form_size.x * mat_form_size.y
	
	canvas.set_remaining_essence(get_remaining_essence())

func set_scene_data(data : Inventory):
	passed_inv = data

func _on_shadow_canvas_interface_item_finished():
	passed_item_to_form.form_discovered = Item.invert_bitmap(canvas.get_drawing())
	# ALERT: passed_item_to_form.form_discovered is passed by ref to the canvas
	# so the canvas drawing is stored there in Item
	# INFO: returning a duplicated bitmap with invert_bitmap makes this untrue
	interface.show_finished_item_screen(used_materials, passed_item_to_form)

func get_remaining_essence() -> int:
	var remaining_essence := 0
	for i in range(0, passed_materials.size()):
		if passed_materials[i]:
			var mat_px_count := get_mat_px_count(passed_materials[i])
			#print(mat_px_count)
			if mat_px_count > 0:
				remaining_essence += mat_px_count
			else:
				slot_markers.get_child(i).remove_child(mat_slots[i])
				mat_slots[i].queue_free()
				mat_slots[i] = null
				passed_materials[i] = null
				#passed_inv.remove_item_at(i)
	return remaining_essence

func get_first_material_index() -> int:
	for i in range(0, passed_materials.size()):
		if passed_materials[i]:
			return i
	return -1

func get_mat_px_count(mat : Item) -> int:
	return material_form_size_px - mat.get_form().get_true_bit_count()

func get_random_mat_index():
	#var filtered_mats := passed_materials.filter(is_not_null)
	var random_mat : Item = used_materials.pick_random()# filtered_mats.pick_random()
	return passed_materials[passed_materials.find(random_mat)]

#func is_not_null(e):
	#return e != null

func _on_drawable_canvas_pixel_drawn(pixel_size : float):
	var rem_essence := get_remaining_essence()
	if rem_essence >= pixel_size:
		var first_mat_i := get_first_material_index()
		var first_mat := passed_materials[first_mat_i]
		# TODO: just pixel side length or full pixel?
		# full pixel would be pixel_size ** 2
		# just pixel size seemed too little
		# even full pixel size seems too little, but
		# full pixel size * 2 seems too much
		# TODO: possibly make a progression system where you can
		# get traits/talents/... to reduce pixels used per level
		#first_mat.reduce_form_by(pixel_size ** 2)
		first_mat.reduce_form_by(pixel_size*2)
		mat_slots[first_mat_i].update_sprite(first_mat.get_form_image())
		if passed_inv.items[first_mat_i]:
			passed_inv.remove_item_at(first_mat_i)
	else:
		pass
	canvas.set_remaining_essence(rem_essence)
# TODO: take pixels from materials NOTE: Done
# TODO: once pixels have been used from a material, remove it from passed_inv.
# If it also messes with passed_inv_materials, make sure it deep deep copies.
# NOTE: Done
# TODO: once all pixels have been used from a material, remove it from the tree
# and queue_free it NOTE: Done
# PRIVATE METHODS


# SUBCLASSES





