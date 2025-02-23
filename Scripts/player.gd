extends RigidBody2D

var movement_force = 10000 # Driving Torque
const MAX_SPEED = 100 # Speed Limit

# Forklift Component Nodes
var arm
var wheel1
var wheel2

# Called when the node enters the scene tree for the first time.
func _ready():
	arm = $Arm
	wheel1 = $"Wheel 1"
	wheel2 = $"Wheel 2"
	$AnimatedSprite2D.play("default")

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
