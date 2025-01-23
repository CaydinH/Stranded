extends Node2D
@onready var projectile = load("res://menus-or-objects/projectile.tscn")
var cooldown : float
var can_shoot = true

func _physics_process(delta: float) -> void:
	cooldown = max(cooldown - delta, 0.0)
	if cooldown == 0.0:
		if Input.is_action_just_pressed("left_click"):
			shoot()
	look_at(get_global_mouse_position())

func shoot():
	if can_shoot == true:
		var instance = projectile.instantiate()
		instance.dir = rotation
		instance.spawnPos = global_position
		instance.spawnRot = rotation
		get_tree().get_root().call_deferred("add_child", instance)
		cooldown = 0.3
