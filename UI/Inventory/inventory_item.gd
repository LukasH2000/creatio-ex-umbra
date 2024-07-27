# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order
# @TOOL
# CLASS_NAME
# EXTENDS
class_name InventoryItem extends TextureRect
# DOCSTRING

# SIGNALS


# ENUMS


# CONSTANTS
const item_tiers : Array[String] = [
	"MORTAL",
	"[color=green]PEAK MORTAL[/color]",
	"[color=blue]MAGICAL[/color]",
	"[color=red]DRACONIC[/color]",
	"[color=gold]DIVINE[/color]",
	"[color=plum]IMMORTAL[/color]"
]
const item_grades : Array[String] = ["F", "E", "D", "C", "B", "A", "S", "P"]

# EXPORTING PROPERTIES https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_exports.html
# @EXPORT_CATEGORY("name")
# @EXPORT_GROUP("name")
# @EXPORT_SUBGROUP("name")
# @EXPORT
@export var item : Item

# PUBLIC VARIABLES
var label_scene := preload("res://UI/Inventory/item_tooltip.tscn")

# PRIVATE VARIABLES


# @ONREADY VARIABLES


# OPTIONAL BUILT-IN VIRTUAL _INIT METHOD
# OPTIONAL BUILT-IN VIRTUAL _ENTER_TREE() METHOD
# BUILT-IN VIRTUAL _READY METHOD
# REMAINING BUILT-IN VIRTUAL METHODS
# PUBLIC METHODS
func _init(i : Item) -> void:
	item = i

func _ready() -> void:
	theme = load(PersistentData.THEME_PATH)
	if item:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_SCALE
		if item.image_texture == null: item.create_image_texture()
		texture = item.image_texture
		update_tooltip_and_label()
		

func _get_drag_data(at_position : Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_pos : Vector2) -> Control:
	var t_rect := TextureRect.new()
	t_rect.texture = texture
	t_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t_rect.stretch_mode = TextureRect.STRETCH_SCALE
	t_rect.custom_minimum_size = size
	t_rect.modulate.a = 0.5
	t_rect.position = Vector2(-at_pos)
	
	var c := Control.new()
	c.add_child(t_rect)
	
	return c

func update_tooltip_and_label():
	tooltip_text = "%s\nTier: %s\nGrade: %s\nValue: %s" % [
			item.name, 
			item_tiers[item.tier],
			item_grades[item.grade],
			item.get_actual_value()
		]
	if item.item_type == Item.ITEM_TYPE.MATERIAL:
		tooltip_text += "\nAmount: %s" % item.amount_held
		var amount_label : Label
		if get_child_count() > 0:
			amount_label = get_child(0)
		else:
			amount_label = Label.new()
			amount_label.add_theme_color_override("font_color", Color(0,0,0))
			add_child(amount_label)
		amount_label.text = "%s" % item.amount_held
	tooltip_text += "\n\n%s" % item.description
	_make_custom_tooltip(tooltip_text)

func _make_custom_tooltip(for_text):
	#var label := RichTextLabel.new()
	var label := label_scene.instantiate()
	#label.bbcode_enabled = true
	#label.visible = true
	#label.add_theme_font_size_override("normal_font_size", 12)
	#label.text = for_text
	label.text = for_text
	#label.fit_content = true
	label.custom_minimum_size = Vector2(128,1)
	#label.mouse_force_pass_scroll_events = false
	return label
# PRIVATE METHODS


# SUBCLASSES


