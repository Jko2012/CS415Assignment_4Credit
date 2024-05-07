extends Area2D

@onready var real_speed = $"../..".speed
@onready var real_speed_scale = $"../..".speed_scale
@onready var platform = $"../.."
@onready var path = $"../../PathFollow2D"
@onready var animation = $"../../AnimationPlayer"

enum States {MOVING, NOT_MOVING}
var state = States.NOT_MOVING
var next_state = States.NOT_MOVING
var player_check = false

# Called when the node enters the scene tree for the first time.
func _ready():
	platform.speed = 0
	platform.speed_scale = 0

func _process(_delta):
	if !player_check:
		if state == States.MOVING:
			if state != next_state:
				platform.speed = 0
				platform.speed_scale = 0
				player_check = true
				update_movement(2.0)
		elif state == States.NOT_MOVING:
			if state != next_state:
				platform.speed = real_speed
				platform.speed_scale = real_speed_scale
				player_check = true
				update_movement(0.5)
	

func update_movement(wait_time):
	await get_tree().create_timer(wait_time).timeout
	if state != next_state:
		platform._ready()
		state = next_state
	player_check = false


func _on_player_hitbox_area_entered(_area):
	next_state = States.MOVING


func _on_player_hitbox_area_exited(_area):
	next_state = States.NOT_MOVING
