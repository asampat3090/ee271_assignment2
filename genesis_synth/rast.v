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
//  Source file: /afs/ir.stanford.edu/users/a/s/asampat/EE271/assignment2/rtl/rast.vp
//  Source template: rast
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

/*
 * Reyes Style Hider:
 *     
 *  This module accepts a stream of micropolygons
 *  and produces a stream of fragments
 * 
 *  This module contains three submodules:
 *    -bounding box module which generates the bounding box
 *     for a micropolygon
 *    -test iterator module which iterates over the bounding 
 *    -sample test function which tests to see if the sample
 *     location from the bounding box lay inside the micropolygon
 * 
 * 
 *   Author: John Brunhaver
 *   Created:          09/21/09
 *   Last Updated: TUE 10/20/09
 *
 *   Copyright 2009 <jbrunhaver@gmail.com>   
 */


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
// SigFig (_GENESIS2_DECLARATION_PRIORITY_) = 24
//
// Radix (_GENESIS2_DECLARATION_PRIORITY_) = 10
//
// Vertices (_GENESIS2_DECLARATION_PRIORITY_) = 3
//
// Axis (_GENESIS2_DECLARATION_PRIORITY_) = 3
//
// Colors (_GENESIS2_DECLARATION_PRIORITY_) = 3
//
// PipesBox (_GENESIS2_DECLARATION_PRIORITY_) = 2
//
// PipesIter (_GENESIS2_DECLARATION_PRIORITY_) = 1
//
// PipesHash (_GENESIS2_DECLARATION_PRIORITY_) = 3
//
// PipesSamp (_GENESIS2_DECLARATION_PRIORITY_) = 5
//

module rast  
  (
   // Input Signals
   input logic signed [24-1:0] 	poly_R10S[3-1:0][3-1:0] , // Poly Position
   input logic 				unsigned [24-1:0] color_R10U[3-1:0] , // Color of Poly
   input logic 				isQuad_R10H , // Is Poly Quad?
   input logic 				validPoly_R10H , // Valid Data for Operation

   // Input Control Signals ( ala CSR )
   input logic signed [24-1:0] 	screen_RnnnnS[1:0] , // Screen Dimensions
   input logic [3:0] 			subSample_RnnnnU , // SubSample_Interval

   // Global Signals 
   input logic 				clk, // Clock 
   input logic 				rst, // Reset

   // Output Control Signals
   output logic 			halt_RnnnnL,
  
   // Output Signals
   output logic signed [24-1:0] hit_R18S[3-1:0], // Hit Location
   output logic 			unsigned [24-1:0] color_R18U[3-1:0] , // Color of Poly 
   output logic 			hit_valid_R18H            // Is this a hit?
   );

   //Intermediate Signals
   logic  signed [24-1:0] 	box_R13S[1:0][1:0];             // 2 Sets X,Y Fixed Point Values   
   logic  signed [24-1:0] 	poly_R13S[3-1:0][3-1:0]; // 4 Sets X,Y Fixed Point Values
   logic 				unsigned [24-1:0]  color_R13U[3-1:0]  ;       // Color of Poly
   logic 				validPoly_R13H;                 // Valid Data for Operation
   logic 				isQuad_R13H;                    // Is Poly Quad?
   
   logic signed [24-1:0] 	poly_R14S[3-1:0][3-1:0]; //Micropolygon to Sample Test
   logic 				unsigned [24-1:0]   color_R14U[3-1:0] ;         // Color of Poly
   logic 				isQuad_R14H;                    //Micropygon is quad
   logic signed [24-1:0] 	sample_R14S[1:0];               //Sample Location to Be Tested
   logic 				validSamp_R14H;                 //Sample and Micropolygon are Valid
   
   logic signed [24-1:0] 	poly_R16S[3-1:0][3-1:0]; //Micropolygon to Sample Test
   logic 				unsigned [24-1:0]   color_R16U[3-1:0] ;         //Color of Poly
   logic 				isQuad_R16H;                    //Micropygon is quad
   logic signed [24-1:0] 	sample_R16S[1:0];               //Sample Location to Be Tested
   logic 				validSamp_R16H;                 //Sample and Micropolygon are Valid
   
   logic [24-1:0] 		zero;                     //fudge signal to hold zero as a reset value
   logic [127:0] 			big_zero;                 //fudge signal to hold zero as a reset value
   //Intermediate Signals

   assign big_zero = 128'd0;
   assign zero = big_zero[24-1:0];  

   //TODO: Missing Micropolygon color
   
   //TODO: Make param pipedepth work
   
   bbox_unq1  bbox (
			     .poly_R10S(poly_R10S) ,
			     .color_R10U(color_R10U) ,	      
			     .isQuad_R10H(isQuad_R10H) ,
			     .validPoly_R10H(validPoly_R10H) ,
      
			     .halt_RnnnnL(halt_RnnnnL) , 
			     .screen_RnnnnS(screen_RnnnnS) ,
			     .subSample_RnnnnU(subSample_RnnnnU) ,
      
			     .clk(clk),
			     .rst(rst),
      
			     .poly_R13S(poly_R13S),
			     .color_R13U(color_R13U) ,	      
			     .isQuad_R13H(isQuad_R13H),
			     .box_R13S(box_R13S),
			     .validPoly_R13H(validPoly_R13H) 
			     ) ; 
   
   
   test_iterator_unq1  test_iterator (
				      .poly_R13S(poly_R13S),
				      .color_R13U(color_R13U) ,	      
				      .isQuad_R13H(isQuad_R13H),
				      .box_R13S(box_R13S),
				      .validPoly_R13H(validPoly_R13H),	
      
				      .subSample_RnnnnU(subSample_RnnnnU) ,
				      .halt_RnnnnL(halt_RnnnnL), 
      
				      .clk(clk),
				      .rst(rst),
      
				      .poly_R14S(poly_R14S),
				      .color_R14U(color_R14U) ,	      
				      .isQuad_R14H(isQuad_R14H),
				      .sample_R14S(sample_R14S),
				      .validSamp_R14H(validSamp_R14H) 
				      ) ;

   hash_jtree_unq1  hash_jtree (
				   .poly_R14S(poly_R14S),
				   .color_R14U(color_R14U) ,	      
				   .isQuad_R14H(isQuad_R14H),
				   .sample_R14S(sample_R14S),
				   .validSamp_R14H(validSamp_R14H),

				   .subSample_RnnnnU(subSample_RnnnnU) ,
      
				   .clk(clk),
				   .rst(rst),
      
				   .poly_R16S(poly_R16S),
				   .color_R16U(color_R16U),			
				   .sample_R16S(sample_R16S),
				   .validSamp_R16H(validSamp_R16H),
				   .isQuad_R16H(isQuad_R16H)

				   );
   

   sampletest_unq1  sampletest (   
				      .poly_R16S(poly_R16S),
				      .color_R16U(color_R16U),			
				      .sample_R16S(sample_R16S),
				      .validSamp_R16H(validSamp_R16H),
				      .isQuad_R16H(isQuad_R16H),
      
				      .clk(clk),
				      .rst(rst),
      
				      .hit_R18S( hit_R18S ),
				      .color_R18U( color_R18U ),						 
				      .hit_valid_R18H( hit_valid_R18H ) 
				      );
   
endmodule
