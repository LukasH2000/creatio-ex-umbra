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

func add_item(item : Item, index : int):
	#resize_inventory()
	items[index] = item
	#resize_inventory()
	#inventory_updated.emit()

func add_items_to_inv(inv : Inventory):
	for i in items:
		if i:
			var added := false
			for j in inv.items:
				if j:
					if i.is_same_item(j):
						j.amount_held += i.amount_held
						added = true
						break
			if not added:
				inv.add_item(i, inv.items.find(null))
			

func remove_item(item : Item):
	if item in items:
		#resize_inventory()
		items[items.find(item)] = null
	#resize_inventory()
		#inventory_updated.emit()

func remove_item_at(index : int):
	#if item in items:
		#items.erase(item)
	#resize_inventory()
	items[index] = null
	#resize_inventory()
	#inventory_updated.emit()

func get_item_by_name(name : String) -> Item:
	for i in items:
		if i and i.name == name:
			return i
	return null

func count_items() -> int:
	var count := 0
	for i in items:
		if i is Item and i != null:
			count += 1
	return count

func get_total_value(is_buying : bool) -> int:
	var total_value := 0
	for i in items:
		if i is Item and i != null:
			if is_buying:
				total_value += i.get_actual_value()
			if not is_buying:
				total_value += i.get_sell_value()
			# TODO: make selling items add less to value
			# NOTE: DONE, i think
	return total_value

func clear_inventory():
	for i in num_slots:
		items[i] = null
	resize_inventory()

func sort_inventory(sort_func : Callable):
	#items.sort() # sort items and null
	items.sort_custom(sort_func)

func sort_by_tier(a : Item, b : Item) -> bool:
	if a != null:
		#if : return true
		if b == null \
		or a.tier < b.tier\
		or (a.tier == b.tier and a.grade < b.grade):
			return true
	return false
# PRIVATE METHODS


# SUBCLASSES


