extends Node

var trash_carried := 0
var trash_on_map := 0
var anemone_protecting_count := 0
var current_micro_plastic_pollution := 0
var max_micro_plastic_pollution := 5


func _ready() -> void:
	SignalBus.trash_collected.connect(on_trash_collected)
	SignalBus.trash_dropped.connect(on_trash_dropped)
	SignalBus.trash_decayed.connect(on_trash_decayed)
	SignalBus.anemome_entered.connect(on_anemone_entered)
	SignalBus.anemone_exited.connect(on_anemone_exited)


func is_player_carrying_trash() -> bool:
	return trash_carried > 0


func on_trash_collected():
	trash_carried += 1

func on_trash_dropped():
	trash_carried = 0

func on_anemone_entered():
	if anemone_protecting_count < 1:
		SignalBus.protection_gained.emit()
	anemone_protecting_count += 1

func on_anemone_exited():
	anemone_protecting_count -= 1
	if anemone_protecting_count == 0:
		SignalBus.protection_lost.emit()


func on_trash_decayed():
	current_micro_plastic_pollution += 1
	SignalBus.microplastics_pollution_changed.emit()
	if current_micro_plastic_pollution >= max_micro_plastic_pollution:
		print('YOU LOST')
