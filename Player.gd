extends Area2D

signal pickup
signal hurt

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 10, screensize.x - 20)
	position.y = clamp(position.y, 100, screensize.y - 20)
	
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"
#	pass

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	
func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)


func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup", "coin")
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()
