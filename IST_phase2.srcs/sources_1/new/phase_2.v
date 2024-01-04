module phase_2 
#(parameter WIDTH = 32, CYCLE_PER_STAGE = 41)
(
    input   clk_i,
    input   rst_i,
    
	input   [WIDTH-1:0] T_x, T_y, T_z,
    input   [WIDTH-1:0] P_x, P_y, P_z,
    
	input   [WIDTH-1:0] V_x, V_y, V_z,
    input   [WIDTH-1:0] Q_x, Q_y, Q_z,

    output 	[WIDTH-1:0] Temp_u, Temp_v, Temp_u_v,
	output 	Valid
);

wire [WIDTH-1:0] T_P_Mul_x, T_P_Mul_y, T_P_Mul_z;
wire [WIDTH-1:0] T_P_Add_xy, T_P_Add_xyz;
wire [WIDTH-1:0] V_Q_Mul_x, V_Q_Mul_y, V_Q_Mul_z;
wire [WIDTH-1:0] V_Q_Add_xy, V_Q_Add_xyz;

reg [WIDTH-1:0] counter;

always @(posedge clk_i) begin
	if (rst_i) begin
		counter = 4'd0;
	end else if (counter < CYCLE_PER_STAGE) begin
		counter <= counter + 1;
	end
end

//////////////////////////////////////////////////////
//          STAGE 1: dot product(T, P) (MUL)        //
//////////////////////////////////////////////////////

//// Initialization ////
wire [WIDTH-1:0] T_P_Mul_z_temp;

reg [WIDTH-1:0] T_P_Mul_z_reg;
reg [WIDTH-1:0] T_P_Add_xy_reg, T_P_Add_xyz_reg;
reg [WIDTH-1:0] T_P_Add_buffer [9:0];

//// T_x * P_x ////
floating_point_0 MUL_A0_0 ( 
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(T_x),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(P_x),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(T_P_Mul_x)
);

//// T_y * P_y ////
floating_point_0 MUL_A1_0 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(T_y),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(P_y),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(T_P_Mul_y)
);

//// T_z * P_z ////
floating_point_0 MUL_A2_0 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(T_z),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(P_z),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(T_P_Mul_z_temp)
);

//////////////////////////////////////////////////////
//          STAGE 1: dot product(V, Q) (MUL)        //
//////////////////////////////////////////////////////

//// Initialization ////
wire [WIDTH-1:0] V_Q_Mul_z_temp;

reg [WIDTH-1:0] V_Q_Mul_z_reg;
reg [WIDTH-1:0] V_Q_Add_xy_reg, V_Q_Add_xyz_reg;
reg [WIDTH-1:0] V_Q_Add_buffer [9:0];

//// V_x * Q_x ////
floating_point_0 MUL_A0_1 ( 
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(V_x),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(Q_x),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(V_Q_Mul_x)
);

//// V_y * Q_y ////
floating_point_0 MUL_A1_1 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(V_y),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(Q_y),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(V_Q_Mul_y)
);

//// V_z * Q_z ////
floating_point_0 MUL_A2_1 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(V_z),
	.s_axis_b_tvalid(1),        	
	.s_axis_b_tdata(Q_z),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(V_Q_Mul_z_temp)
);

//////////////////////////////////////////////////////
//          STAGE 2: dot product(T, P) (ADD)        //
//////////////////////////////////////////////////////

//// alpha = T_x * P_x + T_y * P_y ////
floating_point_1 ADD_A0_0 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(T_P_Mul_x),
	.s_axis_a_tlast(),
	.s_axis_b_tvalid(1),
	.s_axis_b_tdata(T_P_Mul_y),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(T_P_Add_xy),
	.m_axis_result_tlast()
);

//// alpha + T_y * P_y ////
always @(posedge clk_i) begin
	if (rst_i) begin
		T_P_Add_buffer[0] <= 0;
		T_P_Add_buffer[1] <= 0;
		T_P_Add_buffer[2] <= 0;
		T_P_Add_buffer[3] <= 0;
		T_P_Add_buffer[4] <= 0;
		T_P_Add_buffer[5] <= 0;
		T_P_Add_buffer[6] <= 0;
		T_P_Add_buffer[7] <= 0;
		T_P_Add_buffer[8] <= 0;
		T_P_Add_buffer[9] <= 0;
	end else begin
		T_P_Add_buffer[0] <= T_P_Mul_z_temp;
		T_P_Add_buffer[1] <= T_P_Add_buffer[0];
		T_P_Add_buffer[2] <= T_P_Add_buffer[1];
		T_P_Add_buffer[3] <= T_P_Add_buffer[2];
		T_P_Add_buffer[4] <= T_P_Add_buffer[3];
		T_P_Add_buffer[5] <= T_P_Add_buffer[4];
		T_P_Add_buffer[6] <= T_P_Add_buffer[5];
		T_P_Add_buffer[7] <= T_P_Add_buffer[6];
		T_P_Add_buffer[8] <= T_P_Add_buffer[7];
		T_P_Add_buffer[9] <= T_P_Add_buffer[8];
	end
