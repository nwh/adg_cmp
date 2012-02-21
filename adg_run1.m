%adg_run1  run single problem

function adg_run1
  
  pdat_set = mcute_org2pdat('adg_set.org');

  slv_opt = arcopt_nm_lc.optset();
  
  % io options
  io_opt = solve_pdat();
  io_opt.print_flag = 1;
  
  %keyboard
  
  slv = solve_pdat(pdat_set(1),slv_opt,io_opt)
  
end