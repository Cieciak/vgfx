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

fn (tile Tile) draw(mut ge gfxe.GFXEngine, ctx gfxe.LocalContex){
    gg     := ge.get_ctx()
    radius := .10 * (tile.size.x + tile.size.y)

    gg.draw_rounded_rect_filled(
        ctx.scale * tile.position.x + ctx.offset.x,
        ctx.scale * tile.position.y + ctx.offset.y,
        ctx.scale * tile.size.x,
        ctx.scale * tile.size.y,
        ctx.scale * radius,
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
    l0.ctx = gfxe.LocalContex{
        offset: gfxe.Vector2{x:0, y: 0}
        scale: 2.0
    }
    l0.add_complex(
        new_grid(4, 4)
    )

    scene.ctx = gfxe.LocalContex{
        offset: gfxe.Vector2{x:0, y:0},
        scale: 1.0
    }
    scene.add_layer(l0)

    gfx_engine.set_scene(scene)

    gfx_engine.run()
}