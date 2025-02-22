extends RigidBody2D

var movement_force = 10000 # Driving Torque
const MAX_SPEED = 100 # Speed Limit

# Forklift Arm Constants
const MIN_ANGLE = deg_to_rad(-4)
const MAX_ANGLE = deg_to_rad(-2)
const P_GAIN = 500000.0
const D_GAIN = 50.0
const PLAYER_TORQUE = 7000
var previous_error = 0.0

# Forklift Component Nodes
var arm
var wheel1
var wheel2

# Called when the node enters the scene tree for the first time.
func _ready():
	arm = $Arm
	wheel1 = $"Wheel 1"
	wheel2 = $"Wheel 2"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state) -> void:
	var velocity = state.get_linear_velocity()
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
		state.set_linear_velocity(velocity)

func _physics_process(delta):
	var input = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		#input.x += 1
		wheel1.apply_torque(movement_force)
		wheel2.apply_torque(movement_force)
	if Input.is_action_pressed("move_left"):
		#input.x -= 1
		wheel1.apply_torque(-movement_force)
		wheel2.apply_torque(-movement_force)
	
	#apply_force(input.normalized() * movement_force)
	
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
