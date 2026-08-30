// cla64_hier.v
// BONUS -- a two-level hierarchical carry-lookahead adder.
//
// Level 1: sixteen 4-bit CLA blocks (cla4x, an extended cla4 that also
// exports its own Gblk/Pblk block-generate/propagate summary signals).
// Level 2: a single lookahead unit that computes all 16 block carry-ins
// directly and in parallel from Gblk[0..15], Pblk[0..15], and cin --
// instead of rippling the carry block to block like cla64_blocked.v did.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] Gblk, Pblk;
  wire [16:1] C;   // C[1]..C[16] = carry INTO block 1..15, and C[16] = final cout

  // ------------------------------------------------------------------
  // Level 1: sixteen 4-bit CLA blocks, each also exporting Gblk/Pblk
  // ------------------------------------------------------------------
  cla4x block0  (.a(a[3:0]),   .b(b[3:0]),   .cin(cin),    .sum(sum[3:0]),   .cout(), .Gblk(Gblk[0]),  .Pblk(Pblk[0]));
  cla4x block1  (.a(a[7:4]),   .b(b[7:4]),   .cin(C[1]),   .sum(sum[7:4]),   .cout(), .Gblk(Gblk[1]),  .Pblk(Pblk[1]));
  cla4x block2  (.a(a[11:8]),  .b(b[11:8]),  .cin(C[2]),   .sum(sum[11:8]),  .cout(), .Gblk(Gblk[2]),  .Pblk(Pblk[2]));
  cla4x block3  (.a(a[15:12]), .b(b[15:12]), .cin(C[3]),   .sum(sum[15:12]), .cout(), .Gblk(Gblk[3]),  .Pblk(Pblk[3]));
  cla4x block4  (.a(a[19:16]), .b(b[19:16]), .cin(C[4]),   .sum(sum[19:16]), .cout(), .Gblk(Gblk[4]),  .Pblk(Pblk[4]));
  cla4x block5  (.a(a[23:20]), .b(b[23:20]), .cin(C[5]),   .sum(sum[23:20]), .cout(), .Gblk(Gblk[5]),  .Pblk(Pblk[5]));
  cla4x block6  (.a(a[27:24]), .b(b[27:24]), .cin(C[6]),   .sum(sum[27:24]), .cout(), .Gblk(Gblk[6]),  .Pblk(Pblk[6]));
  cla4x block7  (.a(a[31:28]), .b(b[31:28]), .cin(C[7]),   .sum(sum[31:28]), .cout(), .Gblk(Gblk[7]),  .Pblk(Pblk[7]));
  cla4x block8  (.a(a[35:32]), .b(b[35:32]), .cin(C[8]),   .sum(sum[35:32]), .cout(), .Gblk(Gblk[8]),  .Pblk(Pblk[8]));
  cla4x block9  (.a(a[39:36]), .b(b[39:36]), .cin(C[9]),   .sum(sum[39:36]), .cout(), .Gblk(Gblk[9]),  .Pblk(Pblk[9]));
  cla4x block10 (.a(a[43:40]), .b(b[43:40]), .cin(C[10]),  .sum(sum[43:40]), .cout(), .Gblk(Gblk[10]), .Pblk(Pblk[10]));
  cla4x block11 (.a(a[47:44]), .b(b[47:44]), .cin(C[11]),  .sum(sum[47:44]), .cout(), .Gblk(Gblk[11]), .Pblk(Pblk[11]));
  cla4x block12 (.a(a[51:48]), .b(b[51:48]), .cin(C[12]),  .sum(sum[51:48]), .cout(), .Gblk(Gblk[12]), .Pblk(Pblk[12]));
  cla4x block13 (.a(a[55:52]), .b(b[55:52]), .cin(C[13]),  .sum(sum[55:52]), .cout(), .Gblk(Gblk[13]), .Pblk(Pblk[13]));
  cla4x block14 (.a(a[59:56]), .b(b[59:56]), .cin(C[14]),  .sum(sum[59:56]), .cout(), .Gblk(Gblk[14]), .Pblk(Pblk[14]));
  cla4x block15 (.a(a[63:60]), .b(b[63:60]), .cin(C[15]),  .sum(sum[63:60]), .cout(), .Gblk(Gblk[15]), .Pblk(Pblk[15]));

  // ------------------------------------------------------------------
  // Level 2: direct lookahead across all 16 blocks
  // ------------------------------------------------------------------
