extends Node3D

# 62 85 -90

@export var sensitivity: float = 0.001

var dragging = false
var vertically = false
var dragging_point :Vector3

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_pressed():
		dragging = true
		dragging_point = event_position
	if dragging:
		if Input.is_key_pressed(KEY_V):
			$Controls.text = "Drag to rotate vertically, release V to rotate horizontally"
		else:
			$Controls.text = "Drag to rotate horizontally, hold V to rotate vertically"

func _input(event: InputEvent) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_released():
		dragging = false

	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion and dragging:
		vertically = Input.is_key_pressed(KEY_V)
		if vertically:
			$Elephant.rotate(Vector3.RIGHT, mouse_motion.relative.y * sensitivity)
		else:
			$Elephant.rotate(Vector3.UP, mouse_motion.relative.x * sensitivity)
	if not dragging:
		$Controls.text = "Click and hold the misterius object to rotate it"
	if not dragging and $Elephant/ElefantRay.get_collider()  == $Wall/WinArea:
		$WinUI.visible = true
		$Controls.text = "Good job"
		GameState.level2_just_complete = not GameState.level2_complete
		GameState.level2_complete = true

func _on_back_to_menu_button_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/Menus/LevelMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
