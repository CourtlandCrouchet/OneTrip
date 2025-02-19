extends RigidBody2D

var movement_force = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
		
	#if Input.is_action_pressed("rotate_left"):
		#$Arm.apply_torque(-1000)
	#elif Input.is_action_pressed("rotate_right"):
		#$Arm.apply_torque(1000)
	#else:
		#$Arm.angular_velocity *= 0.9
		
	
	apply_force(input.normalized() * movement_force)
