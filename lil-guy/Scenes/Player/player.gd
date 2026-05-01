extends CharacterBody3D

#region VARIABLES

#Camera
@onready var h: Node3D = $Camroot/h
@onready var v: Node3D = $Camroot/h/v
@onready var spring_arm_3d: SpringArm3D = $Camroot/h/v/SpringArm3D
@onready var camera_3d: Camera3D = $Camroot/h/v/SpringArm3D/Camera3D
@onready var head_base_height: Vector3 = Vector3(0.0,h.transform.origin.y,0.0)
var camrot_h: float
var camrot_v: float
var cam_h_min: float
var cam_h_max: float
var cam_v_min: float = -40.0
var cam_v_max: float = 70.0
var cam_sensitivity: float = 0.15

#Movement
var direction: Vector3
var move_speed: float = 4.25

#Actions
@onready var interact_cast: ShapeCast3D = $Camroot/h/InteractShapeCast
var is_pushing: bool = false
var push_strength: float = 20.0

#Player
@onready var player: CharacterBody3D = $"."

#endregion

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	h.set_as_top_level(true)
	camrot_h = h.rotation_degrees.y
	camrot_v = v.rotation_degrees.x

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		camrot_h += -event.screen_relative.x * cam_sensitivity
		camrot_v += -event.screen_relative.y * cam_sensitivity
		camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
		_rotate_camera()
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_pressed("LeftMouse"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_pushing = true
	else:
		is_pushing = false
			
		
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = 3.0	

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	# Gets the desired movement direction based on the camera rotation
	direction = (h.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Fix camera jitter by interpolating position
	var fps: float = Engine.get_frames_per_second()
	var lerp_interval = direction / fps
	var lerp_position = (global_transform.origin + head_base_height) + lerp_interval
	h.global_transform.origin = h.global_transform.origin.lerp(lerp_position, 60 * delta)

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_pushing:
		if interact_cast.is_colliding():
			var collision_array = interact_cast.collision_result
			for i in collision_array:
				if i["collider"].is_in_group("WindPush"):
					i["collider"].apply_central_force(-(player.global_position - i["collider"].global_position).normalized() * push_strength)
	
	_move_character(delta)
	move_and_slide()

func _rotate_camera():
	h.global_rotation_degrees.y = camrot_h
	v.rotation_degrees.x = camrot_v

func _move_character(delta):
	if is_on_floor():
		if direction:
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
		else:
			# Deceleration
			velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 12.0)
			velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 12.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 4.0)
