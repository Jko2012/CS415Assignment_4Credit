extends Node


@export var single_player_mode:bool = true


var max_health = 3
var health_p1 = max_health
var health_p2 = max_health
var hud
var player_health = [max_health, max_health]

func enable_player_2():
	hud.show_p2_health()
	

func lose_health(player, player_id):
	player_health[player_id - 1] -= 1
	if player_health[player_id - 1] == 0:
		player_death(player, player_id)
	hud.update_health()

func player_death(player, player_id):
	player_health[player_id - 1] = max_health
	player.respawn()

func increase_health_max():
	max_health += 1
	player_health[0] = max_health
	player_health[1] = max_health
	hud.update_health()
