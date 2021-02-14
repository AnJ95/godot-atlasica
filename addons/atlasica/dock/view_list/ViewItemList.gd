tool
extends Control

export var height = 30 setget _set_height

var parent
var item_name
var item

onready var tween:Tween = $Tween
onready var textureRect:TextureRect = $HBoxContainer/TextureRect

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


func _on_SpriteDragger_on_hover():
	tween.interpolate_property(textureRect, "rect_scale", null, Vector2(1.5, 1.5), HOVER_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	parent.emit_signal("item_hovered", item_name, item)
	
func _on_SpriteDragger_on_unhover():
	tween.interpolate_property(textureRect, "rect_scale", null, Vector2(1, 1), UNHOVER_EFFECT_TIME, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	parent.emit_signal("item_unhovered", item_name, item)
