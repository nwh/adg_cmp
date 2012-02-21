%adg_run_all  run all adg problems

function adg_run_all
  
  % load problem set
  pdat_set = mcute_org2pdat('adg_set.org');

  % solver options
  slv_opt = arcopt_nm_lc.optset();
  slv_opt.print_screen = 0;
  
  % io options
  io_opt = solve_pdat_set();
  io_opt.out_dir = 'runs';
  io_opt.out_iter = 1;
  io_opt.print_flag = 1;
  %io_opt.slvmax = 5;

  % run the tests
  slv_set = solve_pdat_set(pdat_set,slv_opt,io_opt);
  
  % write results
  mcute_struct2org(slv_set,'adg_results.org');

  %keyboard
  
end