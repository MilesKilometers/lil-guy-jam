extends Node

#region VARIABLES

var game_won: bool = false
var win_state: bool = false
var current_level: String
var next_level: String

@onready var win_screen: Control = $"Win Screen"

#endregion

func _ready() -> void:
	GlobalSignals._update_current_level.connect(_change_level)
	GlobalSignals._win_state.connect(_win_state)

func _change_level(level_name: String):
	var level_list_keys = LevelList.level_dict.keys()
	var level_arr_pos = level_list_keys.find(level_name)
	print(str(level_list_keys) + "\n" + str(level_arr_pos))
	if level_list_keys.size() <= level_arr_pos + 1:
		level_arr_pos = 0
	else:
		level_arr_pos += 1
	next_level = LevelList.level_dict.get(level_list_keys[level_arr_pos])
		
	if game_won:
		get_tree().change_scene_to_file(next_level)
		current_level = next_level
	else:
		get_tree().change_scene_to_file(LevelList.level_dict[level_name])
		current_level = level_name
	
func _win_state():
	win_screen.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = true
	
	
	
	
