extends CharacterBody2D

@export var speed = 50
@export var follow_range = 100
@export var damage_interval : float = 1.0  # Interval de temps en secondes
@export var damage_amount : int = 10
var damage_timer : float = 0.0
var stop_direction : int
var is_moving : bool = false
var animations : AnimationPlayer

# Player
@export var player : Node2D

func _ready():
	animations = $AnimationBoss

func _process(_delta):
	if player and global_position.distance_to(player.global_position) < follow_range:
		move_towards_player()

		# Vérifier si le joueur est à une distance de 10 du monstre
		if global_position.distance_to(player.global_position) < 60:
			# Gérer les dégâts par seconde
			damage_timer += _delta
			if damage_timer >= damage_interval:
				player.take_damage(damage_amount)  # Infliger des dégâts au joueur
				damage_timer = 0.0  # Réinitialiser le timer
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
