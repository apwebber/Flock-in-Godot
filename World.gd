extends Spatial

export var number_of_birds = 10
export var spawn_range = 10
export var gravity = 9.81
# Declare member variables here. Examples:
var birds: Array
var bird = preload("res://Bird.tscn")
var rng = RandomNumberGenerator.new()
var distance_matrix: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	
	rng.randomize()
	
	for i in number_of_birds:
		var b = bird.instance()
		var x = rng.randf_range(-spawn_range, spawn_range)
		var z = rng.randf_range(-spawn_range, spawn_range)
		var y = rng.randf_range(-spawn_range, spawn_range)
		
		b.translation = Vector3(x,y,z)
		birds.append(b)
		b.distance_key = i
		add_child(b)
	
	init_distance_matrix()
	compute_distance_matrix()
	
	for b in birds:
		b.fellow_birds = birds
		b.distance_matrix = distance_matrix

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	compute_distance_matrix()

func init_distance_matrix():
	#First make sure the array is the right size
	distance_matrix = []
	for i in number_of_birds:
		var row = []
		for j in number_of_birds:
			row.append(0)
			
		distance_matrix.append(row)
	
func compute_distance_matrix():

	for i in number_of_birds:
		for j in range(i, number_of_birds):
			#Compute the distance between this bird j and bird i
			
			if birds[i] == birds[j]:
				continue
			
			var d = birds[i].global_transform.origin.distance_to(birds[j].global_transform.origin)
			
			#store in the distance matrix
			distance_matrix[i][j] = d
			distance_matrix[j][i] = d
	
