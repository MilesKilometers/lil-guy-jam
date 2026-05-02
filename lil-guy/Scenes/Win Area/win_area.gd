extends Area3D

@export var final_level: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_shape_entered(_body_rid: RID, body: Node3D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		if GameManager.game_won == false:
			print("You Win!")
			GameManager.game_won = true
			if final_level:
				GlobalSignals._win_state.emit()
			else:
				GlobalSignals._update_current_level.emit(GameManager.next_level)
