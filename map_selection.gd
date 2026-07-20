extends Node2D

var chosen_map = ""


func map1():
	$Map2_button.button_pressed = false
	$Map3_button.button_pressed = false
	chosen_map = "res://maps/map_1.tscn"
func map2():
	$Map1_button.button_pressed = false
	$Map3_button.button_pressed = false
	chosen_map = "res://maps/map_2.tscn"
func map3():
	$Map1_button.button_pressed = false
	$Map2_button.button_pressed = false
	chosen_map = "res://maps/map_3.tscn"


func get_chosen_map():
	return chosen_map
