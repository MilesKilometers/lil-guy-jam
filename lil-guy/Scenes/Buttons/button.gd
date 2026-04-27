extends Area3D

var pressed: bool = false
var objects_array: Array

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if objects_array.size() > 0:
		mesh_instance_3d.mesh.material.albedo_color = Color.GREEN
	else:
		mesh_instance_3d.mesh.material.albedo_color = Color.RED


func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("ButtonKey"):
		objects_array.append(body)


func _on_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("ButtonKey"):
		objects_array.erase(body)
