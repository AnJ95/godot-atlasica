tool
extends HBoxContainer

enum EditorIcons {
	StatusError,
	StatusWarning,
	StatusSuccess,
	Filesystem,
	ToolMove,
	ToolScale,
	AtlasTexture,
	AnimationTrackList, # TODO unused
	Tools # TODO unused
}

var themed_node:Control = null setget _set_themed_node

export(EditorIcons) var icon = EditorIcons.StatusError setget _set_icon
export(String) var text = "IconLabel" setget _set_text

func _ready():
	_set_icon(icon)


func _set_themed_node(v):
	themed_node = v
	if themed_node:
		$TextureRect.texture = themed_node.get_icon(EditorIcons.keys()[icon], "EditorIcons")
	else:
		$TextureRect.texture = null
		
func _set_icon(v):
	icon = v
	_set_themed_node(themed_node)
func _set_text(v):
	text = v
	$Label.text = text
