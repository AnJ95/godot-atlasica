tool
extends Control

const ViewItem = preload("res://addons/atlasica/dock/view_atlas/ViewItemAtlas.tscn")

signal item_hovered(item_name, item)
signal item_unhovered(item_name, item)

var scale = 1

# Clip content and inputs
func _ready():
	rect_clip_content = true
	call_deferred("_on_reset")
func _clips_input():
	return true

func init(atlas_image, atlas_data:Dictionary):
	var root = $CenterContainer/TextureRect
	
	var texture:TextureRect = root
	texture.texture = atlas_image
	
	texture.rect_pivot_offset = texture.rect_size * 0.5
	
	for child in root.get_children():
		child.queue_free()
	
	for item_name in atlas_data.sprites.keys():
		var item = ViewItem.instance()
		item.init(self, item_name, atlas_data.sprites[item_name])
		root.add_child(item)

const SCROLL_FACTOR = 1.08

var is_panning = false
var last_pan_pos = null

func _on_ViewAtlas_gui_input(event):
	if event is InputEventMouseButton:
		
		# Scroll
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				scale *= SCROLL_FACTOR
			if event.button_index == BUTTON_WHEEL_DOWN:
				scale /= SCROLL_FACTOR
			$CenterContainer/TextureRect.rect_scale = Vector2(scale, scale)
		
		# Pan start/end
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed():
				is_panning = true
				last_pan_pos = get_global_mouse_position()
			else:
				is_panning = false
	
	# Pan move
	if event is InputEventMouseMotion:
		if is_panning:
			var pan_pos = get_global_mouse_position()
			var d_pan = pan_pos - last_pan_pos
			$CenterContainer.rect_position += d_pan
			last_pan_pos = pan_pos

func _on_reset():
	scale = 1
	$CenterContainer/TextureRect.rect_scale = Vector2(scale, scale)
	$CenterContainer.rect_position = Vector2(-$CenterContainer/TextureRect.rect_size.x * 0.5 + 1, -rect_size.y * 0.5 + 1)


func _on_LineEditFilterAtlas_text_changed(new_text):
	for child in $CenterContainer/TextureRect.get_children():
		child._on_filter_changed(new_text)
