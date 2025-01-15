extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0
var dmg_lock = 0.5
var jump_lock = 0.0

@export var stats = {
	"health": 140,
	"max_health": 140,
	"jumps": 2,
	"atk_dmg": 20,
}

func _ready() -> void:
	$laser_gun.visible = false

func _physics_process(delta: float) -> void:
	dmg_lock = max(dmg_lock-delta, 0.0)
	jump_lock = max(jump_lock-delta, 0.0)
	print(jump_lock)
	
	if $RayCastRight.is_colliding() or $RayCastLeft.is_colliding():
		stats.jumps = 2
		if Input.is_action_just_pressed("jump"):
			jump_lock = 0.25
		if jump_lock == 0:
			velocity.y = 0.5
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		stats.jumps = 2
	
	if Input.is_action_just_pressed("jump") and stats.jumps >= 1:
		velocity.y = JUMP_VELOCITY
		stats.jumps -= 1
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
	
	
	if Input.is_action_just_pressed("esc"):
		if not $menu.visible:
			$menu.visible = true
			get_tree().paused = true
		else:
			$menu.visible = false
			get_tree().paused = false

	
	
	move_and_slide()
	

func pickup_health(value):
	stats.health += value
	stats.health = clamp(stats.health, 0, stats.max_health)

func take_damage(dmg):
	stats.health -= dmg
	if stats.health <= 0:
		$deathScreen.visible = true
		get_tree().paused = true
