extends Node2D

class_name Weapon

export (PackedScene) var Bullet

onready var fire_point = $FirePoint
onready var fire_direction = $FireDirection
onready var attack_cooldown = $AttackCooldown

func _ready():
	GlobalSignals.connect("dexterity_change", self, "get_attack_cooldown")

func _process(delta):
	look_at(get_global_mouse_position())

func shoot():
	if !attack_cooldown.is_stopped() or Bullet == null:
		return
	var bullet_instance = Bullet.instance()
	var direction = (fire_direction.global_position - fire_point.global_position).normalized()
	GlobalSignals.emit_signal("bullet_fired", bullet_instance, fire_point.global_position, direction)
	attack_cooldown.start()

func get_attack_cooldown(time:float):
	attack_cooldown.wait_time = time
	print(time)
