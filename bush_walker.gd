extends CharacterBody2D


const SPEED = 100.0

func _ready() -> void:
	velocity.x = SPEED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not $RayCast2D.is_colliding():
		velocity.x *= -1
		$Timer.stop()
		$Timer.start()
	if velocity.x == 0:
		velocity.x = SPEED

	move_and_slide()


func _on_timer_timeout() -> void:
	velocity.x *= -1
