extends CharacterBody2D


const SPEED = 80.0
var health = 20

func _ready() -> void:
	velocity.x = SPEED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not $RayCast2D.is_colliding() or not $RayCast2D2.is_colliding():
		velocity.x *= -1
		$Timer.stop()
		$Timer.start()
	if velocity.x == 0:
		velocity.x = SPEED
	move_and_slide()
	
	for player in get_tree().get_nodes_in_group("player"):
		if $Area2D.overlaps_body(player):
			if player.dmg_lock == 0.0:
				player.take_damage(10)
				player.dmg_lock = 0.5

func _on_timer_timeout() -> void:
	velocity.x *= -1

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		self.queue_free()
