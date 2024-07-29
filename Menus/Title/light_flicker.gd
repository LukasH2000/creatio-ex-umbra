extends PointLight2D

const MAX_VAL := 10000000

var value := 0.0
var frequency := 0.01
var x := 1
var y := 1.0#4.0
var z := 0.1#0.5

@onready var noise := FastNoiseLite.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	value = randi() % MAX_VAL
	noise.frequency = frequency

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	noise.frequency = frequency
	value += 0.5
	if value > MAX_VAL:
		value = 0.0
	#var alpha := ((noise.get_noise_1d(value) + x)/y)+z
	var alpha := remap(noise.get_noise_1d(value), -1, 1, 0.75, 1.25)
	color = Color(color, alpha)
	
	
	
