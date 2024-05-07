extends Area2D


func _on_area_entered(_area):
	Global.increase_health_max()
	queue_free()
