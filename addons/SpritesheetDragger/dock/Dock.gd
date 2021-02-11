tool
extends Control

var ei:EditorInterface
var plugin:EditorPlugin

onready var fileInputImage = $TabContainer/Settings/VBoxContainer/FileInputImage
onready var fileInputData = $TabContainer/Settings/VBoxContainer2/FileInputData


onready var iconLabelsPathImage = [
	$TabContainer/Settings/VBoxContainer/IconLabelInfo,
	$TabContainer/Settings/VBoxContainer/IconLabelFileDoesNotExist,
	$TabContainer/Settings/VBoxContainer/IconLabelFileNotValid,
	$TabContainer/Settings/VBoxContainer/IconLabelFileValid
]

onready var iconLabelsPathData = [
	$TabContainer/Settings/VBoxContainer2/IconLabelInfo,
	$TabContainer/Settings/VBoxContainer2/IconLabelFileDoesNotExist,
	$TabContainer/Settings/VBoxContainer2/IconLabelFileNotValid,
	$TabContainer/Settings/VBoxContainer2/IconLabelFileValid
]

onready var iconLabels = iconLabelsPathImage + iconLabelsPathData + [
	$TabContainer/Settings/VBoxContainer/FileInputImage/HBoxContainer/IconLabel,
	$TabContainer/Settings/VBoxContainer2/FileInputData/HBoxContainer/IconLabel
]

func _ready():
	if ei:
		fileInputImage.file_dialog_root = ei.get_base_control()
		fileInputData.file_dialog_root = ei.get_base_control()
		
		var themed_node:Control = ei.get_inspector()
		for iconLabel in iconLabels:
			iconLabel.themed_node = themed_node

func _on_FileInputImage_value_changed(value):
	SpritesheetDragger.get_state().path_spritesheet_image = value
func _on_FileInputData_value_changed(value):
	SpritesheetDragger.get_state().path_spritesheet_data = value
	
func _on_state_changed(state):
	iconLabelsPathImage[0].visible = !state.has_configured_spritesheet_image_path()
	iconLabelsPathImage[1].visible = !state.has_valid_spritesheet_image_path()
	iconLabelsPathImage[2].visible = !state.has_valid_spritesheet_image()
	iconLabelsPathImage[3].visible = !iconLabelsPathImage[2].visible

	iconLabelsPathData[0].visible = !state.has_configured_spritesheet_data_path()
	iconLabelsPathData[1].visible = !state.has_valid_spritesheet_data_path()
	iconLabelsPathData[2].visible = !state.has_valid_spritesheet_data()
	iconLabelsPathData[3].visible = !iconLabelsPathData[2].visible
	
