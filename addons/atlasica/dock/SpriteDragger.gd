tool
extends Control

var scale_get_node:Control
var item_name
var item
var enabled = true
var is_dragging_other = false
var is_hovering = false

signal on_hover()
signal on_unhover()

func init(scale_get_node, item_name, item):
	self.scale_get_node = scale_get_node
	self.item_name = item_name
	self.item = item
	return self
	
func get_drag_data(position):
	if !enabled: return null
	
	# Create drag_preview
	var sprite = TextureRect.new()
	sprite.rect_position = -position
	sprite.texture = Atlasica.get_sprite(item_name)
	sprite.rect_size = Vector2(item.x, item.y)
	var control = Control.new()
	control.add_child(sprite)
	control.rect_scale = Vector2(scale_get_node.scale, scale_get_node.scale)
	set_drag_preview(control)
	
	# Trigger unhover effects
	_on_SpriteDragger_mouse_exited()
	
	# Fake file dragging
	return {
		"type" : "files",
		"files" : [Atlasica._get_resource_path(item_name)],
		"from" : Atlasica.RESOURCE_PATH
	}

func set_filter_enabled(enabled):
	mouse_default_cursor_shape = CURSOR_POINTING_HAND if enabled else CURSOR_ARROW
	self.enabled = enabled

# Only to check if something else is being dragged
func can_drop_data(_position, _data):
	is_dragging_other = true
	return false
	
# Called deferred to make sure can_drop_data is called before when dragging sth else
func _on_SpriteDragger_mouse_entered():
	if !enabled: return
	
	if !is_hovering and !is_dragging_other:
		is_hovering = true
		emit_signal("on_hover")


func _on_SpriteDragger_mouse_exited():
	if !enabled: return
	
	if is_dragging_other:
		is_dragging_other = false
		
	if is_hovering:
		emit_signal("on_unhover")
		is_hovering = false
