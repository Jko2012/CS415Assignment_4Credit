extends CharacterBody2D

var SPEED = 500
var JUMPFORCE = -1000
var GRAVITY = 40

@export_range(1, 2) var player_id: int = 1
@export var flight: bool = false

var move_left
var move_right
var move_up
var move_down

func _ready():
	move_left = "move_left_player" + str(player_id)
	move_right = "move_right_player" + str(player_id)
	move_up = "move_up_player" + str(player_id)
	move_down = "move_down_player" + str(player_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (!flight):
		if Input.is_action_pressed(move_right):
			velocity.x = SPEED
		if Input.is_action_pressed(move_left):
			velocity.x = -SPEED
		if Input.is_action_just_pressed(move_up) and is_on_floor():
			velocity.y = JUMPFORCE
		velocity.y += GRAVITY
	else:
		if Input.is_action_just_pressed("scroll_up"):
			SPEED += 50
		if Input.is_action_just_pressed("scroll_down"):
			SPEED -= 50
		
		var direction = Input.get_vector(move_left, move_right, move_up, move_down)
		velocity = direction * SPEED
		
	move_and_slide()
	velocity.x = lerp(velocity.x, 0.0, 0.3)

