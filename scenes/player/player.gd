extends CharacterBody2D

const BASE_SPEED = 500
const BASE_JUMP = -1000
const BASE_GRAVITY = 40

const SMALL_SPEED = 300
const SMALL_JUMP = -1000
const SMALL_GRAVITY = 40

@export_range(1, 2) var player_id: int = 1
@export var flight: bool = false
@export var can_jump: bool = false
@export var can_shrink: bool = false

var speed
var jumpforce
var gravity
var move_left
var move_right
var move_up
var move_down
var is_shrunk

func _ready():
	speed = BASE_SPEED
	jumpforce = BASE_JUMP
	gravity = BASE_GRAVITY
	move_left = "move_left_player" + str(player_id)
	move_right = "move_right_player" + str(player_id)
	move_up = "move_up_player" + str(player_id)
	move_down = "move_down_player" + str(player_id)
	is_shrunk = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (!flight):
		movement()
	else:
		if Input.is_action_just_pressed("scroll_up"):
			speed += 50
		if Input.is_action_just_pressed("scroll_down"):
			speed -= 50
		
		var direction = Input.get_vector(move_left, move_right, move_up, move_down)
		velocity = direction * speed
		
	move_and_slide()
	velocity.x = lerp(velocity.x, 0.0, 0.3)

func movement():
	if Input.is_action_pressed(move_right):
		velocity.x = speed
	if Input.is_action_pressed(move_left):
		velocity.x = -speed
	if Input.is_action_just_pressed(move_up) and is_on_floor() and can_jump:
		velocity.y = jumpforce
	if Input.is_action_just_pressed(move_down) and can_shrink:
		if is_shrunk:
			grow_player()
		else:
			shrink_player()
	
	velocity.y += gravity


func shrink_player():
	is_shrunk = true
	scale = scale * 0.5
	speed =  SMALL_SPEED
	jumpforce = SMALL_JUMP
	gravity = SMALL_GRAVITY

func grow_player():
	is_shrunk = false
	scale = scale * 2
	speed = BASE_SPEED
	jumpforce = BASE_JUMP
	gravity = BASE_GRAVITY

func collect_shrink():
	can_shrink = true

func collect_jump():
	can_jump = true
