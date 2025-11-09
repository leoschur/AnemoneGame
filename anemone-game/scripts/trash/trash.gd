class_name Trash
extends Area2D


@export_category("Components")
@export var sprite_2d: Sprite2D
@export var texture_progress_bar: TextureProgressBar
@export var particles: CPUParticles2D

@export_category("Parameters")
@export var lifetime_on_spawn: float = 30.0
@export var lifetime_random_range: Vector2 = Vector2(0.0, 20.0)

# Variables
var full_lifetime: float
var current_lifetime: float
var _collected: bool = false
var _decayed: bool = false


func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	
	full_lifetime = lifetime_on_spawn + randf_range(lifetime_random_range.x, lifetime_random_range.y)
	current_lifetime = full_lifetime


func _on_body_entered(_body: Node2D) -> void:
	#print('Body entered: ' + body.name)
	_collected = true
	set_deferred("monitoring", false)
	SignalBus.trash_collected.emit(self)
	
	# Remove progress bar
	var tween: Tween = create_tween()
	tween.tween_property(texture_progress_bar, "modulate:a", 0.0, 0.4)
	tween.finished.connect((func(): self.queue_free()))


func _process(delta: float) -> void:
	if _collected or _decayed:
		return
	current_lifetime -= delta
	if current_lifetime <= 0:
		current_lifetime = 0.0
		decay()
	texture_progress_bar.value = remap(current_lifetime, 0.0, full_lifetime, 0.0, texture_progress_bar.max_value)


func decay():
	_decayed = true
	set_deferred("monitoring", false)
	# TODO: Sound
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, "modulate:a", 0.0, 1.0)
	SignalBus.trash_decayed.emit()
	particles.restart()
	particles.finished.connect((func(): self.queue_free()))
	
