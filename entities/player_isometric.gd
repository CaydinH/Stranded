extends CharacterBody2D


const SPEED = Vector2(5, 5)



func _physics_process(delta: float) -> void:
	move()


func move():
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction == Vector2(-1,0): #Left
		velocity = Vector2(-20,-10)*SPEED
	elif direction == Vector2(1,0): #Right
		velocity = Vector2(20,10)*SPEED
	elif direction == Vector2(0,-1): #Up
		velocity = Vector2(20,-10)*SPEED
	elif direction == Vector2(0,1): #Down
		velocity = Vector2(-20,10)*SPEED
	else:
		self.velocity = Vector2.ZERO
	move_and_slide()
