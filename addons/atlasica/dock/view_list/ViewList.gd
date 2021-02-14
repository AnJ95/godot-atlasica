tool
extends Control

const ViewItem = preload("res://addons/atlasica/dock/view_list/ViewItemList.tscn")

signal item_hovered(item_name, item)
signal item_unhovered(item_name, item)

var scale = 1

const COMPARE_TOS = [
	"_sort_alphabetic",
	"_sort_position",
	"_sort_width",
	"_sort_height",
	"_sort_size",
]

var atlas_data
func init(atlas_image, atlas_data:Dictionary, order=0):
	self.atlas_data = atlas_data
	
	update_children(order)

func update_children(order=0):
	var root = self
	for child in root.get_children():
		child.queue_free()
	
	var item_names:Array = []
	for item_name in atlas_data.sprites.keys():
		item_names.append(item_name)
	
	item_names.sort_custom(self, COMPARE_TOS[order])
		
	for item_name in item_names:
		var item = ViewItem.instance()
		item.init(self, item_name, atlas_data.sprites[item_name])
		root.add_child(item)
	
	# Reapply filter if there is one
	if last_filter.length() > 0:
		_on_LineEditFilterList_text_changed(last_filter, false)

func _sort_alphabetic(a:String, b:String):
	return a < b
func _sort_position(a:String, b:String):
	var ay = atlas_data.sprites[a].y
	var by = atlas_data.sprites[b].y
	if ay == by:	return atlas_data.sprites[a].x < atlas_data.sprites[b].x
	else:			return ay < by
func _sort_width(a:String, b:String):
	return atlas_data.sprites[a].w < atlas_data.sprites[b].w
func _sort_height(a:String, b:String):
	return atlas_data.sprites[a].h < atlas_data.sprites[b].h
func _sort_size(a:String, b:String):
	return atlas_data.sprites[a].w * atlas_data.sprites[a].h < atlas_data.sprites[b].w * atlas_data.sprites[b].h

var last_filter:String = ""
func _on_LineEditFilterList_text_changed(filter, animate=true):
	for child in get_children():
		child._on_filter_changed(filter, animate)
	last_filter = filter

func _on_OptionButtonOrder_item_selected(index):
	update_children(index)
