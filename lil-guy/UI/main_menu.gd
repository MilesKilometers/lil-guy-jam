extends Control

@onready var button_1: Button = $RightLowCenterContainer/RightHBox/Button
@onready var button_2: Button = $RightLowCenterContainer/RightHBox/Button2
@onready var button_3: Button = $RightLowCenterContainer/RightHBox/Button3
@onready var current_select: Label = $"RightTopCenterContainer2/RightVBox/Current Select"

var selected_level: String = "None"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_select.text = "Selected: " + selected_level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _select_level(button):
	var newtext = button.text.replace(" ", "")
	selected_level = "level " + str(newtext)
	current_select.text = "Selected: " + selected_level

func _on_button1_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		_select_level(button_1)
	else:
		selected_level = "None"

func _on_button2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		_select_level(button_2)
	else:
		selected_level = "None"

func _on_button3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		_select_level(button_3)
	else:
		selected_level = "None"

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	var newleveltext = selected_level.replace(" ", "_")
	GlobalSignals._update_current_level.emit(newleveltext)
