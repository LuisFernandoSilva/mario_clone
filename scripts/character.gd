extends KinematicBody2D

# Esta é uma simples demonstração de colisão mostrando como
# o controlador cinemático funciona.
# move () permitirá mover o nó e
# sempre mova-o para um ponto que não colide,
# contanto que comece de um local que não colida também.

# Variáveis de membro
const GRAVITY = 500.0 # Pixels / segundo

# Ângulo em graus para cada lado que o jogador pode considerar "piso"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # Um pixel por segundo
const SLIDE_STOP_MIN_TRAVEL = 1.0 # Um pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _fixed_process(delta):
	# Criar forças
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if (walk_left):
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			force.x -= WALK_FORCE
			stop = false
	elif (walk_right):
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			force.x += WALK_FORCE
			stop = false
	
	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0
		
		velocity.x = vlen*vsign
	
	# Integrar forças à velocidade
	velocity += force*delta
	
	# Integre a velocidade ao movimento e mova-se
	var motion = velocity*delta
	
	# Mova e consuma o movimento
	motion = move(motion)
	
	var floor_velocity = Vector2()
	
	if (is_colliding()):
		# Você pode verificar qual tile foi colidido com este
		# print (get_collider_metadata ())
		
		# Correu contra alguma coisa, é o chão? Ficar normal
		var n = get_collision_normal()
		
		if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
			# Se o ângulo para os vetores "up" for <tolerância do ângulo
			# char está no chão
			on_air_time = 0
			floor_velocity = get_collider_velocity()
		
		if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
			# Como essa fórmula sempre deslizará o personagem,
			# um caso especial deve ser considerado para impedir que ele se mova
			# se estiver em um andar inclinado. Condições são:
			# 1) De pé no chão (on_air_time == 0)
			# 2) Não moveu mais de um pixel (get_travel (). Length () <SLIDE_STOP_MIN_TRAVEL)
			# 3) Não se movendo horizontalmente (abs (velocity.x) <SLIDE_STOP_VELOCITY)
			# 4) Collider não está se movendo
			
			revert_motion()
			velocity.y = 0.0
		else:
			# Para cada outro caso de movimento, nosso movimento foi interrompido.
			# Tente completar o movimento "deslizando" pelo normal
			motion = n.slide(motion)
			velocity = n.slide(velocity)
			# Então, mova-se novamente
			move(motion)
	
	if (floor_velocity != Vector2()):
		# Se o chão se mover, mova-se com o chão
		move(floor_velocity*delta)
	
	if (jumping and velocity.y > 0):
		# Se cair, não mais pular
		jumping = false
	
	if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping):
		# Jump também deve ser permitido se o personagem sair do chão um pouco atrás.
		# Torna os controles mais agitados.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump


func _ready():
	set_fixed_process(true)
