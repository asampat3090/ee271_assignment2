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
//  Source file: /afs/ir.stanford.edu/users/a/s/asampat/EE271/assignment2/rtl/dff3.vp
//  Source template: dff3
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter ArraySize2 	= 3
// Parameter BitWidth 	= 24
// Parameter ArraySize1 	= 3
// Parameter Retime 	= YES
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
 This is a three dimentional array of DFFs
 */

/* ***************************************************************************
 * Change bar:
 * -----------
 * Date           Author    Description
 * Sep 20, 2012   jingpu    init version
 *                          
 * ***************************************************************************/

/******************************************************************************
 * PARAMETERIZATION
 * ***************************************************************************/
// BitWidth (_GENESIS2_INHERITANCE_PRIORITY_) = 24
//
// ArraySize1 (_GENESIS2_INHERITANCE_PRIORITY_) = 3
//
// ArraySize2 (_GENESIS2_INHERITANCE_PRIORITY_) = 3
//
// PipelineDepth (_GENESIS2_INHERITANCE_PRIORITY_) = 2
//
// Retime (_GENESIS2_INHERITANCE_PRIORITY_) = YES
//

module dff3_unq1 (
		input logic [23:0]  in[2:0][2:0], 
		input logic 		       clk, reset, en, 
		output logic [23:0] out[2:0][2:0]
		);	
   
   dff2_unq1  dff2_0 
     (.in(in[0]) , 
      .clk(clk) , .reset(reset), .en(en),
      .out(out[0]));
   dff2_unq1  dff2_1 
     (.in(in[1]) , 
      .clk(clk) , .reset(reset), .en(en),
      .out(out[1]));
   dff2_unq1  dff2_2 
     (.in(in[2]) , 
      .clk(clk) , .reset(reset), .en(en),
      .out(out[2]));
   
endmodule 
