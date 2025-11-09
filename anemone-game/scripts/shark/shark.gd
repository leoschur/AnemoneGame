extends Node2D

@export var acceleration: float
@export var maxSpeed: float

@export var next_position_timer: Timer

@export var fish: Fish

var map_size: Vector2

var target: Player
var random_point: Vector2
#var hunt: bool = true

func _process(_delta):	
	if not target.is_hidden:
		if not next_position_timer.is_stopped():
			next_position_timer.stop()
		fish.target_position = target.global_position
	elif next_position_timer.is_stopped():
		_target_random_point_on_map()
		next_position_timer.wait_time = 0
		next_position_timer.start()


func _target_random_point_on_map():
	random_point = Vector2(randf_range(0.0, map_size.x), randf_range(0.0, map_size.y))
	fish.target_position = random_point


func _on_random_clock_timeout() -> void:
	_target_random_point_on_map()
