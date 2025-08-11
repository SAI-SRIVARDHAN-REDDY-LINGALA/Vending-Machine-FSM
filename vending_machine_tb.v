module vending_machine_tb;

    reg clk, reset, I, J;
    wire X, Y;

    // Action string for descriptions
    reg [200*8:1] action; // Enough space for descriptions

    // Instantiate DUT
    vending_machine dut (
        .clk(clk),
        .reset(reset),
        .I(I),
        .J(J),
        .X(X),
        .Y(Y)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("vending_machine.vcd");
        $dumpvars(0, vending_machine_tb);

        // Monitor for terminal output with event description
        $monitor("Time=%0t | clk=%b reset=%b I=%b J=%b | X=%b Y=%b | %s",
                 $time, clk, reset, I, J, X, Y, action);

        // Initialize
        clk = 0;
        reset = 1;
        I = 0;
        J = 0;
        action = "Reset active";

        // Reset pulse
        #10 reset = 0; action = "Machine ready (no coins)";

        // Test case 1: Rs. 5 + Rs. 10 = Rs. 15 (product only)
        #10 I = 1; J = 0; action = "Inserted Rs.5 coin";
        #10 I = 0; J = 0; action = "Waiting for next coin";
        #10 I = 1; J = 1; action = "Inserted Rs.10 coin → Should dispense product";
        #10 I = 0; J = 0; action = "Idle after product dispense";

        // Test case 2: Rs. 10 + Rs. 5 = Rs. 15 (product only)
        #10 I = 1; J = 1; action = "Inserted Rs.10 coin";
        #10 I = 0; J = 0; action = "Waiting for next coin";
        #10 I = 1; J = 0; action = "Inserted Rs.5 coin → Should dispense product";
        #10 I = 0; J = 0; action = "Idle after product dispense";

        // Test case 3: Rs. 10 + Rs. 10 = Rs. 20 (product + change)
        #10 I = 1; J = 1; action = "Inserted Rs.10 coin";
        #10 I = 0; J = 0; action = "Waiting for next coin";
        #10 I = 1; J = 1; action = "Inserted Rs.10 coin → Should dispense product + Rs.5 change";
        #10 I = 0; J = 0; action = "Idle after product + change dispense";

        // Test case 4: Rs. 5 + Rs. 5 + Rs. 5 = Rs. 15 (product only)
        #10 I = 1; J = 0; action = "Inserted Rs.5 coin";
        #10 I = 0; J = 0; action = "Waiting for next coin";
        #10 I = 1; J = 0; action = "Inserted Rs.5 coin";
        #10 I = 0; J = 0; action = "Waiting for next coin";
        #10 I = 1; J = 0; action = "Inserted Rs.5 coin → Should dispense product";
        #10 I = 0; J = 0; action = "Idle after product dispense";

        #20 $finish;
    end

endmodule