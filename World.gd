extends Spatial

export var number_of_birds = 10
export var spawn_range = 1
export var gravity = 9.81
# Declare member variables here. Examples:
var birds: Array
var bird = preload("res://Bird.tscn")
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng.randomize()
	
	for i in number_of_birds:
		var b = bird.instance()
		var x = rng.randf_range(-spawn_range, spawn_range)
		var z = rng.randf_range(-spawn_range, spawn_range)
		var y = rng.randf_range(-spawn_range, spawn_range)
		
		b.translation = Vector3(x,y,z)
		#b.gravity_scale = gravity
		birds.append(b)
		add_child(b)
		
	for b in birds:
		b.fellow_birds = birds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
