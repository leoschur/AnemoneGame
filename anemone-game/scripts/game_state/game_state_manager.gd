extends Node

var trash_carried := 0
var trash_on_map := 0
var anemone_protecting_count := 0
var current_micro_plastic_pollution := 0
var max_micro_plastic_pollution := 5


func _ready() -> void:
	SignalBus.trash_collected.connect(_on_trash_collected)
	SignalBus.trash_dropped.connect(_on_trash_dropped)
	SignalBus.trash_decayed.connect(_on_trash_decayed)
	SignalBus.anemome_entered.connect(_on_anemone_entered)
	SignalBus.anemone_exited.connect(_on_anemone_exited)


func is_player_carrying_trash() -> bool:
	return trash_carried > 0


func _on_trash_collected(_trash: Trash):
	trash_carried += 1


func _on_trash_dropped():
	trash_carried = 0


func _on_anemone_entered():
	if anemone_protecting_count < 1:
		SignalBus.protection_gained.emit()
	anemone_protecting_count += 1


func _on_anemone_exited():
	anemone_protecting_count -= 1
	if anemone_protecting_count == 0:
		SignalBus.protection_lost.emit()


func _on_trash_decayed():
	current_micro_plastic_pollution += 1
	SignalBus.microplastics_pollution_changed.emit()
	if current_micro_plastic_pollution >= max_micro_plastic_pollution:
		print('YOU LOST')
