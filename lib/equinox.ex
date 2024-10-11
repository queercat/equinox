defmodule WASM4 do
  use Orb.Import, name: "env"

  defw blit(sprite_pointer: I32, x: I32, y: I32, width: I32, height: I32, flags: I32)
  defw blit_sub(sprite_pointer: I32, x: I32, y: I32, width: I32, height: I32, source_x: I32, source_y: I32, stride: I32, flags: I32)
  defw line(x1: I32, y1: I32, x2: I32, y2: I32)
  defw hline(x: I32, y: I32, length: I32)
  defw vline(x: I32, y: I32, length: I32)
  defw oval(x: I32, y: I32, width: I32, height: I32)
  defw rect(x: I32, y: I32, width: I32, height: I32)
  defw text(text: I32, x: I32, y: I32)

  defw tone(frequency: I32, duration: I32, volume: I32, flags: I32)

  defw disk_read(destination_pointer: I32, size: I32)
  defw disk_write(source_pointer: I32, size: I32)

  defw trace(value: I32)
end

defmodule Game do
  use Orb

  global do
    @pallete01 0x0004
    @pallete02 0x0008
    @pallete03 0x000C
    @pallete04 0x0010

    @colors 0x0014

    @gamepads 0x0016

    @mouse_x 0x001A
    @mouse_y 0x001C
    @mouse_buttons 0x001E
    @system_flags 0x001F
    @netplay 0x0020
    @framebuffer 0x00A0
    @memory 0x19A0
  end

  Orb.Import.register(WASM4)
  Orb.Import.register_memory(:env, :memory, 1)

  defw update() do
  end

  defw write(address: I32, value: I32) do
    Memory.store!(I32, address, value)
  end

  defw start() do
  end
end

defmodule Equinox do
  use Application

  def start(_type, _args) do
    File.write!("./Game.wat", Game.to_wat() |> IO.iodata_to_binary())

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
