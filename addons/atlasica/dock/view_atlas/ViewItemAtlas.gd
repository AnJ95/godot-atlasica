tool
extends Panel

var is_hovering = false

onready var animator:AnimationPlayer = $AnimationPlayer

var parent
var item_name
var item

var is_dragging_other = false

func init(parent, item_name, item):
	self.rect_size = Vector2(item.w, item.h)
	self.rect_position = Vector2(item.x, item.y)
	self.rect_pivot_offset = self.rect_size * 0.5
	
	self.parent = parent
	self.item_name = item_name
	self.item = item
	
	$Label.text = item_name

func _ready():
	animator.play("initial")

func get_drag_data(position):
	# Create drag_preview
	var sprite = TextureRect.new()
	sprite.rect_position = -position
	sprite.texture = Atlasica.get_sprite(item_name)
	sprite.rect_size = Vector2(item.x, item.y)
	var control = Control.new()
	control.add_child(sprite)
	control.rect_scale = Vector2(parent.scale, parent.scale)
	set_drag_preview(control)
	
	# Trigger unhover effects
	_on_ViewItemAtlas_mouse_exited()
	
	# Fake file dragging
	return {
		"type" : "files",
		"files" : [Atlasica._get_resource_path(item_name)],
		"from" : Atlasica.RESOURCE_PATH
	}

# Only to check if something else is being dragged
func can_drop_data(_position, _data):
	is_dragging_other = true
	return false

# Called deferred to make sure can_drop_data is called before when dragging sth else
func _on_ViewItemAtlas_mouse_entered():
	if !is_hovering and !is_dragging_other:
		is_hovering = true
		animator.play("on_hover")
		$TextureRect.texture = Atlasica.get_sprite(item_name)
		
		# Notify parent
		parent.emit_signal("item_hovered", item_name, item)

func _on_ViewItemAtlas_mouse_exited():
	if is_dragging_other:
		is_dragging_other = false
		
	if is_hovering:
		is_hovering = false
		animator.play("on_unhover")
		$TextureRect.texture = null
		
		# Notify parent
		parent.emit_signal("item_unhovered", item_name, item)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "on_hover":
		animator.play("hover")
