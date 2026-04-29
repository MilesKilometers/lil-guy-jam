extends RigidBody3D

var max_horizontal_speed: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var horizontal_velocity := Vector3(state.linear_velocity.x, 0.0, state.linear_velocity.z)
	if horizontal_velocity.length() > max_horizontal_speed:
		horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
		state.linear_velocity.x = horizontal_velocity.x
		state.linear_velocity.z = horizontal_velocity.z
