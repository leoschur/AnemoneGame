extends Area2D


func _on_body_entered(_body: Node2D) -> void:
    SignalBus.anemome_entered.emit()


func _on_body_exited(_body: Node2D) -> void:
    SignalBus.anemone_exited.emit()
