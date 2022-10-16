tool
extends Node

class_name character

onready var stats = $Stats

export var base_character : Resource

func _ready():
	stats.initialize(base_character);
