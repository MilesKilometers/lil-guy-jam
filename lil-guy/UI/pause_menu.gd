extends Control

#Containers
@onready var right_center_container: CenterContainer = $RightCenterContainer
@onready var v_box_right: VBoxContainer = $RightCenterContainer/RightVBox
@onready var left_center_container: CenterContainer = $LeftCenterContainer
@onready var v_box_left: VBoxContainer = $LeftCenterContainer/LeftVBox

#Buttons
@onready var resume_button: Button = $LeftCenterContainer/LeftVBox/ResumeButton
@onready var quit_button: Button = $LeftCenterContainer/LeftVBox/QuitButton

#States
enum MenuStates {OPEN, CLOSED}
var menu_state = MenuStates.CLOSED

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:	
	if Input.is_action_just_pressed("ui_cancel"):
		_change_pause()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _change_pause():
	if menu_state == MenuStates.CLOSED:
		print("paused")
		set_state(0)
	elif menu_state == MenuStates.OPEN:
		print("unpaused")
		set_state(1)
		
func set_state(state: int):
		if state == MenuStates.OPEN:
			menu_state = MenuStates.OPEN
			self.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			get_tree().paused = true
		elif state == MenuStates.CLOSED:
			menu_state = MenuStates.CLOSED
			self.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().paused = false
			

func _on_resume_button_pressed() -> void:
	_change_pause()

func _on_restart_button_pressed() -> void:
	_change_pause()
	get_tree().reload_current_scene()
