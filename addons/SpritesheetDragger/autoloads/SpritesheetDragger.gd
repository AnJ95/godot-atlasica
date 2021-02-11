tool
extends Node

signal state_changed(state)

const State = preload("res://addons/SpritesheetDragger/state/State.gd")
const STATE_RES_PATH = "user://spritesheetDragger.tres"

func _enter_tree():
	pass
	
func override_state(path_spritesheet_file, path_spritesheet_data):
	pass


var _state
func get_state()->State:
	if !_state:
		
		if ResourceLoader.exists(STATE_RES_PATH):
			_state = ResourceLoader.load(STATE_RES_PATH)
			if !_state:
				printerr("SpritesheetDragger: Could not load state and settings from %s, resetting to default" % STATE_RES_PATH)
				_reset_state()
		else:
			print("SpritesheetDragger: No settings found, creating new and saving to %s" % STATE_RES_PATH)
			_reset_state()
			
		_state.connect("state_changed", self, "_on_state_changed")
	return _state

func _save_state():
	if OK != ResourceSaver.save(STATE_RES_PATH, _state):
		printerr("SpritesheetDragger: Could not save state and settings to %s" % STATE_RES_PATH)
		
func _reset_state():
	_state = State.new()
	_save_state()

func _on_state_changed(): # redirect signal from resource
	var state = get_state()
	emit_signal("state_changed", state)
	_save_state()
	
