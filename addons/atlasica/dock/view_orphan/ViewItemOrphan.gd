tool
extends "res://addons/atlasica/dock/view_list/ViewItemList.gd"

onready var btnDelete = $HBoxContainer/ButtonDelete
onready var btnDeleteSure = $HBoxContainer/ButtonDeleteSure
onready var btnDeleteNotSure = $HBoxContainer/ButtonDeleteNotSure

func _ready():
	btnDeleteSure.visible = false
	btnDeleteNotSure.visible = false
	
func _get_path():
	return Atlasica._get_resource_path(item_name)

func _on_ButtonReveal_pressed():
	Atlasica.ei.select_file(_get_path())

func _on_ButtonDelete_pressed():
	btnDelete.visible = false
	btnDeleteSure.visible = true
	btnDeleteNotSure.visible = true

func _on_ButtonDeleteSure_pressed():
	if OK != Directory.new().remove(_get_path()):
		printerr("Atlasica: Could not delete resource at %s. Try do do it manually!" % _get_path())
	else:
		Atlasica.ei.get_resource_filesystem().scan()
		queue_free()
		parent.item_removed()

func _on_ButtonDeleteNotSure_pressed():
	btnDelete.visible = true
	btnDeleteSure.visible = false
	btnDeleteNotSure.visible = false
