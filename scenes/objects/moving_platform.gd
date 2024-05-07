extends Path2D


@export var loop = false
@export var One_Way_Collision = false
@export var speed = 2.0
@export var speed_scale = 1.0
@export_enum("move", "move_stop", "move_slow", "move_slow_once") var anim_to_play: String = "move"
@export_range(0, 1, 0.05) var offset: float = 0


@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$"AnimatableBody2D/CollisionShape2D".one_way_collision = One_Way_Collision
	if not loop:
		animation.set_assigned_animation(anim_to_play)
		animation.seek(animation.current_animation_length * offset)
		animation.play()
		animation.speed_scale = speed_scale
	else:
		path.progress_ratio = offset
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if loop:
		move_platform_loop()

func move_platform_loop():
	path.progress += speed
