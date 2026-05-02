extends Node3D

#region VARIABLES
#Shared Children
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#General Vars
var self_groups: Array
var puzzle_group: String
var puzzle_solve_state: bool = false

#Button
var pressed: bool = false
var objects_array: Array

#Door
var open: bool = false

#endregion



# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	self_groups = self.get_groups()
	for group in self_groups:
		match group:
			"Button":	
				puzzle_group = group
			"PuzzleDoor":
				puzzle_group = group
				
	GlobalSignals._register_puzzle_piece.emit.call_deferred(self, self.get_parent_node_3d())
	GlobalSignals._puzzle_completed.connect(_puzzle_complete)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if puzzle_solve_state == false:
		match puzzle_group:
			"Button":
				if objects_array.size() > 0:
					mesh_instance_3d.mesh.material.albedo_color = Color.GREEN
				else:
					mesh_instance_3d.mesh.material.albedo_color = Color.RED
			"PuzzleDoor":
				pass


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	match puzzle_group:
		"Button":
			if body.is_in_group("ButtonKey"):
				objects_array.append(body)
				pressed = true
				GlobalSignals._update_puzzle_piece.emit(self, pressed)


func _on_body_shape_exited(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	match puzzle_group:
		"Button":
			if body.is_in_group("ButtonKey"):
				objects_array.erase(body)
				if objects_array.size() == 0:
					pressed = false
					GlobalSignals._update_puzzle_piece.emit(self, pressed)

func _puzzle_complete(solve_state):
	if solve_state == true:	
		if puzzle_solve_state == false:
			puzzle_solve_state = true
			match puzzle_group:
				"Button":
					mesh_instance_3d.mesh.material.albedo_color = Color.GREEN
				"PuzzleDoor":
					animation_player.play("Open")
	elif solve_state == false:
		puzzle_solve_state = false
		match puzzle_group:
			"Button":
				pass
			"PuzzleDoor":
				animation_player.play("Open")
