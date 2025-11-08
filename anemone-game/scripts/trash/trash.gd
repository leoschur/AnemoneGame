extends Area2D

@export var lifetime_on_spawn := 30.0
var current_lifetime := 0.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	print('Trash ready')
	current_lifetime = lifetime_on_spawn + rng.randf_range(-2.0, 2.0)


func _on_body_entered(body: Node2D) -> void:
	print('body entered: ' + body.to_string())
	SignalBus.trash_collected.emit()
	queue_free()


func _process(delta: float) -> void:
	current_lifetime -= delta
	if current_lifetime <= 0:
		current_lifetime = 0.0
		decay()
	$TextureProgressBar.value = current_lifetime / lifetime_on_spawn * $TextureProgressBar.max_value


func decay():
	print("decay")
	SignalBus.trash_decayed.emit()
	queue_free()
