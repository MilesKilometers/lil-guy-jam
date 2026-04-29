extends Node

#region VARIABLES

var game_won: bool = false



#endregion

func _change_level(level_name: String):
	get_tree().change_scene_to_file(LevelList.get(level_name))
