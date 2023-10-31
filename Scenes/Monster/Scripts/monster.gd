extends CharacterBody2D

@export var speed = 100
var animations : AnimationPlayer
var stop_direction : int
var is_moving : bool = false
var player : Node2D  # Assuming the player is a Node2D; adjust the type accordingly

func _ready():
	animations = $AnimationMonster
	randomize_movement()

func randomize_movement():
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

func _physics_process(_delta):
	move_towards_player()
	move_and_slide()
	update_animation()

func move_towards_player():
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		randomize_movement()

func update_animation():
	is_moving = velocity != Vector2.ZERO

	if is_moving:
		var animation_name = get_animation_direction()
		animations.play("walk_" + animation_name)
	else:
		match stop_direction:
			1: animations.play("stop_left")
			2: animations.play("stop_right")
			3: animations.play("stop_up")
			4: animations.play("stop_down")
			_: animations.play("stop_dance")

func get_animation_direction() -> String:
	if velocity.x < 0:
		stop_direction = 1
		return "left"
	elif velocity.x > 0:
		stop_direction = 2
		return "right"
	elif velocity.y < 0:
		stop_direction = 3
		return "up"
	elif velocity.y > 0:
		stop_direction = 4
		return "down"
	else:
		stop_direction = 0
		return "default"
