extends CharacterBody2D

# Monster
@export var speed = 50
@export var follow_range = 100
var animations : AnimationPlayer
var stop_direction : int
var is_moving : bool = false

# Player
@export var player : Node2D

func _ready():
	animations = $AnimationBoss

func _process(_delta):
	if player and global_position.distance_to(player.global_position) < follow_range:
		move_towards_player()
	else:
		velocity = Vector2.ZERO  # Arrêter le mouvement

	move_and_slide()
	update_animation()

func move_towards_player():
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func update_animation():
	is_moving = velocity != Vector2.ZERO

	if is_moving:
		var animation_name = get_animation_direction()
		animations.play("walk_" + animation_name)
	else:
		# Le joueur n'est pas dans la zone de suivi, donc le monstre danse
		animations.play("stop_dance")

func get_animation_direction():
	var abs_velocity = velocity.abs()

	if abs_velocity.x > abs_velocity.y:
		if velocity.x < 0:
			stop_direction = 1
			return "left"
		elif velocity.x > 0:
			stop_direction = 2
			return "right"
	else:
		if velocity.y < 0:
			stop_direction = 3
			return "up"
		elif velocity.y > 0:
			stop_direction = 4
			return "down"
