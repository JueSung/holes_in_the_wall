extends CharacterBody2D
class_name Player

var gravity := 1875.
# const FRICTION_FACTOR_WALL = .05 # slow descent while on wall
const HORIZONTAL_SPEED: = 400.
const HORIZONTAL_AIR_FRICTION := 4000. # factor in which slows down horizontal velocity while in air
const JUMP_SPEED := 750.


const DASH_SPEED := 800.
const DASH_TIME := .18 # seconds (time length of dash)
var dash_timer := 0.0

const DASH_PAUSE_TIME := .017 * 3 # time freezes between dash button pressed and dash happening
var dash_pause_timer := 0.0
var dash_velocity_to_be := Vector2(0.0, 0.0) # gets set when dash activated, gets actually used when pause_timer done

var has_jumped: bool = false # so cant double jump
var has_released_up: bool = true # since last thing that occurred with up so that new action can be processed (basically to be able to effectively jump out of dash)
var dashing: bool = false
var has_dashed: bool = false # can only dash once per "air cycle" can't dash jump infinitely max should be jump dash jump
var has_released_dash: bool = true
var dash_cooldown_timer := 0.0
const DASH_COOLDOWN := 0.4 # half second cooldown cant just spam dash

var wall_clutching: bool = false
const WALL_CLUTCH_FALL_SPEED: float = 70.
const WALL_JUMP_HOR_SPEED: float = 350. # horizontal jump speed off of wall_jump
const HORIZONTAL_WALL_JUMP_AIR_FRICTION := 850.
const WALL_JUMP_FRICTION_TIME: float = .5 # time higher friction is applied
var wall_jump_friction_timer:= 0.0


