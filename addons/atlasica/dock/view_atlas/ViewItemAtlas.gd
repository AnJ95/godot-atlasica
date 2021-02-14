tool
extends Panel

onready var animator:AnimationPlayer = $AnimationPlayer

var parent
var item_name:String
var item

func init(parent, item_name, item):
	self.rect_size = Vector2(item.w, item.h)
	self.rect_position = Vector2(item.x, item.y)
	self.rect_pivot_offset = self.rect_size * 0.5
	
	self.parent = parent
	self.item_name = item_name
	self.item = item
	
	$SpriteDragger.init(parent, item_name, item)
	$Label.text = item_name

func _ready():
	animator.play("initial")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "on_hover":
		animator.play("hover")
	if anim_name == "on_unhover":
		$TextureRect.texture = null
	if anim_name == "on_disabled":
		animator.play("disabled")

func _on_filter_changed(filter:String):
	if filter.length() == 0:
		set_filter_enabled(true)
	else:
		# Does a simple case-sensitive expression match, where "*" matches zero or more arbitrary characters and "?" matches any single character except a period (".").
		set_filter_enabled(item_name.to_lower().match("*"+filter.to_lower()+"*"))
	
var enabled = true
func set_filter_enabled(enabled):
	if !self.enabled and enabled:
		animator.play("on_enabled")
	if self.enabled and !enabled:
		animator.play("on_disabled")
	$SpriteDragger.set_filter_enabled(enabled)


func _on_SpriteDragger_on_hover():
	animator.play("on_hover")
	$TextureRect.texture = Atlasica.get_sprite(item_name)
	# Notify parent
	parent.emit_signal("item_hovered", item_name, item)


func _on_SpriteDragger_on_unhover():
	animator.play("on_unhover")
	# Notify parent
	parent.emit_signal("item_unhovered", item_name, item)
