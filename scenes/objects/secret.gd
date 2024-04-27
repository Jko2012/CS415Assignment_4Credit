extends TileMap

var found: bool = false
var opacity: float = 1.0

func _on_area_2d_body_entered(_body):
	found = true

func _process(_delta):
	if (found):
		modulate = modulate.lerp(Color(1, 1, 1, 0), 0.2)
	if (modulate == Color(1, 1, 1, 0)):
		queue_free()
