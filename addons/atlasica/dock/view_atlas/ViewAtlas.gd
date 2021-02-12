tool
extends ScrollContainer

const ViewItem = preload("res://addons/atlasica/dock/view_atlas/ViewItemAtlas.tscn")

func init(atlas_image, atlas_data:Dictionary):
	var texture:TextureRect = $CenterContainer/TextureRect
	texture.texture = atlas_image
	
	texture.rect_pivot_offset = texture.rect_size * 0.5
	
	for item_name in atlas_data.sprites.keys():
		var item = ViewItem.instance()
		item.init(item_name, atlas_data.sprites[item_name])
		$CenterContainer/TextureRect.add_child(item)

const SCROLL_FACTOR = 1.08

var is_panning = false
var last_pan_pos = null

func _on_ViewAtlas_gui_input(event):
	if event is InputEventMouseButton:
		
		# Scroll
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				$CenterContainer/TextureRect.rect_scale *= SCROLL_FACTOR
			if event.button_index == BUTTON_WHEEL_DOWN:
				$CenterContainer/TextureRect.rect_scale /= SCROLL_FACTOR
		
		# Pan start/end
		if event.button_index == BUTTON_RIGHT:
			if event.is_pressed():
				is_panning = true
				last_pan_pos = get_global_mouse_position()
			else:
				is_panning = false
	
	if event is InputEventMouseMotion:
		if is_panning:
			var pan_pos = get_global_mouse_position()
			var d_pan = pan_pos - last_pan_pos
			
			$CenterContainer.rect_position += d_pan
			
			last_pan_pos = pan_pos

func _on_reset():
	$CenterContainer/TextureRect.rect_scale = Vector2(1, 1)
	$CenterContainer.rect_position = Vector2(0, 0)
