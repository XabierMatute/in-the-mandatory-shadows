extends Control

func show_progress() -> void:
	var levels := [
		GameState.level1_complete,
		GameState.level2_complete,
		GameState.level3_complete,
	]
	var just := [
		GameState.level1_just_complete,
		GameState.level2_just_complete,
		GameState.level3_just_complete,
	]
	print(just)
	var text := ""
	for i in levels.size():
		text += "Nivel %d: %s %s\n" % [i + 1, "✔" if levels[i] else "✘", "!" if just[i] else ""]

	var done := levels.count(true)
	text += "\nProgreso: %d/%d (%d%%)" % [done, levels.size(), done * 100 / levels.size()]
	$VBoxContainer2/ProgressLabel.text = text

func _ready() -> void:
	show_progress()

	
func _on_normal_mode_button_pressed() -> void:
	GameState.test_mode = false
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelMenu.tscn")

func _on_test_mode_button_pressed() -> void:
	GameState.test_mode = true
	get_tree().change_scene_to_file("res://Scenes/Menus/LevelMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_delete_button_pressed() -> void:
	GameState.delete()
	show_progress()
