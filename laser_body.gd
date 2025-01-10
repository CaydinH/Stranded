extends Node2D
@onready var projectile = load("res://projectile.tscn")

func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("left_click"):
		shoot()

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	get_tree().get_root().call_deferred("add_child", instance)
