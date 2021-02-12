tool
extends PanelContainer

signal value_changed(value)

export var text = "FileInput" setget _set_text
export var value = "Select file..." setget _set_value
export(String) var get_from_state_initially = null

var file_dialog_root
var file_dialog

func _ready():
	var state = Atlasica.get_state()
	if get_from_state_initially != null and state.get(get_from_state_initially) != null:
		_set_value(state.get(get_from_state_initially), false)

func _set_text(v):
	text = v
	$HBoxContainer/IconLabel.text = text
	
func _set_value(v, emit=true):
	value = v
	
	var input = $HBoxContainer/LineEdit
	input.text = value
	input.caret_position = value.length()
	
	if emit:
		emit_signal("value_changed", value)
	
func has_valid_file():
	return Directory.new().file_exists(value)

func _on_Button_pressed():
	file_dialog = FileDialog.new()
	file_dialog.mode = FileDialog.MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_RESOURCES
	file_dialog.connect("file_selected", self, "_on_FileDialog_file_selected")
	# var extensions = ResourceLoader.get_recognized_extensions_for_type("Texture")
	if has_valid_file():
		file_dialog.current_path = value
	
	file_dialog_root.add_child(file_dialog)
	file_dialog.popup_centered_ratio()
	
func _exit_tree():
	if file_dialog:
		file_dialog.queue_free()

func _on_FileDialog_file_selected(path):
	_set_value(path)
