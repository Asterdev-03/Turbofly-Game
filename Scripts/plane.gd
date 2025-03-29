extends CharacterBody3D

@onready var cameraController = $CameraController

const FORWARD_SPEED := 2000.0
const MAX_ROTATE := 0.35
const ROTATION_SPEED := 4.0
const ROTATION_HOLD_TIME := 0.3

var hold_timer := 0.0

func _physics_process(delta):	
	# Get the input direction and handle the movement
	var input_dir = Input.get_axis("move_left","move_right")
	var roll = -input_dir
	var forward = -transform.basis.z

	# Update hold_timer based on input direction
	if input_dir != 0:
		hold_timer += delta
	else:
		hold_timer = 0.0
	
	var z_axis_rotation = rotation.z # -PI..PI
	var z_rotation_normalized = z_axis_rotation / PI # -1..1

	# give a little yaw rotation based on current z rotation
	var yaw_drift = z_rotation_normalized * PI * ROTATION_SPEED * delta

	rotate_y(yaw_drift)
	rotation.z = lerp(rotation.z,MAX_ROTATE * roll,0.05)

	velocity = forward * FORWARD_SPEED * delta

	move_and_slide()
