extends Node

var trash_carried := 0


func _ready() -> void:
	SignalBus.trash_collected.connect(on_trash_collected)
	SignalBus.trash_dropped.connect(on_trash_dropped)


func is_player_carrying_trash() -> bool:
	return trash_carried > 0


func on_trash_collected():
	trash_carried += 1

func on_trash_dropped():
	trash_carried -= 1
	if trash_carried < 0:
		trash_carried = 0
