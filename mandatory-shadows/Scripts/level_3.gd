extends Node3D

@export var sensitivity: float = 0.001
@export var move_sensitivity: float = 0.01

var dragging := false
var dragging_mesh : MeshInstance3D
var vertically = false
var moving := false
var dragging_point :Vector3

func _on_area_3d_input_event(event: InputEvent, event_position: Vector3, mesh : MeshInstance3D) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_pressed():
		dragging = true
		dragging_point = event_position
		dragging_mesh = mesh
	if dragging:
		if Input.is_key_pressed(KEY_V):
			$Controls.text = "Drag to rotate vertically, release V to rotate horizontally"
		elif Input.is_key_pressed(KEY_M):
			$Controls.text = "Drag to move the object, release M to rotate horizontally"
		else:
			$Controls.text = "Drag to rotate horizontally, hold V to rotate vertically or hold M to move the object"

func _input(event: InputEvent) -> void:
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.is_released():
		dragging = false

	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion and dragging:
		vertically = Input.is_key_pressed(KEY_V)
		moving = Input.is_key_pressed(KEY_M)
		if vertically:
			dragging_mesh.rotate(Vector3.RIGHT, mouse_motion.relative.y * sensitivity)
		elif moving:
			var daddy := dragging_mesh.get_parent_node_3d()
			var camera := get_viewport().get_camera_3d()
			if camera and daddy:
				var mouse_pos := get_viewport().get_mouse_position()
				var hit = Plane(daddy.global_basis.z, daddy.global_position).intersects_ray(camera.project_ray_origin(mouse_pos), camera.project_ray_normal(mouse_pos))
				if hit:
					daddy.global_position.x = hit.x
					daddy.global_position.y = hit.y
		else:
			dragging_mesh.rotate(Vector3.UP, mouse_motion.relative.x * sensitivity)
	if not dragging:
		$Controls.text = "Click and hold the misterius object to rotate it"
	if (
		not dragging
		and $"4/MeshInstance3D/ElefantRay".get_collider()  == $"4/WinArea"
		and $"2/MeshInstance3D/ElefantRay".get_collider()  == $"2/WinArea"
		and $"4/MeshInstance3D/PeerArea".overlaps_area($"2/MeshInstance3D/PeerArea")
		):
		$WinUI.visible = true
		$Controls.text = "Good job"
		GameState.level2_just_complete = not GameState.level2_complete
		GameState.level2_complete = true

func _on_back_to_menu_button_pressed() -> void:
		get_tree().change_scene_to_file("res://Scenes/Menus/LevelMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_area_3d_input_event_2(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	_on_area_3d_input_event(event, event_position, $"2/MeshInstance3D")

func _on_area_3d_input_event_4(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
		_on_area_3d_input_event(event, event_position, $"4/MeshInstance3D")
