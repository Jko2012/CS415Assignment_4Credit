extends CharacterBody2D

const BASE_SPEED = 500
const BASE_JUMP = -1000
const BASE_GRAVITY = 40

const SMALL_SPEED = 300
const SMALL_JUMP = -1100
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
var can_move
var friction
var can_grow = false
var facing = 0
var spawnpoint = Vector2(400, -80)

func _ready():
	speed = BASE_SPEED
	jumpforce = BASE_JUMP
	gravity = BASE_GRAVITY
	move_left = "move_left_player" + str(player_id)
	move_right = "move_right_player" + str(player_id)
	move_up = "move_up_player" + str(player_id)
	move_down = "move_down_player" + str(player_id)
	is_shrunk = false
	can_move = true
	friction = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if !flight:
		velocity.y += gravity
		if can_move:
			movement()
	else:
		if Input.is_action_just_pressed("scroll_up"):
			speed += 50
		if Input.is_action_just_pressed("scroll_down"):
			speed -= 50
		
		var direction = Input.get_vector(move_left, move_right, move_up, move_down)
		velocity = direction * speed
		
	move_and_slide()
	velocity.x = lerp(velocity.x, 0.0, friction)

func movement():
	if Input.is_action_pressed(move_right):
		facing = 1
		velocity.x = speed
	if Input.is_action_pressed(move_left):
		facing = -1
		velocity.x = -speed
	if Input.is_action_just_pressed(move_up) and is_on_floor() and can_jump:
		velocity.y = jumpforce
	if Input.is_action_just_pressed(move_down) and can_shrink:
		if is_shrunk:
			grow_player()
		else:
			shrink_player()
	

func respawn():
	position = spawnpoint


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


func _on_enemy_hitbox_area_entered(_area):
	can_move = false
	Global.lose_health(self, player_id)
	friction = 0.1
	velocity.x = facing*speed*-2
	velocity.y = -500
	move_and_slide()
	$InteractionHitbox/StunTimer.start()


func _on_stun_timer_timeout():
	can_move = true
	friction = 0.3


func _on_squish_area_entered(_body):
	Global.player_death(self, player_id)


func _on_spawnpoint_entered(area):
	spawnpoint = area.global_position
	
