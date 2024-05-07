extends Control

func _ready():
	update_health()
	Global.hud = self
	$heartsFullP2.visible = false
	$heartsEmptyP2.visible = false


func update_health():
	$heartsFull.size.x = 53 * Global.player_health[0]
	$heartsEmpty.size.x = 53 * Global.max_health
	$heartsFullP2.size.x = 53 * Global.player_health[1]
	$heartsEmptyP2.size.x = 53 * Global.max_health

func show_p2_health():
	$heartsFullP2.visible = true
	$heartsEmptyP2.visible = true
