tool
extends Control

export var height = 38 setget _set_height

var parent
var item_name
var item

onready var tween:Tween = $Tween
onready var textureRect:TextureRect = $HBoxContainer/TextureRect

const ENABLE_EFFECT_TIME = 0.3
const DISABLE_EFFECT_TIME = 0.3
const HOVER_EFFECT_TIME = 0.2
const UNHOVER_EFFECT_TIME = 0.4

func _ready():
	_set_height(height)

func init(parent, item_name, item):
	self.parent = parent
	self.item_name = item_name
	self.item = item
	$HBoxContainer/TextureRect.texture = Atlasica.get_sprite(item_name)
	$HBoxContainer/Label.text = item_name
	
	$SpriteDragger.init(parent, item_name, item)

func _set_height(v):
	height = v
	
	var textureRect:TextureRect = $HBoxContainer/TextureRect
	textureRect.rect_min_size = Vector2(v, v)
	textureRect.rect_size = Vector2(v, v)
	textureRect.rect_pivot_offset = Vector2(v, v) * 0.5
	
	rect_min_size.y = v
	rect_size.y = v

func _on_filter_changed(filter:String, animate=true):
	if filter.length() == 0:
		set_filter_enabled(true, animate)
	else:
		# Does a simple case-sensitive expression match, where "*" matches zero or more arbitrary characters and "?" matches any single character except a period (".").
		set_filter_enabled(item_name.to_lower().match("*"+filter.to_lower()+"*"), animate)
	
var enabled = true
func set_filter_enabled(enabled, animate=true):
	if !self.enabled and enabled:
		show()
		if animate:
			tween.interpolate_property(self, "modulate:a", null, 1.0, ENABLE_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_IN)
	if self.enabled and !enabled:
		if animate:
			tween.interpolate_property(self, "modulate:a", null, 0.0, DISABLE_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
			tween.interpolate_callback(self, DISABLE_EFFECT_TIME, "hide")
		else:
			hide()
	self.enabled = enabled
	tween.start()
	$SpriteDragger.set_filter_enabled(enabled)

func _on_SpriteDragger_on_hover():
	tween.interpolate_property(textureRect, "rect_scale", null, Vector2(1.5, 1.5), HOVER_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	parent.emit_signal("item_hovered", item_name, item)
	
func _on_SpriteDragger_on_unhover():
	tween.interpolate_property(textureRect, "rect_scale", null, Vector2(1, 1), UNHOVER_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	parent.emit_signal("item_unhovered", item_name, item)
