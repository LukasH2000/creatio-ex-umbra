# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name Order extends Resource
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
#const

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var ordered_items : Array[Item]
@export var days_left : int
#@export var payment : int

# PUBLIC VARIABLES
var tooltip_text : String

#var item_src : InventoryInterface.INV_SOURCE

# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
#func _init(i : Item, src : InventoryInterface.INV_SOURCE) -> void:
	#item = i
	#item_src = src

#func _ready() -> void:
	#update_tooltip()
func get_tooltip_text():
	if tooltip_text == "":
		update_tooltip()
	return tooltip_text

func update_tooltip():
	tooltip_text = "A customer has ordered the following:\n"
	tooltip_text += get_ordered_items_text()
	var days_text := "1 day" if days_left == 1 else "%s days" % days_left
	tooltip_text += "They offer %s gold, order will remain for %s" % [
		get_base_payment(),
		days_text
	]
	#tooltip_text = "%s\nTier: %s\nGrade: %s\nValue: %s" % [
			#item.name, 
			#ITEM_TIERS[item.tier],
			#ITEM_GRADES[item.grade],
			#item.get_actual_value()
		#]
	#if item.item_type == Item.ITEM_TYPE.MATERIAL:
		#if item_src != InventoryInterface.INV_SOURCE.CANVAS_MATERIALS:
			#tooltip_text += "\nAmount: %s" % item.amount_held
			#var amount_label : Label
			#if get_child_count() > 0:
				#amount_label = get_child(0)
			#else:
				#amount_label = Label.new()
				#amount_label.add_theme_color_override("font_color", Color(0,0,0))
				#add_child(amount_label)
			#amount_label.text = "%s" % item.amount_held
	#tooltip_text += "\n\n%s" % item.description
	#_make_custom_tooltip(tooltip_text)

func get_base_payment():
	var payment := 0.0
	for i in ordered_items:
		payment += i.get_actual_value() * 1.2
	return ceili(payment)

func get_ordered_items_text():
	var text := ""
	for i in ordered_items:
		text += "%s, at least %s tier and %s grade\n" % [
			i.name,
			InventoryItem.ITEM_TIERS[i.tier],
			InventoryItem.ITEM_GRADES[i.grade]
		]
	return text

# TODO: better experience formula
func get_rep_xp():
	return ordered_items.size()

func check_items(items : Array[Item]):
	if items.size() == ordered_items.size():
		var correct := true
		for i in items:
			for j in ordered_items:
				if not i.qualifies_as(j):
					correct = false
					break
		return correct
	return false

func get_payment(items : Array[Item]):
	var payment := 0
	for i in items:
		for j in ordered_items:
			if i.qualifies_as(j):
				var quality_diff := ((i.tier-j.tier)+(i.grade-j.grade)+1)
				payment += j.get_actual_value() * 1.2 * quality_diff
	return payment
#func remove_label():
	#if get_child_count() > 0:
		#var amount_label : Label = get_child(0)
		#remove_child(amount_label)
		#amount_label.queue_free()
# PRIVATE METHODS


# SUBCLASSES


