module gfxe

pub struct Vector2{
	pub mut:
		x f32
		y f32
}

pub fn (a Vector2) + (b Vector2) Vector2{
	return Vector2{
		x: a.x + b.x,
		y: a.y + b.y,
	}
}

pub fn (vec Vector2) scale(s f32) Vector2{
	return Vector2{
		x: s * vec.x,
		y: s * vec.y,
	}
}