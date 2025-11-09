class_name Shark
extends Node2D

@export var acceleration: float
@export var maxSpeed: float

@export var next_position_timer: Timer

@export var fish: Fish

var map_size: Vector2
var target: Player
var on_the_hunt: bool = true

func _process(_delta):
	if not on_the_hunt or not target:
		return
	if not target.is_hidden:
		if not next_position_timer.is_stopped():
			next_position_timer.stop()
		# FIXME maybe
		fish.target_position = target.fish.get_links().front().global_position
	elif next_position_timer.is_stopped():
		_target_random_point_on_map()
		next_position_timer.wait_time = 0
		next_position_timer.start()

func target_point(point: Vector2):
	fish.target_position = point

func _target_random_point_on_map():
	fish.target_position = Vector2(randf_range(0.0, map_size.x), randf_range(0.0, map_size.y))


func _on_random_clock_timeout() -> void:
	_target_random_point_on_map()
