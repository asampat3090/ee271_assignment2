//
//---------------------------------------------------------------------------
//  THIS FILE WAS AUTOMATICALLY GENERATED BY THE STANFORD GENESIS2 ENGINE
//  FOR MORE INFORMATION, CONTACT OFER SHACHAM FROM THE STANFORD VLSI GROUP
//  THIS VERSION OF GENESIS2 IS NOT TO BE USED FOR ANY COMMERCIAL USE
//---------------------------------------------------------------------------
//
//  
//	-----------------------------------------------
//	|            Genesis Release Info             |
//	|  $Change: 11012 $ --- $Date: 2012/09/13 $   |
//	-----------------------------------------------
//	
//
//  Source file: /afs/ir.stanford.edu/users/a/s/asampat/EE271/assignment2/rtl/dff.vp
//  Source template: dff
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter BitWidth 	= 24
// Parameter Retime 	= NO
// Parameter PipelineDepth 	= 2
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Command Line input (priority=4):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From XML input (priority=3):
//
//		---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
//
//	From Config File input (priority=2):
//
// ---------------- End Pre-Generation Pramameters Status Report ----------------

/*
 This is a Genesis wrapper of DW pipeline regs with en singal
 */

/* ***************************************************************************
 * Change bar:
 * -----------
 * Date           Author    Description
 * Sep 20, 2012   jingpu    init version
 *                          
 * ***************************************************************************/

/*******************************************************************************
 * PARAMETERIZATION
 * ****************************************************************************/
// BitWidth (_GENESIS2_INHERITANCE_PRIORITY_) = 24
//
// PipelineDepth (_GENESIS2_INHERITANCE_PRIORITY_) = 2
//
// Retime (_GENESIS2_INHERITANCE_PRIORITY_) = NO
//

module dff_unq11 (
		input logic [23:0]  in, 
		input logic 		    clk, reset, en, 
		output logic [23:0] out
		);

   
   /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] true
    set_flatten true -effort high -phase true -design [current_design]
    set_dont_retime [current_design] true
    set_optimize_registers false -design [current_design]
    */
   
   //   DW03_pipe_reg #(2,24) dff ( .A(in) , .clk(clk) , .B(out) ) ;
   DW_pl_reg #(.stages(3),.in_reg(0),.out_reg(0),.width(24),.rst_mode(0)) dff ( .data_in(in) , .clk(clk) , .data_out(out), .rst_n(!reset), .enable({2{en}}) );
   
endmodule
