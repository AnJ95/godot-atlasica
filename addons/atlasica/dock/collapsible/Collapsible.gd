tool
extends VBoxContainer

export var collapsed = false setget _set_collapsed
export var title = "Collapsible" setget _set_title


func _set_collapsed(v):
	collapsed = v
	
	# Show/Hide actual content
	for child in get_children():
		if child != $Header:
			child.visible = !v
	
	# Update icons
	var iconLbl = $Header/IconLabel
	iconLbl.icon = iconLbl.EditorIcons.GuiTreeArrowDown if v else iconLbl.EditorIcons.GuiTreeArrowRight
	
	$Header/ButtonCollapse.pressed = v
	
func _set_title(v):
	title = v
	$Header/IconLabel.text = v
	
func _ready():
	_set_collapsed(collapsed)
	_set_title(title)

func _on_ButtonCollapse_toggled(pressed):
	_set_collapsed(pressed)
