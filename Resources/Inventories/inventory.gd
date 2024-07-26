# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name Inventory extends Resource
# DOCSTRING

# SIGNALS
signal inventory_updated

# ENUMS


# CONSTANTS

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var items : Array[Item] :
	get:
		return items
	set(value):
		items = value

@export var num_slots : int :
	get:
		return num_slots
	set(value):
		num_slots = value
		resize_inventory()

# PUBLIC VARIABLES


# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func resize_inventory():
	items.resize(num_slots)
	#inventory_updated.emit()

func add_item(item : Item, index : int): # TODO
	resize_inventory()
	items[index] = item
	resize_inventory()
	#inventory_updated.emit()

func remove_item(item : Item): # TODO
	if item in items:
		resize_inventory()
		items.erase(item)
	resize_inventory()
		#inventory_updated.emit()

func remove_item_at(index : int): # TODO
	#if item in items:
		#items.erase(item)
	resize_inventory()
	items.remove_at(index)
	resize_inventory()
	#inventory_updated.emit()

func count_items() -> int:
	var count := 0
	for i in items:
		if i is Item and i != null:
			count += 1
	return count

func get_total_value() -> int:
	var total_value := 0
	for i in items:
		if i is Item and i != null:
			total_value += i.get_actual_value()
			# TODO: make selling items add less to value
	return total_value

func clear_inventory():
	for i in num_slots:
		items[i] = null
	resize_inventory()
# PRIVATE METHODS


# SUBCLASSES


