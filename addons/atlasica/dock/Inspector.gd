tool
extends PanelContainer

export var preview_sprite = false

var cur_item_name = null

func _ready():
	modulate.a = 0
	
onready var lblName:Label = $VBoxContainer/LblName
onready var lblPos:Label = $VBoxContainer/HBoxContainer/LblPos
onready var lblSize:Label = $VBoxContainer/HBoxContainer2/LblSize
onready var textureRect:TextureRect = $VBoxContainer/TextureRect
onready var lblMetadata:Label = $VBoxContainer/VBoxContainer/PanelContainer/lblMetadata

func _on_item_hovered(item_name, item):
	cur_item_name = item_name
	
	lblName.text = item_name
	lblPos.text = "(%d, %d)" % [item.x, item.y]
	lblSize.text = "(%d, %d)" % [item.w, item.h]
	lblMetadata.text = JSON.print(item.metadata, "  ")
	
	if preview_sprite:
		textureRect.texture = Atlasica.get_sprite(item_name)
	textureRect.visible = preview_sprite
	
	modulate.a = 1

func _on_item_unhovered(_item_name, _item):
	cur_item_name = null
	modulate.a = 0

func _on_TextureRect_resized():
	var textureRect:TextureRect = $VBoxContainer/TextureRect
	textureRect.rect_min_size.y = textureRect.rect_size.x
	textureRect.rect_size.y = textureRect.rect_size.x
