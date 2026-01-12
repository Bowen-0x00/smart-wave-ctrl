// =============================================================================
// src/smart_wave_ctrl.sv
// Smart Wave Controller - Optimized for Performance
// Features: Command-line control for waveform depth, scope, and time windows.
// =============================================================================
module smart_wave_ctrl;

  // ------------------------------------------------------
  // 1. Parameter Definitions and Default Values
  // ------------------------------------------------------
  string fsdb_name = "sim_wave.fsdb";
  int dump_depth = 1;  // [Critical] Default depth is 1 (IOs only) to prevent massive files
  string dump_view = "default";  // Default dumping perspective
  longint start_time = 0;
  longint end_time = 0;

  initial begin
    // Enable dumping only if +fsdb_on is provided
    if ($test$plusargs("fsdb_on")) begin

      // ------------------------------------------------------
      // 2. Retrieve Command-Line Arguments
      // ------------------------------------------------------
      // Set FSDB filename
      void'($value$plusargs("fsdb_file=%s", fsdb_name));

      // Set dump depth (Key control for performance and disk space)
      // Usage: +dump_depth=0 (full), +dump_depth=1 (top-level only)
      void'($value$plusargs("dump_depth=%d", dump_depth));

      // Set view/scope selection
      // Usage: +dump_view=cpu or +dump_view=all
      void'($value$plusargs("dump_view=%s", dump_view));

      // Set time window for dumping
      void'($value$plusargs("dump_start=%d", start_time));
      void'($value$plusargs("dump_end=%d", end_time));

      // ------------------------------------------------------
      // 3. Configure FSDB Dumping
      // ------------------------------------------------------
      $fsdbDumpfile(fsdb_name);

      // ------------------------------------------------------
      // 4. View Selector - Robust Scope Control
      // ------------------------------------------------------
      // Defining views in-code is often more maintainable than external files.
      case (dump_view)
        "all": begin
          $display("[Wave-Ctrl] View: ALL (Warning: Large file size expected)");
          $fsdbDumpvars(dump_depth, tb_top);
        end

        "list": begin
          // Supports signal lists from an external file
          // Note: Requires $fsdbDumpvarsByFile support in the environment
          string list_file = "cfg/wave_list.f";
          void'($value$plusargs("dump_list=%s", list_file));
          $display("[Wave-Ctrl] View: Signal List File (%s)", list_file);
          $fsdbDumpvarsByFile(list_file);
        end

        default: begin
          $display("[Wave-Ctrl] View: Default (Top-level scope only)");
          $fsdbDumpvars(1, tb_top);  // Level 1 is safe for most simulations
        end
      endcase

      // ------------------------------------------------------
      // 5. Intelligent Time Control
      // ------------------------------------------------------
      $display("[Wave-Ctrl] Config: File=%s, Depth=%0d, Start=%0t, End=%0t", fsdb_name, dump_depth,
               start_time, end_time);

      fork
        // Thread A: Delayed Start
        begin
          if (start_time > 0) begin
            $fsdbDumpoff;
            #(start_time);
            $fsdbDumpon;
            $display("[Wave-Ctrl] @%0t: Dump STARTED", $time);
          end
        end
        // Thread B: Early Stop
        begin
          if (end_time > 0) begin
            #(end_time);
            $fsdbDumpoff;
            $display("[Wave-Ctrl] @%0t: Dump STOPPED", $time);
          end
        end
      join_none
    end
  end

endmodule
