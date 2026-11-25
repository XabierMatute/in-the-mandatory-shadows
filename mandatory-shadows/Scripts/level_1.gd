extends Node3D

@export var sensitivity: float = 0.001

var dragging = false
var dragging_point :Vector3

func _on_area_3d_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_pressed():
		dragging = true
		dragging_point = event_position
	if dragging:
		$Controls.text = "Drag to rotate horizontally"

func _input(event: InputEvent) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_released():
		dragging = false
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion and dragging:
		$TeaPot.rotate(Vector3.UP, mouse_motion.relative.x * sensitivity)
	if not dragging:
		$Controls.text = "Click and hold the misterius object to rotate it"
	if not GameState.level1_just_complete and not dragging and ($TeaPot.rotation_degrees.y < 190 and $TeaPot.rotation_degrees.y > 170):
		$WinUI.visible = true
		$Controls.text = "Good job"
		GameState.level1_just_complete = not GameState.level1_complete
		print(GameState.level1_just_complete)
		GameState.level1_complete = true

func _on_back_to_menu_button_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/Menus/LevelMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
