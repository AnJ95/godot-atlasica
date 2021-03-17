tool
extends Container

export var preview_sprite = false

var cur_item_name = null

func _ready():
	modulate.a = 0
	textureRect.rect_min_size.y = textureRect.rect_size.x
	textureRect.rect_size.y = textureRect.rect_size.x
	
onready var lblName:Label = $VBoxContainer/Panel/LblName
onready var lblPos:Label = $VBoxContainer/CollapsibleMetadata/HBoxContainer/LblPos
onready var lblSize:Label = $VBoxContainer/CollapsibleMetadata/HBoxContainer2/LblSize
onready var textureRect:TextureRect = $VBoxContainer/CollapsiblePreview/TextureRect
onready var lblMetadata:Label = $VBoxContainer/CollapsibleMetadata/VBoxContainer/PanelContainer/lblMetadata

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
	pass

func _on_TextureRect_resized():
	pass # TODO

func _on_ButtonReveal_pressed():
	if cur_item_name == null: return
	Atlasica.ei.select_file(Atlasica._get_resource_path(cur_item_name))

func _on_ButtonEdit_pressed():
	if cur_item_name == null: return
	Atlasica.ei.edit_resource(Atlasica.get_sprite(cur_item_name))
