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
//  Source file: /afs/ir.stanford.edu/users/a/s/asampat/EE271/assignment2/rtl/test_iterator.vp
//  Source template: test_iterator
//
// --------------- Begin Pre-Generation Parameters Status Report ---------------
//
//	From 'generate' statement (priority=5):
// Parameter Radix 	= 10
// Parameter Vertices 	= 3
// Parameter Axis 	= 3
// Parameter SigFig 	= 24
// Parameter Colors 	= 3
// Parameter PipelineDepth 	= 1
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
 *  Bounding Box Sample Test Iteration
 * 
 *  Inputs:
 *    BBox and MicroPolygon Information
 * 
 *  Outputs:
 *    Subsample location and Micropolygon Information
 * 
 *  Function:
 *    Iterate from left to right bottom to top
 *    across the bounding box.
 * 
 *    While iterating set the halt signal in
 *    order to hold the bounding box pipeline in
 *    place.  
 * 
 *    
 * Long Description:
 *    The iterator starts in the waiting state,
 *    when a valid micropolygon bounding box
 *    appears at the input. It will enter the
 *    testing state the next cycle with a 
 *    sample equivelant to the lower left 
 *    cooridinate of the bounding box.
 * 
 *    While in the testing state, the next sample
 *    for each cycle should be one sample interval 
 *    to the right, except when the current sample
 *    is at the right edge.  If the current sample
 *    is at the right edge, the next sample should
 *    be one row up.  Additionally, if the current
 *    sample is on the top row and the right edge,
 *    next cycles sample should be invalid and 
 *    equivelant to the lower left vertice and
 *    next cycles state should be waiting.
 * 
 * 
 *   Author: John Brunhaver
 *   Created:      Thu 07/23/09
 *   Last Updated: Tue 10/01/10
 *
 *   Copyright 2009 <jbrunhaver@gmail.com>   
 *  
 * TEST:ANDREWLOL


/* ***************************************************************************
 * Change bar:
 * -----------
 * Date           Author    Description
 * Sep 19, 2012   jingpu    ported from John's original code to Genesis
 *                          
 * ***************************************************************************/

/******************************************************************************
 * PARAMETERIZATION
 * ***************************************************************************/
// SigFig (_GENESIS2_INHERITANCE_PRIORITY_) = 24
//
// Radix (_GENESIS2_INHERITANCE_PRIORITY_) = 10
//
// Vertices (_GENESIS2_INHERITANCE_PRIORITY_) = 3
//
// Axis (_GENESIS2_INHERITANCE_PRIORITY_) = 3
//
// Colors (_GENESIS2_INHERITANCE_PRIORITY_) = 3
//
// PipelineDepth (_GENESIS2_INHERITANCE_PRIORITY_) = 1
//
// ModifiedFSM (_GENESIS2_DECLARATION_PRIORITY_) = YES
//

/* A Note on Signal Names:
 *
 * Most signals have a suffix of the form _RxxN 
 * where R indicates that it is a Raster Block signal
 * xx indicates the clock slice that it belongs to
 * and N indicates the type of signal that it is.
 * H indicates logic high, L indicates logic low,
 * U indicates unsigned fixed point, and S indicates
 * signed fixed point.
 * 
 * For all the signed fixed point signals (logic signed [24-1:0]),
 * their highest 14 bits, namely [23:10]
 * represent the integer part of the fixed point number, 
 * while the lowest 10 bits, namely [9:0]
 * represent the fractional part of the fixed point number.
 * 
 * 
 * 
 * For signal subSample_RnnnnU (logic [3:0])
 * 1000 for  1x MSAA eq to 1 sample per pixel
 * 0100 for  4x MSAA eq to 4 samples per pixel, 
 *              a sample is half a pixel on a side
 * 0010 for 16x MSAA eq to 16 sample per pixel,
 *              a sample is a quarter pixel on a side.  
 * 0001 for 64x MSAA eq to 64 samples per pixel, 
 *              a sample is an eighth of a pixel on a side.
 * 
 */


