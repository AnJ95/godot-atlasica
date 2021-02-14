tool
extends Control

export var height = 30 setget _set_height

var parent
var item_name
var item

func _ready():
	_set_height(height)

func init(parent, item_name, item):
	self.parent = parent
	self.item_name = item_name
	self.item = item
	$TextureRect.texture = Atlasica.get_sprite(item_name)
	$Label.text = item_name

func _set_height(v):
	height = v
	$TextureRect.rect_min_size = Vector2(v, v)
	$TextureRect.rect_size = Vector2(v, v)
	rect_min_size.y = v
	rect_size.y = v