wire bt1, bt2, bt3, bt4, bt5, bt6, bt7, bt8, bt9, bt10, bt11, bt12, bt13, bt14, bt15, bt16, bt17, bt18, bt19, bt20, bt21, bt22, bt23, bt24, bt25, bt26, bt27, bt28, bt29, bt30, bt31, bt32, bt33, bt34, bt35, bt36, bt37, bt38, bt39, bt40, bt41, bt42, bt43, bt44, bt45, bt46, bt47, bt48, bt49, bt50, bt51, bt52, bt53, bt54, bt55, bt56, bt57, bt58, bt59, bt60, bt61, bt62, bt63, bt64, bt65, bt66, bt67, bt68, bt69, bt70, bt71, bt72, bt73, bt74, bt75, bt76, bt77, bt78, bt79, bt80, bt81, bt82, bt83, bt84, bt85, bt86, bt87, bt88, bt89, bt90, bt91, bt92, bt93, bt94, bt95, bt96, bt97, bt98, bt99, bt100, bt101, bt102, bt103, bt104, bt105, bt106, bt107, bt108, bt109, bt110, bt111, bt112, bt113, bt114, bt115, bt116, bt117, bt118, bt119, bt120, bt121, bt122, bt123, bt124, bt125, bt126, bt127, bt128, bt129, bt130, bt131, bt132, bt133, bt134, bt135, bt136;

  and #(2) (bt1, Pblk[0], cin);
  or  #(2) (C[1], Gblk[0], bt1);
  and #(2) (bt2, Pblk[1], Gblk[0]);
  and #(2) (bt3, Pblk[1], Pblk[0], cin);
  or  #(2) (C[2], Gblk[1], bt2, bt3);
  and #(2) (bt4, Pblk[2], Gblk[1]);
  and #(2) (bt5, Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt6, Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[3], Gblk[2], bt4, bt5, bt6);
  and #(2) (bt7, Pblk[3], Gblk[2]);
  and #(2) (bt8, Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt9, Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt10, Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[4], Gblk[3], bt7, bt8, bt9, bt10);
  and #(2) (bt11, Pblk[4], Gblk[3]);
  and #(2) (bt12, Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt13, Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt14, Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt15, Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[5], Gblk[4], bt11, bt12, bt13, bt14, bt15);
  and #(2) (bt16, Pblk[5], Gblk[4]);
  and #(2) (bt17, Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt18, Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt19, Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt20, Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt21, Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[6], Gblk[5], bt16, bt17, bt18, bt19, bt20, bt21);
  and #(2) (bt22, Pblk[6], Gblk[5]);
  and #(2) (bt23, Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt24, Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt25, Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt26, Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt27, Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt28, Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[7], Gblk[6], bt22, bt23, bt24, bt25, bt26, bt27, bt28);
  and #(2) (bt29, Pblk[7], Gblk[6]);
  and #(2) (bt30, Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt31, Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt32, Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt33, Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt34, Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt35, Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt36, Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[8], Gblk[7], bt29, bt30, bt31, bt32, bt33, bt34, bt35, bt36);
  and #(2) (bt37, Pblk[8], Gblk[7]);
  and #(2) (bt38, Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt39, Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt40, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt41, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt42, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt43, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt44, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt45, Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[9], Gblk[8], bt37, bt38, bt39, bt40, bt41, bt42, bt43, bt44, bt45);
  and #(2) (bt46, Pblk[9], Gblk[8]);
  and #(2) (bt47, Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt48, Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt49, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt50, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt51, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt52, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt53, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt54, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt55, Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[10], Gblk[9], bt46, bt47, bt48, bt49, bt50, bt51, bt52, bt53, bt54, bt55);
  and #(2) (bt56, Pblk[10], Gblk[9]);
  and #(2) (bt57, Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt58, Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt59, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt60, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt61, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt62, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt63, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt64, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt65, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt66, Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[11], Gblk[10], bt56, bt57, bt58, bt59, bt60, bt61, bt62, bt63, bt64, bt65, bt66);
  and #(2) (bt67, Pblk[11], Gblk[10]);
  and #(2) (bt68, Pblk[11], Pblk[10], Gblk[9]);
  and #(2) (bt69, Pblk[11], Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt70, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt71, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt72, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt73, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt74, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt75, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt76, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt77, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt78, Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[12], Gblk[11], bt67, bt68, bt69, bt70, bt71, bt72, bt73, bt74, bt75, bt76, bt77, bt78);
  and #(2) (bt79, Pblk[12], Gblk[11]);
  and #(2) (bt80, Pblk[12], Pblk[11], Gblk[10]);
  and #(2) (bt81, Pblk[12], Pblk[11], Pblk[10], Gblk[9]);
  and #(2) (bt82, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt83, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt84, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt85, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt86, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt87, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt88, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt89, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt90, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt91, Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[13], Gblk[12], bt79, bt80, bt81, bt82, bt83, bt84, bt85, bt86, bt87, bt88, bt89, bt90, bt91);
  and #(2) (bt92, Pblk[13], Gblk[12]);
  and #(2) (bt93, Pblk[13], Pblk[12], Gblk[11]);
  and #(2) (bt94, Pblk[13], Pblk[12], Pblk[11], Gblk[10]);
  and #(2) (bt95, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Gblk[9]);
  and #(2) (bt96, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt97, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt98, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt99, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt100, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt101, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt102, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt103, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt104, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt105, Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[14], Gblk[13], bt92, bt93, bt94, bt95, bt96, bt97, bt98, bt99, bt100, bt101, bt102, bt103, bt104, bt105);
  and #(2) (bt106, Pblk[14], Gblk[13]);
  and #(2) (bt107, Pblk[14], Pblk[13], Gblk[12]);
  and #(2) (bt108, Pblk[14], Pblk[13], Pblk[12], Gblk[11]);
  and #(2) (bt109, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Gblk[10]);
  and #(2) (bt110, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Gblk[9]);
  and #(2) (bt111, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt112, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt113, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt114, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt115, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt116, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt117, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt118, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt119, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt120, Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[15], Gblk[14], bt106, bt107, bt108, bt109, bt110, bt111, bt112, bt113, bt114, bt115, bt116, bt117, bt118, bt119, bt120);
  and #(2) (bt121, Pblk[15], Gblk[14]);
  and #(2) (bt122, Pblk[15], Pblk[14], Gblk[13]);
  and #(2) (bt123, Pblk[15], Pblk[14], Pblk[13], Gblk[12]);
  and #(2) (bt124, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Gblk[11]);
  and #(2) (bt125, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Gblk[10]);
  and #(2) (bt126, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Gblk[9]);
  and #(2) (bt127, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Gblk[8]);
  and #(2) (bt128, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Gblk[7]);
  and #(2) (bt129, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Gblk[6]);
  and #(2) (bt130, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Gblk[5]);
  and #(2) (bt131, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Gblk[4]);
  and #(2) (bt132, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Gblk[3]);
  and #(2) (bt133, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Gblk[2]);
  and #(2) (bt134, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Gblk[1]);
  and #(2) (bt135, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Gblk[0]);
  and #(2) (bt136, Pblk[15], Pblk[14], Pblk[13], Pblk[12], Pblk[11], Pblk[10], Pblk[9], Pblk[8], Pblk[7], Pblk[6], Pblk[5], Pblk[4], Pblk[3], Pblk[2], Pblk[1], Pblk[0], cin);
  or  #(2) (C[16], Gblk[15], bt121, bt122, bt123, bt124, bt125, bt126, bt127, bt128, bt129, bt130, bt131, bt132, bt133, bt134, bt135, bt136);

  assign cout = C[16];

endmodule