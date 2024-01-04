`timescale 1ns / 1ps

module phase_2_tb;
    parameter WIDTH = 32;
    parameter CYCLE_PER_STAGE = 41;

    reg clk_i;
    reg rst_i;
    reg [WIDTH-1:0] T_x_reg, T_y_reg, T_z_reg;
    reg [WIDTH-1:0] P_x_reg, P_y_reg, P_z_reg;
    reg [WIDTH-1:0] V_x_reg, V_y_reg, V_z_reg;
    reg [WIDTH-1:0] Q_x_reg, Q_y_reg, Q_z_reg;
    reg [WIDTH-1:0] Temp_u_reg, Temp_v_reg, Temp_u_v_reg;
	reg Valid_reg;

    wire [WIDTH-1:0] T_x, T_y, T_z;
    wire [WIDTH-1:0] P_x, P_y, P_z;
    wire [WIDTH-1:0] V_x, V_y, V_z;
    wire [WIDTH-1:0] Q_x, Q_y, Q_z;

    // wire [WIDTH-1:0] T_P_Mul_x, T_P_Mul_y, T_P_Mul_z;
    // wire [WIDTH-1:0] T_P_Add_xy, T_P_Add_xyz;
    
    // wire [WIDTH-1:0] V_Q_Mul_x, V_Q_Mul_y, V_Q_Mul_z;
    // wire [WIDTH-1:0] V_Q_Add_xy, V_Q_Add_xyz;

    wire [WIDTH-1:0] Temp_u, Temp_v, Temp_u_v;
	wire Valid;

    integer r_file, w_file;
    integer scan_file;
    integer i;

    phase_2 #(.WIDTH(WIDTH), .CYCLE_PER_STAGE(CYCLE_PER_STAGE)) phase_2_test
    (
        .clk_i(clk_i),
        .rst_i(rst_i),
        
        .T_x(T_x), .T_y(T_y), .T_z(T_z),
        .P_x(P_x), .P_y(P_y), .P_z(P_z),
        
        .V_x(V_x), .V_y(V_y), .V_z(V_z),
        .Q_x(Q_x), .Q_y(Q_y), .Q_z(Q_z),

        // .T_P_Mul_x(T_P_Mul_x), .T_P_Mul_y(T_P_Mul_y), .T_P_Mul_z(T_P_Mul_z),
        // .T_P_Add_xy(T_P_Add_xy), .T_P_Add_xyz(T_P_Add_xyz),

        // .V_Q_Mul_x(V_Q_Mul_x), .V_Q_Mul_y(V_Q_Mul_y), .V_Q_Mul_z(V_Q_Mul_z),
        // .V_Q_Add_xy(V_Q_Add_xy), .V_Q_Add_xyz(V_Q_Add_xyz),

        .Temp_u(Temp_u), .Temp_v(Temp_v), .Temp_u_v(Temp_u_v),
        .Valid(Valid)
    );

    assign T_x = T_x_reg;
    assign T_y = T_y_reg;
    assign T_z = T_z_reg;
    assign P_x = P_x_reg;
    assign P_y = P_y_reg;
    assign P_z = P_z_reg;
    assign V_x = V_x_reg;
    assign V_y = V_y_reg;
    assign V_z = V_z_reg;
    assign Q_x = Q_x_reg;
    assign Q_y = Q_y_reg;
    assign Q_z = Q_z_reg;

    initial begin
        clk_i = 0;
        forever #10 clk_i = ~clk_i;
    end

    initial begin
        rst_i = 1;
        T_x_reg = 0;
        T_y_reg = 0;
        T_z_reg = 0;
        P_x_reg = 0;
        P_y_reg = 0;
        P_z_reg = 0;
        V_x_reg = 0;
        V_y_reg = 0;
        V_z_reg = 0;
        Q_x_reg = 0;
        Q_y_reg = 0;
        Q_z_reg = 0;
        Temp_u_reg = 0;
        Temp_v_reg = 0;
        Temp_u_v_reg = 0;
        Valid_reg = 0;

        #100;
        rst_i = 0;

        r_file = $fopen("/home/ycpinlabpc/Desktop/Ray-Tracing/test_generator/TestFile.txt", "r");
        w_file = $fopen("/home/ycpinlabpc/Desktop/Ray-Tracing/test_generator/SampleFile.txt", "w");
        $fclose(w_file);

        while (!$feof(r_file)) begin
            scan_file = $fscanf(r_file, "%h %h %h %h %h %h %h %h %h %h %h %h %h %h %h %d\n", 
                                T_x_reg, T_y_reg, T_z_reg, 
                                P_x_reg, P_y_reg, P_z_reg, 
                                V_x_reg, V_y_reg, V_z_reg, 
                                Q_x_reg, Q_y_reg, Q_z_reg,
                                Temp_u_reg, Temp_v_reg, Temp_u_v_reg, Valid_reg);
            
            if (Valid == 1) begin
                w_file = $fopen("/home/ycpinlabpc/Desktop/Ray-Tracing/test_generator/SampleFile.txt", "a");
                $fwrite(w_file, "%h %h %h\n", Temp_u, Temp_v, Temp_u_v);
                $fclose(w_file);
            end

            #20;
        end

        for (i = 1; i <= 40; i = i+1) begin
            if (Valid == 1) begin
                $fwrite(w_file, "%h %h %h\n", Temp_u, Temp_v, Temp_u_v);
            end
            #20;
        end

        $fclose(r_file);
        $fclose(w_file);

        // Finish simulation
        T_x_reg = 0;
        T_y_reg = 0;
        T_z_reg = 0;
        P_x_reg = 0;
        P_y_reg = 0;
        P_z_reg = 0;
        V_x_reg = 0;
        V_y_reg = 0;
        V_z_reg = 0;
        Q_x_reg = 0;
        Q_y_reg = 0;
        Q_z_reg = 0;
        Temp_u_reg = 0;
        Temp_v_reg = 0;
        Temp_u_v_reg = 0;
        Valid_reg = 0;

        #1000;
        $finish;
    end

endmodule