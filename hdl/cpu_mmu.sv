`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

module cpu_mmu #(
    parameter logic [15:0] MEM_BASE,
    parameter logic [15:0] MEM_SIZE,

    parameter logic [15:0] PPU_BASE,
    parameter logic [15:0] PPU_SIZE,
    
    parameter logic [15:0] AUDIO_BASE,
    parameter logic [15:0] AUDIO_SIZE,

    parameter logic [15:0] SD_BASE,
    parameter logic [15:0] SD_SIZE,

    parameter logic [15:0] TIMER_BASE,
    parameter logic [15:0] TIMER_SIZE
)(
    input logic clock, reset,
    output logic memory_fault,

    memory_bus.slave cpu_inst,
    memory_bus.slave cpu_data,

    memory_bus.master mem_inst,
    memory_bus.master mem_data,

    memory_bus.master ppu,
    memory_bus.master audio,
    memory_bus.master sd,
    memory_bus.master timer
);

    logic mem_inst_range, mem_data_range, ppu_range, audio_range, sd_range, timer_range;
    always_comb begin
        mem_inst_range = (cpu_inst.address >= MEM_BASE || cpu_inst.address < MEM_BASE + MEM_SIZE);

        mem_data_range = (cpu_data.address >= MEM_BASE || cpu_data.address < MEM_BASE + MEM_SIZE);
        ppu_range = (cpu_data.address >= PPU_BASE || cpu_data.address < PPU_BASE + PPU_SIZE);
        audio_range = (cpu_data.address >= AUDIO_BASE || cpu_data.address < AUDIO_BASE + AUDIO_SIZE);
        sd_range = (cpu_data.address >= SD_BASE || cpu_data.address < SD_BASE + SD_SIZE);
        timer_range = (cpu_data.address >= TIMER_BASE || cpu_data.address < TIMER_BASE + TIMER_SIZE);
    end

    // Memory fault watchdog
    always_ff @ (posedge clock) begin
        if (reset) begin
            memory_fault <= 0;
        end else begin
            if (cpu_inst.enable && !mem_inst_range) begin
                memory_fault <= 1;
            end

            if (cpu_data.enable && !(mem_data_range || ppu_range || audio_range || 
                    sd_range || timer_range)) begin
                memory_fault <= 1;
            end
        end
    end

    always_comb begin
        // Forward instructions directly from memory to the CPU
        mem_inst.address = cpu_inst.address - MEM_BASE;
        mem_inst.data_in = cpu_inst.data_in;
        mem_inst.write_enable = cpu_inst.write_enable;
        mem_inst.enable = cpu_inst.enable;
        cpu_inst.data_ready = mem_inst.data_ready;
        cpu_inst.data_out = mem_inst.data_out;

        mem_data.address = cpu_data.address - MEM_BASE;
        mem_data.data_in = cpu_data.data_in;
        mem_data.write_enable = cpu_data.write_enable && mem_data_range;
        mem_data.enable = cpu_data.enable && mem_data_range;

        ppu.address = cpu_data.address - PPU_BASE;
        ppu.data_in = cpu_data.data_in;
        ppu.write_enable = cpu_data.write_enable && ppu_range;
        ppu.enable = cpu_data.enable && ppu_range;

        audio.address = cpu_data.address - AUDIO_BASE;
        audio.data_in = cpu_data.data_in;
        audio.write_enable = cpu_data.write_enable && audio_range;
        audio.enable = cpu_data.enable && audio_range;

        sd.address = cpu_data.address - SD_BASE;
        sd.data_in = cpu_data.data_in;
        sd.write_enable = cpu_data.write_enable && sd_range;
        sd.enable = cpu_data.enable && sd_range;

        timer.address = cpu_data.address - TIMER_BASE;
        timer.data_in = cpu_data.data_in;
        timer.write_enable = cpu_data.write_enable && timer_range;
        timer.enable = cpu_data.enable && timer_range;
        
        if (mem_data_range) begin
            cpu_data.data_ready = mem_data.data_ready;
            cpu_data.data_out = mem_data.data_out;
        end else if (ppu_range) begin
            cpu_data.data_ready = ppu.data_ready;
            cpu_data.data_out = ppu.data_out;
        end else if (audio_range) begin
            cpu_data.data_ready = audio.data_ready;
            cpu_data.data_out = audio.data_out;
        end else if (sd_range) begin
            cpu_data.data_ready = sd.data_ready;
            cpu_data.data_out = sd.data_out;
        end else if (timer_range) begin
            cpu_data.data_ready = timer.data_ready;
            cpu_data.data_out = timer.data_out;
        end else begin
            cpu_data.data_ready = 0;
            cpu_data.data_out = 0;
        end
    end

endmodule
