////////////////////////////////////////////////////////////////////////////////
//                                            __ _      _     _               //
//                                           / _(_)    | |   | |              //
//                __ _ _   _  ___  ___ _ __ | |_ _  ___| | __| |              //
//               / _` | | | |/ _ \/ _ \ '_ \|  _| |/ _ \ |/ _` |              //
//              | (_| | |_| |  __/  __/ | | | | | |  __/ | (_| |              //
//               \__, |\__,_|\___|\___|_| |_|_| |_|\___|_|\__,_|              //
//                  | |                                                       //
//                  |_|                                                       //
//                                                                            //
//                                                                            //
//              PU RISCV / OR1K / MSP430                                      //
//              Universal Verification Methodology                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

/* Copyright (c) 2020-2021 by the author(s)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =============================================================================
 * Author(s):
 *   Paco Reina Campo <pacoreinacampo@queenfield.tech>
 */

class processor_env extends uvm_env;
  `uvm_component_utils(processor_env)

  processor_agent agent;
  processor_monitor mon;
  processor_scoreboard sb;
  processor_subscriber sub;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    agent = processor_agent::type_id::create("agent", this);
    mon   = processor_monitor::type_id::create("mon",this);
    sb    = processor_scoreboard::type_id::create("sb",this);
    sub   = processor_subscriber::type_id::create("sub",this);
  endfunction

  // connect ports of various TB components here
  function void connect_phase(uvm_phase phase);
    `uvm_info("", "Called env::connect_phase", UVM_NONE);

    // connect driver's analysis port to scoreboard's analysis
    // implementation por
    agent.driver.Drv2Sb_port.connect(sb.Drv2Sb_port);

    // connect monitor's analysis port to scoreboard's analysis
    // implementation port
    mon.Mon2Sb_port.connect(sb.Mon2Sb_port);

    // connect monitor's analysis port to subscriber's analysis
    // implementation port
    mon.aport.connect(sub.aport);
  endfunction: connect_phase
endclass
