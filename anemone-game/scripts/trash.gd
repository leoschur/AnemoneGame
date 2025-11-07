extends Area2D

signal collided_with_player()

func _ready() -> void:
	print('Trash!!!')


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			print('ESCAPE')


func _on_body_entered(body: Node2D) -> void:
	print('body entered: ' + body.to_string())
	collided_with_player.emit()


func _on_area_entered(area: Area2D) -> void:
	print('area entered: ' + area.to_string())