var last_tick_on_floor: bool = true # on_floor from last tick - used for coyote time
var COYOTE_TIME := .05 # you get this many seconds to after falling off edge or dash ending to jump still
var COYOTE_TIME_POST_DASH := 0.1 # for after dashing, need a bit more maybe keep TODO
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
	if dash_pause_timer >= 0.0:
		dash_pause_timer -= delta
		if dash_pause_timer <= 0.0:
			velocity = dash_velocity_to_be
			dashing = true
			dash_timer = DASH_TIME
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false
			velocity *= Vector2(0.5, 0.7)
			coyote_timer = COYOTE_TIME_POST_DASH
			dash_cooldown_timer = DASH_COOLDOWN

			set_animation("idle", Vector2.ZERO)

	if coyote_timer > 0:
		coyote_timer -= delta
	if wall_jump_friction_timer > 0:
		wall_jump_friction_timer -= delta
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	

	## handle horizontal velocity (just instantaneous probably)
	var dir = Vector2i.ZERO
	if inputs["left"]:
		dir.x -= 1
	if inputs["right"]:
		dir.x += 1
	
	if !dashing && is_on_floor(): # don't do while dashing or while in air (for in air, will be gradual slow)
		velocity.x = dir.x * HORIZONTAL_SPEED

		if abs(velocity.x) > 0:
			set_animation("run", dir)
		else:
			set_animation("idle", dir)

	# var friction_factor := 1. # default 1 aka no friction
	if is_on_wall():
		if dashing:
			dashing = false
			dash_cooldown_timer = DASH_COOLDOWN
			
		if wall_jump_friction_timer > 0.0:
			wall_jump_friction_timer = 0.0
		
		if dir.length() != 0 && abs(get_wall_normal().angle_to(dir)) > .75 * PI:
			wall_clutching = true
			coyote_timer = COYOTE_TIME # for jumping off wall
			#TODO animation clutching wall type prep for jumping anyway
			has_dashed = false # TODO maybe turn off basically refreshes dash when clutching wall
			
			set_animation("wall_clutch", dir)
		else:
			wall_clutching = false
			if $AnimatedSprite2D.animation == "wall_clutch":
				set_animation("idle", dir)
	else:
		wall_clutching = false
		if $AnimatedSprite2D.animation == "wall_clutch":
			set_animation("idle", dir)
		
	
	

	if !is_on_floor():
		if !dashing && !dash_pause_timer >= 0: # don't apply gravity if dashing
			if velocity.y < 0: # going up
				if !inputs["up"] && !has_released_up: # runs moment released up while jumping - has_released_up gets set later
					velocity.y /= 2.
					#velocity.y += 2.5 * gravity * delta
				else: # still holding up -- higher jump or released_up already happened, and just still gravity
					if abs(velocity.y) >= 200:
						velocity.y += gravity * delta
					else:
						velocity.y += .75 * gravity * delta
			else: # going down
				if wall_clutching:
					velocity.y = WALL_CLUTCH_FALL_SPEED
				else:
					# TODO remove after getting sprites for jumping/in air
					if abs(velocity.y) >= 200:
						velocity.y += 1.5 * gravity * delta
					else:
						velocity.y += 1. * gravity * delta
		
		
			# diff horizontal velocity stuff while in air
			var alpha = HORIZONTAL_AIR_FRICTION if wall_jump_friction_timer <= 0 else HORIZONTAL_WALL_JUMP_AIR_FRICTION
			velocity.x = move_toward(velocity.x, dir.x * HORIZONTAL_SPEED, alpha * delta)
		
		if last_tick_on_floor && !has_jumped: # just left floor and wasn't by jumping
			coyote_timer = COYOTE_TIME
		
	else:
		if dir.x == 0 && inputs["down"]: # not moving and want to crouch
			# set hitbox diff and sprite diff TODO
			set_animation("crouch", dir)


		if has_jumped:
			has_jumped = false
		if has_dashed && !inputs["dash"]:
			has_dashed = false
		if wall_jump_friction_timer > 0.0:
			wall_jump_friction_timer = 0.0
	

	# can jump out of (and cancel) a dash
	if inputs["up"] && (((!has_jumped && (is_on_floor())) || ((dashing || wall_clutching || coyote_timer > 0) && has_released_up))):
		#why_jump(has_jumped, is_on_floor(), dashing, wall_clutching, has_released_up, coyote_timer)
		#print("RAN")
		coyote_timer = 0.
		has_jumped = true
		has_released_up = false
		velocity.y = -1. * JUMP_SPEED

		set_animation("idle", dir) # TODO change to some jump one?

		if dashing:
			dashing = false
			dash_cooldown_timer = DASH_COOLDOWN
			# if was dashing, kill horizontal velocity
			velocity.x = 0

		
		if wall_clutching:
			# override horizontal velocity
			velocity.x = -1 * dir.x * WALL_JUMP_HOR_SPEED
			wall_jump_friction_timer = WALL_JUMP_FRICTION_TIME
	
	if !inputs["up"]:
		has_released_up = true
	if !inputs["dash"]:
		has_released_dash = true


	# checking for dash
	if inputs["dash"] && !dashing && !has_dashed && !wall_clutching && has_released_dash && dash_cooldown_timer <= 0.0:
		
		# basicaly overwrite all velocity for dashing in one of the 8 directions
		# get vertical direction
		if inputs["up"]:
			dir.y -= 1
		if inputs["down"]:
			dir.y += 1
		
		if not dir.length() < 0.1: # make sure dir is not basically zero (is like int so should be at least 1 basically)
			has_released_dash = false
			has_released_up = false # so doesn't auto jump if pressed jump again inbetween first jump and dash

			has_dashed = true
			dash_pause_timer = DASH_PAUSE_TIME
			velocity = Vector2(0,0)
			dash_velocity_to_be = DASH_SPEED * Vector2(dir).normalized() # overwites current velocity with dashing stuff
			
			set_animation("dash", dir)

	
	last_tick_on_floor = is_on_floor()

	# set terminal velocity for falling y # TODO maybe keep idk
	if velocity.y > 1300:
		velocity.y = 1300

	# # TODO idk if like maybe get rid of
	# match $AnimatedSprite2D.animation:
	# 	"idle":
	# 		$AnimatedSprite2D.scale = Vector2(0.6 * (1 - abs(velocity.y/6000.)), 0.6 * (1+abs(velocity.y / 6000.)))
	# 	"run":
	# 		$AnimatedSprite2D.scale = Vector2(0.6 * (1 - abs(velocity.y/6000.)), 0.6 * (1+abs(velocity.y / 6000.)))
	# 	"dash":
	# 		$AnimatedSprite2D.scale = Vector2(0.6 * (1 - abs(velocity.y/6000.)), 0.6 * (1+abs(velocity.y / 6000.)))
	# 	"wall_clutch":
	# 		$AnimatedSprite2D.scale = Vector2(0.1 * (1 - abs(velocity.y/6000.)), 0.1 * (1+abs(velocity.y / 6000.)))

				
	move_and_slide()



