extends CharacterBody2D


const SPEED = 200.0
const MAX_SPEED = 400.0
const JUMP_VELOCITY = -100.0

const PUSH_FORCE = 15.0
const MIN_PUSH_FORCE = 10.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Limit the overall velocity
	velocity = velocity.limit_length(MAX_SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print(collision.get_collider())
		if collision.get_collider() is RigidBody2D:
			var rb = collision.get_collider() as RigidBody2D
			var push_force = (PUSH_FORCE * velocity.length() / SPEED) + MIN_PUSH_FORCE
			rb.apply_central_force(-collision.get_normal() * push_force)
