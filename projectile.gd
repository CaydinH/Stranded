extends CharacterBody2D

@export var SPEED = 100

var dir : float
var spawnPos : Vector2
var spawnRot : float

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot

func _physics_process(delta: float) -> void:
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()

func _on_timer_timeout() -> void:
	self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("test")
	self.queue_free()
