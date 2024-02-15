extends ColorRect

func _ready():
    LinkHandling.link_type_changed.connect(_on_link_type_changed)

func _on_link_type_changed(link: LinkData):
    set_color(link.ui_color)
