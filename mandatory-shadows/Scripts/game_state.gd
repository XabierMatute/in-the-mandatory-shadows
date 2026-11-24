extends Node

const SAVE_PATH := "user://game_state.cfg"
const SAVED_VARS := [
	"level1_complete", "level2_complete", "level3_complete",
	"level1_just_complete", "level2_just_complete", "level3_just_complete",
]

var test_mode := false

var level1_complete := false:
	set(value):
		level1_complete = value
		_save()
var level2_complete := false:
	set(value):
		level2_complete = value
		_save()
var level3_complete := false:
	set(value):
		level3_complete = value
		_save()

var level1_just_complete := false:
	set(value):
		level1_just_complete = value
		_save()
var level2_just_complete := false:
	set(value):
		level2_just_complete = value
		_save()
var level3_just_complete := false:
	set(value):
		level3_just_complete = value
		_save()

var loading := false

func _ready() -> void:
	_load()

func _save() -> void:
	if loading or test_mode:
		return
	var cfg := ConfigFile.new()
	for var_name in SAVED_VARS:
		cfg.set_value("game_state", var_name, get(var_name))
	cfg.save(SAVE_PATH)

func delete() -> void:
	loading = true
	for var_name in SAVED_VARS:
		set(var_name, false)
	loading = false
	_save()

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	loading = true
	for var_name in SAVED_VARS:
		set(var_name, cfg.get_value("game_state", var_name, get(var_name)))
	loading = false