end

assign T_P_Mul_z = T_P_Mul_z_reg;

always @(posedge clk_i) begin
	if (rst_i) begin
		T_P_Mul_z_reg <= 0;
	end else begin
		T_P_Mul_z_reg <= T_P_Add_buffer[9];
	end
end

floating_point_1 ADD_A1_0 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(T_P_Add_xy),
	.s_axis_a_tlast(),
	.s_axis_b_tvalid(1),
	.s_axis_b_tdata(T_P_Mul_z),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(T_P_Add_xyz),
	.m_axis_result_tlast()
);

//////////////////////////////////////////////////////
//          STAGE 2: dot product(V, Q) (ADD)        //
//////////////////////////////////////////////////////

//// alpha = V_x * Q_x + V_y * Q_y ////
floating_point_1 ADD_A0_1 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(V_Q_Mul_x),
	.s_axis_a_tlast(),
	.s_axis_b_tvalid(1),
	.s_axis_b_tdata(V_Q_Mul_y),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(V_Q_Add_xy),
	.m_axis_result_tlast()
);

//// alpha + V_y * Q_y ////
always @(posedge clk_i) begin
	if (rst_i) begin
		V_Q_Add_buffer[0] <= 0;
		V_Q_Add_buffer[1] <= 0;
		V_Q_Add_buffer[2] <= 0;
		V_Q_Add_buffer[3] <= 0;
		V_Q_Add_buffer[4] <= 0;
		V_Q_Add_buffer[5] <= 0;
		V_Q_Add_buffer[6] <= 0;
		V_Q_Add_buffer[7] <= 0;
		V_Q_Add_buffer[8] <= 0;
		V_Q_Add_buffer[9] <= 0;
	end else begin
		V_Q_Add_buffer[0] <= V_Q_Mul_z_temp;
		V_Q_Add_buffer[1] <= V_Q_Add_buffer[0];
		V_Q_Add_buffer[2] <= V_Q_Add_buffer[1];
		V_Q_Add_buffer[3] <= V_Q_Add_buffer[2];
		V_Q_Add_buffer[4] <= V_Q_Add_buffer[3];
		V_Q_Add_buffer[5] <= V_Q_Add_buffer[4];
		V_Q_Add_buffer[6] <= V_Q_Add_buffer[5];
		V_Q_Add_buffer[7] <= V_Q_Add_buffer[6];
		V_Q_Add_buffer[8] <= V_Q_Add_buffer[7];
		V_Q_Add_buffer[9] <= V_Q_Add_buffer[8];
	end
end

assign V_Q_Mul_z = V_Q_Mul_z_reg;

always @(posedge clk_i) begin
	if (rst_i) begin
		V_Q_Mul_z_reg <= 0;
	end else begin
		V_Q_Mul_z_reg <= V_Q_Add_buffer[9];
	end
end

floating_point_1 ADD_A1_1 (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(V_Q_Add_xy),
	.s_axis_a_tlast(),
	.s_axis_b_tvalid(1),
	.s_axis_b_tdata(V_Q_Mul_z),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(V_Q_Add_xyz),
	.m_axis_result_tlast()
);

//////////////////////////////////////////////////////
//          STAGE 3: Early Stop Stage		        //
//////////////////////////////////////////////////////

