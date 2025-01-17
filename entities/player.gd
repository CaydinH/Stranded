extends CharacterBody2D

#Global Variables
const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var dmg_lock : float
var jump_lock : float

@export var stats = {
	"health": 140,
	"max_health": 140,
	"jumps": 2,
	"atk_dmg": 20,
}

#State Machine
enum States {IDLE, WALKING, JUMPING, FALLING, ATTACKING, SLIDING, DEAD, PAUSED}
var state = States.IDLE

func _ready() -> void:
	$laser_gun.visible = false

func _physics_process(delta: float) -> void:
	dmg_lock = max(dmg_lock-delta, 0.0)
	jump_lock = max(jump_lock-delta, 0.0)
	$player_HUD/ProgressBar.max_value = stats.max_health
	$player_HUD/ProgressBar.value = stats.health
	$player_HUD/Label.text = str(stats.health)

	if state != States.DEAD and state != States.PAUSED:
		var direction := Input.get_axis("walk_left", "walk_right")
		if direction:
			state = States.WALKING
			velocity.x = direction * SPEED
			$AnimatedSprite2D.flip_h = direction < 0
		else:
			state = States.IDLE
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if not is_on_floor():
			state = States.JUMPING
			velocity += get_gravity() * delta
		else:
			stats.jumps = 2

		if Input.is_action_just_pressed("jump") and stats.jumps >= 1:
			state = States.JUMPING
			velocity.y = JUMP_VELOCITY
			stats.jumps -= 1

		if Input.is_action_just_pressed("esc"):
			if not $menu.visible:
				$menu.visible = true
				get_tree().paused = true
			else:
				$menu.visible = false
				get_tree().paused = false
		move_and_slide()
	match state:
		States.DEAD:
			OS.alert("Dead")
			get_tree().reload_current_scene()
		States.WALKING:
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("walk_right")
		States.JUMPING:
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("jump")
		States.FALLING:
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("jump")
		_:
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.play("idle")


func pickup_health(value):
	stats.health += value
	stats.health = clamp(stats.health, 0, stats.max_health)

func take_damage(dmg):
	stats.health -= dmg
	if stats.health <= 0:
		state = States.DEAD
