extends PanelContainer

#@export var item : Item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print(item.name)
	#item.image.set_pixelv(Vector2i(31, 29), Color(0.1,0.9,1))
	# ALERT: debug stuff, remove later
	#$TextureRect.texture = item.image_texture
	#$TextureRect.texture = PersistentData.game_data.get_discovered_form_texture("Longsword")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
