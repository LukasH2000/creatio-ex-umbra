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
var mat_slot_scene : PackedScene = preload("res://Scenes/ShadowCanvas/Canvas stuff/material_slot.tscn")
var mat_slots : Array[Node]
# PRIVATE VARIABLES


# @ONREADY VARIABLES
@onready var slot_markers := $ShadowCanvasArea/MatSlotMarkers
@onready var canvas := $ShadowCanvasArea/DrawableCanvas

# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _ready():
	passed_materials = passed_inv.items.slice(0, -1, 1, true)
	passed_item_to_form = passed_inv.items[passed_inv.items.size()-1]
	for i in range(0, passed_materials.size()):
		if passed_materials[i]:
			var mat_slot := mat_slot_scene.instantiate()
			
			mat_slots.append(mat_slot)
			slot_markers.get_child(i).add_child(mat_slot)
			mat_slot.update_sprite(passed_materials[i].get_form_image())

func set_scene_data(data : Inventory):
	passed_inv = data

# PRIVATE METHODS


# SUBCLASSES


