tool
extends Control

onready var fileInputZip = $TabContainer/Setup/VBoxContainer/GridContainer/VBoxContainer/FileInputZip

onready var iconLabels = [
	$TabContainer/Setup/VBoxContainer/GridContainer/VBoxContainer/IconLabelFileDoesNotExist,
	$TabContainer/Setup/VBoxContainer/GridContainer/VBoxContainer/IconLabelFileNotValid,
	$TabContainer/Setup/VBoxContainer/GridContainer/VBoxContainer/IconLabelFileValid
]

onready var viewOrphan = $TabContainer/Setup/VBoxContainer/GridContainer2/VBoxContainer/ViewOrphan

onready var viewAtlas = $TabContainer/Atlas/ViewAtlas
onready var viewList = $"TabContainer/List of Sprites/ScrollContainer/ViewList"
onready var optionButtonOrder:OptionButton = $"TabContainer/List of Sprites/VBoxContainer/GridContainer/OptionButtonOrder"

onready var gridSetupValid = $TabContainer/Setup/VBoxContainer/GridContainer2
onready var btnUpdate:Button = $TabContainer/Setup/VBoxContainer/GridContainer2/VBoxContainer/HBoxContainer2/ButtonUpdate
onready var checkUpdate:CheckBox = $TabContainer/Setup/VBoxContainer/GridContainer2/VBoxContainer/HBoxContainer2/CheckBoxUpdate
onready var btnRevealResourceDir:Button = $TabContainer/Setup/VBoxContainer/GridContainer2/VBoxContainer2/HBoxContainer/ButtonRevealResourceDir
onready var tween:Tween = $Tween


func _ready():
	optionButtonOrder.clear()
	optionButtonOrder.add_item("Alphabetic")
	optionButtonOrder.add_item("Position in Atlas")
	optionButtonOrder.add_item("Width")
	optionButtonOrder.add_item("Height")
	optionButtonOrder.add_item("Size")
	
	if Atlasica.ei:
		# Dialogs must be in editor base control
		fileInputZip.file_dialog_root = Atlasica.ei.get_base_control()
		
		var themed_node:Control = Atlasica.ei.get_inspector()
		for iconLabel in get_tree().get_nodes_in_group("IconLabel"):
			iconLabel.themed_node = themed_node
			
	_on_state_changed(Atlasica.get_state())
	
	Atlasica.connect("resources_updated", self, "_on_resources_changed")
	_on_resources_changed()
	
	# Fix to prevent height change on tab change
	var y = rect_size.y
	rect_min_size.y = y
	

func _on_FileInputZip_value_changed(value):
	Atlasica.get_state().path_zip = value
	if Atlasica.get_state().has_valid_zip():
		Atlasica.update_resources()
	
	
func _on_resources_changed():
	viewOrphan.update_orphans(Atlasica._orphaned_resources)
	
func _on_state_changed(state):
	var is_all_valid = false
	
	iconLabels[0].visible = false
	iconLabels[1].visible = false
	iconLabels[2].visible = false
	if !state.has_valid_zip_path():
		iconLabels[0].visible = true
	elif !state.has_valid_zip():
		iconLabels[1].visible = true
	else:
		iconLabels[2].visible = true
		is_all_valid = true
	
	$TabContainer.set_tab_disabled(1, !is_all_valid)
	$TabContainer.set_tab_disabled(2, !is_all_valid)
	
	btnUpdate.disabled = !is_all_valid
	checkUpdate.disabled = !is_all_valid
	btnRevealResourceDir.disabled = !is_all_valid
	
	checkUpdate.pressed = state.autoupdate
	
	tween.interpolate_property(gridSetupValid, "modulate:a", null, 1 if is_all_valid else 0.4, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _on_TabContainer_tab_changed(tab):
	if tab == 1: update_tab_atlas()
	if tab == 2: update_tab_list()
	
func update_tab_atlas():
	var state = Atlasica.get_state()
	viewAtlas.init(state.get_atlas_image(), state.get_atlas_layout())
func update_tab_list():
	var state = Atlasica.get_state()
	viewList.init(state.get_atlas_image(), state.get_atlas_layout(), optionButtonOrder.selected)

func _on_LinkButtonSpriteBuilder_pressed():
	OS.shell_open("https://h0rn0chse.github.io/SpriteBuilder/")
func _on_LinkButtonGitHub_pressed():
	OS.shell_open("https://github.com/AnJ95/godot-atlasica")
	
func _on_ButtonRevealResourceDir_pressed():
	Atlasica.ei.select_file(Atlasica.RESOURCE_PATH)

func _on_ButtonUpdate_pressed():
	if Atlasica.get_state().has_valid_zip():
		Atlasica.update_resources()

func _on_CheckBoxUpdate_toggled(button_pressed):
	Atlasica.get_state().autoupdate = button_pressed
