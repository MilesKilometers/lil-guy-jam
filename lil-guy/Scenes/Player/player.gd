extends CharacterBody3D

#region VARIABLES

#Camera
@onready var h: Node3D = $Camroot/h
@onready var v: Node3D = $Camroot/h/v
var camrot_h: float = 0
var camrot_v: float = 0
var cam_h_min: float
var cam_h_max: float
var cam_v_min: float = -40.0
var cam_v_max: float = 70.0
var cam_sensitivity: float = 0.5

#Movement
var direction: Vector3
var move_speed: float = 10.0

#endregion

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * cam_sensitivity
		camrot_v += -event.relative.y * cam_sensitivity
		camrot_v = clamp(camrot_v, cam_v_min, cam_v_max)
		_rotate_camera()
		
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor():
			velocity.y = 5
		
	

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBack")
	# Gets the desired movement direction based on the camera rotation
	direction = (h.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_move_character(delta)
	move_and_slide()

func _rotate_camera():
	h.rotation_degrees.y = camrot_h
	v.rotation_degrees.x = camrot_v

func _move_character(delta):
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		# Deceleration
		velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 4.0)