module test_iterator_unq1
  (
   //Input Signals
   input logic signed [24-1:0] 	poly_R13S[3-1:0][3-1:0], //Micropolygon to Iterate Over
   input logic unsigned [24-1:0] color_R13U[3-1:0] , //Color of Poly
   input logic 				isQuad_R13H, //Micropolygon is quad
   input logic signed [24-1:0] 	box_R13S[1:0][1:0], //Box to iterate for subsamples
   input logic 				validPoly_R13H, //Micropolygon is valid

   //Control Signals
   input logic [3:0] 			subSample_RnnnnU , //Subsample width 
   output logic 			halt_RnnnnL , //Halt -> hold current micropoly
   //Note that this block generates
   //Global Signals
   input logic 				clk, // Clock
   input logic 				rst, // Reset

   //Outputs
   output logic signed [24-1:0] poly_R14S[3-1:0][3-1:0], //Micropolygon to Sample Test
   output logic unsigned [24-1:0] color_R14U[3-1:0] , //Color of Poly
   output logic signed [24-1:0] sample_R14S[1:0], //Sample Location to Be Tested
   output logic 			isQuad_R14H, //Micropygon is quad
   output logic 			validSamp_R14H                   //Sample and Micropolygon are Valid
   );
   
   
   // This module implement a Moore machine to iterarte sample points in bbox
   // Recall: a Moore machine is an FSM whose output values are determined 
   // solely by its current state.
   // A simple way to build a Moore machine is to make states for every output
   // and the values of the current states are the outputs themselves
   
   // Now we create the signals for the next states of each outputs and 
   // then instantiate registers for storing these states
   logic signed [24-1:0] 	next_poly_R14S[3-1:0][3-1:0]; 
   logic unsigned  [24-1:0] next_color_R14U[3-1:0] ;
   logic signed [24-1:0] 	next_sample_R14S[1:0];  
   logic 				next_isQuad_R14H;                   
   logic 				next_validSamp_R14H;                 
   logic 				next_halt_RnnnnL;
   
   
   // Instantiate registers for storing these states
   dff3_unq1  d301(
			  .in(next_poly_R14S) , 
			  .clk(clk) , .reset(rst), .en(1'b1),
			  .out(poly_R14S));
   
   dff2_unq1  d302 (
			   .in(next_color_R14U) , 
			   .clk(clk) , .reset(rst), .en(1'b1),
			   .out(color_R14U));
   
   dff2_unq2  d303 (
			   .in(next_sample_R14S) , 
			   .clk(clk) , .reset(rst), .en(1'b1),
			   .out(sample_R14S));				 
   
   dff_unq5  d304 (
			   .in({next_validSamp_R14H, next_isQuad_R14H, next_halt_RnnnnL}) , 
			   .clk(clk) , .reset(rst), .en(1'b1),
			   .out({validSamp_R14H, isQuad_R14H, halt_RnnnnL}));
   // Instantiate registers for storing these states   
   
   
   //////
   //////  RTL code for original FSM Goes Here
   //////
   
   // To build this FSM we want to have two more state: one is the working
   // status of this FSM, and the other is the current bounding box where
   // we iterate sample points
   
   // defin two more states, box_R14S and state_R14H
   logic signed [24-1:0] 	box_R14S[1:0][1:0];    		// the state for current bounding box
   logic signed [24-1:0] 	next_box_R14S[1:0][1:0];
   typedef enum logic {
			 WAIT_STATE, TEST_STATE
		       } state_t;
   state_t                        state_R14H;     //State Designation (Waiting or Testing)
   state_t                        next_state_R14H;        //Next Cycles State 
   
   // instantiate registers for storing these two states
   dff3_unq4  d305 (
			   .in(next_box_R14S) , 
			   .clk(clk) , .reset(rst), .en(1'b1),
			   .out(box_R14S));
   
    
   dff_unq6  d306 (
			   .in(next_state_R14H) , 
			   .clk(clk) , .reset(rst), .en(1'b1),
			   .out(state_R14H));
   
   
   // define some helper signals
   logic signed [24-1:0] 	next_up_samp_R14S[1:0]; //If jump up, next sample
   logic signed [24-1:0] 	next_rt_samp_R14S[1:0]; //If jump right, next sample
   logic 				at_right_edg_R14H;      //Current sample at right edge of bbox?
   logic 				at_top_edg_R14H;        //Current sample at top edge of bbox?
   logic 				at_end_box_R14H;        //Current sample at end of bbox?
   // Adding code Anand
   logic signed [24-1:0]       interval_R14S; //interval for subsample incrementing

   //////
   ////// First calculate the values of the helper signals using CURRENT STATES
   //////

   // check the comments 'A Note on Signal Names' 
   // at the begining of the module for the help on
   // understanding the signals here
  
   
   //////
   //////  RTL code for modified FSM Goes Here
   //////
   

   ////// PLACE YOUR CODE HERE MODIFIEDYEEEAAAAHH

   always_comb begin      
  
	 // Define pixel interval based on subSample_RnnnnU value

	 interval_R14S = {24{1'b0}};    	 
   	 case (subSample_RnnnnU)
   	      4'b1000: interval_R14S[10]=1'b1;
	      4'b0100: interval_R14S[10-1]=1'b1;
	      4'b0010: interval_R14S[10-2]=1'b1;
	      4'b0001: interval_R14S[10-3]=1'b1;
	      default: interval_R14S[10]= 1'b1;
   	 endcase
   	
   	// Define the helper signals

   	// if at right edge go to next row up and furthest left
   	// set the ll x value as x
   	next_up_samp_R14S[0] = box_R14S[0][0];
   	// set y as current sample y + 1 unit 
	next_up_samp_R14S[1] = sample_R14S[1]+interval_R14S;

   	// going to next point if not at edge
   	// set x as current sample x +1 pos
   	next_rt_samp_R14S[0] = sample_R14S[0]+interval_R14S;
   	// set y as same as current sample
   	next_rt_samp_R14S[1] = sample_R14S[1];

   	// Assume bounding box is calibrated to the grid
   	// compare the x value of the ur of box and the current sample point
   	at_right_edg_R14H = (box_R14S[1][0] == sample_R14S[0]);   

   	// compare y val of ur of box and current sample point
   	at_top_edg_R14H = (box_R14S[1][1] == sample_R14S[1]);

   	// compare x and y val of ur bbox and sample point
   	at_end_box_R14H =   	
	(box_R14S[1][1] == sample_R14S[1]) &&
   	(box_R14S[1][0] == sample_R14S[0]);
	
	// simple case - move to the right
	next_sample_R14S = next_rt_samp_R14S;
	// next sample is valid
	next_validSamp_R14H = 1'b1;
	//micropolygon info
   	next_isQuad_R14H    = isQuad_R14H;
   	next_poly_R14S      = poly_R14S;
   	next_color_R14U     = color_R14U; 
   	next_box_R14S       = box_R14S;
   	next_halt_RnnnnL    = 1'b0;
	

	
	 if (at_right_edg_R14H)
	 begin
		// move to next sample up
		next_sample_R14S = next_up_samp_R14S;
		// next sample is valid
		next_validSamp_R14H = 1'b1;
		//micropolygon info
	   	next_isQuad_R14H    = isQuad_R14H;
	   	next_poly_R14S      = poly_R14S;
	   	next_color_R14U     = color_R14U; 
	   	next_box_R14S       = box_R14S;
	   	next_halt_RnnnnL    = 1'b0;
	 end 	
	 
	 if(at_end_box_R14H || !validSamp_R14H)
	 begin
		// Since we want to intake new values
	   	// basically do what what WAIT_STATE used to do!
		
		// the first sample is equivalent to the ll of bbox
	   	next_sample_R14S[0] = box_R13S[0][0]; 
	   	next_sample_R14S[1] = box_R13S[0][1];
	   	// the first sample at ll of bbox should be valid
	   	next_validSamp_R14H = validPoly_R13H;
	   	next_isQuad_R14H    = isQuad_R13H;
	   	// takes in a new polygon for testing
	   	next_poly_R14S      = poly_R13S;
	   	// takes in new color info for incoming poly
	   	next_color_R14U     = color_R13U;
	   	// takes in a new bounding box
	   	next_box_R14S       = box_R13S;
	   	// received a new bounding box, so no halt
	   	next_halt_RnnnnL    = 1'b1;
	 end
	
	 
	  // if statement to account for new inputs
	 
	  
	   

	//output
    /*  $display("VALID POLY: %d \n"	, validSamp_R14H);
      $display("at right: %d \n"	, at_right_edg_R14H);
      $display("at top: %d \n"		, at_top_edg_R14H);
      $display("at end: %d \n"		, at_end_box_R14H);
      // $display("sampleR13 x: %d \n"	, sample_R13S[0]);
      // $display("sampleR13 y: %d \n"	, sample_R13S[1]);
      $display("sampleR14 x: %d \n"	, sample_R14S[0]);
      $display("sampleR14 y: %d \n"	, sample_R14S[1]);
      $display("boxR13 ll x: %d \n"	, box_R13S[0][0]);
      $display("boxR13 ll y: %d \n"	, box_R13S[0][1]);
      $display("boxR13 ur x: %d \n"	, box_R13S[1][0]);
      $display("boxR13 ur y: %d \n"	, box_R13S[1][1]);
      $display("boxR14 ll x: %d \n"	, box_R14S[0][0]);
      $display("boxR14 ll y: %d \n"	, box_R14S[0][1]);
      $display("boxR14 ur x: %d \n"	, box_R14S[1][0]);
      $display("boxR14 ur y: %d \n"	, box_R14S[1][1]);
      $display("interval: %d \n" 	, interval_R14S);
      $display("subsample: %d \n"       , subSample_RnnnnU);
      $display("------------- \n");
      */
   end //always_comb
   
   //////
   //////  RTL code for modified FSM Finishes
   //////
   
   //Some Error Checking Assertions

   //Define a Less Than Property
   //  
   //  a should be less than b
   property rb_lt( rst, a , b , c );
      @(posedge clk) rst | ((a<=b) | !c);
   endproperty

   //Check that Proposed Sample is in BBox
   assert property( rb_lt( rst, next_sample_R14S[0] , next_box_R14S[1][0] , next_validSamp_R14H ));
   assert property( rb_lt( rst, next_sample_R14S[1] , next_box_R14S[1][1] , next_validSamp_R14H ));
   assert property( rb_lt( rst, next_box_R14S[0][0] , next_sample_R14S[0] , next_validSamp_R14H ));
   assert property( rb_lt( rst, next_box_R14S[0][1] , next_sample_R14S[1] , next_validSamp_R14H ));
   //Check that Proposed Sample is in BBox

   //Error Checking Assertions
   


endmodule

