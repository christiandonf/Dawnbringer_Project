extends KinematicBody2D

onready var weapon = $Weapon
onready var player_sprite = $PlayerSprite
onready var walk_direction = $WalkDirection

var velocity_multiplier := 1.0

func _ready():
	GlobalSignals.connect("velocity_change", self, "get_velocity_multiplier")

func _physics_process(delta):
	var movement_direction	:= Vector2(
		Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left"),
		Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up")).normalized()
	if movement_direction.length() == 0:
		player_sprite.play("iddle")
	else:
		player_sprite.play("run")
		if movement_direction.x < 0:
			player_sprite.flip_h = true
		else:
			player_sprite.flip_h = false
	if Input.is_action_pressed("shoot"):
		weapon.shoot()
	move_and_slide(movement_direction * 32 * velocity_multiplier)
	walk_direction.look_at(movement_direction + global_position)

func get_velocity_multiplier(multiplier:float):
	velocity_multiplier = multiplier
	print(multiplier)
