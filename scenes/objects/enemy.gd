@tool
extends CharacterBody2D

const MAX_SPEED = 100
const MAX_GRAVITY = 24

@onready var marker = $Marker2D
@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D

#@export var flip_h: bool = false
#@export var flip_v: bool = false
@export_enum("Right:1", "Left:-1") var dir: int = 1:
	set(new_dir):
		dir = new_dir

@export_enum("Down:1", "Up:-1") var init_grav_dir: int = 1:
	set(new_grav):
		init_grav_dir = new_grav

@export_range(1, 30, 1) var distance: float = 1:
	set(new_distance):
		if Engine.is_editor_hint():
			distance = new_distance
			$Marker2D.position.x = distance * 8 * dir
			$Timer.wait_time = (distance * 8 * 3.5)/MAX_SPEED


var speed
var gravity
@onready var grav_dir = init_grav_dir

func _ready():
	if not Engine.is_editor_hint():
		if (dir == -1):
			sprite.flip_h = true
		if (grav_dir == -1):
			sprite.flip_v = true
			up_direction.y = 1
		speed = MAX_SPEED
		gravity = MAX_GRAVITY
		$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.is_editor_hint():
		game_process()

func game_process():
	velocity.y += gravity * grav_dir
	velocity.x = speed * dir
	
	move_and_slide()

func stop_and_flip():
	sprite.pause()
	speed = 0
	await get_tree().create_timer(0.2).timeout
	flip_direction()
	flip_gravity()
	await get_tree().create_timer(0.5).timeout
	sprite.play()
	speed = MAX_SPEED
	$Timer.start()

func flip_direction():
	sprite.flip_h = !sprite.flip_h
	dir *= -1

func flip_gravity():
	sprite.flip_v = !sprite.flip_v
	up_direction.y *= -1
	grav_dir *= -1 #lerp(0.0, up_direction.y, 0.3)

func _on_timer_timeout():
	stop_and_flip()


func _on_player_hitbox_area_entered(_area):
	pass # Replace with function body.
