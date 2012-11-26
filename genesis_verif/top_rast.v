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
//  Source file: /afs/ir.stanford.edu/users/a/s/asampat/EE271/assignment2/verif/top_rast.vp
//  Source template: top_rast
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
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

/******************************************************************************
 * File: top_rast.vp
 * Author: Jing Pu
 * 
 * Description:
 * top for rast
 * 
 *
 * Change bar:
 * -----------
 * Date          Author   Description
 * Sep 18, 1812  jingpu   init version
 * 
 * ****************************************************************************/
 
 module top_rast();



   /*****************************************
    * wires to connect design and environment
    *****************************************/

   //DUT INPUTS
   logic signed   [24-1:0] poly_R10S[3-1:0][3-1:0] ;   // 4 Sets X,Y Fixed Point Values
   logic unsigned [24-1:0] color_R10U[3-1:0] ;   // 4 Sets X,Y Fixed Point Values
   logic 		        isQuad_R10H ;           // Is Poly Quad?
   logic 		        validPoly_R10H ;        // Valid Data for Operation
   //DUT INPUTS
   
   //DUT CONFIG
   logic signed   [24-1:0] screen_RnnnnS[1:0];       // Screen Dimensions
   logic          [3:0]         subSample_RnnnnU ;        // SubSample_Interval
   //DUT CONFIG
   
   //DUT GLOBAL
   logic 		        clk ;                     // Clock 
   logic 		        rst ;                     // Reset
   //DUT GLOBAL
   
   //DUT OUTPUTS
   logic 		        halt_RnnnnL;
   logic signed   [24-1:0] hit_R18S[3-1:0]; //Sample hit Location
   logic unsigned [24-1:0] color_R18U[3-1:0]; //Sample hit Location
   logic 		        hit_valid_R18H ;  //Did Sample Hit?
   //DUT OUTPUTS
   


   // instantiate the DUT
   rast  rast
     (
      .poly_R10S(poly_R10S) ,            // Input: 4 Sets X,Y Fixed Point Values
	     .color_R10U(color_R10U) ,            // Input: 4 Sets X,Y Fixed Point Values
	     .isQuad_R10H (isQuad_R10H) ,       // Input: Is Poly Quad?
	     .validPoly_R10H(validPoly_R10H) ,  // Input: Valid Data for Operation
	     
	     .screen_RnnnnS(screen_RnnnnS) ,        // Input: Screen Dimensions
	     .subSample_RnnnnU (subSample_RnnnnU),  // Input: SubSample_Interval
	     
	     .clk(clk),                             // Input: Clock 
	     .rst(rst),                             // Input: Reset
	     
	     .halt_RnnnnL(halt_RnnnnL), 
	     
	     .hit_R18S(hit_R18S),             // Output: Sample Location Tested
	     .color_R18U(color_R18U) ,            // Input: 4 Sets X,Y Fixed Point Values
	     .hit_valid_R18H(hit_valid_R18H)  // Output: Does Sample lie in uPoly     
	 );


	// generate clocker
   clocker_unq1  clocker  ( .clk(clk) );
   
   
   // generate testbench
   testbench_unq1  testbench
     (
	      // Output Signals (to DUT inputs)
      .poly_R10S(poly_R10S) ,            
	     .color_R10U(color_R10U) ,           
	     .isQuad_R10H (isQuad_R10H) ,     
	     .validPoly_R10H(validPoly_R10H) ,  
	          // Output Control Signals (to DUT inputs)
	     .screen_RnnnnS(screen_RnnnnS) ,        
	     .subSample_RnnnnU (subSample_RnnnnU), 
	          // Global Signals 
	     .clk(clk),                            
	     .rst(rst),                            
	          // Input Control Signals (from DUT outputs)
	     .halt_RnnnnL(halt_RnnnnL), 
	          // Input Signals (from DUT outputs)
	     .hit_R18S(hit_R18S),             
	     .color_R18U(color_R18U) ,          
	     .hit_valid_R18H(hit_valid_R18H)  
	 );
   


endmodule //
