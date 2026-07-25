extends Node2D

var chosen_map = ""

@onready var maps = [$Map1_button, $Map2_button, $Map3_button, $Map4_button]

# func map1():
# 	$Map2_button.button_pressed = false
# 	$Map3_button.button_pressed = false
# 	chosen_map = "res://maps/map_1.tscn"
# func map2():
# 	$Map1_button.button_pressed = false
# 	$Map3_button.button_pressed = false
# 	chosen_map = "res://maps/map_2.tscn"
# func map3():
# 	$Map1_button.button_pressed = false
# 	$Map2_button.button_pressed = false
# 	chosen_map = "res://maps/map_3.tscn"

func map_chosen(num: int):
	chosen_map = "res://maps/map_" + str(num) + ".tscn"
	for i in range(len(maps)):
		if num != i+1:
			maps[i].button_pressed = false


func get_chosen_map():
	return chosen_map
