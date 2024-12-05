extends Area2D

@export var speed = 400
signal hit
var screen_size
var animated_sprite 

func _ready():
	screen_size = get_viewport_rect()
	animated_sprite = $AnimatedSprite2D
	hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _process(_delta):
	basic_move(_delta)

func basic_move(delta):
	var velocity = Vector2.ZERO
	if(Input.is_action_pressed("move_right")):
		velocity.x += 1
	if(Input.is_action_pressed("move_left")):
		velocity.x -= 1
	if(Input.is_action_pressed("move_down")):
		velocity.y += 1
	if(Input.is_action_pressed("move_up")):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animated_sprite.play()
	else:
		animated_sprite.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size.end)
	
	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0
		
		


func _on_body_entered(body: Node2D):
	hide()
	hit.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)
