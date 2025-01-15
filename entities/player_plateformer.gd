extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -200.0
var jumps = 2

var bullet_scene

 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		velocity.y = 0.5
		jumps = 2
	if not is_on_floor():
		velocity += get_gravity() * delta
		$RayCast2D.enabled = true
	
	if is_on_floor():
		jumps = 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("Jump") and jumps >= 1:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
		$RayCast2D.enabled = false 
		
	elif Input.is_action_pressed("Jump") and jumps >= 1:
		velocity.y = JUMP_VELOCITY * 2
		jumps -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Walk_Left", "Walk_Right")
	if Input.is_action_pressed("Shift"):
		velocity.x = direction*SPEED*1.7
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$AnimatedSprite2D.flip_h = direction > 0
	
	if Input.is_action_just_pressed("ui_text_indent"):
		spawn_bullet()
	
	move_and_slide()

func spawn_bullet():
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
