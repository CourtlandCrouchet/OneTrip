extends RigidBody2D

var movement_force = 1000
const MIN_ANGLE = deg_to_rad(-90)
const MAX_ANGLE = deg_to_rad(-2)
const P_GAIN = 500000.0
const D_GAIN = 50.0
const PLAYER_TORQUE = 7000
var arm
var previous_error = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	arm = $Arm
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
	
	apply_force(input.normalized() * movement_force)
	
	if Input.is_action_pressed("rotate_left"):
		arm.apply_torque(-PLAYER_TORQUE)  # Rotate left
	elif Input.is_action_pressed("rotate_right"):
		arm.apply_torque(PLAYER_TORQUE)  # Rotate right
	else:
		arm.angular_velocity *= 0.9  # Add damping to prevent infinite spinning

	var error = 0.0
	#print("rotation = ", rad_to_deg(arm.rotation))
	if arm.rotation < MIN_ANGLE:
		#print("ANGLE TOO LOW")
		error = MIN_ANGLE - arm.rotation
		#arm.apply_torque(10000)
		#arm.rotation = MIN_ANGLE
	elif arm.rotation > MAX_ANGLE:
		#print("ANGLE TOO HIGH")
		#arm.rotation = MAX_ANGLE
		#arm.apply_torque(-10000)
		error = MAX_ANGLE - arm.rotation
	#print(rad_to_deg(arm.rotation))
	#print("error = ", error)
	# PD Control Calculation
	var p_term = error * P_GAIN  # Proportional term (stronger correction if farther)
	var d_term = ((error - previous_error) / delta) * D_GAIN  # Derivative term (damping)
	var torque = p_term + d_term
	#print("torque = ", torque)
	arm.apply_torque(p_term + d_term)
	previous_error = error
