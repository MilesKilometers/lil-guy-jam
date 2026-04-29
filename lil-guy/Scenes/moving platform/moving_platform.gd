extends AnimatableBody3D

@export var move_amount: float
@export var move_time: float
var move_speed: float
@export var move_direction_x: int
@export var move_direction_y: int
@export var should_move: bool
@export var wait_time: float
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D2

var move_normal
var start_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = self.global_position
	move_normal = Vector3(move_direction_x,0.0,0.0) + Vector3(0.0,move_direction_y,0.0)
	move_speed = move_amount / move_time
	mesh_instance_3d_2.set_as_top_level(true)
	mesh_instance_3d_2.global_position = mesh_instance_3d.global_position - Vector3(0.0,(mesh_instance_3d.mesh.size.y / 2) -0.001,0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	if should_move:
		if self.global_position.distance_to(start_pos) < move_amount:
			self.global_position += (move_normal * move_speed) * delta
		else:
			should_move = false
			await get_tree().create_timer(wait_time).timeout
			print("turnin around")
			start_pos = self.global_position
			move_normal = -move_normal
			print(move_normal)
			should_move = true
	else:
		pass
