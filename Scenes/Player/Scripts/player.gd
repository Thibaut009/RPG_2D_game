extends CharacterBody2D

@export var speed = 100
@export var health : int = 100
var stop_direction : int
var is_moving : bool = false
var health_bar : ProgressBar
var animations : AnimationPlayer

func _ready():
	animations = $AnimationPlayer
	health_bar = $ProgressBar

	health_bar.value = health

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_animation()

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
			_: animations.play("RESET")

func get_animation_direction() -> String:
	if Input.get_action_strength("move_left") == 1:
		stop_direction = 1
		return "left"
	elif Input.get_action_strength("move_right") == 1:
		stop_direction = 2
		return "right"
	elif Input.get_action_strength("move_up") == 1:
		stop_direction = 3
		return "up"
	elif Input.get_action_strength("move_down") == 1:
		stop_direction = 4
		return "down"
	else:
		stop_direction = 0
		return "down"

# Fonction pour réduire la vie du joueur
func take_damage(amount: int):
	health -= amount
	health_bar.value = health
	# Ajoutez ici la logique de vérification de la mort du joueur, si nécessaire
