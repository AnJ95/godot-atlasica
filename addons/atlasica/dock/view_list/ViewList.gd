tool
extends Control

const ViewItem = preload("res://addons/atlasica/dock/view_list/ViewItemList.tscn")

signal item_hovered(item_name, item)
signal item_unhovered(item_name, item)

var scale = 1

# Clip content and inputs
func _ready():
	rect_clip_content = true
	
func _clips_input():
	return true

func init(atlas_image, atlas_data:Dictionary):
	var root = self
	
	for child in root.get_children():
		child.queue_free()
	
	for item_name in atlas_data.sprites.keys():
		var item = ViewItem.instance()
		item.init(self, item_name, atlas_data.sprites[item_name])
		root.add_child(item)

func _on_LineEditFilterList_text_changed(new_text):
	var root = self
	for child in root.get_children():
		child._on_filter_changed(new_text)
