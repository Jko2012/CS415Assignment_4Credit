extends Control

@export var max_separation:float = 500.0
@export var split_line_thickness:float = 3.0
@export var split_line_color:Color = Color.BLACK
@export var adaptive_split_line_thickness:bool = true
@export var single_player_mode:bool = true

@onready var player1 = $ViewportContainer/Viewport1/GameWorld/Player1
@onready var player2 = $ViewportContainer/Viewport1/GameWorld/Player2
@onready var viewport1 = $ViewportContainer/Viewport1
@onready var viewport2 = $ViewportContainer2/Viewport2
@onready var view = $View2P
@onready var camera1 = $ViewportContainer/Viewport1/Camera2D
@onready var camera2 = $ViewportContainer2/Viewport2/Camera2D
@onready var camera0 = $ViewportContainer/Viewport1/GameWorld/Player1/Camera1

func _ready():
	viewport2.world_2d = viewport1.world_2d
	_on_size_changed()
	_update_splitscreen()
	get_viewport().size_changed.connect(_on_size_changed)

	view.material.set_shader_parameter("viewport1", viewport1.get_texture())
	view.material.set_shader_parameter("viewport2", viewport2.get_texture())
	
	if (single_player_mode):
		camera1.enabled = false
		camera2.enabled = false
		camera0.enabled = true
	

func _process(_delta):
	if Input.is_action_just_pressed("player2_input"):
		single_player_mode = false
		camera1.enabled = true
		camera2.enabled = true
		camera0.enabled = false


func _physics_process(_delta):
	if (!single_player_mode):
		_move_cameras()
		_update_splitscreen()

func _move_cameras():
	var position_difference = _compute_position_difference_in_world()
	
	var distance = clamp(position_difference.length(), 0, max_separation)

	position_difference = position_difference.normalized() * distance

	camera1.global_position = player1.global_position + position_difference / 2.0
	camera2.global_position = player2.global_position - position_difference / 2.0

func _update_splitscreen():
	var screen_size = get_viewport().get_visible_rect().size
	
	var topLeft1 = camera1.get_screen_center_position() - screen_size / 2.0
	var topLeft2 = camera2.get_screen_center_position() - screen_size / 2.0
	
	var player1_position = (player1.position - topLeft1) / screen_size
	var player2_position = (player2.position - topLeft2) / screen_size
		
	var thickness
	if adaptive_split_line_thickness:
		var position_difference = _compute_position_difference_in_world()
		var distance = position_difference.length()
		thickness = lerpf(0, split_line_thickness, (distance - max_separation) / max_separation)
		thickness = clamp(thickness, 1, split_line_thickness)
	else:
		thickness = split_line_thickness

	view.material.set_shader_parameter("split_active", _get_split_state())
	view.material.set_shader_parameter("player1_position", player1_position)
	view.material.set_shader_parameter("player2_position", player2_position)
	view.material.set_shader_parameter("split_line_thickness", thickness)
	view.material.set_shader_parameter("split_line_color", split_line_color)
	

func _get_split_state():
	var position_difference = _compute_position_difference_in_world()
	var separation_distance = position_difference.length()
	return separation_distance > max_separation
	
func _on_size_changed():
	var screen_size = get_viewport().get_visible_rect().size

	$ViewportContainer.size = screen_size
	$ViewportContainer2.size = screen_size
	viewport1.size = screen_size
	viewport2.size = screen_size
	view.size = screen_size
	view.material.set_shader_parameter("viewport_size", screen_size)

func _compute_position_difference_in_world():
	return player2.global_position - player1.global_position
