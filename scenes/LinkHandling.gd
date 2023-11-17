# AutoLoad that contains globally available information about links.
extends Node

signal link_type_changed(new_link_type : LinkType)

enum LinkType { Forward, StaticForward, StaticReverse }
var all_link_types = LinkType.values()
var link_type : LinkType = LinkType.Forward

var link_info = {
    LinkType.Forward : {
        "color" : Color(0.165, 0.855, 0.91),
        "material" : preload("res://materials/glowing_panels/forward_link.tres"),
        "link" : preload("res://links/forward_link.tscn"),
    },
    LinkType.StaticForward : {
        "color" : Color(1, 0.686, 0.212),
        "material" : preload("res://materials/glowing_panels/static_forward_link.tres"),
        "link" : preload("res://links/static_forward_link.tscn"),
    },
    LinkType.StaticReverse : {
        "color" : Color(0.653, 0.464, 1),
        "material" : preload("res://materials/glowing_panels/static_reverse_link.tres"),
        "link" : preload("res://links/static_reverse_link.tscn")
    },
}

func next_link_type(current_link_type : LinkType) -> LinkType:
    return ((current_link_type + 1) % LinkType.size()) as LinkType

func prev_link_type(current_link_type : LinkType) -> LinkType:
    return ((LinkType.size() + current_link_type - 1) % LinkType.size()) as LinkType