reg signed [WIDTH-1:0] temp_u_signed, temp_v_signed;
reg [WIDTH-1:0] temp_u_reg, temp_v_reg, valid_reg;
reg [WIDTH-1:0] temp_u_buffer [9:0];
reg [WIDTH-1:0] temp_v_buffer [9:0];
reg [WIDTH-1:0] valid_buffer [9:0];

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_u_signed <= 0;
	end else begin
		temp_u_signed = T_P_Add_xyz;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_v_signed <= 0;
	end else begin
		temp_v_signed = V_Q_Add_xyz;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_u_reg <= 0;
	end else begin
		if (temp_u_signed < 0 || temp_v_signed < 0) temp_u_reg <= 0;
		else temp_u_reg <= T_P_Add_xyz;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_v_reg <= 0;
	end else begin
		if (temp_u_signed < 0 || temp_v_signed < 0) temp_v_reg <= 0;
		else temp_v_reg <= V_Q_Add_xyz;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		valid_reg <= 0;
	end else begin
		if (temp_u_signed < 0 || temp_v_signed < 0) valid_reg <= 0;
		else valid_reg <= 1;
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_u_buffer[0] <= 0;
		temp_u_buffer[1] <= 0;
		temp_u_buffer[2] <= 0;
		temp_u_buffer[3] <= 0;
		temp_u_buffer[4] <= 0;
		temp_u_buffer[5] <= 0;
		temp_u_buffer[6] <= 0;
		temp_u_buffer[7] <= 0;
		temp_u_buffer[8] <= 0;
		temp_u_buffer[9] <= 0;
	end else begin
		temp_u_buffer[0] <= temp_u_reg;
		temp_u_buffer[1] <= temp_u_buffer[0];
		temp_u_buffer[2] <= temp_u_buffer[1];
		temp_u_buffer[3] <= temp_u_buffer[2];
		temp_u_buffer[4] <= temp_u_buffer[3];
		temp_u_buffer[5] <= temp_u_buffer[4];
		temp_u_buffer[6] <= temp_u_buffer[5];
		temp_u_buffer[7] <= temp_u_buffer[6];
		temp_u_buffer[8] <= temp_u_buffer[7];
		temp_u_buffer[9] <= temp_u_buffer[8];
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_v_buffer[0] <= 0;
		temp_v_buffer[1] <= 0;
		temp_v_buffer[2] <= 0;
		temp_v_buffer[3] <= 0;
		temp_v_buffer[4] <= 0;
		temp_v_buffer[5] <= 0;
		temp_v_buffer[6] <= 0;
		temp_v_buffer[7] <= 0;
		temp_v_buffer[8] <= 0;
		temp_v_buffer[9] <= 0;
	end else begin
		temp_v_buffer[0] <= temp_v_reg;
		temp_v_buffer[1] <= temp_v_buffer[0];
		temp_v_buffer[2] <= temp_v_buffer[1];
		temp_v_buffer[3] <= temp_v_buffer[2];
		temp_v_buffer[4] <= temp_v_buffer[3];
		temp_v_buffer[5] <= temp_v_buffer[4];
		temp_v_buffer[6] <= temp_v_buffer[5];
		temp_v_buffer[7] <= temp_v_buffer[6];
		temp_v_buffer[8] <= temp_v_buffer[7];
		temp_v_buffer[9] <= temp_v_buffer[8];
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		valid_buffer[0] <= 0;
		valid_buffer[1] <= 0;
		valid_buffer[2] <= 0;
		valid_buffer[3] <= 0;
		valid_buffer[4] <= 0;
		valid_buffer[5] <= 0;
		valid_buffer[6] <= 0;
		valid_buffer[7] <= 0;
		valid_buffer[8] <= 0;
		valid_buffer[9] <= 0;
	end else begin
		valid_buffer[0] <= valid_reg;
		valid_buffer[1] <= valid_buffer[0];
		valid_buffer[2] <= valid_buffer[1];
		valid_buffer[3] <= valid_buffer[2];
		valid_buffer[4] <= valid_buffer[3];
		valid_buffer[5] <= valid_buffer[4];
		valid_buffer[6] <= valid_buffer[5];
		valid_buffer[7] <= valid_buffer[6];
		valid_buffer[8] <= valid_buffer[7];
		valid_buffer[9] <= valid_buffer[8];
	end
end

//////////////////////////////////////////////////////
//          STAGE 4: Output Stage			        //
//////////////////////////////////////////////////////

wire [WIDTH-1:0] temp_u_wire, temp_v_wire;
reg [WIDTH-1:0] temp_u_reg_, temp_v_reg_, valid_buffer_reg_;

assign temp_u_wire = temp_u_reg;
assign temp_v_wire = temp_v_reg;

assign Temp_u = temp_u_reg_;
assign Temp_v = temp_v_reg_;
assign Valid = valid_buffer_reg_;

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_u_reg_ <= 0;
	end else begin
		temp_u_reg_ <= temp_u_buffer[9];
	end
end

always @(posedge clk_i) begin
	if (rst_i) begin
		temp_v_reg_ <= 0;
	end else begin
		temp_v_reg_ <= temp_v_buffer[9];
	end
end

always @(posedge clk_i) begin
	if (rst_i || counter < CYCLE_PER_STAGE) begin
		valid_buffer_reg_ <= 0;
	end else begin
		valid_buffer_reg_ <= valid_buffer[9];
	end
end

floating_point_1 ADD_Final (
	.aclk(clk_i),
	.s_axis_a_tvalid(1),
	.s_axis_a_tdata(temp_u_wire),
	.s_axis_a_tlast(),
	.s_axis_b_tvalid(1),
	.s_axis_b_tdata(temp_v_wire),
	.m_axis_result_tvalid(),
	.m_axis_result_tdata(Temp_u_v),
	.m_axis_result_tlast()
);

//////////////////////////////////////////////////////
//          STAGE 5: Hand over to Phase 3	        //
//////////////////////////////////////////////////////

endmodule