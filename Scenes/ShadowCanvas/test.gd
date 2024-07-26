extends PanelContainer

@export var item : Item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#print(item.name)
	#item.image.set_pixelv(Vector2i(31, 29), Color(0.1,0.9,1))
	# ALERT: debug stuff, remove later
	item.create_image_texture()
	item.create_form()
	item.create_form_texture()
	#$TextureRect.texture = item.image_texture
	$TextureRect.texture = item.form_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
