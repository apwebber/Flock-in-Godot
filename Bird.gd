extends KinematicBody


# Declare member variables here. Examples:
var position = Vector3()
var forward_velocity = Vector3(0,0,0)

export var velocity_magnitude = 50.0
export var seperation_force = 5.0
export var seperation_distance = 3.0
export var cohesion_force = 5.0
export var origin_force = 1.0

var fellow_birds: Array
var bird_distances: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Find nearest neighbour
	find_distances()
	var b = find_nearest()
	#Zero velocity
	#forward_velocity = Vector3(0,0,0)
	#Add seperation, attraction and alignment
	seperation(b)
	cohesion(b)
	attract_to_origin()
	
	#Look in the right direction
	look_at(global_transform.origin - forward_velocity, Vector3.UP)
	#Actually move
	move_and_slide(forward_velocity.normalized()*velocity_magnitude)
	
func attract_to_origin():
	#All birds should be attracted to the origin so they don't just fly off into space
	var v1 = Vector3(0,0,0) - global_transform.origin
	forward_velocity += v1.normalized() * origin_force
	
func seperation(nearest_bird):
	if nearest_bird == null:
		return
	
	if bird_distances[nearest_bird] > seperation_distance:
		return
	
	var v1 = nearest_bird.global_transform.origin - global_transform.origin
	forward_velocity -= v1.normalized() * seperation_force
	
func cohesion(nearest_bird):
	if nearest_bird == null:
		return
	
	var v1 = nearest_bird.global_transform.origin - global_transform.origin
	forward_velocity += v1.normalized() * cohesion_force

func find_distances():
	#The distance between the birds and this bird is used often so do this once
	bird_distances = {}
	for b in fellow_birds:
		
		if b == self:
			continue
		
		var d = global_transform.origin.distance_to(b.global_transform.origin)
		bird_distances[b] = d
	
func find_nearest():
	var distance = null
	var nearest = null
	var d = null
	
	for b in fellow_birds:
		
		if b == self:
			continue
		
		d = bird_distances[b]
		
		if distance == null:
			distance = d
			nearest = b
		elif d < distance:
			distance = d
			nearest = b
	
	return nearest
