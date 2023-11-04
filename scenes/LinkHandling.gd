# AutoLoad that contains globally available information about links.
extends Node

signal link_type_changed(new_link_type : LinkType)

enum LinkType { Forward, StaticForward }
var all_link_types = LinkType.values()
var link_type : LinkType = LinkType.Forward

var link_objs = {}
var link_colors = {
	LinkType.Forward : Color(1, 0, 0),
	LinkType.StaticForward : Color(0, 1, 0)
}

func _ready():
	link_objs[LinkType.Forward] = preload("res://links/forward_link.tscn")
	link_objs[LinkType.StaticForward] = preload("res://links/static_forward_link.tscn")

func next_link_type(link_type : LinkType) -> LinkType:
	return (link_type + 1) % LinkType.size()

func prev_link_type(link_type : LinkType) -> LinkType:
	return (LinkType.size() + link_type - 1) % LinkType.size()
