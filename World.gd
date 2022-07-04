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
	
	#Setup the ui elements
	var disposable_bird = bird.instance()
	$SidePanel/Grid/cohesion_slider.value = disposable_bird.cohesion_force
	$SidePanel/Grid/cohesion_label.text = str(disposable_bird.cohesion_force)
	$SidePanel/Grid/cohesion_distance_slider.value = disposable_bird.cohesion_distance
	$SidePanel/Grid/cohesion_distance_label.text = str(disposable_bird.cohesion_distance)
	$SidePanel/Grid/seperation_slider.value = disposable_bird.seperation_force
	$SidePanel/Grid/seperation_label.text = str(disposable_bird.seperation_force)
	$SidePanel/Grid/align_slider.value = disposable_bird.alignment_force
	$SidePanel/Grid/align_label.text = str(disposable_bird.alignment_force)
	$SidePanel/Grid/origin_slider.value = disposable_bird.origin_force
	$SidePanel/Grid/origin_label.text = str(disposable_bird.origin_force)
	
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
		b.alive = true
		b.fellow_birds = birds
		b.distance_matrix = distance_matrix

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	compute_distance_matrix()
	
func make_bird(debug_me):
	
	var b = bird.instance()
	var x = rng.randf_range(-spawn_range, spawn_range)
	var z = rng.randf_range(-spawn_range, spawn_range)
	var y = rng.randf_range(-spawn_range, spawn_range)

	b.debug_me = debug_me
	b.distance_key = len(birds)
	birds.append(b)
	b.translation = Vector3(x,y,z)
	b.fellow_birds = birds
	b.distance_matrix = distance_matrix

	compute_distance_matrix()
	add_child(b)

	
func init_distance_matrix():
	#First make sure the array is the right size
	distance_matrix = []
	for i in number_of_birds:
		var row = []
		for j in number_of_birds:
			row.append(0)
			
		distance_matrix.append(row)
	
func compute_distance_matrix():
	
	if len(distance_matrix) < len(birds):
		expand_distance_matrix()
		
	if len(distance_matrix) > len(birds):
		reduce_distance_matrix()
	
	for i in len(birds):
		for j in range(i, len(birds)):
			#Compute the distance between this bird j and bird i
			if birds[i] == birds[j]:
				continue
			
			var d = birds[i].global_transform.origin.distance_to(birds[j].global_transform.origin)
			
			#store in the distance matrix
			distance_matrix[i][j] = d
			distance_matrix[j][i] = d

func expand_distance_matrix():
	
	for row in distance_matrix:
		row.append(0)
	
	var new_len = len(distance_matrix) + 1
	var row = [0]
	row.resize(new_len)
	
	distance_matrix.append(row)
	
func reduce_distance_matrix():
	
	for row in distance_matrix:
		row = row.slice(0,-2)
		
	distance_matrix = distance_matrix.slice(0,-2)
	
func _on_cohesion_slider_value_changed(value):
	for b in birds:
		b.cohesion_force = value
	$SidePanel/Grid/cohesion_label.text = str(value)

func _on_seperation_slider_value_changed(value):
	for b in birds:
		b.seperation_force = value
	$SidePanel/Grid/seperation_label.text = str(value)

func _on_align_slider_value_changed(value):
	for b in birds:
		b.alignment_force = value
	$SidePanel/Grid/align_label.text = str(value)

func _on_origin_slider_value_changed(value):
	for b in birds:
		b.origin_force = value
	$SidePanel/Grid/origin_label.text = str(value)

func _on_cohesion_distance_slider_value_changed(value):
	for b in birds:
		b.cohesion_distance = value
	$SidePanel/Grid/cohesion_distance_label.text = str(value)

func _on_add_button_pressed():
	make_bird(true)

func _on_remove_button_pressed():
	if len(birds) <= 0:
		return
	
	birds[-1].queue_free()
	birds = birds.slice(0,-2)
	reduce_distance_matrix()


func _on_reset_button_pressed():
	for b in birds:
		var x = rng.randf_range(-spawn_range, spawn_range)
		var z = rng.randf_range(-spawn_range, spawn_range)
		var y = rng.randf_range(-spawn_range, spawn_range)
		b.translation = Vector3(x,y,z)
