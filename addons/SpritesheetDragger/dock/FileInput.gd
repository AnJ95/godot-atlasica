tool
extends PanelContainer

signal value_changed(value)

export var text = "FileInput" setget _set_text
export var value = "Select file..." setget _set_value

func _set_text(v):
	text = v
	$HBoxContainer/Label.text = text
	
func _set_value(v):
	value = v
	$HBoxContainer/LineEdit.text = value

func _on_Button_pressed():
	pass

func _on_FileInputImage_value_changed(value):
	pass # Replace with function body.
func _on_FileInputData_value_changed(value):
	pass # Replace with function body.
