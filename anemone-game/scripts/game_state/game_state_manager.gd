extends Node

signal trash_dropped()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('GameStateManager ready')


func trash_collected():
	print('trash collected')


func drop_trash():
	print('trash dropped')
	trash_dropped.emit()
