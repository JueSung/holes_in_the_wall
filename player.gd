extends CharacterBody2D
class_name Player

var gravity := 1875.
# const FRICTION_FACTOR_WALL = .05 # slow descent while on wall
const HORIZONTAL_SPEED: = 400.
const HORIZONTAL_AIR_FRICTION := 4000. # factor in which slows down horizontal velocity while in air
const JUMP_SPEED := 750.


const DASH_SPEED := 900.
const DASH_TIME := .18 # seconds (time length of dash)
var dash_timer := 0.0

var has_jumped: bool = false # so cant double jump
var has_released_up: bool = true # since last thing that occurred with up so that new action can be processed (basically to be able to effectively jump out of dash)
var dashing: bool = false
var has_dashed: bool = false # can only dash once per "air cycle" can't dash jump infinitely max should be jump dash jump

var wall_clutching: bool = false
const WALL_CLUTCH_FALL_SPEED: float = 70.
const WALL_JUMP_HOR_SPEED: float = 350. # horizontal jump speed off of wall_jump
const HORIZONTAL_WALL_JUMP_AIR_FRICTION := 1000.
const WALL_JUMP_FRICTION_TIME: float = .5 # time higher friction is applied
var wall_jump_friction_timer:= 0.0


var last_tick_on_floor: bool = true # on_floor from last tick - used for coyote time
var COYOTE_TIME := .05 # you get this many seconds to after falling off edge or dash ending to jump still
var COYOTE_TIME_POST_DASH := 0.9 # for after dashing, need a bit more maybe keep TODO
var coyote_timer := 0.

enum INPUTS {
	up,
	down,
	left,
	right,
	dash,
}

var inputs := {
	"up" : false,
	"down" : false,
	"left" : false,
	"right" : false,
	"dash" : false,
	

}

func _ready() -> void:
	pass

# used for taking in inputs
func _process(_delta):
	for input in INPUTS:
		if Input.is_action_pressed(input):
			inputs[input] = true
		else:
			inputs[input] = false
	


func _physics_process(delta: float) -> void:
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
			velocity *= Vector2(0.5, 0.7)
			coyote_timer = COYOTE_TIME_POST_DASH

	if coyote_timer > 0:
		coyote_timer -= delta
	if wall_jump_friction_timer > 0:
		wall_jump_friction_timer -= delta

	

	## handle horizontal velocity (just instantaneous probably)
	var dir = Vector2i.ZERO
	if inputs["left"]:
		dir.x -= 1
	if inputs["right"]:
		dir.x += 1
	
	if !dashing && is_on_floor(): # don't do while dashing or while in air (for in air, will be gradual slow)
		velocity.x = dir.x * HORIZONTAL_SPEED

	# var friction_factor := 1. # default 1 aka no friction
	if is_on_wall():
		if dashing:
			dashing = false
		if wall_jump_friction_timer > 0.0:
			wall_jump_friction_timer = 0.0
		
		if dir.length() != 0 && abs(get_wall_normal().angle_to(dir)) > .75 * PI:
			wall_clutching = true
			#TODO animation clutching wall type prep for jumping anyway
		else:
			wall_clutching = false
	else:
		wall_clutching = false
	
	

	if !is_on_floor():
		if !dashing: # don't apply gravity if dashing
			if velocity.y < 0: # going up
				if inputs["up"]: # holding up button, so higher jump
					velocity.y += gravity * delta
				else: # end jump soon
					velocity.y += 2.5 * gravity * delta
			else: # going down
				if wall_clutching:
					velocity.y = WALL_CLUTCH_FALL_SPEED
				else:
					velocity.y += 1.5 * gravity * delta
		if last_tick_on_floor && !has_jumped: # just left floor and wasn't by jumping
			print("EEE")
			coyote_timer = COYOTE_TIME
		

		# diff horizontal velocity stuff while in air
		var alpha = HORIZONTAL_AIR_FRICTION if wall_jump_friction_timer <= 0 else HORIZONTAL_WALL_JUMP_AIR_FRICTION
		velocity.x = move_toward(velocity.x, dir.x * HORIZONTAL_SPEED, alpha * delta)
	else:
		if has_jumped:
			has_jumped = false
		if has_dashed && !inputs["dash"]:
			has_dashed = false
		if wall_jump_friction_timer > 0.0:
			wall_jump_friction_timer = 0.0
	

	# can jump out of (and cancel) a dash
	if inputs["up"] && (((!has_jumped && (is_on_floor())) || ((dashing || wall_clutching || coyote_timer > 0) && has_released_up))):
		why_jump(has_jumped, is_on_floor(), dashing, wall_clutching, has_released_up, coyote_timer)
		print("RAN")
		coyote_timer = 0.
		has_jumped = true
		has_released_up = false
		velocity.y = -1. * JUMP_SPEED

		dashing = false
		
		if wall_clutching:
			# override horizontal velocity
			velocity.x = -1 * dir.x * WALL_JUMP_HOR_SPEED
			wall_jump_friction_timer = WALL_JUMP_FRICTION_TIME
	
	if !inputs["up"]:
		has_released_up = true


	# checking for dash
	if inputs["dash"] && !dashing && !has_dashed:
		# basicaly overwrite all velocity for dashing in one of the 8 directions
		# get vertical direction
		if inputs["up"]:
			dir.y -= 1
		if inputs["down"]:
			dir.y += 1
		
		if not dir.length() < 0.1: # make sure dir is not basically zero (is like int so should be at least 1 basically)
			velocity = DASH_SPEED * dir # overwites current velocity with dashing stuff
			dashing = true
			has_dashed = true
			dash_timer = DASH_TIME

	
	last_tick_on_floor = is_on_floor()
				
	move_and_slide()



# for testing
# (((!has_jumped && (is_on_floor())) || ((dashing || wall_clutching || coyote_timer > 0) && has_released_up)))
func why_jump(has_jumped_, is_on_floor_, dashing_, wall_clutching_, has_released_up_, coyote_timer_):
	print("!has_jumped && is_on_floor(): ", !has_jumped_ && is_on_floor_)
	print("dashing && has_released_up: ", dashing_ && has_released_up_)
	print("wall_clutching && has_released_up: ", wall_clutching_ && has_released_up_)
	print("coyote_timer > 0 && has_released_up: ", coyote_timer_ > 0 && has_released_up)
