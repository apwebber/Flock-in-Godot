extends KinematicBody


# Declare member variables here. Examples:
var position = Vector3()
var forward_velocity = Vector3(0,0,0)

export var velocity_magnitude = 25.0
export var seperation_force = 4.8
export var seperation_distance = 5
export var cohesion_force = 1.2
export var cohesion_distance = 10
export var origin_force = 0.1
export var alignment_force = 3.0



var fellow_birds: Array
var distance_matrix: Array
var distance_key: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	forward_velocity = Vector3(0,0,0)
	
	#Find nearest neighbour
	seperation()
	cohesion()
	align()
	attract_to_origin()
	
	#Look in the right direction
	look_at(global_transform.origin - forward_velocity, Vector3.UP)
	#Actually move
	move_and_slide(forward_velocity.normalized()*velocity_magnitude)
	
func attract_to_origin():
	#All birds should be attracted to the origin so they don't just fly off into space
	var v1 = Vector3(0,0,0) - global_transform.origin
	forward_velocity += v1.normalized() * origin_force
	
func seperation():
	
	var repulse: float
	var v1: Vector3
	var d: float
	
	#For every bird, repulse based on the inverse distance
	
	for b in fellow_birds:
		if b == self:
			continue
		
		d = distance_matrix[distance_key][b.distance_key]
		if d > seperation_distance:
			continue
		
		v1 = b.global_transform.origin - global_transform.origin
		forward_velocity -= v1.normalized() * seperation_force * (1/d)
	
func cohesion():
	
	var v1: Vector3
	var d: float
	
	for b in fellow_birds:
		if b == self:
			continue
		
		d = distance_matrix[distance_key][b.distance_key]
		if d > cohesion_distance:
			continue
		
		v1 = b.global_transform.origin - global_transform.origin
		forward_velocity += v1.normalized() * cohesion_force * (1/d)

func align():
	var v1: Vector3
	var d: float
	
	for b in fellow_birds:
		if b == self:
			continue
		
		d = distance_matrix[distance_key][b.distance_key]
		if d > cohesion_distance:
				continue
				
		forward_velocity += b.forward_velocity.normalized() * alignment_force * (1/d)
		
#func find_nearest():
#	var distance = null
#	var nearest = null
#	var d = null
#
#	for b in fellow_birds:
#
#		if b == self:
#			continue
#
#		d = bird_distances[b]
#
#		if distance == null:
#			distance = d
#			nearest = b
#		elif d < distance:
#			distance = d
#			nearest = b
#
#	return nearest
