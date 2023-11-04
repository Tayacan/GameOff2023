extends ColorRect

func _ready():
	LinkHandling.link_type_changed.connect(_on_link_type_changed)

func _on_link_type_changed(link_type):
	set_color(LinkHandling.link_colors[link_type])
