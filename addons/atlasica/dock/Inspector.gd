tool
extends PanelContainer

var cur_item_name = null

func _ready():
	modulate.a = 0

func _on_ViewAtlas_item_hovered(item_name, item):
	cur_item_name = item_name
	
	$VBoxContainer/LblName.text = item_name
	$VBoxContainer/HBoxContainer/LblPos.text = "(%d, %d)" % [item.x, item.y]
	$VBoxContainer/HBoxContainer2/LblSize.text = "(%d, %d)" % [item.w, item.h]
	modulate.a = 1
		

func _on_ViewAtlas_item_unhovered(_item_name, _item):
	cur_item_name = null
	modulate.a = 1
