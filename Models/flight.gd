extends CharacterBody3D

const SPEED = 500
const FLAP_NEUTRAL = PI/2
const FLAP_UP = -PI/4
const FLAP_DOWN = PI/4

@onready var leftFlapAxis = $FlapAxisLeft
@onready var rightFlapAxis = $FlapAxisRight

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta


	var input_dir = Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	
	var roll = -input_dir[0]
	var pitch = input_dir[1]
	var forward = -transform.basis.z
	
	var z_axis_rotation = rotation.z # -PI..PI
	var z_rotation_normalized = z_axis_rotation / PI # -1..1
	if z_rotation_normalized > 0.5:
		z_rotation_normalized = 1 - z_rotation_normalized
	elif z_rotation_normalized < -0.5:
		z_rotation_normalized = -1 - z_rotation_normalized
	
	# give a little yaw rotation based on current z rotation
	var yaw_drift = z_rotation_normalized * PI * 1.22 * delta

	rotate(transform.basis.z, roll * 1.2 * delta)
	#rotate(transform.basis.x, pitch  * delta)
	rotate_y(yaw_drift)

	# animate the flaps for fun
	leftFlapAxis.rotation.x = FLAP_NEUTRAL
	rightFlapAxis.rotation.x = FLAP_NEUTRAL

	if roll < 0:
		leftFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
		rightFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_UP
	elif roll > 0:
		leftFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_UP
		rightFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
	
	if pitch > 0:
		leftFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_UP
		rightFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_UP
	elif pitch < 0:
		leftFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
		rightFlapAxis.rotation.x = FLAP_NEUTRAL + FLAP_DOWN
	
	
	velocity = forward * SPEED * delta
	move_and_slide()
