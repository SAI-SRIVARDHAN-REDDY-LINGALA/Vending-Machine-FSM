//==================================================
// Vending Machine (Mealy Model)
// Accepts ₹5 and ₹10 coins
// Product Price: ₹15
// Returns ₹5 if ₹20 inserted
//==================================================

`timescale 1ns / 1ps

module vending_machine (
    input wire clk,       // Clock
    input wire reset,     // Asynchronous reset
    input wire I,         // Coin insertion (1 = coin inserted)
    input wire J,         // Coin type (0 = ₹5, 1 = ₹10)
    output reg X,         // Product delivery
    output reg Y          // ₹5 return
);

    //===========================
    // State Encoding
    //===========================
    localparam S_IDLE       = 2'b00;
    localparam S_5_RUPEES   = 2'b01;
    localparam S_10_RUPEES  = 2'b10;

    // Current & Next State
    reg [1:0] current_state, next_state;

    //===========================
    // Sequential Block: State Update
    //===========================
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    //===========================
    // Combinational Block: Next State & Outputs
    //===========================
    always @(*) begin
        // Default values
        next_state = current_state;
        X = 1'b0;
        Y = 1'b0;

        case (current_state)

            //================================
            // STATE: S_IDLE (₹0 received)
            //================================
            S_IDLE: begin
                if (I) begin
                    if (J) // ₹10 coin
                        next_state = S_10_RUPEES;
                    else   // ₹5 coin
                        next_state = S_5_RUPEES;
                end
            end

            //================================
            // STATE: S_5_RUPEES (₹5 received)
            //================================
            S_5_RUPEES: begin
                if (I) begin
                    if (J) begin
                        // ₹10 coin → ₹15 total → deliver product
                        X = 1'b1;
                        Y = 1'b0;
                        next_state = S_IDLE;
                    end
                    else begin
                        // ₹5 coin → ₹10 total
                        next_state = S_10_RUPEES;
                    end
                end
            end

            //================================
            // STATE: S_10_RUPEES (₹10 received)
            //================================
            S_10_RUPEES: begin
                if (I) begin
                    if (J) begin
                        // ₹10 coin → ₹20 total → product + ₹5 return
                        X = 1'b1;
                        Y = 1'b1;
                        next_state = S_IDLE;
                    end
                    else begin
                        // ₹5 coin → ₹15 total → product only
                        X = 1'b1;
                        Y = 1'b0;
                        next_state = S_IDLE;
                    end
                end
            end

            default: begin
                next_state = S_IDLE;
                X = 1'b0;
                Y = 1'b0;
            end

        endcase
    end

endmodule