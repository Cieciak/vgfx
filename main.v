module main

import gfxe

import gx
import rand

const max_obj_pass = 1024

// Get random rgb color
fn rand_rgb() gx.Color{
    return gx.Color{
        r: rand.u8(),
        g: rand.u8(),
        b: rand.u8(),
    }
}

struct Vector2{
    x f32
    y f32
}

struct Tile{
    position Vector2
    size     Vector2
    color    gx.Color
}

fn (tile Tile) cost() int{return 1}

fn (tile Tile) draw(mut ge gfxe.GFXEngine){
    gg     := ge.get_ctx()
    radius := .05 * (tile.size.x + tile.size.y)

    gg.draw_rounded_rect_filled(
        tile.position.x,
        tile.position.y,
        tile.size.x,
        tile.size.y,
        radius,
        tile.color,
    )
}

struct Grid{
    mut:
        position Vector2
        field [][]Tile

        x int
        y int
}

fn (grid Grid) cost() int{return grid.x * grid.y}

fn (grid Grid) flatten() []gfxe.Simple{
    mut simple := []gfxe.Simple{}
    for i in 0..grid.x{
        for j in 0..grid.y{
            simple << grid.field[i][j]
        }
    }
    return simple
}

fn new_grid(x int, y int) Grid{
    mut g := Grid{x: x, y: y}
    for i in 0..x{
        mut col := []Tile{}
        for j in 0..y{
            col << Tile{
                position: Vector2{x: i * 60, y: j * 60},
                size:     Vector2{x: 50, y: 50},
                color:    rand_rgb(),
            }
        }
        g.field << col
    }
    return g
}

fn main() {
    mut gfx_engine := gfxe.new_gfxe()

    mut scene := &gfxe.Scene{}

    mut l0 := gfxe.Layer{}
    l0.add_simple(
        Tile{
            position: Vector2{x: 300, y: 300},
            size:     Vector2{x: 50,  y:  50},
            color:    rand_rgb(),
        }
    )
    l0.add_complex(
        new_grid(4, 4)
    )

    scene.add_layer(l0)

    gfx_engine.set_scene(scene)

    gfx_engine.run()
}