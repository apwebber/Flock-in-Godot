extends RigidBody


# Declare member variables here. Examples:
var position = Vector3()
var forward_velocity = Vector3(1,0,0)

export var velocity_magnitude = 5.0
export var seperation_force = 1
export var seperation_distance = 1.0

var fellow_birds: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#First add velocity - fly forward
	add_central_force(forward_velocity)
	
	#Add seperation, attraction and alignment
	seperation()
	
	#Orient towards current vector
	#print(linear_velocity)
	
func seperation():
	#For every bird that is within a certain distance,
	#add a repulsive force
	for b in fellow_birds:
		if b == self:
			continue
			
		var distance = b.global_transform.origin.distance_to(global_transform.origin)
		
		if distance < seperation_distance:
			var f = b.global_transform.origin.direction_to(global_transform.origin)
			add_central_force(f.normalized() * seperation_force)

func look_follow(state, current_transform, target_position):
	var up_dir = Vector3(0, 1, 0)
	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
	var target_dir = (target_position - current_transform.origin).normalized()
	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)

	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))

func _integrate_forces(state):
	var target_position = fellow_birds[0].global_transform.origin
	look_follow(state, get_global_transform(), target_position)
