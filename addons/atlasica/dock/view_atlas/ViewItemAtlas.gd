tool
extends Panel

var is_hovering = false

onready var animator:AnimationPlayer = $AnimationPlayer

var item_name
var item

func init(item_name, item):
	self.rect_size = Vector2(item.w, item.h)
	self.rect_position = Vector2(item.x, item.y)
	self.rect_pivot_offset = self.rect_size * 0.5
	
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
	set_drag_preview(control)
	
	# Fake file dragging
	return {
		"type" : "files",
		"files" : [Atlasica._get_resource_path(item_name)],
		"from" : Atlasica.RESOURCE_PATH
	}

func _on_ViewItemAtlas_mouse_entered():
	if !is_hovering:
		is_hovering = true
		animator.play("on_hover")
		$TextureRect.texture = Atlasica.get_sprite(item_name)

func _on_ViewItemAtlas_mouse_exited():
	if is_hovering:
		is_hovering = false
		animator.play("on_unhover")
		$TextureRect.texture = null

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "on_hover":
		animator.play("hover")
