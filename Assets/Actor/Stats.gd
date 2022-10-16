extends Node

class_name CharacterStats

var current_level:int
var current_health:float
var current_mana:float
var max_health:int setget set_max_health
var max_mana:int setget set_max_mana
var attack:int
var defense:int
var dexterity:int
var speed:int
var vitality:int
var wisdown:int

var health_min_scale:int
var mana_min_scale:int
var attack_min_scale:int
var defense_min_scale:int
var dexterity_min_scale:int
var speed_min_scale:int
var vitality_min_scale:int
var wisdown_min_scale:int

var health_max_scale:int
var mana_max_scale:int
var attack_max_scale:int
var defense_max_scale:int
var dexterity_max_scale:int
var speed_max_scale:int
var vitality_max_scale:int
var wisdown_max_scale:int

var health_bonus_scale:int
var mana_bonus_scale:int
var attack_bonus_scale:int
var defense_bonus_scale:int
var dexterity_bonus_scale:int
var speed_bonus_scale:int
var vitality_bonus_scale:int
var wisdown_bonus_scale:int

var current_xp:int
var next_level_xp:int
var xp_scale:int = 100

var regen_health:float
var regen_mana:float
var attack_multiplier:float
var attack_speed:float
var velocity:float

func initialize(stats: CharacterBaseStats):
	max_health = stats.health
	max_mana = stats.mana
	attack = stats.attack
	defense = stats.defense
	dexterity = stats.dexterity
	speed = stats.speed
	vitality = stats.vitality
	wisdown = stats.wisdown
	health_min_scale = stats.health_min_scale
	mana_min_scale = stats.mana_min_scale
	attack_min_scale = stats.attack_min_scale
	defense_min_scale = stats.defense_min_scale
	dexterity_min_scale = stats.dexterity_min_scale
	speed_min_scale = stats.speed_min_scale
	vitality_min_scale = stats.vitality_min_scale
	wisdown_min_scale = stats.wisdown_min_scale
	health_max_scale = stats.health_max_scale
	mana_max_scale = stats.mana_max_scale
	attack_max_scale = stats.attack_max_scale
	defense_max_scale = stats.defense_max_scale
	dexterity_max_scale = stats.dexterity_max_scale
	speed_max_scale = stats.speed_max_scale
	vitality_max_scale = stats.vitality_max_scale
	wisdown_max_scale = stats.wisdown_max_scale
	health_bonus_scale = stats.health_bonus_scale
	mana_bonus_scale = stats.mana_bonus_scale
	attack_bonus_scale = stats.attack_bonus_scale
	defense_bonus_scale = stats.defense_bonus_scale
	dexterity_bonus_scale = stats.dexterity_bonus_scale
	speed_bonus_scale = stats.speed_bonus_scale
	vitality_bonus_scale = stats.vitality_bonus_scale
	wisdown_bonus_scale = stats.wisdown_bonus_scale
	yield(get_tree().create_timer(0.1), "timeout")
	stats_change()

func gain_experience(amount: int):
	current_xp = amount
	while current_xp >= next_level_xp:
		current_xp -= next_level_xp
		level_up()

func level_up():
	if (current_level % 5) == 0:
		max_health += health_bonus_scale
		max_mana += mana_bonus_scale
		attack += attack_bonus_scale
		defense += defense_bonus_scale
		dexterity += dexterity_bonus_scale
		speed += speed_bonus_scale
		vitality += vitality_bonus_scale
		wisdown += wisdown_bonus_scale
	else:
		max_health += int(rand_range(float(health_min_scale), float(health_max_scale)))
		max_mana += int(rand_range(float(mana_min_scale), float(mana_max_scale)))
		attack += int(rand_range(float(attack_min_scale), float(attack_max_scale)))
		defense += int(rand_range(float(defense_min_scale), float(defense_max_scale)))
		dexterity += int(rand_range(float(dexterity_min_scale), float(dexterity_max_scale)))
		speed += int(rand_range(float(speed_min_scale), float(speed_max_scale)))
		vitality += int(rand_range(float(vitality_min_scale), float(vitality_max_scale)))
		wisdown += int(rand_range(float(wisdown_min_scale), float(wisdown_max_scale)))
	stats_change()

func stats_change():
	if current_level >= 20:
		return
	current_level += 1
	next_level_xp += xp_scale
	current_health = max_health
	current_mana = max_mana
	regen_health = 0.2 + 10 * (float(vitality) / 50)
	regen_mana = 0.2 + 5 * (float(wisdown) / 50)
	attack_multiplier = 0.75 + 1.5 *(float(attack) / 70)
	attack_speed = 1/(1 + 5 * (float(dexterity) / 70))
	velocity = 2 + 10 * (float(speed) / 50)
	GlobalSignals.emit_signal("health_changed", current_health)
	GlobalSignals.emit_signal("mana_changed", current_mana)
	GlobalSignals.emit_signal("attack_change", attack_multiplier)
	GlobalSignals.emit_signal("dexterity_change", attack_speed)
	GlobalSignals.emit_signal("velocity_change", velocity)

func take_damage(amount: float):
	var damage
	var percent_damage := amount * 0.1
	if (amount - defense) >= percent_damage:
		damage = amount - defense
		current_health -= damage
	else:
		damage = percent_damage
		current_health -= damage
	current_health = clamp(current_health, 0, max_health)
	GlobalSignals.emit_signal("health_changed", current_health)
	GlobalSignals.emit_signal("damage_receive", damage)
	if current_health == 0:
		GlobalSignals.emit_signal("on_death")

func heal(amount: float):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	GlobalSignals.emit_signal("health_changed", current_health)
	GlobalSignals.emit_signal("health_recover", amount)

func mana_heal(amount: float):
	current_mana += amount
	current_mana = clamp(current_mana, 0, max_mana)
	GlobalSignals.emit_signal("health_changed", current_mana)
	GlobalSignals.emit_signal("mana_recover", amount)

func regen():
	current_health += regen_health
	current_mana += regen_mana
	current_health = clamp(current_health, 0, max_health)
	current_mana = clamp(current_mana, 0, max_mana)
	GlobalSignals.emit_signal("health_changed", current_health)
	GlobalSignals.emit_signal("mana_changed", current_mana)

func set_max_health(value: int):
	max_health = max(0, value)

func set_max_mana(value: int):
	max_mana = max(0, value)

func _on_Regen_timeout():
	regen()
