extends MeshInstance


func shoot():
	$MeshInstance.show()
	$Timer.start(0.1)


func _on_Timer_timeout() -> void:
	$MeshInstance.hide()
