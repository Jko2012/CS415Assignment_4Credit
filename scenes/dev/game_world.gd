extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_shrink_body_entered(_body):
	$Player1.collect_shrink()
	$Player2.collect_shrink()
	$Shrink_PU.queue_free()


func _on_jump_pu_body_entered(_body):
	$Player1.collect_jump()
	$Player2.collect_jump()
	$Jump_PU.queue_free()
