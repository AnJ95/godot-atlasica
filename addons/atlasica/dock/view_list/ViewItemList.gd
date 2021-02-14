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
	$HBoxContainer/TextureRect.texture = Atlasica.get_sprite(item_name)
	$HBoxContainer/Label.text = item_name
	
	$SpriteDragger.init(parent, item_name, item)

func _set_height(v):
	height = v
	$HBoxContainer/TextureRect.rect_min_size = Vector2(v, v)
	$HBoxContainer/TextureRect.rect_size = Vector2(v, v)
	rect_min_size.y = v
	rect_size.y = v