# dir is vector describing direction looking rn
func set_animation(animation_name, dir):
	var animatedSprite2D = $AnimatedSprite2D
	animatedSprite2D.rotation = 0
	match animation_name:
		"idle":
			animatedSprite2D.animation = "idle"
			animatedSprite2D.flip_h = false
			animatedSprite2D.offset = Vector2(-340., -1007)
			animatedSprite2D.scale = Vector2(0.6, 0.6)
			$CollisionShape2D.disabled = false
			$crouch_hitbox.disabled = true
		"crouch":
			animatedSprite2D.animation = "crouch"
			animatedSprite2D.flip_h = false
			animatedSprite2D.offset = Vector2(-341., -967.)
			animatedSprite2D.scale = Vector2(0.6, 0.6)
			$CollisionShape2D.disabled = true
			$crouch_hitbox.disabled = false
		"run":
			animatedSprite2D.animation = "run"
			if dir.x > 0:
				animatedSprite2D.flip_h = false
				animatedSprite2D.offset = Vector2(-496., -1007.)
				animatedSprite2D.scale = Vector2(0.6, 0.6)
			else:
				animatedSprite2D.flip_h = true
				animatedSprite2D.offset = Vector2(496., -1007.)
				animatedSprite2D.scale = Vector2(0.6, 0.6)

			$CollisionShape2D.disabled = false
			$crouch_hitbox.disabled = true
		"dash":
			animatedSprite2D.animation = "dash"
			animatedSprite2D.flip_h = false
			animatedSprite2D.offset = Vector2(-646., -785.)
			animatedSprite2D.scale = Vector2(0.6, 0.6)
			animatedSprite2D.rotation = atan2(dir.y, dir.x) + PI/2.
			$CollisionShape2D.disabled = false
			$crouch_hitbox.disabled = true
		"wall_clutch":
			animatedSprite2D.animation = "wall_clutch"
			if dir.x > 0:
				animatedSprite2D.flip_h = false
				animatedSprite2D.offset = Vector2(-724., -783.)
				animatedSprite2D.scale = Vector2(0.6, 0.6)
			else:
				animatedSprite2D.flip_h = true
				animatedSprite2D.offset = Vector2(724., -783.)
				animatedSprite2D.scale = Vector2(0.6, 0.6)

			$CollisionShape2D.disabled = false
			$crouch_hitbox.disabled = true
		"jump":
			pass
			# animatedSprite2D.animation = "jump"
			# animatedSprite2D.offset = Vector2(-646., -799.)
			# animatedSprite2D.scale = Vector2(0.6, 0.6)
			# $CollisionShape2D.disabled = false
			# $crouch_hitbox.disabled = true
		"land":
			animatedSprite2D.animation = "land"
			animatedSprite2D.flip_h = false
			animatedSprite2D.offset = Vector2(-724., -775.)
			animatedSprite2D.scale = Vector2(0.6, 0.6)
			$CollisionShape2D.disabled = false
			$crouch_hitbox.disabled = true

	
	animatedSprite2D.play()




# for testing
# (((!has_jumped && (is_on_floor())) || ((dashing || wall_clutching || coyote_timer > 0) && has_released_up)))
func why_jump(has_jumped_, is_on_floor_, dashing_, wall_clutching_, has_released_up_, coyote_timer_):
	print("!has_jumped && is_on_floor(): ", !has_jumped_ && is_on_floor_)
	print("dashing && has_released_up: ", dashing_ && has_released_up_)
	print("wall_clutching && has_released_up: ", wall_clutching_ && has_released_up_)
	print("coyote_timer > 0 && has_released_up: ", coyote_timer_ > 0 && has_released_up)
