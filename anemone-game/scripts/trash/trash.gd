extends Area2D

func _ready() -> void:
	print('Trash ready')


func _on_body_entered(body: Node2D) -> void:
	print('body entered: ' + body.to_string())
	SignalBus.trash_collected.emit()
	queue_free()
