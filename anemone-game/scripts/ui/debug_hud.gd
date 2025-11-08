extends Control

func _ready() -> void:
	SignalBus.trash_spawned.connect(on_trash_spawned)
	SignalBus.trash_collected.connect(on_trash_collected)
	SignalBus.trash_dropped.connect(on_trash_dropped)
	SignalBus.microplastics_pollution_changed.connect(on_microplastics_pollution_changed)
	SignalBus.protection_gained.connect(on_protection_gained)
	SignalBus.protection_lost.connect(on_protection_lost)
	
	on_trash_spawned()
	on_trash_collected()
	on_protection_lost()
	on_microplastics_pollution_changed()


func on_trash_spawned():
	$VBoxContainer/TrashOnMapLabel.text = "Trash on Map: " + str(GameStateManager.trash_on_map)
	
	
func on_trash_collected():
	$VBoxContainer/TrashCollectedLabel.text = "Trash carried: " + str(GameStateManager.trash_carried)
	
	
func on_trash_dropped():
	$VBoxContainer/TrashOnMapLabel.text = "Trash on Map: " + str(GameStateManager.trash_on_map)
	$VBoxContainer/TrashCollectedLabel.text = "Trash carried: " + str(GameStateManager.trash_carried)


func on_microplastics_pollution_changed():
	$VBoxContainer/MicroplasticsPollutionLabel.text = "Microplastics Pollution: " + str(float(GameStateManager.current_micro_plastic_pollution) / float(GameStateManager.max_micro_plastic_pollution) * 100.0) + "%" 


func on_protection_gained():
	$VBoxContainer/SafeFromSharkLabel.text = "Protected"


func on_protection_lost():
	$VBoxContainer/SafeFromSharkLabel.text = "Not Protected"
