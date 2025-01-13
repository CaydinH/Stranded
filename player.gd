extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@export var stats = {
	"health": 100,
	"max_health": 100,
	"jumps": 2,
	"atk_dmg": 20,
}


 
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if $RayCastRight.is_colliding() or $RayCastLeft.is_colliding():
		velocity.y = 0.5
		stats.jumps = 2
	if not is_on_floor():
		velocity += get_gravity() * delta
		$RayCastRight.enabled = true
		$RayCastLeft.enabled = true
	
	if is_on_floor():
		stats.jumps = 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump") and stats.jumps >= 1:
		velocity.y = JUMP_VELOCITY
		stats.jumps -= 1
		$RayCastRight.enabled = false
		$RayCastLeft.enabled = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	if Input.is_action_pressed("shift"):
		velocity.x = direction*SPEED*1.7
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	$player_HUD/ProgressBar.max_value = stats.max_health
	$player_HUD/ProgressBar.value = stats.health
	$player_HUD/Label.text = str(stats.health)
	
	
	move_and_slide()
	

func pickup_health(value):
	stats.health += value
	stats.health = clamp(stats.health, 0, stats.max_health)
