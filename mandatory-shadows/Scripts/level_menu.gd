#extends Node
#
#func _ready() -> void:
	#$TestLabel.visible = GameState.test_mode
	#$VBoxContainer/L2Button.disabled = not (GameState.test_mode or GameState.level1_complete)
	#$VBoxContainer/L3Button.disabled = not (GameState.test_mode or GameState.level2_complete)
	#if GameState.level1_just_complete:
		## TODO: play animatiom
		#GameState.level1_just_complete = false
	#if GameState.level2_just_complete:
		## TODO: play animatiom
		#GameState.level2_just_complete = false
	#if GameState.level3_just_complete:
		## TODO: play animatiom
		#GameState.level3_just_complete = false
#
#func _on_l_1_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")
#
#func _on_l_2_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")
#
#func _on_l_3_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level3.tscn")
#
#func _on_back_button_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
extends Node

@onready var l1_btn: Button = $VBoxContainer/L1Button
@onready var l2_btn: Button = $VBoxContainer/L2Button
@onready var l3_btn: Button = $VBoxContainer/L3Button

func _ready() -> void:
	$TestLabel.visible = GameState.test_mode
	$HBoxContainerTest.visible = GameState.test_mode
	l2_btn.disabled = not (GameState.test_mode or GameState.level1_complete)
	l3_btn.disabled = not (GameState.test_mode or GameState.level2_complete)
	
	if GameState.level1_complete and not GameState.level1_just_complete:
		l1_btn.modulate = Color(0.6, 1.0, 0.6)
	if GameState.level2_complete and not GameState.level2_just_complete:
		l2_btn.modulate = Color(0.6, 1.0, 0.6)
	if GameState.level3_complete and not GameState.level3_just_complete:
		l3_btn.modulate = Color(0.6, 1.0, 0.6)

	await get_tree().process_frame

	if GameState.level1_just_complete:
		GameState.level1_just_complete = false
		_animate_solved(l1_btn)
		if not GameState.test_mode:
			_animate_unlock(l2_btn)

	if GameState.level2_just_complete:
		GameState.level2_just_complete = false
		_animate_solved(l2_btn)
		if not GameState.test_mode:
			_animate_unlock(l3_btn)

	if GameState.level3_just_complete:
		GameState.level3_just_complete = false
		_animate_solved(l3_btn)

func _animate_solved(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	var tween := create_tween().set_parallel(true)
	
	tween.tween_property(btn, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(btn, "modulate", Color(0.6, 1.0, 0.6), 0.3)
	
	tween.chain().tween_property(btn, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_SINE)

func _animate_unlock(btn: Button) -> void:
	btn.pivot_offset = btn.size / 2.0
	
	btn.disabled = true
	btn.scale = Vector2(0.7, 0.7)
	btn.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	var tween := create_tween()
	tween.tween_interval(0.35)
	
	tween.set_parallel(true)
	tween.tween_property(btn, "modulate", Color(1.6, 1.4, 0.7, 1.0), 0.25)
	tween.tween_property(btn, "scale", Vector2(1.1, 1.1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween.chain().set_parallel(true)
	tween.tween_property(btn, "modulate", Color.WHITE, 0.3)
	tween.tween_property(btn, "scale", Vector2.ONE, 0.2)
	tween.chain().tween_callback(func(): btn.disabled = false)

func _on_l_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1.tscn")

func _on_l_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level2.tscn")

func _on_l_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level3.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")


func _on_test_a_1_button_pressed() -> void:
	var random_btn: Button = [l1_btn, l2_btn, l3_btn].pick_random()
	_animate_solved(random_btn)

func _on_test_a_2_button_2_pressed() -> void:
	var random_btn: Button = [l1_btn, l2_btn, l3_btn].pick_random()
	_animate_unlock(random_btn)
