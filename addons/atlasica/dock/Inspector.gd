tool
extends Container

const ImportSettingNames = [
	"Mipmaps", "Repeat", "Filter", "Anisotropic Linear", "Convert to Linear", "Mirrored Repeat", "Video Surface"
]

export var preview_sprite = false

onready var lblName:Label = $VBoxContainer/Panel/LblName
onready var lblPos:Label = $VBoxContainer/CollapsibleMetadata/HBoxContainer/LblPos
onready var lblSize:Label = $VBoxContainer/CollapsibleMetadata/HBoxContainer2/LblSize
onready var textureRect:TextureRect = $VBoxContainer/CollapsiblePreview/TextureRect
onready var lblMetadata:Label = $VBoxContainer/CollapsibleMetadata/VBoxContainer/PanelContainer/lblMetadata
onready var importSettingsRoot:Control = $VBoxContainer/CollapsibleImportSettings/Root

var cur_item_name = null
var cur_item_sprite:AtlasTexture = null

func _ready():
	modulate.a = 0
	textureRect.rect_min_size.y = textureRect.rect_size.x
	textureRect.rect_size.y = textureRect.rect_size.x
	
	# Set ImportSettings and connect event to checkboxes
	var i = 0
	for child in importSettingsRoot.get_children():
		child.text = ImportSettingNames[i]
		if !child.is_connected("toggled", self, "_on_ImportSetting_toggled"):
			child.connect("toggled", self, "_on_ImportSetting_toggled", [i])
		i += 1

func _on_item_hovered(item_name, item):
	cur_item_name = item_name
	cur_item_sprite = Atlasica.get_sprite(item_name)
	
	# Update all labels
	lblName.text = item_name
	lblPos.text = "(%d, %d)" % [item.x, item.y]
	lblSize.text = "(%d, %d)" % [item.w, item.h]
	lblMetadata.text = JSON.print(item.metadata, "  ")
	
	# Show/Hide and update sprite preview
	if preview_sprite and cur_item_sprite:
		textureRect.texture = Atlasica.get_sprite(item_name)
		textureRect.visible = true
	else:
		textureRect.visible = false
		
	# Set ImportSettings in checkboxes
	var i = 0
	for child in importSettingsRoot.get_children():
		var flag = cur_item_sprite.flags & int(pow(2, i))
		child.pressed = flag > 0
		i += 1
		
	modulate.a = 1

func _on_item_unhovered(_item_name, _item):
	pass # TODO
	
func _on_ImportSetting_toggled(pressed, i):
	print("ImportSetting ", i, ": ", pressed)
	
	# Update resources flags
	var flags = cur_item_sprite.flags
	if pressed:
		flags = flags | (1 << i)
	else:
		flags = flags & ~(1 << i)
	cur_item_sprite.flags = flags
	
	# update resource
	var path = Atlasica._get_resource_path(cur_item_name)
	Atlasica.ei.get_resource_filesystem().update_file(path)

func _on_TextureRect_resized():
	pass # TODO

func _on_ButtonReveal_pressed():
	if cur_item_name == null: return
	Atlasica.ei.select_file(Atlasica._get_resource_path(cur_item_name))

func _on_ButtonEdit_pressed():
	if cur_item_name == null: return
	Atlasica.ei.edit_resource(Atlasica.get_sprite(cur_item_name))
